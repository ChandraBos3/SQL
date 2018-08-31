Use EPM
GO

/*
Exec #Lntsp_Get_Attr_And_Value 'MATR','1c11'
Exec #Lntsp_Get_Attr_And_Value 'MATR','6ca1'
*/
Create Procedure #Lntsp_Get_Attr_And_Value
(
@Res_Type varchar(15),
@Res_Grp varchar(15)
)
as
Begin
Declare @KVP int
set @KVP=(select LSRTRGKD_KVP_Code from epm.sqlpmp.Gen_L_Standard_Resource_Type_Resource_Group_KVP_Definition 
where LSRTRGKD_Resource_Type_Code=@Res_Type and LSRTRGKD_IsActive='Y' and LSRTRGKD_Resource_Group_Code=@Res_Grp)
--select @KVP
Create Table #tab_1
(
Attribute_Code int,
Attribute_Desc varchar(250),
Attribute_Value_Code int,
Attribute_Value_Desc varchar(250)
)
insert into #tab_1
select LSKA_Attribute_Code,Null,LSKAAV_Attribute_Value_Code,null 
from epm.SQLPMP.Gen_L_Standard_KVP_Attributes,
epm.sqlpmp.Gen_L_Standard_KVP_Attributes_Attribute_Values
where LSKA_KVP_Code=@KVP and LSKA_IsActive='Y' and LSKAAV_KVP_Code=LSKA_KVP_Code and LSKAAV_Attribute_Code=LSKA_Attribute_Code and LSKAAV_IsActive='Y'
 
Update #tab_1
set Attribute_Desc=MSA_Description
from epm.sqlpmp.Gen_M_Standard_Attributes
where MSA_Attribute_Code=Attribute_Code

Update #tab_1
set Attribute_Value_Desc=MSAV_Description
from epm.sqlpmp.Gen_M_Standard_Attribute_Values
where MSAV_Attribute_Code=Attribute_Code
and MSAV_Attribute_Value_Code=Attribute_Value_Code

select *  from #tab_1

End

select *from epm.sqlpmp.Gen_L_Standard_Resource_Type_Resource_Group_KVP_Definition where LSRTRGKD_Resource_Group_Code ='1c11'
select *from epm.SQLPMP.Gen_L_Standard_KVP_Attributes
select * from epm.sqlpmp.Gen_L_Standard_KVP_Attributes_Attribute_Values where LSKAAV_Attribute_Value_Code ='78620'
 select *from epm.sqlpmp.Gen_M_Standard_Attributes
  select *from epm.sqlpmp.Gen_M_Standard_Attribute_values where MSAV_Attribute_Value_Code ='78620' and MSAV_Attribute_Code = '1068'



drop table #master
select LSRTRGKD_Resource_Group_Code, LSKA_Attribute_Code,MSA_Description,LSKAAV_Attribute_Value_Code,MSAV_Description 
into #Master
from epm.sqlpmp.Gen_L_Standard_Resource_Type_Resource_Group_KVP_Definition,epm.SQLPMP.Gen_L_Standard_KVP_Attributes,
epm.sqlpmp.Gen_L_Standard_KVP_Attributes_Attribute_Values,epm.sqlpmp.Gen_M_Standard_Attributes,epm.sqlpmp.Gen_M_Standard_Attribute_values
where LSRTRGKD_Resource_Type_Code='MATR' and LSRTRGKD_IsActive='Y' 
--and LSRTRGKD_Resource_Group_Code BETWEEN '1000' and '9999'
and LSKA_KVP_Code=LSRTRGKD_KVP_Code and LSKA_IsActive='Y' and LSKAAV_KVP_Code=LSKA_KVP_Code and LSKAAV_Attribute_Code=LSKA_Attribute_Code and LSKAAV_IsActive='Y'
and  MSA_Attribute_Code=LSKA_Attribute_Code and MSA_IsActive ='Y' AND MSAV_IsActive ='Y'

and MSAV_Attribute_Code=LSKA_Attribute_Code
and MSAV_Attribute_Value_Code=LSKAAV_Attribute_Value_Code





update #Master set MSA_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MSA_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #Master set MSAV_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MSAV_Description,char(9),'-'),char(10),'-'),
 
 
                                char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

alter table #master add materialcategory VARCHAR (500)
alter table #Master add Category varchar(500)

Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #master a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where LSRTRGKD_Resource_Group_Code=left(LMMCLM_Material_Code,4) and LMMCLM_Company_Code=1 



Update a set category = f.MMC_Description 
from #Master a ,epm.sqlpmp.GEN_M_Material_Category f
where   materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 

select *from #master




alter table #master add materialcategory2 VARCHAR (500)
alter table #master add PlanningCategory2 VARCHAR (500)



 Update a set materialcategory2 = d.LMCMG_Material_Category_Code 
from #master a , epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP d
where LSRTRGKD_Resource_Group_Code=LMcmg_mg_Code 

Update a set PlanningCategory2 = f.MMC_Description 
from #master a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory2= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 

alter table #master add group_description VARCHAR (500)

Update a set group_description = MSRP_DESCRIPTION
from #master a ,epm.sqlpmp.Gen_M_Standard_Resource_Group
where  LSRTRGKD_Resource_Group_Code = MSRP_Resource_Group_Code and MSRP_ISACTIVE ='Y' AND MSRP_RESOURCE_TYPE_code ='matr'


epm.sqlpmp.Gen_L_Standard_KVP_Attributes_Attribute_Values

select *from epm.sqlpmp.GEN_M_Material_Category where MMC_Material_Category_Code like '%6cd1%'



select *from epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping  where lmmclm_material_code like '%6m54%'
6m54

select *from  epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP where lmcmg_mg_code ='1sch'

select *from epm.sqlpmp.GEN_M_Material_Category where mmc_material_category_code ='1sch'

select *from EIP.SQLMAS.GEN_M_ITEM_GROUPS where MIGRP_company_CODE = '1' AND MIGRP_ISACTIVE ='Y' and migrp_item_group_code ='6c15'

select *from epm.sqlpmp.Gen_M_Standard_Resource where msr_resource_type_code ='scpl' and msr_isactive='y'

select *from eip.sqlmas.GEN_M_Material_Groups WHERE MMGRP_Company_Code ='1' AND MMGRP_ISACTIVE ='Y'

select *from epm.sqlpmp.GEN_M_Material_Category where mmc_company_code ='1' 
and mmc_isactive ='y' 