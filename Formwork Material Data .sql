
select a.MMAT_Material_Code, a.MMAT_MG_Code, 
replace(replace(replace(replace(replace(replace(replace(replace(MMGRP_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),
                                  char(14),'-'),'''','F'),'"','I'),

replace(replace(replace(replace(replace(replace(replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),
                                  char(14),'-'),'''','F'),'"','I'), a.MMAT_UOM_Code,a.MMAT_ISActive,MMGRP_Depreciation_Percent,
MMGRP_Form_Work_Tag
from eip.sqlmas.GEN_M_Materials a, eip.sqlmas.GEN_M_Material_Groups where MMAT_MG_Code = MMGRP_MG_Code and MMAT_Company_Code=1
and a.MMAT_Company_Code= MMGRP_Company_Code
and MMGRP_MG_Code between '1500' and '1599'
