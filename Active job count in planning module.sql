
---ACE Jobs
select TCM_Job_Code Job_code, 'ACE' module , maxdate jcrdate , b.bpcode
--into #acejobs
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
										where s.TPBP_PST_Code = 2000 AND 
												s.TPBP_DS_Code IN ('BPDS0003','BPDS0002')  AND s.TPBP_DS_Code IS NOT NULL
										group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 

drop table #jobmaster
select TCM_Job_Code Job_code,job_description, c.sector_code,  d.sector_description, e.bu_description,'PMP' module ,c.job_operating_group, cluster_code, Year(TCM_Inserted_on) LINKED_Year,cast ( null as varchar(200) ) cluster_desc
into #jobmaster
from epm.sqlepm.EPM_M_Control_Master ,   lnt.dbo.job_master c, lnt.dbo.Sector_Master d, lnt.dbo.business_unit_master e
where  TCM_Job_Code = job_code and d.sector_code = c.sector_code and e.bu_code =c.bu_code
and  c.company_code='LE' and job_status in ( 'C','R') 
--and c.job_operating_group <>'I'

and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 


UPDATE a SET cluster_desc = b.Cluster_Description
from #jobmaster a, lnt.dbo.cluster_master b
WHERE a.cluster_code = b.Cluster_Code 

select *from #jobmaster

select * from lnt.dbo.business_unit_master

use EPM
go

select *from epm.sqlepm.EPM_M_Control_Master