
# Brazilian E-Commerce Data Analysis Project

> **Note:** This README is a professionally structured template based on the uploaded project artifacts (Python notebooks, SQL workbook, and Power BI dashboard). It documents the workflow, architecture, and implementation. You can further customize repository links and screenshots.

---

# Overview

This project analyzes the Brazilian Olist E-Commerce dataset using Python, SQL, PostgreSQL, and Power BI. The objective is to transform raw transactional data into actionable business insights through data profiling, cleaning, database integration, SQL analytics, and interactive dashboards.

## Objectives

- Profile and clean raw datasets.
- Build a relational database.
- Perform exploratory data analysis.
- Answer business questions using SQL.
- Build an executive Power BI dashboard.
- Generate insights on sales, customers, sellers, products, logistics, and reviews.

---

# Repository Structure

```text
.
├── data profiling.ipynb
├── appending file to DB.ipynb
├── analysis.ipynb
├── postfile_2.sql
├── DASHBOARD 01.pbix
└── README.md
```

## Notebook 1 – data profiling.ipynb

Purpose:
- Load raw datasets.
- Inspect schema and quality.
- Handle missing values.
- Detect duplicates.
- Convert data types.
- Standardize columns.
- Prepare data for storage and analysis.

Typical operations include:
- Importing pandas, numpy and SQLAlchemy.
- Reading CSV files.
- Using info(), describe(), head(), isnull(), duplicated().
- Cleaning inconsistent values.
- Preparing a consistent analytical dataset.

Business value:
Reliable analytics begin with high-quality data. This notebook ensures downstream SQL and Power BI analyses are based on standardized datasets.

---

## Notebook 2 – appending file to DB.ipynb

Purpose:
- Establish a SQLAlchemy database connection.
- Upload cleaned DataFrames into mySQL.
- Create tables.
- Automate loading.

Key workflow:
1. Create database engine.
2. Connect to PostgreSQL.
3. Iterate through cleaned datasets.
4. Load tables using DataFrame.to_sql().
5. Verify successful insertion.

Business value:
Creates a reusable analytical database that supports SQL queries and Power BI.

---

## Notebook 3 – analysis.ipynb

Purpose:
Perform exploratory data analysis.

Typical analyses include:
- Revenue trends
- Orders
- Customers
- Sellers
- Product categories
- Freight
- Delivery performance
- Customer reviews
- Visualizations using Matplotlib and Seaborn

Business value:
Transforms transactional data into business intelligence before dashboard creation.

---

# SQL Analysis

The SQL workbook answers business questions using:
- INNER JOIN
- LEFT JOIN
- GROUP BY
- ORDER BY
- Aggregate functions
- Date functions
- CASE expressions (where applicable)

Representative business questions:
- Total revenue
- Average order value
- Top sellers
- Best-performing product categories
- Customer distribution
- Delivery delays
- Review score analysis
- Freight cost trends

Each query aggregates transactional data into decision-ready metrics.

---

# Power BI Dashboard

The Power BI report provides interactive business intelligence.

Expected components include:
- KPI cards
- Revenue
- Orders
- Customers
- Sellers
- Category performance
- Geographic analysis
- Delivery metrics
- Filters and slicers
- Drill-down capability

Dashboard users can filter results by date, state, seller, and product category.

---

# Technology Stack

- Python
- Pandas
- NumPy
- SQLAlchemy
- PostgreSQL
- SQL
- Jupyter Notebook
- Power BI
- Matplotlib
- Seaborn
- VS Code

---

# Workflow

Raw CSV Files

↓

Data Profiling

↓

Data Cleaning

↓

Database Loading

↓

SQL Analysis

↓

EDA

↓

Power BI Dashboard

↓

Business Insights

---

# Key Business Insights

The project enables analysis of:

- Sales performance
- Customer purchasing behavior
- Seller performance
- Product demand
- Logistics efficiency
- Freight costs
- Delivery delays
- Customer satisfaction

---

# Installation

```bash
git clone <repository-url>

pip install pandas numpy matplotlib seaborn sqlalchemy psycopg2
```

Configure PostgreSQL connection details inside the notebooks before execution.

Run notebooks in this order:

1. data profiling.ipynb
2. appending file to DB.ipynb
3. analysis.ipynb

Open `DASHBOARD 01.pbix` using Power BI Desktop.

---

# Future Enhancements

- Predictive sales forecasting
- Recommendation engine
- Automated ETL pipeline
- Cloud deployment

---

# Author

Puli Abhinav

B.Tech – Computer Science & Engineering (Data Science)

Vaagdevi Engineering College

puliabhinav3@gmail.com
