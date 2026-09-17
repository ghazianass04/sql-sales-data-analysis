-- CHANGE-OVER-TIME (TRENDS)
-- ANALYZE SALES PERFORMANCE OVER TIME 
SELECT YEAR(order_date) order_year,
MONTH(order_date) order_month,
SUM(sales_amount) total_sales,
COUNT(DISTINCT customer_key) total_customers,
SUM(quantity) total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date),MONTH(order_date)
ORDER BY YEAR(order_date),MONTH(order_date)
--CUMULATIVE ANALYSIS
--CALCULATE THE TOTAL SALES PER MONTH AND THE RUNING TOTAL OF SALES OVER TIME 
SELECT order_date,
total_sales,
SUM(total_sales) OVER(ORDER BY order_date ) runing_total_sales,
AVG(avg_price) OVER(ORDER BY order_date ) moving_avg_price
FROM
(
SELECT DATETRUNC(month,order_date) order_date,
SUM(sales_amount) total_sales,
AVG(price) avg_price
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month,order_date)

)t
-- PERFORMANCE ANALYSIS
/* ANALYSE THE YEARLY PERFORMANCE OF PRODUCTS BY COMPARING EACH PRODUCT'S SALES TO BOTH 
ITS AVERAGE SALES PERFORMANCE AND THE PREVIOUS YEAR'S SALES */
WITH yearly_products_sales AS(
SELECT 
YEAR(s.order_date) order_year,
p.product_name,
SUM(s.sales_amount) current_sales
FROM  gold.fact_sales s LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
WHERE order_date IS NOT NULL
GROUP BY YEAR(s.order_date) , p.product_name
)
SELECT
order_year,
product_name,
current_sales,
AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
current_sales - (AVG (current_sales) OVER(PARTITION BY product_name)) avg_diff,
CASE WHEN current_sales - (AVG (current_sales) OVER(PARTITION BY product_name)) > 0 THEN 'incease'
     WHEN current_sales - (AVG (current_sales) OVER(PARTITION BY product_name)) < 0 THEN 'decrease'
ELSE 'no change'
END avg_change,
LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) previousyear,
current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) diff_with_previousyear
FROM yearly_products_sales
ORDER BY product_name, order_year
-- PROPORTIONAL ANALYSIS
-- WHICH CATEGORIES CONTRIBUTE THE MOST TO OVERALL SALES
WITH category_sales AS(
SELECT
p.category,
SUM(s.sales_amount) total_sales
FROM gold.fact_sales s LEFT JOIN gold.dim_products p ON s.product_key = p.product_key
GROUP BY  p.category 
)
SELECT
category,
total_sales,
SUM(total_sales) OVER()  overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) *100 , 2), '%')overall_contr
FROM category_sales
ORDER BY overall_contr DESC
-- DATA SEGMENTATION
-- SEGMENT PRODUCTS INTO COST RANGES AND COUNT HOW MANY PRODUCTS FALL INTO EACH SEGMENT
WITH products_segment AS (
SELECT
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'below 100'
     WHEN cost BETWEEN 100 AND 500 THEN '100-500'
     WHEN cost BETWEEN 500 AND 1000 THEN '500-1000'
     ELSE 'above 1000'
END cost_range
FROM gold.dim_products
)
SELECT
cost_range,
COUNT(product_key) total_products
FROM products_segment
GROUP BY cost_range
ORDER BY total_products DESC
/* GROUP CUSTOMERS INTO THREE SEGMENTS BASED ON THEIR SPENDING BEHAVIOR :
  - VIP : AT LEAST 12 MONTHS OF HISTORY AND SPENDING MORE THAN 5000 EURO.
  - REGULAR : AT LEATS 12 MONTHS OF HISTORY BUT SPENDING 5000 EURO OR LESS.
  - NEW : LISFESPAN LESS THAN 12 MONTHS 
AND FIND THE TOTAL NUMBER OF CUSTOMERS BY EACH GROUP
*/
WITH customer_spending AS(
SELECT
c.customer_key,
SUM (s.sales_amount) total_spending,
MIN(order_date) fist_order,
MAX(order_date) last_order,
DATEDIFF(month,MIN(order_date),MAX(order_date)) lifespan
FROM gold.fact_sales s  LEFT JOIN  gold.dim_customers c ON c.customer_key = s.customer_key
GROUP BY c.customer_key
)
SELECT
customer_segment,
COUNT(customer_key) total_customers
FROM(
SELECT customer_key,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
     WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'REGULAR'
ELSE 'NEW' 
END customer_segment 
FROM customer_spending)t
GROUP BY customer_segment
ORDER BY total_customers DESC

/* 
------------------------------------------------------------------------------------------
CUSTOMER REPORT
------------------------------------------------------------------------------------------
PURPOSE:
 -THIS REPORT CONSOLIDATES KEY CUSTOMER METRICS AND BEHAVIORS
 HIGHLIGHTS :
  1. GATHERS ESSENTIAL FIELDS SUCH AS NAME, AGES, AND TRANSACTIONS DETAILS.
  2. SEGMENTS CUSTOMERS INTO CATEGORIES(VIP, REGULAR, NEW) AND AGE GROUPS.
  3. AGGREGATES CUSTOMER LEVEL METRICS :
     - TOTAL ORDERS
     - TOTAL SALES
     - TOTAL QUANTITY PURCHASED
     - TOTAL PRODUCTS
     - LIFESPAN (IN MONTHS)
  4. CALCULATES VALUABLE KPIS :
     - RECENCY (MONTHS SINCE LAST ORDER)
     - AVERAGE ORDER VALUE
     - AVERAGE MONTHLY SPEND
------------------------------------------------------------------------------------------
*/
CREATE VIEW gold.report_customers AS
WITH base_query AS (
-- 1. BASE QUERY: RETRIEVES CORE COLUMNS FROM TABLES
SELECT
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(c.first_name, ' ' ,c.last_name) customer_name,
DATEDIFF(year,c.birthdate,GETDATE()) age
FROM gold.fact_sales s LEFT JOIN gold.dim_customers c ON s.customer_key = c.customer_key
WHERE s.order_date IS NOT NULL
)
,custumor_aggregation AS ( 
  --2. SEGMENTS CUSTOMERS INTO CATEGORIES(VIP, REGULAR, NEW) AND AGE GROUPS.

SELECT
customer_key,
customer_number,
customer_name,
age,
COUNT(DISTINCT order_number) total_order,
SUM(sales_amount) total_sales,
SUM(quantity) total_quantity,
COUNT(DISTINCT product_key) total_products,
MAX(order_date) last_order_date,
DATEDIFF(month,MIN(order_date), MAX(order_date)) lifespan
FROM base_query
GROUP BY customer_key,
         customer_number,
         customer_name,
         age )
SELECT
--3.
         customer_key,
         customer_number,
         customer_name,
         age,
         CASE WHEN age < 20 THEN 'under 20'
              WHEN age BETWEEN 20 AND 29 THEN '20-29'
              WHEN age BETWEEN 30 AND 39 THEN '30-39'
              WHEN age BETWEEN 40 AND 49 THEN '40-49'
              ELSE '50 and above'
         END age_group,
         CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
              WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'REGULAR'
              ELSE 'NEW' 
        END customer_segment,
         last_order_date,
          -- RECENCY (MONTHS SINCE LAST ORDER)
         DATEDIFF(MONTH,last_order_date,GETDATE()) recency,
         total_sales,
         total_order,
         -- AVERAGE ORDER VALUE
         CASE WHEN total_order = 0 THEN 0
               ELSE total_sales / total_order 
         END AS avg_order_value,
         -- AVERAGE MONTHLY SPEND
         CASE WHEN lifespan = 0 THEN total_sales
               ELSE total_sales / lifespan 
         END AS avg_monthly_spend,
         total_quantity,
         total_products,
         lifespan
FROM custumor_aggregation

