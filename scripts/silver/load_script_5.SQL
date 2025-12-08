/* =====================================================================================
   Script Name  : Load Location Data - Silver Layer
   Author       : Akshatha Kumble Prabhu
   Description  :
       This script loads standardized location records from the bronze layer into 
       the silver layer. Customer IDs are cleaned by removing hyphens, and country 
       codes are transformed into consistent, readable values. Missing or invalid 
       country entries are defaulted to 'n/a' to maintain data quality and uniformity.
   ===================================================================================== */

-- Insert cleaned and standardized location data into Silver layer
INSERT INTO silver.erp_loc_a101 (
    cid, 
    cntry
)
SELECT 
       REPLACE(CID, '-', '') AS cid,                       -- Remove hyphens from Customer ID

       CASE 
            WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'               -- Map DE → Germany
            WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States' -- Normalise US country codes
            WHEN TRIM(CNTRY) = '' OR CNTRY IS NULL THEN 'n/a'      -- Default missing values
            ELSE TRIM(CNTRY)                                       -- Use cleaned country value
       END AS cntry
FROM [Datawarehouse].[bronze].[erp_loc_a101];               -- Source bronze table
