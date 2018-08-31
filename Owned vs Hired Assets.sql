use EIP
GO
---Owned Assets
select CURRENT_JOB_NO, ASSET_CODE, DESCRIPTION,P_OR_V_TAG,OWNED_OR_LEASED_TAG, LT_AQN_DATE, LT_AQN_VALUE, BOOK_VALUE_THIS_YEAR, b.job_description
from asset.dbo.Plant_Master a, lnt.dbo.job_master b where b.Company_Code='LE'
and ERROR_VALUE_TAG='P' and OWNED_OR_LEASED_TAG in ( 'O','Y','E','F','K','P','U','Y','B')
and STATUS_TAG='A' and a.CURRENT_JOB_NO= b.job_code
and b.company_code='LE'

---Hired assets

select distinct hwo_wo_number,CURRENT_JOB_NO, ASSET_CODE, DESCRIPTION,P_OR_V_TAG,OWNED_OR_LEASED_TAG, LT_AQN_DATE, LT_AQN_VALUE, BOOK_VALUE_THIS_YEAR, b.job_description,
d.DWO_Item_Rate
from asset.dbo.Plant_Master a, lnt.dbo.job_master b,
eip.sqlwom.WOM_H_Work_Orders h , eip.sqlwom.WOM_D_Work_Orders d, eip.sqlwom.WOM_D_Item_Asset_Link
  where b.Company_Code='LE'
--and ERROR_VALUE_TAG='P' 
and OWNED_OR_LEASED_TAG in ( 'H') and b.job_active='Y'
and STATUS_TAG='A' and a.CURRENT_JOB_NO= b.job_code
and b.company_code='LE' 
and  HWO_WO_Number = DWO_WO_Number and DWO_Item_Code= DIAL_Work_Order_Item
and DWO_WO_Number = DIAL_Work_Order_Number and DIAL_Asset_Code= a.ASSET_CODE
and h.HWO_Company_Code=1 and a.STATUS_TAG='A'


