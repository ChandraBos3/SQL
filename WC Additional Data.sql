
use CRM
GO

drop table #invoice
select job_code, invoice_no, a.invoice_type,Actual_Invoice_No,order_no,customer_code, invoice_date, gross_amt_current, certification_date,
	gross_amt_certified_current, 	 deduct_amt_certified_current,taxable_amt_current, add_amt_certified_current,
		cast(null as varchar(100)) paymentterm, cast(0 as money) osduedays, cast( null as date) duedate
into #invoice
from crm.dbo.invoice_header a, crm.dbo.invoice_type_master b where   Consider_For_Sales ='y'
 and job_code = 'LE130413' and substring(invoice_no,4,2)=b.invoice_type


update b set  duedate= case when os_due_on_tag = 'IC' then Certification_date + OS_Due_Days
				else certification_date + OS_Due_Days end  , 
paymentterm = case when os_due_on_tag = 'IC' then 'On Certification ' else 'On Claimed' End ,
osduedays = OS_Due_Days
				--select * 
from crm.dbo.Job_OS_Details a, #invoice b where a.job_code = 'LE130413' 
and a.job_code = b.job_code and a.Order_No = b.order_no and a.Invoice_Type = b.invoice_type

select * from #invoice



