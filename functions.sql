----------------------------SELECTS---------------------------------
---------------------------consumers--------------------------------
CREATE OR REPLACE FUNCTION get_consumers() RETURNS SETOF consumers AS $$
BEGIN
	RETURN QUERY SELECT * FROM consumers;
END;
$$ LANGUAGE plpgsql;
---------------------------distributor--------------------------------

CREATE OR REPLACE FUNCTION get_distributor() RETURNS SETOF distributor AS $$
BEGIN
	RETURN QUERY SELECT * FROM distributor;
END;
$$ LANGUAGE plpgsql;
-----------------------------cars--------------------------------

CREATE OR REPLACE FUNCTION get_cars() RETURNS SETOF cars AS $$
BEGIN
	RETURN QUERY SELECT * FROM cars;
END;
$$ LANGUAGE plpgsql;

-----------------------------orders--------------------------------

CREATE OR REPLACE FUNCTION get_orders() RETURNS SETOF orders AS $$
BEGIN
	RETURN QUERY SELECT * FROM orders;
END;
$$ LANGUAGE plpgsql;
-----------------------get record by id--------------------------------
CREATE OR REPLACE FUNCTION get_record_by_id(table_name TEXT, record_id integer) RETURNS record AS $$
DECLARE
r_Return record;
BEGIN
EXECUTE 'SELECT * FROM '|| $1 ||' WHERE id = ' || $2 INTO r_Return;

RETURN r_Return;
END;
$$ LANGUAGE plpgsql;
-----------------------DELETE FROM TABLES------------------------------

CREATE OR REPLACE FUNCTION clear_table(table_name TEXT) RETURNS VOID AS $$
BEGIN
	EXECUTE 'TRUNCATE '|| $1 || ' CASCADE';
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION clear_all_tables() RETURNS VOID AS $$
BEGIN
	TRUNCATE consumers, distributor, cars, orders;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-------------------INSERT NEW RECORDS-------------------------------

CREATE OR REPLACE FUNCTION insert_into_consumers(VARCHAR(30), TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO consumers(name, address) VALUES ($1, $2);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_distributor(VARCHAR(30), TEXT) RETURNS VOID AS $$
BEGIN
	INSERT INTO distributor(companyName, address) VALUES($1, $2);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_cars(VARCHAR(30), INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO cars(name, price) VALUES($1, $2);
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION insert_into_orders(INTEGER, INTEGER, INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	INSERT INTO orders(consumer_id, distributor_id, car_id, number_of_cars) VALUES($1, $2, $3, $4);
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-------------------SEARCH RECORDS BY TEXT FIELD---------------------

CREATE OR REPLACE FUNCTION search_consumers_by_address(TEXT) RETURNS SETOF consumers AS $$
BEGIN
	RETURN QUERY SELECT * FROM consumers WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION search_distributor_by_address(TEXT) RETURNS SETOF distributor AS $$
BEGIN
	RETURN QUERY SELECT * FROM distributor WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------
-----------------------UPDATE RECORDS-------------------------------

CREATE OR REPLACE FUNCTION update_consumers(record_id INTEGER, VARCHAR(30), TEXT) RETURNS VOID AS $$
BEGIN
	UPDATE consumers
	SET name = $2, address = $3
	WHERE id = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_distributor(record_id INTEGER, VARCHAR(30), TEXT) RETURNS VOID AS $$
BEGIN
	UPDATE distributor
	SET companyName = $2, address = $3
	WHERE id = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_cars(record_id INTEGER, VARCHAR(30), INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE cars
	SET name = $2, price = $3
	WHERE id = record_id;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION update_orders(record_id INTEGER, INTEGER, INTEGER, INTEGER) RETURNS VOID AS $$
BEGIN
	UPDATE orders
	SET consumer_id = $2, distributor_id = $3, car_id = $4
	WHERE id = record_id;
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------
-----------------------DELETE BY TEXT FIELD-------------------------------

CREATE OR REPLACE FUNCTION delete_from_consumers_by_address(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM consumers WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION delete_from_distributor_by_address(TEXT) RETURNS VOID AS $$
BEGIN
	DELETE FROM distributor WHERE address LIKE '%'||$1||'%';
END
$$ LANGUAGE plpgsql;
--------------------------------------------------------------------------
-----------------------DELETE RECORD FROM TABLE---------------------------

CREATE OR REPLACE FUNCTION delete_record_from_table(record_id INTEGER, table_name TEXT) RETURNS VOID AS $$
BEGIN
	EXECUTE 'DELETE FROM '||table_name||' WHERE id = '|| record_id;
END;
$$ LANGUAGE plpgsql;
