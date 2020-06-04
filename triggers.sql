-----------------------TRIGGERS-------------------------
--triggers for update orders.total
--update details.price
CREATE OR REPLACE FUNCTION update_total_by_detail_price()
RETURNS TRIGGER AS $$
BEGIN
	UPDATE orders
	SET total = orders.number_of_cars * NEW.price
	WHERE orders.car_id = NEW.id;
	RETURN NULL;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS t_total ON cars;

CREATE TRIGGER t_total 
AFTER UPDATE OF price ON cars
FOR EACH ROW
EXECUTE PROCEDURE update_total_by_detail_price();

--update orders.number_of_cars and insert into orders
CREATE OR REPLACE FUNCTION update_total_by_number_of_details()
RETURNS TRIGGER AS $$
BEGIN
	IF TG_OP = 'UPDATE' OR TG_OP = 'INSERT' THEN
		NEW.total = NEW.number_of_cars * (SELECT price FROM cars WHERE id = NEW.car_id);
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS t_total ON orders;

CREATE TRIGGER t_total 
BEFORE UPDATE OF number_of_cars ON orders
FOR EACH ROW
EXECUTE PROCEDURE update_total_by_number_of_details();

--insert into orders-------------------------------
DROP TRIGGER IF EXISTS t_insert_orders ON orders;

CREATE TRIGGER t_insert_orders
BEFORE INSERT ON orders
FOR EACH ROW
EXECUTE PROCEDURE update_total_by_number_of_details();
------------------------------------------------
