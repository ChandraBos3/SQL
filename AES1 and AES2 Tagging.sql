SELECT * FROM epm.SQLPMP.GEN_M_Job_Configuration_Details, epm.SQLPMP.GEN_M_Configurations, lnt.dbo.job_master d,lnt.dbo.sector_master c  where mjcd_configuration_id = mcfg_configuration_id
and mjcd_job_code= job_code
and d.company_code='LE'
and c.company_code='LE'
and d.Sector_Code=c.Sector_Code

and mjcd_configuration_id ='2'

select *from lnt.dbo.job_master

use eip

go

use epm

go


