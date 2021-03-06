---Tracker Reports
/* PRR to EMR */

use EPM
---DROP TABLE #PRREMr

select Job_code,job_description,c.Sector_Description,a.TEPR_Material_Code,a.TEPR_Required_Quantity, a.TEPR_Rate, a.TEPR_isApproved, a.TEPR_Is_Bundled,
case when job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end PILOtJobs,
TEPR_MR_Reference_Code MRreference, cast(null as varchar(30)) MRNUmber, cast(null as varchar(15)) plancategory, cast(null as varchar(300)) matgroup,
CAST(NULL AS DATE) MRDATE
into #PRREMR
 from epm.sqlpmp.PMP_T_ExecPlan_Purchase_Register a, lnt.dbo.job_master b , lnt.dbo.sector_master c
where TEPR_Inserted_On>='22-Feb-2017'
and a.TEPR_Job_Code= b.job_code and b.Sector_Code=c.Sector_Code and c.Company_Code= b.company_code
and b.company_code='LE'
and a.TEPR_ISActive='Y' and a.TEPR_Amount<>0
and a.TEPR_Is_Bundled='Y'
and TEPR_MR_Reference_Code is not null


Update a set MRNUmber = HEPRMR_MR_Number,plancategory=DEPRMR_Plan_Category,matgroup=mmc_description,MRDATE=HEPRMR_MR_Date
from #PRREMR a ,epm.sqlpmp.PMP_H_ExecPlan_Purchase_Register_MR_Request b, epm.sqlpmp.pmp_d_execplan_purchase_register_mr_request ,epm.sqlpmp.gen_m_material_category
 where heprmr_reference_code =MRreference
 and heprmr_reference_code = deprmr_reference_code
 and MMC_Company_Code=1 and DEPRMR_Plan_Category= MMC_Material_Category_Code

 select * from #PRREMR order by mrnumber





/* SLA / KPI */

select * from lnt.dbo.staff_master where Date_of_Birth like '%1983%'

use EIP
GO

drop table #SLAKPI

select * from lnt.dbo.security_user_master, lnt.dbo.staff_master 
where user_class_code = Psno and psno=11409 and Company_Code='LE'

select TDF_Document_code docnumber, tdf_dt_code doctype,MDOCT_Name docdesc,tdf_job_Code jobcode, TDF_Sender_UID sender, muser_reference_id as PSNO, 
MUSER_Login_Name as Login,TDF_Receiver_UID receiver, 
TDF_Send_Date_Time ActionStartTime, dateadd(HOUR,TDF_KPI,TDF_Send_Date_Time) MaxExpTime,
TDF_Received_Status_Date_Time ActionEndTime, b.Sector_Code IC, b.bu_code BU, b.job_description JObDesc, cast(0 as money) po_wo_value,TDF_Action_Status,
'Approver'  UserPosition, CAST( 0 AS INTEGER) CURRENCYCODE, cast(0 as money) TaxAmount
--Into #SLAKPI
 from eip.sqlacs.ACS_T_Document_Flow , lnt.dbo.job_master b, eip.sqlmas.GEN_M_Document_Transaction, eip.sqlmas.gen_m_users
 where tdf_dt_code in(204,224,301,304,10036) --and tdf_kpi is not NULL
and TDF_Send_DOPT_Code iN ('A')
and TDF_Job_Code= b.job_code
and b.company_code='LE'and TDF_Action_Status='Y'
and TDF_Receiver_UID ='241'
and TDF_dt_code= MDOCT_DT_Code 
and TDF_Send_Date_Time between '04-Apr-2017' and '19-Dec-2017'
and muser_user_id=TDF_Receiver_UId 
ORDER BY 1

select * from eip.sqlacs.ACS_T_Document_Flow where TDF_Document_Code like 'EA427PO7000311'
--select * from eip.sqlwom.wom_t_document_approvals where twoda_document_reference_number='EF890PO7000046'
select * from eip.sqlscm.scm_t_document_approvals where tscda_document_reference_number='EA427PO7000311' and TSCDA_Amendment_Number=1

insert into #SLAKPI
select TDF_Document_code docnumber, tdf_dt_code doctype,MDOCT_Name docdesc,tdf_job_Code jobcode, TDF_Sender_UID sender, TDF_Receiver_UID receiver, 
TDF_Send_Date_Time ActionStartTime, dateadd(HOUR,TDF_KPI,TDF_Send_Date_Time) MaxExpTime,
TDF_Received_Status_Date_Time ActionEndTime, b.Sector_Code IC, b.bu_code BU, b.job_description JObDesc, cast(0 as money) po_wo_value,TDF_Action_Status,
'Verifier'  UserPosition,CAST (0 AS INTEGER) CURRENCYCODE
 from eip.sqlacs.ACS_T_Document_Flow , lnt.dbo.job_master b, eip.sqlmas.GEN_M_Document_Transaction
 where tdf_dt_code in (204,224,301,304,10036) --and tdf_kpi is not NULL
and TDF_Send_DOPT_Code in ( 'S')
and TDF_Job_Code= b.job_code
and b.company_code='LE'
--and TDF_Action_Status='Y'
and TDF_dt_code= MDOCT_DT_Code 
and TDF_Send_Date_Time between '04-Apr-2017' and '19-Dec-2017'
ORDER BY 1



select * from eip.sqlwom.wom_d_work_orders 

alter table #SLAKPI add POStatus varchar(15)

update a set po_wo_value= hpo_po_net_value, postatus =  b.HPO_DS_Code, CURRENCYCODE=HPO_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_Purchase_Orders b
where docnumber= hpo_po_number
 
 
update a set po_wo_value= hwo_wo_amount,postatus =  b.HWO_DS_Code,CURRENCYCODE=HWO_Currency_Code
from #slakpi a, eip.sqlwom.WOM_H_Work_Orders b
where docnumber= hwo_wo_number


update a set po_wo_value= HWORQ_Amount, postatus= b.HWORQ_DS_Code, CURRENCYCODE= HWORQ_CURRENCY_CODE
from #slakpi a, eip.sqlwom.WOM_H_Work_Order_Request b
where docnumber= HWORQ_Request_Number


update a set po_wo_value= HPOAR_PO_Net_Value,postatus= b.HPOAR_DS_Code, CURRENCYCODE=HPOAR_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_PO_Amend_Request b
where docnumber= HPOAR_Request_Number


alter table #slakpi add BUdesc varchar(100)
alter table #slakpi add ICdesc varchar(100)
alter table #slakpi add taxbilled money, taxbalance money, wotaxamount money


uPDATE a SET  BUDESC= B.bu_description
FROM #SLAKPI A, lnt.dbo.business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE a SET  ICDESC= B.Sector_Description
FROM #slakpi A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code


update #slakpi set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')

Update c set wotaxamount=taxamt,taxbilled=taxbill, taxbalance=taxbal
from #slakpi c, (
select dwo_wo_number, sum(dwo_item_tax_amount) taxamt, sum(dwo_item_taxamount_billed) taxbill,sum(dwo_item_taxAmount_balance) taxbal
 from eip.sqlwom.wom_d_work_orders a, #slakpi b
where dwo_wo_number = b.docnumber 
group by dwo_wo_number) b
where b.dwo_wo_number = c.docnumber 

select * from #SLAKPI
select * from #slakpi where postatus =3 and  ((tdf_action_status ='Y' and userposition='Approver') or (userposition='Verifier'))
order by 1,2,3,7
select * from #slakpi where postatus is null



select * from eip.sqlwom.wom_t_document_approvals

select identity (int) slno, *into #temp from #SLAKPI

select * from #temp where Slno >=800000




/*  --- */
--EBID REquest Generated in system

select a.HBRQ_BR_Number bidnumber,a.HBRQ_BR_Date biddate, a.HBRQ_Job_Code jobcode,c.Sector_Description ic,hbrq_value value,a.HBRQ_DS_Code status,
 
case when b.job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end pilotjob

 from eip.SQLBID.BID_H_Bid_Request a, lnt.dbo.job_master b , lnt.dbo.sector_master c
where b.job_code=a.HBRQ_Job_Code
and b.Sector_Code=c.Sector_Code and b.company_code=c.Company_Code
and b.company_code='LE'
and a.HBRQ_DS_Code<>8

----LOI


select HLOI_LOI_Number LOINumber, hloi_date loidate, HLOI_Job_Code jobcode,c.Sector_Description IC,a.HLOI_Value value,a.HLOI_DS_Code status,

case when b.job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end pilotjob
 from eip.sqlBID.BID_H_Letter_of_Intent a, lnt.dbo.job_master b , lnt.dbo.sector_master c
where b.job_code=a.HLOI_Job_Code
and b.Sector_Code=c.Sector_Code and b.company_code=c.Company_Code
and b.company_code='LE'
and a.HLOI_DS_Code<>8

---Allocation of Work

select * from eip.sqlfas.FAS_T_Allocation_Parameter where TAP_Allocation_Code=5892

select TDA_Document_Code docnumber, job_code jobcode,c.Sector_Description ic,TDA_Allocation_Code allcode, TDA_Allocated_Date Allocatedon,TDA_Completed_On completedon,MDOCT_Name docname,
case when job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end pilotjob
 from eip.sqlfas.FAS_T_Document_Allocation , lnt.dbo.job_master a, lnt.dbo.sector_master c,eip.sqlfas.FAS_T_Allocation_Parameter d,
 eip.sqlmas.GEN_M_Document_Transaction
where TDA_Job_Code= a.job_code and a.Sector_Code=c.Sector_Code and a.company_code= c.Company_Code
and a.company_code='LE' and d.TAP_Allocation_DT_Code= MDOCT_DT_Code
and TDA_Allocation_Code= d.TAP_Allocation_Code
and TDA_Completed_On is not NULL

---Multiple Logins

select * from eip.sqlmas.GEN_M_Functional_Roles where MFR_Description like '%Site%Engineer%'
and MFR_Company_Code=1

select c.job_Code jobcode, c.job_description jobdesc, d.Sector_Description IC, mfr_description roleofuser,a.LUJFR_User_ID uid,
case when c.job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end pilotjob
from eip.sqlacs.ACS_L_User_Job_Functional_Roles a, eip.sqlmas.GEN_M_Functional_Roles b, lnt.dbo.job_master c, lnt.dbo.Sector_Master d
where a.LUJFR_FR_Code= b.MFR_FR_Code and b.MFR_Company_Code=1
and c.Sector_Code= d.Sector_Code and c.company_code=d.Company_Code
and MFR_Description like '%Site%Engineer%'
and MFR_Company_Code=1 and a.LUJFR_Job_Code= c.job_code

---PO / WO approvals

select TDF_Document_code doccode,TDF_DT_Code dt,b.MDOCT_Name docdesc,a.TDF_Sender_UID sender,a.TDF_Receiver_UID receiver,
a.TDF_Send_Date_Time, case when tdf_send_dopt_code = 'A' then 'Authorizer' else 'Verifier' end,
a.TDF_Action_Status,isnull(tdf_kpi,0)/24 kpidays,a.TDF_Job_Code jobcode, d.Sector_Description ic, 
case when job_Code in ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') then 'Pilot' else 'No' end pilotjob

 from eip.sqlacs.ACS_T_Document_Flow a, eip.sqlmas.GEN_M_Document_Transaction b, lnt.dbo.job_master c, lnt.dbo.sector_master d
 where TDF_DT_Code in ( 204,301,304,224) and TDF_Send_Date_Time>='01-Feb-2017'
 and a.TDF_DT_Code= b.MDOCT_DT_Code 
 and c.Sector_Code = d.Sector_Code
 and d.Company_Code=c.company_code
 and a.TDF_Job_Code= c.job_code

 -- Bid Request - DT Code - 775
SELECT HBRQ_Job_Code Job, MCLED_Description IC, 
		Case When HBRQ_JOB_CODE IN ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') Then 'Yes' Else
					'No' End Pilot_Job, convert(date, HBRQ_Inserted_On, 102) Created_On, MUSGD_FULL_NAME Bid_Request_Created_By, 
					HBRQ_BR_Number BR_Number, MDOCS_Description Document_Status, d.*
FROM FromLive.EIP.SqlBid.Bid_H_Bid_Request d
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USERS  ON HBRQ_INSERTED_BY=MUSER_USER_ID
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USER_GENERAL_DETAILS  ON MUSER_USER_ID=MUSGD_USER_ID,
		fromlive.eip.SQLMAS.GEN_L_Job_Cluster_Elements,
		fromlive.eip.SQLMAS.GEN_M_Cluster_Element_Details,
		fromlive.eip.sqlmas.gen_m_document_Status 
WHERE HBRQ_Inserted_On >= '04-Jan-2017' 
		And HBRQ_Job_Code=LJCE_Job_Code 
		and LJCE_IC_Code=MCLED_CED_Code
		and LJCE_company_code= HBRQ_company_code
		And HBRQ_Company_Code = 1
		And MCLED_CE_Code = 2
		And MDOCS_DT_Code = 775
		And HBRQ_DS_Code = MDOCS_DS_Code

-- Request For Quote - DT - 781
SELECT HRQ_Job_Code Job, MCLED_Description IC, 
		Case When HRQ_JOB_CODE IN ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') Then 'Yes' Else
					'No' End Pilot_Job, convert(date, HRQ_Inserted_On, 102) Created_On, MUSGD_FULL_NAME Bid_Request_Created_By, d.*
FROM FromLive.EIP.SqlBid.Bid_H_Request_For_Quote d
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USERS  ON HRQ_INSERTED_BY=MUSER_USER_ID
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USER_GENERAL_DETAILS  ON MUSER_USER_ID=MUSGD_USER_ID,
		fromlive.eip.SQLMAS.GEN_L_Job_Cluster_Elements,
		fromlive.eip.SQLMAS.GEN_M_Cluster_Element_Details
WHERE HRQ_Inserted_On >= '04-Jan-2017' 
		And HRQ_Job_Code=LJCE_Job_Code 
		and LJCE_IC_Code=MCLED_CED_Code
		and LJCE_company_code= HRQ_company_code
		And HRQ_Company_Code = 1
		And MCLED_CE_Code = 2

-- LOI - DT Code - 777
SELECT HLOI_Job_Code Job, MCLED_Description IC, 
		Case When HLOI_JOB_CODE IN ('LE150403','LE151046','LE160010','LE160037','LE160189','LE160273','LE160433','LE160643','LE160659','LE160805','LE160360') Then 'Yes' Else
					'No' End Pilot_Job, convert(date, HLOI_Inserted_On, 102) Created_On, MUSGD_FULL_NAME LOI_Created_By, 
					HLOI_LOI_Number LOI_Number, MDOCS_Description Document_Status--, d.*
FROM FromLive.EIP.SqlBid.BID_H_Letter_of_Intent d
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USERS  ON HLOI_INSERTED_BY=MUSER_USER_ID
	INNER JOIN FROMLIVE.EIP.SQLMAS.GEN_M_USER_GENERAL_DETAILS  ON MUSER_USER_ID=MUSGD_USER_ID,
		fromlive.eip.SQLMAS.GEN_L_Job_Cluster_Elements,
		fromlive.eip.SQLMAS.GEN_M_Cluster_Element_Details,
		fromlive.eip.sqlmas.gen_m_document_Status 
WHERE HLOI_Inserted_On >= '04-Jan-2017' 
		And HLOI_Job_Code=LJCE_Job_Code 
		and LJCE_IC_Code=MCLED_CED_Code
		and LJCE_company_code= HLOI_company_code
		And HLOI_Company_Code = 1
		And MCLED_CE_Code = 2
		And MDOCS_DT_Code = 777
		And HLOI_DS_Code = MDOCS_DS_Code

		---MEASUREMENTS THROUGHH MOBILE

select hms_wo_number,hms_ms_number, hms_date, cast(hms_inserted_on as date) createdon,hms_ds_code, hms_job_code,sector_description,
case when hms_ismobile='Y' then 'Mobile' else '' end Mobile,case when hms_ismobile='N' then 'Desktop' else '' end Desktop ,
cast ( 0 as int)  noofmeasurements
into #meas
from eip.sqlwom.wom_h_measurements a, eip.sqlwom.wom_d_measurements b, lnt.dbo.job_master c, lnt.dbo.sector_master d
where hms_ms_number = dwoms_ms_number and hms_Company_Code=1
and hms_job_Code = c.job_code and c.company_code = 'LE'
and c.sector_code = d.sector_code
and hms_date >='01-Jan-2017' and hms_date <='31-Mar-2017'

select hms_wo_number,hms_ms_number, hms_date,createdon,hms_ds_code,hms_job_code,sector_description,mobile,desktop,count(hms_ms_number)
from #meas
where hms_ds_code =3
group by  hms_wo_number,hms_ms_number, hms_date,createdon,hms_ds_code,hms_job_code,sector_description,mobile,desktop

select * from eip.sqlacs.ACS_T_Document_Flow

select *from lnt.dbo.job_master where company_code ='LE'

SELECT *from  LNT.DBO.job_Circular
