use eip
go


/*  
--30 Days
#lntsp_warehouse_nonmoving_stock_list @from_item='100000000', @to_item='9ZZZZZZZZ',@IC_Code='0', @company_code=1,
@uid=525, @to_date = '31-Jan-2018', @NoofDays = 999

--,@warehouse_code='C04861', 

--60 Days
#lntsp_warehouse_nonmoving_stock_list @from_item='900000000', @to_item='9ZZZZZZZZ',@IC_Code='3', @company_code=1,
@uid=525, @to_date = '30-jun-2017', @NoofDays = 60 --,@warehouse_code='C04861', 
 
 --90 Days
 #lntsp_warehouse_nonmoving_stock_list @from_item='900000000', @to_item='9ZZZZZZZZ',@IC_Code='0', @company_code=1,
@uid=525, @to_date = '30-jun-2017', @NoofDays = 90 --,@warehouse_code='C04861

 --180 Days
 #lntsp_warehouse_nonmoving_stock_list @from_item='900000000', @to_item='9ZZZZZZZZ',@IC_Code='3', @company_code=1,
@uid=525,@from_date = '01-Oct-2016' ,@to_date = '30-jun-2017'--,@warehouse_code='C04861', 

 --More Than 180 Days
 #lntsp_warehouse_nonmoving_stock_list @from_item='900000000', @to_item='9ZZZZZZZZ',@IC_Code='3', @company_code=1,
@uid=525,@from_date = '01-Apr-2014' ,@to_date = '30-jun-2017'--,@warehouse_code='C04861', 

select top 10 * from sqlmas.gen_m_cluster_element_Details where mcled_company_code = 1 and mcled_ce_code= 2 and mcled_isactive = 'Y'

lntsp_warehouse_nonmoving_stock_list @warehouse_code= '', @from_item = '100000000', @to_item = '999999999', @from_date = '11/4/2016', @to_date= '2/2/2017', @region_code = 'BF', @job_code= '', @class_code = '(ALL)',
@uid=523
lntsp_warehouse_nonmoving_stock_list @warehouse_code= '', @from_item = '100000000', @to_item = '999999999', @from_date = '11/4/2016', @to_date= '2/2/2017', @region_code = 'BF', @job_code= '', @class_code = '(ALL)'
,@uid=523

lntsp_warehouse_nonmoving_stock_list @from_item='100000000', @to_item='199999999',
@NoofDays=90, @uid = 523,@job_code='MBBH7533',
@to_date='24-Apr-2017', @company_code='1'

*/  
  
create PROCEDURE #lntsp_warehouse_nonmoving_stock_list  
(    
 @job_code  varchar(15)=NULL,  
 @warehouse_code varchar(15)='0',  
 @from_item  varchar(15),  
 @to_item  varchar(15),  
 @from_date      datetime = NULL,  
 @to_date       datetime,  -- Current Date
 @class_code  varchar(15)=NULL,  
 @uid int ,
 @NoofDays int = NULL,
 @IC_Code varchar(15) = '0',
 @BU_Code varchar(15) = '0',
 @Cluster_Code varchar(15) = '0',
 @company_code int
  
)  
  
AS  
/*  
   Created  By: P.Chokkalingam On 04 Oct 2016
   Purpose  : getdate() is validating with fromdate codition is removed in SP.

  */  
  
  SET NOCOUNT ON  
  
 Declare @month int,@year int  
 set @month = month(@from_date)                            
 set @year = year(@to_date)   
  
SET @from_date = DATEADD(d,-@NoofDays,GETDATE())

if (UPPER(@job_code)='(ALL)' or RTRIM(ltrim(@job_code))='')
	set @job_code= Null
if (UPPER(@warehouse_code)='0' or RTRIM(ltrim(@warehouse_code))='')
	set @warehouse_code= Null

--if (UPPER(@region_code)='(ALL)' or RTRIM(ltrim(@region_code))='')
--	set @region_code= Null
   
-- If (upper(@class_code)='(ALL)' or LEN(@class_code)=0)          
-- set @class_code=null    
   

Create Table #security_user_job_link     
		( Userid int,               
		Job_code varchar(15))

--insert into  #security_user_job_link(Userid,Job_code)        
-- Exec accesscontrol.dbo.lntsp_security_access_list @Uid = @uid, @role_id='rgecc', @cluster_desc='Job', @cluster_list=3 

  
 Declare @Company_Currency Varchar(15), @currency_Description varchar(15)
 
 Declare @New_Warehouse_Code int     
 

  CREATE TABLE #temp_online_stock  
  (  
  stock_type   varchar(15),  
  stock_Description Varchar(200),
  job_code  varchar(15),
  job_description vARCHAR(250) , 
  warehouse_code varchar(15),  
  material_code   varchar(15),  
  material_name  varchar(500),  
  uom_description  varchar(50),  
  quantity   money,  
  amount   money,
  MRN_Qty Money, 
  MRN_Value Money, 
  DC_Qty  Money, 
  DC_Value Money,  
  IJSTN_qty Money, 
  IJSTN_Value Money,
  IC_Description Varchar(200),
  BU_Description Varchar(200),
  Cluster_Description Varchar(200),
  Currency_code Varchar(50),
  Surplus_qty Money)   

   INSERT INTO #temp_online_stock (stock_type,  
           job_code,  
           warehouse_code,  
           material_code,  
           material_name,  
           uom_description,
		   job_description,  
           quantity,  
           amount )  
   SELECT wo.TWHS_Stock_Detail_Code as stock_type,  
       wo.TWHS_Job_Code as job_code,  
       wo.TWHS_Warehouse_Code as warehouse_code,  
       wo.TWHS_Material_Code as material_code,  
       mm.MMAT_Material_Description as material_name,  
       um.UUOM_Description as uom_description, 
	   jm.MJOB_Description as job_description, 
       wo.TWHS_Qty as quantity,  
       wo.TWHS_Value as amount   
   FROM eip.SQLSCM.SCM_T_Warehouse_Stock wo  
     inner Join eip.SQLMAS.GEN_M_Materials mm on (wo.TWHS_Material_Code = mm.MMAT_Material_Code and TWHS_Company_Code=MMAT_Company_Code)  
     inner Join eip.SQLMAS.GEN_U_Unit_Of_Measurement  um on (mm.MMAT_UOM_Code = um.UUOM_UOM_Code)  
     Inner JOIN eip.SQLMAS.GEN_M_Jobs  jm on (MJOB_Job_Code = wo.TWHS_Job_Code)
	 Inner JOIN eip.SQLMAS.GEN_L_Job_Cluster_Elements  ON (LJCE_Job_Code = wo.TWHS_Job_Code  )
	 Inner JOIN eip.SQLMAS.GEN_M_Cluster_Element_Details IC  ON (IC.MCLED_CED_Code=LJCE_IC_Code 
																	AND IC.MCLED_CE_Code=2 
																	AND IC.MCLED_Company_Code = @company_code )
	 Inner JOIN eip.SQLMAS.GEN_M_Cluster_Element_Details BU ON (BU.MCLED_CED_Code=LJCE_bu_Code AND BU.MCLED_CE_Code=4
																	AND BU.MCLED_Company_Code = @company_code)
	 Inner JOIN eip.SQLMAS.GEN_M_Cluster_Element_Details Cluster ON (Cluster.MCLED_CED_Code= LJCE_Cluster_Office_Code 
																		AND Cluster.MCLED_CE_Code=6
																		AND BU.MCLED_Company_Code = @company_code)
   WHERE TWHS_Stock_Type_Code= 4 and TWHS_Stock_Detail_Code in (11,19)  
    and TWHS_Company_Code=@company_code   
	AND (@IC_Code = '0' OR  LJCE_IC_Code = @IC_Code)
	AND (@BU_Code = '0' OR LJCE_BU_Code = @BU_Code)
	AND (@Cluster_Code = '0' OR LJCE_Cluster_Office_Code = @Cluster_Code)              
   	AND (( @job_code  IS NULL)  OR  ( wo.TWHS_Job_Code = @job_code ))
	AND (( @warehouse_code IS null)  OR  ( wo.TWHS_Warehouse_Code = @warehouse_code ))     
    And wo.TWHS_Material_Code between @from_item AND  @to_item  
	and wo.TWHS_Qty > 0
																			 
  

 -- print @company_code
  /*Issue*/	
		Select HISS_Job_Code, HISS_Warehouse_Code,DISS_Stock_Detail_Code, DISS_Material_Code, SUM(DISS_Qty) DISS_Qty, SUM(DISS_Value) DISS_Value
			into #Non_Moving_stock_Issue
		From eip.sqlscm.SCM_H_Issue,
			 eip.SQLSCM.SCM_D_Issue
		where HISS_Issue_Number = DISS_Issue_Number
			and HISS_Date between @from_date and @to_date
			AND HISS_Company_Code = @company_code
			and DISS_Material_Code between @from_item AND  @to_item
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock WHERE Job_Code = HISS_Job_Code
																		AND Warehouse_code = HISS_Warehouse_Code
																		AND Material_code = DISS_Material_Code
																		AND DISS_Stock_type_Code = 4
																		AND Stock_type = DISS_Stock_Detail_Code)
		group BY HISS_Job_Code, HISS_Warehouse_Code,DISS_Stock_Detail_Code, DISS_Material_Code


		Delete FROM #temp_online_stock
		where EXISTS (SELECT TOP 1 'x' from #Non_Moving_stock_Issue where Job_Code = HISS_Job_Code AND  
																			Warehouse_Code = HISS_Warehouse_Code AND
																			stock_type =DISS_Stock_Detail_Code and 
																			Material_Code = DISS_Material_Code)
	
	/*MRN*/
		SELECT HMRN_Job_Code, HMRN_Warehouse_Code, DMRN_Material_Code, HMRN_Stock_Detail_Code, SUM(DMRN_Accepted_Qty) DMRN_Accepted_Qty, 
			SUM(DMRN_Native_Currency_Material_Value)DMRN_Native_Currency_Material_Value 		
			into #temp_MRN_detail_Non_moving
		FROM eip.SQLSCM.SCM_H_MRN
		INNER JOIN eip.SQLSCM.SCM_D_MRN ON (HMRN_MRN_Number = DMRN_MRN_Number 
														AND HMRN_Company_Code = @COMPANY_CODE)
		WHERE
			 HMRN_MRN_Date between @from_date and @to_date
			 and DMRN_Material_Code  between @from_item AND  @to_item 
			 and HMRN_Company_Code = @company_code
			 AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock WHERE Job_Code = HMRN_Job_Code
																		AND Warehouse_code = HMRN_Warehouse_Code
																		AND Material_code = DMRN_Material_Code
																		AND HMRN_Stock_type_Code = 4
																		AND Stock_type = HMRN_Stock_Detail_Code)
		group BY HMRN_Job_Code, HMRN_Warehouse_Code, DMRN_Material_Code, HMRN_Stock_Detail_Code

	/*DC*/
		select HDC_Job_Code, HDC_Warehouse_Code, DDC_Material_Code, HDC_Stock_Detail_Code, SUM(DDC_Qty) DDC_Qty, sum(DDC_Value) DDC_Value
		into #temp_DC_detail_Non_moving
		from eip.SQLSCM.SCM_H_DC,
			eip.SQLSCM.SCM_D_DC
		where HDC_DC_Number = DDC_DC_Number
			and HDC_Date between @from_date and @to_date
			and DDC_Material_Code  between @from_item AND  @to_item  
			and HDC_Company_Code = @COMPANY_CODE
			and HDC_DS_Code <> 8
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock WHERE Job_Code = HDC_Job_Code
																		AND Warehouse_code = HDC_Warehouse_Code
																		AND Material_code = DDC_Material_Code
																		AND HDC_Stock_Type_Code = 4
																		AND Stock_type = HDC_Stock_Detail_Code)
		
		group BY HDC_Job_Code, HDC_Warehouse_Code, DDC_Material_Code, HDC_Stock_Detail_Code

	/*IJSTN*/
		SELECT HIJST_From_Job_Code, HIJST_From_Warehouse_Code, DIJST_Material_Code, HIJST_From_Stock_Type_Detail_Code, 
			SUM(DIJST_Quantity) DIJST_Quantity, SUM(DIJST_Material_Value) DIJST_Material_Value
		into #temp_IJSTN_detail_Non_moving
		FROM eip.sqlscm.SCM_H_Inter_Job_Stock_Transfer_Note,
			 eip.SQLSCM.SCM_D_Inter_Job_Stock_Transfer_Note
		where HIJST_IJSTN_Number = DIJST_IJSTN_Number
			and HIJST_IJSTN_Date between @from_date and @to_date
			and DIJST_Material_Code  between @from_item AND  @to_item 
			and HIJST_Company_Code =  @COMPANY_CODE 
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock WHERE Job_Code = HIJST_From_Job_Code
																			AND Warehouse_code = HIJST_From_Warehouse_Code
																			AND Material_code = DIJST_Material_Code
																			AND HIJST_From_Stock_Type_Code = 4
																			AND Stock_type = HIJST_From_Stock_Type_Detail_Code)
		group by HIJST_From_Job_Code, HIJST_From_Warehouse_Code, DIJST_Material_Code, HIJST_From_Stock_Type_Detail_Code

	/*MRN Update*/
		update #temp_online_stock
			SET MRN_Qty = DMRN_Accepted_Qty,
				MRN_Value = DMRN_Native_Currency_Material_Value
		from #temp_MRN_detail_Non_moving mrn
		where Job_Code = mrn.HMRN_Job_Code
			and Warehouse_code = mrn.HMRN_Warehouse_Code
			and Stock_type = mrn.HMRN_Stock_Detail_Code
			and Material_code = mrn.DMRN_Material_Code
	
	/*DC Update*/
		Update #temp_online_stock
			SET DC_Qty = DDC_Qty,
				DC_Value = DDC_Value
		from #temp_DC_detail_Non_moving
		where Job_Code = HDC_Job_Code
		and Warehouse_code = HDC_Warehouse_Code
		and Stock_type = HDC_Stock_Detail_Code
		and Material_code = DDC_Material_Code

	/*IJSTN Update*/
		Update #temp_online_stock
			SET IJSTN_qty = DIJST_Quantity,
				IJSTN_Value = DIJST_Material_Value
		From #temp_IJSTN_detail_Non_moving
			where Job_Code = HIJST_From_Job_Code
				and Warehouse_code = HIJST_From_Warehouse_Code
				and Material_code = DIJST_Material_Code
				and Stock_type = HIJST_From_Stock_Type_Detail_Code
	/*Master Data*/
		update #temp_online_stock 
			SET stock_Description = MTD_Trans_Type_Desc
		from EIP.SQLmas.GEN_M_Transaction_Details
		where stock_type = MTD_Trans_Detail_Code
			and MTD_Trans_Type_Code = 4
		
		update #temp_online_stock SET IC_Description = MCLED_Description
		from eip.SQLmas.GEN_L_Job_Cluster_Elements,
		SQLMAS.GEN_M_Cluster_Element_Details
		where job_code = LJCE_Job_Code
		and LJCE_IC_Code = MCLED_CED_Code
		and LJCE_Company_Code = MCLED_Company_Code
		and MCLED_Company_Code = @company_code

		update #temp_online_stock SET BU_Description = MCLED_Description
		from eip. SQLmas.GEN_L_Job_Cluster_Elements,
		eip.SQLMAS.GEN_M_Cluster_Element_Details
		where job_code = LJCE_Job_Code
		and LJCE_BU_Code = MCLED_CED_Code
		and LJCE_Company_Code = MCLED_Company_Code
		and MCLED_Company_Code = @company_code

		update #temp_online_stock SET Cluster_Description = MCLED_Description
		from eip.SQLmas.GEN_L_Job_Cluster_Elements,
		eip.SQLMAS.GEN_M_Cluster_Element_Details
		where job_code = LJCE_Job_Code
		and LJCE_Cluster_Office_Code = MCLED_CED_Code
		and LJCE_Company_Code = MCLED_Company_Code
		and MCLED_Company_Code = @company_code

		update #temp_online_stock SET Currency_code = MCUR_Short_Description
		from eip.SQLMAS.GEN_L_Job_Currency,
		eip.SQLMAS.GEN_M_Currencies
		where job_code = LJCUR_Job_Code
		and MCUR_Currency_Code = LJCUR_Currency_Code
		and LJCUR_Currency_Type_Code = 1

		update #temp_online_stock SET Surplus_qty = isnull(TSURS_Surplus_Quantity,0)
		from eip.SQLSCM.SCM_T_Surplus_Stock
		where 
			TSURS_Company_Code = @company_code
			and TSURS_Job_Code = job_code
			and TSURS_Warehouse_Code = warehouse_code
			and TSURS_Material_Code = material_code
			and TSURS_Stock_Type_Code = 4
			and TSURS_Stock_Type_Detail_Code = stock_type

 SELECT  tos.stock_type+' - '+ tos.stock_Description stock_type,  
   tos.job_code,  
   tos.warehouse_code,  
   tos.material_code,  
   tos.material_name,  
   tos.uom_description,  
   job_description,   
   (quantity-(isnull(MRN_Qty,0) + ISNULL(IJSTN_qty,0))) quantity,   
   (amount-( isnull(MRN_Value,0) + Isnull(IJSTN_Value,0)))amount,  
   Currency_code as Company_Currency,
   Currency_code as Currency_Description,
   tos.IC_Description,
   tos.BU_Description,
   tos.Cluster_Description,
   isnull(tos.Surplus_qty,0)Surplus_qty
  FROM  #temp_online_stock  tos 
	-- left Join #security_user_job_link t on (tos.job_code = t.job_code)	
			where  (quantity-(isnull(MRN_Qty,0) + ISNULL(IJSTN_qty,0))) > 0	
   ORDER BY  tos.job_code, tos.material_code  
    
	DROP table #temp_online_stock
	DROP TABLE #temp_MRN_detail_Non_moving
	DROP TABLE #temp_DC_detail_Non_moving
	DROP table #temp_IJSTN_detail_Non_moving

  RETURN  








;

