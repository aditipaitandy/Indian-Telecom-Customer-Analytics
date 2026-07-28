USE telecom;

-- Q1. Total number of distinct states
SELECT COUNT(DISTINCT state) AS Total_States
FROM telecom_customer;

-- Q2. Total number of distinct cities
SELECT COUNT(DISTINCT city) AS Total_Cities
FROM telecom_customer;

-- Q3. Customer count by state
SELECT
    state,
    COUNT(*) AS Total_Customers
FROM telecom_customer
GROUP BY state
ORDER BY Total_Customers DESC;

-- Q4. Top 10 cities by customer count
SELECT
    city,
    COUNT(*) AS Total_Customers
FROM telecom_customer
GROUP BY city
ORDER BY Total_Customers DESC
LIMIT 10;

-- Q5. Customer count grouped by state and telecom partner
SELECT
    state,
    telecom_partner,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY state, telecom_partner
ORDER BY state, Customers DESC;

-- Q6. Average data usage by state
SELECT
    state,
    ROUND(AVG(data_used), 2) AS Average_Data_Usage
FROM telecom_customer
GROUP BY state
ORDER BY Average_Data_Usage DESC;

-- Q7. Average calls made by state
SELECT
    state,
    ROUND(AVG(calls_made), 2) AS Average_Calls
FROM telecom_customer
GROUP BY state
ORDER BY Average_Calls DESC;

-- Q8. Average SMS sent by state
SELECT
    state,
    ROUND(AVG(sms_sent), 2) AS Average_SMS
FROM telecom_customer
GROUP BY state
ORDER BY Average_SMS DESC;

-- Q9. Average estimated salary by state
SELECT
    state,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary
FROM telecom_customer
GROUP BY state
ORDER BY Average_Salary DESC;

-- Q10. Average age by state
SELECT
    state,
    ROUND(AVG(age), 2) AS Average_Age
FROM telecom_customer
GROUP BY state
ORDER BY Average_Age DESC;

-- Q11. Churn rate and customer count by state
SELECT
    state,
    COUNT(*) AS Total_Customers,
    SUM(churn) AS Churned_Customers,
    ROUND((SUM(churn) * 100.0) / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY state
ORDER BY Churn_Rate DESC;

-- Q12. Top 10 cities by average data usage
SELECT
    city,
    ROUND(AVG(data_used), 2) AS Average_Data_Usage
FROM telecom_customer
GROUP BY city
ORDER BY Average_Data_Usage DESC
LIMIT 10;

-- Q13. Top 10 states by total data consumption
SELECT
    state,
    SUM(data_used) AS Total_Data_Usage
FROM telecom_customer
GROUP BY state
ORDER BY Total_Data_Usage DESC
LIMIT 10;

-- Q14. Top 20 pincodes by customer count
SELECT
    pincode,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY pincode
ORDER BY Customers DESC
LIMIT 20;

-- Q15. Yearly customer registration trend by state
SELECT
    state,
    YEAR(date_of_registration) AS Registration_Year,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY state, YEAR(date_of_registration)
ORDER BY state, Registration_Year;

-- Q16. Top 5 states ranked by average salary and data usage
SELECT
    state,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary,
    ROUND(AVG(data_used), 2) AS Average_Data
FROM telecom_customer
GROUP BY state
ORDER BY Average_Salary DESC, Average_Data DESC
LIMIT 5;

-- Q17. Overall geographical summary counts
SELECT
    COUNT(DISTINCT state) AS Total_States,
    COUNT(DISTINCT city) AS Total_Cities,
    COUNT(DISTINCT pincode) AS Total_Pincodes
FROM telecom_customer;