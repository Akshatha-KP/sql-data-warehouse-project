--Data Consistency Checks
  SELECT 
        cid
       ,[CNTRY]
  FROM [Datawarehouse].[bronze].[erp_loc_a101]
  WHERE cid NOT IN (
  SELECT DISTINCT [cst_key]
  FROM [Datawarehouse].[bronze].[crm_cust_info])


  --Data Standardization and consistency

  Select Distinct CNTRY from [Datawarehouse].[bronze].[erp_loc_a101]

  Select * from [Datawarehouse].[bronze].[erp_loc_a101]
