use EPM
GO

drop table #joblist

select TCM_Job_Code Job_code, 'PMP' module , maxdate jcrdate , b.bpcode
into #joblist 
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 3000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' )
--and job_status in ( 'P','B') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 

--drop table #acejobs

SELECT TCM_Job_Code Job_code, 'ACE' module , maxdate jcrdate , b.bpcode
into #acejobs
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 2000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003','BPDS0002')  AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' 
and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 




select a.*, b.job_description, b.Sector_Code, D.job_status,c.revised_contract_value,location, InvCompPC, CostCompPC, c.original_contract_value, gm_per
from #joblist a, lnt.dbo.job_master b,lnt.dbo.job_overview c, CRM.DBO.Invoice_Valuation_SHEET D
 where a.job_code = b.job_code and b.job_code=c.job_code
 AND D.JOB_CODE = A.JOB_CODE AND D.valuation_month=12 AND D.valuation_year=2017
 AND Currency_TAG='c'
 and a.job_code in ('LE150316'

select a.*, b.job_description, b.Sector_Code, c.revised_contract_value from #acejobs a, lnt.dbo.job_master b, lnt.dbo.job_overview c
where a.job_code= b.job_code and b.job_code=c.job_code and a.Job_code in ('LE150316')

select job_code, org_contract_value, rev_contract_value, InvCompPC, CostCompPC from CRM.DBO.Invoice_Valuation_SHEET  where job_code in ('LE150316')
AND valuation_year=2017 and  Currency_TAG='c'
--AND valuation_month=11 

select job_code, invcompc, costcompc from 
select *from lnt.dbo.job_master

select *from lnt.dbo.Sector_Master

use lnt
go

select *from lnt.dbo.job_overview

select *from CRM.DBO.Invoice_Valuation_SHEET where job_code in ('LE150316')

select *from lnt.dbo.job_master where job_code in ('LE150316')
use eip
go
select *from sys.tables where name like '%status%'

select *from CRM.DBO.Invoice_Valuation_SHEET 


select a.job_code, a.job_description, a.Sector_Code, D.job_status,b.revised_contract_value,location, InvCompPC, CostCompPC, b.original_contract_value, gm_per
INTO #TEMP
from  lnt.dbo.job_master a,lnt.dbo.job_overview b, CRM.DBO.Invoice_Valuation_SHEET D 
 where a.job_code = b.job_code 
 AND D.JOB_CODE = A.JOB_CODE AND D.valuation_month=12 AND D.valuation_year=2017
 AND Currency_TAG='c'
 and A.job_status in ('C','R')
 AND A.COMPANY_CODE ='LE'
 AND A. main_sub_dept ='M'

 SELECT *FROM epm.sqlepm.EPM_M_Control_Master WHERE TCM_PMP_TAG ='Y' AND TCM_Job_Code = 'LE160011'

 DROP TABLE #TEMP1
 SELECT  job_code, CostCompPC 
 into #temp1
 FROM CRM.DBO.INVOICE_VALUATION_SHEET WHERE Currency_Tag ='c' and valuation_month=12 AND valuation_year=2017
 select *from #temp1


 select job_code, costcomppc from #temp,  epm.sqlepm.EPM_M_Control_Master where TCM_Job_Code = JOB_CODE AND TCM_PMP_TAG ='Y'

