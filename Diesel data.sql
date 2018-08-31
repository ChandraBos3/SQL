drop table #link
select dpo_material_code,dpo_basic_rate,DPO_Net_Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,DPO_Qty,DPO_PO_Number, hpo_po_date, DPO_Value,MMAT_Material_Description, location, HPO_Currency_Code,HPO_Last_Amendment_Number
,HPO_BA_Code, vendor_description,DPODS_FROM_DATE,dpods_to_date, HPO_Warehouse_Code
 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.scm_d_purchase_orders, lnt.dbo.job_master,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement , lnt.dbo.vendor_master j
,eip.sqlscm.SCM_D_PO_Delivery_Schedules

where hpo_po_number = dpo_po_number 
--and MMAT_Material_Description like'%station%'
--and MMGRP_Description like '%station%'
and HPO_Last_Amendment_number=DPO_Amendment_Number
and mmat_material_code = DPO_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code and MMGRP_Company_Code= mmat_company_code and MMATC_Class_Code = c.MMGRP_Class_Code and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and hpo_po_number =DPODS_PO_NUMBER
and DPODS_mATERIAL_cODE = DPO_Material_Code
and HPO_BA_CODE= j.vendor_code
and HPO_Company_Code=1 and HPO_Job_Code= job_code 
and j.company_code = 'LE'
and DPODS_Company_Code =1

--and HPO_JOB_CODE in ('QGMAP013')
and MMAT_UOM_Code = UUOM_UOM_Code
and hpo_po_date between '01-Aug-2017' and '8-Nov-2017'
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code= 1
and MMAT_Company_Code= MMATC_Company_Code 
and job_operating_group <>'I' 
and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')


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
select * from #link



select *from eip.sqlscm.scm_d_purchase_orders 

use lnt
go
select *from lnt.dbo.job_master