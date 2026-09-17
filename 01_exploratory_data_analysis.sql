-- FIND THE TOTAL SALES 
SELECT SUM(sales_amount) total_sales
FROM gold.fact_sales
-- FIND HOW MANY ITEMS ARE SOLD
SELECT count(product_key) total_items_sold
FROM gold.fact_sales
-- FIND THE AVERAGE SELLING PRICE 
SELECT AVG(price) avg_selling_price
FROM gold.fact_sales
-- FIND THE TOTAL NUMBER OF ORDERS 
SELECT count(DISTINCT(order_number)) total_number_orders
FROM gold.fact_sales
-- FIND THE TOTAL NUMBER OF PRODUCTS
SELECT count(Distinct product_key) total_number_products
FROM gold.dim_products
-- FIND THE TOTAL NUMBER OF CUSTOMERS
SELECT count(customer_key)  total_number_customers
FROM gold.dim_customers
-- FIND THE TOTAL NUMBER OF CUSTOMERS THAT HAVE PLACED AN ORDER
SELECT count(DISTINCT customer_key)  total_number_customers_with_orders
FROM gold.fact_sales
-- GENERATE A REPORT THAT SHOWS ALL KEY METRICS OF THE BUSINESS
SELECT 'Total Sales' measure_name , SUM(sales_amount) measure_value
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Quantity' measure_name , SUM(quantity) measure_value
FROM gold.fact_sales
UNION ALL 
SELECT 'Average Price' measure_name , AVG(price) measure_value
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Orders' measure_name, count(DISTINCT(order_number)) measure_value
FROM gold.fact_sales
UNION ALL 
SELECT 'Total Nr. Products' measure_name, count(Distinct product_key) measure_name
FROM gold.dim_products
UNION ALL 
SELECT 'Total Nr. Customers' measure_name ,count(customer_key)  measure_name
FROM gold.dim_customers

-- FIND THE DATE OF THE FIRST AND LAST ORDER 
-- HOW MANY YEARS OF SALES ARE AVAILABLE
SELECT  
   MIN(order_date) first_order_date ,
   MAX(order_date) last_order_date ,
   DATEDIFF(DAY, MIN(order_date), MAX(order_date)) order_range_years

FROM gold.fact_sales
-- FIND THE YOUNGEST AND THE OLDEST CUSTOMER
SELECT 
DATEDIFF(year, MIN(birthdate) , GETDATE()) oldest_customer,
DATEDIFF(year, MAX(birthdate) , GETDATE()) youngest_customer
from gold.dim_customers

-- Explore All Countries our Customers come from.
SELECT DISTINCT country From gold.dim_customers

-- EXPLORE ALL THE CATEGORIES "The major Divisions" 
SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products

-- FIND THE TOTAL CUSTUMERS BY COUNTRIES 
SELECT 
  country ,
  count(customer_key) total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC

-- Find TOTAL CUSTOMERS BY GERNDER 
SELECT 
  gender ,
  count(customer_key) total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC

-- FIND TOTAL PRODUCTS BY CATEGORY 
SELECT 
  category ,
  count(product_key) total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC

-- WHAT IS THE AVERAGE COSTS IN EACH CATEGORY
SELECT 
  category,
  Avg(cost) Avg_cost
FROM gold.dim_products
GROUP BY category
ORDER BY Avg_cost DESC

-- WHAT IS THE TOTAL REVENUE GENERATED FOR EACH CATEGORY

SELECT 
  p.category,
  SUM(s.sales_amount) total_revenue

FROM gold.dim_products p LEFT JOIN gold.fact_sales s ON p.product_key = s.product_key
GROUP BY p.category
ORDER BY total_revenue DESC

-- WHAT IS THE TOTAL REVENUE BY EACH CUSTOMER

SELECT 
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(s.sales_amount) total_revenue

FROM gold.fact_sales s LEFT JOIN gold.dim_customers c  ON s.customer_key = c.customer_key
GROUP BY c.customer_key , c.first_name,
  c.last_name
ORDER BY total_revenue DESC

-- WHAT IS THE DISTRIBUTION OF SOLD ITEMS ACROSS COUNTRIES

SELECT 
  c.country,
  SUM(s.sales_amount) Sold_items

FROM gold.fact_sales s LEFT JOIN gold.dim_customers c  ON s.customer_key = c.customer_key
GROUP BY c.country
ORDER BY Sold_items DESC





-- WHICH 5 PRODUCTS GENERATE THE HIGHEST REVENUE
SELECT TOP 5
 p.product_name,
 SUM(sales_amount) Total_revenue
 From gold.dim_products p Left Join gold.fact_sales s ON p.product_key = s.product_key
 GROUP BY  p.product_name
 ORDER BY Total_revenue DESC

-- WHAT ARE THE WORST PERFORMING PRODUCTS IN TERMS OF SALES 
SELECT TOP 5
 p.product_name,
 SUM(sales_amount) Total_revenue
 From gold.dim_products p Left Join gold.fact_sales s ON p.product_key = s.product_key
 GROUP BY  p.product_name
 HAVING SUM(s.sales_amount) IS NOT NULL
 ORDER BY Total_revenue 

-- FIND THE TOP 10 CUSTOMERS WHO HAVE GENERATED THE HIGHEST REVENUE
 SELECT TOP 10
  c.customer_key,
  c.first_name,
  c.last_name,
  SUM(s.sales_amount) total_revenue
FROM gold.fact_sales s LEFT JOIN gold.dim_customers c  ON s.customer_key = c.customer_key
GROUP BY c.customer_key , c.first_name,
  c.last_name
ORDER BY total_revenue DESC

-- FIND 3 CUSTOMERS WITH THE FEWEST ODERDERS PLACED
 SELECT TOP 3
  c.customer_key,
  c.first_name,
  c.last_name,
  COUNT(DISTINCT order_number) total_orders
FROM gold.fact_sales s LEFT JOIN gold.dim_customers c  ON s.customer_key = c.customer_key
GROUP BY c.customer_key , c.first_name,
  c.last_name
ORDER BY total_orders ASC


