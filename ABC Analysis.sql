CREATE DATABASE inventory_project;
USE inventory_project;
SELECT COUNT(*) FROM online_retail_ii;

USE inventory_project;


SET SQL_SAFE_UPDATES = 0;
DELETE FROM online_retail_ii WHERE Quantity <= 0;


SELECT 
    StockCode, 
    Description, 
    SUM(Quantity * Price) AS Total_Revenue,
   
    CASE 
        WHEN SUM(Quantity * Price) >= 2000 THEN 'A - High Value' 
        WHEN SUM(Quantity * Price) BETWEEN 500 AND 1999 THEN 'B - Medium Value'
        ELSE 'C - Low Value (Dead Stock)'
    END AS ABC_Category
FROM 
    online_retail_ii
GROUP BY 
    StockCode, Description
ORDER BY 
    Total_Revenue DESC;