
drop table #link


select HMRN_MRN_DATE, HMRN_JOB_CODE,job_description, n.Sector_Code,n.bu_code,HPO_PO_Date, HMRN_PO_NUMBER,HMRN_WAREHOUSE_CODE,HMRN_BA_CODE,j.vendor_description,
Sector_Description, bu_description, DMRN_MRN_Number, DMRN_MATERIAL_CODE, DMRN_ACCEPTED_QTY,DMRN_Basic_Rate, DMRN_Net_Rate,DMRN_Value, MMAT_MG_Code,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,
MMAT_Material_Description,mmatc_description, HMRN_Currency_Code
,MMAT_Material_Code,MMATC_Company_Code
--,MMC_Description
into #link
from eip.sqlscm.SCM_D_MRN a, eip.sqlscm.SCM_H_MRN b, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,eip.sqlmas.GEN_U_Unit_Of_Measurement, 
lnt.dbo.vendor_master j,lnt.dbo.job_master n,eip.sqlmas.GEN_M_Material_Classes, lnt.dbo.business_unit_master p, lnt.dbo.Sector_Master q, eip.sqlscm.SCM_H_Purchase_Orders

--, epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping,epm.sqlpmp.GEN_M_Material_Category


WHERE hmrn_mrn_number = DMRN_MRN_Number 
and HPO_PO_Number = hmrn_po_number 
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
and HMRN_MRN_DATE between '01-Apr-2017' AND '30-Apr-2018'
and HMRN_Company_code  ='1'
and n.bu_code = p.bu_code 
AND p.Company_Code='LE'
and HPO_Company_Code=1
and n.sector_code = q.Sector_Code 
AND q.Company_Code='LE'
and hpo_ds_code =3--- = 3
--and HMRN_PO_Number = 'EG377PO7000011'

and job_operating_group <> 'I'

--and mmat_mg_code in ('3102','3103','3105','3115','3116','3118','3123','3124','3125','3126','3890','312640','312695','3190','3205','3290','3703','3844','3846','3885','3901','3990','6106','6190','73102','73105','73124','73125','73126','73340','75201','76152','770003','770052','770153','770214','770435','770441','770495','770574','770610','770676','770773','770778','770797','770933','770951','770973','771041','771105','771130','771131','771181','771187','771211','771218','771219','771236','771309','771316','771332','771336','771341','771478','771486','771508','771519','771568','771590','771591','771593','771600','771605','771606','771665','771675','771678','771697','771702','771709','771713','771776','771786','771805','771852','771854','771877','771884','771898','771900','771906','771913','771929','771943','771955','771961','771966','771977','771982','771991','771995','772000','772002','772015','772031','772044','772045','772053','772060','772074','772075','772081','772093','772103','772107','772118','772121','772133','772136','772138','772163','772166','772172','772187','772202','772208','772209','772211','772213','772215','772223','772229','772230','772238','772239','772244','772239','772244','772265','772276','772281','772292','772295','772299','772301','772302','772309','772319','772320','772323','772325','772339','772365','772369','772383','772386','772390','772392','772397','772410','772415','772420','772426','772431','772437','772456','772466','772467','772478','772497','772504','772512','772515','772524','772533','772534','772543','772555','772569','772572','772573','772586','772600','772601','772607','772613','772642','772643','772647','772649','772670','772688','772690','772694','772695','772699','772722','772747','772754','772757','772759','772778','772779','772787','772796','772797','772798','772804','772815','772823','772824','772826','772835','772837','772847','772852','772853','772855','772857','772875','772885','772889','772897','772905','772906','772937','772940','772942','772944','772948','772967','772975','772992','772997','772998','773001','773021','773026','773031','773032','773037','773038','773042','773056','773058','773059','773063','773137','773158','773161','773167','773203','773206','773207','773210','773213','773219','773229','773252','773287','773295','773339','773352','773381','773390','773407','773408','773453','773474','773588','773668')
and mmat_mg_code in ('091013','6E48','770455','771218','771333','771417','771486','771671','771809','771867','772020','772243','772308','772378','772392','772410','772442','772448','772495','772500','772516','772560','772572','772667','772671','772688','772723','772737','772747','772754','772771','772787','772793','772799','772801','772804','772808','772831','772834','772892','772905','772906','772944','772957','772970','773024','773066','773086','773104','773111','773115','773128','773155','773161','773189','773198','773218','773253','773266','773271','773287','773332','773337','773355','773361','773434','773435','773437','773455','773471','773508','773546','773559','02532','02540','02542','02550','02563','02570','02575','02592','02594','02595','02596','02598','09901','1099','1196','1372','70000','71099','771455','771555','771902','772034','772172','772260','772269','772292','772319','772424','772706','772798','773014','773071','773099','773125','773178','773184','773200','773213','773215','773252','773256','773274','773282','773308','773329','773399','773449','773504','773558')


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


select *from #link2 where mmat_mg_code in ('312640')


select  distinct dmrn_material_code, mmc_description, MMAT_Material_Description, MMGRP_Description, MMATC_Description from #link2

								

select distinct DMRN_Material_Code, MMC_Description, MMAT_Material_Description FROM #LINK WHERE DMRN_MRN_Number IN ('EF397MRN7000896')



select *from #link where HMRN_PO_Number in ('EB988PO7000129')




Select *from eip.sqlscm.SCM_D_MRN,eip.sqlscm.SCM_H_MRN  where  HMRN_PO_Number in ('EG377PO7000011')AND HMRN_COMPANY_CODE  ='1' AND hmrn_mrn_number = DMRN_MRN_Number 



Select * from eip.sqlscm.SCM_H_MRN where HMRN_MRN_Number ='EF397MRN7000896'

select *from eip.sqlmas.GEN_M_Materials
select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_Category_Type_Code IS NOT NULL
select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_Category_Type_Code IS NULL

Select distinct COUNT(HMRN_MRN_Number) MRNCOUNT FROM  eip.sqlscm.SCM_h_MRN where HMRN_MRN_Date between '01-Jan-2016' and '31-Dec-2016' and HMRN_Company_Code ='1'

select distinct DMRN_MRN_Number,count(DMRN_MATERIAL_CODE) from eip.sqlscm.SCM_D_MRN WHERE DMRN_Inserted_On between '01-Jan-2016' and '31-Dec-2016' AND DMRN_Company_Code ='1'

GROUP BY DMRN_Material_Code, DMRN_MRN_Number

select * from eip.sqlscm.SCM_D_Purchase_Orders where DPO_PO_Number = 'E0188PO7000005' AND
SELECT *FROM EIP.SQLSCM.SCM_D_PO_Payment_Terms


SE