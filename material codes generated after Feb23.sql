USE EIP
GO
select d.MMAT_Material_Code, c.mmgrp_mg_code,c.mmgrp_description,d.MMAT_Material_Description
from eip.sqlscm.scm_h_mrn a, eip.sqlscm.scm_d_mrn b,eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials d, eip.sqlmas.GEN_M_Material_Classes
where c.MMGRP_MG_Code = MMAT_MG_Code 
and c.MMGRP_Company_Code = d.MMAT_Company_Code and d.MMAT_Company_Code= 1  and d.mmat_isactive ='Y'
and  exists ( select top 1 'x' from epm.sqlepm.EPM_M_Control_Master where a.HMRN_Job_Code = TCM_Job_Code and TCM_PMP_TAG='Y' and TCM_EPM_Tag='N') group by c.mmgrp_mg_code,c.MMGRP_Description,DMRN_Material_Code
--and exists ( select top 1 'x' from eip.sqlscm.SCM_H_Purchase_Orders where hpo_po_number = HMRN_PO_Number)
--and hpo_po_date >='01-Jan-2017' ) 





select MMAT_Material_Code, mmgrp_mg_code,mmgrp_description,MMAT_Material_Description 
from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials
where c.MMGRP_MG_Code= MMAT_MG_Code AND MMAT_Company_Code=1 --and MMGRP_MG_Code='3109'

and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code=1-- AND MMGRP_Description=MMAT_Material_Description


--and  exists ( select top 1 'x' from epm.sqlepm.EPM_M_Control_Master where a.HMRN_Job_Code = TCM_Job_Code and TCM_PMP_TAG='Y' and TCM_EPM_Tag='N')
group by  mmgrp_mg_code,c.MMGRP_Description

use EIP
gO
drop table #list
select  mmat_material_code, mmat_material_description,mmat_isactive into #list
 from eip.sqlmas.GEN_M_Materials
WHERE MMAT_Company_Code= 1
and left(MMAT_Material_Code,1) in ('9') 
and mmat_isactive='Y' 
---and  exists ( select top 1 'x' from epm.sqlepm.EPM_M_Control_Master where TCM_PMP_TAG='Y' and TCM_EPM_Tag='N')

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(9),'')

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(10),'')
                          

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(11),'')

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(12),'')

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(13),'')

Update #list set MMAT_Material_Description = replace(MMAT_Material_Description, char(14),'')

select *from #list


and MMAT_Company_Code= 1

SELECT *FROM eip.sqlmas.GEN_M_Materials

SELECT *FROM eip.sqlmas.GEN_M_Material_Classes

eip.sqlmas.GEN_M_Material_Classes

select *from eip.sqlmas.GEN_M_Material_Groups