use epm
go

select *from sys.tables where name like '%project%'
SELECT * FROM EPM.SQLpmp.PMP_T_Master_Controller

SELECT * FROM EPM.SQLEPM.EPM_M_Control_Master

select *from epm.sqlpmp.PMP_T_Project_Base_Plans 

SELECT * FROM SQLPMP.PMP_T_Schedule_Details WHERE TSHD_Schedule_For = 'SCHD0002' 
use crm
go


select job_code, inserted_on, valuation_year, valuation_month from crm.dbo.invoice_valuation_sheet where job_status in ('C','R')

group by job_code, valuation_year, valuation_month

select *from lnt.dbo.job_master where job_code = 'LE131113' 


SELECT TPBP_Job_Code, TPBP_BP_Code,TPBP_To_date from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 3000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code

select *from epm.sqlpmp.PMP_T_Project_Base_Plans