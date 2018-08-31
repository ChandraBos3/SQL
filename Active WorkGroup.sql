 
 SELECT * from epm.sqlpmp.GEN_M_Work_Items  
 where  MWI_Major_Work_Item_Group_Code in (
 
 SElect MSRP_Resource_Group_Code 
 from epm.sqlpmp.Gen_M_Standard_Resource_Group
  where MSRP_Resource_Type_Code='SCPL' and MSRP_IsActive='Y'
 ) and MWI_Is_WorkItem_Group='Y' and MWI_ISActive='Y'  