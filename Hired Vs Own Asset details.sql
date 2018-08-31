use EIP
GO
---Owned Assets
drop table #asset
select CURRENT_JOB_NO,Sector_Code, ASSET_CODE, DESCRIPTION,P_OR_V_TAG,OWNED_OR_LEASED_TAG, LT_AQN_DATE, LT_AQN_VALUE, BOOK_VALUE_THIS_YEAR, b.job_description, Book_Value_Date
into #asset
from asset.dbo.Plant_Master a, lnt.dbo.job_master b where b.Company_Code='LE'
and ERROR_VALUE_TAG='P' and OWNED_OR_LEASED_TAG in ( 'O','Y','E','F','K','P','U','Y','B')

---and STATUS_TAG='A' 
and a.CURRENT_JOB_NO= b.job_code
and b.company_code='LE'

alter table #asset add ICdesc varchar(100)

UPDATE a SET ICdesc = b.Sector_Description
from #asset a, lnt.dbo.Sector_Master b
WHERE a.sector_code = b.Sector_Code 
AND b.Company_Code='LE'

select *from #asset
---Hired assets
drop table #hired
select distinct hwo_wo_number,CURRENT_JOB_NO, ASSET_CODE, DESCRIPTION,P_OR_V_TAG,OWNED_OR_LEASED_TAG, hwo_wo_date, hwo_from_date,HWO_To_Date, BOOK_VALUE_THIS_YEAR, b.job_description,
d.DWO_Item_Rate,d.DWO_Item_Value,d.DWO_UOM_Code, d.DWO_WO_Qty, DWO_Item_Code, MJITC_Item_Description into #Hired
from asset.dbo.Plant_Master a, lnt.dbo.job_master b,
eip.sqlwom.WOM_H_Work_Orders h , eip.sqlwom.WOM_D_Work_Orders d, eip.sqlwom.WOM_D_Item_Asset_Link,eip.sqlwom.wom_m_job_item_codes
  where b.Company_Code='LE'
--and ERROR_VALUE_TAG='P' 
and OWNED_OR_LEASED_TAG in ( 'H') and b.job_active='Y'
and STATUS_TAG='A' and a.CURRENT_JOB_NO= b.job_code
and b.company_code='LE' and hwo_wot_code=109
and  HWO_WO_Number = DWO_WO_Number and DWO_Item_Code= DIAL_Work_Order_Item
and DWO_WO_Number = DIAL_Work_Order_Number and DIAL_Asset_Code= a.ASSET_CODE
and h.HWO_Company_Code=1 and a.STATUS_TAG='A'
and hwo_job_code =mjitc_job_code
and mjitc_item_code  = DWO_Item_Code 
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(9),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(10),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(11),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(12),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(13),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(14),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, char(15),'-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, '''','-')
update #Hired set MJITC_Item_Description = replace(MJITC_Item_Description, '"','-')
select *from #Hired



select *from asset.dbo.Plant_Master
---sample try

drop table #owned
select CURRENT_JOB_NO, ASSET_CODE, DESCRIPTION,P_OR_V_TAG,OWNED_OR_LEASED_TAG,hwo_wo_date, hwo_from_date,HWO_To_Date, LT_AQN_DATE, LT_AQN_VALUE, BOOK_VALUE_THIS_YEAR, b.job_description,
d.DWO_Item_Rate, DWO_Item_Code,DWO_Item_Value, DWO_WO_Qty, DWO_UOM_Code, EXPECTED_LIFE, LIFE_LEFT
--, MJITC_Item_Description
 into #Owned
from asset.dbo.Plant_Master a, lnt.dbo.job_master b,eip.sqlwom.WOM_H_Work_Orders h , eip.sqlwom.WOM_D_Work_Orders d, eip.sqlwom.WOM_D_Item_Asset_Link
where b.Company_Code='LE'
and ERROR_VALUE_TAG='P' and OWNED_OR_LEASED_TAG in ( 'O','Y','E','F','K','P','U','Y','B')
and STATUS_TAG='A' and a.CURRENT_JOB_NO= b.job_code
and b.company_code='LE'
and  HWO_WO_Number = DWO_WO_Number and DWO_Item_Code= DIAL_Work_Order_Item
and DWO_WO_Number = DIAL_Work_Order_Number and DIAL_Asset_Code= a.ASSET_CODE
and h.HWO_Company_Code=1 and a.STATUS_TAG='A'



select *from #Owned


use eip
go


select * from eip.sqlwom.wom_m_job_item_codes where mjitc_item_code in ('190000000001960','190000000001968','190000000001974')
and mjitc_job_code ='CETC6554'

select *from asset.dbo.Plant_Master 

use lnt
go

select *from lnt.dbo.vendor_master

select *from lnt.dbo.vendor_registration_detail

select *from eip.sqlwom.WOM_D_Work_Orders where DWO_WO_Number ='E4408WOD4000115' and DWO_Item_Code ='190000000002336'

use asset
go

select *from eip.sqlwom.WOM_D_Item_Asset_Link

select *from dbo.ams_asset_logsheet_detail_data
select*from dbo.ams_asset_logsheet_header_data
select *from dbo.ams_asset_type_master
select *from dbo.ams_h_work_orders

use asset
go

select *from sys.tables where name like '%work%'
