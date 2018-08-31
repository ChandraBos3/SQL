
drop table #temp
select mmat_material_code, mmgrp_mg_code, mmgrp_description, MMAT_Material_Description,MMAT_Inserted_On,MMC_Description, MMC_Material_Category_Code,mmatc_description,MMAT_UOM_Code, MMAT_ISActive
into #temp 

from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, 

 epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category
 
where c.MMGRP_MG_Code= MMAT_MG_Code 
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code=1

and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Company_Code=1 and LMMCLM_Material_Category_Code= MMC_Material_Category_Code

and MMGRP_Company_Code= mmat_company_code and MMATC_Class_Code = c.MMGRP_Class_Code
--and MMGRP_Company_Code=MMATC_Company_Code
---and mmat_material_code in ('315060707', '6CA2M0023000000')
--and MMC_Material_Category_Code in ('M044', 'M015','M049','M051','M020','M017','M059')
--and MMAT_iNSERTED_on between '01-Jan-2017' and '20-Nov-2017'

Update #temp set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),
						MMC_Description=replace(MMC_Description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #temp set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),
						MMC_Description=replace(MMC_Description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #temp set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),
						MMC_Description=replace(MMC_Description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #temp set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),
						MMC_Description=replace(MMC_Description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #temp set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),
						MMC_Description=replace(MMC_Description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #temp set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),
						MMC_Description=replace(MMC_Description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #temp set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),
						MMC_Description=replace(MMC_Description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #temp set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),
						MMC_Description=replace(MMC_Description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
select *from #temp


select  identity(int) slno,* into #temp1    from #temp

select * from #temp1 where slno between 1000000 and 1926616


select *from eip.sqlmas.GEN_M_Materials WHERE MMAT_Company_Code= '1'