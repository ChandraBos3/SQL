use lnt
go

select *from lnt.dbo.vendor_registration_detail where supplier ='Y' 

select *from lnt.dbo.Vendor_Branch

select approved_date,vendor_code,vendor_name,vendor_category_1, vendor_category_2, vendor_category_3,product_details from lnt.dbo.vendor_registration_detail where supplier ='Y'

select approved_date,vendor_code,vendor_name,subcontractor_type,product_details from lnt.dbo.vendor_registration_detail where subcontractor ='Y'

SELECT *FROM eip.sqlmas.GEN_U_Unit_Of_Measurement

use eip
go

select *from sys.tables where name like '%material%category%'

use EIP
go

select *from eip.sqlmas.GEN_L_FR_Material_Category


select *from epm.sqlpmp.GEN_M_Material_Category