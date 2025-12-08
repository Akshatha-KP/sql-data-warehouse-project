/*
================================================================================
Script Name  : Silver Layer Table Setup
Author       : Akshatha Kumble Prabhu
Date         : [2025-12-05]
Environment  : SQL Server
Description  : 
    This script sets up the Silver layer tables in the data warehouse.
    - Drops existing tables if they exist to avoid conflicts.
    - Creates tables for CRM, ERP, and product-related data with appropriate columns.
    - Tables included:
        1. crm_cust_info      - CRM customer information
        2. crm_prd_info       - CRM product information
        3. crm_sales_details  - CRM sales transactions
        4. erp_cust_az12      - ERP customer data
        5. erp_loc_a101       - ERP location data
        6. erp_px_cat_g1v2    - ERP product category data
Usage Notes :
    - Run this script in the datawarehouse database context.
    - All drops are conditional to prevent errors if the table does not exist.
================================================================================
*/



-- Drop table if it already exists
IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_cust_info;
GO

-- Create customer info table
CREATE TABLE silver.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE,
    dwh_create_date    DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it already exists
IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE silver.crm_prd_info;
GO

-- Create product info table
CREATE TABLE silver.crm_prd_info (
    prd_id          INT,
    cat_id          NVARCHAR(50),
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATE,
    prd_end_dt      DATE,
    dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- Drop table if it already exists
IF OBJECT_ID('silver.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE silver.crm_sales_details;
GO

-- Create sales details table
CREATE TABLE silver.crm_sales_details (
    sls_ord_num         NVARCHAR(50),
    sls_prd_key         NVARCHAR(50),
    sls_cust_id         INT,
    sls_order_dt        DATE,
    sls_ship_dt         DATE,
    sls_due_dt          DATE,
    sls_sales           INT,
    sls_quantity        INT,
    sls_price           INT,
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);



-- Drop table if it already exists
IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE silver.erp_cust_az12;
GO

-- Create ERP customer table
CREATE TABLE silver.erp_cust_az12 (
    CID                 NVARCHAR(50),
    BDATE               DATETIME,
    GEN                 NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it already exists
IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE silver.erp_loc_a101;
GO

-- Create ERP location table
CREATE TABLE silver.erp_loc_a101 (
    CID     NVARCHAR(50),
    CNTRY   NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);


-- Drop table if it already exists
IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE silver.erp_px_cat_g1v2;
GO

-- Create ERP product category table
CREATE TABLE silver.erp_px_cat_g1v2 (
    id                  NVARCHAR(50),
    cat                 NVARCHAR(50),
    subcat              NVARCHAR(50),
    maintenance         NVARCHAR(50),
    dwh_create_date     DATETIME2 DEFAULT GETDATE()
);
GO

