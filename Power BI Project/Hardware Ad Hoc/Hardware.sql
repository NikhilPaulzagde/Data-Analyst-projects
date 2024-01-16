Use Atliqhardware;



/*Provide the list of markets in which customer Atliq Exclusive operates its business in the APAC region*/

SELECT 
    market, COUNT(customer) AS `No. of Customer`
FROM
    dim_customer
WHERE
    region = 'APAC'
GROUP BY market
ORDER BY `No. of Customer` DESC
;

/*What is the percentage of unique product increase in 2021 vs. 2020? The final output contains these fields,*/

WITH ProductCounts AS (
    SELECT
        fiscal_year,
        COUNT(DISTINCT product_code) AS unique_products
    FROM fact_sales_monthly
    WHERE fiscal_year IN (2020, 2021)
    GROUP BY fiscal_year
)
SELECT 
p1.unique_products AS unique_products_2020,
p2.unique_products AS unique_products_2021,
(p2.unique_products - p1.unique_products) /(p1.unique_products ) * 100 AS percentage_increase
FROM ProductCounts p1
JOIN ProductCounts p2 ON p1.fiscal_year = 2020 AND p2.fiscal_year = 2021;

-- Product increased to 36.32 % in 2021--

SELECT 
    segment, COUNT(DISTINCT (product)) AS product_count
FROM
    dim_product
GROUP BY segment
ORDER BY product_count DESC;

-- Accessories and peripherals products Segments are more than other segments followed by Notebook --

/* Which segment had the most increase in unique products in 2021 vs 2020?*/

With Segmentcount as (
Select a.segment,
COUNT(DISTINCT CASE WHEN b.fiscal_year = 2020 Then a.product END) as Unique_product_2020,
COUNT(DISTINCT CASE WHEN b.fiscal_year = 2021 Then a.product END) as Unique_product_2021
from dim_product a
Inner Join fact_sales_monthly b on a.product_code = b.product_code
where b.fiscal_year in(2020,2021)
Group By a.segment
)
Select
spc.segment,
spc.Unique_product_2020,
spc.Unique_product_2021,
spc.Unique_product_2021 - spc.Unique_product_2020 as difference
From Segmentcount spc
ORDER BY difference DESC;


/* 5. Get the products that have the highest and lowest manufacturing costs.*/

SELECT 
    a.product_code, a.product, b.manufacturing_cost
FROM
    dim_product a
        INNER JOIN
    fact_manufacturing_cost b ON a.product_code = b.product_code
WHERE
    b.manufacturing_cost = (SELECT 
            MAX(manufacturing_cost)
        FROM
            fact_manufacturing_cost)
        OR b.manufacturing_cost = (SELECT 
            MIN(manufacturing_cost)
        FROM
            fact_manufacturing_cost)
;


/* Generate a report which contains the top 5 customers who received an average high pre_invoice_discount_pct for the fiscal year 2021 and in the 
Indian market. */

SELECT 
    a.customer_code,
    a.customer,
    b.pre_invoice_discount_pct AS Average_discount_pct
FROM
    dim_customer a
        INNER JOIN
    fact_pre_invoice_deductions b ON a.customer_code = b.customer_code
WHERE
    a.market = 'India'
        AND b.fiscal_year = '2021'
ORDER BY b.pre_invoice_discount_pct DESC
LIMIT 5;





/*. Get the complete report of the Gross sales amount for the customer “Atliq Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.*/

SELECT 
    EXTRACT(YEAR FROM b.`date`) AS `Year`,
    EXTRACT(MONTH FROM b.`date`) AS `Month`,
    ROUND(SUM(c.gross_price * b.sold_quantity) / 1000000,
            2) AS Sales
FROM
    dim_customer a
        INNER JOIN
    fact_sales_monthly b ON a.customer_code = b.customer_code
        INNER JOIN
    fact_gross_price c ON b.product_code = c.product_code
WHERE
    a.customer = 'Atliq Exclusive'
GROUP BY `Year` , `MOnth`
ORDER BY `year` , `Month`;


/*n which quarter of 2020, got the maximum total_sold_quantity? The final output contains these fields sorted by the total_sold_quantity*/

Select Concat('Q', Quarter(`date`)) as quater, sum(sold_quantity) as Total_Sold_Quantity from fact_sales_monthly 
Where extract(Year from `date`) = 2020
GROUP BY Quater
ORDER BY quater DeSC
LIMIT 1;

/*Which channel helped to bring more gross sales in the fiscal year 2021 and the percentage of contribution? */



With ChannelGrossSales AS (Select a.`channel`, 
Round(sum(c.gross_price * b.sold_quantity)/1000000,2)as Gross_sales
from dim_customer a
INNER JOIN fact_sales_monthly b on
a.customer_code = b.customer_code
INNER JOIN fact_gross_price c on
b.product_code = c.product_code
Where b.fiscal_year=2021
GROUP BY a.`channel`
)
SeleCT cgs.`Channel`,
cgs.Gross_sales,
Round(cgs.Gross_sales/Sum(cgs.Gross_sales) Over() *100 , 2) as percentage
from ChannelGrossSales cgs
ORDER BY cgs.Gross_sales DESC;


/*Get the Top 3 products in each division that have a high total_sold_quantity in the fiscal_year 2021?*/

WITH Temp_table AS (
    SELECT
        a.division,
        b.product_code,
        CONCAT(a.product, '(', a.variant, ')') AS product,
        SUM(b.sold_quantity) AS total_sold_quantity,
        RANK() OVER (PARTITION BY a.division ORDER BY SUM(b.sold_quantity) DESC) AS rank_order
    FROM dim_product a
    JOIN fact_sales_monthly b ON a.product_code = b.product_code
    WHERE b.fiscal_year = '2021'
    GROUP BY a.division,b.product_code,CONCAT(a.product, '(', a.variant, ')')
)
SELECT
    tt.division,
    tt.product_code,
    tt.product,
    tt.total_sold_quantity,
    tt.rank_order
FROM Temp_table tt
Where tt.rank_order in (1,2,3)
GROUP BY tt.division,tt.product_code,tt.product
ORDER BY tt.division, tt.rank_order;
