
drop table #temp
select mmat_material_code, mmgrp_mg_code, mmgrp_description, MMAT_Material_Description,MMAT_UOM_Code,UUOM_Description,MMAT_ISActive,MMAT_Company_Code,MMAT_Inserted_On ,mmat_mg_code,len (mmat_material_code) matlength
into #temp from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials,eip.sqlmas.GEN_U_Unit_Of_Measurement
where c.MMGRP_MG_Code= MMAT_MG_Code AND MMAT_Company_Code=1 
and MMAT_UOM_Code = UUOM_UOM_Code
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code=1
and mmat_isactive ='Y'
--and LEN (mmat_material_code)>='15'




Update #temp set mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #temp set mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #temp set mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

select *from #temp WHERE LEN (mmat_material_code)>='15'

---select *from #temp WHERE mmat_isactive ='Y'

alter table #temp add MMC_Description1 varchar(100)
alter table #temp add MMC_Material_Category_Code1 varchar(100)


Update a set MMC_Material_Category_Code1 = d.LMMCLM_Material_Category_Code 
from #temp a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set MMC_Material_Category_Code1 = d.LMMCLM_Material_Category_Code 
from #temp a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where mmat_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1
and LMMCLM_Material_Category_Code='9999' and MMC_Material_Category_Code1  is null
	

Update a set MMC_Description1 = f.MMC_Description 
from #temp a ,epm.sqlpmp.GEN_M_Material_Category f
where  MMC_Material_Category_Code1= f.MMC_Material_Category_Code and f.MMC_Company_Code=1

--select *from #temp where  left (mmat_material_code,1) not in ('9', '1', '0') and mmat_isactive = 'n'


alter table #temp add materialcategory2 VARCHAR (500)
alter table #temp add PlanningCategory2 VARCHAR (500)

 Update a set materialcategory2 = d.LMCMG_Material_Category_Code 
from #temp a , epm.sqlpmp.GEN_L_MATERIAL_CATEGORY_MATERIAL_GROUP d
where mmat_mg_Code=LMcmg_mg_Code 

Update a set PlanningCategory2 = f.MMC_Description 
from #temp a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory2= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 





select  identity(int) slno,* into #temp1    from #temp

select * from #temp1 where slno >=1800001

select * from #temp1 where MMAT_ISActive ='y'


select *from epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping where LMMCLM_Company_Code ='1'

select *from epm.sqlpmp.GEN_M_Material_Category where MMC_Company_Code=1 



----

select *
into #temp2 
from eip.sqlmas.GEN_M_Materials b, #temp a where b.mmat_material_code= a.mmat_material_code and b.mmat_company_code = '1'

select *from #temp2 

select a.mmat_material_code, a.mmgrp_mg_code, a.mmgrp_description, a.MMAT_Material_Description,a.MMAT_UOM_Code,a.UUOM_Description,a.MMAT_ISActive,a.MMAT_Company_Code,a.MMAT_Inserted_On ,a.mmat_mg_code,matlength,a.MMC_Description1,a.MMC_Material_Category_Code1
into #temp3 from #temp a,eip.sqlmas.GEN_M_Materials b where b.mmat_material_code= a.mmat_material_code and b.mmat_company_code = '1'

select *from #temp3 where mmat_isactive ='y'



select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_PO_NUMBER ='EC174PO8000496'

SELECT *FROM eip.sqlscm.SCM_D_Material_Request WHERE DMR_MR_NUMBER ='EC174EMR8000553'

Select *from eip.sqlmas.GEN_M_Materials  where mmat_material_code = '320290626'
 