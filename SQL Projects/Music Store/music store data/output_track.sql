CREATE TABLE track (
	track_id DECIMAL(38, 0) NOT NULL, 
	name VARCHAR(123) NOT NULL, 
	album_id DECIMAL(38, 0) NOT NULL, 
	media_type_id DECIMAL(38, 0) NOT NULL, 
	genre_id DECIMAL(38, 0) NOT NULL, 
	composer VARCHAR(188), 
	milliseconds DECIMAL(38, 0) NOT NULL, 
	bytes DECIMAL(38, 0) NOT NULL, 
	unit_price DECIMAL(38, 2) NOT NULL
);
