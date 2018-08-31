SELECT * FROM EPM.SQLPMP.PMP_T_Bill_Of_Quantity_Breakups a,EPM.SQLEPM.EPM_M_Control_Master b, epm.SQLPMP.PMP_T_Bill_Of_Quantities c  WHERE a.tboqbs_job_code = b.tcm_job_code and TCM_PMP_CE_Tag = 'Y'and  a.TBOQBS_Job_Code =c.tboq_job_code and a.TBOQBS_BoQ_Code = c.tboq_boq_code


SELECT * FROM epm.SQLPMP.PMP_T_Bill_Of_Quantities 
use EPM
go

select *from sys.tables where name like '%master%'

select *from lnt.dbo.tender_boq where job_code = 'LE131077'

select *From EPM.SQLEPM.EPM_M_Control_Master

select *from lnt.dbo.scb_job_item_group_link


select *from lnt.dbo.job_master

