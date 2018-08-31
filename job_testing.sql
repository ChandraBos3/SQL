
DROP TABLE #TEMP
USE LNT
GO


select CAST (NULL AS VARCHAR(15)) TCM_Job_Code,	job_description,	long_description,	job_highlight,	CAST (0 AS MONEY) original_contract_value,	CAST (0 AS MONEY)revised_contract_value,	CAST (NULL AS DATE) actual_start_date,	CAST (NULL AS DATE) expected_start_date,	CAST (NULL AS DATE) actual_end_date,	CAST (NULL AS DATE) expected_end_date,	
CAST (NULL AS VARCHAR(15)) TCM_EPM_Tag,	CAST (NULL AS DATE)TCM_Inserted_On,	CAST (NULL AS DATE)TCM_Updated_On,	CAST (NULL AS DATE)TCM_EIP_Start_Date,	CAST (NULL AS VARCHAR(15)) TCM_PMP_TAG,	bu_code,	site_code,	customer_code,	job_type,	job_main_tag,job_status,	job_operating_group,	job_nature,Zone_Code,Sector_Code,	
region_code, Cluster_Code, Sub_BU_Code,	lOCATION, CAST (NULL AS VARCHAR(200)) Location_description,	SBG_Code, Job_Code
INTO #TEMP
from lnt.dbo.job_master A

where sector_code = 'B' and BU_Code ='J' and job_active ='y' and company_code ='LE' AND MAIN_SUB_DEPT = 'M' and job_code like 'LE%'

select *from #temp

UPDATE A SET  a.TCM_Job_Code= b.TCM_Job_Code, a.tcm_epm_tag = b.TCM_EPM_Tag , a.tcm_inserted_on=b.tcm_inserted_on, a.tcm_updated_on =b.tcm_updated_on, a.tcm_eip_start_date = b.tcm_eip_start_date, a.tcm_pmp_tag=b.tcm_pmp_tag
   FROM #TEMP a, epm.sqlepm.EPM_M_Control_Master b
   WHERE b.TCM_Job_Code= a.JOB_CODE 

UPDATE A SET  a.original_contract_value = b.original_contract_value, a.revised_contract_value = b.revised_contract_value, a.actual_start_date=b.actual_start_date,	a.expected_start_date=b.expected_start_date,a.actual_end_date=b.actual_end_date,a.expected_end_date=b.expected_end_date
FROM #TEMP a, lnt.dbo.job_overview b 
where b.job_code =a.job_code

update a set a.location_description = b.region_description
from #temp a, lnt.dbo.location_master b
where b.region_code = a.location
and b.company_code='LE'

SELECT *FROM #TEMP

select *from lnt.dbo.location_master

   use epm
   go
   select *from epm.sqlepm.EPM_M_Control_Master

---AND A.job_code = 'LE130804'

SELECT *FROM epm.sqlepm.EPM_M_Control_Master, #TEMP WHERE TCM_Job_Code= JOB_CODE  AND TCM_Job_Code = 'LE130804'

select *from epm.sqlepm.EPM_M_Control_Master where tcm_job_code = 'LE090184'

USE LNT
GO

SELECT *FROM SYS.TABLES WHERE NAME LIKE '%JOB%'


select *from lnt.dbo.bu_master_for_site 
select *from lnt.dbo.job_overview

select *from lnt.dbo.job_main_tag_master

select *from lnt.dbo.Job_Operating_Group_Master

select *from lnt.dbo.job_nature_master

select *from lnt.dbo.job

use eip

go

select *from sys.tables where name like '%epm%'