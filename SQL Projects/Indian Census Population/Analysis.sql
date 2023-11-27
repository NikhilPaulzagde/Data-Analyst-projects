SELECT * FROM projects.data1;

SELECT * FROM projects.data2;


-- number of rows into our dataset 

SELECT count(*) from data1;
SELECT count(*) from data2;

-- =========================================================================================================================

-- Calculate the Dataset for Jharkhand and Bihar

SELECT * from data1 WHERE State IN ('Jharkhand', 'Bihar') ;

-- ========================================================================================================================

-- Total Population of India 

SELECT sum(Population) As `Total Population`
 from Data2; 

-- ========================================================================================================================

-- Average Growth 

-- India's Avg Growth
SELECT avg(Growth)*100 AS `Average Growth` from Data1;


-- State wise Avg Growth
SELECT state, avg(Growth)*100 AS `Average Growth`
FROM data1
GROUP BY State 
ORDER BY `Average Growth` DESC ;
-- =========================================================================================================================

-- Averge Sex Ratio 

SELECT state, round(avg(sex_ratio),0) `Average Sex Ratio`
From data1
GROUP BY State 
ORDER BY `Average Sex Ratio` DESC;

-- =========================================================================================================================

-- Average Literacy Rate
SELECT state, round(avg(literacy),0) `Average Literacy Rate`
From data1
GROUP BY State 
HAVING `Average Literacy Rate`>90
ORDER BY `Average Literacy Rate` DESC;
-- ===========================================================================================================================

-- Top 3 Sate Showing  Avg Growth ratio

SELECT state, round(avg(Growth),2)*100 AS `Average Growth`
FROM data1
GROUP BY State 
ORDER BY `Average Growth` DESC 
limit 3;

-- Bottom 3 Sate Showing  Avg  Growth ratio
SELECT state, round(avg(Growth),2)*100 AS `Average Growth`
FROM data1
GROUP BY State 
ORDER BY `Average Growth` ASC 
limit 3;

-- ================================================================================================================================

-- Top 3 Sate Showing  Avg Sex ratio
SELECT state, round(avg(sex_ratio),0) `Average Sex Ratio`
From data1
GROUP BY State 
ORDER BY `Average Sex Ratio` DESC
limit 3;

--  Bottom 3 Sate Showing  Avg  Sex ratio
SELECT state, round(avg(sex_ratio),0) `Average Sex Ratio`
From data1
GROUP BY State 
ORDER BY `Average Sex Ratio` ASC
limit 3;
-- ==================================================================================================================================

-- Top 3 Sate Showing  Avg Litercy Rate
SELECT state, round(avg(literacy),0) `Average Litercy Rate`
From data1
GROUP BY State 
ORDER BY `Average Litercy Rate` DESC
limit 3;

--  Bottom 3 Sate Showing  Avg  Litercy Rate
SELECT state, round(avg(literacy),0) `Average Litercy Rate`
From data1
GROUP BY State 
ORDER BY `Average Litercy Rate` ASC
limit 3;

-- =====================================================================================================================================

-- Population of all the District in Maharashtra starting with Letter a
Select * from  Data2 WHERE state = 'Maharashtra' and District like 'A%';

--  Total Population of Maharashtra

SELECT sum(Population) as `Total Population` 
from  Data2 WHERE state = 'Maharashtra';

-- =====================================================================================================================================

-- Total Number of Male and Female in Each State
SELECT d.state, sum(d.males) `Total males`, sum(d.female) `Total Female` from
(SELECT c.District, c.State,c.Population,round(c.population/(c.Sex_Ratio+1),0) `males`,round((c.population*c.sex_ratio)/(c.sex_ratio+1 ),0) `female`
FROM
(SELECT a.District, a.state, a.Sex_ratio/1000 as Sex_ratio, b.population from data1 a
INNER JOIN data2 b on a.District = b.District) c) d
GROUP BY d.state;

-- =======================================================================================================================================

-- Total Number literate and Illeterate People
SELECT d.State, Sum(d.Literate_people) Literate_Population, sum(d.Illiterate_people) Illiterate_Population From
(SELECT c.District, c.state, round((c.literacy_ratio*c.population),0) Literate_people, round((1-c.literacy_ratio)*c.population, 0) Illiterate_People
From
(SELECT a.District, a.State, a.Literacy/100 literacy_ratio , b.Population from Data1 a
INNER JOIN data2 b on a.district =  b.district) c) d
GROUP BY d.state;

-- =======================================================================================================================================
-- Population of Previous Census
Select d.State, sum(d.Previous_Census_Population)`  Previous Census Population`, sum(d.Population) `Current Census Population ` From
(SELECT c.District, c.State, round(c.population/(1+c.growth),0) Previous_Census_Population , c.Population From
(SELECT a.District, a.State, a.growth  , b.Population from Data1 a
INNER JOIN data2 b on a.district =  b.district) c ) d
GROUP BY d.State ;

-- =======================================================================================================================================

-- Area vs Population
Select g.total_area/`Previous Census Population` `Previous Census Population Vs Area`, g.total_area/ `Current Census Population` `Current Census Population VS Area`
From
(SELECT q.*, r.total_area from (

SELECT '1' as keyy, n.* from
(SELECT  sum(m.`Previous Census Population`) `Previous Census Population`, sum(m.`Current Census Population `) `Current Census Population` from
(Select d.State, sum(d.Previous_Census_Population)`Previous Census Population`, sum(d.Population) `Current Census Population ` From
(SELECT c.District, c.State, round(c.population/(1+c.growth),0) Previous_Census_Population , c.Population From
(SELECT a.District, a.State, a.growth  , b.Population from Data1 a
INNER JOIN data2 b on a.district =  b.district) c ) d
GROUP BY d.State ) m) n) q inner Join(

Select '1' as keyy, z.* from
(Select sum(area_km2) total_area from data2) z) r on q.keyy = r.keyy) g;

-- ============================================================================================================================================

-- Top 3 District of Each State Literacy rate

Select a.* from
(SELECT District, State , Literacy, rank() 
over(PARTITION BY State ORDER BY Literacy Desc) `rank`
From Data1) a
Where a.`rank` in (1,2,3)
ORDER BY State
