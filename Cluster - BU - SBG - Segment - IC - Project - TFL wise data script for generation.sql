
drop table #salesdata
select a.job_code,b.Sector_Code, b.Cluster_Code ,b.bu_code, b.Sub_BU_Code, b.SBG_Code,b.job_operating_group, a.rev_sales contvalue, 
a.Sales_PMS Cumsales, cast(0 as money) LYsales, cast(0 as money) YTDsales , cast(0 as money) backlogonsales,
cast ( null as varchar(200)) ICdesc, cast(null as varchar(200)) SBGDESC, cast(null as varchar(200)) BUdesc, cast(null as varchar(200)) Segment, 
       cast(null as varchar(200)) clusterdesc, cast(0 as money) LYOBOOK
into #salesdata
from crm.dbo.invoice_valuation_sheet a, lnt.dbo.job_master b
where a.job_code = b.job_code 
and a.valuation_year=2017 and a.valuation_month=3
and a.Currency_Tag='C'
and a.job_type=1 and b.company_code='LE'

Update a set LYsales = sales_pms, lyobook = rev_sales
from #salesdata a, crm.dbo.invoice_valuation_sheet b
where a.job_Code = b.job_Code and b.valuation_year=2016 and b.valuation_month=3
and b.Currency_Tag='C' 

update #salesdata set ytdsales = cumsales - lysales, backlogonsales = contvalue-cumsales

Update a set icdesc = sector_description
from #salesdata a, lnt.dbo.sector_master b
where a.sector_code =  b.Sector_Code and b.Company_Code='LE'

Update a set sbgdesc = b.SBG_Description
from #salesdata a, lnt.dbo.sbg_master b
where a.sbg_code =  b.sbg_Code --and b.Company_Code='LE'

Update a set budesc = b.bu_description
from #salesdata a, lnt.dbo.business_unit_master b
where a.bu_code =  b.bu_code and b.Company_Code='LE'

Update a set segment = b.Sub_BU_Description
from #salesdata a, lnt.dbo.Sub_BU_Master b
where a.sub_bu_code =  b.Sub_BU_Code --and b.Company_Code='LE'

Update a set clusterdesc = b.Cluster_Description
from #salesdata a, lnt.dbo.Cluster_Master b
where a.cluster_code =  b.Cluster_Code --and b.Company_Code='LE'


select sum(ytdsales)/10000000,sum(backlogonsales)/10000000 from #salesdata

use EIP
GO

select * from eip.sqlmas.gen_m_functional_roles where MFR_Company_Code=1
and (MFR_Description like '%PROJECT%/%mANAGER%' )--or MFR_Description like '%cluster%/%head%')

---Project Head
---Project Director
---Cluster Project Manager / Sector Project Manager
---Segment Head
---Business Unit Head
---SBG Head
--IC Head

--Need to substitute one role after another to get the output for each of the positions.

select MEMP_Employee_ID as Psno, memp_name as Name,s.sector_code as IC,s.short_description as UserIC,job_code,job_description,MFR_Description as FR,
mcadr_description, mcadr_tier_code,  musgd_mail_id, musgd_mobile,                             
Case (mfr_cplt_code) when 1  then 'HQ'                               
When 2 Then 'RO/Cluster'                               
When 3 then 'FAC'                               
When 4 then 'Site' END  as Location   , j.bu_code, j.sbg_code, j.sub_bu_code, j.cluster_Code                               
from sqlmas.gen_m_users , sqlmas.GEN_M_Functional_Roles , sqlacs.acs_l_user_job_functional_roles,                                   
lnt.dbo.job_master j, eip.sqlmas.GEN_M_Employees, lnt.dbo.sector_master s  , sqlmas.gen_m_cadres  , eip.sqlmas.gen_m_user_general_details                         
where MUSER_USER_ID=LUJFR_User_ID and LUJFR_FR_Code =MFR_FR_Code --and MFR_CPLT_Code=4                               
and MFR_Company_Code=1 and memp_cadre_code =MCADR_Cadre_Code and MCADR_Company_Code=MEMP_Company_Code
and MFR_Description like '%PROJECT%/%' and muser_reference_id =memp_employee_id                             
and muser_company_code=memp_company_code and MEMP_Company_Code=MFR_Company_Code and LUJFR_Job_Code=job_code                                 
and s.sector_code=j.sector_code and muser_isactive='y'    
--and exists ( select 'x' from #salesdata s where s.job_Code = j.job_Code)  
and musgd_user_id = muser_user_id     
and j.job_code in ('DHDH5547','LE160551','LE080378','HBBG3616','LE150642','LE150235','LE130842','LE150033''LE150286','LE150315','LE150384','LE150573','LE150575','LE150993','LE151047','LE151069''LE160143','LE160144','LE160241','LE160348','LE160486','LE160548','LE160807','LE170216')
                
order by short_description,memp_name     

select * from #salesdata                          

select *from sqlmas.GEN_M_Functional_Roles