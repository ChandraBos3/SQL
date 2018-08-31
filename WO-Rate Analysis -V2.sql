use eip
GO

drop table #billlist

select d.sector_code,d.Sector_Description, a.HBILL_Job_Code, c.job_description, a.HBILL_WO_Number, a.HBILL_Bill_Number,b.DWMBL_PBS_Code,
cast(null as varchar(500)) Costpackage, cast(null as varchar(15)) workcategorycode,cast(null as varchar(500)) workCategory, 
b.DWMBL_Item_Code,
cast(null as varchar(500)) itemdesc,HWO_Currency_Code, cast( null as varchar(15))currencydesc,  b.DWMBL_Qty, b.DWMBL_Rate, b.DWMBL_Amount,b.DWMBL_Service_Tax_Componant_Total_Amount, b.dwmbl_vat_amount,
cast ( null as varchar(15) ) PlanningModule, job_status,job_active, cc_percentage, c.inserted_on, location, c.SBG_Code
into #billlist
from eip.sqlwom.wom_h_bills a , eip.sqlwom.wom_d_bills b, lnt.dbo.job_master c, lnt.dbo.sector_master d, eip.sqlwom.WOM_H_Work_Orders
WHERE
a.HBILL_Bill_Number = b.DWMBL_Bill_Number and HWO_WO_Number = a.HBILL_WO_Number
--and a.HBILL_Bill_Date>='01-Jan-2017' and hbill_bill_date <='311-Dec-2017' 
and a.HBILL_Job_Code= c.job_code
and c.Sector_Code = d.Sector_Code and c.company_code='LE' and c.company_code = d.Company_Code
--and HWO_WO_Number = DWO_WO_Number
--and dwmbl_item_code =dwo_item_Code

---AND HBILL_JOB_CODE = 'LE130413'
and HBILL_WO_Number in ('EE361WOD7000346','EE361WOD7000354','EF906WOD8000031','EG146WOD8000021','EF398WOD8000018','EF398WOD7000301','EF908WOD8000031','EF907WOD8000036','EE361WOD8000064','EE361WOD8000060','EH414WOD8000144','EF684WOD8000043','EH414WOD8000117','EH414WOD8000149','EF550WOD7000163','EF684WOD8000035','EC576WOD7000304','EC576WOD8000010','EF291WOD7000109','EF291WOD7000146','EF291WOD7000158','EF291WOD7000163','EC885WOD7000149','EF291WOD8000009','EF709WOD7000061','EC576WOD8000082','EH401WOD8000014','EH401WOD8000017','EH401WOD8000024','EH401WOD8000025','EH401WOD8000028','EH401WOD8000029','EH401WOD8000030','EH401WOD8000031','EG745WOD7000009','EF715WOD7000018','EG034WOD7000010','EB053WOD7000097','EC402WOD7000017','EC402WOD7000016','EE563WOD7000066','ED205WOD6000040','EA411WOD6000029','ED326WOD6000069','EF715WOD7000019','E8404WOD6000017','E9231WOD7000012','ED205WOD6000032','EF831WOD7000041','ED203WOD6000018','ED203WOD6000029','EG520WOD7000011','EG466WOD7000006','EF305WOD7000032','EF893WOD8000014','EF674WOD7000100','EF893WOD7000065','EB021WOD7000053','EG377WOD7000030','ED204WOD7000062','EF893WOD7000082','EF831WOD7000054','EF674WOD7000049','EB021WOD7000050','EG035WOD7000004','EG448WOD7000039','EG377WOD7000020','EF807WOD7000019','EF674WOD7000107','EG377WOD7000021','EF890WOD7000050','EG247WOD8000012','EG247WOD8000013','EE563WOD7000016','ED326WOD7000048','EF893WOD8000019','EB021WOD8000014','ED326WOD8000039','EC581WOD8000006','EF674WOD8000014','EE563WOD7000081')
--and c.main_sub_dept='M'--job 
--and HWO_WOT_Code = '105'




Update a set Costpackage = MPBS_Description
from #billlist a, eip.sqlmas.GEN_M_Project_Breakdown_Structure
where a.hbill_job_Code = MPBS_Job_Code
and MPBS_PBS_Code= a.dwmbl_pbs_code
and MPBS_Company_Code=1

Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #billlist a, eip.sqlwom.wom_m_job_item_codes
where a.hbill_job_Code = MJITC_Job_Code
and MJITC_Item_Code= a.dwmbl_item_code
and MJITC_Company_Code=1


Update a set workCategory = b.MIGRP_Description
from #billlist a, EIP.SQLMAS.GEN_M_ITEM_GROUPS B
where workcategorycode= b.MIGRP_Item_Group_Code


Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #billlist a, eip.sqlmas.GEN_M_Currencies b
where HWO_Currency_Code= b.MCUR_Currency_Code 



update a set PlanningModule = case when B.TCM_PMP_TAG='Y' then 'New Plan' else 'Old' End
from #billlist a,  epm.sqlepm.EPM_M_Control_Master B
where a.hbill_job_code = b.TCM_Job_Code



Update #billlist set itemdesc = replace(itemdesc , char(9),'-'), costpackage=replace(costpackage, char(9),'-')

Update #billlist set itemdesc = replace(itemdesc , char(10),'-'),costpackage=replace(costpackage, char(10),'-')

Update #billlist set itemdesc = replace(itemdesc , char(11),'-'),costpackage=replace(costpackage, char(11),'-')

Update #billlist set itemdesc = replace(itemdesc , char(12),'-'),costpackage=replace(costpackage, char(12),'-')

Update #billlist set itemdesc = replace(itemdesc , char(13),'-'),costpackage=replace(costpackage, char(13),'-')

Update #billlist set itemdesc = replace(itemdesc , char(14),'-'),costpackage=replace(costpackage, char(14),'-')

Update #billlist set itemdesc=replace (itemdesc , '''','f')
Update #billlist set itemdesc=replace (itemdesc , '"','i')

alter table #billlist add BUdesc varchar(100)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE a.HBILL_Job_Code= c.job_code
AND c.BU_CODE = d.bu_code


alter table #billlist add sbgdesc varchar (200)

UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 



alter table #billlist add Locdesc varchar(100)

UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

select * from #billlist 



alter table #billlist add BUdesc varchar(100)
alter table #billlist add sbgdesc varchar (200)
alter table #billlist add Locdesc varchar(100)
alter table #billlist add city varchar (200)
alter table #billlist add state1 varchar (200)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE hbill_Job_Code= c.job_code
AND c.BU_CODE = d.bu_code


UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 





UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'


update a set city =UCITY_Name, state1=USTAT_Name
 from #billlist a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and Hbill_Job_Code =mjob_job_code

 select *from #billlist


