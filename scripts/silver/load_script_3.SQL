/*
================================================================================
Script Name  : Load and Clean Sales Details into Silver Layer
Author       : [Akshatha Kumble Prabhu]
Date         : [08-12-2025]
Environment  : SQL Server
Description  :
    This script extracts raw sales transactions from the bronze layer and loads 
    them into the silver layer after performing key data-quality and 
    standardization steps. The transformation logic includes:

        - Validating raw date fields stored as integers in YYYYMMDD format.  
          Invalid or malformed values are converted to NULL.
        - Deriving cleaned DATE values using safe casting.
        - Recalculating sales amounts when the raw value is missing, zero, or 
          does not match the expected formula (quantity × absolute price).
        - Cleaning product price values by recalculating price when invalid.
        - Passing through quantity values as provided in the source.
        - Ensuring the dataset is analytics-ready for downstream transformations.

    The result is a curated sales transaction table that maintains both accuracy 
    and business consistency prior to gold-layer consumption.
================================================================================
*/

INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
)
SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    -- Convert raw integer YYYYMMDD to DATE; set to NULL if invalid or malformed
    CASE 
        WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,

    -- Clean ship date using the same validation and conversion logic
    CASE 
        WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,

    -- Clean due date using the same validation and conversion logic
    CASE 
        WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
        ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,

    -- Validate sales amount:
    -- If NULL, non-positive, or inconsistent with quantity × price, recalculate it
    CASE 
        WHEN sls_sales IS NULL 
          OR sls_sales <= 0
          OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,

    -- Pass through quantity as stored in the source
    sls_quantity,

    -- Validate price:
    -- If NULL or non-positive, derive it from sales / quantity (safe divide)
    CASE 
        WHEN sls_price IS NULL OR sls_price <= 0 
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price

FROM [Datawarehouse].bronze.[crm_sales_details];
