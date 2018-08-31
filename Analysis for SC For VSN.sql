---Resource type code = ‘SCPL for subcontract items, ‘MATRL’ – for Material items

---

---total item code request approved and available – count based on 9 digit codes
use EIP
GO

select username,msr_attribute_combination_value, count(msr_scope_value)
from epm.sqlpmp.Gen_M_Standard_Resource a, lnt.dbo.security_user_master b
where msr_resource_type_code='SCPL'
and msr_attribute_combination_value is not NULL
and a.msr_inserted_by = b.uid
and b.company_code='LE'
group  by username,msr_attribute_combination_value
order by 1

---total request

select MSRR_Resource_Request_Number,MSRR_Requested_By, MSRR_Requested_On, msrr_inserted_by, cast(null as varchar(100)) , MSRR_Inserted_On, msrr_approved_by, msrr_approved_on,c.MSR_Attribute_Combination_Value,
a.MSR_Resource_Code,e.MIGRP_Description category, case when MSRR_Status in ('SRAS0004','SRAS0003') then 'Rejected' 
                                         when MSRR_Status='SRAS0001' then 'Created'
                                         when msrr_Status ='SRAS0002' then 'Authorised'
                                         Else 'Others'
                                  End Status
								  ,MSRR_Status
								  ,MSRJR_Job_Code, MSRJR_IC_Code, MSRJR_Inserted_On
								  ,MSR_Standardized_Description
from epm.sqlpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b
,epm.sqlpmp.Gen_M_Standard_Resource_Job_Request
,epm.sqlpmp.Gen_M_Standard_Resource c
,epm.sqlpmp.GEN_M_Item_Groups e

where a.msrr_inserted_by= b.uid and b.company_code='LE' 
and c.MSR_Resource_Code=a.MSR_Resource_Code

and a.MSRR_Inserted_On between '29-May-2017' and '25-Oct-2017'
and MSRJR_Resource_Request_Code=MSRR_Resource_Request_Number 
and MSRJR_Resource_Type_Code = MSRR_Resource_Type_Code
AND MSRJR_Resource_Type_Code='scpl'
and MSRJR_Resource_Type_Code = MSR_Resource_Type_Code
and e.MIGRP_Item_Group_Code = left(MSR_Attribute_Combination_Value,4) 
--and c.MSR_Standardized_description like '%as%described%further%'
--and MSRR_Status ='SRAS0004'
SELECT *from epm.sqlpmp.Gen_M_Standard_Resource_Request where MSRR_Resource_Request_Number = '7989'

SELECT *from epm.sqlpmp.Gen_M_Standard_Resource_Job_Request where MSRJR_Resource_Request_Code = '7989'

--and MSRR_Status ='SRAS0004'



--used in WO
drop table #newtab
select MSRR_Resource_Request_Number,MSRR_Requested_By, MSRR_Requested_On, msrr_inserted_by, cast(null as varchar(100)) C, MSRR_Inserted_On, msrr_approved_by, msrr_approved_on,
a.MSR_Resource_Code, case when MSRR_Status in ('SRAS0004','SRAS0003') then 'Rejected' 
                                         when MSRR_Status='SRAS0001' then 'Created'
                                         when msrr_Status ='SRAS0002' then 'Authorised'
                                         Else 'Others'
                                  End Status,MSRR_Status, MSRJR_Job_Code, MSRJR_IC_Code, MSR_Standardized_Description
into #newtab from epm.sqlpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,epm.sqlpmp.Gen_M_Standard_Resource c , epm.sqlpmp.Gen_M_Standard_Resource_Job_Request
where a.msrr_inserted_by= b.uid and b.company_code='LE' and c.MSR_Resource_Code=a.MSR_Resource_Code and msr_resource_type_code='SCPL'
and a.MSRR_Inserted_On between '29-May-2017' and '13-Sep-2017'
and not EXISTS ( select top 1'x' from eip.sqlwom.WOM_H_Work_Order_Request h, eip.sqlwom.WOM_D_Work_Order_Request d
where h.hworq_request_number = dworq_request_number and a.MSR_Resource_Code = dworq_item_code and HWORQ_Company_Code=1 )
and MSRJR_Resource_Request_Code=MSRR_Resource_Request_Number and MSRJR_Resource_Type_Code = MSR_Resource_Type_Code
--and MSRR_Status ='SRAS0004'

select *from #newtab

SELECT * FROM EIP.SQLMAS.GEN_M_Major_Material_Groups WHERE MMMG_Company_Code=1

select * from epm.sqlpmp.Gen_M_Standard_Resource

drop table #newtab1
select MSRR_Resource_Request_Number,MSRR_Requested_By, MSRR_Requested_On, msrr_inserted_by, cast(null as varchar(100)) C, MSRR_Inserted_On, msrr_approved_by, msrr_approved_on,
a.MSR_Resource_Code, case when MSRR_Status in ('SRAS0004','SRAS0003') then 'Rejected' 
                                         when MSRR_Status='SRAS0001' then 'Created'
                                         when msrr_Status ='SRAS0002' then 'Authorised'
                                         Else 'Others'
                                  End Status,MSRR_Status, MSRJR_Job_Code, MSRJR_IC_Code,MSR_Standardized_Description
into #newtab1 from epm.sqlpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b ,epm.sqlpmp.Gen_M_Standard_Resource c,epm.sqlpmp.Gen_M_Standard_Resource_Job_Request
where a.msrr_inserted_by= b.uid and b.company_code='LE' and c.MSR_Resource_Code=a.MSR_Resource_Code and msr_resource_type_code='SCPL'
and a.MSRR_Inserted_On between '29-May-2017' and '28-Sep-2017'
and EXISTS ( select top 1'x' from eip.sqlwom.WOM_H_WOA_Request h, eip.sqlwom.WOM_D_WOA_Request d
where h.HWOA_WO_Number = DWOA_WO_Number and  h.hwoa_amendment_number = DWOA_Amendment_Number and DWOA_Item_Code = a.MSR_Resource_Code)
and MSRJR_Resource_Request_Code=MSRR_Resource_Request_Number and MSRJR_Resource_Type_Code = MSR_Resource_Type_Code
--and MSRR_Status ='SRAS0004'

select *from #newtab1
---new codes created but used in new WOR

select *from eip.sqlwom.WOM_H_WOA_Request

select username,msr_attribute_combination_value, count(msr_scope_value)
from epm.sqlpmp.Gen_M_Standard_Resource a, lnt.dbo.security_user_master b
where msr_resource_type_code='SCPL'
and msr_attribute_combination_value is not NULL
and a.msr_inserted_by = b.uid
and b.company_code='LE'
and not exists  ( select top 1'x' from eip.sqlwom.WOM_H_Work_Order_Request h, eip.sqlwom.WOM_D_Work_Order_Request d
where h.hworq_request_number = dworq_request_number and msr_resource_code = dworq_item_code)
group  by username,msr_attribute_combination_value

-- 15 digit code


select username,a.msr_resource_code, count(MSR_Resource_Code)
from epm.sqlpmp.Gen_M_Standard_Resource a, lnt.dbo.security_user_master b
where msr_resource_type_code='SCPL'
and msr_attribute_combination_value is not NULL
and a.msr_inserted_by = b.uid
and b.company_code='LE'
and exists  ( select top 1'x' from eip.sqlwom.WOM_H_Work_Order_Request h, eip.sqlwom.WOM_D_Work_Order_Request d
where h.hworq_request_number = dworq_request_number and msr_resource_code = dworq_item_code)
group  by username,MSR_Resource_Code

---new codes created but used in new Amendments

select username,msr_attribute_combination_value, count(msr_scope_value),MSR_Resource_Code
from epm.sqlpmp.Gen_M_Standard_Resource a, lnt.dbo.security_user_master b
where msr_resource_type_code='SCPL'
and msr_attribute_combination_value is not NULL
and a.msr_inserted_by = b.uid
and b.company_code='LE'
and exists  ( select top 1'x' from eip.sqlwom.WOM_H_WOA_Request h, eip.sqlwom.WOM_D_WOA_Request d
where h.HWOA_WO_Number = DWOA_WO_Number and  h.hwoa_amendment_number = DWOA_Amendment_Number and DWOA_Item_Code = msr_resource_code)
group  by username,msr_attribute_combination_value

-- 15 digit code
select username,MSR_Resource_Code, count(MSR_Resource_Code)
from epm.sqlpmp.Gen_M_Standard_Resource a, lnt.dbo.security_user_master b
where msr_resource_type_code='SCPL'
and msr_attribute_combination_value is not NULL
and a.msr_inserted_by = b.uid
and b.company_code='LE'
and exists  ( select top 1'x' from eip.sqlwom.WOM_H_WOA_Request h, eip.sqlwom.WOM_D_WOA_Request d
where h.HWOA_WO_Number = DWOA_WO_Number and  h.hwoa_amendment_number = DWOA_Amendment_Number and DWOA_Item_Code = msr_resource_code)
group  by username,MSR_Resource_Code

use epm
go

select *from sys.tables where name like '%group%'


select *from eip.sqlwom.WOM_H_WOA_Request
select *from eip.sqlwom.WOM_D_WOA_Request


----total request old format
use EIP
GO



---total request

select MSRR_Resource_Request_Number,MSRR_Requested_By, MSRR_Requested_On, msrr_inserted_by, cast(null as varchar(100)), MSRR_Inserted_On, msrr_approved_by, msrr_approved_on,
msr_resource_code,MSRJR_IC_Code,MSRJR_Job_Code, case when MSRR_Status in ('SRAS0004','SRAS0003') then 'Rejected' 
                                         when MSRR_Status='SRAS0001' then 'Created'
                                         when msrr_Status ='SRAS0002' then 'Authorised'
                                         Else 'Others'
                                  End Status 
from epm.sqlpmp.Gen_M_Standard_Resource_Request a, lnt.dbo.security_user_master b, epm.sqlpmp.Gen_M_Standard_Resource_Job_Request
where a.msrr_inserted_by= b.uid and b.company_code='LE'
and MSRJR_Resource_Request_Code=MSRR_Resource_Request_Number 
and MSRJR_Resource_Type_Code = MSRR_Resource_Type_Code
AND MSRJR_Resource_Type_Code='scpl'
and a.MSRR_Approved_On between '29-May-2017' and '28-Sep-2017'
