select distinct c.LAGPAG_Parent_Activity_Group_Code L1Code,
       d.MAGRP_Description L1Description,a.MPBS_Activity_Group_Code L2Code, b.MAGRP_Description L2Description,  
       a.MPBS_PBS_Code L3Code, a.MPBS_Description L3Description 
  from EPM.SQLPMP.GEN_M_Project_Breakdown_Structure a, EPM.SQLPMP.GEN_M_Activity_Groups  b , epm.sqlpmp.GEN_L_Activity_Group_Parent_Activity_Group c,
       EPM.SQLPMP.GEN_M_Activity_Groups d
  where MPBS_Activity_Group_Code is not NULL and MPBS_ISActive='Y'
  and a.MPBS_Activity_Group_Code= b.MAGRP_Activity_Group_Code
  and LAGPAG_Activity_Group_Code = MPBS_Activity_Group_Code
  and c.LAGPAG_Parent_Activity_Group_Code = d.MAGRP_Activity_Group_Code