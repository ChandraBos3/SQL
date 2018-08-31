select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_PO_Number in ('EF750PO7000049','EG657PO7000038','EA317PO7000152','E7445PO7000003')

select *from eip.sqlscm.SCM_H_Material_Request where HMR_MR_Number in ('EA317EMR7000268','EF750EMR7000087','EG657EMR7000128','E7445EMR7000003')

select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_MR_Number in ('EA317EMR7000268','EF750EMR7000087','EG657EMR7000128')

select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_PO_Number in ('EG795PO7000004')

select *from eip.sqlscm.SCM_D_Purchase_Orders where DPO_PO_Number in ('EG795PO7000004')

select*from eip.sqlscm.scm_d_purchase_orders where dpo_po_number in ('EG622PO7000006','E9682PO7000126','E9682PO7000277','EE977PO7000073','EF803PO7000715','EG622PO7000002',
'EG622PO7000001',
'EG622PO7000010',
'E9431PO7000044',
'E9851PO7000080',
'EF803PO7000714',
'EF698PO7000040',
'EC883PO7000293',
'EC725PO7000027',
'EC725PO7000149',
'EC725PO7000200',
'EF516PO7000066',
'EF516PO7000064'
)

select *from eip.sqlscm.SCM_H_Material_Request where HMR_COMPANY_CODE =1 AND hmr_mr_date between '01-Jul-2017' and '04-Sep-2017' and hmr_job_code in ('LE090333',
'LE090397',
'LE100260',
'QGISD015',
'QGMAP013',
'LE120422',
'LE120451',
'LE130465',
'LE150574',
'LE131077',
'LE160072',
'LE160361',
'LE16D103',
'LE160491',
'LE131284',
'LE160732',
'LE160914',
'LE170524',
'LE170554',
'LE140586')


select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_Company_Code =1 and HPO_Job_Code in  ('LE090333',
'LE090397',
'LE100260',
'QGISD015',
'QGMAP013',
'LE120422',
'LE120451',
'LE130465',
'LE150574',
'LE131077',
'LE160072',
'LE160361',
'LE16D103',
'LE160491',
'LE131284',
'LE160732',
'LE160914',
'LE170524',
'LE170554',
'LE140586')


use eip
go

select *from eip.sqlscm.SCM_H_Purchase_Orders where HPO_Company_Code =1 and HPO_Job_Code in ('QGMAP013')
select *from  eip.sqlwom.wom_H_work_order_request where hworq_job_code in ('LE170213')

select *from eip.sqlwom.WOM_D_Work_Orders where DWO_WO_Number IN ('E3582WOD6000004')



select * from eip.sqlwom.WOM_M_Job_Item_Codes where MJITC_Item_Description like '%water%proofing%under%ground%Chemi%water%proof%'

select *from epm.sqlepm.EPM_M_Control_Master


use EPM
GO

drop table #joblist

select TCM_Job_Code Job_code, 'PMP' module , maxdate jcrdate , b.bpcode
into #joblist 
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 3000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 



select TCM_Job_Code Job_code, 'ACE' module , maxdate jcrdate , b.bpcode
into #acejobs
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 2000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003','BPDS0002')  AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 




select a.*, b.job_description, b.Sector_Code from #joblist a, lnt.dbo.job_master b where a.job_code = b.job_code

select a.*, b.job_description, b.Sector_Code from #acejobs a, lnt.dbo.job_master b
where a.job_code= b.job_code

select a.Sector_Code, a.job_code, job_description,a.bu_code, bu_description, c.original_contract_value, c.revised_contract_value, a.main_sub_dept,
a.parent_job_code, a.job_type, a.job_status
from lnt.dbo.job_master a, lnt.dbo.business_unit_master b, lnt.dbo.job_overview c
where a.bu_code in ('DFCC','DDW') ---Specific BU as required alone considered
and a.job_Code = c.job_code
and a.company_code='LE'
and a.bu_code = b.bu_code
and a.main_sub_dept in ( 'M')--,'D') ---Only Jobs considered Department Excluded
and a.job_active='Y'
and a.job_status not in ('P','B')-----


eip.sqlwom.WOM_H_Work_Orders a, eip.sqlwom.wom_d_work_orders eip.sqlwom.WOM_H_Work_Order_Request a, eip.sqlwom.WOM_D_Work_Order_Request

select DPODS_PO_NUMBER, DPODS_mATERIAL_cODE, DPODS_FROM_DATe Startdate, dpods_to_date enddate from eip.sqlscm.SCM_D_PO_Delivery_Schedules where DPODS_PO_Number in ('E5099PO7000228')
Group by DPODS_PO_Number, DPODS_Material_Code
USE eip
go
select *from eip.sqlwom.WOM_d_Work_Orders where dwo_item_
select *from eip.sqlwom.WOM_h_Work_Orders

select *from eip.sqlfas.FAS_D_Ledger_Register_Vendor

select *from eip.sqlfas.fas_t_ledger_register

SELECT *FROM eip.sqlwom.WOM_H_Work_Order_Request where HWORQ_REQUEST_nUMBER IN ('E5099PO7000228')
select *from eip.sqlscm.SCM_D_PO_Delivery_Schedules

use lnt
go
select *from lnt.dbo.Warehouse_Master
select *from 

use epm
go


select *from eip.sqlmas.GEN_M_warehouses

use eip
go
select *from eip.sqlmas.GEN_M_Warehouses where MWH_Company_Code =1
select *from eip.sqlmas.GEN_M_Address_Book
select *from eip.sqlmas.GEN_U_STATES
select *from eip.sqlmas.GEN_L_Warehouse_Locations
select *from sys.tables where name like '%STATE%'

select * from lnt.dbo.warehouses_master

select *from lnt.dbo.job_master
select *from lnt.dbo.region_master

use lnt
go
select *from sys.tables where name like '%region%'
select *from 


select mwh_wAREHOUSE_CODE,MAB_AB_CODE,MAB_nAME, MWH_Description, USTAT_Name ,MAB_ZIP_CODE FROM eip.sqlmas.GEN_M_Address_Book, eip.sqlmas.GEN_U_STATES, eip.sqlmas.GEN_M_Warehouses
Where MWH_AB_Code=MAB_AB_Code and MAB_State_CODE=USTAT_State_Code
AND mwh_cOMPANY_cODE=1
AND mwh_warehouse_code='2742'

MAB_AB_Code
USTAT_State_Code