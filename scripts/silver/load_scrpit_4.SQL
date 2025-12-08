/*
================================================================================
Script Name  : Load and Clean ERP Customer Data (AZ12) into Silver Layer
Author       : [Akshatha Kumble Prabhu]
Date         : [08-12-2025]
Environment  : SQL Server
Description  :
    This script loads customer records from the ERP AZ12 extract in the bronze 
    layer into the silver layer. During the load, essential data-cleaning 
    transformations are applied to standardize identifiers and correct invalid 
    values. Key improvements include:

        - Cleaning Customer ID (CID) by removing the 'NAS' prefix when present.
        - Validating birthdates and nullifying values that fall in the future.
        - Standardizing gender values to a consistent format (Male/Female/n/a),
          regardless of variations in casing or abbreviations.

    The resulting silver table provides a clean and reliable dataset suitable 
    for analytics and downstream modelling.
================================================================================
*/


INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
)
SELECT 
    -- Clean Customer ID:
    -- Remove the 'NAS' prefix when present (e.g., 'NAS12345' → '12345')
    CASE 
        WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
        ELSE CID
    END AS cid,

    -- Validate birthdate:
    -- If the birthdate is in the future, treat as invalid and set to NULL
    CASE 
        WHEN BDATE > GETDATE() THEN NULL
        ELSE BDATE
    END AS bdate,

    -- Standardize gender values:
    -- Accept variations ('M', 'MALE', 'F', 'FEMALE') and convert to clean labels
    CASE 
        WHEN UPPER(TRIM(GEN)) IN ('MALE', 'M') THEN 'Male'
        WHEN UPPER(TRIM(GEN)) IN ('FEMALE', 'F') THEN 'Female'
        ELSE 'n/a'
    END AS gen

FROM [Datawarehouse].[bronze].[erp_cust_az12];
