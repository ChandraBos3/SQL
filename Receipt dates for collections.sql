select b.DPR_Customer_Code, b.DPR_Job_Code, a.HPR_Voucher_Date, b.DPR_Ledger_COA_Code,b.DPR_Currency_Code, b.DPR_Debit_Amount, 
        b.DPR_Credit_Amount, DBRG_Bill_Number,DBRG_Bill_Date, DBRG_Due_Date, b.DPR_Narration, DBR_Order_Number, cast(null as varchar(100)) Remarks
       into #Collections
from eip.sqlfas.FAS_H_Payments_Receipts a, eip.sqlfas.FAS_D_Payments_Receipts b, eip.sqlmas.GEN_M_Charter_Of_Accounts c,
eip.sqlfas.FAS_D_Booking_Register_General , eip.sqlfas.FAS_H_Booking_Register, eip.sqlfas.FAS_D_Booking_Register
where a.HPR_PRV_Number = b.DPR_PRV_Number and a.HPR_Company_Code=1 and HBR_BR_Number = DBR_BR_Number
and DBR_BR_Number = DBRG_BR_Number and DBR_Serial_Number = DBRG_BR_Serial_Number and b.DPR_BR_Number=DBR_BR_Number
and b.DPR_Voucher_Serial_Number = DBR_Serial_Number 
and c.MCOA_Company_Code= a.HPR_Company_Code
and c.MCOA_COA_Code= b.DPR_Ledger_COA_Code
and c.MCOA_Ledger_Code=4
and a.HPR_Voucher_Date>='01-Jan-2016' and a.HPR_Voucher_Date<='31-Mar-2018'
and b.DPR_Job_Code in ('LE160041','LE160042')


Update #Collections set DBRG_Due_Date = case when b.OS_Due_On_Tag='IC' then certification_date + b.OS_Due_Days
                                                                                  else d.invoice_date + b.OS_Due_Days end , remarks= case when b.OS_Due_On_Tag='IC' then 'On Certification' else 'On Claim' end
from #Collections a,  crm.dbo.Job_Order_Master c, crm.dbo.Job_OS_Details b, crm.dbo.invoice_header d
where a.DBR_Order_Number= b.Order_No and a.DPR_Job_Code in ('LE160041','LE160042')
and a.DPR_Job_Code = d.job_Code and a.dbrg_bill_number = d.invoice_no and  d.invoice_type = b.Invoice_Type


select * from #collections
