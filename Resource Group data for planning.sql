drop table #list
select * from epm.sqlpmp.GEN_M_Item_Groups where MIGRP_Item_Group_Code in ('0001','0002')


select * into #list from epm.sqlpmp.gen_m_standard_resource where MSR_Resource_Group_Code in ('7041','5098')

update #list set msr_description = replace(msr_description, char(9),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(9),'-')
update #list set msr_description = replace(msr_description, char(10),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(10),'-')
update #list set msr_description = replace(msr_description, char(11),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(11),'-')
update #list set msr_description = replace(msr_description, char(12),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(12),'-')
update #list set msr_description = replace(msr_description, char(13),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(13),'-')
update #list set msr_description = replace(msr_description, char(14),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(14),'-')
update #list set msr_description = replace(msr_description, char(15),'-'), msr_Standardized_Description = replace(msr_Standardized_Description,char(15),'-')
update #list set msr_description = replace(msr_description, '''','-'), msr_Standardized_Description = replace(msr_Standardized_Description,'''','-')
update #list set msr_description = replace(msr_description, '"','-'), msr_Standardized_Description = replace(msr_Standardized_Description,'"','-')


select msr_resource_code, msr_resource_group_code, msr_description, msr_standardized_description from #list
select * from #list
