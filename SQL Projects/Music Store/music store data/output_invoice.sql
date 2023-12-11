CREATE TABLE invoice (
	invoice_id DECIMAL(38, 0) NOT NULL, 
	customer_id DECIMAL(38, 0) NOT NULL, 
	invoice_date TIMESTAMP NULL, 
	billing_address VARCHAR(40) NOT NULL, 
	billing_city VARCHAR(19) NOT NULL, 
	billing_state VARCHAR(6), 
	billing_country VARCHAR(14) NOT NULL, 
	billing_postal_code VARCHAR(10), 
	total DECIMAL(38, 16) NOT NULL
);
