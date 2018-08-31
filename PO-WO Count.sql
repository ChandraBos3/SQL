use eip
go
select  b.Sector_Code,case when hwo_wo_amount <=  200000 then 'Less than   2.0  L' 
                                         when hwo_wo_amount <= 500000 then 'Less than  5  L' 
										 when hwo_wo_amount <= 5000000 then 'Less than  50.0  L' 
                                         when hwo_wo_amount <= 7500000 then 'Less than  75.0  L'
                                         when hwo_wo_amount <= 10000000 then 'Less than  1.0  Cr'
                                         when hwo_wo_amount <= 25000000 then 'Less than  2.5  Cr'
                                         when hwo_wo_amount <= 50000000 then 'Less than  5.0  Cr'
                                         when hwo_wo_amount <= 100000000 then 'Lessthan 10.0  Cr'
                                         else 'Above 10.0 cr' END category,
count(a.HWO_WO_Number) wocount, sum(a.HWO_WO_Amount) wovalue
from eip.sqlwom.WOM_H_Work_Orders a, lnt.dbo.job_master b
where HWO_Job_Code= b.job_code and a.HWO_Currency_Code=72
and b.company_code='LE' --and b.SBG_Code='RBF'
and a.HWO_DS_Code in ( 3)
and a.HWO_WO_Date between '01-Jul-2017' and '31-Jul-2017'
group by  b.Sector_Code,case when hwo_wo_amount <=  200000 then 'Less than   2.0  L' 
                                         when hwo_wo_amount <= 500000 then 'Less than  5  L' 
										 when hwo_wo_amount <= 5000000 then 'Less than  50.0  L' 
                                         when hwo_wo_amount <= 7500000 then 'Less than  75.0  L'
                                         when hwo_wo_amount <= 10000000 then 'Less than  1.0  Cr'
                                         when hwo_wo_amount <= 25000000 then 'Less than  2.5  Cr'
                                         when hwo_wo_amount <= 50000000 then 'Less than  5.0  Cr'
                                         when hwo_wo_amount <= 100000000 then 'Lessthan 10.0  Cr'
                                         else 'Above 10.0 cr' END


select  b.Sector_Code,case when a.HPO_PO_Net_Value <=  200000 then 'Less than   2.0  L' 
                                         when HPO_PO_Net_Value <= 500000 then 'Less than  5.0  L' 
										 when HPO_PO_Net_Value <= 5000000 then 'Less than  50.0  L' 
                                         when HPO_PO_Net_Value <= 7500000 then 'Less than  75.0  L'
                                         when HPO_PO_Net_Value <= 10000000 then 'Less than  1.0  Cr'
                                         when HPO_PO_Net_Value <= 25000000 then 'Less than  2.5  Cr'
                                         when HPO_PO_Net_Value <= 50000000 then 'Less than  5.0  Cr'
                                         when HPO_PO_Net_Value <= 100000000 then 'Lessthan 10.0  Cr'
                                         else 'Above 10.0 cr' END category,
count(a.HPO_PO_Number) pocount, sum(a.HPO_PO_Net_Value) povalue
from eip.sqlscm.SCM_H_Purchase_Orders a, lnt.dbo.job_master b
where a.HPO_Job_Code= b.job_code and a.HPO_Currency_Code=72
and b.company_code='LE' --and b.SBG_Code='RBF'
and a.HPO_PO_Date between '01-Jul-2017' and '31-Jul-2017'
and a.HPO_DS_Code=3
group by  b.Sector_Code,case when HPO_PO_Net_Value <=  200000 then 'Less than   2.0  L' 
                                         when HPO_PO_Net_Value <= 500000 then 'Less than  5.0  L'  
										 when HPO_PO_Net_Value <= 5000000 then 'Less than  50.0  L' 
                                         when HPO_PO_Net_Value <= 7500000 then 'Less than  75.0  L'
                                         when HPO_PO_Net_Value <= 10000000 then 'Less than  1.0  Cr'
                                         when HPO_PO_Net_Value <= 25000000 then 'Less than  2.5  Cr'
                                         when HPO_PO_Net_Value <= 50000000 then 'Less than  5.0  Cr'
                                         when HPO_PO_Net_Value <= 100000000 then 'Lessthan 10.0  Cr'
                                         else 'Above 10.0 cr' END 
