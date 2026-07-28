USE telecom;

-- Q1. Overall customer churn rate
SELECT
    COUNT(*) AS Total_Customers,
    SUM(churn) AS Churned_Customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer;

-- Q2. Churn rate by telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Churn_Rate DESC;

-- Q3. Churn rate by gender
SELECT
    gender,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY gender
ORDER BY Churn_Rate DESC;

-- Q4. Churn rate by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY Age_Group
ORDER BY Churn_Rate DESC;

-- Q5. Churn rate by state
SELECT
    state,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY state
ORDER BY Churn_Rate DESC;

-- Q6. Top 10 cities with highest churn rate (minimum 50 customers)
SELECT
    city,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY city
HAVING COUNT(*) >= 50
ORDER BY Churn_Rate DESC
LIMIT 10;

-- Q7. Churn rate by salary bracket
SELECT
    CASE
        WHEN estimated_salary < 30000 THEN 'Low Income'
        WHEN estimated_salary BETWEEN 30000 AND 60000 THEN 'Middle Income'
        WHEN estimated_salary BETWEEN 60001 AND 100000 THEN 'Upper Middle Income'
        ELSE 'High Income'
    END AS Salary_Group,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY Salary_Group
ORDER BY Churn_Rate DESC;

-- Q8. Churn rate by number of dependents
SELECT
    num_dependents,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY num_dependents
ORDER BY num_dependents;

-- Q9. Churn rate by usage category
SELECT
    CASE
        WHEN data_used < 3000 THEN 'Low Usage'
        WHEN data_used BETWEEN 3000 AND 7000 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS Usage_Category,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY Usage_Category
ORDER BY Churn_Rate DESC;

-- Q10. Top 10 high data-usage customers who churned
SELECT
    customer_id,
    telecom_partner,
    state,
    data_used,
    estimated_salary
FROM telecom_customer
WHERE churn = 1
ORDER BY data_used DESC
LIMIT 10;

-- Q11. Rank telecom partners by churn rate
SELECT
    telecom_partner,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate,
    RANK() OVER (ORDER BY ROUND(SUM(churn) * 100.0 / COUNT(*), 2) DESC) AS Partner_Rank
FROM telecom_customer
GROUP BY telecom_partner;

-- Q12. Top 5 states with highest churn rate using CTE and window functions
WITH State_Churn AS (
    SELECT
        state,
        ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
    FROM telecom_customer
    GROUP BY state
)
SELECT *
FROM (
    SELECT
        state,
        Churn_Rate,
        DENSE_RANK() OVER (ORDER BY Churn_Rate DESC) AS Ranking
    FROM State_Churn
) t
WHERE Ranking <= 5;

-- Q13. Customer distribution by risk category
SELECT
    CASE
        WHEN churn = 1 AND data_used < 3000 THEN 'High Risk'
        WHEN churn = 1 THEN 'Churned'
        ELSE 'Active'
    END AS Customer_Category,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Customer_Category;

-- Q14. Average usage comparison between churned and active customers
SELECT
    CASE WHEN churn = 1 THEN 'Churned' ELSE 'Active' END AS Customer_Status,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY churn;

-- Q15. High-level churn KPI dashboard summary
SELECT
    COUNT(*) AS Total_Customers,
    SUM(churn) AS Total_Churned,
    COUNT(*) - SUM(churn) AS Active_Customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Overall_Churn_Rate,
    ROUND(AVG(data_used), 2) AS Average_Data,
    ROUND(AVG(calls_made), 2) AS Average_Calls,
    ROUND(AVG(sms_sent), 2) AS Average_SMS
FROM telecom_customer;