
use eip
go

select job_code, job_description,j.Cluster_Code,g.Cluster_Description, location,mmc_description,a.MCMG_Description,
TCMGD_Material_Price ,TCMGD_Uom_Code, UUOM_Description
from EPM.SQLpmp.PMP_T_Custom_Material_Group_Details ,  EPM.SQLPMP.GEN_M_Custom_Material_Groups a, epm.sqlpmp.GEN_M_Material_Category  b,
lnt.dbo.Job_master j, lnt.dbo.Cluster_Master g, eip.sqlmas.GEN_U_Unit_Of_Measurement
where TCMGD_Job_Code=job_Code and company_code='LE' and location='B'  and j.Cluster_Code= g.Cluster_Code
and TCMGD_Custom_Material_Group_Code = MCMG_Custom_Material_Group_Code and  b.MMC_Company_Code= 1 and b.MMC_Material_Category_Code = a.MCMG_Material_Category_Code
and MCMG_Material_Category_Code in ( '1003','M001') and TCMGD_Bp_Code=99992
and UUOM_UOM_Code = TCMGD_Uom_Code
and TCMGD_Material_Price <>0




