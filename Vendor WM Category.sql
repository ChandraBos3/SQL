select vendor_code, MBAC_Description, subcontractor_type,* from eip.sqlmas.GEN_M_BA_Categories , eip.sqlbas.BAS_D_BA_Categories, lnt.dbo.vendor_registration_detail 
where MBAC_BA_Category_Code= DBACT_BA_Category_Code and DBACT_BA_Registration_Number= vendor_register_no
and company_Code = 'LE'
and vendor_code='S0006915'

select *from lnt.dbo.vendor_registration_detail where vendor_name like '%gaund%' and company_code ='LE'

select *from eip.sqlbas.BAS_D_BA_Categories