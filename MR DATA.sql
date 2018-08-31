
drop table #link
select dmr_material_code,dmr_suggested_rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,dmr_qty,dmr_mr_Number, hmr_mr_date, dmr_value,MMAT_Material_Description, location, hmr_Currency_Code,
 p.sector_code, p.bu_code , p.SBG_Code, Hmr_Warehouse_Code,Hmr_DS_Code,MMAT_MG_Code

 into #link
 from eip.sqlscm.SCM_H_Material_Request   , eip.sqlscm.SCM_D_Material_Request,
 lnt.dbo.job_master p,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials , eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement 

 
  
where hmr_mr_number = dmr_mr_number 


and mmat_material_code = DMR_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code 
and MMGRP_Company_Code= mmat_company_code 
and MMATC_Class_Code = c.MMGRP_Class_Code 
and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and HMR_DS_CODE = '3'
and Hmr_Company_Code=1 
and Hmr_Job_Code= p.job_code 

and p.company_code='LE'

and MMAT_UOM_Code = UUOM_UOM_Code

and MMAT_Company_Code= MMATC_Company_Code 


and len (dmr_material_code) >= '15'

and job_operating_group <>'I' 
Update #link set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')


Update #link set MMATC_Description= replace(MMATC_Description,',','-'),mmgrp_description=replace(mmgrp_description,',','-'),MMAT_Material_Description=replace(MMAT_Material_Description,',','-')

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
WHERE A.Dmr_MATERIAL_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='MATR'
--AND MSR_Attribute_Combination_Value IS NOT NULL

select *from #link

alter table #link add materialcategory VARCHAR (500)
alter table #link add PlanningCategory VARCHAR (500)



 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dmr_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dmr_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 


alter table  #link add materialcategory varchar(100)
alter table  #link add PlanningCategory varchar(100)




 Update a set materialcategory = d.LMCMG_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP d
where mmat_mg_Code=LMcmg_mg_Code 

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 
	

select *from #link a where MMAT_ISActive = 'y'

select *From eip.sqlscm.SCM_D_Material_Request where dmr_material_code = '3O22M0001000239'

select *From eip.sqlscm.scm_h_material_request where hmr_mr_number = 'EA331EMR8000241'