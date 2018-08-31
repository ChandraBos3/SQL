select * into #codes
from epm.sqlpmp.Gen_M_Standard_Resource a , lnt.dbo.security_user_master b 
where MSR_Inserted_On>='29-May-2017' and a.MSR_Inserted_By=b.uid and b.Company_Code='LE'
and a.MSR_Inserted_By<>200

---Total codes created by LTC

select * from #codes c where not exists (
select top 1 'x' from eip.sqlwom.WOM_H_Work_Order_Request a, eip.sqlwom.WOM_D_Work_Order_Request b
where a.HWORQ_Request_Number= b.DWORQ_Request_Number and b.DWORQ_Item_Code = c.msr_resource_code
and a.HWORQ_Company_Code=1)


select * from #codes c where not exists 
(select top 1  'x' from eip.sqlwom.WOM_H_WOA_Request a, eip.sqlwom.WOM_D_WOA_Request b
where a.HWOA_WO_Number= b.DWOA_WO_Number AND A.HWOA_Amendment_Number = B.DWOA_Amendment_Number  and b.DWOA_Item_Code = c.msr_resource_code )


---No. of workorder using these item codE

select  * FROM eip.sqlwom.WOM_H_Work_Orders a
WHERE  EXISTS ( SELECT TOP 1 'X' FROM eip.sqlwom.WOM_D_Work_Orders b, #CODES C
where HWO_WO_Number= b.DWO_WO_Number and b.DWO_Item_Code = c.msr_resource_code)

