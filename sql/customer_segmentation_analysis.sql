USE telecom;

-- Q1. Segment customers by average data usage
SELECT
    CASE
        WHEN data_used < (SELECT AVG(data_used) FROM telecom_customer) THEN 'Below Average Usage'
        ELSE 'Above Average Usage'
    END AS Usage_Segment,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Usage_Segment;

-- Q2. Segment customers by average salary
SELECT
    CASE
        WHEN estimated_salary < (SELECT AVG(estimated_salary) FROM telecom_customer) THEN 'Below Average Salary'
        ELSE 'Above Average Salary'
    END AS Salary_Segment,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Salary_Segment;

-- Q3. Top 25% highest salary customers (Quartile 1)
WITH Salary_Ranking AS (
    SELECT
        customer_id,
        telecom_partner,
        estimated_salary,
        NTILE(4) OVER (ORDER BY estimated_salary DESC) AS Salary_Quartile
    FROM telecom_customer
)
SELECT *
FROM Salary_Ranking
WHERE Salary_Quartile = 1
ORDER BY estimated_salary DESC;

-- Q4. Top 25% highest data users (Quartile 1)
WITH Data_Ranking AS (
    SELECT
        customer_id,
        telecom_partner,
        data_used,
        NTILE(4) OVER (ORDER BY data_used DESC) AS Data_Quartile
    FROM telecom_customer
)
SELECT *
FROM Data_Ranking
WHERE Data_Quartile = 1
ORDER BY data_used DESC;

-- Q5. Customers with above-average calls, SMS, and data usage
SELECT
    customer_id,
    telecom_partner,
    calls_made,
    sms_sent,
    data_used
FROM telecom_customer
WHERE calls_made > (SELECT AVG(calls_made) FROM telecom_customer)
  AND sms_sent > (SELECT AVG(sms_sent) FROM telecom_customer)
  AND data_used > (SELECT AVG(data_used) FROM telecom_customer);

-- Q6. Customers with above-average number of dependents
SELECT
    customer_id,
    telecom_partner,
    num_dependents
FROM telecom_customer
WHERE num_dependents > (SELECT AVG(num_dependents) FROM telecom_customer)
ORDER BY num_dependents DESC;

-- Q7. Young professionals (below average age and above average salary)
SELECT
    customer_id,
    telecom_partner,
    age,
    estimated_salary
FROM telecom_customer
WHERE age < (SELECT AVG(age) FROM telecom_customer)
  AND estimated_salary > (SELECT AVG(estimated_salary) FROM telecom_customer);

-- Q8. Churned customers with below-average data usage
SELECT
    customer_id,
    telecom_partner,
    data_used,
    churn
FROM telecom_customer
WHERE churn = 1
  AND data_used < (SELECT AVG(data_used) FROM telecom_customer);

-- Q9. Top 10% premium customers based on salary cumulative distribution
WITH Premium AS (
    SELECT
        customer_id,
        telecom_partner,
        estimated_salary,
        data_used,
        CUME_DIST() OVER (ORDER BY estimated_salary DESC) AS Salary_Percentile
    FROM telecom_customer
)
SELECT *
FROM Premium
WHERE Salary_Percentile <= 0.10;

-- Q10. Divide customers into 4 salary quartiles
SELECT
    customer_id,
    estimated_salary,
    NTILE(4) OVER (ORDER BY estimated_salary) AS Salary_Quartile
FROM telecom_customer;

-- Q11. Calculate percent rank of customer salaries
SELECT
    customer_id,
    estimated_salary,
    ROUND(PERCENT_RANK() OVER (ORDER BY estimated_salary), 4) AS Salary_Percent_Rank
FROM telecom_customer;

-- Q12. Calculate cumulative distribution percentile of data usage
SELECT
    customer_id,
    data_used,
    ROUND(CUME_DIST() OVER (ORDER BY data_used), 4) AS Data_Percentile
FROM telecom_customer;

-- Q13. Rank customers by data usage
SELECT
    customer_id,
    telecom_partner,
    data_used,
    RANK() OVER (ORDER BY data_used DESC) AS Data_Rank
FROM telecom_customer;

-- Q14. Dense rank customers by estimated salary
SELECT
    customer_id,
    estimated_salary,
    DENSE_RANK() OVER (ORDER BY estimated_salary DESC) AS Salary_Rank
FROM telecom_customer;

-- Q15. Rank customers by salary within each telecom partner
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    ROW_NUMBER() OVER (PARTITION BY telecom_partner ORDER BY estimated_salary DESC) AS Partner_Rank
FROM telecom_customer;

-- Q16. Average usage metrics by salary segment
SELECT
    CASE
        WHEN estimated_salary < (SELECT AVG(estimated_salary) FROM telecom_customer) THEN 'Below Average Salary'
        ELSE 'Above Average Salary'
    END AS Salary_Segment,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY Salary_Segment;

-- Q17. Churn rate comparison by salary segment
SELECT
    CASE
        WHEN estimated_salary < (SELECT AVG(estimated_salary) FROM telecom_customer) THEN 'Below Average Salary'
        ELSE 'Above Average Salary'
    END AS Salary_Segment,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY Salary_Segment;

-- Q18. Top 10 most valuable customers based on salary and data usage
WITH Customer_Value AS (
    SELECT
        customer_id,
        telecom_partner,
        estimated_salary,
        data_used,
        RANK() OVER (ORDER BY estimated_salary DESC, data_used DESC) AS Customer_Rank
    FROM telecom_customer
)
SELECT *
FROM Customer_Value
WHERE Customer_Rank <= 10;