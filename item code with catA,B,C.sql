select * from eip.sqlmas.GEN_M_Materials a,
eip.sqlmas.GEN_M_Material_Groups
where MMGRP_MG_Code = MMAT_MG_Code
and MMGRP_Company_Code = MMAT_Company_Code
and MMAT_Company_Code = 1
and MMGRP_Category_Type_Code = MMAT_Category_Type_Code
and MMGRP_Category_Type_Detail_Code = MMAT_Category_Type_Detail_Code


and MMAT_ISActive = 'y'
and len(MMAt_material_code) = 15
--and MMAT_MG_Code <> MMGRP_MG_Code
and MMAT_MG_CODE IN ('1335')
and MMAT_Category_Type_Detail_Code = 368


select * from eip.sqlscm.SCM_H_Material_Request where HMR_MR_Number='EF196EMR7000652'

--and MMGRP_MG_Code in ('6CD2')
and MMAT_Inserted_On <= '30-Aug-2017'
--(102 row(s) affected)
--commit tran


SELECT *FROM eip.sqlmas.GEN_M_Material_Groups WHERE MMGRP_MG_CODE IN ('6CD2')

SELECT *FROM EIP.SQLMAS.GEN_M_Transaction_Details WHERE MTD_Trans_Type_Code =14

select * from sys.tables where name like '%mater%'

use 
go

select * from sys.tables where name like '%const%'


drop table #temp
select mmat_material_code, mmat_mg_code, mmat_material_description,mmat_uom_code, MMAT_Category_Type_Detail_Code, MMAT_Company_Code
into #temp
 from eip.sqlmas.GEN_M_Materials 
 where MMAT_Company_Code = '1' and MMAT_ISActive = 'y' and MMAT_Category_Type_Detail_Code in ('366','367','368')

 select *from #temp
 
update #temp set mmat_material_description= replace(replace(replace(replace(replace(replace(replace(replace(replace(mmat_material_description,char(9),'-'),char(10),'-'),
     
	 DROP TABLE #TEMP2                             char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
 select MMC_Description, a.*
into #temp2
from #temp a
left join epm.sqlpmp.GEN_L_Material_Material_Category_Legacy_Mapping on (MMAT_Material_Code=LMMCLM_Material_Code and LMMCLM_Company_Code=MMAT_Company_Code and LMMCLM_Company_Code=1 )
left join epm.sqlpmp.GEN_M_Material_Category b on (LMMCLM_Material_Category_Code= MMC_Material_Category_Code and MMC_Company_Code=1)

update #temp2 set MMC_Description= replace(replace(replace(replace(replace(replace(replace(replace(replace(MMC_Description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')

update #temp2 set mmat_material_description= replace(replace(replace(replace(replace(replace(replace(replace(replace(mmat_material_description,char(9),'-'),char(10),'-'),
                                  char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),char(15),'-'),'''','-'),'"','-')
Select *from #temp2


select *from eip.sqlmas.GEN_M_Material_Groups where MMGRP_MG_Code ='1335'