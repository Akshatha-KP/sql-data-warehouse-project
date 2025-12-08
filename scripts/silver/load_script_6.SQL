/* =====================================================================================
   Script Name  : Load Product Category Data - Silver Layer
   Author       : Akshatha Kumble Prabhu
   Description  :
       This script loads product category master data from the bronze layer into 
       the silver layer. No transformations are applied in this step; the purpose 
       is to promote raw category data into a structured, query-ready silver table.
   ===================================================================================== */

/* =====================================================================================
   Script Name  : Load Product Category Data - Silver Layer
   Author       : Akshatha Kumble Prabhu
   Description  :
       This script loads product category master data from the bronze layer into 
       the silver layer. No transformations are applied in this step; the purpose 
       is to promote raw category data into a structured, query-ready silver table.
   ===================================================================================== */

-- Insert product category data into Silver layer
INSERT INTO silver.erp_px_cat_g1v2 (
    id,             -- Product/Item Identifier
    cat,            -- Category
    subcat,         -- Subcategory
    maintenance     -- Maintenance classification
)
SELECT 
    id, 
    cat, 
    subcat,
    maintenance
FROM bronze.erp_px_cat_g1v2;   -- Source bronze table
