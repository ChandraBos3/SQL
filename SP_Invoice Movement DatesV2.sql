use finance
GO

---Exec #Lntsp_Invoice_PO_WO_TAT @fromdate = '01-Jan-2018',@Todate = '02-Jan-2018'
--alter Procedure #Lntsp_Invoice_PO_WO_TAT
create Procedure #Lntsp_Invoice_PO_WO_TAT
(
@fromdate		Date,
@Todate			Date,
@Company_code varchar(15) = 'LE',
@Jobcode		varchar(15)= Null
)
as

select  job_Code into #jobs 
from lnt.dbo.job_master where Company_code=@Company_code and job_operating_group <>'I'

---For payment based Invoices

select distinct TLREG_LR_Number ebrnumber into #tlreg from eip.sqlfas.FAS_T_Ledger_Register_Breakup a, eip.sqlfas.fas_t_ledger_register 
where TLRBR_Cheque_Date between @fromdate and @Todate
	and a.TLRBR_LR_Number= TLREG_LR_Number
	and TLREG_DS_Code<>8
	and TLREG_Currency_Code=72 and TLREG_DT_Code in ( 403,404)
	and TLREG_Company_Code=1 

select TLREG_LR_Number, TLREG_LR_Date Invregisterdate, TLREG_DT_Code, TLREG_Bill_Number InvoiceNo, TLREG_Bill_Date invoicedate,tlreg_job_code JObcode, 
tlreg_vendor_code vendorcode,cast(null as varchar(3000)) VendName,TLREG_Gross_Amount invvalue, cast ( null as varchar(30)) ordernumber,
cast(null as varchar(15)) PVTag,cast(null as varchar(15)) LDTag, 
cast(null as varchar(15)) ContrBG,cast(null as varchar(15)) advbg,cast(null as varchar(15)) perfbg,cast ( null as date) AcknowDate, 
 cast ( null as date) InvPhyDate, cast ( null as date) MinScrutinyDate, cast ( null as date) MaxScrutinyDate, cast ( null as date) Canceldate,
 cast ( null as date) JVDate, cast ( null as date) MinDisbdate, cast ( null as date) Maxdisbdate,
  cast ( null as date) rejectdate,    cast ( 0 as int) ptevent,cast ( 0 as int) ptcategory,
  cast ( null as date) duedate,cast ( null as varchar(500)) paymentterm , cast(null as varchar(3000)) MRnNumbers, cast(0 as int) scrutinyid,cast(0 as int) SJVuid,
  cast(null as varchar(30)) materialcode,cast(null as varchar(30)) materialgroup, cast(null as varchar(300)) cancelremarks,cast(null as varchar(300)) Rejectremarks,
  cast(null as varchar(3000)) Rejreasons,cast(0 as money) ptquantum
into #invoices 
from eip.sqlfas.fas_t_ledger_register 
where exists ( select 'x' from #tlreg where TLREG_LR_Number= ebrnumber)

----MR based invoice list
/*
use finance
GO
drop table #invoices
select hmr_mr_Number, hmr_mr_date MrDate, HMR_Job_Code JObcode, cast(null as varchar(30) ) ponumber,cast(null as varchar(30) ) mrnnumber,
cast(null as varchar(30) ) LRnumber,
cast(null as varchar(15)) vendorcode,cast(null as varchar(3000)) VendName,cast( 0 as money) invvalue, cast ( null as varchar(30)) ordernumber,
cast(null as varchar(15)) PVTag,cast(null as varchar(15)) LDTag, 
cast(null as varchar(15)) ContrBG,cast(null as varchar(15)) advbg,cast(null as varchar(15)) perfbg,cast ( null as date) AcknowDate, 
 cast ( null as date) InvPhyDate, cast ( null as date) MinScrutinyDate, cast ( null as date) MaxScrutinyDate, cast ( null as date) Canceldate,
 cast ( null as date) JVDate, cast ( null as date) MinDisbdate, cast ( null as date) Maxdisbdate,
  cast ( null as date) rejectdate,    cast ( 0 as int) ptevent,cast ( 0 as int) ptcategory,
  cast ( null as date) duedate,cast ( null as varchar(500)) paymentterm , cast(null as varchar(3000)) MRnNumbers, cast(0 as int) scrutinyid,cast(0 as int) SJVuid,
  cast(null as varchar(30)) materialcode,cast(null as varchar(30)) materialgroup, cast(null as varchar(300)) cancelremarks,cast(null as varchar(300)) Rejectremarks,
  cast(null as varchar(3000)) Rejreasons,cast(0 as money) ptquantum
into #invoices 
from eip.sqlscm.scm_h_material_request 
where HMR_MR_Date between '01-Jan-2017' and '28-Feb-2017' and HMR_DS_Code=3
and hmr_company_code=1
*/
-----

Alter Table #invoices add amendno int, lastamdDate date,noofstages int

Alter Table #invoices add wornumber varchar(30)

alter table #invoices add retnbg char(1)

--select * from #invoices


Update a set duedate= hlrv_due_date, ptevent= hlrv_pt_event_code,  ptquantum= b.HLRV_PT_Quantum_Percentage,
			ordernumber= isnull(b.HLRV_PO_Number, 'NOPO')
from #invoices a, eip.sqlfas.FAS_H_Ledger_Register_Vendor b
where a.tlreg_lr_number= b.HLRV_LR_Number and TLREG_DT_Code=403


Update a set duedate= hlrv_due_date, ptevent= hlrv_pt_event_code,  ptquantum= b.HLRV_PT_Quantum_Percentage,
			ordernumber= isnull(b.HLRV_WO_Number,'NOWO')
from #invoices a, eip.sqlfas.FAS_H_Ledger_Register_Vendor b
where a.tlreg_lr_number= b.HLRV_LR_Number and TLREG_DT_Code=404

---select * from #invoices


Update a set  MinDisbdate  = mindate 
			from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  7)


Update a set   Maxdisbdate  = maxdate
from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  7)



Update a set  MinScrutinyDate  = mindate 
			from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  4)

Update a set   MaxScrutinyDate  = maxdate
from #invoices a, (select TDAPR_Document_Reference_Number, tdapr_ds_code, min(tdapr_action_on) mindate, 
			max(tdapr_action_on) maxdate from eip.sqlfas.fas_t_document_approvals b, #invoices c
			where b.TDAPR_Document_Reference_Number= c.tlreg_lr_number
			group by TDAPR_Document_Reference_Number, tdapr_ds_code ) g
where a.tlreg_lr_number= g.TDAPR_Document_Reference_Number
and g.TDAPR_DS_Code in (  4)


Update a set scrutinyid=b.TDAPR_Action_By
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =4



Update a set Canceldate=tdapr_action_on,cancelremarks=b.TDAPR_Remarks
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =8

Update a set JVdate  = tdapr_action_on
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =19

Update a set SJVuid=b.TDAPR_Action_By
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =19

			
Update a set AcknowDate  = tdapr_action_on
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =12

Update a set rejectdate  = tdapr_action_on,rejectremarks=b.TDAPR_Remarks
	from #invoices a, eip.sqlfas.fas_t_document_approvals b
			where b.TDAPR_Document_Reference_Number= a.tlreg_lr_number
			and tdapr_ds_code =13



Update a set ptcategory= mpte_event_category_code
from #invoices a, ---eip.sqlmas.GEN_M_PT_Event_Category b,
eip.sqlmas.GEN_M_PT_Events c
where a.ptevent= c.mpte_event_code 






Update a set paymentterm= mpte_description +'-'+ mptec_description + '-'+ case when mptec_is_advance_category ='Y' then 'Advance' 
														when mptec_is_advance_category = 'I' then 'Installation'
														when mptec_is_advance_category = 'E' then 'After Receipt' End 
															
from #invoices a, eip.sqlmas.GEN_M_PT_Event_Category b,eip.sqlmas.GEN_M_PT_Events c
where  a.ptevent = MPTE_Event_Code and tlreg_dt_Code=403
and a.ptcategory = MPTEC_Event_Category_Code

Update a set paymentterm= mpte_description +'-'+  case when mptec_is_advance_category ='Y' then 'Advance' 
														when mptec_is_advance_category = 'I' then 'Installation'
														when mptec_is_advance_category = 'E' then 'After Execution' End 
															
from #invoices a, eip.sqlmas.GEN_M_PT_Event_Category b,eip.sqlmas.GEN_M_PT_Events c
where  a.ptevent = MPTE_Event_Code and tlreg_dt_Code=404
and a.ptcategory = MPTEC_Event_Category_Code



Update a set  vendname = vendor_description
 from #invoices a, finance.dbo.IT_Vendor_View where Company_Code='LE'
 and vendor_Code= a.vendorcode

Update a set pvtag=dpot_isPrice_variation,ldtag=dpot_ld_clause
from eip.sqlscm.SCM_D_Purchase_Order_Terms b,#invoices a
where a.ordernumber=b.DPOT_PO_Number


Update a set ldtag=hwo_is_ld_applicable,amendno=hwo_last_amendment_number,lastamdDate=hwo_last_amendment_date,noofstages=hwo_number_of_stages,
			wornumber=b.HWO_WO_Request_Number
--select * 
from eip.sqlwom.WOM_H_Work_Orders b,#invoices a
where a.ordernumber=b.HWO_WO_Number

Update b set contrbg='Y'
from eip.sqlscm.SCM_L_PO_BG_Types a, #invoices b
where ordernumber= a.LPOBT_PO_Number
and a.LPOBT_BG_Type=1


Update b set retnbg='Y'
from eip.sqlwom.WOM_L_WO_Request_BG_Types a, #invoices b
where wornumber= a.LWRBT_Request_Number
and a.LWRBT_BG_Type=3


Update b set contrbg='Y'
from eip.sqlwom.WOM_L_WO_Request_BG_Types a, #invoices b
where wornumber= a.LWRBT_Request_Number
and a.LWRBT_BG_Type=2



Update #invoices set advbg='Y' where ptevent in ( 203,223,224,225,302)
Update #invoices set perfbg='Y' where ptevent in ( 208,210,213,214,218,231,303)

-----PO

--select * from #invoices

--drop table #mrndetails

--select * from #mrndetails

---Invoice based Material Details

select distinct b.DLRV_LR_Number,b.DLRV_MRN_Number,b.DLRV_MRN_Date, 
		b.DLRV_WO_Bill_Number,C.MMAT_MG_Code, DMRN_Material_Code,MMGRP_Description, 
		JObcode, DPOT_Stock_Type_Detail_Code, DPOT_Direct_Supply, MMGRP_Class_Code,cast ( null as varchar(100)) materialcategory, 
		cast ( null as varchar(100)) PlanningCategory,c.MMAT_Material_Description
into #MRNdetails
 from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlscm.SCM_D_MRN, eip.sqlmas.GEN_M_Materials C, 
	eip.sqlmas.GEN_M_Material_Groups,eip.sqlmas.GEN_M_Material_Classes e
	,eip.sqlscm.SCM_D_Purchase_Order_Terms
	where a.tlreg_lr_number = b.DLRV_LR_Number and DPOT_PO_Number= ordernumber
and b.DLRV_MRN_Number= DMRN_MRN_Number and c.MMAT_Material_Code= DMRN_Material_Code 
and c.MMAT_Company_Code=1 
and c.MMAT_MG_Code= MMGRP_MG_Code and MMGRP_Company_Code=c.MMAT_Company_Code
and c.MMAT_Company_Code= e.MMATC_Company_Code 

 

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #mrndetails a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where DMRN_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code<>'9999'
	

 Update a set materialcategory = d.LMMCLM_Material_Category_Code 
from #mrndetails a , epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping d
where DMRN_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=1 
and LMMCLM_Material_Category_Code='9999' and materialcategory is null
	

Update a set PlanningCategory = f.MMC_Description 
from #mrndetails a ,epm.sqlpmp.GEN_M_Material_Category f
where  materialcategory= f.MMC_Material_Category_Code and f.MMC_Company_Code=1 


select * from #MRNdetails




alter table #invoices add mrNumber varchar(30) 
alter table #invoices add MRNNUmber varchar(30) 
alter table #invoices add GinNumber varchar(30) 
alter table #invoices add Mrdate date
alter table #invoices add MrAuthDate date
alter table #invoices add POAuth date
alter table #invoices add DCDate date
alter table #invoices add GinDate date
alter table #invoices add MRNDate date
alter table #invoices add MRNAuthDate date

Update a set mrNumber = b.HPO_MR_Number
from #invoices a, eip.sqlscm.SCM_h_Purchase_Orders b
where a.ordernumber = b.HPO_PO_Number

Update a set Mrdate = b.HMR_MR_Date
from #invoices a, eip.sqlscm.SCM_H_Material_Request b
where a.mrNumber = b.HMR_MR_Number


Update a set mrnnumber = b.DLRV_MRN_Number--, mrndate=b.DLRV_MRN_Date
from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b
where a.tlreg_lr_number = b.DLRV_LR_Number

Update a set ginnumber=HMRN_Gin_Number, mrndate=b.HMRN_MRN_Date
from #invoices a, eip.sqlscm.scm_h_mrn b
where a.mrnnumber = b.HMRN_MRN_Number

Update a set gindate=b.HGIN_GIN_Date
from #invoices a, eip.sqlscm.SCM_H_GIN b
where a.ginnumber = b.HGIN_GIN_Number

Update a set gindate=b.HGIN_GIN_Date
from #invoices a, eip.sqlscm.SCM_H_GIN b
where a.ginnumber = b.HGIN_GIN_Number

Update a set dcdate=mindcdate
from #invoices a, (select DGIN_GIN_Number , min(DGIN_DC_Date) mindcdate,max(DGIN_DC_Date) maxdcdate 
							 from eip.sqlscm.SCM_d_GIN b,#invoices c
						where c.ginnumber= b.DGIN_GIN_Number
						group by b.DGIN_GIN_Number) g
where a.ginnumber = g.DGIN_GIN_Number

Update c set mrnauthdate= mindate
from #invoices c, (select mrnnumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate 
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.mrnnumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3 group by mrnnumber) g
where c.mrnnumber = g.mrnnumber

Update c set POAuth= mindate
from #invoices c, (select ordernumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate  
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.ordernumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3  group by ordernumber) g
where c.ordernumber = g.ordernumber

Update c set mrauthdate= mindate
from #invoices c, (select mrNumber, min(b.TSCDA_Action_On) mindate, max(b.TSCDA_Action_On) maxdate 
from eip.sqlscm.SCM_T_Document_Approvals b, #invoices a
where a.mrnumber=b.TSCDA_Document_Reference_Number
and b.TSCDA_DS_Code=3  group by mrNumber) g
where c.mrnumber = g.mrnumber


alter table #invoices add BUdesc varchar(100)
alter table #invoices add ICdesc varchar(100)


uPDATE A SET  BUDESC= B.bu_description
FROM #INVOICES A, lnt.dbo.business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE A SET  ICDESC= B.Sector_Description
FROM #INVOICES A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code


update #invoices set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-'),vendname=replace(vendname,',','-')





select mrdate, MrAuthDate, POAuth, GinDate,	mrndate,MRNAuthDate,Invregisterdate,MinScrutinyDate,	MaxScrutinyDate,	JVDate,	MinDisbdate,	Maxdisbdate,	HPO_PO_Number,	BUdesc,	ICdesc,	TLREG_LR_Number, invvalue	
from #invoices a, eip.sqlscm.SCM_H_Purchase_Orders
where a.ordernumber = HPO_PO_Number



-----wO


alter table #Invoices add WOREquestNo varchar(30)
alter table #Invoices add WORCreatedDate date
alter table #Invoices add WORequestDate date
alter table #Invoices add WOBillNumber varchar(30)

alter table #Invoices add Billdate date
alter table #Invoices add Billdedndate date
alter table #Invoices add BillDednApprovaldate date
alter table #Invoices add Billapprovaldate date
alter table #Invoices add WOApprovalDate date
alter table #Invoices add WORMinApproved date
alter table #Invoices add WORMaxApproved date

--alter table #Invoices alter column WOApprovalDate date
--alter table #Invoices drop column WOApprovalDate 



Update a set WOREquestNo= b.HWO_WO_Request_Number, WORequestDate=hwo_wo_date
from #Invoices a, eip.sqlwom.WOM_H_Work_Orders b
where a.ordernumber = b.HWO_WO_Number

Update a set WOBillNumber= b.DLRV_WO_Bill_Number
from #Invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b
where a.tlreg_lr_number = b.DLRV_LR_Number

Update a set Billdate= b.HBILL_Bill_Date
from #Invoices a, eip.sqlwom.WOM_H_Bills b
where a.wobillnumber = b.HBILL_Bill_Number


Update a set Billdedndate= TWOBD_Inserted_On
from #Invoices a, eip.sqlfas.FAS_T_Work_Order_Bill_Deductions
where a.wobillnumber = TWOBD_Bill_Number


Update a set Billdedndate= TDAPR_Action_On
from #Invoices a, eip.sqlfas.FAS_T_Document_Approvals
where a.wobillnumber = TDAPR_Document_Reference_Number
and TDAPR_DS_Code=1

Update a set BillDednApprovaldate= TDAPR_Action_On
from #Invoices a, eip.sqlfas.FAS_T_Document_Approvals
where a.wobillnumber = TDAPR_Document_Reference_Number
and TDAPR_DS_Code=3

Update a set BillDednApprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where a.wobillnumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=17


Update a set Billapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where a.wobillnumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=3

Update a set woapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where ordernumber = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and TWODA_Amendment_Number=0

Update a set woapprovaldate= Twoda_Action_On
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where worequestno = TWODA_Document_Reference_Number
and TWODA_DS_Code=3
and woapprovaldate is NULL

Update a set WORCreatedDate= Twoda_Action_On
--select * 
from #Invoices a, eip.sqlwom.WOM_T_Document_Approvals
where worequestno = TWODA_Document_Reference_Number
and TWODA_DS_Code=1 --and worequestno='E9972WOR6000046'

Update a set WORCreatedDate= HWORQ_Inserted_On
from #Invoices a, eip.sqlwom.WOM_H_Work_Order_Request
where worequestno = HWORQ_Request_Number
and WORCreatedDate is NULL

Update a set WORMinApproved= Mindt,WORMaxApproved=maxdt
from #Invoices a, (select TWODA_Document_Reference_Number, min(twoda_action_on) mindt, max(twoda_action_on) maxdt
			from eip.sqlwom.WOM_T_Document_Approvals, #Invoices c
			where c.worequestno = TWODA_Document_Reference_Number and TWODA_DS_Code=2 
					and twoda_amendment_number=0
			group by TWODA_Document_Reference_Number) d
where a.worequestno=TWODA_Document_Reference_Number


uPDATE A SET  BUDESC= B.bu_description
FROM #INVOICES A, business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE A SET  ICDESC= B.Sector_Description
FROM #INVOICES A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code

update #invoices set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')

select WORequestDate,WORCreatedDate,WOApprovalDate,	hbill_from_date,hbill_to_date,hbill_bill_date,Invregisterdate,MinScrutinyDate,MaxScrutinyDate,
JVDate,MinDisbdate,Maxdisbdate,BUdesc,ICdesc,DLRV_LR_Number,DLRV_WO_Bill_Number,	HWO_Job_Code,	HWO_WOT_Code, invvalue
from #invoices a, eip.sqlfas.FAS_D_Ledger_Register_Vendor b, eip.sqlwom.WOM_H_Bills c,eip.sqlwom.WOM_H_Work_Orders d
where a.tlreg_lr_number = b.DLRV_LR_Number and a.ordernumber = HWO_WO_Number
and b.DLRV_WO_Bill_Number= hbill_bill_number --and DWMBL_Item_Code= MJITC_Item_Code



 ---common

Return
go

