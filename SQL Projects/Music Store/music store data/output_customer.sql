CREATE TABLE customer (
	customer_id DECIMAL(38, 0) NOT NULL, 
	first_name VARCHAR(9) NOT NULL, 
	last_name VARCHAR(12) NOT NULL, 
	company VARCHAR(48), 
	address VARCHAR(40) NOT NULL, 
	city VARCHAR(19) NOT NULL, 
	state VARCHAR(6), 
	country VARCHAR(14) NOT NULL, 
	postal_code VARCHAR(10), 
	phone VARCHAR(19), 
	fax VARCHAR(18), 
	email VARCHAR(29) NOT NULL, 
	support_rep_id DECIMAL(38, 0) NOT NULL
);
