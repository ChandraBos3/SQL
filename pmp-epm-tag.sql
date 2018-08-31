use EPM
GO

drop table #joblist
drop table #jobs

SELECT A.jOB_CODE, JOB_DESCRIPTION, AREA_CODE,COUNTRY_CODE, JOB_TYPE, job_operating_group, CAST(NULL AS VARCHAR(15)) PLANNING,
job_status,  country, city

INTO #JOBS
FROM LNT.DBO.JOB_MASTER A, LNT.DBO.job_Circular B
WHERE A.JOB_CODE = B.JOB_CODE AND COMPANY_CODE='le' AND MAIN_SUB_DEPT='m'


Update a set planning =  case when TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' then 'PMP' else 'EPM' end
from #jobs a, epm.sqlepm.EPM_M_Control_Master
where job_code = TCM_Job_Code


select * from #jobs where job_operating_group='I' and job_status not in ( 'P','B') and area_code='Q'

select TCM_Job_Code Job_code, 'PMP' module , maxdate jcrdate , b.bpcode, TCM_PMP_TAG
into #joblist 
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 3000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group ='I' )
--and job_status in ( 'P','B') )
--and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 

--drop table #acejobs



SELECT TCM_Job_Code Job_code, 'ACE' module , maxdate jcrdate , b.bpcode, TCM_PMP_TAG
into #acejobs
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 2000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003','BPDS0002')  AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group ='I' )
--and job_status in ( 'C','R') )
--and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 




select a.*, b.job_description, b.Sector_Code, D.job_status,c.revised_contract_value,location, InvCompPC, CostCompPC
from #joblist a, lnt.dbo.job_master b,lnt.dbo.job_overview c, CRM.DBO.Invoice_Valuation_SHEET D
 where a.job_code = b.job_code and b.job_code=c.job_code
 AND D.JOB_CODE = A.JOB_CODE AND D.valuation_month=9 AND D.valuation_year=2017
 AND Currency_TAG='c'
select a.*, b.job_description, b.Sector_Code, c.revised_contract_value from #acejobs a, lnt.dbo.job_master b, lnt.dbo.job_overview c
where a.job_code= b.job_code and b.job_code=c.job_code


select *from lnt.dbo.job_master

select *from lnt.dbo.Sector_Master

use lnt
go

select *from lnt.dbo.job_overview

select *from lnt.dbo.job_master