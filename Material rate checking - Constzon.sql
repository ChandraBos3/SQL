use eip
go


select dpo_material_code, location, min(dpo_net_rate) Miniumrate, max(dpo_net_rate) maxrate,Avg(dpo_net_rate) Avgrate, mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description
 from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.scm_d_purchase_orders b, lnt.dbo.job_master,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement
where hpo_po_number = dpo_po_number 
--and DPO_Material_Code ='310210910'
and mmat_material_code = DPO_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code and MMGRP_Company_Code= mmat_company_code
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and HPO_Company_Code=1 and HPO_Job_Code= job_code 
and MMAT_UOM_Code = UUOM_UOM_Code
and hpo_po_date between '01-jan-2017' and '30-Aug-2017' 

group by dpo_material_code, location,mmatc_description,MMGRP_Description, MMAT_UOM_Code,UUOM_Description








epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,

select * from lnt.dbo.location_master where company_code = 'LE'

select *from  eip.sqlmas.GEN_M_Materials

use EIP
GO
Select *from EPM.SQLPMP.GEN_M_Custom_Material_Groups


USE EPM
GO

select *from sys.tables where name like '%UOM%'

select * from eip.sqlscm.SCM_H_Purchase_Orders


use eip
go

drop table #link
select dpo_material_code,DPO_Net_Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code, DPO_Qty,DPO_PO_Number, hpo_po_date, DPO_Value,MMAT_Material_Description, MMC_Description, location, HPO_Currency_Code,HPO_Last_Amendment_Number
,HPO_BA_Code, vendor_description
 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.scm_d_purchase_orders b, lnt.dbo.job_master,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category
 , lnt.dbo.vendor_master j
where hpo_po_number = dpo_po_number 
--and MMAT_Material_Description like'%station%'
---and left (dpo_material_code,1) in ('9')
--and MMGRP_Description like '%station%'
--and mmc_description like'%ready%'
and HPO_Last_Amendment_number=DPO_Amendment_Number
and mmat_material_code = DPO_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code and MMGRP_Company_Code= mmat_company_code and MMATC_Class_Code = c.MMGRP_Class_Code
and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and HPO_Company_Code=1 and HPO_Job_Code= job_code 
and HPO_BA_CODE= j.vendor_code
and j.company_code =1
--and HPO_JOB_CODE in ('QGMAP013')
and MMAT_UOM_Code = UUOM_UOM_Code
and hpo_po_date between '01-Oct-2017' and '04-Dec-2017'
and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1
and MMAT_Company_Code= 1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Company_Code=1 and LMMCLM_Material_Category_Code= MMC_Material_Category_Code
and MMGRP_Company_Code= 1
and HPO_DS_Code <>'8'
---and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')
--and DPO_Material_Code in ('610112001','610112001','611096010','611096013','611096012','614300006','614300010','614300010','614300020','614300030','614300040','614300050','614300060','614300000','614300005','614300005','615300011','6C41M0001000000','6C41M0001000001','6C41M0001000002','6C41M0001000003','6C42M0001000001','6C42M0001000000','6C43M0001000000','6C43M0001000001')
--and job_code in ('QOCSD019','CTTRA015','LE150574','LE160072','LE120318','LE120451','LE080156','LE140913','LE16D080','LE16D109','LE131284','LE131077','LE17D088','LE160914','LE140002','LE170554','LE160491','QGMAP013','LCBAF013','LE100260','LE090062','DGMAP014','CGMAP014','LE090397','LE170524','LE130465','LE120422','LE080192','YGFAA018','LE16D103','LE090333','LE160732','LE140586','LE160361','LE17D097','QGISD015')

--Group by dpo_material_code, location,mmatc_description,MMGRP_Description, MMAT_UOM_Code,UUOM_Description,job_code,DPO_Qty,DPO_PO_Number
Update #link set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),
						MMC_Description=replace(MMC_Description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),
						MMC_Description=replace(MMC_Description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),
						MMC_Description=replace(MMC_Description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),
						MMC_Description=replace(MMC_Description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),
						MMC_Description=replace(MMC_Description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),
						MMC_Description=replace(MMC_Description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),
						MMC_Description=replace(MMC_Description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),
						MMC_Description=replace(MMC_Description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
select * from #link


--new prog: tested

drop table #link
select dpo_material_code,DPO_Net_Rate,DPO_Basic_Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,job_description,(DPO_Qty - DPO_Cancelled_Qty) Volume,DPO_PO_Number, hpo_po_date, ((DPO_Qty - DPO_Cancelled_Qty)*DPO_Net_Rate) Value,MMAT_Material_Description, MMC_Description, location, HPO_Currency_Code,HPO_Last_Amendment_Number
,HPO_BA_Code, vendor_description, sector_code, bu_code , SBG_Code
 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.scm_d_purchase_orders b, lnt.dbo.job_master,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category
 , lnt.dbo.vendor_master j

 where hpo_po_number = dpo_po_number 

 and MMGRP_MG_Code= MMAT_MG_Code and MMGRP_Company_Code= 1 and MMAT_Material_Code= DPO_Material_Code
and MMATC_Class_Code = MMGRP_Class_Code
and HPO_Last_Amendment_number=DPO_Amendment_Number
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Material_Category_Code= MMC_Material_Category_Code
and MMAT_Company_Code=1 and HPO_Company_Code=1
--and left (dpo_material_code,1) in ('9')

and HPO_BA_CODE= j.vendor_code
and j.company_code = 'LE'
and HPO_PO_Date between '01-Jul-2017' and '09- Feb-2018'
and MMAT_UOM_Code = UUOM_UOM_Code
and LMMCLM_Company_Code=1 
and HPO_Job_Code =job_code
and HPO_DS_Code ='3'

 update #link set MMATC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMATC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
 update #link set mmgrp_description= replace(replace(replace(replace(replace(replace(replace(replace(replace(mmgrp_description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set MMC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set MMAT_Material_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

select * from #link

alter table #link add ICdesc varchar(100)
alter table #link add BUdesc varchar(100)
alter table #link add Jobdesc varchar(200)
alter table #link add Locdesc varchar(200)
alter table #link add sbgdesc varchar (200)


UPDATE a SET ICdesc = b.Sector_Description
from #link a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #link a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #link a, LNT.dbo.job_master b
WHERE a.job_code = b.job_code 
AND b.Company_Code='LE'

UPDATE a SET Locdesc  = b.region_description
from #link a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

UPDATE a SET sbgdesc = b.SBG_Description
from #link a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 

alter table #LINK add NEWOLDCODE varchar(100)

uPDATE A SET NEWOLDCODE ='NEW'
FROM #LINK A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DPO_MATERIAL_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='MATR'
AND MSR_Attribute_Combination_Value IS NOT NULL

select *from #link



---sample
	select *from epm.sqlpmp.GEN_M_Material_Category where MMC_Description LIKE '%READY%'
	_=
	select *from epm.SQLpmp.Gen_M_Standard_Resource_Request

	SELECT * from  eip.sqlmas.GEN_M_Materials where MMAT_COMPANY_CODE ='1' 
	AND mmat_inserted_on >= '01-Jan-2017'


	select *from eip.sqlmas.GEN_M_Materials where MMAT_Material_Code LIKE '%6e4%' and job

	select *from epm.sqlpmp.GEN_M_Material_Category

	Select *from eip.sqlscm.scm_d_purchase_orders
