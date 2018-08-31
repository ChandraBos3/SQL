select mmat_material_code, mmgrp_mg_code, mmgrp_description, MMAT_Material_Description into #temp from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials
where c.MMGRP_MG_Code= MMAT_MG_Code AND MMAT_Company_Code=1 
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code=1

Update #temp set mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #temp set mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #temp set mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #temp set mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #temp set mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

select  identity(int) slno,* into #temp1    from #temp

select * from #temp1 where slno between 1000000 and 1926616