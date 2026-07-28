USE telecom;

-- 1. Churn rate by telecom partner
SELECT
    telecom_partner,
    COUNT(*) AS Total_Customers,
    SUM(churn) AS Churned_Customers,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Churn_Rate DESC;

-- Finding: BSNL has the highest churn rate (21.51%), followed by Vodafone (21.06%). Airtel has the lowest (18.64%).
-- Recommendation: Launch retention campaigns for BSNL and Vodafone to address network/pricing issues.


-- 2. Top 10 states by churn rate
SELECT
    state,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY state
ORDER BY Churn_Rate DESC
LIMIT 10;

-- Finding: Churn is highest in Jharkhand (29.03%), Andhra Pradesh (26.85%), Nagaland (25.00%), and Sikkim (24.49%).
-- Recommendation: Audit network quality and coverage in Jharkhand and Andhra Pradesh.


-- 3. Churn rate by salary group
SELECT
    CASE
        WHEN estimated_salary < (SELECT AVG(estimated_salary) FROM telecom_customer) THEN 'Below Average Salary'
        ELSE 'Above Average Salary'
    END AS Customer_Segment,
    COUNT(*) AS Customers,
    SUM(churn) AS Churned,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Churn_Rate
FROM telecom_customer
GROUP BY Customer_Segment
ORDER BY Churn_Rate DESC;

-- Finding: Below-average salary customers churn more (21.02%) than above-average earners (19.83%).
-- Recommendation: Offer lower-cost recharge options for budget-conscious users.


-- 4. High-value customers who churned
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    data_used
FROM telecom_customer
WHERE churn = 1
  AND estimated_salary > (SELECT AVG(estimated_salary) FROM telecom_customer)
  AND data_used > (SELECT AVG(data_used) FROM telecom_customer);

-- Finding: Premium users like Customer 81 (salary ₹1,31,010) and Customer 194 (salary ₹1,20,001) have churned.
-- Recommendation: Set up proactive account alerts to retain high-earning, high-usage subscribers.


-- 5. Average salary and data usage by partner
SELECT
    telecom_partner,
    ROUND(AVG(estimated_salary), 2) AS Avg_Salary,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY telecom_partner
ORDER BY Avg_Salary DESC, Avg_Data DESC;

-- Finding: Airtel has the highest avg salary (₹86,388.55) and data usage (5,136.58 MB). BSNL has the lowest avg salary (₹84,568.67).
-- Recommendation: Target Airtel users with premium upgrades and BSNL users with budget plans.


-- 6. Top 10 states by average data usage
SELECT
    state,
    ROUND(AVG(data_used), 2) AS Avg_Data
FROM telecom_customer
GROUP BY state
ORDER BY Avg_Data DESC
LIMIT 10;

-- Finding: Data usage is highest in Uttar Pradesh (5,586.10 MB), Mizoram (5,447.89 MB), and Telangana (5,425.24 MB).
-- Recommendation: Expand network capacity and 5G rollout in top data-consuming states.


-- 7. Customers earning above partner average salary
WITH Partner_Average AS (
    SELECT
        telecom_partner,
        AVG(estimated_salary) AS Avg_Salary
    FROM telecom_customer
    GROUP BY telecom_partner
)
SELECT
    t.customer_id,
    t.telecom_partner,
    t.estimated_salary
FROM telecom_customer t
JOIN Partner_Average p ON t.telecom_partner = p.telecom_partner
WHERE t.estimated_salary > p.Avg_Salary
ORDER BY t.telecom_partner, t.estimated_salary DESC;

-- Finding: Many customers earn above their operator's average, including Airtel users up to ₹1,49,995 salary.
-- Recommendation: Cross-sell family plans and premium add-ons to higher earners.


-- 8. Top 10 most valuable customers
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

-- Finding: Top VIPs like Customer 4005 and 122 have maximum salaries (~₹1,49,900) and high data usage (>5,500 MB).
-- Recommendation: Offer priority support and VIP perks to keep churn at 0% for top customers.


-- 9. High-usage, lower-salary customers
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    data_used
FROM telecom_customer
WHERE estimated_salary < (SELECT AVG(estimated_salary) FROM telecom_customer)
  AND data_used > (SELECT AVG(data_used) FROM telecom_customer);

-- Finding: Users like Customer 9 (Jio) and Customer 4 (BSNL) use heavy data (>9,000 MB) despite lower salaries.
-- Recommendation: Create high-volume, affordable data plans to retain cost-sensitive heavy users.


-- 10. Overall dataset summary
SELECT
    COUNT(*) AS Total_Customers,
    COUNT(DISTINCT telecom_partner) AS Telecom_Partners,
    COUNT(DISTINCT state) AS States,
    ROUND(AVG(estimated_salary), 2) AS Avg_Salary,
    ROUND(AVG(data_used), 2) AS Avg_Data,
    ROUND(AVG(calls_made), 2) AS Avg_Calls,
    ROUND(AVG(sms_sent), 2) AS Avg_SMS,
    ROUND(SUM(churn) * 100.0 / COUNT(*), 2) AS Overall_Churn_Rate
FROM telecom_customer;

-- Finding: Across 4,063 customers in 28 states, overall churn is 20.43% with average data usage of 5,063.10 MB.
-- Recommendation: Focus on reducing overall churn from 20.43% to under 16% through regional and partner-level fixes.