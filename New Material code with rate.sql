drop table #matcodes
select c.msr_resource_code ITEMScope,msrr_standardized_description stddesc,msrr_description scopedesc, c.MSR_Attribute_Combination_Value stdcode, MSRR_Inserted_On, msrr_approved_on, MSRR_UOM_Code, MSR_IsActive
into #matcodes
from epm.SQLpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,
EPM.sqlpmp.Gen_M_Standard_Resource c
where a.msr_resource_code is not NULL and msrr_approved_by = b.uid and b.Company_Code='LE' 
and a.MSRR_Resource_Type_Code='scpl'
and c.msr_resource_code = a.msr_resource_code 



---select * from #matcodes


update #matcodes set stddesc = replace(stddesc, char(9),'-'), scopedesc = replace(scopedesc,char(9),'-')
update #matcodes set stddesc = replace(stddesc, char(10),'-'), scopedesc = replace(scopedesc,char(10),'-')
update #matcodes set stddesc = replace(stddesc, char(11),'-'), scopedesc = replace(scopedesc,char(11),'-')
update #matcodes set stddesc = replace(stddesc, char(12),'-'), scopedesc = replace(scopedesc,char(12),'-')
update #matcodes set stddesc = replace(stddesc, char(13),'-'), scopedesc = replace(scopedesc,char(13),'-')
update #matcodes set stddesc = replace(stddesc, char(14),'-'), scopedesc = replace(scopedesc,char(14),'-')
update #matcodes set stddesc = replace(stddesc, char(15),'-'), scopedesc = replace(scopedesc,char(15),'-')
update #matcodes set stddesc = replace(stddesc, '''','-'), scopedesc = replace(scopedesc,'''','-')
update #matcodes set stddesc = replace(stddesc, '"','-'), scopedesc = replace(scopedesc,'"','-')

--select * from #matcodes

select distinct a.HPO_Job_Code jobcode,  a.HPO_PO_Number POnumber, stdcode, right(DPO_Material_Code,6)  scope, DPO_Material_Code Scopecode,b.DPO_Net_Rate rate, b.DPO_Qty,f.UUOM_Description,
		b.DPO_VALUE itemvalue, d.Sector_Code IC,
		scopedesc, stddesc, HPO_PO_Type_Code, e.MMGRP_Description category, d.job_description, hpo_po_date,location, MSRR_Inserted_On, msrr_approved_on, MMC_Description, HPO_Last_Amendment_Number
from eip.sqlscm.SCM_H_Purchase_Orders a, eip.sqlscm.SCM_D_Purchase_Orders b, #matcodes c, lnt.dbo.job_master d,
		eip.sqlmas.GEN_M_Material_Groups e, eip.sqlmas.GEN_U_Unit_Of_Measurement f, eip.sqlmas.GEN_M_Materials, epm.sqlpmp.GEN_M_Material_Category, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,eip.sqlmas.GEN_M_Material_Classes

where a.hpo_po_number = b.Dpo_po_number and c.itemscope = b.DPO_Material_Code and a.HPO_Job_Code = d.job_code and f.UUOM_UOM_Code= c.MSRR_UOM_Code 
and a.HPO_PO_Date>='02-Aug-2017' and e.MMGRP_MG_Code= MMAT_MG_Code and e.MMGRP_Company_Code= 1 and MMAT_Material_Code= DPO_Material_Code
and MMATC_Class_Code = e.MMGRP_Class_Code
and HPO_Last_Amendment_number=DPO_Amendment_Number
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Company_Code=1 and LMMCLM_Material_Category_Code= MMC_Material_Category_Code
and MMAT_Company_Code=1 and HPO_Company_Code=1
--and category
and d.job_operating_group<>'I' 
--and DPO_Material_Code='3O41M0002000001' 
--and DPO_ISActive='Y'
order by 3



---sample
select *from eip.sqlmas.GEN_M_Material_Groups 
where MMGRP_MG_Code='6M11' and MMGRP_Company_Code=1

select * from eip.sqlmas.GEN_M_Materials where MMAT_Material_CodE in ('6M11M00L3000000' , '6M11M00L1000000','6M11M00KZ000000')

Select *from eip.sqlmas.GEN_M_Materials where MMAT_ISActive ='N' and MMAT_Inserted_On >='02-Aug-2017' AND mmat_company_code =1

select * from eip.sqlmas.GEN_M_Materials where MMAT_Material_Code='6M11M00L1000000'
select * from #matcodes where ITEMScope='6M13M0001000052'

USE epm
GO
SELECT *FROM eip.sqlmas.GEN_M_Material_Groups

select * from sys.tables where name like '%code%'

select  ITEMScope,stddesc,scopedesc, stdcode,MSRR_Inserted_On, msrr_approved_on, cast ( null as varchar(500)) category, cast ( null as varchar(50)) MJITC_IsActive, cast ( null as varchar(500)) markupdescr,MSRR_UOM_Code, MSR_IsActive into #scodes from #matcodes 


UPDATE A SET a.category = MIGRP_Description  FROM #scodes a, epm.sqlpmp.GEN_M_Item_Groups b
where MIGRP_Item_Group_Code = left(ITEMSCOPE,4)

UPDATE A SET A.MJITC_IsActive = B.MJITC_ISACTIVE FROM #scodes a,eip.sqlwom.wom_m_job_item_codes B
WHERE MJITC_Item_Code= itemscope
and MJITC_Company_Code=1
and B.MJITC_IsActive ='Y'


select *from #scodes

drop table #scodes