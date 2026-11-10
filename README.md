# Retail Business Performance & Profitability Analysis

## Project Overview

This project focuses on analyzing retail sales and profitability using SQL, Python, and Tableau. The objective is to explore business performance, identify patterns in sales and profit, and generate insights that can support better business decisions.

The analysis uses the Superstore dataset and combines SQL-based analysis, Python-based exploratory data analysis (EDA), and interactive data visualization.

## Business Objectives

- Analyze overall sales, profit, and profit margin.
- Identify the most and least profitable product categories.
- Compare business performance across different regions.
- Examine seasonal sales and profitability trends.
- Analyze the relationship between shipping modes and business performance.
- Identify areas where profitability can be improved.

## Tools & Technologies

| Tool | Purpose |
|---|---|
| MySQL 8.0 | Data storage, querying, and analysis |
| Python | Data analysis and exploration |
| Pandas | Data manipulation and cleaning |
| Matplotlib | Data visualization |
| Seaborn | Statistical visualization |
| Tableau | Interactive dashboard development |
| Git & GitHub | Version control and project documentation |

## Dataset

- **Dataset:** Superstore Sales Dataset
- **Total Records:** 9,994
- **Data Type:** Retail sales transactions

The dataset contains information about orders, sales, profit, product categories, regions, shipping modes, and other business-related attributes.

## Project Workflow

### 1. Data Cleaning and Preparation
- Inspected the dataset and its structure.
- Checked for duplicate records and data inconsistencies.
- Prepared the cleaned dataset for further analysis.

### 2. SQL Analysis (MySQL)
Imported the cleaned dataset into MySQL and performed business-oriented analysis.

Key areas explored:
- Overall sales and profit performance.
- Category-wise and region-wise profitability.
- Product-level performance.
- Seasonal sales and profit trends.
- Shipping mode analysis.

### 3. Exploratory Data Analysis (Python)

Used Pandas, Matplotlib, and Seaborn to explore the dataset and understand patterns in retail business performance through visualizations.

### 4. Tableau Dashboard

Developed an interactive dashboard to present important business metrics and trends, making the analysis easier to understand.

## Key Business Metrics

The following metrics were calculated using SQL:

| Metric | Value |
|---|---:|
| Total Sales | 2,297,201.07 |
| Total Profit | 286,397.02 |
| Profit Margin | 12.47% |

## Key Insights

The analysis focuses on identifying:

- High-performing and low-performing product categories.
- Regional differences in sales and profitability.
- Seasonal variations in business performance.
- Products contributing to higher or lower profits.
- Shipping modes and their relationship with profitability.

Detailed findings and business recommendations are documented alongside the analysis.

## Repository Structure

```text
retail-business-performance-analysis/
│
├── dataset/
│   └── cleaned_sales_data.csv
│
├── sql/
│   └── analysis_queries.sql
│
├── notebooks/
│   └── exploratory_data_analysis.ipynb
│
├── visualizations/
│   └── charts/
│
├── tableau/
│   └── dashboard.twbx
│
├── requirements.txt
└── README.md
```

## Learning Outcomes

Through this project, I worked on:

- Writing SQL queries for business analysis.
- Cleaning and manipulating data using Pandas.
- Performing exploratory data analysis.
- Creating meaningful data visualizations.
- Understanding retail sales and profitability metrics.
- Presenting analytical findings through Tableau dashboards.

## Conclusion

This project demonstrates an end-to-end approach to retail business analysis, combining database querying, Python-based data exploration, and dashboard visualization to understand business performance and identify opportunities for improvement.

---

**Project Category:** Data Analytics  
**Status:** Completed
