USE EIP
GO


====== >  Material Viewed

SELECT

       a.Staff_name as Employee_Name,
       MUSER_Reference_ID AS PSNO,
             B.Sector_Code as IC,
       C.Sector_Description as IC_Description,
       B.Job_code,
       B.Job_description,
       CONVERT(date, BTPA_Inserted_On) BTPA_Inserted_On ,
       COUNT(BTPA_Inserted_By) AS ID

FROM eip.SQLBSS.BSS_T_Procedure_Audit
JOIN eip.sqlmas.Gen_M_users
       ON (BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
WHERE BTPA_Procedure_Name = 'BSS_SP_RA_Material_Details_List'
GROUP BY      CONVERT(date, BTPA_Inserted_On),
                     a.Staff_name,
                     MUSER_Reference_ID,
                     B.Sector_Code,
                     C.Sector_Description,
                     B.job_code,
                     B.job_description
ORDER BY CONVERT(date, BTPA_Inserted_On) DESC, B.Sector_Code, C.Sector_Description






==== > Material Analysed

SELECT
       BTPA_Audit_ID,
       CAST(BTPA_Param_values AS xml).value('(/row/itemcode)[1]', 'varchar(100)') AS Itemcode,
       CAST(BTPA_Param_values AS xml).value('(/row/rate)[1]', 'varchar(100)') AS Rate,
       CAST(BTPA_Param_values AS xml).value('(/row/minrate)[1]', 'varchar(100)') AS Minrate INTO #temp
FROM eip.SQLBSS.BSS_T_Procedure_Audit
WHERE BTPA_Procedure_Name = 'BSS_SP_RA_MaterialRateCalculation'
AND CAST(BTPA_Param_values AS varchar(max)) LIKE '%item%'


SELECT


       a.Staff_name AS Employee_Name,
       MUSER_Reference_ID AS PSNO,
       B.Sector_Code AS IC,
       C.Sector_Description AS IC_Description,
       B.Job_code,
       B.Job_description,
       BTP.BTPA_Inserted_By,
       CONVERT(date, BTP.BTPA_Inserted_On) BTPA_Inserted_On,
       COUNT(BTP.BTPA_Inserted_By) AS ID,
       tm.Itemcode,
       LEFT(tm.itemcode, 4) AS Material_group,
       IGM.MRAIM_Description,
       LEFT(tm.itemcode, 6) AS Material_sub_group,
       ISM.MRAIM_Description,

       tm.Rate,
       tm.Minrate
--   Cast(BTPA_Param_values AS XML).value('(/row/itemcode)[1]', 'varchar(100)') AS itemcode, Cast(BTPA_Param_values AS XML).value('(/row/rate)[1]', 'varchar(100)') AS rate,
--Cast(BTPA_Param_values AS XML).value('(/row/minrate)[1]', 'varchar(100)') AS minrate
FROM eip.SQLBSS.BSS_T_Procedure_Audit BTP
INNER JOIN #temp tm
       ON tm.BTPA_Audit_ID = BTP.BTPA_Audit_ID
JOIN eip.sqlmas.Gen_M_users
       ON (BTP.BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
LEFT JOIN EIP.SQLBSS.BSS_M_RA_ItemMaster IGM
       ON LEFT(tm.itemcode, 4) = IGM.MRAIM_Item_Code
       AND IGM.MRAIM_Group_Level = 1
LEFT JOIN EIP.SQLBSS.BSS_M_RA_ItemMaster ISM
       ON LEFT(tm.itemcode, 6) = ISM.MRAIM_Item_Code
       AND ISM.MRAIM_Group_Level = 2
WHERE BTP.BTPA_Procedure_Name = 'BSS_SP_RA_MaterialRateCalculation'
AND CAST(BTP.BTPA_Param_values AS varchar(max)) LIKE '%item%'
GROUP BY      CONVERT(date, BTP.BTPA_Inserted_On),
                     a.Staff_name,
                     MUSER_Reference_ID,
                     BTP.BTPA_Inserted_By,
                     IGM.MRAIM_Description,
                     ISM.MRAIM_Description,
                     B.Sector_Code,
                     C.Sector_Description,
                     B.job_code,
                     B.job_description,
                     tm.itemcode,
                     tm.rate,
                     tm.minrate
ORDER BY CONVERT(date, BTP.BTPA_Inserted_On) DESC, B.Sector_Code, C.Sector_Description

DROP TABLE #temp



====== > Service Viewed

SELECT

       a.Staff_name AS Employee_Name,
       MUSER_Reference_ID AS PSNO,
       B.Sector_Code AS IC,
       C.Sector_Description AS IC_Description,
       B.Job_code,
       B.Job_description,
       CONVERT(date, BTPA_Inserted_On) BTPA_Inserted_On,
       COUNT(BTPA_Inserted_By) AS ID
FROM eip.SQLBSS.BSS_T_Procedure_Audit
JOIN eip.sqlmas.Gen_M_users
       ON (BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
WHERE BTPA_Procedure_Name IN ('BSS_SP_RA_WorkOrder_List')
GROUP BY      CONVERT(date, BTPA_Inserted_On),
                     a.Staff_name,
                     MUSER_Reference_ID,
                     B.Sector_Code,
                     C.Sector_Description,
                     B.job_code,
                     B.job_description
ORDER BY CONVERT(date, BTPA_Inserted_On) DESC, B.Sector_Code, C.Sector_Description




==== > Service Analysed

drop table #temp
SELECT
       BTPA_Audit_ID,
       CAST(BTPA_Param_values AS xml).value('(/row/@Code)[1]', 'varchar(100)') AS itemcode,
       CAST(BTPA_Param_values AS xml).value('(/row/@city)[1]', 'varchar(100)') AS city,
       CAST(BTPA_Param_values AS xml).value('(/row/@retval)[1]', 'varchar(100)') AS retval,
       CAST(BTPA_Param_values AS xml).value('(/row/@userrate)[1]', 'varchar(100)') AS userrate INTO #temp
FROM eip.SQLBSS.BSS_T_Procedure_Audit
WHERE BTPA_Procedure_Name = 'BSS_SP_RA_WorkOrder_Rate_List'
AND CAST(BTPA_Param_values AS varchar(max)) LIKE '%code=%'
AND CAST(BTPA_Param_values AS varchar(max)) LIKE '%city=%'

SELECT


       a.Staff_name AS Employee_Name,
       MUSER_Reference_ID AS PSNO,
       B.Sector_Code AS IC,
       C.Sector_Description AS IC_Description,
       B.Job_code,
       B.Job_description,
       CONVERT(date, BTP.BTPA_Inserted_On) BTPA_Inserted_On,
       BTP.BTPA_Inserted_By,
       COUNT(BTP.BTPA_Inserted_By) AS ID,
       tm.Itemcode,
       MRAIM_Description,
       CASE MRAIM_Parent_Code
              WHEN 'NC' THEN 'Concreting'
              WHEN 'NE' THEN 'Earthwork'
              WHEN 'NF' THEN 'Formwork'
              WHEN 'NM' THEN 'Masonary and Plastering'
              WHEN 'NW' THEN 'Waterproofing'
              WHEN 'NT' THEN 'Tiling'
              WHEN 'NR' THEN 'Reinforcement'
              WHEN 'NP' THEN 'Painting'
              WHEN 'NTE' THEN 'Tower Erection'
              WHEN 'NTL' THEN 'Tiling'
              WHEN 'NST' THEN 'Stringing Transmission Lines'
              WHEN 'NSL' THEN 'Street Lighting'
              WHEN 'NEE' THEN 'Eqpt Erection Elec' ELSE ''
       END AS Parent_Name,
       tm.City,
       LO.MRALO_Description,
       tm.Retval,
       tm.Userrate

FROM eip.SQLBSS.BSS_T_Procedure_Audit BTP
INNER JOIN #temp tm
       ON tm.BTPA_Audit_ID = BTP.BTPA_Audit_ID
LEFT JOIN eip.sqlbss.BSS_M_RA_Location LO
       ON tm.City = LO.MRALO_Location_Code
JOIN eip.sqlmas.Gen_M_users
       ON (BTP.BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
LEFT JOIN SQLBSS.BSS_M_RA_ItemMaster
       ON (itemcode = MRAIM_Item_Code)
WHERE BTP.BTPA_Procedure_Name = 'BSS_SP_RA_WorkOrder_Rate_List'
AND CAST(BTPA_Param_values AS varchar(max)) LIKE '%code=%'
AND CAST(BTPA_Param_values AS varchar(max)) LIKE '%city=%'
GROUP BY      CONVERT(date, BTP.BTPA_Inserted_On),
                     a.Staff_name,
                     MUSER_Reference_ID,
                     BTP.BTPA_Inserted_By,
                     B.Sector_Code,
                     C.Sector_Description,
                     B.job_code,
                     B.job_description,
                     MRAIM_Description,
                     MRAIM_Parent_Code,
                     tm.itemcode,
                     tm.city,
                     LO.MRALO_Description,
                     tm.retval,
                     tm.userrate
ORDER BY CONVERT(date, BTP.BTPA_Inserted_On) DESC, B.Sector_Code, C.Sector_Description

DROP TABLE #temp


ICWISE-SITEWISE-USAGE -Script



USE EIP
GO

--Employee Checked PO

SELECT COUNT(BTPA_Inserted_By) AS ID,
    CONVERT(date, BTPA_Inserted_On) BTPA_Inserted_On,
             MUSER_Reference_ID as PSNO,
             a.Staff_name as Employe_Name,       
       B.Sector_Code as IC,C.Sector_Description as IC_Description,
             B.Job_code,
             B.Job_description
FROM eip.SQLBSS.BSS_T_Procedure_Audit                                                                                
JOIN  eip.sqlmas.Gen_M_users
       ON (BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
WHERE BTPA_Procedure_Name IN ( 'BSS_SP_RA_Material_Details_List','BSS_SP_RA_MaterialRateCalculation')
AND main_sub_dept IN ( 'M' ,'D' ) 
AND job_type <> '6'  and job_status not in('P')     
AND Job_active='Y'  -- ACTIVE MAIN JOB P,B - CLOSED AND ALMOST CLOSED JOBS      
AND JOB_SOURCE_TAG='E'  -- TO DISPLAY ONLY EIP ONLINE JOBS  
GROUP BY     
CONVERT(date, BTPA_Inserted_On),
                    MUSER_Reference_ID,a.Staff_name,
                     B.Sector_Code,C.Sector_Description, B.job_code,        B.job_description
ORDER BY 
CONVERT(date, BTPA_Inserted_On) DESC,  
B.Sector_Code,C.Sector_Description, B.job_code,          B.job_description

--Employee Checked WO

SELECT COUNT(BTPA_Inserted_By) AS ID,
      CONVERT(date, BTPA_Inserted_On) BTPA_Inserted_On,
             MUSER_Reference_ID as PSNO,
             a.Staff_name as Employe_Name,    
      B.Sector_Code as IC,C.Sector_Description as IC_Description,
             B.Job_code,
             B.Job_description
FROM eip.SQLBSS.BSS_T_Procedure_Audit
JOIN  eip.sqlmas.Gen_M_users
       ON (BTPA_Inserted_By = MUSER_User_ID)
JOIN LNT.DBO.STAFF_MASTER a
       ON (MUSER_Reference_ID = A.Psno)
JOIN LNT.DBO.job_master B
       ON (A.Dept_Code = B.job_code)
JOIN LNT.DBO.Sector_Master C
       ON (b.Sector_Code = C.Sector_Code)
WHERE BTPA_Procedure_Name IN ( 'BSS_SP_RA_WorkOrder_List','BSS_SP_RA_WorkOrder_Rate_List' )
AND main_sub_dept IN ( 'M' ,'D' ) 
AND job_type <> '6'  and job_status not in('P')     
AND Job_active='Y'  -- ACTIVE MAIN JOB P,B - CLOSED AND ALMOST CLOSED JOBS      
AND JOB_SOURCE_TAG='E'  -- TO DISPLAY ONLY EIP ONLINE JOBS  
GROUP BY    CONVERT(date, BTPA_Inserted_On),
                    MUSER_Reference_ID,a.Staff_name,
                     B.Sector_Code,C.Sector_Description, B.job_code,        B.job_description
ORDER BY CONVERT(date, BTPA_Inserted_On) DESC,  
B.Sector_Code,C.Sector_Description, B.job_code,B.job_description







select *from EIP.SQLBSS.BSS_M_RA_ItemMaster IGM WHERE MRAIM_Item_Code = '344000400'
select *from EIP.SQLBSS.BSS_M_RA_ItemMaster IsM WHERE MRAIM_Item_Code = '344000400'

select *from EIP.SQLBSS.BSS_M_RA_ItemMaster WHERE MRAIM_Item_Code = '344000400'

SELECT *FROM eip.SQLBSS.BSS_T_Procedure_Audit BTP

use eip
go

select *from sys.tables where name like '%constzon%'


select * from eip.sqlscm.scm_d_po_constzon_details


select *from eip.sqlscm.SCM_d_Purchase_Orders where dpo_po_number = 'E0188PO8000001'


select *from eip.sqlscm.SCM_h_Purchase_Orders where hpo_po_number = 'E0188PO8000001'

select *from eip.sqlscm.scm_d_counter_offer

select *from eip.sqlwom.WOM_D_Work_Order_ConstZon_Details where DWOCD_WO_Number = 'E2222WOR8000016'


