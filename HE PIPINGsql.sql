use eip
GO

drop table #billlist

select d.sector_code,d.Sector_Description, HWO_Job_Code, c.job_description, HWO_WO_Number, DWO_Item_Code,
cast(null as varchar(15)) workcategorycode,cast(null as varchar(500)) workCategory, 
cast(null as varchar(500)) itemdesc,HWO_Currency_Code, cast( null as varchar(15))currencydesc, DWO_WO_Qty, DWO_Item_Rate, DWO_Item_Value,DWO_UOM_Code,
HWO_Last_Amendment_Number,HWO_WOT_Code,MWOTP_Description, HWO_BA_Code,vendor_description, CAST( NULL AS VARCHAR(15)) NEWOLDCODE, location, c.SBG_Code, HWO_WO_Amount, HWO_WO_Date
,hwo_ds_code
into #billlist
from  lnt.dbo.job_master c, lnt.dbo.sector_master d, eip.sqlwom.WOM_H_Work_Orders, eip.SQLWOM.WOM_D_Work_Orders,lnt.dbo.vendor_master j, eip.SQLMAS.GEN_M_WO_Types 
WHERE
HWO_WO_Number = DWO_WO_Number
--and HWO_WO_Date>='01-Sep-2017' and HWO_WO_DATE <='31-Dec-2017' 
and HWO_Job_Code= c.job_code
and c.Sector_Code = d.Sector_Code and c.company_code='HE' and c.company_code = d.Company_Code and hwo_ba_code = j.vendor_code 

and HWO_DS_CODE =3
and j.company_code = 'HE'
and hwo_company_code  = '10'
and HWO_WOT_code = MWOTP_WOT_Code

--AND d.sector_code = 'ws'


uPDATE A SET NEWOLDCODE ='NEW'
FROM #BILLLIST A, EPM.SQLPMP.Gen_M_Standard_Resource B
WHERE A.DWO_Item_Code = B.MSR_Resource_Code AND MSR_Resource_Type_Code='scpl'
--AND MSR_Attribute_Combination_Value IS NOT NULL




Update a set workcategorycode = MJITC_Item_Group_Code,itemdesc = left(MJITC_Item_Description,500)
from #billlist a, eip.sqlwom.wom_m_job_item_codes
where HWO_Job_Code = MJITC_Job_Code
and MJITC_Item_Code= DWO_Item_Code
and MJITC_Company_Code='10'


Update a set workCategory = b.MIGRP_Description
from #billlist a, EIP.SQLMAS.GEN_M_ITEM_GROUPS B
where workcategorycode= b.MIGRP_Item_Group_Code


Update a set currencydesc = left(b.MCUR_Short_Description,50)
from #billlist a, eip.sqlmas.GEN_M_Currencies b
where HWO_Currency_Code= b.MCUR_Currency_Code 





Update #billlist set itemdesc = replace(itemdesc , char(9),'-')

Update #billlist set itemdesc = replace(itemdesc , char(10),'-')

Update #billlist set itemdesc = replace(itemdesc , char(11),'-')

Update #billlist set itemdesc = replace(itemdesc , char(12),'-')

Update #billlist set itemdesc = replace(itemdesc , char(13),'-')

Update #billlist set itemdesc = replace(itemdesc , char(14),'-')

Update #billlist set itemdesc=replace (itemdesc , '''','f')
Update #billlist set itemdesc=replace (itemdesc , '"','i')

alter table #billlist add BUdesc varchar(100)

uPDATE a SET  BUdesc= d.bu_description
FROM #billlist a, lnt.dbo.business_unit_master d, LNT.DBO.JOB_MASTER c
WHERE hwo_Job_Code= c.job_code
AND c.BU_CODE = d.bu_code

alter table #billlist add sbgdesc varchar (200)

UPDATE a SET sbgdesc = b.SBG_Description
from #billlist a, lnt.dbo.sbg_master b
WHERE a.sbg_code = b.sbg_code 



alter table #billlist add Locdesc varchar(100)

UPDATE a SET Locdesc  = b.region_description
from #billlist a, lnt.dbo.region_master b
WHERE a.location = b.region_code
and b. Company_Code='hE'



select * from #billlist where workcategorycode in ( '0076', '6M25')

use lnt
go

select *from sys.tables where name like '%comp%'

select *from lnt.dbo.Company_Master
select *from lnt.dbo.location_master

use eip
go


select *from eip.sqlwom.wom_m_job_item_codes where MJITC_Company_Code ='10'

select *from EIP.SQLMAS.GEN_M_ITEM_GROUPS


