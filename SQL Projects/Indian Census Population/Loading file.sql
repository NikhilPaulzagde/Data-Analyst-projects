Create Database projects ;
use Projects;

CREATE TABLE `Data1` (
	`District` VARCHAR(27) NOT NULL, 
	`State` VARCHAR(27) NOT NULL, 
	`Growth` DECIMAL(38, 2) NOT NULL, 
	`Sex_Ratio` DECIMAL(38, 0) NOT NULL, 
	`Literacy` DECIMAL(38, 2) NOT NULL
);

CREATE TABLE `Data2` (
	`District` VARCHAR(28) NOT NULL, 
	`State` VARCHAR(27) NOT NULL, 
	`Area_km2` DECIMAL(38, 0) NOT NULL, 
	`Population` DECIMAL(38, 0) NOT NULL
);



SET SQL_SAFE_UPDATES = 0;


LOAD DATA INFILE 'D:\\Project\\SQL\\Population\\Dataset1.csv'
INTO TABLE Data1
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows
;
LOAD DATA INFILE 'D:\\Project\\SQL\\Population\\Dataset2.csv'
INTO TABLE Data2
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows
(District, State, @Area_km2, Population)
SET
	Area_km2 = replace(@Area_km2,',','')
    ;
    
/*=============================================================================================================================*/
Select * from Data1;

Select * from Data2;