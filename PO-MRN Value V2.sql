
drop table #link


select HMRN_MRN_DATE, HMRN_JOB_CODE,job_description, n.Sector_Code,n.bu_code,HPO_PO_Date, HMRN_PO_NUMBER,HMRN_WAREHOUSE_CODE,HMRN_BA_CODE,j.vendor_description,
Sector_Description, bu_description, DMRN_MRN_Number, DMRN_MATERIAL_CODE, DMRN_ACCEPTED_QTY,DMRN_Basic_Rate, DMRN_Net_Rate,DMRN_Value, MMAT_MG_Code,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,
MMAT_Material_Description,mmatc_description, HMRN_Currency_Code, HPO_PO_Basic_Value, HPO_PO_Net_Value
,MMAT_Material_Code,MMATC_Company_Code, DPO_QTY
--,MMC_Description
into #link
from eip.sqlscm.SCM_D_MRN a, eip.sqlscm.SCM_H_MRN b, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,eip.sqlmas.GEN_U_Unit_Of_Measurement, 
lnt.dbo.vendor_master j,lnt.dbo.job_master n,eip.sqlmas.GEN_M_Material_Classes, lnt.dbo.business_unit_master p, lnt.dbo.Sector_Master q, eip.sqlscm.SCM_H_Purchase_Orders,  eip.sqlscm.SCM_D_Purchase_Orders

--, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category


WHERE hmrn_mrn_number = DMRN_MRN_Number 
and HPO_PO_Number = hmrn_po_number 
and HPO_PO_NUMBER = DPO_PO_NUMBER
AND DPO_Material_Code = DMRN_Material_Code
and MMAT_Material_Code= DMRN_Material_Code
and MMAT_Company_Code=1 
and MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=MMAT_Company_Code
and MMAT_UOM_Code = UUOM_UOM_Code
and Hmrn_BA_CODE= j.vendor_code
and j.company_code = 'LE'
and Hmrn_Job_Code =job_code
and HPO_Job_Code = hmrn_job_code
and MMATC_Class_Code = MMGRP_Class_Code
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code
--and LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1
and MMAT_Company_Code= MMATC_Company_Code 
--and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
--and LMMCLM_Company_Code=1 
and MMAT_Company_Code= MMATC_Company_Code
--and MMAT_Category_Type_Code=MMGRP_Category_Type_Code and MMAT_Category_Type_Detail_Code=MMGRP_Category_Type_Detail_Code

--and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
--and LMMCLM_Material_Category_Code= MMC_Material_Category_Code
---and HMRN_MRN_DATE between '01-Jan-2017' AND '31-Dec-2017'
and HMRN_Company_code  ='1'
and n.bu_code = p.bu_code 
AND p.Company_Code='LE'
and HPO_Company_Code=1
and n.sector_code = q.Sector_Code 
AND q.Company_Code='LE'
--and hpo_ds_code =3--- = 3
and HMRN_PO_Number in ('EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG558PO7000011','EG558PO7000013','EG559PO7000036','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG559PO7000056','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG559PO7000033','EG559PO7000038','EG559PO7000056','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO7000086','EG450PO7000036','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EF201PO7000140','EF201PO7000139','EE646PO7000044','EE646PO7000045','EE646PO7000040','EE646PO7000041','EF201PO7000085','EF201PO7000082','EC030PO7000637','EC030PO7000638','EC999PO7000174','EC999PO7000175','EC999PO7000178','EC999PO7000179','EC030PO7000636','EC999PO7000173','EC999PO7000177','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC030PO7000474','EC030PO7000391','EC030PO7000514','EC030PO7000509','EC030PO7000338','EC030PO7000339','EG569PO7000010','ED145PO7000305','EF618PO7001608','EF618PO7001615','EG162PO7001432','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG745PO7000018','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EG745PO7000093','EF715PO7000146','EF893PO7000290','EF037PO7000141','EF037PO7000146','E9231PO8000001','EF674PO7000200','EF674PO7000199','EG132PO7000146','EE970PO8000011','EG413PO7000035','EE970PO8000010')


update #link set MMATC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMATC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set mmgrp_description= replace(replace(replace(replace(replace(replace(replace(replace(replace(mmgrp_description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set MMAT_Material_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

--update #link set MMC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMC_Description,char(9),'-'),char(10),'-'),
                                  --char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
select *from #link



select MMC_Description, a.*
into #link2
from #link a
left join epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping on (MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code and LMMCLM_Company_Code=1 )
left join epm.sqlpmp.GEN_M_Material_Category b on (LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1)

update #link2 set MMC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

select  distinct dmrn_material_code, mmc_description, MMAT_Material_Description, MMGRP_Description, MMATC_Description from #link2

								

select distinct DMRN_Material_Code, MMC_Description, MMAT_Material_Description FROM #LINK WHERE DMRN_MRN_Number IN ('EF397MRN7000896')



select *from #link where HMRN_PO_Number in ('EB988PO7000129')




Select *from eip.sqlscm.SCM_D_MRN,eip.sqlscm.SCM_H_MRN  where  HMRN_PO_Number in ('JJ001PO7000003')
--AND HMRN_COMPANY_CODE  ='1' 
AND hmrn_mrn_number = DMRN_MRN_Number 



Select * from eip.sqlscm.SCM_H_MRN where HMRN_MRN_Number ='EF397MRN7000896'

select *from eip.sqlmas.GEN_M_Materials
select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_Category_Type_Code IS NOT NULL
select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_Category_Type_Code IS NULL

Select distinct COUNT(HMRN_MRN_Number) MRNCOUNT FROM  eip.sqlscm.SCM_h_MRN where HMRN_MRN_Date between '01-Jan-2016' and '31-Dec-2016' and HMRN_Company_Code ='1'

select distinct DMRN_MRN_Number,count(DMRN_MATERIAL_CODE) from eip.sqlscm.SCM_D_MRN WHERE DMRN_Inserted_On between '01-Jan-2016' and '31-Dec-2016' AND DMRN_Company_Code ='1'

GROUP BY DMRN_Material_Code, DMRN_MRN_Number

select * from eip.sqlscm.SCM_D_Purchase_Orders where DPO_PO_Number IN ('JJ001PO7000003','JJ001PO7000005','JJ001PO7000006')

SELECT *FROM LNT.DBO.JOB_MASTER WHERE JOB_CODE = 'LJ170001'

select *from eip.sqlscm.scm_h_po_amend_request where dpoar_request_number = 'ED145POA7000010'

use eip
go


select *from sys.tables where name like '%amend%'

select * from eip.sqlscm.SCM_h_Purchase_Orders 