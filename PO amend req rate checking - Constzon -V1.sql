drop table #link
select DPOAR_Material_Code,DPOAR_Net_Rate,DPOar_Basic_Rate,mmatc_description,MMGRP_Description,MMAT_UOM_Code,UUOM_Description,job_code,DPOAR_Qty,DPOAR_Request_Number, HPOAR_Request_Date, DPOAR_Value,MMAT_Material_Description, location, a.HPO_Currency_Code,HPOAR_Amendment_Number,hpo_last_amendment_number,
a.HPO_BA_Code, vendor_description, p.sector_code, p.bu_code , p.SBG_Code, a.HPO_Warehouse_Code,HPOAR_DS_Code, HPOAR_IsAuthorised, HPOAR_Request_Status
 into #link
 from eip.sqlscm.SCM_H_Purchase_Orders a, SQLSCM.SCM_H_PO_Amend_Request, SQLSCM.SCM_D_PO_Amend_Request, lnt.dbo.job_master p,
  eip.sqlmas.GEN_M_Material_Groups c, eip.sqlmas.GEN_M_Materials , eip.sqlmas.GEN_M_Material_Classes ,eip.sqlmas.GEN_U_Unit_Of_Measurement , lnt.dbo.vendor_master j
where HPO_PO_Number = HPOAR_PO_Number AND HPOAR_Request_Number = DPOAR_Request_Number 
--and MMAT_Material_Description like'%station%'
--and MMGRP_Description like '%station%'
--and left (dpo_material_code,1) in ('9')
and mmat_material_code = DPOAR_Material_Code and mmat_mg_Code = c.MMGRP_MG_Code 
and MMGRP_Company_Code= mmat_company_code 
and MMATC_Class_Code = c.MMGRP_Class_Code 
and MMGRP_Company_Code=MMATC_Company_Code
and MMAT_Company_Code =1
and HPO_BA_CODE= j.vendor_code

and HPOAR_Company_Code=1 
and HPOar_Job_Code= p.job_code 
and j.company_code = 'LE'
and p.company_code='LE'
--and HPO_JOB_CODE in ('LE130413')
and MMAT_UOM_Code = UUOM_UOM_Code
and HPOAR_Request_Date between '01-Apr-2018' and '04-May-2018'
and MMAT_Company_Code= MMATC_Company_Code 
and HPOAR_DS_Code <> 8
--and hpo_po_number in ('EG557PO7000017','EG557PO7000018','EG558PO7000017','EG558PO7000018','EG558PO7000038','EG559PO7000039','EG559PO7000040','EG558PO7000011','EG558PO7000013','EG559PO7000035','EG559PO7000036','EG557PO7000011','EG557PO7000013','EG558PO7000011','EG558PO7000013','EG559PO7000036','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG557PO7000009','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG558PO7000009','EG558PO7000010','EG558PO7000016','EG558PO7000033','EG559PO7000033','EG559PO7000034','EG559PO7000038','EG559PO7000056','EG557PO7000010','EG557PO7000016','EG557PO7000035','EG559PO7000033','EG559PO7000038','EG559PO7000056','EF861PO7000102','EF861PO7000109','EF860PO7000105','EF860PO7000102','EF864PO7000100','EF864PO7000096','EF862PO7000089','EF862PO7000098','EF859PO7000082','EF859PO7000082','EF859PO7000079','EF859PO7000095','EG450PO7000015','EG450PO7000016','EG450PO7000018','EG450PO7000115','EG450PO7000179','EG450PO7000086','EG450PO7000036','EG450PO7000126','EG450PO7000156','EG450PO7000157','EG450PO7000158','EG450PO7000157','EG450PO7000158','EG450PO7000009','EG450PO7000101','JJ001PO7000003','JJ001PO7000005','JJ001PO7000006','EF201PO7000140','EF201PO7000139','EE646PO7000044','EE646PO7000045','EE646PO7000040','EE646PO7000041','EF201PO7000085','EF201PO7000082','EC030PO7000637','EC030PO7000638','EC999PO7000174','EC999PO7000175','EC999PO7000178','EC999PO7000179','EC030PO7000636','EC999PO7000173','EC999PO7000177','EC999PO7000151','EC999PO7000153','EC999PO7000154','EC030PO7000474','EC030PO7000391','EC030PO7000514','EC030PO7000509','EC030PO7000338','EC030PO7000339','EG569PO7000010','ED145PO7000305','EF618PO7001608','EF618PO7001615','EG162PO7001432','EG795PO7000004','EG745PO7000027','EG377PO7000011','EG745PO7000018','EG034PO7000053','EF715PO7000101','EG034PO7000070','EF715PO7000128','EG034PO7000064','EG520PO7000043','EG381PO7000037','EG466PO7000032','EF889PO7000219','EF889PO7000220','EF889PO7000221','EF890PO7000226','EF890PO7000228','EF890PO7000227','EF890PO7000229','EF890PO7000230','EG034PO7000093','EF305PO7000154','EF305PO7000155','EG379PO7000020','EG336PO7000067','EG448PO7000094','EG381PO7000034','EG520PO7000041','EG466PO7000030','EG034PO7000080','EC402PO7000235','EG035PO7000001','EF698PO7000128','ED323PO7000344','EG745PO7000093','EF715PO7000146','EF893PO7000290','EF037PO7000141','EF037PO7000146','E9231PO8000001','EF674PO7000200','EF674PO7000199','EG132PO7000146','EE970PO8000011','EG413PO7000035','EE970PO8000010')

---and job_operating_group <>'I' 
--and left (dpo_material_code,1) in ('9')
---and DPO_Material_Code in ('313050000','3O41M0001000000','3O41M0001000001')

--and job_code in ('QOCSD019','CTTRA015','LE150574','LE160072','LE120318','LE120451','LE080156','LE140913','LE16D080','LE16D109','LE131284','LE131077','LE17D088','LE160914','LE140002','LE170554','LE160491','QGMAP013','LCBAF013','LE100260','LE090062','DGMAP014','CGMAP014','LE090397','LE170524','LE130465','LE120422','LE080192','YGFAA018','LE16D103','LE090333','LE160732','LE140586','LE160361','LE17D097','QGISD015')

--Group by dpo_material_code, location,mmatc_description,MMGRP_Description, MMAT_UOM_Code,UUOM_Description,job_code,DPO_Qty,DPO_PO_Number
Update #link set MMATC_Description= replace(MMATC_Description,char(9),'-'),mmgrp_description=replace(mmgrp_description,char(9),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(9),'-')


Update #link set MMATC_Description= replace(MMATC_Description,char(10),'-'),mmgrp_description=replace(mmgrp_description,char(10),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(10),'-')

						
Update #link set MMATC_Description= replace(MMATC_Description,char(11),'-'),mmgrp_description=replace(mmgrp_description,char(11),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(11),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(12),'-'),mmgrp_description=replace(mmgrp_description,char(12),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(12),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(13),'-'),mmgrp_description=replace(mmgrp_description,char(13),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(13),'-')
						
Update #link set MMATC_Description= replace(MMATC_Description,char(14),'-'),mmgrp_description=replace(mmgrp_description,char(14),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(14),'-')

Update #link set MMATC_Description= replace(MMATC_Description,char(15),'-'),mmgrp_description=replace(mmgrp_description,char(15),'-'),MMAT_Material_Description=replace(MMAT_Material_Description,char(15),'-')

Update #link set MMATC_Description= replace(MMATC_Description,'"','-'),mmgrp_description=replace(mmgrp_description,'"','-'),MMAT_Material_Description=replace(MMAT_Material_Description,'"','-')
--select * from #link

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
WHERE a.job_code = b.job_code 
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
 and job_code =mjob_job_code

UPDATE a SET sbgdesc = b.SBG_Description
from #link a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 

alter table #LINK add NEWOLDCODE varchar(100)

uPDATE A SET NEWOLDCODE ='NEW'
FROM #LINK A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DPOar_MATERIAL_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='MATR'
--AND MSR_Attribute_Combination_Value IS NOT NULL

select *from #link

alter table #link add materialcategory VARCHAR (500)
alter table #link add PlanningCategory VARCHAR (500)


 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpoar_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #link a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where Dpoar_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #link a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 


alter table #link add Constzon_Applicable VARCHAR (200)

UPDATE A SET a.Constzon_Applicable  = b.DPOAC_Rate_Applicable
from #LINK a
left join SQLSCM.SCM_D_POA_ConstZon_Details b  on 
DPOAC_POA_Request_Number = DPOAR_Request_Number AND DPOAC_Amendment_Number = HPO_Last_Amendment_Number+1
					AND DPOAC_Material_Code = DPOAR_Material_Code


select * from #Link 