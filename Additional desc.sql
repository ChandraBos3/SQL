
SELECT  LSRTRGKD_Resource_Group_Code ,MSRP_Description   ,MSKD_Is_Allow_Custom_Description ,MSKD_Is_Allow_ReWorded_Description
FROM SQLPMP.Gen_L_Standard_Resource_Type_Resource_Group_KVP_Definition
,SQLPMP.Gen_M_Standard_KVP_Definitions
,SQLPMP.Gen_M_Standard_Resource_Group
where LSRTRGKD_Resource_Type_Code ='MATR' and LSRTRGKD_IsActive='Y' and LSRTRGKD_KVP_Code=MSKD_KVP_Code AND 
(MSKD_Is_Allow_Custom_Description='Y' OR MSKD_Is_Allow_ReWorded_Description ='Y') and 
LSRTRGKD_Resource_Group_Code =MSRP_Resource_Group_Code
 and MSRP_Resource_Type_Code=LSRTRGKD_Resource_Type_Code 
