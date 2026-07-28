USE telecom;

-- Q1. Rank customers by estimated salary
SELECT
    customer_id,
    estimated_salary,
    RANK() OVER (ORDER BY estimated_salary DESC) AS Salary_Rank
FROM telecom_customer;

-- Q2. Dense rank customers by data usage
SELECT
    customer_id,
    data_used,
    DENSE_RANK() OVER (ORDER BY data_used DESC) AS Data_Rank
FROM telecom_customer;

-- Q3. Assign row numbers within each telecom partner
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    ROW_NUMBER() OVER (PARTITION BY telecom_partner ORDER BY estimated_salary DESC) AS Partner_Row
FROM telecom_customer;

-- Q4. Running total of data usage ordered by estimated salary
SELECT
    customer_id,
    estimated_salary,
    data_used,
    SUM(data_used) OVER (ORDER BY estimated_salary) AS Running_Data_Total
FROM telecom_customer;

-- Q5. 5-row moving average of data usage
SELECT
    customer_id,
    estimated_salary,
    data_used,
    ROUND(
        AVG(data_used) OVER (
            ORDER BY estimated_salary 
            ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
        ), 2
    ) AS Moving_Avg_Data
FROM telecom_customer;

-- Q6. Get previous customer's salary using LAG()
SELECT
    customer_id,
    estimated_salary,
    LAG(estimated_salary) OVER (ORDER BY estimated_salary) AS Previous_Salary
FROM telecom_customer;

-- Q7. Get next customer's salary using LEAD()
SELECT
    customer_id,
    estimated_salary,
    LEAD(estimated_salary) OVER (ORDER BY estimated_salary) AS Next_Salary
FROM telecom_customer;

-- Q8. Calculate salary difference from previous customer
SELECT
    customer_id,
    estimated_salary,
    estimated_salary - LAG(estimated_salary) OVER (ORDER BY estimated_salary) AS Salary_Difference
FROM telecom_customer;

-- Q9. Find highest salary in each telecom partner using FIRST_VALUE()
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    FIRST_VALUE(estimated_salary) OVER (
        PARTITION BY telecom_partner
        ORDER BY estimated_salary DESC
    ) AS Highest_Salary_In_Partner
FROM telecom_customer;

-- Q10. Find lowest salary in each telecom partner using LAST_VALUE()
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    LAST_VALUE(estimated_salary) OVER (
        PARTITION BY telecom_partner
        ORDER BY estimated_salary DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
    ) AS Lowest_Salary
FROM telecom_customer;

-- Q11. Divide customers into Salary Deciles (10 buckets)
SELECT
    customer_id,
    estimated_salary,
    NTILE(10) OVER (ORDER BY estimated_salary DESC) AS Salary_Decile
FROM telecom_customer;

-- Q12. Top 5% highest salary customers using PERCENT_RANK()
WITH Ranked_Salaries AS (
    SELECT
        customer_id,
        estimated_salary,
        PERCENT_RANK() OVER (ORDER BY estimated_salary DESC) AS Percent_Rank_Score
    FROM telecom_customer
)
SELECT *
FROM Ranked_Salaries
WHERE Percent_Rank_Score <= 0.05;

-- Q13. Find the Nth highest salary (e.g., 5th highest) using DENSE_RANK()
WITH Salary_Ranks AS (
    SELECT
        customer_id,
        estimated_salary,
        DENSE_RANK() OVER (ORDER BY estimated_salary DESC) AS Rank_Num
    FROM telecom_customer
)
SELECT *
FROM Salary_Ranks
WHERE Rank_Num = 5;

-- Q14. Calculate Median Salary using window functions
WITH Median_Calculation AS (
    SELECT
        estimated_salary,
        ROW_NUMBER() OVER (ORDER BY estimated_salary) AS Row_Num,
        COUNT(*) OVER () AS Total_Count
    FROM telecom_customer
)
SELECT
    ROUND(AVG(estimated_salary), 2) AS Median_Salary
FROM Median_Calculation
WHERE Row_Num IN (FLOOR((Total_Count + 1) / 2.0), CEIL((Total_Count + 1) / 2.0));

-- Q15. Calculate running cumulative count of customers
SELECT
    customer_id,
    date_of_registration,
    COUNT(*) OVER (ORDER BY date_of_registration) AS Running_Customer_Count
FROM telecom_customer;

-- Q16. Customer salary contribution percentage relative to partner total
SELECT
    customer_id,
    telecom_partner,
    estimated_salary,
    ROUND(
        estimated_salary * 100.0 / SUM(estimated_salary) OVER (PARTITION BY telecom_partner), 2
    ) AS Partner_Salary_Contribution_Pct
FROM telecom_customer;

-- Q17. Average salary by telecom partner using a CTE
WITH Partner_Salary AS (
    SELECT
        telecom_partner,
        ROUND(AVG(estimated_salary), 2) AS Avg_Salary
    FROM telecom_customer
    GROUP BY telecom_partner
)
SELECT *
FROM Partner_Salary
ORDER BY Avg_Salary DESC;

-- Q18. Customers earning above their telecom partner's average salary
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

-- Q19. Top 5 highest-earning customers per telecom partner
WITH Ranked_Customers AS (
    SELECT
        customer_id,
        telecom_partner,
        estimated_salary,
        ROW_NUMBER() OVER (
            PARTITION BY telecom_partner
            ORDER BY estimated_salary DESC
        ) AS Ranking
    FROM telecom_customer
)
SELECT *
FROM Ranked_Customers
WHERE Ranking <= 5;

-- Q20. Compare salary rank vs data usage rank
SELECT
    customer_id,
    estimated_salary,
    data_used,
    RANK() OVER (ORDER BY estimated_salary DESC) AS Salary_Rank,
    RANK() OVER (ORDER BY data_used DESC) AS Data_Rank
FROM telecom_customer;