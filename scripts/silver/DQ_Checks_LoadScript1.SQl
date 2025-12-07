 --Checks for NULLS or duplicates in a Primary Key
--Expectation - NO results

SELECT 
	prd_id, 
	count(*) as Count_Prd_id
FROM [Datawarehouse].[bronze].[crm_prd_info]
Group by prd_id
Having Count(*) > 1 OR prd_id IS NULL

--Check for Unwanted spaces
--Expectation - No Results

Select 
* from [Datawarehouse].[bronze].[crm_prd_info]
Where prd_nm !=TRIM(prd_nm)

--Check for NULLS or Negative Numbers
--Expectation : No Results

Select 
prd_cost 
from [Datawarehouse].[bronze].[crm_prd_info]
WHERE Prd_cost < 0 OR Prd_cost IS NULL

----Data Standardization and Consistency

Select 
DISTINCT  prd_line
from [Datawarehouse].[bronze].[crm_prd_info]

-- Check for Invalid Date Orders
--Expectation is NO results

Select 
prd_id,
prd_start_dt,
Prd_end_dt
from [Datawarehouse].[bronze].[crm_prd_info]
where prd_start_dt > prd_end_dt
