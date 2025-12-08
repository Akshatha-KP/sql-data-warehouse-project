/********************************************************************************************
    DATA QUALITY CHECKS – SILVER.CRM_SALES_DETAILS
    Expectation: All checks should return ZERO records.
********************************************************************************************/

--------------------------------------------------------------------------------------------
-- 1. UNWANTED SPACES (Leading/Trailing)
--------------------------------------------------------------------------------------------
SELECT *
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_ord_num <> TRIM(sls_ord_num);

SELECT *
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_prd_key <> TRIM(sls_prd_key);



--------------------------------------------------------------------------------------------
-- 2. REFERENTIAL INTEGRITY CHECKS
--------------------------------------------------------------------------------------------

-- Product Key should exist in the Silver Product Dimension
SELECT sls_prd_key
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_prd_key NOT IN (
        SELECT prd_key 
        FROM [Datawarehouse].[silver].[crm_prd_info]
      );

-- Customer ID should exist in the Silver Customer Dimension
SELECT sls_cust_id
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_cust_id NOT IN (
        SELECT cst_id 
        FROM [Datawarehouse].[silver].[crm_cust_info]
      );



--------------------------------------------------------------------------------------------
-- 3. INVALID DATE CHECKS (Silver stores valid DATE types, NOT raw integers)
--------------------------------------------------------------------------------------------

-- Order Date outside expected business range
SELECT sls_order_dt
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_order_dt IS NULL
   OR sls_order_dt < '1900-01-01'
   OR sls_order_dt > '2099-12-31';

-- Ship Date
SELECT sls_ship_dt
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_ship_dt IS NULL
   OR sls_ship_dt < '1900-01-01'
   OR sls_ship_dt > '2099-12-31';

-- Due Date
SELECT sls_due_dt
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_due_dt IS NULL
   OR sls_due_dt < '1900-01-01'
   OR sls_due_dt > '2099-12-31';



--------------------------------------------------------------------------------------------
-- 4. INCORRECT DATE FORMATS (Should NEVER appear in Silver because DATE type)
-- These checks confirm no unexpected VARCHAR values snuck in.
--------------------------------------------------------------------------------------------

SELECT *
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE LEN(CONVERT(VARCHAR(10), sls_order_dt)) > 10;

SELECT *
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_order_dt < '1900-01-01'
   OR sls_order_dt > '2099-01-01';



--------------------------------------------------------------------------------------------
-- 5. DATA CONSISTENCY CHECK
-- Sales must equal Quantity * Price
-- Values must not be NULL, Zero or Negative
--------------------------------------------------------------------------------------------
SELECT DISTINCT
       sls_sales,
       sls_quantity,
       sls_price
FROM [Datawarehouse].[silver].[crm_sales_details]
WHERE sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity < 0
   OR sls_price <= 0
   OR sls_sales <> (sls_quantity * sls_price)
ORDER BY sls_sales_
