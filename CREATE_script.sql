------------------------CREATE TABLES-----------------------
--if not exists
CREATE OR REPLACE FUNCTION create_tables() RETURNS VOID AS $$
BEGIN
		CREATE TABLE consumers
	(
		id SERIAL PRIMARY KEY,
		name VARCHAR(30) NOT NULL,
		address TEXT NOT NULL
	);

	CREATE TABLE distributor
	(
		id SERIAL PRIMARY KEY,
		companyName VARCHAR(30) NOT NULL,
		address TEXT NOT NULL
	);

	CREATE TABLE cars(
		id SERIAL PRIMARY KEY,
		name VARCHAR(30) NOT NULL,
		price INTEGER NOT NULL CHECK(price >= 0)
	);

	CREATE TABLE orders(
		id SERIAL PRIMARY KEY,
		consumer_id INTEGER NOT NULL 
		REFERENCES consumers (id) ON DELETE CASCADE ON UPDATE CASCADE,
		distributor_id INTEGER NOT NULL 
		REFERENCES distributor (id) ON DELETE CASCADE ON UPDATE CASCADE,
		car_id INTEGER NOT NULL 
		REFERENCES cars (id) ON DELETE CASCADE ON UPDATE CASCADE,
		number_of_cars INTEGER NOT NULL,
		total BIGINT,
	    date timestamp DEFAULT date_trunc('second', now())
	);
	CREATE INDEX ON consumers(address);
	CREATE INDEX ON distributor(address);
END;
$$ LANGUAGE plpgsql;
--------------------------------------------------------