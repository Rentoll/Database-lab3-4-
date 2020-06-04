from Table import Table
class TableWithAddition(Table):
    def __init__(self, name, columns: list, cursor):
        super().__init__(name, columns, cursor)

    def search_by_address(self, address: str):
        self.database.cursor.execute("SELECT * FROM search_{}_by_address('{}')".format(self.name, address))
        result = self.database.cursor.fetchall()
        return result

    def delete_by_address(self, address: str):
        self.database.cursor.execute("SELECT delete_from_{}_by_address('{}')".format(self.name, address))
        self.database.conn.commit()
        return self.get_records()