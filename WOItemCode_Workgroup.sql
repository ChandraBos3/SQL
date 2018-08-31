use EIP
go

  --SELECT * from epm.sqlpmp.gen_m_item_groups where MIGRP_IsActive='Y' and MIGRP_Module_Tag='IGMT0002'



SELECT distinct DWO_WO_Number  into #NEWItem_WO
from  eip.SQLWOM.WOM_D_Work_Orders
where  exists (
--DWO_Item_Code
SELECT 'x' from epm.sqlpmp.Gen_M_Standard_Resource
where MSR_Resource_Type_Code='SCPL' and MSR_Resource_Code=DWO_Item_Code 
and MSR_Resource_Group_Code in (
'6C11',
'6C12',
'6C13',
'6C14',
'6C15',
'6C16',
'6C17',
'6C18',
'6C19',
'6C1A',
'6C1B',
'6C1C',
'6C1D',
'6C1E',
'6C1F',
'6C1G',
'6C1H',
'6C1I',
'6C1J',
'6C1K',
'6C1L',
'6C1M',
'6C1N',
'6C1O',
'6C21',
'6C22',
'6C23',
'6C24',
'6C25',
'6C26',
'6C27',
'6C28',
'6C29',
'6C2A',
'6C2B',
'6C2C',
'6C2D',
'6C2E',
'6C2F',
'6C2G',
'6C2H',
'6C2I',
'6C2J',
'6C2K',
'6C2L',
'6C2M',
'6E11',
'6E12',
'6E13',
'6E14',
'6E15',
'6E22',
'6E23',
'6E24',
'6E25',
'6E26',
'6E27',
'6E28',
'6E29',
'6E2A',
'6M11',
'6M12',
'6M13',
'6M14',
'6M15',
'6M21',
'6M22',
'6M23',
'6M24',
'6M25',
'6O11',
'6O21'  
)


)


Select * from #NEWItem_WO
---(4033 row(s) affected)





Create Table #WorkGroup
( 
ItemCode varchar(50),
ItemDescription varchar(500),
KVP_Combination  varchar(5000), 
Group_Code  char(4),
UOM INT
)

	   
Insert into #WorkGroup
(
ItemCode,
ItemDescription,
KVP_Combination,
Group_Code,
UOM
)

SELECT  MWI_Work_Item_Code, 
		MWI_Description,
		Replace(MSR_KVP_Combination,'/','%') as MSR_KVP_Combination,
		MSR_Resource_Group_Code,
		MWI_UOM_Code
from epm.SQLPMP.GEN_M_Work_Items 
Join epm.SQLPMP.Gen_M_Standard_Resource 
on (
MSR_Resource_Type_Code ='SCPL' and 
MSR_Resource_Code=MWI_Work_Item_Code 
  ) 
where   MWI_Is_WorkItem_Group='Y'  and
EXISTS(
Select 'x'  from epm.sqlpmp.GEN_M_Item_Groups where MIGRP_Item_Group_Code=MSR_Resource_Group_Code and MIGRP_IsActive='Y') 






SELECT  MSR_Resource_Code,
	    MSR_Description ,
		(
		Select top 1 ItemDescription
		from #WorkGroup
		where 
		MSR_KVP_Combination like '%' + KVP_Combination+'%'    
		order by  len(KVP_Combination)-len(MSR_KVP_Combination)    
		) WorkGroup
from epm.sqlpmp.Gen_M_Standard_Resource
where MSR_Resource_Type_Code='SCPL' and 
MSR_Resource_Group_Code in (
'6C11','6C12','6C13','6C14','6C15','6C16','6C17',
'6C18','6C19','6C1A','6C1B',
'6C1C','6C1D','6C1E','6C1F','6C1G','6C1H','6C1I',
'6C1J','6C1K','6C1L','6C1M','6C1N','6C1O','6C21','6C22',
'6C23','6C24','6C25','6C26','6C27','6C28','6C29','6C2A',
'6C2B','6C2C','6C2D','6C2E','6C2F','6C2G','6C2H','6C2I',
'6C2J','6C2K','6C2L','6C2M','6E11','6E12','6E13','6E14',
'6E15','6E22','6E23','6E24','6E25','6E26','6E27','6E28','6E29','6E2A',
'6M11','6M12','6M13','6M14','6M15',
'6M21','6M22','6M23','6M24','6M25','6O11','6O21'  
)

and exists 
( 
SELECT top 1 'x' 
from  eip.SQLWOM.WOM_D_Work_Orders
where    DWO_Item_Code=MSR_Resource_Code
)




SELECT * from  epm.sqlpmp.gen_m_Standard_resource where MSR_Resource_Type_Code ='MATR' order by MSR_Inserted_On asc

 