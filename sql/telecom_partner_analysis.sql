USE telecom;

-- Q1. Total customer count by telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Total_Customers
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Total_Customers DESC;

-- Q2. Market share percentage of each telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Customers,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM telecom_customer), 2) AS Market_Share_Percentage
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Market_Share_Percentage DESC;

-- Q3. Average customer age by telecom partner
SELECT
    telecom_partner,
    ROUND(AVG(age), 2) AS Average_Age
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Average_Age DESC;

-- Q4. Average salary by telecom partner
SELECT
    telecom_partner,
    ROUND(AVG(estimated_salary), 2) AS Average_Salary
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Average_Salary DESC;

-- Q5. Average calls, SMS, and data usage by telecom partner
SELECT
    telecom_partner,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Avg_Data DESC;

-- Q6. Churn rate by telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Total_Customers,
    SUM(churn) AS Churned_Customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Churn_Rate DESC;

-- Q7. Rank telecom partners by customer count
SELECT
    telecom_partner,
    COUNT(*) AS Customers,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Customer_Rank
FROM telecom_customer
GROUP BY telecom_partner;

-- Q8. Dense rank telecom partners by churn rate
SELECT
    telecom_partner,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate,
    DENSE_RANK() OVER (ORDER BY ROUND(SUM(churn) * 100.0 / COUNT(*), 2) DESC) AS Churn_Rank
FROM telecom_customer
GROUP BY telecom_partner;

-- Q9. Assign row numbers based on average data usage
SELECT
    telecom_partner,
    ROUND(AVG(data_used), 2) AS Avg_Data,
    ROW_NUMBER() OVER (ORDER BY AVG(data_used) DESC) AS Row_Num
FROM telecom_customer
GROUP BY telecom_partner;

-- Q10. Gender distribution per telecom partner
SELECT
    telecom_partner,
    gender,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY telecom_partner, gender
ORDER BY telecom_partner;

-- Q11. High income customers (>80,000) per telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS High_Income_Customers
FROM telecom_customer
WHERE estimated_salary > 80000
GROUP BY telecom_partner
ORDER BY High_Income_Customers DESC;

-- Q12. Heavy data users (>7000 units) per telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Heavy_Data_Users
FROM telecom_customer
WHERE data_used > 7000
GROUP BY telecom_partner
ORDER BY Heavy_Data_Users DESC;

-- Q13. Customer registration trend by partner and year
SELECT
    telecom_partner,
    YEAR(date_of_registration) AS Registration_Year,
    COUNT(*) AS Customers
FROM telecom_customer
GROUP BY telecom_partner, YEAR(date_of_registration)
ORDER BY telecom_partner, Registration_Year;

-- Q14. Rank telecom partners by volume, lowest churn, and highest data usage
SELECT
    telecom_partner,
    COUNT(*) AS Customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Customers DESC, Churn_Rate ASC, Avg_Data DESC;

-- Q15. Overall partner performance summary
SELECT
    COUNT(DISTINCT telecom_partner) AS Total_Partners,
    ROUND(AVG(data_used), 2) AS Overall_Average_Data,
    ROUND(AVG(calls_made), 2) AS Overall_Average_Calls,
    ROUND(AVG(sms_sent), 2) AS Overall_Average_SMS
FROM telecom_customer;