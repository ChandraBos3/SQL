----1 ) Report for a Project - Work Category to compare the Planned Values Vs WO Issed Qty across Contractors

select * from eip.sqlmas.GEN_M_Item_Groups where MIGRP_IsActive='Y' and MIGRP_Company_code=1
and migrp_description like '%reinf%'

drop table #CSR

select DWO_Item_Code item, DWO_UOM_Code uom,a.HWO_BA_Code vendor, hwo_currency_code currency,hwo_job_Code Job,hwo_wo_number wono,sum(DWO_WO_Qty) Qty,sum(DWO_Item_Value) amount,
cast(0 as money) billedqty, cast(0 as money) billedamount, MJITC_Item_Description itemdesc, MJITC_Item_Group_Code groupcode,d.Sector_Code sectcode,job_description Jobdesc,
cast(null as varchar(200)) vendorname,cast(0 as money) scopeqty,
cast(0 as money) Planqty, cast(0 as money) PlanAmt, cast(0 as money) Avgworate,cast(0 as money) Avgbillrate,cast(0 as money) Avgplanrate ,
cast(0 as money) BalACEQty, cast(0 as money) BalWOQty, cast(0 as money) BalWOAmt
into #CSR
from eip.sqlwom.WOM_H_Work_Orders a, eip.sqlwom.WOM_D_Work_Orders, eip.sqlwom.WOM_M_Job_Item_Codes, lnt.dbo.job_master d
where a.HWO_WO_Number=DWO_WO_Number --and DWO_Item_Code='5112S0000008361'
and a.HWO_Job_Code= 'le120315'
and a.HWO_Job_Code= MJITC_Job_Code and MJITC_Item_Code= DWO_Item_Code
and MJITC_Item_Group_Code in (5112,1030,1045)
and a.HWO_Job_Code= d.job_code
and MJITC_Company_Code=1
group by DWO_Item_Code, DWO_UOM_Code, a.HWO_BA_Code, hwo_currency_code,hwo_job_Code,MJITC_Item_Group_Code,hwo_wo_number,MJITC_Item_Description,Sector_Code,job_description



select item, job,vendor, wono, sum(DWMBL_Qty) billqty, sum(DWMBL_Amount) billamt
 into #scbills
 from eip.sqlwom.WOM_H_Bills, eip.sqlwom.WOM_D_Bills, #CSR c
where HBILL_Bill_Number= DWMBL_Bill_Number
and DWMBL_Item_Code= item
and HBILL_WO_Number=wono
group by item, job,vendor, wono


select DVWID_Job_Code, DVWID_Work_Item_Code, DVWID_Vendor_Code, sum(DVWID_Quantity) plannedqty
into #planqty
 from epm.sqlpmp.PMP_D_ExecPlan_Vendor_Work_Item_Details,#csr b
where job= DVWID_Job_Code and item=DVWID_Work_Item_Code and DVWID_Vendor_Code=vendor
group by DVWID_Job_Code, DVWID_Work_Item_Code, DVWID_Vendor_Code

update a set vendorname = b.vendor_description
from #csr a, lnt.dbo.vendor_view b
where a.vendor= b.vendor_code and b.company_Code='LE'


Update a set scopeqty=lewipswi_approved_quantity
from #csr a, epm.sqlpmp.PMP_L_ExecPlan_Work_Item_PBS_SubContract_Work_Item b
where b.LEWIPSWI_Job_Code= a.job
and b.LEWIPSWI_SubContract_Work_Item_Code = a.item


--select * FROM  epm.sqlpmp.PMP_L_ExecPlan_Work_Item_PBS_SubContract_Work_Item where LEWIPSWI_SubContract_Work_Item_Code='6O11S0001000009'

--select * from epm.sqlpmp.PMP_D_ExecPlan_Vendor_Work_Item_Details where DVWID_Work_Item_Code='6O11S0001000009'


--select * from epm.sqlpmp.Gen_M_Standard_Resource_Request

Update a set planqty=plannedqty
from #csr a, #planqty b
where b.DVWID_Job_Code= a.job
and b.DVWID_Work_Item_Code = a.item and DVWID_Vendor_Code=vendor


Update a set billedqty = billqty, billedamount = billamt
from #CSR  a, #scbills b
where a.job= b.job and a.item = b.item and a.vendor= b.vendor and a.wono = b.wono

--select top 2 * from #scbills
--select top 2 * from #CSR

Update #CSR set avgworate = case when Qty = 0 then 0 else Amount / Qty end,
				avgbillrate = case when billedqty = 0 then 0 else billedamount/billedqty end,
				balaceqty = planqty-Qty ,
				balwoqty = Qty - billedqty,
				balwoamt = amount - billedamount


Update #csr set vendorname = replace(vendorname,char(9),'-'), jobdesc = replace(jobdesc, char(9),'-'),itemdesc = replace(itemdesc, char(9),'-')
Update #csr set vendorname = replace(vendorname,char(10),'-'), jobdesc = replace(jobdesc, char(10),'-'),itemdesc = replace(itemdesc, char(10),'-')

Update #csr set vendorname = replace(vendorname,char(11),'-'), jobdesc = replace(jobdesc, char(11),'-'),itemdesc = replace(itemdesc, char(11),'-')


Update #csr set vendorname = replace(vendorname,char(12),'-'), jobdesc = replace(jobdesc, char(12),'-'),itemdesc = replace(itemdesc, char(12),'-')

Update #csr set vendorname = replace(vendorname,char(13),'-'), jobdesc = replace(jobdesc, char(13),'-'), itemdesc = replace(itemdesc, char(13),'-')

Update #csr set vendorname = replace(vendorname,char(15),'-'), jobdesc = replace(jobdesc, char(14),'-'),itemdesc = replace(itemdesc, char(14),'-')
Update #csr set vendorname = replace(vendorname,'''','F'), jobdesc = replace(jobdesc, '''','F'),itemdesc = replace(itemdesc, '''','F')
Update #csr set vendorname = replace(vendorname,'"','-'), jobdesc = replace(jobdesc, '"','.'),itemdesc = replace(itemdesc, '"','.')

-------2 ) Report for a Project - to compare WO Vales with various Previous amendments and current amendments for a Work order

drop table #WODetails
drop table #Amdwo
drop table #AmdwoCurrent
drop table #WOBills


select HWO_Job_Code job, hwo_wo_number, a.HWO_BA_Code, a.HWO_Last_Amendment_Number, b.DWO_Item_Code, cast(0 as money) origWOQty, cast(0 as money) origWOValue, 
b.DWO_WO_Qty, b.DWO_Item_Value,
cast( 0 as money) prevamdqty, cast(0 as money) prevamdvalue , cast(0 as money) curramdqty, cast(0 as money) curramdvalue,
cast(0 as money) billedqty, cast(0 as money) billedamt, b.DWO_UOM_Code uom,a.HWO_Currency_Code currency,c.job_description jobdesc,c.Sector_Code IC,c.bu_code BU,
cast ( null as varchar(50)) UOMdesc, cast ( null as varchar(50)) Currdesc,cast(null as varchar(200)) vendordesc,MJITC_Item_Description itemdesc
into #WODetails
 from  eip.sqlwom.WOM_H_Work_Orders a, eip.sqlwom.wom_d_work_orders b , lnt.dbo.job_master c, eip.sqlwom.WOM_M_Job_Item_Codes
where --HWO_Job_Code='LE120315' and 
a.HWO_Job_Code = c.job_code  and a.HWO_Job_Code= MJITC_Job_Code and b.DWO_Item_Code= MJITC_Item_Code
and HWO_WO_Number='EF291WOD7000015' 
and a.HWO_Job_Code= b.DWO_Job_Code
and a.HWO_WO_Number= b.DWO_WO_Number

select a.HWOA_WO_Number, b.DWOA_Item_Code, sum(b.DWOA_WO_Qty) amdqty, sum(b.DWOA_Item_Value) amdval 
into #Amdwo
from eip.sqlwom.WOM_H_WOA_Request a, eip.sqlwom.WOM_D_WOA_Request b,#WODetails c
where a.HWOA_WO_Number = b.DWOA_WO_Number
and a.HWOA_Amendment_Number = b.DWOA_Amendment_Number
and c.hwo_wo_number = a.HWOA_WO_Number and dwo_item_code = b.DWOA_Item_Code
and a.HWOA_DS_Code=3
group by a.HWOA_WO_Number, b.DWOA_Item_Code


select a.HWOA_WO_Number, b.DWOA_Item_Code, sum(b.DWOA_WO_Qty) amdqty, sum(b.DWOA_Item_Value) amdval 
into #AmdwoCurrent
from eip.sqlwom.WOM_H_WOA_Request a, eip.sqlwom.WOM_D_WOA_Request b,#WODetails c
where a.HWOA_WO_Number = b.DWOA_WO_Number
and a.HWOA_Amendment_Number = b.DWOA_Amendment_Number
and c.hwo_wo_number = a.HWOA_WO_Number and dwo_item_code = b.DWOA_Item_Code
and a.HWOA_DS_Code not in ( 3,8)
group by a.HWOA_WO_Number, b.DWOA_Item_Code

select dwo_item_code item, hwo_ba_code vendor, hwo_wo_number wono, sum(DWMBL_Qty) billqty, sum(DWMBL_Amount) billamt
 into #WOBills
 from eip.sqlwom.WOM_H_Bills, eip.sqlwom.WOM_D_Bills, #WODetails c
where HBILL_Bill_Number= DWMBL_Bill_Number
and DWMBL_Item_Code= dwo_item_code
and HBILL_WO_Number=hwo_wo_number
group by dwo_item_code, hwo_ba_code, hwo_wo_number



Update a SET prevamdqty = amdqty, prevamdvalue = amdval
from #WODetails a,#Amdwo B
where hwo_wo_number = hwoa_wo_number and dwo_item_code = dwoa_item_code


Update a SET curramdqty = amdqty, curramdvalue = amdval
from #WODetails a,#AmdwoCurrent B
where hwo_wo_number = hwoa_wo_number and dwo_item_code = dwoa_item_code

Update a SET origwoQty = DWO_WO_Qty - Prevamdqty, origwoValue = dwo_item_value - prevamdvalue
from #WODetails a


Update a set billedqty  = billqty, billedamt = billamt
from #wodetails a, #WOBills b
where a.dwo_item_code = b.item and a.hwo_wo_number = wono and hwo_ba_code = vendor

Update a set uomdesc = UUOM_Description
from #wodetails a, eip.sqlmas.GEN_U_Unit_Of_Measurement
where a.uom = UUOM_UOM_Code

Update a set currdesc = MCUR_Short_Description
from #wodetails a, eip.sqlmas.GEN_M_Currencies
where a.currency = MCUR_Currency_Code


update a set Vendordesc = b.vendor_description
from #wodetails a, lnt.dbo.vendor_view b
where vendor_code= hwo_ba_code and b.company_Code='LE'


Update #WODetails set Vendordesc = replace(Vendordesc,char(9),'-'), jobdesc = replace(jobdesc, char(9),'-'),itemdesc = replace(itemdesc, char(9),'-')
Update #WODetails set Vendordesc = replace(Vendordesc,char(10),'-'), jobdesc = replace(jobdesc, char(10),'-'),itemdesc = replace(itemdesc, char(10),'-')

Update #WODetails set Vendordesc = replace(Vendordesc,char(11),'-'), jobdesc = replace(jobdesc, char(11),'-'),itemdesc = replace(itemdesc, char(11),'-')


Update #WODetails set Vendordesc = replace(Vendordesc,char(12),'-'), jobdesc = replace(jobdesc, char(12),'-'),itemdesc = replace(itemdesc, char(12),'-')

Update #WODetails set Vendordesc = replace(Vendordesc,char(13),'-'), jobdesc = replace(jobdesc, char(13),'-'), itemdesc = replace(itemdesc, char(13),'-')

Update #WODetails set Vendordesc = replace(Vendordesc,char(15),'-'), jobdesc = replace(jobdesc, char(14),'-'),itemdesc = replace(itemdesc, char(14),'-')
Update #WODetails set Vendordesc = replace(Vendordesc,'''','F'), jobdesc = replace(jobdesc, '''','F'),itemdesc = replace(itemdesc, '''','F')
Update #WODetails set Vendordesc = replace(Vendordesc,'"','-'), jobdesc = replace(jobdesc, '"','.'),itemdesc = replace(itemdesc, '"','.')

select * from #WODetails

-----3 ) New Item Codes Generated and list of Work Orders the same has been used

drop table #stdcodes
select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode,cast (MSRR_Inserted_On as date) MSRR_Inserted_On, cast (msrr_approved_on as date) msrr_approved_on
into #stdcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE' 
and a.MSRR_Resource_Type_Code='SCPL'
and c.msr_resource_code = a.msr_resource_code --and  msrr_standardized_description not like '%work%group%'
--and  msrr_standardized_description not like '%as%described%further%'

select *from EPM.sqlpmp.Gen_M_Standard_Resource


--select * from #stdcodes



update #stdcodes set stddesc = replace(stddesc, char(9),'-'), scopedesc = replace(scopedesc,char(9),'-')
update #stdcodes set stddesc = replace(stddesc, char(10),'-'), scopedesc = replace(scopedesc,char(10),'-')
update #stdcodes set stddesc = replace(stddesc, char(11),'-'), scopedesc = replace(scopedesc,char(11),'-')
update #stdcodes set stddesc = replace(stddesc, char(12),'-'), scopedesc = replace(scopedesc,char(12),'-')
update #stdcodes set stddesc = replace(stddesc, char(13),'-'), scopedesc = replace(scopedesc,char(13),'-')
update #stdcodes set stddesc = replace(stddesc, char(14),'-'), scopedesc = replace(scopedesc,char(14),'-')
update #stdcodes set stddesc = replace(stddesc, char(15),'-'), scopedesc = replace(scopedesc,char(15),'-')
update #stdcodes set stddesc = replace(stddesc, '''','-'), scopedesc = replace(scopedesc,'''','-')
update #stdcodes set stddesc = replace(stddesc, '"','-'), scopedesc = replace(scopedesc,'"','-')



--select * from #stdcodes

select a.HWORQ_Job_Code jobcode,  a.HWORQ_Request_Number WORnumber, stdcode, right(b.DWORQ_Item_Code,6)  scope, DWORQ_Item_Code Scopecode,b.DWORQ_Item_Rate rate, b.DWORQ_Qty,b.DWORQ_UOM_Code,f.UUOM_Description,
b.DWORQ_Item_Value itemvalue, d.Sector_Code IC,
scopedesc, stddesc, HWORQ_WOT_Code, e.MIGRP_Description category, d.job_description, HWORQ_Date,location, MSRR_Inserted_On, msrr_approved_on, HWORQ_Currency_Code
into #mark
from eip.sqlwom.WOM_H_Work_Order_Request a, eip.sqlwom.WOM_D_Work_Order_Request b, #stdcodes c, lnt.dbo.job_master d,epm.sqlpmp.GEN_M_Item_Groups e, eip.sqlmas.GEN_U_Unit_Of_Measurement f

where a.HWORQ_Request_Number= b.DWORQ_Request_Number and c.itemscope = b.DWORQ_Item_Code and a.HWORQ_Job_Code = d.job_code and f.UUOM_UOM_Code= dworq_uom_code
and a.HWORQ_Date between '01-Jan-2018' and '28-Mar-2018' --and c.stddesc not like 'Work Group%' 
and e.MIGRP_Item_Group_Code = left(stdcode,4) 
and d.job_operating_group<>'I' 
--and DWORQ_Item_Code = '6C11S000G000004'

--select *from eip.SQLWOM.WOM_T_Document_Approvals where TWODA_Document_Reference_Number = 'EC551WOD7000058'

order by 3



ALTER TABLE #mark add markupdescr varchar (500)
ALTER TABLE #mark add markupcode varchar (15)
ALTER TABLE #mark add markupdesc varchar (100)

UPDATE A SET a.markupdescr= MMKUP_DESCRIPTION,a.markupcode= MMKUP_markup_code, a.markupdesc= MMKCT_Description   FROM #mark a, eip.sqlmas.GEN_M_Markup b,eip.sqlmas.GEN_M_Markup_Categories c
where MMKUP_Item_Group_Code = left(stdcode,4)
AND B.MMKUP_Job_Code = a.JobCode
and MMKUP_Markup_Code = c.MMKCT_MC_Code
and b.mmkup_company_code ='1'


update #mark set markupdescr = replace(markupdescr, char(9),'-')
update #mark set markupdescr = replace(markupdescr, char(10),'-')
update #mark set markupdescr = replace(markupdescr, char(11),'-')
update #mark set markupdescr = replace(markupdescr, char(12),'-')
update #mark set markupdescr = replace(markupdescr, char(13),'-')
update #mark set markupdescr = replace(markupdescr, char(14),'-')
update #mark set markupdescr = replace(markupdescr, char(15),'-')
update #mark set markupdescr = replace(markupdescr, '''','-')
update #mark set markupdescr = replace(markupdescr, '"','-')
select *from #mark


----Additional
DROP TABLE #SCODES
select  ITEMScope,stddesc,scopedesc, stdcode,MSRR_Inserted_On, msrr_approved_on, cast ( null as varchar(500)) category, cast ( null as varchar(50)) MJITC_IsActive, cast ( null as varchar(500)) markupdescr into #scodes from #stdcodes 


UPDATE A SET a.category = MIGRP_Description  FROM #scodes a, epm.sqlpmp.GEN_M_Item_Groups b
where MIGRP_Item_Group_Code = left(ITEMSCOPE,4)

UPDATE A SET A.MJITC_IsActive = B.MJITC_ISACTIVE FROM #scodes a,eip.sqlwom.wom_m_job_item_codes B
WHERE MJITC_Item_Code= itemscope
and MJITC_Company_Code=1
and B.MJITC_IsActive ='Y'


select *from #scodes
UPDATE A SET a.markupdescr= MMKUP_DESCRIPTION  FROM #scodes a, eip.sqlmas.GEN_M_Markup b
where MMKUP_Item_Group_Code = left(ITEMSCOPE,4)
AND B.MMKUP_Job_Code =
SELECT *FROM #scodes 

, epm.sqlpmp.GEN_M_Item_Groups b, eip.sqlwom.wom_m_job_item_codes c

select *from epm.sqlpmp.GEN_M_Item_Groups where MIGRP_Item_Group_Code LIKE ('%6O21%')

 




select * from  eip.sqlmas.GEN_U_Unit_Of_Measurement f

-- New Prog for selecting S/C

select HWO_BA_Code, Count(HWO_WO_Number) WOCount, SUM(HWO_WO_Amount) WOAMOUNT from eip.sqlwom.WOM_H_Work_Orders

WHERE HWO_WO_Date >= '01-Apr-2016' and HWO_Company_Code = 72 and HWO_Company_Code = 1 
GROUP BY HWO_BA_Code

select *from eip.sqlwom.WOM_D_Work_Order_Request where  DWORQ_Request_Number= 'EC551WOR7000057'

use lnt
go

select *from lnt.dbo.region_master


select  ITEMScope,MIGRP_Description category,stddesc,scopedesc,stdcode,MSRR_Inserted_On, msrr_approved_on from #stdcodes, epm.sqlpmp.GEN_M_Item_Groups
where MIGRP_Item_Group_Code = left(stdcode,4) 


select *from lnt.dbo.job_master  where  job_code  in ('LE150104',
'LE150994',
'LE160560',
'LE160806',
'LE170243',
'LE170689')

use lnt 

select *from CRM.DBO.Invoice_Valuation_SHEET where  job_code  in ('LE090183','LE090521','LE090348','LE090565','LE090264','LE090476','LE090544','LE100235','LE100546','LE100580','LE100023','LE100547','LE100249','LE100056','LE100387','LE110319','LE110689','LE110045','LE110007','LE110253','LE110048','LE110347','LE110458','LE110232','LE120658','LE120623','LE120524','LE120310','LE120146','LE120375','LE120388','LE120030','LE131436','LE130215','LE130119','LE130236','LE131435','LE130256','LE140113','LE131182','LE140336','LE140713','LE130257','LE130465','LE130804','LE140274','LE140296','LE140313','LE140367','LE140639','LE140714','LE140715','LE140797','LE140971','LE150291','LE160008','LE160169','LE160322','LE150952','LE170552','LE170553','LE170554','LE170840','LE170917')
