use EIP
GO

SELECT * from sys.tables where name like '%cons%'

select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode --, d.MIGRP_Description category
--into #stdcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c--, epm.sqlpmp.GEN_M_Item_Groups d
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE'
and a.MSRR_Resource_Type_Code='MATR'
--and a.MSRR_Resource_Group_Code = d.MIGRP_Item_Group_Code
and c.msr_resource_code = a.msr_resource_code


select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode,dpo_material_code, location,dpo_net_rate, mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description --, d.MIGRP_Description category
--into #matcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c, eip.sqlscm.SCM_H_Purchase_Orders d, eip.sqlscm.scm_d_purchase_orders e, lnt.dbo.job_master,
  eip.sqlmas.GEN_M_Material_Groups f, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement
--, epm.sqlpmp.GEN_M_Item_Groups d.
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE'
and a.MSRR_Resource_Type_Code='MATR'
--and a.MSRR_Resource_Group_Code = d.MIGRP_Item_Group_Code
and c.msr_resource_code = a.msr_resource_code 
and hpo_po_number = dpo_po_number 
--and DPO_Material_Code ='310210910'
and mmat_material_code = DPO_Material_Code and mmat_mg_Code = MMGRP_MG_Code and MMGRP_Company_Code= mmat_company_code 
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and HPO_Company_Code=1 and HPO_Job_Code= job_code 
and MMAT_UOM_Code = UUOM_UOM_Code
and hpo_po_date between '01-Aug-2017' and '28-Aug-2017' 


select *from epm.SQLpmp.Gen_M_Standard_Resource_Request

select *from epm.sqlpmp.GEN_M_Item_Groups

select *from EPM.sqlpmp.Gen_M_Standard_Resource 

select * from eip.sqlscm.SCM_H_Purchase_Orders

select * from eip.sqlmas.GEN_M_Materials

select * from eip.sqlscm.SCM_d_Purchase_Orders
