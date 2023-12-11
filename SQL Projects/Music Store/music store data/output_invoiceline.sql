CREATE TABLE invoice_line (
	invoice_line_id DECIMAL(38, 0) NOT NULL, 
	invoice_id DECIMAL(38, 0) NOT NULL, 
	track_id DECIMAL(38, 0) NOT NULL, 
	unit_price DECIMAL(38, 2) NOT NULL, 
	quantity BOOL NOT NULL
);
