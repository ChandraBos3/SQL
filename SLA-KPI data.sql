---PO & POA  Authorised by SNS from 1-Apr-2017 

select a.HPO_PO_Number, a.HPO_Job_Code, a.HPO_PO_Date, a.HPO_Currency_Code, a.HPO_PO_Basic_Value, a.HPO_PO_Net_Value, 
              TSCDA_Amendment_Number AMENDMENTNUMBER,a.HPO_DS_Code, a.HPO_PO_Net_Value-a.HPO_PO_Basic_Value TAXES, TSCDA_Action_On
from eip.sqlscm.SCM_H_Purchase_Orders a , eip.sqlscm.scm_t_document_approvals 
 where TSCDA_DS_Code in (2,30,3) and TSCDA_Action_On>='01-Apr-2017' and HPO_PO_Net_Value>=100000000
and HPO_DS_Code=3 and a.HPO_PO_Number= TSCDA_Document_Reference_Number
and TSCDA_Action_By=241 and a.HPO_Company_Code=1 AND a.HPO_Currency_Code=72

--159 Rows ---PO Amendment Number is zero are PO, if Amendment Number is notzero then it is POA

---WO Authorised by SNS from 1-Apr-2017

drop table #WO
 select HWO_WO_Number , HWO_JOB_cODE,  HWO_WO_Date, HWO_CURRENCY_cODE, HWO_WO_Amount, CAST( 0 AS MONEY) WOINCLTAX, 
              TWODA_Amendment_Number, a.HWORQ_DS_Code, CAST( 0 AS MONEY) taxes, TWODA_Action_On
			  into #WO
  from eip.sqlwom.WOM_H_Work_Order_Request a , eip.sqlwom.WOM_T_Document_Approvals , eip.sqlwom.WOM_H_Work_Orders
where TWODA_DS_Code in (2,30,3) and TWODA_Action_On>='01-Apr-2017' and TWODA_Approve_Value>=100000000
and a.HWORQ_DS_Code=3 and a.HWORQ_Request_Number= TWODA_Document_Reference_Number
and TWODA_Action_By=241 and a.HWORQ_Request_Number = HWO_WO_Request_Number and HWO_DS_Code=3
AND HWO_Company_Code=1 

alter table #WO add taxbilled money, taxbalance money, wotaxamount money

Update c set wotaxamount=taxamt,taxbilled=taxbill, taxbalance=taxbal
from #WO c, (
select dwo_wo_number, sum(dwo_item_tax_amount) taxamt, sum(dwo_item_taxamount_billed) taxbill,sum(dwo_item_taxAmount_balance) taxbal
 from eip.sqlwom.wom_d_work_orders a, #WO b
where dwo_wo_number = b.HWO_WO_Number 
group by dwo_wo_number) b
where b.dwo_wo_number = c.HWO_WO_Number 

SELECT *FROM #WO
--118
---WO Amendment Authorised by SNS from 1-Apr-2017

drop table #WOA

 select HWO_WO_Number , a.HWOA_WO_Amendment_Date, HWO_WO_Date, hwo_currency_Code, (hwo_wo_amount+TWODA_Approve_Value) WO_Value, CAST( 0 AS MONEY) WOINCLTAX, 
        TWODA_Amendment_Number , a.HWOA_DS_Code,CAST( 0 AS MONEY) taxes, TWODA_Action_On
		into #WOA
  from eip.sqlwom.WOM_H_WOA_Request a , eip.sqlwom.WOM_T_Document_Approvals , eip.sqlwom.WOM_H_Work_Orders
where TWODA_DS_Code in (2,30,3) and TWODA_Action_On>='01-Apr-2017' --and TWODA_Approve_Value>=100000000
and a.HWOA_DS_Code=3 and a.HWOA_WO_Number= TWODA_Document_Reference_Number and a.HWOA_Amendment_Number= TWODA_Amendment_Number
and TWODA_Action_By=241 and a.HWOA_WO_Number = HWO_WO_Number and HWO_DS_Code=3

alter table #WOA add taxbilled money, taxbalance money, wotaxamount money
Update c set wotaxamount=taxamt,taxbilled=taxbill, taxbalance=taxbal
from #WOA c, (

select dwo_wo_number, sum(dwo_item_tax_amount) taxamt, sum(dwo_item_taxamount_billed) taxbill,sum(dwo_item_taxAmount_balance) taxbal
 from eip.sqlwom.wom_d_work_orders a, #WOA b
where dwo_wo_number = b.HWO_WO_Number 
group by dwo_wo_number) b
where b.dwo_wo_number = c.HWO_WO_Number 

SELECT *FROM #WOA

