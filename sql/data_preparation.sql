-- Create and switch database
CREATE DATABASE IF NOT EXISTS telecom;
USE telecom;

-- Rename and inspect table
RENAME TABLE telecom TO telecom_customer;
DESCRIBE telecom_customer;

-- Check for duplicate customer IDs
SELECT customer_id, COUNT(*) AS duplicate_count
FROM telecom_customer
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Check for NULL customer IDs
SELECT *
FROM telecom_customer
WHERE customer_id IS NULL;

-- Set customer_id as Primary Key
ALTER TABLE telecom_customer
MODIFY customer_id INT NOT NULL;

ALTER TABLE telecom_customer
ADD PRIMARY KEY (customer_id);

-- Check registration date values
SELECT DISTINCT date_of_registration
FROM telecom_customer
LIMIT 20;

-- Check for invalid date strings
SELECT *
FROM telecom_customer
WHERE STR_TO_DATE(date_of_registration, '%Y-%m-%d') IS NULL;

-- Change date_of_registration column to DATE type
ALTER TABLE telecom_customer
MODIFY COLUMN date_of_registration DATE;

-- Check distinct values in text columns
SELECT DISTINCT telecom_partner FROM telecom_customer ORDER BY telecom_partner;
SELECT DISTINCT gender FROM telecom_customer ORDER BY gender;
SELECT DISTINCT state FROM telecom_customer;
SELECT DISTINCT churn FROM telecom_customer;

-- Check for empty strings in text columns
SELECT *
FROM telecom_customer
WHERE TRIM(telecom_partner) = ''
   OR TRIM(gender) = ''
   OR TRIM(state) = ''
   OR TRIM(city) = '';

-- Check for invalid pincode lengths
SELECT *
FROM telecom_customer
WHERE LENGTH(CAST(pincode AS CHAR)) <> 6;

-- Check age bounds
SELECT MIN(age) AS min_age, MAX(age) AS max_age FROM telecom_customer;
SELECT * FROM telecom_customer WHERE age < 18 OR age > 100;

-- Check salary bounds
SELECT MIN(estimated_salary) AS min_salary, MAX(estimated_salary) AS max_salary FROM telecom_customer;
SELECT * FROM telecom_customer WHERE estimated_salary < 0;

-- Check dependents bounds
SELECT MIN(num_dependents) AS min_dependents, MAX(num_dependents) AS max_dependents FROM telecom_customer;
SELECT * FROM telecom_customer WHERE num_dependents < 0;

-- Save invalid usage records to a backup table
CREATE TABLE telecom_invalid_records AS
SELECT *
FROM telecom_customer
WHERE calls_made < 0
   OR sms_sent < 0
   OR data_used < 0;

-- Delete invalid usage records from main table
DELETE FROM telecom_customer
WHERE calls_made < 0
   OR sms_sent < 0
   OR data_used < 0;

-- Check for NULL values across all columns
SELECT
    SUM(customer_id IS NULL) AS null_customer_id,
    SUM(telecom_partner IS NULL) AS null_telecom_partner,
    SUM(gender IS NULL) AS null_gender,
    SUM(age IS NULL) AS null_age,
    SUM(state IS NULL) AS null_state,
    SUM(city IS NULL) AS null_city,
    SUM(pincode IS NULL) AS null_pincode,
    SUM(date_of_registration IS NULL) AS null_registration_date,
    SUM(num_dependents IS NULL) AS null_dependents,
    SUM(estimated_salary IS NULL) AS null_estimated_salary,
    SUM(calls_made IS NULL) AS null_calls_made,
    SUM(sms_sent IS NULL) AS null_sms_sent,
    SUM(data_used IS NULL) AS null_data_used,
    SUM(churn IS NULL) AS null_churn
FROM telecom_customer;

-- Final schema and data checks
DESCRIBE telecom_customer;

SELECT
    MIN(calls_made) AS min_calls, MAX(calls_made) AS max_calls,
    MIN(sms_sent) AS min_sms, MAX(sms_sent) AS max_sms,
    MIN(data_used) AS min_data, MAX(data_used) AS max_data
FROM telecom_customer;