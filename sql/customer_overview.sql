USE telecom;

-- Q1. Total number of customers
SELECT COUNT(*) AS Total_Customers
FROM telecom_customer;

-- Q2. Active vs churned customers with percentage
SELECT
    CASE WHEN churn = 1 THEN 'Churned' ELSE 'Active' END AS Customer_Status,
    COUNT(*) AS Total_Customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telecom_customer), 2) AS Percentage
FROM telecom_customer
GROUP BY churn;

-- Q3. Number of distinct telecom partners
SELECT COUNT(DISTINCT telecom_partner) AS Total_Telecom_Partners
FROM telecom_customer;

-- Q4. Customer count and market share by telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telecom_customer), 2) AS Market_Share_Percentage
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Customers DESC;

-- Q5. Min and max customer age
SELECT
    MIN(age) AS Youngest_Customer,
    MAX(age) AS Oldest_Customer
FROM telecom_customer;

-- Q6. Registration trend by year
SELECT
    YEAR(date_of_registration) AS Registration_Year,
    COUNT(*) AS Total_Customers
FROM telecom_customer
GROUP BY YEAR(date_of_registration)
ORDER BY Registration_Year;

-- Q7. Registration trend by year and month
SELECT
    DATE_FORMAT(date_of_registration, '%Y-%m') AS Registration_Month,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY DATE_FORMAT(date_of_registration, '%Y-%m')
ORDER BY Registration_Month;

-- Q8. Earliest registered customer
SELECT *
FROM telecom_customer
ORDER BY date_of_registration ASC
LIMIT 1;

-- Q9. Most recently registered customer
SELECT *
FROM telecom_customer
ORDER BY date_of_registration DESC
LIMIT 1;