USE telecom;

-- Q1. Overall usage statistics (min, max, avg for calls, SMS, and data)
SELECT
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    MIN(calls_made) AS Min_Calls,
    MAX(calls_made) AS Max_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    MIN(sms_sent) AS Min_SMS,
    MAX(sms_sent) AS Max_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data_Used,
    MIN(data_used) AS Min_Data_Used,
    MAX(data_used) AS Max_Data_Used
FROM telecom_customer;

-- Q2. Average usage by telecom partner
SELECT
    telecom_partner,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Avg_Data DESC;

-- Q3. Average usage by gender
SELECT
    gender,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY gender;

-- Q4. Average usage by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY Age_Group
ORDER BY Age_Group;

-- Q5. Top 10 customers by data usage
SELECT
    customer_id,
    telecom_partner,
    state,
    age,
    data_used
FROM telecom_customer
ORDER BY data_used DESC
LIMIT 10;

-- Q6. Top 10 customers by calls made
SELECT
    customer_id,
    telecom_partner,
    state,
    calls_made
FROM telecom_customer
ORDER BY calls_made DESC
LIMIT 10;

-- Q7. Top 10 customers by SMS sent
SELECT
    customer_id,
    telecom_partner,
    state,
    sms_sent
FROM telecom_customer
ORDER BY sms_sent DESC
LIMIT 10;

-- Q8. Count of heavy data users (> 8000 units)
SELECT COUNT(*) AS Heavy_Data_Users
FROM telecom_customer
WHERE data_used > 8000;

-- Q9. Count of heavy call users (> 80 calls)
SELECT COUNT(*) AS Heavy_Call_Users
FROM telecom_customer
WHERE calls_made > 80;

-- Q10. Count of heavy SMS users (> 40 SMS)
SELECT COUNT(*) AS Heavy_SMS_Users
FROM telecom_customer
WHERE sms_sent > 40;

-- Q11. Customer distribution by data usage category
SELECT
    CASE
        WHEN data_used < 3000 THEN 'Low Usage'
        WHEN data_used BETWEEN 3000 AND 7000 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS Usage_Category,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Usage_Category
ORDER BY Customers DESC;

-- Q12. Average salary by data usage category
SELECT
    CASE
        WHEN data_used < 3000 THEN 'Low Usage'
        WHEN data_used BETWEEN 3000 AND 7000 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS Usage_Category,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary
FROM telecom_customer
GROUP BY Usage_Category;

-- Q13. Average age by data usage category
SELECT
    CASE
        WHEN data_used < 3000 THEN 'Low Usage'
        WHEN data_used BETWEEN 3000 AND 7000 THEN 'Medium Usage'
        ELSE 'High Usage'
    END AS Usage_Category,
    ROUND(AVG(age), 2) AS Average_Age
FROM telecom_customer
GROUP BY Usage_Category;

-- Q14. Average usage by number of dependents
SELECT
    num_dependents,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY num_dependents
ORDER BY num_dependents;

-- Q15. Customers with above-average data usage
SELECT
    customer_id,
    telecom_partner,
    state,
    data_used
FROM telecom_customer
WHERE data_used > (SELECT AVG(data_used) FROM telecom_customer)
ORDER BY data_used DESC;

-- Q16. Customers with above-average call volume
SELECT
    customer_id,
    telecom_partner,
    calls_made
FROM telecom_customer
WHERE calls_made > (SELECT AVG(calls_made) FROM telecom_customer)
ORDER BY calls_made DESC;

-- Q17. Customers with above-average SMS volume
SELECT
    customer_id,
    telecom_partner,
    sms_sent
FROM telecom_customer
WHERE sms_sent > (SELECT AVG(sms_sent) FROM telecom_customer)
ORDER BY sms_sent DESC;

-- Q18. Top 5 states by average data usage
SELECT
    state,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY state
ORDER BY Avg_Data DESC
LIMIT 5;
