select asset_group_code, asset_group_Desc, OWNED_OR_LEASED_TAG, count(a.asset_Code) 
from asset.dbo.plant_master a, 
asset.dbo.asset_group_master b where  a.company_code = 'LE'
and  asset_group_code = left(a.asset_code,4) and a.company_Code = b.company_Code
and STATUS_TAG in ('A','Y')  and OWNED_OR_LEASED_TAG in ('O', 'H')
group by asset_group_code, asset_group_Desc, OWNED_OR_LEASED_TAG

---New Program with job description----- 
select B.Four_Digit_Code,B.Description, OWNED_OR_LEASED_TAG, count(a.asset_Code), d.sector_code 
from asset.dbo.plant_master a, 
asset.dbo.FOUR_group b, lnt.dbo.job_master c, LNT.DBO.SECTOR_MASTER D
where  a.company_code = 'LE'
and  B.Four_Digit_Code = left(a.asset_code,4) and a.company_Code = b.company_Code
and CURRENT_JOB_NO =c.job_code
and c.company_code='LE'
and c.Sector_Code=d.Sector_Code
---and d.sector_code in ('b', 'e','g','i','o','sw','ti','u','ws')
---and d.sector_code in ('I')
and STATUS_TAG in ('A','Y')  and OWNED_OR_LEASED_TAG in ('O', 'H')
group by d.sector_code, Four_Digit_Code, B.Description, OWNED_OR_LEASED_TAG

----105


select asset_group_code, asset_group_Desc, OWNED_OR_LEASED_TAG, a.asset_Code, CURRENT_JOB_NO
from asset.dbo.plant_master a, 
asset.dbo.asset_group_master b where  a.company_code = 'LE'
and  asset_group_code = left(a.asset_code,4) and a.company_Code = b.company_Code
and STATUS_TAG in ('A','Y')  and OWNED_OR_LEASED_TAG in ('O', 'H')
and asset_group_code LIKE ('0135')

