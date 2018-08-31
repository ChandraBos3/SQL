drop table #matcodes
select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode, MSRR_Inserted_On, msrr_approved_on, MSRR_UOM_Code
,cast (Null as varchar(500)) mmat_material_code, cast (Null as varchar(50)) mmgrp_mg_code,cast (Null as varchar(500)) mmgrp_description, cast (Null as varchar(500))MMAT_Material_Description,cast (Null as varchar(50)) MMAT_UOM_Code,cast (Null as varchar(100)) UUOM_Description,cast (Null as varchar(50))MMAT_ISActive,cast (Null as varchar(50)) MMAT_Company_Code,cast (Null as date)MMAT_Inserted_On,cast (Null as varchar(50)) mmat_mg_code
into #matcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE' 
and a.MSRR_Resource_Type_Code='MATR'
and c.msr_resource_code = a.msr_resource_code 

update a set a.mmat_material_code = b.MMAT_Material_Code, a.mmgrp_mg_code =c.mmgrp_mg_code, a.mmgrp_description =c.MMGRP_Description, a.MMAT_Material_Description = b.MMAT_Material_Description, a.MMAT_UOM_Code=b.MMAT_UOM_Code,a.UUOM_Description =d.UUOM_Description, a.MMAT_ISActive=b.MMAT_ISActive,a.MMAT_Company_Code=b.MMAT_Company_Code, a.MMAT_Inserted_On=b.MMAT_Inserted_On, a.mmat_mg_code =b.mmat_mg_code
from #matcodes a, eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials b,eip.sqlmas.GEN_U_Unit_Of_Measurement d
where c.MMGRP_MG_Code= b.MMAT_MG_Code AND b.MMAT_Company_Code=1
and a.itemscope =b.mmat_material_code  
and b.MMAT_UOM_Code = UUOM_UOM_Code
and c.MMGRP_Company_Code= b.MMAT_Company_Code 

Update #matcodes set mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #matcodes set mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #matcodes set mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #matcodes set mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #matcodes set mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #matcodes set mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #matcodes set mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #matcodes set mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

alter table #matcodes add materialcategory varchar(100)
alter table #matcodes add PlanningCategory varchar(100)




 Update a set materialcategory = d.LMCMG_Material_Category_Code 
from #matcodes a , epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP d
where mmat_mg_Code=LMcmg_mg_Code 

Update a set PlanningCategory = f.MMC_Description 
from #matcodes a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 
	

select *from #matcodes where MMAT_ISActive = 'y'

use epm

go

SELECT *FROM epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP,epm.sqlpmp.GEN_M_Material_Category,eip.sqlmas.GEN_M_Material_Groups WHERE LMCMG_MG_CODE =MMGRP_MG_Code, lmcmg_company_code