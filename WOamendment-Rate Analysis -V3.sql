use eip
GO

drop table #billlist

select d.sector_code,d.Sector_Description, HWOA_Job_Code, c.job_description, HWOA_WO_Number, DWOA_Item_Code,
cast(null as varchar(15)) workcategorycode,cast(null as varchar(500)) workCategory, 
cast(null as varchar(500)) itemdesc,HWO_Currency_Code, cast( null as varchar(15))currencydesc, DWOA_WO_Qty, DWOA_Item_Rate, DWOA_Item_Value,dwoA_uom_code,
HWO_WOT_Code,MWOTP_Description, HWO_BA_Code,vendor_description, CAST( NULL AS VARCHAR(15)) NEWOLDCODE, cast (Null as date) code_Inserted_On, location, c.SBG_Code, HWOA_Native_Currency_WO_Amount, HWOA_WO_Amendment_Date, HWOA_Amendment_Number
,HWOA_DS_Code, DWOA_Markup_Code, DWOA_Version
into #billlist
from  lnt.dbo.job_master c, lnt.dbo.sector_master d, eip.sqlwom.WOM_H_WOA_Request , eip.sqlwom.WOM_D_WOA_Request ,lnt.dbo.vendor_master j, eip.SQLMAS.GEN_M_WO_Types,EIP.SQLWOM.WOM_H_Work_Orders  
WHERE HWOA_WO_Number = DWOA_WO_Number
AND HWOA_WO_Number = HWO_WO_Number
--and HWOA_WO_Amendment_Date >='30-Apr-2018' and HWOA_WO_Amendment_Date <='06-May-2018' 
and HWOA_Job_Code= c.job_code
and c.Sector_Code = d.Sector_Code and c.company_code='LE' and c.company_code = d.Company_Code and hwo_ba_code = j.vendor_code 
--and c.main_sub_dept IN ('M')--job 
--and HWO_WOT_Code = '105'
and HWOA_DS_CODE <> 8
and j.company_code = 'LE'
and hwo_company_code  = '1'
and HWO_WOT_code = MWOTP_WOT_Code
and len (dwoA_item_code) >= '9'
--and hwo_JOB_CODE = 'LE130413'
--AND HWO_WO_NUMBER IN ('EG745WOD7000009','EF715WOD7000018','EG034WOD7000010','EB053WOD7000097','EC402WOD7000017','EC402WOD7000016','EE563WOD7000066','ED205WOD6000040','EA411WOD6000029','ED326WOD6000069','E8404WOD6000017','E9231WOD7000012','ED205WOD6000032','ED203WOD6000018','ED203WOD6000029','EF715WOD7000019','EC576WOD7000304','EF291WOD7000109','EF291WOD7000146','EF291WOD7000158','EF291WOD7000163','EC576WOD8000010','EC885WOD7000149','EF709WOD7000061')

--and dwo_item_code in ('6C11S008N000006','6C11S00I0000001','6C1JS000U000009','6C1JS000U000010','6C1MS0009000015','6C26S000I000008','6C26S000I000009','6C26S000I000010','6C2BS000V000003','6C2BS000V000004','6C2BS000V000005','6C2BS000V000006','6C2BS000V000007','6C2BS000V000008','6C2BS000V000009','6C2BS000V000010','6C2BS000V000011','6C2BS000V000012','6C2BS000V000013','6C2BS000V000014','6C2BS000V000015','9100000000542','9100000000584','9100000000585','9100000000586','9100000000587','9100000000588','9100000000589','9100000000590','6C2IS0012000002','6C2IS0012000003','6C2IS0013000001','6C2IS0014000000','6C2IS0015000001','6C2IS0015000002','6C2IS002U000001','9100000000548')

---select *from eip.sqlwom.WOM_H_Work_Order_Request

uPDATE A SET NEWOLDCODE ='NEW', code_Inserted_On = c.MSRR_Inserted_On
FROM #BILLLIST A, EPM.SQLPMP.Gen_M_Standard_Resource B, EPM.SQLPMP.Gen_M_Standard_Resource_Request c
WHERE A.DWOA_Item_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='scpl'

and b.msr_resource_code = c.msr_resource_code 
--AND MSR_Attribute_Combination_Value IS NOT NULL




Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #billlist a, eip.sqlwom.wom_m_job_item_codes
where HWOA_Job_Code = MJITC_Job_Code
and MJITC_Item_Code= DWOA_Item_Code
and MJITC_Company_Code=1




Update a set workCategory = b.MIGRP_Description
from #billlist a, EIP.SQLMAS.GEN_M_ITEM_GROUPS B
where workcategorycode= b.MIGRP_Item_Group_Code


Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #billlist a, eip.sqlmas.GEN_M_Currencies b
where HWO_Currency_Code= b.MCUR_Currency_Code 





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
alter table #billlist add city varchar (200)
alter table #billlist add state1 varchar (200)

--ALTER TABLE #billlist add markupdescr varchar (500)
--ALTER TABLE #billlist add markupcode varchar (15)
--ALTER TABLE #billlist add markupdesc varchar (100)
--ALTER TABLE #billlist add adddesc varchar (2000)
uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE hwoA_Job_Code= c.job_code
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
 and HWOa_Job_Code =mjob_job_code


UPDATE A SET a.markupdescr= MMKUP_DESCRIPTION  , a.markupdesc= MMKCT_Description , a.markupcode = MMKUP_Markup_Code
FROM #billlist a, eip.sqlmas.GEN_M_Markup b,eip.sqlmas.GEN_M_Markup_Categories c
where MMKUP_Item_Group_Code = left(dwoA_item_code,4)
and MMKUP_MC_Code = c.MMKCT_MC_Code
AND MMKUP_Markup_Code=DWOA_Markup_Code
AND B.MMKUP_Job_Code = a.HWOA_Job_Code
and b.mmkup_company_code ='1'

UPDATE A SET a.adddesc = b.TEPWI_Additional_Description
from #billlist a, epm.sqlpmp.PMP_T_ExecPlan_Project_Work_Items b
where TEPWI_Job_Code = a.HWOA_Job_Code
and TEPWI_Work_Item_Code = a.DWOA_Item_Code
and tepwi_markup= dwoA_markup_code




Update #billlist set markupdescr = replace(markupdescr , char(9),'-')

Update #billlist set markupdescr = replace(markupdescr , char(10),'-')

Update #billlist set markupdescr = replace(markupdescr , char(11),'-')

Update #billlist set markupdescr = replace(markupdescr , char(12),'-')

Update #billlist set markupdescr = replace(markupdescr, char(13),'-')

Update #billlist set markupdescr = replace(markupdescr , char(14),'-')

Update #billlist set markupdescr=replace (markupdescr , '''','f')
Update #billlist set markupdescr=replace (markupdescr , '"','i')

Update #billlist set adddesc = replace(adddesc , char(9),'-')

Update #billlist set adddesc = replace(adddesc , char(10),'-')

Update #billlist set adddesc = replace(adddesc , char(11),'-')

Update #billlist set adddesc = replace(adddesc , char(12),'-')

Update #billlist set adddesc = replace(adddesc , char(13),'-')

Update #billlist set adddesc = replace(adddesc , char(14),'-')

Update #billlist set adddesc = replace(adddesc , '''','f')
Update #billlist set adddesc = replace(adddesc , '"','i')

alter table #billlist add Constzon_Applicable varchar (200)

UPDATE A SET a.Constzon_Applicable  = b.DWOAC_Rate_Applicable
from #billlist a
left join eip.SQLWOM.WOM_D_WOA_ConstZon_Details b  on 
hWOA_WO_Number = DWOAC_WO_Number
					AND DWOA_Item_Code = DWOAC_Item_Code AND DWOA_Version = DWOAC_Version AND DWOA_Markup_Code = DWOAC_Markup_Code


SELECT *FROM #billlist where len(dwoA_item_code) ='9' and newoldcode ='new'

USE EIP
GO
SELECT *FROM eip.sqlwom.WOM_D_WOA_Request

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



Select *from eip.sqlwom.WOM_d_Work_Orders where dwo_wo_number in ('RG926WOD7000001','EC576WOD7000304','EC885WOD7000149','EF709WOD7000061')


Select *from eip.sqlwom.WOM_h_Work_Orders where hwo_wo_number in  ('RG926WOD7000001','EC576WOD7000304','EC885WOD7000149','EF709WOD7000061','EF291WOD7000163','EF291WOD7000109','EF291WOD7000158','EF291WOD7000146')

select *from eip.sqlwom.WOM_h_Work_Order_Request where HWORQ_Request_Number in ('E2225WOR8000024')
select *from eip.sqlwom.WOM_d_Work_Order_Request where dworq_m
select *from eip.sqlwom.WOM_D_Work_Order_Request where DWORQ_Job_Code = 'LE131126' and dworq_item_code = '6C11S003D'

select *from eip.sqlwom.wom_m_job_item_codes where mjitc_item_description like '%laying%'

use eip

go

select *from sys.tables where name like '%mark%'

select *from epm.sqlpmp.PMP_T_ExecPlan_Project_Work_Items WHERE TEPWI_Additional_Description is not null
TEPWI_Additional_Description 

