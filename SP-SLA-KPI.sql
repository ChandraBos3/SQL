use EIP
GO
---/
--#Lntsp_SLA_KPI @fromdate='01-May-2018', @Todate='17-Aug-2018'
Create Procedure #Lntsp_SLA_KPI
(
@fromdate		Date,
@Todate			Date,
@Company_code varchar(15) = 'LE',
@Jobcode		varchar(15)= Null
)
as

select TDF_Document_code docnumber, tdf_dt_code doctype,MDOCT_Name docdesc,tdf_job_Code jobcode, TDF_Sender_UID sender, muser_reference_id as PSNO, 
MUSER_Login_Name as Login,TDF_Receiver_UID receiver, 
TDF_Send_Date_Time ActionStartTime, dateadd(HOUR,TDF_KPI,TDF_Send_Date_Time) MaxExpTime,
TDF_Received_Status_Date_Time ActionEndTime, b.Sector_Code IC, b.bu_code BU, b.job_description JObDesc, cast(0 as money) po_wo_Basic_value,cast(0 as money) po_wo_Net_value,TDF_Action_Status,
'Approver'  UserPosition, CAST( 0 AS INTEGER) CURRENCYCODE, cast(0 as money) wotaxamount, cast(0 as money) worqtaxamount
Into #SLAKPI
 from eip.sqlacs.ACS_T_Document_Flow , lnt.dbo.job_master b, eip.sqlmas.GEN_M_Document_Transaction, eip.sqlmas.gen_m_users
 where tdf_dt_code in(204,224,301,304,10036,10640) and tdf_kpi is not NULL
and TDF_Send_DOPT_Code iN ('A')
and TDF_Job_Code= b.job_code
and b.company_code='LE'and TDF_Action_Status='Y'
--and TDF_Receiver_UID ='11409'
and TDF_dt_code= MDOCT_DT_Code 
and TDF_Send_Date_Time between @fromdate and @Todate
and muser_user_id=TDF_Receiver_UID
ORDER BY 1


alter table #SLAKPI add POStatus varchar(15)

update a set po_wo_Basic_value= HPO_PO_Basic_Value, postatus =  b.HPO_DS_Code, CURRENCYCODE=HPO_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_Purchase_Orders b
where docnumber= hpo_po_number

update a set po_wo_Net_value= hpo_po_net_value, postatus =  b.HPO_DS_Code, CURRENCYCODE=HPO_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_Purchase_Orders b
where docnumber= hpo_po_number

update a set po_wo_Basic_value= hwo_wo_amount,postatus =  b.HWO_DS_Code,CURRENCYCODE=HWO_Currency_Code
from #slakpi a, eip.sqlwom.WOM_H_Work_Orders b
where docnumber= hwo_wo_number


Update a set wotaxamount=(taxamt1 + taxamt2)
from #slakpi a, (select dwo_wo_number, sum(DWO_Item_TaxAmount_Billed) taxamt1, sum(DWO_Item_TaxAmount_Balance) taxamt2
 from eip.sqlwom.wom_d_work_orders b, #slakpi a
where dwo_wo_number = a.docnumber
group by dwo_wo_number) c
where c.dwo_wo_number = a.docnumber

update a set po_wo_Net_value= (HWO_WO_Amount + wotaxamount), postatus= b.HWO_DS_Code, CURRENCYCODE= HWO_CURRENCY_CODE
from #slakpi a, eip.sqlwom.WOM_H_Work_Orders b
where docnumber= HWO_WO_Number

update a set po_wo_Basic_value= HWORQ_Amount, postatus= b.HWORQ_DS_Code, CURRENCYCODE= HWORQ_CURRENCY_CODE
from #slakpi a, eip.sqlwom.WOM_H_Work_Order_Request b
where docnumber= HWORQ_Request_Number

Update a set worqtaxamount=taxamt
from #slakpi a, (select DWORQ_Request_Number, sum(DWORQ_Item_Tax_Amount) taxamt
 from eip.sqlwom.WOM_D_Work_Order_Request b, #slakpi a
where DWORQ_Request_Number = a.docnumber
group by DWORQ_Request_Number) c
where c.DWORQ_Request_Number = a.docnumber


update a set po_wo_Net_value= (HWORQ_Amount + worqtaxamount), postatus= b.HWORQ_DS_Code, CURRENCYCODE= HWORQ_CURRENCY_CODE
from #slakpi a, eip.sqlwom.WOM_H_Work_Order_Request b
where docnumber= HWORQ_Request_Number

update a set po_wo_Basic_value= HPOAR_PO_Basic_Value,postatus= b.HPOAR_DS_Code, CURRENCYCODE=HPOAR_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_PO_Amend_Request b
where docnumber= HPOAR_Request_Number

update a set po_wo_Net_value= HPOAR_PO_Net_Value,postatus= b.HPOAR_DS_Code, CURRENCYCODE=HPOAR_Currency_Code
from #slakpi a, eip.sqlscm.SCM_H_PO_Amend_Request b
where docnumber= HPOAR_Request_Number


alter table #slakpi add BUdesc varchar(100)
alter table #slakpi add ICdesc varchar(100)


uPDATE a SET  BUDESC= B.bu_description
FROM #SLAKPI A, lnt.dbo.business_unit_master B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE
AND C.BU_CODE = B.BU_CODE


uPDATE a SET  ICDESC= B.Sector_Description
FROM #slakpi A, LNT.DBO.SECTOR_MASTER B, LNT.DBO.JOB_MASTER c
WHERE A.JOBCODE = C.JOB_cODE AND B.Company_Code= C.company_code
AND C.Sector_Code = B.Sector_Code


update #slakpi set budesc=replace(budesc,',','-'),ICDESC=replace(ICDESC,',','-')

select * from #slakpi where postatus =3 and  ((tdf_action_status ='Y' and userposition='Approver') or (userposition='Verifier'))
order by 1,2,3,7
select * from #slakpi where postatus is null

Return
go


