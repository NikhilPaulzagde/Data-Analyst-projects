create DATABASE Codex ;
use Codex;

/* CREATE TABLE*/

CREATE TABLE dim_cities (
	`City_ID` VARCHAR(5) NOT NULL PRIMARY key, 
	`City` VARCHAR(9) NOT NULL, 
	`Tier` VARCHAR(6) NOT NULL
);

CREATE TABLE dim_repondents (
	`Respondent_ID` DECIMAL(38, 0) NOT NULL Primary key, 
	`Name` VARCHAR(23) NOT NULL, 
	`Age` VARCHAR(5) NOT NULL, 
	`Gender` VARCHAR(10) NOT NULL, 
	`City_ID` VARCHAR(5) NOT NULL
    
    
);


CREATE TABLE fact_survey_responses (
	`Response_ID` DECIMAL(38, 0) NOT NULL, 
	`Respondent_ID` DECIMAL(38, 0) NOT NULL, 
	`Consume_frequency` VARCHAR(17) NOT NULL, 
	`Consume_time` VARCHAR(31) NOT NULL, 
	`Consume_reason` VARCHAR(29) NOT NULL, 
	`Heard_before` VARCHAR(8) NOT NULL, 
	`Brand_perception` VARCHAR(8) NOT NULL, 
	`General_perception` VARCHAR(9) NOT NULL, 
	`Tried_before` VARChar(8) NOT NULL, 
	`Taste_experience` DECIMAL(38, 0) NOT NULL, 
	`Reasons_preventing_trying` VARCHAR(31) NOT NULL, 
	`Current_brands` VARCHAR(9) NOT NULL, 
	`Reasons_for_choosing_brands` VARCHAR(23) NOT NULL, 
	`Improvements_desired` VARCHAR(24) NOT NULL, 
	`Ingredients_expected` VARCHAR(8) NOT NULL, 
	`Health_concerns` VARCHAR(8) NOT NULL, 
	`Interest_in_natural_or_organic` VARCHAR(8) NOT NULL, 
	`Marketing_channels` VARCHAR(18) NOT NULL, 
	`Packaging_preference` VARCHAR(25) NOT NULL, 
	`Limited_edition_packaging` VARCHAR(8) NOT NULL, 
	`Price_range` VARCHAR(9) NOT NULL, 
	`Purchase_location` VARCHAR(24) NOT NULL, 
	`Typical_consumption_situations` VARCHAR(22) NOT NULL
);

set sql_mode = "";

/* LOADING DATA INTO TABLES*/

LOAD DATA INFILE "D:/codex/Dataset/dim_cities.csv"
INTO TABLE dim_cities
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows ;


LOAD DATA INFILE "D:/codex/Dataset/dim_repondents.csv"
INTO TABLE dim_repondents
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows ;


LOAD DATA INFILE "D:/codex/Dataset/fact_survey_responses.csv"
INTO TABLE fact_survey_responses
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows ;

/* Adding Foreign key*/

Alter Table dim_repondents
ADD FOREIGN KEY (City_ID) REFERENCES dim_cities(City_ID);

ALTER TABLE fact_survey_responses
ADD FOREIGN KEY (Respondent_ID) REFERENCES dim_repondents(Respondent_ID);

/*Q Who prefers energy drink more? (male/female/non-binary)?*/

Select B.Gender, COUNT(A.Consume_frequency) As Count from 
fact_survey_responses A Inner join dim_repondents B 
on A.Respondent_ID = B.Respondent_ID
Group By B.Gender;

/* Male Prefer to Drink More Energy Drink than Female and Non Binary */ 

-- =======================================================================================================================================-- 

/*Q Which age group prefers energy drinks more?*/

Select A.Age , COUNT(B.Consume_frequency) As Count from 
fact_survey_responses B Inner Join dim_repondents A
on B.Respondent_ID = A.Respondent_ID
Group by A.Age;

-- Age Group of 19-30 prefer energy drink More-- 

-- =======================================================================================================================================-- 

/*Q Which type of marketing reaches the most Youth (15-30)?*/

SELECT A.Marketing_channels, COUNT(A.Marketing_channels) AS Count
FROM fact_survey_responses A
INNER JOIN dim_repondents B ON A.Respondent_ID = B.Respondent_ID
WHERE B.Age = '15-18' OR B.Age = '19-30'
GROUP BY A.Marketing_channels;


-- Online ads and TV commercials marketing reaches Youth More -- 

-- =======================================================================================================================================-- 

/*Q What are the preferred ingredients of energy drinks among respondents?*/

Select Ingredients_expected, Count(Ingredients_expected) as Count
from fact_survey_responses
Group By Ingredients_expected;


-- The preferred ingredients of energy drinks among respondents Are Caffeine and Vitamins -- 

-- =======================================================================================================================================-- 

/*Q What packaging preferences do respondents have for energy drinks? */

Select Packaging_preference, COUNT(Packaging_preference) as Count
from fact_survey_responses 
GROUP BY Packaging_preference;

-- 'Compact and portable cans' and 'Innovative bottle design' packaging is being Preferred By Respondents-- 

-- =======================================================================================================================================-- 

/*Q Who are the current market leaders?*/

Select Current_brands, COUNT(Current_brands) as Count
from fact_survey_responses
Group By Current_brands;

--  ''Cola-Coka', 'Bepsi' and 'Gangster' are the Top Three Current Market Leaders--
 
-- =======================================================================================================================================-- 

/*Q What are the primary reasons consumers prefer those brands over ours?*/

Select Reasons_for_choosing_brands, COUNT(Reasons_for_choosing_brands) as Count
from fact_survey_responses
GROUP BY Reasons_for_choosing_brands;

-- 'Brand reputation', 'Taste/flavor preference', 'Availability' are the Primary reason for the preference-- 

-- =======================================================================================================================================-- 

/*Which marketing channel can be used to reach more customers?*/

Select Marketing_channels, COUNT(Marketing_channels) as Count
from fact_survey_responses 
GROUP BY Marketing_channels;

-- 'Online ads' and 'TV commercials' channels that reaches More -- 

-- =======================================================================================================================================-- 

/* How effective are different marketing strategies and channels in reaching our customers?  */

SELECT Marketing_channels,
       (COUNT(CASE WHEN Heard_before = 'Yes' THEN 1 ELSE NULL END) / COUNT(*)) * 100 AS Percentage
FROM fact_survey_responses
GROUP BY Marketing_channels;

-- All the marketing strategies are effective but Tv commercials are little more effective as compared to others-- 

-- =======================================================================================================================================-- 

/*Q What do people think about our brand? (overall rating)*/

SELECT
    Brand_perception,
    CONCAT(
         Sum(Brand_perception = 'Positive' ),
         SUm(Brand_perception = 'Neutral'), 
         SUm(Brand_perception = 'Negative')
    ) AS Sentiment_Counts
FROM fact_survey_responses
WHERE Current_brands = 'CodeX'
GROUP BY Brand_perception;

-- People  are thinking Positive about our brand-- 

SELECT
    Brand_perception,
    CONCAT(
         Sum(Brand_perception = 'Positive' and (General_perception='Healthy' Or General_perception = 'Effective')),
         SUm(Brand_perception = 'Neutral'and (General_perception='Healthy' Or General_perception = 'Effective')), 
         SUm(Brand_perception = 'Negative'and (General_perception='Healthy' Or General_perception = 'Effective'))
    ) AS Sentiment_Counts
FROM fact_survey_responses
WHERE Current_brands = 'CodeX'
GROUP BY Brand_perception;

/* Out Which only 10000 People Thinks That it is Healthy And Effective */


-- =======================================================================================================================================-- 

/*b. Which cities do we need to focus more on?*/

Select A.City,
SUM(C.Brand_perception='Positive') As Positive, 
Sum(C.Brand_perception='Negative') As Negative,
Sum(C.Brand_perception='Neutral') As Neutral
from dim_cities A 
inner join  dim_repondents B 
on A.City_ID = B.City_ID
inner join fact_survey_responses C 
on B.Respondent_ID = C.Respondent_ID
GROUP BY A.City 
ORDER BY Negative
 ;

-- =======================================================================================================================================-- 

/* Where do respondents prefer to purchase energy drinks? */

SELECT Purchase_location, COUNT(Purchase_location) as Count
from fact_survey_responses
GROUP BY Purchase_location ;

-- People are tend to buy energy drink from Supermarkets , Online retailers and Gyms and fitness centers--

-- =======================================================================================================================================-- 

/*What are the typical consumption situations for energy drinks among respondents?*/

SELECT Typical_consumption_situations , COUNT(Typical_consumption_situations) as Count
from fact_survey_responses
GROUP BY Typical_consumption_situations
ORDER BY Count desc ;

-- Sports/exercise , Studying/working late ,Social outings/parties Are the three Common Situation to Consume Energy Drink--

-- =======================================================================================================================================-- 

/* What factors influence respondents' purchase decisions, such as price range and limited edition packaging? */

SELECT price_range, Limited_edition_packaging, COUNT(*) as count
FROM fact_survey_responses
GROUP BY Limited_edition_packaging
ORDER BY Count desc;

-- Price Range is influencing the respondents  limited edition packing is not that bothered --

-- =======================================================================================================================================-- 

/* Which area of business should we focus more on our product development? (Branding/taste/availability*/

Select Taste_experience ,Count(Brand_perception = 'Negative') as Count
from fact_survey_responses
GROUP BY Taste_experience 
ORDER BY Count DESC;


Select Heard_before ,Count(Brand_perception = 'Negative') as Count
from fact_survey_responses
GROUP BY Heard_before 
ORDER BY Count DESC;


Select Reasons_for_choosing_brands ,Count(Brand_perception = 'Negative') as Count
from fact_survey_responses
GROUP BY Reasons_for_choosing_brands 
ORDER BY Count DESC;

SELECT Heard_before,(COUNT(CASE WHEN Brand_perception = 'Negative' THEN 1 ELSE NULL END) / COUNT(*)) * 100 AS Percentage
FROM fact_survey_responses
GROUP BY Heard_before
ORDER BY Percentage DESC;



-- We should Focus on  Branding , Availability  --
