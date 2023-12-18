-- 1. What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS count
FROM hr
WHERE age >= 18 and termdate=''
GROUP BY gender;

-- 2. What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS count
FROM hr
WHERE age >= 18 and termdate=''
GROUP BY race
order by race ;

-- 3. What is the age distribution of employees in the company?
Select 
	case
    when age>=18 and age <=24 then '18-24'
	when age>=25 and age <=34 then '25-34'
	when age>=35 and age <=44 then '35-44'
	when age>=45 and age <=54 then '45-54'
	when age>=55 and age <=64 then '55-64'
    else '65+'
end as age_group , count(*) as count
from hr
WHERE age >= 18 and termdate=''
GROUP BY age_group
order by age_group;

-- 4. How many employees work at headquarters versus remote locations?
Select location , count(*) as count
from hr
WHERE age >= 18 and termdate=''
GROUP BY location;

-- 5. What is the average length of employment for employees who have been terminated?
Select avg(datediff(termdate,hire_date))/365 as avg_length_employment
from hr
where termdate <=curdate() and termdate<>'' and age>=18;

-- 6. How does the gender distribution vary across departments and job titles?
Select Department , gender , count(*) as count
from hr
where age>18 and termdate=''
group by department,gender
order by department;

-- 7. What is the distribution of job titles across the company?
Select jobtitle ,  count(*) as count
from hr
where age>18 and termdate=''
group by jobtitle
order by jobtitle Desc;

-- 8. Which department has the highest turnover rate?
Select department,
totalcount,
terminatedcount,
terminatedcount/totalcount as terminatedrate
from(Select department,
    count(*) as totalcount,
    Sum(case when termdate!=''  and termdate != curdate() then 1 else 0 End) 
    from hr
    where age>18
    Group by department) as terminatedcount
order by terminationrate;

-- 9. What is the distribution of employees across locations by city and state?
Select location_state , count(*) as count from hr
where age>18 and termdate=''
group by location_state;


Select year,hires,termination,hires-terminations as net_change,
round((hires-terminations)/hires*100,2) as net_change_percentage
from (select year(hire_date)AS year,
	count(*) as hires,
    Sum(case when termdate!=''  and termdate != curdate() then 1 else 0 End) as terminations
    from hr 
    where age >18
    group by year(hire_date)
    ) as subquery
order by year ;


Select department , round(avg(datediff(termdate,hire_date)/365),0) as avg_tenure
from hr
where  age>18
Group by department