use eip
go



drop table #link

select dpo_material_code,DPO_Net_Rate,DPO_Basic_Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,(DPO_Qty - DPO_Cancelled_Qty) Volume,DPO_PO_Number, hpo_po_date, ((DPO_Qty - DPO_Cancelled_Qty)*DPO_Net_Rate) Value,MMAT_Material_Description, location, HPO_Currency_Code,HPO_last_Amendment_Number,  dpo_amendment_number
,HPO_BA_Code, vendor_description, p.sector_code, p.bu_code , p.SBG_Code, HPO_Warehouse_Code,HPO_DS_Code,HPO_PO_Basic_Value, HPO_PO_Net_Value, hpo_mr_number
,DPOT_Direct_Supply,DPOT_Freight_Value,DPOT_Packing_Forwarding_Value,DPOT_Others_Value,dpo_qty old_qty,
DPO_Value old_value, ((DPO_Qty - DPO_Cancelled_Qty) *(DPO_net_rate-dpo_basic_rate)) TaxRate
 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders   , eip.sqlscm.SCM_d_Purchase_Orders,
 lnt.dbo.job_master p,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials , eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement , lnt.dbo.vendor_master j
  ,eip.sqlscm.scm_d_purchase_order_terms f



where hpo_po_number = dpo_po_number 

--and hPO_last_amendment_Number  = dpo_amendment_number


--and MMAT_Material_Description like'%station%'
--and MMGRP_Description like '%station%'
--and left (dpo_material_code,1) in ('9')
and mmat_material_code = DPO_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code 
and MMGRP_Company_Code= mmat_company_code 
and MMATC_Class_Code = c.MMGRP_Class_Code 
and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and HPO_BA_CODE= j.vendor_code

and HPO_Company_Code=1 
and HPO_Job_Code= p.job_code 
and j.company_code = 'LE'
and p.company_code='LE'
--and HPO_JOB_CODE in ('LE130413')
and MMAT_UOM_Code = UUOM_UOM_Code
--and hpo_po_date between '01-Apr-2017' and '31-Mar-2018'
and MMAT_Company_Code= MMATC_Company_Code    
--and hpo_ds_code ='3'  -- and HPO_DS_Code <>'8' 
and dpo_isactive = 'y'

and hpo_po_number in ('E5317PO8000271','E5317PO8000209','E5346PO8000099')
and hpo_po_number = f.dpot_po_number and HPO_Last_Amendment_Number = f.dpot_amendment_number

and job_operating_group <>'I' 
--and left (dpo_material_code,1) in ('9')
---and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')

--and job_code in ('QOCSD019','CTTRA015','LE150574','LE160072','LE120318','LE120451','LE080156','LE140913','LE16D080','LE16D109','LE131284','LE131077','LE17D088','LE160914','LE140002','LE170554','LE160491','QGMAP013','LCBAF013','LE100260','LE090062','DGMAP014','CGMAP014','LE090397','LE170524','LE130465','LE120422','LE080192','YGFAA018','LE16D103','LE090333','LE160732','LE140586','LE160361','LE17D097','QGISD015')

--Group by dpo_material_code, location,mmatc_description,MMGRP_Description, MMAT_UOM_Code,UUOM_Description,job_code,DPO_Qty,DPO_PO_Number
Update #link set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
--select * from #link

alter table #link add ICdesc varchar(100)
alter table #link add BUdesc varchar(100)
alter table #link add Jobdesc varchar(200)
alter table #link add Locdesc varchar(200)
alter table #link add city varchar (200)
alter table #link add state1 varchar (200)
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

update a set city =UCITY_Name, state1=USTAT_Name
 from #link a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and job_code =mjob_job_code

UPDATE a SET sbgdesc = b.SBG_Description
from #link a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 

alter table #LINK add NEWOLDCODE varchar(100)

uPDATE A SET NEWOLDCODE ='NEW'
FROM #LINK A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DPO_MATERIAL_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='MATR'
--AND MSR_Attribute_Combination_Value IS NOT NULL

select *from #link

alter table #link add materialcategory VARCHAR (500)
alter table #link add PlanningCategory VARCHAR (500)


 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 


alter table #link add Constzon_Applicable VARCHAR (200)

UPDATE A SET a.Constzon_Applicable  = b.DPOCD_Rate_Applicable
from #LINK a
left join eip.SQLSCM.SCM_D_PO_ConstZon_Details b  on 
 DPOCD_PO_Number = DPO_PO_Number 
					AND DPOCD_Amendment_Number = hPO_last_Amendment_Number AND DPOCD_Material_Code = DPO_Material_Code


					alter table #LINK add EPM_Tag varchar (5)

Update a set EPM_Tag = TCM_EPM_Tag 
from #Link  a 

left join EPM.sqlepm.EPM_M_Control_Master b on JOB_CODE=TCM_Job_Code 



alter table #LINK add MR_Date Date


Update a set mr_date = hmr_mr_date

from #link a 

left join eip.sqlscm.SCM_h_Material_Request on 

 hmr_mr_number = HPO_MR_Number and HMR_Company_Code=1

 select *from #link
 
 alter table #LINK add mrnnumber varchar (50)
 alter table #LINK add mrndate Date
 alter table #LINK add mrnqty varchar (50)
 alter table #LINK add mrnvalue varchar (50)





 ---MRN-UPDATE

update a set mrnnumber= HMRN_MRN_Number, mrndate = HMRN_MRN_Date, mrnqty = DMRN_ACCEPTED_QTY , mrnvalue =DMRN_VALUE

from #link a,  
( select HMRN_MRN_Number, HMRN_PO_Number, HMRN_MRN_Date,  DMRN_ACCEPTED_QTY, DMRN_VALUE,DMRN_Material_Code
from  eip.sqlscm.SCM_H_MRN , eip.sqlscm.SCM_D_MRN b,#link c
where c.DPO_PO_Number = HMRN_PO_Number and HMRN_MRN_Number=b.DMRN_MRN_Number 
and c.DPO_Material_Code = B.DMRN_Material_Code ) d
where HMRN_PO_Number = a.DPO_PO_Number


 alter table #LINK add mrnumber varchar (50)
 alter table #LINK add mrdate Date



 
update a set mrnumber= d.HMR_MR_Number, mrdate = d.HMR_MR_Date

from #link a, ( select HMR_MR_Number,HMR_MR_Date
from   eip.sqlscm.SCM_H_Material_Request ,  eip.sqlscm.SCM_d_Material_Request b,#link c
where hmr_mr_number = HPO_MR_Number and hmr_mr_number = dmr_mr_number
and c.DPO_Material_Code =b.DMR_Material_Code) d


select *from #link

select *from eip.sqlscm.SCM_h_MRN where hmrn_mrn_number in ('E5346MRN8000646','E5346MRN8000647','E5346MRN8000447')





 select *from eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
and mjob_job_code = 'LE080311'


select *from   eip.sqlmas.GEN_M_Material_Groups

