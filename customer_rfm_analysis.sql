USE inventory_project;

/* RFM SEGMENTATION ANALYSIS
   -------------------------
   1. Customer_Stats: Aggregates data per customer (Total Spend, Last Date).
   2. Max_Date: Finds the latest date in the dataset to act as "Today".
   3. Final Select: Calculates Recency and assigns VIP/Loyal/Churn labels.
*/

WITH Customer_Stats AS (
    SELECT 
        `Customer ID`, 
        MAX(InvoiceDate) as Last_Purchase_Date,
        COUNT(DISTINCT Invoice) as Frequency,
        SUM(Quantity * Price) as Total_Spend
    FROM online_retail_ii
    WHERE `Customer ID` IS NOT NULL
    GROUP BY `Customer ID`
),
Max_Date AS (
    SELECT MAX(InvoiceDate) as MaxDate FROM online_retail_ii
)
SELECT 
    `Customer ID`,
    /* Calculate how many days since their last visit */
    DATEDIFF((SELECT MaxDate FROM Max_Date), Last_Purchase_Date) as Recency_Days,
    Frequency,
    Total_Spend,
    /* Segmentation Logic: Categorize customers based on behavior */
    CASE 
        WHEN DATEDIFF((SELECT MaxDate FROM Max_Date), Last_Purchase_Date) < 30 AND Total_Spend > 1000 THEN 'VIP Gold'
        WHEN DATEDIFF((SELECT MaxDate FROM Max_Date), Last_Purchase_Date) < 60 AND Total_Spend > 500 THEN 'Loyal Customer'
        WHEN DATEDIFF((SELECT MaxDate FROM Max_Date), Last_Purchase_Date) > 100 THEN 'Churn Risk (Lost)'
        ELSE 'Regular'
    END as Customer_Segment
FROM Customer_Stats
ORDER BY Total_Spend DESC;