# SQL Sales Data Analysis

## 📌 Project Overview

This project focuses on exploratory and business-oriented sales data analysis using SQL Server.

The analysis was performed on a **pre-existing sales database** containing fact and dimension tables. The database was provided as a starting point, while the SQL queries, analysis, customer segmentation, performance analysis, and reporting were developed as part of this project.

The main goal was to explore the data, calculate key business metrics, identify trends, and extract meaningful insights about customers, products, and sales performance.

---

## 🎯 Objectives

The main objectives of this project were to:

* Explore and understand the available sales data.
* Calculate key business performance indicators (KPIs).
* Analyze sales trends over time.
* Evaluate product and category performance.
* Analyze customer purchasing behavior.
* Segment customers based on spending and purchasing history.
* Perform proportional and cumulative analyses.
* Create a customer-level analytical report.

---

## 🗂️ Dataset

The project uses a **pre-existing sales database** with a dimensional structure.

The main tables used in the analysis are:

* `gold.fact_sales` — Sales transactions
* `gold.dim_products` — Product information
* `gold.dim_customers` — Customer information

The database itself was **not built as part of this project**. Instead, the focus was on using SQL to analyze the existing data and derive business insights.

---

## 🛠️ Tools

* **Microsoft SQL Server**
* **SQL Server Management Studio (SSMS)**
* **SQL**

### SQL techniques used

* Aggregations: `SUM()`, `AVG()`, `COUNT()`
* Filtering and sorting
* `GROUP BY` and `ORDER BY`
* `JOIN`
* `CTE`
* `CASE` statements
* Window functions
* `LAG()`
* Running totals
* Moving averages
* Date-based analysis
* `UNION ALL`
* SQL Views
* Customer and product segmentation

---

## 🔍 Analysis Performed

### 1. Business KPIs

Calculated key metrics including:

* Total Sales
* Total Quantity Sold
* Total Orders
* Total Products
* Total Customers
* Average Selling Price
* Customers with Orders

### 2. Exploratory Data Analysis

Explored:

* Customer countries
* Customer gender
* Product categories and subcategories
* Number of customers by country
* Number of products by category
* Average product cost by category

### 3. Product & Customer Analysis

Analyzed:

* Revenue by category
* Revenue by customer
* Sales by country
* Top-performing products
* Lowest-performing products
* Top customers by revenue
* Customers with the fewest orders

### 4. Time-Series Analysis

Analyzed sales performance over time using monthly data:

* Total monthly sales
* Number of customers
* Quantity sold
* Running total of sales
* Moving average of selling price

### 5. Performance Analysis

Compared product performance across years using:

* Average product sales
* Current-year sales
* Previous-year sales
* Difference from average
* Year-over-year changes

Window functions such as `AVG() OVER()` and `LAG() OVER()` were used for these comparisons.

### 6. Proportional Analysis

Calculated the contribution of each product category to overall sales in order to understand the relative importance of each category.

### 7. Customer & Product Segmentation

Products were grouped into cost ranges.

Customers were segmented based on their purchasing history and spending:

* **VIP**
* **Regular**
* **New**

Customer age groups were also created.

### 8. Customer Report

A customer-level analytical view was created containing metrics such as:

* Customer age and age group
* Customer segment
* Total sales
* Total orders
* Total quantity purchased
* Total products purchased
* Last order date
* Recency
* Average Order Value
* Average Monthly Spend
* Customer lifespan

---

## 📁 Project Structure

```text
sql-sales-data-analysis/
│
├── README.md
├── Project Roadmap.png
│
├── datasets/
│   ├── DataWarehouseAnalytics.bak
│   └── flat-files/
│       ├── dim_customers.csv
│       ├── dim_products.csv
│       └── fact_sales.csv
│
└── scripts/
    ├── 00_init_database.sql
    ├── 01_database_exploration.sql
    ├── 02_dimensions_exploration.sql
    ├── 03_date_range_exploration.sql
    ├── 04_measures_exploration.sql
    ├── 05_magnitude_analysis.sql
    ├── 06_ranking_analysis.sql
    ├── 07_change_over_time_analysis.sql
    ├── 08_cumulative_analysis.sql
    ├── 09_performance_analysis.sql
    ├── 10_data_segmentation.sql
    ├── 11_part_to_whole_analysis.sql
    ├── 12_report_customers.sql
    ├── 13_report_products.sql
    ├── 14_exploratory_data_analysis.sql
    └── 15_advanced_data_analysis.sql
```

### 📂 Folders & Files

**`datasets/`**
Contains the database backup and the flat CSV files used for the analysis.

**`scripts/`**
Contains the SQL scripts used to explore the database, analyze the data, perform advanced analysis, and create analytical reports.

**`Project Roadmap.png`**
Provides an overview of the project workflow and analysis steps.

**`README.md`**
Provides an overview of the project, objectives, methodology, and analysis performed.


## 💡 Key Takeaways

This project provided practical experience in using SQL for business-oriented data analysis, including:

* Transforming raw transactional data into meaningful metrics.
* Identifying sales and customer trends.
* Comparing product performance over time.
* Using advanced SQL techniques for analytical queries.
* Building customer segmentation logic.
* Creating reusable analytical views.

---

## 🚀 How to Reproduce the Analysis

To run the analysis:

1. Use a SQL Server environment.
2. Connect to a database containing the required tables.
3. Ensure the following tables are available:

```text
gold.fact_sales
gold.dim_products
gold.dim_customers
```

4. Open the SQL scripts in SQL Server Management Studio.
5. Execute the queries to reproduce the analysis.

> **Note:** The original database is not included in this repository. The SQL scripts are provided to demonstrate the analysis and SQL techniques used in the project.

---

## 👤 Author

This project was developed as part of my Data Analytics learning portfolio, with a focus on SQL-based business and exploratory data analysis.

