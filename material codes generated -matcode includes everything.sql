select MMAT_Material_Code, mmgrp_mg_code,mmgrp_description,MMAT_Material_Description 
from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials
where c.MMGRP_MG_Code= MMAT_MG_Code AND MMAT_Company_Code=1 and MMGRP_MG_Code='3100'

and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code=1