use eip
GO

drop table #billlist

select d.sector_code,d.Sector_Description, HWORQ_Job_Code, c.job_description, HWORQ_Request_Number, DWORQ_Item_Code,
cast(null as varchar(15)) workcategorycode,cast(null as varchar(500)) workCategory, 
cast(null as varchar(500)) itemdesc,HWORQ_Currency_Code, cast( null as varchar(15))currencydesc, DWOrq_Qty, DWORQ_Item_Rate, DWORQ_Item_Value,
HWORQ_WOT_Code,MWOTP_Description, HWORQ_BA_Code,vendor_description, CAST( NULL AS VARCHAR(15)) NEWOLDCODE, location, c.SBG_Code, HWorq_Date

into #billlist
from  lnt.dbo.job_master c, lnt.dbo.sector_master d, eip.sqlwom.WOM_H_Work_Order_Request , eip.sqlwom.WOM_D_Work_Order_Request ,lnt.dbo.vendor_master j, eip.SQLMAS.GEN_M_WO_Types 
WHERE
HWORQ_Request_Number = DWORQ_Request_Number
and HWORQ_Date>='01-Dec-2017' and HWORQ_DATE <='28-Jan-2018' 
and HWORQ_Job_Code= c.job_code
and c.Sector_Code = d.Sector_Code and c.company_code='LE' and c.company_code = d.Company_Code and hwoRQ_ba_code = j.vendor_code 
and c.main_sub_dept IN ('M')--job 
--and HWO_WOT_Code = '105'
and HWORQ_DS_Code =3
and j.company_code = 'LE'
and HWORQ_Company_Code  = '1'
and HWORQ_WOT_Code = MWOTP_WOT_Code
--AND HWO_WO_NUMBER IN ( 'EC576WOD8000010') 

--and dwo_item_code in ('6C11S008N000006','6C11S00I0000001','6C1JS000U000009','6C1JS000U000010','6C1MS0009000015','6C26S000I000008','6C26S000I000009','6C26S000I000010','6C2BS000V000003','6C2BS000V000004','6C2BS000V000005','6C2BS000V000006','6C2BS000V000007','6C2BS000V000008','6C2BS000V000009','6C2BS000V000010','6C2BS000V000011','6C2BS000V000012','6C2BS000V000013','6C2BS000V000014','6C2BS000V000015','9100000000542','9100000000584','9100000000585','9100000000586','9100000000587','9100000000588','9100000000589','9100000000590','6C2IS0012000002','6C2IS0012000003','6C2IS0013000001','6C2IS0014000000','6C2IS0015000001','6C2IS0015000002','6C2IS002U000001','9100000000548')

----SELECT *FROM eip.sqlwom.WOM_H_Work_Order_Request

uPDATE A SET NEWOLDCODE ='NEW'
FROM #BILLLIST A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DWORQ_Item_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='scpl'
AND MSR_Attribute_Combination_Value IS NOT NULL




Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #billlist a, eip.sqlwom.wom_m_job_item_codes
where HWORQ_Job_Code = MJITC_Job_Code
and MJITC_Item_Code= DWORQ_Item_Code
and MJITC_Company_Code=1


select *from eip.sqlwom.wom_m_job_item_codes

select *from epm.SQLpmp.Gen_M_Standard_Resource_Request where MSR_Resource_Code in ('6C11S005Y000008')

Update a set workCategory = b.MIGRP_Description
from #billlist a, EIP.SQLMAS.GEN_M_ITEM_GROUPS B
where workcategorycode= b.MIGRP_Item_Group_Code


Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #billlist a, eip.sqlmas.GEN_M_Currencies b
where HWORQ_Currency_Code= b.MCUR_Currency_Code 





Update #billlist set itemdesc = replace(itemdesc , char(9),'-')

Update #billlist set itemdesc = replace(itemdesc , char(10),'-')

Update #billlist set itemdesc = replace(itemdesc , char(11),'-')

Update #billlist set itemdesc = replace(itemdesc , char(12),'-')

Update #billlist set itemdesc = replace(itemdesc , char(13),'-')

Update #billlist set itemdesc = replace(itemdesc , char(14),'-')

Update #billlist set itemdesc=replace (itemdesc , '''','f')
Update #billlist set itemdesc=replace (itemdesc , '"','i')

alter table #billlist add BUdesc varchar(100)
alter table #billlist add sbgdesc varchar (200)
alter table #billlist add Locdesc varchar(100)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE hwoRQ_Job_Code= c.job_code
AND c.BU_CODE = d.bu_code



UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 





UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

select * from #billlist 



select HBILL_Job_Code,job_description,PlanningModule,job_status, sector_description,job_status,job_active, cc_percentage, inserted_on, sum (dwmbl_amount) WO_BILL_AMT from #billlist  where HWO_Currency_Code ='72'
group by HBILL_Job_Code,job_description,Sector_Description,PlanningModule, job_status,job_active, cc_percentage, inserted_on

--where sector_code ='B'---one after another

select *from epm.sqlpmp.GEN_M_Activity_Groups

use epm 
go

select * from sys.tables where name like '%magrp%'


USE EIP
GO

SELECT *FROM SYS.TABLES WHERE name LIKE '%TYPE%'

select *from eip.SQLMAS.GEN_M_WO_Types

Select *from eip.sqlwom.WOM_H_Work_Orders where hwo_wo_number in ('E4650WOD7000012')

select *from eip.sqlwom.WOM_H_Work_Order_Request where HWORq_Request_Number in ('E4650WOR7000013')

Select *from eip.sqlwom.WOM_d_Work_Orders where dwo_wo_number in ('RG926WOD7000001','EC576WOD7000304','EC885WOD7000149','EF709WOD7000061')


Select *from eip.sqlwom.WOM_h_Work_Orders where hwo_wo_number in  ('RG926WOD7000001','EC576WOD7000304','EC885WOD7000149','EF709WOD7000061','EF291WOD7000163','EF291WOD7000109','EF291WOD7000158','EF291WOD7000146')

select *from eip.sqlwom.WOM_d_Work_Order_Request where dworq_request_number in ('RG960WOR7000002','EC576WOR7000361')