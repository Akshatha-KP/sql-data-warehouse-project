
 -- Data Consistency across keys

 Select DISTINCT CID from [Datawarehouse].[bronze].[erp_cust_az12]
  where CID NOT IN (Select DISTINCT [cst_key] from [Datawarehouse].[bronze].crm_cust_info)

  --Date Checks- Out of date range

  Select BDATE from [Datawarehouse].[bronze].[erp_cust_az12] where BDATE < '1900-01-01' OR BDATE > GETDATE()

  --Data Standardization and consistency

  Select DISTINCT GEN from [Datawarehouse].[bronze].erp_cust_az12
