 lnt.dbo.job_master a, 
 
 USE LNT
 GO
 drop table #TEMP1
select MPBS_JOB_CODE,job_description,Sector_Code,bu_code, MPBS_DESCRIPTION, MPBS_UOM_CODE,MPBS_PBS_CODE 
into #temp1
FROM eip.sqlmas.GEN_M_Project_Breakdown_Structure,LNT.DBO.JOB_MASTER 
WHERE  MPBS_JOB_CODE=job_code
AND MPBS_ISActive='Y'
and MPBS_Company_Code =1 and company_code ='LE'
update #temp1 set MPBS_DESCRIPTION = replace(replace(replace(replace(replace(replace(replace(replace(MPBS_DESCRIPTION,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),
                                  char(14),'-'),'''','F'),'"','I')

alter table #temp1 add BUdesc varchar(100)
alter table #temp1 add ICdesc varchar(100)
alter table #temp1 add UOMdesc varchar(100)

UPDATE a SET ICdesc = b.Sector_Description
from #temp1 a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'


UPDATE a SET BUdesc = b.bu_description
from #temp1 a, lnt.dbo.business_unit_master b
WHERE a.bu_code = b.bu_code 
AND b.Company_Code='LE'

UPDATE a SET UOMdesc = b.UUOM_Description
from #temp1 a, eip.sqlmas.GEN_U_Unit_Of_Measurement b
WHERE a.MPBS_UOM_CODE = b.UUOM_UOM_Code



 SELECT *FROM #temp1

 SELECT *FROM  eip.sqlmas.GEN_M_Project_Breakdown_Structure