
drop table #link


select HMRN_MRN_DATE, HMRN_JOB_CODE,job_description, n.Sector_Code,n.bu_code,HPO_PO_Date, HMRN_PO_NUMBER,HMRN_WAREHOUSE_CODE,HMRN_BA_CODE,j.vendor_description,
Sector_Description, bu_description, DMRN_MRN_Number, DMRN_MATERIAL_CODE, DMRN_ACCEPTED_QTY,DMRN_Basic_Rate, DMRN_Net_Rate,DMRN_Value, MMAT_MG_Code,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,
MMAT_Material_Description,mmatc_description, HMRN_Currency_Code, HPO_PO_Basic_Value, HPO_PO_Net_Value, SBG_Code
,MMAT_Material_Code,MMATC_Company_Code,location,dpo_material_code,DPO_Net_Rate,DPO_Basic_Rate,(DPO_Qty - DPO_Cancelled_Qty) Volume,DPO_PO_Number, ((DPO_Qty - DPO_Cancelled_Qty)*DPO_Net_Rate) Value, HPO_Currency_Code,HPO_last_Amendment_Number,  dpo_amendment_number
, HPO_Warehouse_Code,HPO_DS_Code, hpo_mr_number
,DPOT_Direct_Supply,DPOT_Freight_Value,DPOT_Packing_Forwarding_Value,DPOT_Others_Value,dpo_qty old_qty,
DPO_Value old_value, ((DPO_Qty - DPO_Cancelled_Qty) *(DPO_net_rate-dpo_basic_rate)) TaxRate,HPO_Job_Code, HPO_BA_Code
--,MMC_Description
into #link
from eip.sqlscm.SCM_D_MRN a, eip.sqlscm.SCM_H_MRN b, eip.sqlmas.GEN_M_Materials, eip.sqlmas.GEN_M_Material_Groups,eip.sqlmas.GEN_U_Unit_Of_Measurement, 
lnt.dbo.vendor_master j,lnt.dbo.job_master n,eip.sqlmas.GEN_M_Material_Classes, lnt.dbo.business_unit_master p, lnt.dbo.Sector_Master q, eip.sqlscm.SCM_H_Purchase_Orders,  eip.sqlscm.SCM_D_Purchase_Orders
,eip.sqlscm.scm_d_purchase_order_terms f
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
and hpo_po_number = f.dpot_po_number and HPO_Last_Amendment_Number = f.dpot_amendment_number
--and MMAT_Category_Type_Code=MMGRP_Category_Type_Code and MMAT_Category_Type_Detail_Code=MMGRP_Category_Type_Detail_Code

--and MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMATC_Company_Code
--and LMMCLM_Material_Category_Code= MMC_Material_Category_Code
---and HMRN_MRN_DATE between '01-Jan-2017' AND '03-jAN-2017'
and HMRN_Company_code  ='1'
and n.bu_code = p.bu_code 
AND p.Company_Code='LE'
and HPO_Company_Code=1
and n.sector_code = q.Sector_Code 
AND q.Company_Code='LE'
--and hpo_ds_code =3--- = 3
--and HMRN_PO_Number in ('EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG558PO7000011','EG558PO7000013','EG559PO7000036','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG559PO7000056','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG559PO7000033','EG559PO7000038','EG559PO7000056','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO7000086','EG450PO7000036','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EF201PO7000140','EF201PO7000139','EE646PO7000044','EE646PO7000045','EE646PO7000040','EE646PO7000041','EF201PO7000085','EF201PO7000082','EC030PO7000637','EC030PO7000638','EC999PO7000174','EC999PO7000175','EC999PO7000178','EC999PO7000179','EC030PO7000636','EC999PO7000173','EC999PO7000177','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC030PO7000474','EC030PO7000391','EC030PO7000514','EC030PO7000509','EC030PO7000338','EC030PO7000339','EG569PO7000010','ED145PO7000305','EF618PO7001608','EF618PO7001615','EG162PO7001432','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG745PO7000018','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EG745PO7000093','EF715PO7000146','EF893PO7000290','EF037PO7000141','EF037PO7000146','E9231PO8000001','EF674PO7000200','EF674PO7000199','EG132PO7000146','EE970PO8000011','EG413PO7000035','EE970PO8000010')
--AND HMRN_PO_NUMBER IN ('EE361PO7001027','EF398PO7001401','EF823PO7001276','EF823PO8000096','EF906PO8000209','EF908PO8000221','EF907PO8000174','EG147PO8000119','EF823PO7001332','EH414PO8000370','EF684PO8000002','ED145PO7000305','EG001PO8000062','EG001PO8000063','EG001PO8000149','EG001PO8000148','EF618PO7001608','EF618PO7001615','EG162PO7001432','EH354PO8000278','EH354PO8000191','EH354PO8000198','EH354PO8000296','EH354PO8000379','EH354PO8000225','EH354PO8000289','EH354PO8000552','EH354PO8000444','EH354PO8000445','EH354PO8000415','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000056','EH002PO8000346','EC030PO7000636','EC030PO7000637','EC030PO7000638','EF201PO8000001','EF201PO8000002','EE646PO7000040','EE646PO7000041','EE646PO7000044','EE646PO7000045','EF201PO7000082','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO8000010','EG450PO8000011','EG450PO8000078','EG450PO8000109','EC999PO7000177','EC999PO7000178','EC999PO7000179','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC999PO7000173','EC999PO7000174','EC999PO7000175','JJ001PO8000004','JJ001PO8000001','JJ001PO8000002','EC030PO7000338','EC030PO7000499','EC030PO7000500','EC030PO7000509','EC030PO7000514','EC030PO7000519','EC030PO8000017','EC030PO8000018','EC030PO8000019','EC030PO8000021','EC030PO8000035','EF201PO7000085','EG450PO7000036','EG450PO7000086','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','EG450PO7000102','EG569PO7000010','EC030PO7000391','EC030PO7000445','EC030PO7000446','EC030PO7000447','EC030PO7000448','EC030PO7000449','EC030PO7000450','EC030PO7000451','EC030PO7000473','EC030PO7000474','EC030PO7000522','EC030PO7000523','EC030PO7000524','EC030PO7000523','EC030PO7000524','EG798PO8000003','EG798PO8000004','EG450PO7000046','EG450PO8000018','EC030PO7000339','EF201PO7000140','EF201PO7000139','EC030PO8000252','EC030PO8000332','EC030PO8000067','EC030PO8000068','EC030PO8000348','EC030PO8000349','EE646PO7000042','EE646PO7000046','EE646PO7000047','EE646PO7000048','EE646PO7000049','EE646PO7000050','EE646PO7000051','EE646PO7000052','EE646PO7000053','EE646PO7000054','EE646PO8000007','EE646PO8000008','EE646PO8000035','EE646PO8000036','EE646PO8000037','EE646PO8000038','EE646PO8000017','EF201PO8000062','EF201PO8000066','EF201PO8000012','EF201PO8000013','JJ001PO8000003','JJ001PO8000005','JJ001PO8000006','EG450PO8000021','EG450PO8000234','EG450PO8000258 ','EG569PO8000067','EG569PO8000066','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EE970PO8000010','EG413PO7000035','EE970PO8000011','EG132PO7000146','EF674PO7000199','EF674PO7000200','E9231PO8000001','EF037PO7000141','EF037PO7000146','EF893PO7000290','EF715PO7000146','EG745PO7000093','EG745PO7000018','EG247PO8000014','EE770PO8000041','EE770PO8000017','EF889PO8000060','EF889PO8000059','EF890PO8000059','EF890PO8000060','EF715PO7000063','EF715PO7000075','EF628PO7000144','EF768PO7000005','EF768PO7000006','EF768PO7000007','EF768PO7000008','EF807PO7000088','EF893PO7000122 ','EG649PO7000018','EG132PO7000035','EF674PO7000130','EF674PO7000131','EF674PO7000132','EF674PO7000133','EF674PO7000134','EF292PO7000299','EF292PO7000300','EB053PO7000061','EE770PO8000164','EG336PO7000056','EF888PO7000052 ','EE770PO7000409','EG448PO7000097','EF890PO7000238','EF674PO7000186','EG314PO7000032','EG314PO7000029','EH233PO7000003','EH246PO7000002','EH236PO7000002','EG247PO7000093','EG745PO8000120','EF715PO8000031','EF715PO8000032','EG381PO8000026','EE770PO8000051','EA331PO8000016','EG745PO8000033','EG745PO8000091','EC402PO7000320','EG379PO8000037','EG379PO8000039','EG379PO8000008','EG381PO8000046','EG381PO8000048','EG448PO8000100','EF715PO8000016','EG520PO8000060','EG466PO8000070','EF715PO8000025','EG390PO8000054','EG390PO8000055','EG390PO8000056','EG745PO8000102','EG745PO8000121','EC402PO8000103','EG034PO8000120','EF831PO8000070','EG132PO7000100','EF893PO7000122','EF888PO7000052','EG132PO7000113')
and hmrn_po_number ='E2693PO7000028'

update #link set MMATC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMATC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set mmgrp_description= replace(replace(replace(replace(replace(replace(replace(replace(replace(mmgrp_description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
update #link set MMAT_Material_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMAT_Material_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

--update #link set MMC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMC_Description,char(9),'-'),char(10),'-'),
                                  --char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')




select *from #link

	

	
alter table #link add ICdesc varchar(100)
alter table #link add BUdesc varchar(100)
alter table #link add Jobdesc varchar(200)
alter table #link add Locdesc varchar(200)
alter table #link add city varchar (200)
alter table #link add state1 varchar (200)
alter table #link add sbgdesc varchar (200)


UPDATE a SET ICdesc = b.Sector_Description
from #link a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #link a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #link a, LNT.dbo.job_master b
WHERE a.HMRN_Job_Code = b.job_code 
AND b.Company_Code='LE'

UPDATE a SET Locdesc  = b.region_description
from #link a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

update a set city =UCITY_Name, state1=USTAT_Name
 from #link a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and HMRN_Job_Code =mjob_job_code

UPDATE a SET sbgdesc = b.SBG_Description
from #link a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 



alter table #link add materialcategory VARCHAR (500)
alter table #link add PlanningCategory VARCHAR (500)


 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where DMRN_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where DMRN_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1


alter table #link add newfreight VARCHAR (500)
alter table #link add othertaxes VARCHAR (500)


update a set newfreight = d.freight 
from #link a, (select hmrn_po_number,dmrn_material_code,  sum(dporc_value) freight
from #link, eip.SQLSCM.SCM_D_PO_Rate_Components
where hmrn_po_number = dporc_po_number 
and dmrn_material_code =dporc_material_code 
---and dpo_po_number = 'E2693PO7000028'
--and dporc_rate_component_code in ('10','1004','1005')
and dporc_rate_component_code in ('10')
group by hmrn_po_number, dmrn_material_code) d
where a.hmrn_po_number = d.hmrn_po_number
and a.dmrn_material_code = d.DMRN_Material_Code

update a set othertaxes = d.taxothers 
from #link a, (select hmrn_po_number,dmrn_material_code,  sum(dporc_value) taxothers
from #link, eip.SQLSCM.SCM_D_PO_Rate_Components
where hmrn_po_number = dporc_po_number 
and dmrn_material_code =dporc_material_code 
---and dpo_po_number = 'E2693PO7000028'
and dporc_rate_component_code in ('8','1004','1005')
--and dporc_rate_component_code in ('8')
group by hmrn_po_number, dmrn_material_code) d
where a.hmrn_po_number = d.hmrn_po_number

and a.dmrn_material_code = d.DMRN_Material_Code





select *from #link








--------
drop table #link2

select cast (null as Date) HMRN_MRN_DATE, cast (null as varchar(20)) HMRN_JOB_CODE,job_description, n.Sector_Code,n.bu_code,HPO_PO_Date, cast (null as varchar(50)) HMRN_PO_NUMBER,cast (null as varchar(50)) HMRN_WAREHOUSE_CODE,cast (null as varchar(50)) HMRN_BA_CODE,j.vendor_description,
Sector_Description, bu_description,cast (null as varchar(50)) DMRN_MRN_Number, cast (null as varchar(50))DMRN_MATERIAL_CODE, cast (null as money)DMRN_ACCEPTED_QTY,cast (null as money) DMRN_Basic_Rate,cast (null as money) DMRN_Net_Rate,cast (null as money) DMRN_Value, MMAT_MG_Code,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,
MMAT_Material_Description,mmatc_description, cast (null as varchar(10)) HMRN_Currency_Code, HPO_PO_Basic_Value, HPO_PO_Net_Value, SBG_Code
,MMAT_Material_Code,MMATC_Company_Code,location,dpo_material_code,DPO_Net_Rate,DPO_Basic_Rate,(DPO_Qty - DPO_Cancelled_Qty) Volume,DPO_PO_Number, ((DPO_Qty - DPO_Cancelled_Qty)*DPO_Net_Rate) Value, HPO_Currency_Code,HPO_last_Amendment_Number,  dpo_amendment_number
, HPO_Warehouse_Code,HPO_DS_Code, hpo_mr_number
,DPOT_Direct_Supply,DPOT_Freight_Value,DPOT_Packing_Forwarding_Value,DPOT_Others_Value,dpo_qty old_qty,
DPO_Value old_value, ((DPO_Qty - DPO_Cancelled_Qty) *(DPO_net_rate-dpo_basic_rate)) TaxRate,HPO_Job_Code, HPO_BA_Code,HPO_PO_Number
 into #link2
 from eip.sqlscm.SCM_H_Purchase_Orders   , eip.sqlscm.SCM_d_Purchase_Orders,
 lnt.dbo.job_master n,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials , eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement , lnt.dbo.vendor_master j
  ,eip.sqlscm.scm_d_purchase_order_terms f, lnt.dbo.business_unit_master p, lnt.dbo.Sector_Master q

-------------------
  WHERE  HPO_PO_NUMBER = DPO_PO_NUMBER

and MMAT_Material_Code= DPO_Material_Code
and MMAT_Company_Code=1 
and MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=MMAT_Company_Code
and MMAT_UOM_Code = UUOM_UOM_Code
and HPO_BA_Code= j.vendor_code
and j.company_code = 'LE'
and HPO_Job_Code =job_code
and MMATC_Class_Code = MMGRP_Class_Code
and MMGRP_Class_Code = MMATC_Class_Code and MMGRP_Company_Code=MMATC_Company_Code

and MMAT_Company_Code= MMATC_Company_Code 

and MMAT_Company_Code= MMATC_Company_Code
and hpo_po_number = f.dpot_po_number and HPO_Last_Amendment_Number = f.dpot_amendment_number

---and HMRN_MRN_DATE between '01-Jan-2017' AND '03-jAN-2017'
and HPO_Company_Code  ='1'
and n.bu_code = p.bu_code 
AND p.Company_Code='LE'
and HPO_Company_Code=1
and n.sector_code = q.Sector_Code 
AND q.Company_Code='LE'
--and hpo_ds_code =3--- = 3
--and HMRN_PO_Number in ('EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG558PO7000011','EG558PO7000013','EG559PO7000036','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG559PO7000056','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG559PO7000033','EG559PO7000038','EG559PO7000056','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO7000086','EG450PO7000036','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EF201PO7000140','EF201PO7000139','EE646PO7000044','EE646PO7000045','EE646PO7000040','EE646PO7000041','EF201PO7000085','EF201PO7000082','EC030PO7000637','EC030PO7000638','EC999PO7000174','EC999PO7000175','EC999PO7000178','EC999PO7000179','EC030PO7000636','EC999PO7000173','EC999PO7000177','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC030PO7000474','EC030PO7000391','EC030PO7000514','EC030PO7000509','EC030PO7000338','EC030PO7000339','EG569PO7000010','ED145PO7000305','EF618PO7001608','EF618PO7001615','EG162PO7001432','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG745PO7000018','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EG745PO7000093','EF715PO7000146','EF893PO7000290','EF037PO7000141','EF037PO7000146','E9231PO8000001','EF674PO7000200','EF674PO7000199','EG132PO7000146','EE970PO8000011','EG413PO7000035','EE970PO8000010')
--AND HMRN_PO_NUMBER IN ('EE361PO7001027','EF398PO7001401','EF823PO7001276','EF823PO8000096','EF906PO8000209','EF908PO8000221','EF907PO8000174','EG147PO8000119','EF823PO7001332','EH414PO8000370','EF684PO8000002','ED145PO7000305','EG001PO8000062','EG001PO8000063','EG001PO8000149','EG001PO8000148','EF618PO7001608','EF618PO7001615','EG162PO7001432','EH354PO8000278','EH354PO8000191','EH354PO8000198','EH354PO8000296','EH354PO8000379','EH354PO8000225','EH354PO8000289','EH354PO8000552','EH354PO8000444','EH354PO8000445','EH354PO8000415','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000056','EH002PO8000346','EC030PO7000636','EC030PO7000637','EC030PO7000638','EF201PO8000001','EF201PO8000002','EE646PO7000040','EE646PO7000041','EE646PO7000044','EE646PO7000045','EF201PO7000082','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO8000010','EG450PO8000011','EG450PO8000078','EG450PO8000109','EC999PO7000177','EC999PO7000178','EC999PO7000179','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC999PO7000173','EC999PO7000174','EC999PO7000175','JJ001PO8000004','JJ001PO8000001','JJ001PO8000002','EC030PO7000338','EC030PO7000499','EC030PO7000500','EC030PO7000509','EC030PO7000514','EC030PO7000519','EC030PO8000017','EC030PO8000018','EC030PO8000019','EC030PO8000021','EC030PO8000035','EF201PO7000085','EG450PO7000036','EG450PO7000086','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','EG450PO7000102','EG569PO7000010','EC030PO7000391','EC030PO7000445','EC030PO7000446','EC030PO7000447','EC030PO7000448','EC030PO7000449','EC030PO7000450','EC030PO7000451','EC030PO7000473','EC030PO7000474','EC030PO7000522','EC030PO7000523','EC030PO7000524','EC030PO7000523','EC030PO7000524','EG798PO8000003','EG798PO8000004','EG450PO7000046','EG450PO8000018','EC030PO7000339','EF201PO7000140','EF201PO7000139','EC030PO8000252','EC030PO8000332','EC030PO8000067','EC030PO8000068','EC030PO8000348','EC030PO8000349','EE646PO7000042','EE646PO7000046','EE646PO7000047','EE646PO7000048','EE646PO7000049','EE646PO7000050','EE646PO7000051','EE646PO7000052','EE646PO7000053','EE646PO7000054','EE646PO8000007','EE646PO8000008','EE646PO8000035','EE646PO8000036','EE646PO8000037','EE646PO8000038','EE646PO8000017','EF201PO8000062','EF201PO8000066','EF201PO8000012','EF201PO8000013','JJ001PO8000003','JJ001PO8000005','JJ001PO8000006','EG450PO8000021','EG450PO8000234','EG450PO8000258 ','EG569PO8000067','EG569PO8000066','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EE970PO8000010','EG413PO7000035','EE970PO8000011','EG132PO7000146','EF674PO7000199','EF674PO7000200','E9231PO8000001','EF037PO7000141','EF037PO7000146','EF893PO7000290','EF715PO7000146','EG745PO7000093','EG745PO7000018','EG247PO8000014','EE770PO8000041','EE770PO8000017','EF889PO8000060','EF889PO8000059','EF890PO8000059','EF890PO8000060','EF715PO7000063','EF715PO7000075','EF628PO7000144','EF768PO7000005','EF768PO7000006','EF768PO7000007','EF768PO7000008','EF807PO7000088','EF893PO7000122 ','EG649PO7000018','EG132PO7000035','EF674PO7000130','EF674PO7000131','EF674PO7000132','EF674PO7000133','EF674PO7000134','EF292PO7000299','EF292PO7000300','EB053PO7000061','EE770PO8000164','EG336PO7000056','EF888PO7000052 ','EE770PO7000409','EG448PO7000097','EF890PO7000238','EF674PO7000186','EG314PO7000032','EG314PO7000029','EH233PO7000003','EH246PO7000002','EH236PO7000002','EG247PO7000093','EG745PO8000120','EF715PO8000031','EF715PO8000032','EG381PO8000026','EE770PO8000051','EA331PO8000016','EG745PO8000033','EG745PO8000091','EC402PO7000320','EG379PO8000037','EG379PO8000039','EG379PO8000008','EG381PO8000046','EG381PO8000048','EG448PO8000100','EF715PO8000016','EG520PO8000060','EG466PO8000070','EF715PO8000025','EG390PO8000054','EG390PO8000055','EG390PO8000056','EG745PO8000102','EG745PO8000121','EC402PO8000103','EG034PO8000120','EF831PO8000070','EG132PO7000100','EF893PO7000122','EF888PO7000052','EG132PO7000113')
and HPO_PO_Number ='E2693PO7000028'



and job_operating_group <>'I' 
--and left (dpo_material_code,1) in ('9')
---and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')

--and job_code in ('QOCSD019','CTTRA015','LE150574','LE160072','LE120318','LE120451','LE080156','LE140913','LE16D080','LE16D109','LE131284','LE131077','LE17D088','LE160914','LE140002','LE170554','LE160491','QGMAP013','LCBAF013','LE100260','LE090062','DGMAP014','CGMAP014','LE090397','LE170524','LE130465','LE120422','LE080192','YGFAA018','LE16D103','LE090333','LE160732','LE140586','LE160361','LE17D097','QGISD015')

--Group by dpo_material_code, location,mmatc_description,MMGRP_Description, MMAT_UOM_Code,UUOM_Description,job_code,DPO_Qty,DPO_PO_Number
Update #link2 set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link2 set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link2 set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link2 set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link2 set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link2 set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link2 set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link2 set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
--select * from #link2

alter table #link2 add ICdesc varchar(100)
alter table #link2 add BUdesc varchar(100)
alter table #link2 add Jobdesc varchar(200)
alter table #link2 add Locdesc varchar(200)
alter table #link2 add city varchar (200)
alter table #link2 add state1 varchar (200)
alter table #link2 add sbgdesc varchar (200)


UPDATE a SET ICdesc = b.Sector_Description
from #link2 a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #link2 a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET Jobdesc = b.job_description
from #link2 a, LNT.dbo.job_master b
WHERE a.HPO_Job_Code = b.job_code 
AND b.Company_Code='LE'

UPDATE a SET Locdesc  = b.region_description
from #link2 a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

update a set city =UCITY_Name, state1=USTAT_Name
 from #link2 a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and HPO_Job_Code =mjob_job_code

UPDATE a SET sbgdesc = b.SBG_Description
from #link2 a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 

alter table #LINK add NEWOLDCODE varchar(100)

uPDATE A SET NEWOLDCODE ='NEW'
FROM #LINK2 A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DPO_MATERIAL_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='MATR'
--AND MSR_Attribute_Combination_Value IS NOT NULL

select *from #link2

alter table #link2 add materialcategory VARCHAR (500)
alter table #link2 add PlanningCategory VARCHAR (500)


 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link2 a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link2 a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpo_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link2 a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 



alter table #link2 add newfreight VARCHAR (500)
alter table #link2 add othertaxes VARCHAR (500)


update a set newfreight = d.freight 
from #link2 a, (select hpo_po_number,dpo_material_code,  sum(dporc_value) freight
from #link2, eip.SQLSCM.SCM_D_PO_Rate_Components
where hpo_po_number = dporc_po_number 
and DPO_Material_Code =dporc_material_code 
---and dpo_po_number = 'E2693PO7000028'
--and dporc_rate_component_code in ('10','1004','1005')
and dporc_rate_component_code in ('10')
group by HPO_PO_Number, dpo_material_code) d
where a.HPO_PO_Number = d.HPO_PO_Number
and a.DPO_Material_Code = d.Dpo_Material_Code

update a set othertaxes = d.taxothers 
from #link2 a, (select hpo_po_number,dpo_material_code,  sum(dporc_value) taxothers
from #link2, eip.SQLSCM.SCM_D_PO_Rate_Components
where hpo_po_number = dporc_po_number 
and DPO_Material_Code =dporc_material_code  
---and dpo_po_number = 'E2693PO7000028'
and dporc_rate_component_code in ('8','1004','1005')
--and dporc_rate_component_code in ('8')
group by HPO_PO_Number, dpo_material_code) d
where a.HPO_PO_Number = d.HPO_PO_Number
and a.DPO_Material_Code = d.Dpo_Material_Code





select *from #link2
select *From #link






alter table #link2 add Constzon_Applicable VARCHAR (200)

UPDATE A SET a.Constzon_Applicable  = b.DPOCD_Rate_Applicable
from #LINK2 a
left join eip.SQLSCM.SCM_D_PO_ConstZon_Details b  on 
 DPOCD_PO_Number = DPO_PO_Number 
					AND DPOCD_Amendment_Number = hPO_last_Amendment_Number AND DPOCD_Material_Code = DPO_Material_Code


					alter table #LINK add EPM_Tag varchar (5)

Update a set EPM_Tag = TCM_EPM_Tag 
from #Link2  a 

left join EPM.sqlepm.EPM_M_Control_Master b on JOB_CODE=TCM_Job_Code 



alter table #LINK2 add MR_Date Date


Update a set mr_date = hmr_mr_date

from #link2 a 

left join eip.sqlscm.SCM_h_Material_Request on 

 hmr_mr_number = HPO_MR_Number and HMR_Company_Code=1

 select *from #link2
 
 alter table #LINK2 add mrnnumber varchar (50)
 alter table #LINK2 add mrndate Date
 alter table #LINK2 add mrnqty varchar (50)
 alter table #LINK2 add mrnvalue varchar (50)





 ---MRN-UPDATE

update a set mrnnumber= HMRN_MRN_Number, mrndate = HMRN_MRN_Date, mrnqty = DMRN_ACCEPTED_QTY , mrnvalue =DMRN_VALUE

from #link a,  
( select HMRN_MRN_Number, HMRN_PO_Number, HMRN_MRN_Date,  DMRN_ACCEPTED_QTY, DMRN_VALUE,DMRN_Material_Code
from  eip.sqlscm.SCM_H_MRN , eip.sqlscm.SCM_D_MRN b,#link c
where c.DPO_PO_Number = HMRN_PO_Number and HMRN_MRN_Number=b.DMRN_MRN_Number 
and c.DPO_Material_Code = B.DMRN_Material_Code ) d
where HMRN_PO_Number = a.DPO_PO_Number


 alter table #LINK add mrnumber varchar (50)
 alter table #LINK add mrdate Date



 
update a set mrnumber= d.HMR_MR_Number, mrdate = d.HMR_MR_Date

from #link a, ( select HMR_MR_Number,HMR_MR_Date
from   eip.sqlscm.SCM_H_Material_Request ,  eip.sqlscm.SCM_d_Material_Request b,#link c
where hmr_mr_number = HPO_MR_Number and hmr_mr_number = dmr_mr_number
and c.DPO_Material_Code =b.DMR_Material_Code) d


select *from #link

select *from eip.sqlscm.SCM_h_MRN where hmrn_mrn_number in ('JJ001PO7000003',
'JJ001PO7000005',
'JJ001PO7000006',
'JJ001PO8000001',
'JJ001PO8000002',
'JJ001PO8000003',
'JJ001PO8000004',
'JJ001PO8000005',
'JJ001PO8000006'
)





 select *from eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
and mjob_job_code = 'LE080311'


select *from   eip.sqlmas.GEN_M_Material_Groups















select h.dpo_material_code,h.DPO_Net_Rate,h.DPO_Basic_Rate,p.job_code,(h.DPO_Qty - h.DPO_Cancelled_Qty) Volume,h.DPO_PO_Number, g.hpo_po_date, ((h.DPO_Qty - h.DPO_Cancelled_Qty)*h.DPO_Net_Rate) Value,p.location, g.HPO_Currency_Code,g.HPO_last_Amendment_Number,  h.dpo_amendment_number
,g.HPO_BA_Code, j.vendor_description, p.sector_code, p.bu_code , p.SBG_Code, g.HPO_Warehouse_Code,g.HPO_DS_Code,g.HPO_PO_Basic_Value, g.HPO_PO_Net_Value, g.hpo_mr_number
,f.DPOT_Direct_Supply,f.DPOT_Freight_Value,f.DPOT_Packing_Forwarding_Value,f.DPOT_Others_Value,h.dpo_qty old_qty,
h.DPO_Value old_value, ((h.DPO_Qty - h.DPO_Cancelled_Qty) *(h.DPO_net_rate-h.dpo_basic_rate)) TaxRate, a.* from #link a,   eip.sqlscm.SCM_H_Purchase_Orders g  , eip.sqlscm.SCM_d_Purchase_Orders h, lnt.dbo.job_master p, lnt.dbo.vendor_master j
 ,eip.sqlscm.scm_d_purchase_order_terms f


where g.hpo_po_number = h.dpo_po_number 

--and hPO_last_amendment_Number  = dpo_amendment_number


--and MMAT_Material_Description like'%station%'
--and MMGRP_Description like '%station%'
--and left (dpo_material_code,1) in ('9')


and g.HPO_BA_CODE= j.vendor_code

and g.HPO_Company_Code=1
and g.HPO_Job_Code= p.job_code 
and j.company_code = 'LE'
and p.company_code='LE'


--and hpo_po_date between '01-Apr-2017' and '31-Mar-2018'

--and hpo_ds_code ='3'  -- and HPO_DS_Code <>'8' 
and h.dpo_isactive = 'y'
and g.hpo_po_number = f.dpot_po_number and g.HPO_Last_Amendment_Number = f.dpot_amendment_number



and not exists ( select 'x' from  #link , eip.sqlscm.SCM_H_Purchase_Orders,eip.sqlscm.SCM_d_Purchase_Orders h
where hmrn_po_number =hpo_po_number and hpo_po_number=h.dpo_Po_number )




select  a.* from #link a,   eip.sqlscm.SCM_H_Purchase_Orders g  , eip.sqlscm.SCM_d_Purchase_Orders h


where g.hpo_po_number = h.dpo_po_number 

and not exists ( select 'x' from  #link , eip.sqlscm.SCM_H_Purchase_Orders,eip.sqlscm.SCM_d_Purchase_Orders h
where hmrn_po_number =hpo_po_number and hpo_po_number=h.dpo_Po_number )








