select *from eip.sqlscm.scm_h_mrn

select *from sys.tables where name like '%REQUEST%'

select *from lnt.dbo.job_master
select * from eip.sqlscm.SCM_H_Purchase_Orders

USE EIP
GO
select * from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.SCM_D_Purchase_Orders b, lnt.dbo.job_master c into #
where HPO_PO_Number = DPO_PO_Number
and HPO_Company_Code= 1 and hpo_job_code = c.job_code
and c.company_code='LE'
and c.location ='B'
and HPO_PO_Date between '01-Jan-2017' and '30-Jun-2017'

select * from eip.sqlscm.SCM_H_Purchase_Orders e, eip.sqlscm.SCM_D_Purchase_Orders f, lnt.dbo.job_master g into #ratecode
where HPO_PO_Number = DPO_PO_Number
and HPO_Company_Code= 1 and hpo_job_code = c.job_code
and g.company_code='LE'
and g.location ='B'
and HPO_PO_Date between '01-Jan-2017' and '30-Jun-2017'

drop table #ratecode
select MMAT_Material_Code, MMATC_Description, mmgrp_mg_code,mmgrp_description, MMAT_Material_Description, DPO_Basic_Rate,job_code,
HPO_PO_Date,HPO_PO_Number, Sector_Code, bu_code, location
--into #ratecode
from eip.sqlscm.SCM_H_Purchase_Orders e, eip.sqlscm.SCM_D_Purchase_Orders f, lnt.dbo.job_master g ,
		eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes
			where HPO_PO_Number = DPO_PO_Number AND HPO_Job_Code = G.JOB_CODE AND HPO_Company_Code=1 AND COMPANY_CODE='LE'
	AND HPO_PO_DATE >='01-aPR-2017' AND HPO_PO_DATE <='30-jUN-2017'
	AND DPO_MATERIAL_CODE = MMAT_Material_Code AND MMAT_Company_Code=HPO_Company_Code
	AND MMAT_MG_Code = MMGRP_MG_Code  AND MMGRP_Company_Code = MMATC_Company_Code
	AND MMATC_Company_Code = MMGRP_Company_Code AND MMATC_Class_Code = MMGRP_Class_Code
	AND MMAT_Company_Code = MMGRP_Company_Code and g.company_code='LE'
	and g.location ='B' AND  MMATC_Company_Code=1 and MMGRP_MG_Code IN ('6101','6C21')  

---working
	SELECT * FROM EIP.SQLMAS.GEN_M_Material_Category
	SELECT * FROM EIP.SQLMAS.GEN_M_Material_Classes WHERE MMATC_Company_Code=1
	SELECT * FROM EIP.SQLMAS.GEN_M_MATERIAL_GROUPS WHERE MMGRP_Description LIKE '%AGGREG%' AND  MMGRP_Company_Code=1
	SELECT * FROM EIP.SQLMAS.GEN_M_MATERIALS WHERE MMAT_Material_Code='313050000' AND MMAT_Company_Code=1

c.MMGRP_MG_Code= MMAT_MG_Code  and MMATC_Class_Code = c.MMGRP_Class_Code  AND MMC_Company_Code= HPO_Company_Code
	AND MMC_Material_Class_Code= MMATC_CLASS_CODE
	and HPO_PO_Number = DPO_PO_Number and DPO_Material_Code = MMAT_Material_Code
	and HPO_Company_Code= 1 and hpo_job_code = g.job_code
	and g.company_code='LE'
	and g.location ='B'
	and HPO_PO_Date between '01-Jan-2017' and '30-Jun-2017'
	and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code= 1
	and MMAT_Company_Code= MMATC_Company_Code and HPO_Company_Code =MMATC_Company_Code and MMGRP_Company_Code =HPO_Company_Code and MMAT_Company_Code =HPO_Company_Code 
	and MMC_Company_Code=1 and mmat_material_Code='313050000'


Update #ratecode set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),
						MMC_Description=replace(MMC_Description,char(9),'-')


Update #ratecode set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),
						MMC_Description=replace(MMC_Description,char(10),'-')

						
Update #ratecode set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),
						MMC_Description=replace(MMC_Description,char(11),'-')

Update #ratecode set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),
						MMC_Description=replace(MMC_Description,char(12),'-')
						
Update #ratecode set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),
						MMC_Description=replace(MMC_Description,char(13),'-')
						
Update #ratecode set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),
						MMC_Description=replace(MMC_Description,char(14),'-')

Update #ratecode set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),
						MMC_Description=replace(MMC_Description,char(15),'-')

Update #ratecode set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),
						MMC_Description=replace(MMC_Description,'"','-')



select * from #ratecode where MMC_Description like '%aggregate%'

--ACE -Material Rate

select job_code, job_description,j.Cluster_Code,g.Cluster_Description, location,mmc_description,a.MCMG_Description,
TCMGD_Material_Price 
from EPM.SQLpmp.PMP_T_Custom_Material_Group_Details ,  EPM.SQLPMP.GEN_M_Custom_Material_Groups a, epm.sqlpmp.GEN_M_Material_Category  b,
lnt.dbo.Job_master j, lnt.dbo.Cluster_Master g
where TCMGD_Job_Code=job_Code and company_code='LE' and location='B'  and j.Cluster_Code= g.Cluster_Code
and TCMGD_Custom_Material_Group_Code = MCMG_Custom_Material_Group_Code and  b.MMC_Company_Code= 1 and b.MMC_Material_Category_Code = a.MCMG_Material_Category_Code
and MCMG_Material_Category_Code in ( '1003','M001') and TCMGD_Bp_Code=30001



--30001 Means ACE
--1003, M001  Aggregates
--Location  B – Mumbai
--Company  LTC == LE

--Code from ISD

DECLARE
@companyCode         INT                  =      1,
@isActive                  CHAR(1)              =      'Y',
@moduleType                VARCHAR(15)   =      'PMMT0002',   -- Cost Estimation - ACE / RE
@materialCategory    VARCHAR(15)   =      'M001' -- Crushed Stone (Aggregate, Railway Ballast)

SELECT ic.Sector_Description Sector
              ,bu.bu_description BU
              ,j.job_code + ' : ' + job_description jobDescription
              ,MMC_Description materialCategory
              ,UUOM_Symbol uom
              ,SUM(TMED_Effective_Activity_Quantity) quantity
              ,CASE WHEN SUM(TMED_Effective_Activity_Quantity) IS NULL OR SUM(TMED_Effective_Activity_Quantity) = 0 THEN 0 ELSE SUM(TMED_Effective_Activity_Cost) / SUM(TMED_Effective_Activity_Quantity) END rate
              ,SUM(TMED_Effective_Activity_Cost) cost
FROM EPM.SQLPMP.GEN_M_Material_Category
JOIN EPM.SQLPMP.GEN_M_Custom_Material_Groups
ON (MMC_Material_Category_Code           =      MCMG_Material_Category_Code              AND
       MMC_Company_Code                         =      MCMG_Company_Code)
JOIN EPM.SQLPMP.PMP_T_Custom_Material_Group_Details
ON (MCMG_Custom_Material_Group_Code      =      TCMGD_Custom_Material_Group_Code)
JOIN EPM.SQLPMP.GEN_U_Unit_Of_Measurement
ON (TCMGD_Uom_Code                              =      UUOM_UOM_Code)
JOIN EPM.SQLPMP.PMP_T_Material_Estimation_Details
ON (TCMGD_Job_Code                              =      TMED_Job_Code                                   AND
       TCMGD_Bp_Code                            =      TMED_BP_Code                                    AND
       TCMGD_Custom_Material_Group_Code= TMED_PR_Code)
JOIN lnt.dbo.Job_Master j
ON (TMED_Job_Code                               =      job_code and location = 'B')
JOIN EPM.SQLPMP.Sector_Master ic
ON (j.Sector_Code                               =      ic.Sector_Code)
JOIN EPM.SQLPMP.business_unit_master bu
ON (j.bu_code                                   =      bu.bu_code)
WHERE  MMC_Company_Code                  =      @companyCode                                    AND
              MMC_IsActive                      =      @isActive                                             AND
              MMC_Moudle_Type                          =      @moduleType                                            AND
              MMC_Material_Category_Code =      @materialCategory                               AND
              TMED_BP_Code                      =      99992
                       
GROUP BY ic.Sector_Description, bu.bu_description, job_code, job_description, MMC_Description, UUOM_Symbol
HAVING SUM(TMED_Effective_Activity_Cost) > 0
ORDER BY ic.Sector_Description, bu.bu_description, job_code, job_description
