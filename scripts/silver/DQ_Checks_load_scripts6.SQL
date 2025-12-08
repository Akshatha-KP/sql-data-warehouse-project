
  --Check for Unwanted Spaces

  Select  cat from [Datawarehouse].[bronze].[erp_px_cat_g1v2] 
  where TRIM(Cat) != cat


 
  Select  subcat from [Datawarehouse].[bronze].[erp_px_cat_g1v2] 
  where TRIM(subcat) != subcat


  select DISTINCT [maintenance] from [Datawarehouse].[bronze].[erp_px_cat_g1v2] 
