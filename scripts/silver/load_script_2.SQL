/*
================================================================================
Script Name  : Load Cleaned Product Information into Silver Layer
Author       : [Akshatha Kumble Prabhu]
Date         : [07-12-2025]
Environment  : SQL Server
Description  :
    This script processes raw product data from the bronze layer and loads it 
    into the silver layer after applying key data-cleaning and transformation rules. 
    The logic implemented includes:

        - Deriving category IDs by extracting and standardizing segments of prd_key.
        - Extracting product identifiers from composite keys.
        - Standardizing product line codes into descriptive business terms.
        - Replacing null product costs with zero to ensure data completeness.
        - Converting datetime fields to date-only formats.
        - Calculating product end dates using LEAD(), ensuring proper date ranges 
          for product history tracking.

    The final output is a structured and business-ready product dataset 
    suitable for analytics, reporting, and dimensional modeling.
================================================================================
*/
INSERT INTO silver.crm_prd_info (
    prd_id,
    cat_id,
    prd_key,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT 
    prd_id,

    -- Derive Category ID from the first 5 characters of PRD_KEY, replace '-' with '_'
    REPLACE(SUBSTRING(PRD_KEY, 1, 5), '-', '_') AS cat_id,

    -- Extract Product Key from the remaining part of PRD_KEY (after position 7)
    SUBSTRING(PRD_KEY, 7, LEN(PRD_KEY)) AS prd_key,

    -- Replace missing product cost values with 0
    ISNULL(prd_cost, 0) AS prd_cost,

    -- Standardize product line codes into full descriptive names
    CASE UPPER(TRIM(prd_line))
        WHEN 'M' THEN 'Mountain'
        WHEN 'R' THEN 'Road'
        WHEN 'S' THEN 'Other Sales'
        WHEN 'T' THEN 'Touring'
        ELSE 'n/a' -- Handle unknown or invalid values
    END AS prd_line,

    -- Keep only the date part of product start date
    CAST(prd_start_dt AS DATE) AS prd_start_dt,

    -- Calculate end date: one day before the next product start date (per product key)
    CAST(
        LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt ASC) - 1 
        AS DATE
    ) AS prd_end_dt

FROM [Datawarehouse].[bronze].[crm_prd_info];
