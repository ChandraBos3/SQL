drop table #temp
use EIP 
GO
Select HISS_Date, DISS_Debit_Job_Code,Job_description,Sector_Description,q.bu_description, DISS_Material_Code, HISS_Currency_Code, DISS_Rate, DISS_Value, DISS_Qty, DISS_Indent_Number,DISS_Issue_Number, MTD_Trans_Type_Desc, MCUR_Description, DISS_Asset_code,DESCRIPTION, c.sector_code, c.bu_code,HISS_Warehouse_Code
into #temp
from EIP.SQLSCM.SCM_D_Issue, EIP.SQLSCM.SCM_H_Issue, eip.sqlmas.GEN_M_Transaction_Details, eip.sqlmas.GEN_M_Currencies, lnt.dbo.job_master c,lnt.dbo.Sector_Master d,asset.dbo.Plant_Master p, lnt.dbo.business_unit_master q
Where HISS_Issue_Number = DISS_Issue_Number
and HISS_ISSUE_TYPE_CODE = MTD_Trans_Type_Code AND HISS_Issue_Detail_Code = MTD_Trans_Detail_Code
and HISS_Currency_Code =MCUR_Currency_Code and c.company_Code = 'LE'

and HISS_Job_Code = Job_Code
and c.sector_code= d.Sector_Code 
and c.bu_code = q.bu_code 
AND q.Company_Code='LE'
and HISS_Date between '01-Jan-2017' and '31-Dec-2017'
and DISS_Asset_code = p.ASSET_CODE and p.company_code = 'LE'
and DISS_Asset_code is not NULL
--and DISS_Material_Code like '%3O41%'----not sure on this 3041, check for the new item group for fuel also.
--and left (DISS_material_code,1) in ('9')
--and DISS_Material_code ='9HT170036'
and c.company_code='LE'
and HISS_Company_Code =1
and c.Sector_Code ='b'
 update #temp set DESCRIPTION = replace(replace(replace(replace(replace(replace(replace(replace(replace(DESCRIPTION,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
select *from #temp 




select Job_code, asset_code,month(logsheet_entry_date), year(logsheet_entry_date),work_type,sum(no_of_hours), sum(work_done_qty), sum(diss_qty), sum(diss_value), DISS_Material_Code
from dbo.ams_asset_logsheet_Detail a, #temp where --asset_Code='0125454H' and 
hiss_date between a.logsheet_entry_date and a.logsheet_entry_date 
and a.job_code = DISS_Debit_Job_Code
and asset_Code = DISS_Asset_Code and MONTH(HISS_date) = month(logsheet_entry_date)
--and asset_Code='02720CMH'
and year(hiss_date)= year(logsheet_entry_date)
group by Job_code, asset_code,logsheet_entry_date,work_type,DISS_Material_Code,month(logsheet_entry_date), year(logsheet_entry_date)

select * from #temp where DISS_Asset_Code='02720CMH' 
select * from  dbo.ams_asset_logsheet_Detail a where logsheet_entry_date between '02-Aug-2017' and '31-Oct-2017' and
asset_Code='02720CMH' 

select * from sys.tables where name like '%log%'


drop table #temp
select distinct DISS_Material_Code, MMAT_Material_Description, MMGRP_Description 
into #temp
from EIP.SQLSCM.SCM_D_Issue, EIP.SQLSCM.SCM_H_Issue,   eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category
where HISS_Issue_Number = DISS_Issue_Number
and HISS_Date between '01-Jan-2017' and '31-dec-2017'
and mmat_material_code = DISS_Material_Code and mmat_mg_Code = MMGRP_MG_Code and MMGRP_Company_Code= mmat_company_code and MMATC_Class_Code = MMGRP_Class_Code
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code= 1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Company_Code=1 
Update #temp set mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #temp set mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #temp set mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

select *from #temp
use epm
go


select * from EIP.SQLSCM.SCM_D_Issue


Select distinct DISS_Issue_Number,HISS_BA_Code,vendor_description 
--into #temp
from EIP.SQLSCM.SCM_D_Issue, EIP.SQLSCM.SCM_H_Issue, lnt.dbo.vendor_master
Where HISS_Issue_Number = DISS_Issue_Number
and HISS_Date between '01-Jan-2017' and '30-Sep-2017'
and HISS_BA_Code= vendor_code

and HISS_Company_Code =1


use asset
go

select *from sys.tables where name like '%asset%'

select *from dbo.ams_asset_logsheet_Detail

use EIP
GO

Select *from sys.tables where name like '%ideal%'

use asset
go

select *from dbo.ams_h_work_orders

select *from asset.dbo.Plant_Master where ASSET_CODE in ('0276002H')
select *from EIP.SQLSCM.SCM_D_Issue where diss