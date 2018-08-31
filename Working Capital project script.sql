DROP TABLE #TEMP1
SELECT JCRCostFor_AC, Cost_Cum, CostCompPC,* FROM PMS.DBO.JOB_PERFORMANCE WHERE JOB_CODE='DITA1419' AND REVISION_TAG=2
SELECT * FROM CRM.DBO.Invoice_Valuation_Sheet WHERE JOB_CODE='DITA1419'

use PMS
GO
select a.job_code, b.Performance_date, a.Sector_Code, a.bu_code,c.contract_start_date, c.expected_end_date,a.job_status,
b.CostCompPC, b.InvCompPC,b.Invoice_Cum InvCum, b.Amount_Certified_Cum CertInv,CURRENCY_CODE, b.Total_OS, b.Net_Cash_Retention, b.Other_Current_Assets, b.Stock_Valued, b.Stock_Consum, b.Stock_FG,
b.Stock_Raw_Materials, b.Cost_Over_Invoice SOI, b.Vendor_Credit, b.Plant_Advance- b.Plant_Advance_Recovery plntadv,
b.Matrl_Advance-b.Matrl_Advance_Recovery matrladv, b.Mobile_Advance-b.Mobile_Advance_Recovery mobadv,
b.Other_Current_Liabil , b.Sales_Cum,b.BGTotal
into #temp1
from lnt.dbo.job_master a, PMS.dbo.Job_Performance b, PMS.dbo.job_overview c
where a.job_Code = c.job_code and a.job_code= b.Job_code
and b.Revision_Tag=2 and b.Performance_date>='01-Apr-2012'
and a.company_code='LE'
and a.job_type=1 and a.main_sub_dept='M'
--and a.job_code in ('LE100548')
AND CURRENCY_CODE ='inr'



alter table #temp1 add ICdesc varchar(100)
alter table #temp1 add BUdesc varchar(100)
alter table #temp1 add Jobdesc varchar(200)

UPDATE a SET ICdesc = b.Sector_Description
from #temp1 a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #temp1 a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #temp1 a, LNT.dbo.job_master b
WHERE a.job_code = b.job_code 
AND b.Company_Code='LE'

select *from #temp1


select *from PMS.dbo.Job_Performance
use lnt 
go
select *from sys.tables where name like '%status%'
select *from lnt.dbo.job_status_master

select *from pms.dbo.job_performance_status

select * from crm.dbo.invoice_header a, crm.dbo.invo


select job_Code, Order_no, invoice_type, Customer_code,* from crm.dbo.invoice_header where job_Code='mbbh7533'

select *from crm.dbo.invoice_header

-------
select A.job_Code, B.JOB_DESCRIPTION,C.SECTOR_DESCRIPTION, Order_no, invoice_type, A.Customer_code,* from crm.dbo.invoice_header a, lnt.dbo.job_master b, LNT.DBO.Sector_Master C 
where authorised_on is not null 
and a.job_code = b.job_code
and b.Sector_Code =c.Sector_Code
and b.company_code ='LE'
and a.invoice_date >='01-Jan-2010'
---------

select * from crm.dbo.Job_Order_Master where job_Code = 'mbbh7533'

select * from crm.dbo.Job_OS_Details where job_Code = 'MBBH7533' and Order_No='MBBH7533/00001'
and Invoice_Type='O' and Customer_Code='IO00677' 

use crm
GO
select *from sys.tables where name like '%cust%'

select *from crm.dbo.CRM_OS_Job_Customer_Details

select *from crm.dbo.invoice_group_master

select *from crm.dbo.Actual_Invoice_Type_Master
select *from CRM.DBO.Invoice_Valuation_Sheet where invoice

use CRM
GO
select *from sys.tables where name like '%type%'
select *from crm.dbo.Invoice_Valuation_Customer
use pms
go

select *from PMS.DBO.JOB_PERFORMANCE 

select *from crm.dbo.invoice_header

use EIP
GO
select *from sys.tables where name like '%type%'