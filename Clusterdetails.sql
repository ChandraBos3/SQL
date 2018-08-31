

select *from eip.sqlbss.bss_t_rate_analysis 

select *from eip.SQLSCM.SCM_D_PO_ConstZon_Details where dpocd_po_number = 'EC829PO8000817'

select *from eip.SQLSCM.SCM_D_Purchase_Orders where dpo_po_number = 'E9294PO8000803'


select *from eip.SQLSCM.SCM_D_PO_ConstZon_Details where dpocd_po_number = 'ED323PO8000231'

select *from eip.SQLSCM.SCM_D_Purchase_Orders where dpo_po_number = 'ED323PO8000231'
EA419PO8000470
select *from eip.SQLSCM.SCM_h_Purchase_Orders where hpo_po_number = 'EA419PO8000470'and hpo_mr_number 

select *from eip.sqlscm.SCM_d_Material_Request where dMR_MR_Number = 'EA419EMR8000564'

select *from LNT.DBO.SECTOR_MASTER 

6C24S003C


select *from eip.SQLWOM.WOM_D_WO_Request_ConstZon_Details where DWORC_Request_Number ='EB121WOR8000083'  6C24S003C

select *from eip.sqlbss.BSS_T_Rate_Analysis where BTRA_EIP_ITEM_CODE = '6C24S003C'
in ('6C12S02JB','6C12S02J9','6C12S008I','6C12S004C','6C12S001V')

select *from EB121WOR8000083

select *From eip.sqlscm.SCM_d_GIN

use lnt
go

select *from sys.tables where name like '%nature%'

select *from lnt.dbo.job_nature_Master

select *from lnt.dbo.contract_Type_Master


select *from lnt.dbo.job_master


select *from eip.sqlbss.BSS_M_RA_Location

select *from EPM.sqlepm.EPM_M_Control_Master 


drop table #billlist
select c.job_code ,job_description,c.sector_code,d.Sector_Description, c.sbg_code,location,original_contract_value, f.Cluster_Description
into #billlist
from EPM.sqlepm.EPM_M_Control_Master,lnt.dbo.job_master C,lnt.dbo.sector_master d, lnt.dbo.job_overview e, lnt.dbo.cluster_master f

where TCM_Job_Code= c.job_code and tcm_pmp_tag ='y'and job_active ='y' and c.job_code=e.job_code

and c.Sector_Code = d.Sector_Code and c.company_code='LE' and c.company_code = d.Company_Code
 and c.job_status in ('C','R')
 AND c.COMPANY_CODE ='LE'
 AND c. main_sub_dept ='M'
 and c.Cluster_Code=f.Cluster_Code
 and c.job_operating_group <>'I'


alter table #billlist add BUdesc varchar(100)
alter table #billlist add sbgdesc varchar (200)

alter table #billlist add Locdesc varchar(100)
alter table #billlist add city varchar (200)
alter table #billlist add state1 varchar (200)
alter table #billlist add jobnature varchar (100)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE a.Job_Code= c.job_code
AND c.BU_CODE = d.bu_code



UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 




UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='LE'

update a set city =UCITY_Name, state1=USTAT_Name
 from #billlist a, eip.SQLMAS.GEN_M_Address_Book, Eip.Sqlmas.Gen_M_Jobs,eip.sqlmas.GEN_U_States, Eip.Sqlmas.GEN_U_Cities
 where Mjob_AB_Code=MAB_AB_Code 
 and MAB_City_Code=UCITY_City_Code
 and UCITY_State_Code =USTAT_State_Code
 and a.job_code =mjob_job_code

 

 select *from  #billlist

 select *from lnt.dbo.cluster_master



