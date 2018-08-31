USE EPM
GO


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

 /*

SELECT * FROM EPM.sqlpmp.PMP_T_Project_Base_Plans where TPBP_Job_Code in ('LE131182','MBBH7533','LE140014','LE140336')

SELECT * FROM EPM.sqlepm.EPM_M_Control_Master where TCM_Job_Code in ('MBBH7533','LE140014','LE140336','LE100514')

SELECT * FROM EPM.sqlepm.epm_T_project_base_plans where TPBP_Job_Code = 'LE100514'

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



--le131182	99993	3000	2015-03-01 00:00:00.000	2015-03-31 00:00:00.000
--LE140014	99993	3000	2015-02-01 00:00:00.000	2015-02-28 00:00:00.000 tagged to PMP
--LE140336	99993	3000	2015-07-01 00:00:00.000	2015-07-31 00:00:00.000 tagged to PMP
--MBBH7533	99993	3000	2015-11-01 00:00:00.000	2015-11-30 00:00:00.000 tagged to PMP
--LE100514	99993	3000	2015-07-01 23:59:59.000	2015-07-31 23:59:59.000 tagged to EPM
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
select a.job_code,performance_date,revised_contract_value from pms.dbo.job_performance a where performance_date = '31-Aug-2015' and revision_tag=1
and exists ( 
SELECT job_code from crm.dbo.invoice_valuation_sheet b where valuation_year=2015
and valuation_month = 9 and currency_tag = 'C' and job_status not in  ('B','S','M','D')
and a.job_code  = b.job_code)

select * from pms.dbo.job_performance where job_code ='LE100524' and revision_tag=1
select job_Code,reg_Code, rev_sales,rev_cost,* from crm.dbo.invoice_valuation_sheet where valuation_month = 8 and valuation_year = 2015
 and currency_tag = 'C' and job_status not in  ('B','S','M','D')

 select a.job_code, a.job_type, a.job_status,rev_sales, rev_cost, Gm,costcomppc,invcomppc,reg_code, job_description,company_code, sector_code,
 b.bu_code
  from crm.dbo.invoice_valuation_sheet a, crm.dbo.job_master b where valuation_month=9 and valuation_year=2015
 and currency_tag='C' and a.job_status not in ('B','S','M','D')
 and a.job_code =b.job_code 

 select * from crm.dbo.job_from_planning
 select * from lnt.dbo.security_user_master where uid=341935

EXEC [SQLPMP].[#LNTSP_PMP_Get_ACEJCR_RVCD_ESTIMATE_TO_COMPLETE]	@Approved= 'BLA',
@xml ='<JobList>
	<Jobs> <Job_code_List> LE131542 </Job_code_List> </Jobs> 
		</JobList>' 


EXEC [SQLPMP].[#LNTSP_PMP_Get_ACEJCR_RVCD_ESTIMATE_TO_COMPLETE]	@Approved= 'LA',@xml='<JobList>
	<Jobs> <Job_code_List> LE131542 </Job_code_List> </Jobs> 
		</JobList>' 


EXEC [SQLPMP].[#LNTSP_PMP_Get_ACEJCR_RVCD_ESTIMATE_TO_COMPLETE]	@year=2017,@Month=12
*/

Create  PROCEDURE [SQLPMP].[#LNTSP_PMP_Get_ACEJCR_RVCD_ESTIMATE_TO_COMPLETE]
(	
	@Approved		varchar(15)='LA',
	@xml			xml = null,
	@year			int = 2017,
	@Month			int = 2,
	@output			varchar(100) = null OUTPUT
)

AS

SET NOCOUNT ON

BEGIN

DECLARE @jobcode varchar(15),@bp_code int,@date datetime,
@maxcount int, @mincount int,@cur_terms int = 1

CREATE TABLE #JobList(row_id INT IDENTITY( 1, 1 ),Job_code varchar(25),bpCode int,Module varchar(15),
					 document_type varchar(15),LatestApprovedMonth datetime,REC decimal(38,2),revisedRiskProvision decimal(38,2),
					 commonEnablingCostRevised decimal(38,2),revisedEstimatedCost decimal(38,2), Riskopporprov decimal(38,2))

insert INTO #JobList(Job_code)
--SELECT item.value('(Job_code_List)[1]','varchar(15)') as Job_List             
--	FROM @xml.nodes('/JobList/Jobs') as Joblist(item) 
SELECT a.job_code from crm.dbo.invoice_valuation_sheet a, crm.dbo.job_master b where valuation_year=@year
and valuation_month = @Month and currency_tag = 'C' --and a.job_status  in  ('B') 
and a.Job_code= b.job_code and b.Company_Code='LE'
--and job_code in ( 'LE140888','LE131132','LE140038','LE150645')

update A
SET Job_code = ltrim(rtrim(A.Job_code)),
	Module = CASE WHEN TCM_EPM_Tag = 'Y' THEN 'EPM' ELSE  'PMP' END 
from #JobList A 
	join EPM.sqlepm.EPM_M_Control_Master B 
on (ltrim(rtrim(A.Job_code)) = B.TCM_Job_Code) 


if exists (select * from #JobList where Module = 'EPM')

	BEGIN	
		if (@Approved = 'LA')
		BEGIN  
	
			update J
			SET bpCode = TPBP_BP_Code,
				LatestApprovedMonth = TPBP_To_date-- CONVERT(CHAR(4), TPBP_To_date, 100) + '- ' + CONVERT(CHAR(4), TPBP_To_date, 120) 
			from #JobList j
			join epm.sqlepm.EPM_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code)					
			where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlepm.EPM_T_Project_Base_Plans s
										where j.Job_code = S.TPBP_Job_Code and 
												s.TPBP_PST_Code = 3000 AND 
												s.TPBP_DS_Code IN (2,3)) and 
			j.Module = 'EPM'
			END

			ELSE if (@Approved = 'BLA')

			BEGIN 
		
				update J
				SET bpCode = TPBP_BP_Code - 1				
				from #JobList j
				join epm.sqlepm.EPM_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code)					
				where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlepm.EPM_T_Project_Base_Plans s
				where j.Job_code = S.TPBP_Job_Code and 
						s.TPBP_PST_Code = 3000 AND 
						s.TPBP_DS_Code IN (2,3) )  and
				j.Module = 'EPM' 
		
				update J
				SET LatestApprovedMonth = TPBP_To_date 
				from epm.sqlepm.EPM_T_Project_Base_Plans p, #JobList j				
				where j.Job_code = p.TPBP_Job_Code AND 
					p.TPBP_BP_Code = j.bpCode and 
					j.module = 'EPM' 

			END

			update #JobList 
			SET  REC = tpred_cost
			FROM
			(
				select  TPRED_Job_Code,TPRED_BP_Code,sum(isnull(tpred_cost,0)) tpred_cost                       
				from #JobList A 
				join epm.sqlepm.EPM_T_PBS_Revised_Estimation_Details
				on (TPRED_Job_Code = A.Job_code and 
					TPRED_BP_Code = A.bpCode)
			    join EPM.sqlepm.EPM_T_Project_Breakdown_Structure 
				on (TPRED_Job_Code = TPBS_Job_Code and 
				    TPRED_BP_Code = TPBS_BP_Code AND 
					TPRED_PBS_Code = TPBS_PBS_Code AND 
					TPBS_ET_Code IN ('ID','WP'))
			where   A.Module = 'EPM'
			group by TPRED_Job_Code,TPRED_BP_Code
			)TBL   
			where Module = 'EPM' AND
				Job_code = TPRED_Job_Code  AND
				bpCode = TPRED_BP_Code
		

	END


if exists (select * from #JobList where Module = 'PMP')

	BEGIN
		
			if (@Approved = 'LA')
			BEGIN 
					update J
					SET bpCode = TPBP_BP_Code,
					LatestApprovedMonth = TPBP_To_date--CONVERT(CHAR(4), TPBP_To_date, 100) + '- ' + CONVERT(CHAR(4), TPBP_To_date, 120) 
					from #JobList j
					join epm.sqlpmp.PMP_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code) 							
					where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlpmp.PMP_T_Project_Base_Plans s
										where j.Job_code = S.TPBP_Job_Code AND s.TPBP_PST_Code = 3000 AND 
												s.TPBP_DS_Code IN ('BPDS0002','BPDS0003') AND s.TPBP_DS_Code IS NOT NULL) and 
					j.Module = 'PMP' 
					
						update J
					SET bpCode = TPBP_BP_Code,
					LatestApprovedMonth = TPBP_To_date--CONVERT(CHAR(4), TPBP_To_date, 100) + '- ' + CONVERT(CHAR(4), TPBP_To_date, 120) 
					from #JobList j
					join epm.sqlpmp.PMP_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code) 							
					where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlpmp.PMP_T_Project_Base_Plans s
										where j.Job_code = S.TPBP_Job_Code AND s.TPBP_PST_Code = 2000 AND 
												s.TPBP_DS_Code IN ('BPDS0002','BPDS0003') AND s.TPBP_DS_Code IS NOT NULL) and 
					j.Module = 'PMP' and bpCode is null

			END

			ELSE if (@Approved = 'BLA')

			BEGIN 
	
					update J
					SET bpCode = TPBP_BP_Code - 1				
					from #JobList j
					join epm.sqlpmp.PMP_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code) 							
					where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlpmp.PMP_T_Project_Base_Plans s
					where j.Job_code = S.TPBP_Job_Code AND s.TPBP_PST_Code = 3000 AND 
					s.TPBP_DS_Code IN ('BPDS0002','BPDS0003') AND s.TPBP_DS_Code IS NOT NULL) and 
					j.Module = 'PMP'



					update J
					SET LatestApprovedMonth = TPBP_To_date 
					from #JobList j,epm.sqlpmp.PMP_T_Project_Base_Plans p 
					where  j.Job_code = p.TPBP_Job_Code AND p.TPBP_BP_Code = j.bpCode
			END
			
			update #JobList 
					SET  revisedRiskProvision = trsed_risk_provision  
					FROM
					(
						select  TRSED_Job_Code,TRSED_BP_Code,sum(isnull(TRSED_Risk_Provision,0)) trsed_risk_provision                      
						from #JobList A 
						join SQLPMP.PMP_T_Risk_Estimation_Details
						on (TRSED_Job_Code = A.Job_code and 
							TRSED_BP_Code = A.bpCode)
					where   A.Module = 'PMP'
					group by TRSED_Job_Code,TRSED_BP_Code
					)TBL   
					where Module = 'PMP' AND
						Job_code = TRSED_Job_Code  AND
						bpCode = TRSED_BP_Code

				update #JobList 
					SET  Riskopporprov =  trsed_risk_provision  
					FROM
					(
						select  TROED_Job_Code,TROED_BP_Code,sum( isnull(TROED_Amount_Considered,0)) trsed_risk_provision                      
						from #JobList A 
						join sqlpmp.PMP_T_Risk_Opportunity_Estimation_Details
						on (TROED_Job_Code = A.Job_code and 
							TROED_BP_Code = A.bpCode)
					where   A.Module = 'PMP'
					group by TROED_Job_Code,TROED_BP_Code
					)TBL   
					where Module = 'PMP' AND
						Job_code = TROED_Job_Code  AND
						bpCode = TROED_BP_Code


	
			update #JobList 
					SET  commonEnablingCostRevised = TCECED_Cost  
					FROM
					(
						select  TCECED_Job_Code,TCECED_BP_Code,sum(isnull(TCECED_Cost,0)) TCECED_Cost                    
						from #JobList A 
						join SQLPMP.PMP_T_Common_Enabling_Cost_Estimation_Details
						on (TCECED_Job_Code = A.Job_code and 
							TCECED_BP_Code = A.bpCode)
					where   A.Module = 'PMP'
					group by TCECED_Job_Code,TCECED_BP_Code
					)TBL   
					where Module = 'PMP' AND
						Job_code = TCECED_Job_Code  AND
						bpCode = TCECED_BP_Code


			
			update #JobList 
					SET  revisedEstimatedCost = TPRE_Cost  
					FROM
					(
						select  TPRE_Job_Code,TPRE_BP_Code,sum(isnull(TPRE_Cost,0)) TPRE_Cost                    
						from #JobList A 
						join SQLPMP.PMP_T_PBS_Revised_Estimation_Details
						on (TPRE_Job_Code = A.Job_code and 
							TPRE_BP_Code = A.bpCode)
					where   A.Module = 'PMP'
					group by TPRE_Job_Code,TPRE_BP_Code
					)TBL   
					where Module = 'PMP' AND
						Job_code = TPRE_Job_Code  AND
						bpCode = TPRE_BP_Code


			update #JobList 
			SET REC =  ISNULL(commonEnablingCostRevised,0) + ISNULL(revisedEstimatedCost,0) + isnull(revisedRiskProvision,0) ---+ isnull(Riskopporprov,0)
			where Module = 'PMP'

			select * from #JobList where job_code ='LE150535'
	END

	update A 
	SET document_type = case WHEN A.bpCode <> 99992 THEN 'JCR' 
							  WHEN A.bpCode = 99992 THEN 'ACE' 
						 END,
		REC = isnull(REC,0)				
	from #JobList A 

	--if (@Approved = 'LA')

	--BEGIN 

	--	SELECT JOB_CODE,BPCODE,MODULE,DOCUMENT_TYPE,LATESTAPPROVEDMONTH,isnull(REC,0) as REC FROM #JOBLIST 
	--	WHERE BPCODE  IS NOT NULL and rec <> 0

	--END 


	--IF (@Approved = 'BLA')

	--BEGIN  


	--	SELECT JOB_CODE,BPCODE,MODULE,DOCUMENT_TYPE,LATESTAPPROVEDMONTH,isnull(REC,0) as REC FROM #JOBLIST 
	--	WHERE BPCODE  IS NOT NULL and rec <> 0 and bpCode <> 99992

	--END


	--DROP TABLE #JOBLIST 


--select * from #joblist order by rec desc
--select * from #joblist jl where bpcode is not NULL
--and not exists (
--select a.job_code, c.job_description, d.Sector_Description, e.bu_description,bpcode, module, Document_type,latestapprovedMonth,c.region_code,b.valuation_year, b.valuation_month,
--b.InvCompPC, b.CostCompPC,b.Job_Type,b.job_status,
--b.rev_sales, Rec, rev_sales-rec JCR_GM, b.JCRCostFor_AC crmendcost, b.rev_sales-b.JCRCostFor_AC CRMGM
-- from #joblist a, crm.dbo.invoice_valuation_sheet b, lnt.dbo.job_master c, lnt.dbo.sector_master d, 
--lnt.dbo.business_unit_master e
--where a.job_code = b.job_code and a.job_code = c.job_code and c.Sector_Code= d.Sector_Code and c.bu_code= e.bu_code
--and b.currency_tag='C' and module is not NULL and latestapprovedMonth is not null
--and valuation_year = @year and valuation_month = @Month
--and c.job_main_tag in ( 'O') 
--and a.job_Code = jl.job_Code)

select a.job_Code, b.region_Code, b.Sector_Code, job_description, b.bu_code,
valuation_year, valuation_month ,a.CostCompPC, a.InvCompPC,a.rev_sales PMSJCRsales, a.JCRCostFor_AC PMSjcrcost,a.rev_sales-a.JCRCostFor_AC pmsjcrgm,
isnull(a.wip_cost,0)+isnull(a.wip_rsv,0) tilldatesales, isnull(a.wip_cost,0)+isnull(a.wip_rsv,0) -isnull(a.gm,0) tilldatecost, isnull(a.gm,0) tilldatemargin,
cast(null as date) jcrmonth,
cast ( 0 as money) planjcrsales, cast ( 0 as money) planjcrcost, cast ( 0 as money) planjcrGM, cast(null as varchar(15)) LInkstatus, cast(null as varchar(15)) planmodule,
cast(0 as money) Riskopprprov, cast(0 as money) revisedRiskProvision,cast(0 as money) commonEnablingCostRevised
into #Plancrm 
from crm.dbo.invoice_valuation_sheet a, lnt.dbo.job_master b
where a.Job_code=b.job_code and a.Currency_Tag='C'
and b.company_code='LE'
and a.valuation_year=@year and a.valuation_month=@Month
and a.job_status in ('C','R')
and b.main_sub_dept ='M'


Update a set planjcrcost = rec ,planmodule = module,jcrmonth=b.LatestApprovedMonth, Riskopprprov=b.Riskopporprov,
			revisedRiskProvision = b.revisedRiskProvision,commonEnablingCostRevised = b.commonEnablingCostRevised
From #Plancrm a, #joblist b 
where a.job_code = b.job_Code

Update a set LInkstatus = 'Delink'
From #Plancrm a, crm.dbo.Job_from_Planning_NTag b 
where a.job_code = b.job_Code and b.NYear=@year and b.Nmonth=@month


Update a set LInkstatus = 'Delink'
From #Plancrm a, crm.dbo.Job_from_Planning b 
where a.job_code = b.job_Code and not exists ( select top 1 'd' from crm.dbo.Job_from_Planning_NTag c where  NYear=@year and Nmonth=@month)
and source_from_planning = 'N'

Update a set planjcrsales = revised_contract_value
from #plancrm a, lnt.dbo.job_performance b
where a.job_code = b.job_code and revision_tag =1 and month(performance_date)=@month
and year(performance_date)=@year and jcrmonth>=performance_date


Update a set planjcrsales = revised_contract_value
from #plancrm a, lnt.dbo.job_performance b
where a.job_code = b.job_code and revision_tag =1  and jcrmonth=performance_date
and planjcrsales =0

Update #plancrm set planjcrgm= planjcrsales-planjcrcost

Update #plancrm set LInkstatus = 'Delink' where costcomppc between 0 and 10 or costcomppc >90

Update a set LInkstatus = 'Delink'
from #plancrm a, finance.dbo.Region_Operating_Group_Link b
where a.region_Code = b.Region_Code and b.Operating_Group_Code='I'


select CostCompPC,InvCompPC,tilldatesales,tilldatecost, tilldatemargin, LInkstatus, job_Code, 	job_description, region_Code,	Sector_Code	,	bu_code	,
		PMSJCRsales, 	PMSjcrcost, 	pmsjcrgm, jcrmonth,	planjcrsales,	planjcrcost,	planjcrGM	,
			planmodule,isnull(Riskopprprov,0) Riskopprprov, isnull(revisedRiskProvision,0) revisedRiskProvision,
			isnull(commonEnablingCostRevised,0) commonEnablingCostRevised
from #plancrm



END 

/*



select * from lnt.dbo.job_master where job_Code in ('LE080377','LE120367','LE120380','LE140909','LE120434','LE150416','LE141064')

select * from #joblist order by rec desc
select * from #joblist jl where bpcode is not NULL
and not exists (
select a.job_code, c.job_description, d.Sector_Description, e.bu_description,bpcode, module, Document_type,latestapprovedMonth,c.region_code,b.valuation_year, b.valuation_month,
b.InvCompPC, b.CostCompPC,b.Job_Type,b.job_status,
b.rev_sales, Rec, rev_sales-rec JCR_GM, b.JCRCostFor_AC crmendcost, b.rev_sales-b.JCRCostFor_AC CRMGM
 from #joblist a, crm.dbo.invoice_valuation_sheet b, lnt.dbo.job_master c, lnt.dbo.sector_master d, 
lnt.dbo.business_unit_master e
where a.job_code = b.job_code and a.job_code = c.job_code and c.Sector_Code= d.Sector_Code and c.bu_code= e.bu_code
and b.currency_tag='C' and module is not NULL and latestapprovedMonth is not null
and valuation_year = 2016 and valuation_month = 9
and c.job_main_tag in ( 'O') 
and a.job_Code = jl.job_Code)

select * from lnt.dbo.job_master where job_Code in ('LE160044','LE131278','LE150733','LE131541')



---Jobs where approved JCR is avaialable alone are considered
--International Jobs are not included
---supply and factory jobs are excluded

--select * 
--from lnt.dbo.job_master j
--					join epm.sqlpmp.PMP_T_Project_Base_Plans p on (j.Job_code = p.TPBP_Job_Code) 							
--					where p.TPBP_To_date in (SELECT max(s.TPBP_To_date) from epm.sqlpmp.PMP_T_Project_Base_Plans s
--										where j.Job_code = S.TPBP_Job_Code AND s.TPBP_PST_Code = 3000 AND 
--												s.TPBP_DS_Code IN ('BPDS0002','BPDS0003') AND s.TPBP_DS_Code IS NOT NULL) and 
				
					

--select * from epm.sqlpmp.PMP_T_Project_Base_Plans s
--										where  s.TPBP_PST_Code = 3000 AND 
--												s.TPBP_DS_Code IN ('BPDS0002','BPDS0003')

select tpbp_job_code,sector_description,case when a.TPBP_PST_Code=2000 then 'ACE' Else 'JCR' End,max(a.TPBP_To_Date) ,TCM_EPM_Tag, b.job_operating_group,region_Code
from epm.sqlpmp.PMP_T_Project_Base_Plans a, lnt.dbo.job_master b, lnt.dbo.sector_master c,EPM.sqlepm.EPM_M_Control_Master p
where TPBP_Job_Code = b.job_Code 
and b.sector_code = c.sector_code
and b.company_code = 'LE' and ltrim(rtrim(b.Job_code)) = p.TCM_Job_Code
and tpbp_ds_code in ( 'BPDS0003','BPDS0002')
and b.region_code not in ( 'O','BO','IO','MO','TO','WO')
and TCM_EPM_Tag <> 'Y'  and b.job_status='B'
--and a.TPBP_PST_Code=3000 
--and b.job_code='LE150232'
group by tpbp_job_code,a.TPBP_PST_Code,sector_description,TCM_EPM_Tag,job_operating_group,b.region_code

select * from epm.sqlpmp.PMP_T_Project_Base_Plans where TPBP_Job_Code='LE141170'

select * from crm.dbo.Job_master where job_code in (
'LE131278',
'LE140895',
'LE141170',
'LE150226',
'LE160009',
'LE160044',
'CUHS6567')
and valuation_year =2016 and valuation_month=9


select * from crm.dbo.Invoice_Valuation_Sheet where job_code = 'LE160210' and valuation_year=2016
and valuation_month=8


*/













