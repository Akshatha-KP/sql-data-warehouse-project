/*
================================================================================
Script Name  : Bronze Layer Table Setup
Author       : Akshatha Kumble Prabhu
Date         : [2025-12-04]
Environment  : SQL Server
Description  : 
    This script sets up the bronze layer tables in the data warehouse.
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
IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_cust_info;
GO

-- Create customer info table
CREATE TABLE bronze.crm_cust_info (
    cst_id             INT,
    cst_key            NVARCHAR(50),
    cst_firstname      NVARCHAR(50),
    cst_lastname       NVARCHAR(50),
    cst_marital_status NVARCHAR(50),
    cst_gndr           NVARCHAR(50),
    cst_create_date    DATE
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
    DROP TABLE bronze.crm_prd_info;
GO

-- Create product info table
CREATE TABLE bronze.crm_prd_info (
    prd_id          INT,
    prd_key         NVARCHAR(50),
    prd_nm          NVARCHAR(50),
    prd_cost        INT,
    prd_line        NVARCHAR(50),
    prd_start_dt    DATETIME,
    prd_end_dt      DATETIME
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.crm_sales_details', 'U') IS NOT NULL
    DROP TABLE bronze.crm_sales_details;
GO

-- Create sales details table
CREATE TABLE bronze.crm_sales_details (
    sls_ord_num     NVARCHAR(50),
    sls_prd_key     NVARCHAR(50),
    sls_cust_id     INT,
    sls_order_dt    INT,
    sls_ship_dt     INT,
    sls_due_dt      INT,
    sls_sales       INT,
    sls_quantity    INT,
    sls_price       INT
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
    DROP TABLE bronze.erp_cust_az12;
GO

-- Create ERP customer table
CREATE TABLE bronze.erp_cust_az12 (
    CID     NVARCHAR(50),
    BDATE   DATETIME,
    GEN     NVARCHAR(50)
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
    DROP TABLE bronze.erp_loc_a101;
GO

-- Create ERP location table
CREATE TABLE bronze.erp_loc_a101 (
    CID     NVARCHAR(50),
    CNTRY   NVARCHAR(50)
);


-- Drop table if it already exists
IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
    DROP TABLE bronze.erp_px_cat_g1v2;
GO

-- Create ERP product category table
CREATE TABLE bronze.erp_px_cat_g1v2 (
    id           NVARCHAR(50),
    cat          NVARCHAR(50),
    subcat       NVARCHAR(50),
    maintenance  NVARCHAR(50)
);
GO
