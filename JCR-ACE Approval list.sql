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

Insert into #acejobs
select TCM_Job_Code Job_code, 'JCR' module , maxdate jcrdate , b.bpcode
from epm.sqlepm.EPM_M_Control_Master, (
SELECT TPBP_Job_Code, max(TPBP_BP_Code) bpcode,max(s.TPBP_To_date) maxdate from epm.sqlpmp.PMP_T_Project_Base_Plans s
                                                                     where s.TPBP_PST_Code = 3000 AND 
                                                                                  s.TPBP_DS_Code IN ('BPDS0003') AND s.TPBP_DS_Code IS NOT NULL
                                                                     group by TPBP_Job_Code) b
where TCM_Job_Code = TPBP_Job_Code and TCM_Job_Code in (
select job_code from  lnt.dbo.job_master c
where  c.company_code='LE' and c.job_operating_group <>'I' and job_status in ( 'C','R') )
and TCM_PMP_TAG='Y' and isnull(TCM_EPM_Tag,'N') ='N' 

---drop table #acejobs

select distinct job_code,module, jcrdate,substring(TDA_Document_Number,1,12), tda_approved_by,job_code + '/'+module +'/'+ cast(month(jcrdate) as varchar(2)) +'-'+cast(year(jcrdate) as varchar(4))
 from #acejobs a, 
epm.sqlpmp.PMP_T_Document_Approvals where right(TDA_Document_Number,4 )= cast(year(jcrdate) as varchar(4))
and 
TDA_DS_Code=2 
and substring(TDA_Document_Number,1,12)=job_code+'/'+module 
and job_code='LE160086'

select * from #acejobs where job_code = 'le160957'


select * from epm.sqlpmp.PMP_T_Document_Approvals a where TDA_DS_Code=2 and exists ( select 'x' from #acejobs b
where left(tda_document_number,8) = job_code )--and job_code='LE160086')


2017-07-31 00:00:00.000	LE160086/JCR	5635
2017-07-31 00:00:00.000	LE160086/JCR	55559
2017-07-31 00:00:00.000	LE160086/JCR	359248
2017-07-31 00:00:00.000	LE160086/JCR	369987
2017-07-31 00:00:00.000	LE160086/JCR	414255
2017-07-31 00:00:00.000	LE160086/JCR	414258

select a.*, b.job_description, b.Sector_Code from #acejobs a, lnt.dbo.job_master b where a.job_code = b.job_code

select a.*, b.job_description, b.Sector_Code from #acejobs a, lnt.dbo.job_master b
where a.job_code= b.job_code


select muser_reference_id,MUSER_Login_Name from eip.sqlmas.gen_m_users where MUSER_Company_Code=1

select *from eip.sqlmas.GEN_M_Employees
select *from lnt.dbo.staff_master where psno = '15654'
select *from lnt.dbo.security_user_master where uid ='8846'

select *from eip.sqlmas.gen_m_users
select *from eip.sqlmas.GEN_M_Document_Transaction
select *from eip.sqlmas.GEN_M_Employee_Details
select *from eip.sqlmas.gen_m_e

select uid, Staff_name, designation from lnt.dbo.staff_master, lnt.dbo.security_user_master where user_class_code = Psno

