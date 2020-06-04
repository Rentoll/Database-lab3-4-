import psycopg2
from Table import Table 
from TableAddition import TableWithAddition


class UserDB:
    def __init__(self, username: str, password: str, database: str = 'postgres'):
        self.username = username
        self.__password__ = password
        self.database = database

    @property
    def password(self):
        return self.__password__


class Database:
    def __init__(self):
        self.data = None
        self.conn = None
        self.cursor = None

        self.postgres_user = None
        self.my_user = None

        self.tables = []
        self.create_tables()
        self.is_exists = False

    def create_postgres_user(self, username: str, password: str):
        self.postgres_user = UserDB(username, password)

    def connect_to_database(self, username: str, password: str, dbname: str = 'postgres') -> bool:
        try:
            self.conn = psycopg2.connect(dbname=dbname, user=username, password=password, host='localhost')
            self.cursor = self.conn.cursor()
            return True
        except psycopg2.OperationalError as e:
            print(e)
            return False

    def create_user(self):
        try:
            self.my_user = UserDB('my_user', 'my_password', 'orders_db')
            self.cursor.execute("CREATE USER {} WITH PASSWORD '{}'".format(self.my_user.username, self.my_user.password))
        except psycopg2.errors.DuplicateObject as e:
            print(e)
        self.conn.commit()

    def change_connection(self, username, password, dbname: str = 'postgres') -> bool:
        self.close_all()
        if not self.connect_to_database(username, password, dbname):
            return False
        return True

    def upload_function_create_database_to_postgres(self):
        self.change_connection(self.postgres_user.username, self.postgres_user.password)
        self.load_sql_function_from_file(".\\CREATE_DROP_database.sql")
        self.conn.commit()

    def load_sql_function_from_file(self, filename: str):
        with open(filename, 'r') as file:
            self.cursor.execute(file.read())
        self.conn.commit()

    def create_database(self) -> bool:
        try:
            self.change_connection(self.postgres_user.username, self.postgres_user.password)
            self.create_user()
            self.cursor.execute("SELECT create_database('{}', '{}')".format(self.postgres_user.username,
                                                                            self.postgres_user.password))
            self.conn.commit()

            self.change_connection(self.my_user.username, self.my_user.password, 'orders_db')
            self.create_tables_in_db()

            self.load_sql_function_from_file(".\\functions.sql")
            self.load_sql_function_from_file(".\\triggers.sql")
            self.conn.commit()
        except psycopg2.errors.RaiseException as e:
            self.change_connection(self.my_user.username, self.my_user.password, 'orders_db')
            print(e)
            self.conn.commit()
            return False

        return True

    def create_tables_in_db(self):
        self.change_connection(self.my_user.username, self.my_user.password, self.my_user.database)
        self.load_sql_function_from_file(".\\CREATE_script.sql")
        self.cursor.execute("SELECT create_tables()")
        self.conn.commit()

    def create_tables(self):
        self.tables = [TableWithAddition('consumers', ['id', 'name', 'address'], self), TableWithAddition('distributor', ['id', 'companyName', 'address'], self), Table('cars', ['id', 'name', 'price'],  self), Table('orders', ['id', 'consumer_id', 'distributor_id', 'car_id', 'number_of_cars', 'total', 'date'], self)]

    def drop_database(self) -> bool:
        try:
            self.change_connection(self.postgres_user.username, self.postgres_user.password)

            self.cursor.execute("SELECT drop_database('{}', '{}')".format(self.postgres_user.username, self.postgres_user.password))
            self.cursor.execute("DROP USER IF EXISTS {}".format(self.my_user.username))
            self.conn.commit()
        except psycopg2.errors.RaiseException as e:
            print(e)
            self.conn.commit()
            return False
        return True

    def truncate_all_tables(self) -> bool:
        if not self.change_connection(self.my_user.username, self.my_user.password, self.my_user.database):
            return False
        self.cursor.execute("SELECT clear_all_tables()")
        self.conn.commit()
        return True

    def close_all(self):
        if self.cursor and self.conn:
            self.cursor.close()
            self.conn.close()

    def init_connection(self, username: str, password: str) -> bool:
        self.create_postgres_user(username, password)
        if not self.connect_to_database(self.postgres_user.username, self.postgres_user.password):
            return False

        self.create_user()
        self.upload_function_create_database_to_postgres()

        self.cursor.execute("SELECT 1 FROM pg_database WHERE datname = 'orders_db'")
        self.is_exists = True if self.cursor.fetchall() else False
        if self.is_exists:
            self.change_connection(self.my_user.username, self.my_user.password, 'orders_db')
        return True
