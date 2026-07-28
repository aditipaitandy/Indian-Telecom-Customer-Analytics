USE telecom;

-- Q1. Gender distribution and market percentage
SELECT
    gender,
    COUNT(*) AS Total_Customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telecom_customer), 2) AS Percentage
FROM telecom_customer
GROUP BY gender
ORDER BY Total_Customers DESC;

-- Q2. Average age by gender
SELECT
    gender,
    ROUND(AVG(age), 2) AS Average_Age
FROM telecom_customer
GROUP BY gender
ORDER BY Average_Age DESC;

-- Q3. Customer count by age group
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Age_Group
ORDER BY Customers DESC;

-- Q4. Gender breakdown within age groups
SELECT
    CASE
        WHEN age BETWEEN 18 AND 25 THEN '18-25'
        WHEN age BETWEEN 26 AND 35 THEN '26-35'
        WHEN age BETWEEN 36 AND 45 THEN '36-45'
        WHEN age BETWEEN 46 AND 55 THEN '46-55'
        ELSE '56+'
    END AS Age_Group,
    gender,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Age_Group, gender
ORDER BY Age_Group, gender;

-- Q5. Average salary by gender
SELECT
    gender,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary
FROM telecom_customer
GROUP BY gender
ORDER BY Average_Salary DESC;

-- Q6. Min, max, avg, and standard deviation of salary
SELECT
    MIN(estimated_salary) AS Minimum_Salary,
    MAX(estimated_salary) AS Maximum_Salary,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary,
    ROUND(STDDEV(estimated_salary), 2) AS Salary_Standard_Deviation
FROM telecom_customer;

-- Q7. Customer distribution by salary bracket
SELECT
    CASE
        WHEN estimated_salary < 30000 THEN 'Low Income'
        WHEN estimated_salary BETWEEN 30000 AND 60000 THEN 'Middle Income'
        WHEN estimated_salary BETWEEN 60001 AND 100000 THEN 'Upper Middle Income'
        ELSE 'High Income'
    END AS Salary_Group,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY Salary_Group
ORDER BY Customers DESC;

-- Q8. Average number of dependents
SELECT ROUND(AVG(num_dependents), 2) AS Average_Dependents
FROM telecom_customer;

-- Q9. Customer count by dependent count
SELECT
    num_dependents,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY num_dependents
ORDER BY num_dependents;

-- Q10. Average salary grouped by dependents count
SELECT
    num_dependents,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary
FROM telecom_customer
GROUP BY num_dependents
ORDER BY num_dependents;

-- Q11. Average age grouped by dependents count
SELECT
    num_dependents,
    ROUND(AVG(age), 2) AS Average_Age
FROM telecom_customer
GROUP BY num_dependents
ORDER BY num_dependents;

-- Q12. Top 10 highest-earning customers
SELECT
    customer_id,
    telecom_partner,
    gender,
    age,
    estimated_salary
FROM telecom_customer
ORDER BY estimated_salary DESC
LIMIT 10;

-- Q13. Top 10 oldest customers
SELECT
    customer_id,
    telecom_partner,
    gender,
    age
FROM telecom_customer
ORDER BY age DESC
LIMIT 10;

-- Q14. Top 10 youngest customers
SELECT
    customer_id,
    telecom_partner,
    gender,
    age
FROM telecom_customer
ORDER BY age ASC
LIMIT 10;