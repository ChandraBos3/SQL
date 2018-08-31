use eip
go

select *from lnt.dbo.job_master
select *from sys.tables where name like '%stock%'
select *from eip.sqlscm.SCM_T_Warehouse_Closing_Stock

drop table #stocklimit
select a.TWHCS_Material_Code, a.TWHCS_Qty, a.TWHCS_Value, a.TWHCS_Job_Code, b.job_description,B.Sector_Code IC,
			C.SECTOR_DESCRIPTION,B.BU_CODE,D.bu_description into #stocklimit 
from eip.sqlscm.SCM_T_Warehouse_Closing_Stock a, lnt.dbo.job_master b, LNT.DBO.SECTOR_MASTER c, lnt.dbo.business_unit_master D
where a.TWHCS_Job_Code =b.job_code 
and job_status in ('P','B')
and a.TWHCS_Material_Code like '7%'AND b.company_code='LE'
and TWHCS_Stock_Year = 2017 and TWHCS_Stock_Month = 6 and TWHCS_Stock_Detail_Code =11
AND B.SECTOR_CODE = C.SECTOR_CODE AND C.COMPANY_CODE = B.COMPANY_CODE
AND B.BU_CODE = D.BU_CODE AND D.COMPANY_CODE = B.COMPANY_CODE

alter table #stocklimit add UOM varchar(100)
UPDATE A SET UOM= UUOM_Description from #stocklimit a, eip.sqlmas.GEN_M_Materials c, EIP.SQLMAS.GEN_U_Unit_Of_Measurement d
where a.TWHCS_Material_Code = c.MMAT_Material_Code 
and c.MMAT_Company_Code=1
and d.UUOM_UOM_CODE= C.MMAT_UOM_Code
SELECT *FROM #STOCKLIMIT


MMAT_UOM_Code
REFERENCES EIP.SQLMAS.GEN_U_Unit_Of_Measurement (UUOM_UOM_Code)
MMAT_Material_Code, MMAT_Company_Code

SELECT * FROM #stocklimit
alter table #stocklimit add BUdesc varchar(100)
alter table #stocklimit add ICdesc varchar(100)

Update a set ICdescription= c.Sector_description from #STOCKLIMIT A, LNT.DBO.SECTOR_MASTER c, LNT.DBO.JOB_MASTER B
where A.TWHCS_Job_Code=c.job_code and c.sector_code =b. sector_code

Update a set BUdescription= D.bu_description FROM #STOCKLIMIT A,LNT.DBO.JOB_MASTER B, lnt.dbo.business_unit_master d
WHERE A.twhcs_job_code= d.job_code
and b.job_code =d.job_code

update #stocklimit set BUdescription=replace(BUdescription,',','-'),ICdescription=replace(ICdescription,',','-')

select *from #stocklimit


