-- Retail Business Performance & Profitability Analysis
-- Database: retail_analysis
-- Main table: superstore (deduplicated, expected 9,994 rows)
-- Run these queries in MySQL Workbench or the MySQL command-line client.

USE retail_analysis;

-- 0. DATA VALIDATION: row count should be 9,994
SELECT COUNT(*) AS Transaction_Rows FROM superstore;

-- 1. OVERALL BUSINESS KPIs
SELECT
    COUNT(*) AS Transaction_Rows,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore;

-- 2. CATEGORY PROFITABILITY
SELECT
    `Category`,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Category`
ORDER BY Total_Profit DESC;

-- 3. REGIONAL PROFITABILITY
SELECT
    `Region`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Region`
ORDER BY Total_Profit DESC;

-- 4. TOP 10 STATES BY PROFIT
SELECT
    `State`, `Region`,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `State`, `Region`
ORDER BY Total_Profit DESC
LIMIT 10;

-- 5. BOTTOM 10 STATES BY PROFIT
SELECT
    `State`, `Region`,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `State`, `Region`
ORDER BY Total_Profit ASC
LIMIT 10;

-- 6. COUNTRY-LEVEL PERFORMANCE
-- The supplied table has shown only United States; use Region/State for geographic comparisons if that remains true.
SELECT
    `Country`,
    COUNT(DISTINCT `Order ID`) AS Total_Orders,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM superstore
GROUP BY `Country`
ORDER BY Total_Profit DESC;

-- 7. DISCOUNT IMPACT
SELECT
    CASE
        WHEN `Discount` = 0 THEN '0% - No discount'
        WHEN `Discount` <= 0.10 THEN '1-10%'
        WHEN `Discount` <= 0.20 THEN '11-20%'
        WHEN `Discount` <= 0.30 THEN '21-30%'
        WHEN `Discount` <= 0.40 THEN '31-40%'
        ELSE 'Above 40%'
    END AS Discount_Band,
    COUNT(*) AS Transaction_Lines,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent,
    ROUND(AVG(`Discount`) * 100, 2) AS Average_Discount_Percent
FROM superstore
GROUP BY Discount_Band
ORDER BY MIN(`Discount`);

-- 8. PROFITABILITY BY SEASON, CATEGORY, AND SUBCATEGORY
-- Season definition used in this project: Winter=Dec-Feb, Spring=Mar-May, Summer=Jun-Aug, Autumn=Sep-Nov.
WITH seasonal_sales AS (
    SELECT
        CASE
            WHEN MONTH(`Order Date`) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(`Order Date`) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(`Order Date`) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Autumn'
        END AS Season,
        CASE
            WHEN MONTH(`Order Date`) IN (12, 1, 2) THEN 1
            WHEN MONTH(`Order Date`) IN (3, 4, 5) THEN 2
            WHEN MONTH(`Order Date`) IN (6, 7, 8) THEN 3
            ELSE 4
        END AS Season_Order,
        `Category`, `Sub-Category`, `Quantity`, `Sales`, `Profit`
    FROM superstore
    WHERE `Order Date` IS NOT NULL
)
SELECT
    Season, `Category`, `Sub-Category`,
    SUM(`Quantity`) AS Units_Sold,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit,
    ROUND(100 * SUM(`Profit`) / NULLIF(SUM(`Sales`), 0), 2) AS Profit_Margin_Percent
FROM seasonal_sales
GROUP BY Season, Season_Order, `Category`, `Sub-Category`
ORDER BY Season_Order, Total_Profit DESC;

-- 9. SEASONAL DEMAND BY YEAR
-- This aligns December with the following Jan-Feb winter. Edge winters may be incomplete.
WITH tagged AS (
    SELECT
        CASE WHEN MONTH(`Order Date`) = 12 THEN YEAR(`Order Date`) + 1
             ELSE YEAR(`Order Date`) END AS Season_Year,
        CASE
            WHEN MONTH(`Order Date`) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(`Order Date`) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(`Order Date`) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Autumn'
        END AS Season,
        `Quantity`, `Sales`, `Profit`
    FROM superstore
    WHERE `Order Date` IS NOT NULL
)
SELECT
    Season_Year, Season,
    SUM(`Quantity`) AS Units_Sold,
    ROUND(SUM(`Sales`), 2) AS Total_Sales,
    ROUND(SUM(`Profit`), 2) AS Total_Profit
FROM tagged
GROUP BY Season_Year, Season
ORDER BY Season_Year, FIELD(Season, 'Winter', 'Spring', 'Summer', 'Autumn');

-- 10. TOP 3 PRODUCTS BY COUNTRY, SEASON, AND SHIPPING MODE
WITH tagged AS (
    SELECT
        `Country`, `Product Name`, `Ship Mode`,
        CASE
            WHEN MONTH(`Order Date`) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(`Order Date`) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(`Order Date`) IN (6, 7, 8) THEN 'Summer'
            ELSE 'Autumn'
        END AS Season,
        `Quantity`, `Sales`, `Profit`
    FROM superstore
    WHERE `Order Date` IS NOT NULL
), product_profit AS (
    SELECT
        `Country`, Season, `Ship Mode`, `Product Name`,
        SUM(`Quantity`) AS Units_Sold,
        SUM(`Sales`) AS Total_Sales,
        SUM(`Profit`) AS Total_Profit
    FROM tagged
    GROUP BY `Country`, Season, `Ship Mode`, `Product Name`
), ranked AS (
    SELECT *,
        ROW_NUMBER() OVER (
            PARTITION BY `Country`, Season, `Ship Mode`
            ORDER BY Total_Profit DESC
        ) AS Profit_Rank
    FROM product_profit
)
SELECT
    `Country`, Season, `Ship Mode`, Profit_Rank, `Product Name`, Units_Sold,
    ROUND(Total_Sales, 2) AS Total_Sales,
    ROUND(Total_Profit, 2) AS Total_Profit,
    ROUND(100 * Total_Profit / NULLIF(Total_Sales, 0), 2) AS Profit_Margin_Percent
FROM ranked
WHERE Profit_Rank <= 3
ORDER BY `Country`, FIELD(Season, 'Winter', 'Spring', 'Summer', 'Autumn'), `Ship Mode`, Profit_Rank;

-- 11. SHIPPING-MODE FINANCIAL PERFORMANCE (does not depend on Ship Date)
WITH order_level AS (
    SELECT
        `Order ID`,
        MAX(`Ship Mode`) AS Ship_Mode,
        SUM(`Sales`) AS Order_Sales,
        SUM(`Profit`) AS Order_Profit
    FROM superstore
    GROUP BY `Order ID`
)
SELECT
    Ship_Mode,
    COUNT(*) AS Total_Orders,
    ROUND(SUM(Order_Sales), 2) AS Total_Sales,
    ROUND(SUM(Order_Profit), 2) AS Total_Profit,
    ROUND(100 * SUM(Order_Profit) / NULLIF(SUM(Order_Sales), 0), 2) AS Profit_Margin_Percent
FROM order_level
GROUP BY Ship_Mode
ORDER BY Total_Profit DESC;

-- 12. DATA QUALITY CHECK: verify if Order Date and Ship Date are unexpectedly identical.
-- Do not report average delivery time until the Ship Date field is checked against the original source.
SELECT
    COUNT(*) AS Total_Rows,
    SUM(CASE WHEN `Order Date` = `Ship Date` THEN 1 ELSE 0 END) AS Same_Order_And_Ship_Date,
    SUM(CASE WHEN `Ship Date` < `Order Date` THEN 1 ELSE 0 END) AS Ship_Date_Before_Order_Date,
    MIN(`Order Date`) AS Earliest_Order_Date,
    MAX(`Order Date`) AS Latest_Order_Date
FROM superstore;
