/*
================================================================================
Script Name  : Load Cleaned Customer Information into Silver Layer
Author       : Akshatha Kumble Prabhu
Date         : 05-12-2025
Environment  : SQL Server
Description  :
    This script loads customer records from the bronze layer into the silver layer
    after applying essential data-cleaning and standardization rules. The process
    includes:
        - Removing duplicate customer records by keeping the most recent entry.
        - Standardizing text fields such as first and last names (trim + uppercase).
        - Mapping marital status and gender codes to meaningful, standardized values.
        - Excluding invalid or null customer IDs.
    The result is a curated, business-ready customer dataset for downstream
    analytics and reporting.
================================================================================
*/

INSERT INTO silver.crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr,
    cst_create_date
)
SELECT
    cst_id,
    cst_key,
    -- Clean first name: trim spaces and convert to uppercase
    UPPER(TRIM(cst_firstname)) AS cst_firstname,
    -- Clean last name: trim spaces and convert to uppercase
    UPPER(TRIM(cst_lastname)) AS cst_lastname,

    -- Standardize marital status values
    CASE 
        WHEN cst_marital_status = 'M' THEN 'Married'
        WHEN cst_marital_status = 'S' THEN 'Single'
        ELSE 'n/a' -- Handle missing or unknown values
    END AS cst_marital_status,

    -- Standardize gender values
    CASE 
        WHEN cst_gndr = 'M' THEN 'Male'
        WHEN cst_gndr = 'F' THEN 'Female'
        ELSE 'n/a' -- Handle missing or invalid gender entries
    END AS cst_gndr,

    cst_create_date
FROM (
    SELECT 
        *,
        -- Rank records per customer by most recent create date to remove duplicates
        ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
    FROM [Datawarehouse].[bronze].[crm_cust_info]
    WHERE cst_id IS NOT NULL -- Exclude rows with missing customer IDs
) t
WHERE flag = 1; -- Keep only the latest record per customer
