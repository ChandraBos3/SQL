select sector_code,DMRN_Material_Code, mmgrp_mg_code,mmgrp_description,sum(DMRN_Value) itemvalue
from eip.sqlscm.scm_h_mrn a, eip.sqlscm.scm_d_mrn ,eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, lnt.dbo.job_master 
where a.HMRN_MRN_Number = dmrn_mrn_number and c.MMGRP_MG_Code= MMAT_MG_Code and MMAT_Material_Code= DMRN_Material_Code
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code= a.HMRN_Company_Code 
and hmrn_mrn_date between '01-Jul-2017' and '31-July-2017'
and hmrn_company_code = 1
and a.HMRN_Job_Code= job_code and company_code='LE'
AND a.HMRN_PO_Number IS NOT NULL
and  exists ( select top 1 'x' from epm.sqlepm.EPM_M_Control_Master where a.HMRN_Job_Code = TCM_Job_Code and TCM_PMP_TAG='Y' and TCM_EPM_Tag='N') group by Sector_Code, mmgrp_mg_code,c.MMGRP_Description,DMRN_Material_Code



--select * from epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping where LMMCLM_Material_Code='313050000' and where LMMCLM_Company_Code=1
drop table #grouplink
select MMAT_Material_Code, MMATC_Description, mmgrp_mg_code,mmgrp_description, MMAT_Material_Description,DMRN_Value, LMMCLM_Material_Category_Code, MMC_Description,MMAT_ISActive,f.HMRN_PO_Number,hmrn_mrn_date into #grouplink
from eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Classes ,epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,
eip.sqlscm.scm_h_mrn f, eip.sqlscm.scm_d_mrn g,
epm.sqlpmp.GEN_M_Material_Category, lnt.dbo.job_master 
where c.MMGRP_MG_Code= MMAT_MG_Code  and MMATC_Class_Code = c.MMGRP_Class_Code and f.HMRN_MRN_Number = g.dmrn_mrn_number
and hmrn_mrn_date between '01-Aug-2017' and '16-Aug-2017'
and hmrn_company_code = 1
and f.HMRN_Job_Code= job_code and company_code='LE'
AND f.HMRN_PO_Number IS NOT NULL
and c.MMGRP_Company_Code= MMAT_Company_Code and MMAT_Company_Code= 1
and MMAT_Company_Code= MMATC_Company_Code and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
and LMMCLM_Company_Code=1 and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1 --and mmat_material_Code='313050000'


Update #grouplink set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),
						MMC_Description=replace(MMC_Description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #grouplink set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),
						MMC_Description=replace(MMC_Description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #grouplink set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),
						MMC_Description=replace(MMC_Description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #grouplink set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),
						MMC_Description=replace(MMC_Description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #grouplink set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),
						MMC_Description=replace(MMC_Description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #grouplink set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),
						MMC_Description=replace(MMC_Description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #grouplink set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),
						MMC_Description=replace(MMC_Description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #grouplink set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),
						MMC_Description=replace(MMC_Description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')

--select * from #grouplink where mmat_material_description like '%safety%Shoes%'
--select  * from #grouplink where MMAT_Material_Code='313022381'

--select * from #grouplink where MMC_Description like '%aggregate%'
select * from #grouplink


--update #grouplink 