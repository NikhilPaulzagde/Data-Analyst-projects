CREATE TABLE employee (
	employee_id DECIMAL(38, 0) NOT NULL, 
	last_name VARCHAR(8) NOT NULL, 
	first_name VARCHAR(8) NOT NULL, 
	title VARCHAR(22) NOT NULL, 
	reports_to DECIMAL(38, 0), 
	levels VARCHAR(2) NOT NULL, 
	birthdate VARCHAR(16) NOT NULL, 
	hire_date VARCHAR(16) NOT NULL, 
	address VARCHAR(27) NOT NULL, 
	city VARCHAR(10) NOT NULL, 
	state VARCHAR(2) NOT NULL, 
	country VARCHAR(6) NOT NULL, 
	postal_code VARCHAR(7) NOT NULL, 
	phone VARCHAR(17) NOT NULL, 
	fax VARCHAR(17) NOT NULL, 
	email VARCHAR(27) NOT NULL
);
