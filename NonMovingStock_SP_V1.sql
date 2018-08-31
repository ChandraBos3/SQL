select * from epm.sqlepm.epm_m_control_master

select * from epm.sqlpmp.PMP_T_Master_Controller


select TWHCS_Job_Code, TWHCS_Material_Code,TWHCS_Qty, count(TWHCS_Stock_Month)---TWHCS_Last_PO_Code , TWHCS_Stock_Year, TWHCS_Stock_Month
 from eip.sqlscm.SCM_T_Warehouse_Closing_Stock where TWHCS_Company_Code=1
 and TWHCS_Stock_Detail_Code=11
 group by TWHCS_Job_Code, TWHCS_Material_Code,TWHCS_Qty
 having count(TWHCS_Stock_Month) > 3
 
 select *from eip.SQLSCM.SCM_T_Warehouse_Stock 
where TWHS_MATERIAL_CODE = '9a1215193' 
AND TWHS_COMPANY_CODE ='1'  and TWHS_Stock_Detail_Code in ('11','13') AND TWHS_JOB_CODE = 'LE150033'



 select * from eip.sqlscm.SCM_H_Issue , eip.sqlscm.SCM_D_Issue b
 where HISS_Issue_Number = DISS_Issue_Number
 and HISS_Company_Code=1 and DISS_Debit_Job_Code='YGPAM038'
 and DISS_Material_Code='9n1d10707' 

 

 SELECT *FROM eip.sqlscm.SCM_D_MRN a, eip.sqlscm.SCM_H_MRN b
 WHERE hmrn_mrn_number = DMRN_MRN_Number 
 and HMRN_Company_Code=1 and HMRN_Job_Code='LE150033'
 and DMRN_Material_Code= '9a1215193'

 SELECT *FROM eip.sqlscm.SCM_H_Inter_Job_Stock_Transfer_Note,
			 eip.SQLSCM.SCM_D_Inter_Job_Stock_Transfer_Note
			 WHERE HIJST_IJSTN_Number = DIJST_IJSTN_Number

					and DIJST_Material_Code='9CL210186' AND HIJST_From_Job_Code = 'LE130822'
			and HIJST_Company_Code =1



 select * from eip.sqlscm.SCM_H_Issue , eip.sqlscm.SCM_D_Issue b
 where HISS_Issue_Number = DISS_Issue_Number
 and HISS_Company_Code=1 and DISS_Debit_Job_Code='LE120526'
 and DISS_Material_Code='228400510'

 select * from eip.sqlmas.GEN_M_Transaction_Details where mtd_trans_detail_code=4 and mtd_trans_type_code=2

 select *from eip.sqlscm.SCM_d_Purchase_Orders a, eip.sqlscm.SCM_H_Purchase_Orders b where HPO_PO_NUMBER = DPO_PO_NUMBER 
 and HPO_Company_Code=1
 and hpo_po_number in ('ED145PO7000305')

 and  dpo_material_code in ( '9cb020128','9cb020129') and HPO_Job_Code = 'LE090217'

 select *from eip.sqlscm.SCM_h_Material_Request where hMR_MR_Number in ( 'EE569EMR6001309','EE569EMR7001019','EE569EMR8000001')

 use eip
 go

 select * from sys.tables where name like '%transaction%'

 select *from sqlmas.gen_u_document_status


 select 
 cast(null as varchar(15)) Job_code,  cast('0'as varchar(15)) warehouse_code,  cast(null as datetime) from_date,  
cast(null as datetime) to_date,  -- Current Date,
cast(null as varchar(15)) class_code ,  
cast(null as int) uid  ,
  count(wo.TWHS_Inserted_On),
LJCE_IC_Code IC_Code,
LJCE_BU_Code BU_Code,
LJCE_Cluster_Office_Code Cluster_Code ,
 wo.TWHS_Company_Code company_code, 
 cast(null as varchar(15)) stock_type,  cast(null as varchar(200)) stock_Description,  cast(null as varchar(15))job_code, cast(null as varchar(250)) job_description ,  cast(null as varchar(15)) warehouse_code,  
  cast(null as varchar(15))material_code,  cast(null as varchar(500))  material_name,    cast(null as varchar(50))uom_description,   cast(null as money) quantity,    cast(null as money) amount ,   cast(null as money) MRN_Qty, 
  cast(null as money)  MRN_Value,   cast(null as money)  DC_Qty ,   cast(null as money)  DC_Value ,    cast(null as money)  IJSTN_qty,   cast(null as money)  IJSTN_Value,   cast(null as Varchar(200)) IC_Description , cast(null as Varchar(200))  BU_Description,
  cast(null as Varchar(200)) Cluster_Description,  cast(null as Varchar(50)) Currency_code,  cast(null as money) Surplus_qty , 
  wo.TWHS_Stock_Detail_Code as stock_type,  
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
																	AND IC.MCLED_Company_Code = TWHS_Company_Code )
	 Inner JOIN eip.SQLMAS.GEN_M_Cluster_Element_Details BU ON (BU.MCLED_CED_Code=LJCE_bu_Code AND BU.MCLED_CE_Code=4
																	AND BU.MCLED_Company_Code = TWHS_Company_Code )
	 Inner JOIN eip.SQLMAS.GEN_M_Cluster_Element_Details Cluster ON (Cluster.MCLED_CED_Code= LJCE_Cluster_Office_Code 
																		AND Cluster.MCLED_CE_Code=6
																		AND BU.MCLED_Company_Code = TWHS_Company_Code )
   WHERE TWHS_Stock_Type_Code= 4 and TWHS_Stock_Detail_Code in ('11','19')  
 --   and TWHS_Company_Code=company_code   
	--AND (IC_Code = '0' OR  LJCE_IC_Code = IC_Code)
	--AND (BU_Code = '0' OR LJCE_BU_Code = BU_Code)
	--AND (Cluster_Code = '0' OR LJCE_Cluster_Office_Code = Cluster_Code)              
 --  	AND ((job_code  IS NULL)  OR  ( wo.TWHS_Job_Code = job_code ))
	--AND ((warehouse_code IS null)  OR  ( wo.TWHS_Warehouse_Code = warehouse_code ))     
 --   And wo.TWHS_Material_Code between from_item AND  to_item  
	and wo.TWHS_Qty > 0
	AND TWHS_COMPANY_CODE='1'
	 group  by TWHS_Job_Code,LJCE_IC_Code,LJCE_BU_Code, LJCE_Cluster_Office_Code,TWHS_Material_Code,TWHS_Company_Code,TWHS_Stock_Detail_Code,TWHS_Qty,TWHS_Warehouse_Code,MMAT_Material_Description,
	  UUOM_Description,MJOB_Description,TWHS_Value, TWHS_Qty
	  having count(TWHS_Inserted_On) > 3

	select * from eip.SQLSCM.SCM_T_Warehouse_Stock

	select *from  eip.SQLMAS.GEN_M_Jobs


	drop table #temp_online_stock
	select TWHS_Job_Code, TWHS_Material_Code,TWHS_Qty, count(TWHS_inserted_on) invent_date
	into #temp_online_stock
		---TWHCS_Last_PO_Code , TWHCS_Stock_Year, TWHCS_Stock_Month
 from eip.sqlscm.SCM_T_Warehouse_Stock 
 where TWHS_Company_Code=1
 and TWHS_Stock_Detail_Code in ('11','19') and TWHS_Stock_Type_Code ='4'
 group by TWHS_Job_Code, TWHS_Material_Code,TWHS_Qty
 having count(TWHS_inserted_on) > 3

 ----select *from eip.sqlscm.SCM_T_Warehouse_Stock
 drop table #Non_Moving_stock_Issue
 		Select HISS_Job_Code, HISS_Warehouse_Code,DISS_Stock_Detail_Code, DISS_Material_Code, SUM(DISS_Qty) DISS_Qty, SUM(DISS_Value) DISS_Value
			into #Non_Moving_stock_Issue
		From eip.sqlscm.SCM_H_Issue,
			 eip.SQLSCM.SCM_D_Issue
		where HISS_Issue_Number = DISS_Issue_Number
			---and HISS_Date between @from_date and @to_date
			---AND HISS_Company_Code = TWHS_Company_Code
			--and DISS_Material_Code between @from_item AND  @to_item
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock a, eip.sqlscm.SCM_T_Warehouse_Stock b  WHERE a.TWHS_Job_Code = HISS_Job_Code
																		AND TWHS_Warehouse_Code = HISS_Warehouse_Code
																		AND a.TWHS_Material_Code = DISS_Material_Code
																		AND DISS_Stock_type_Code = 4
																		AND b.TWHS_Stock_Detail_Code = DISS_Stock_Detail_Code)
		group BY HISS_Job_Code, HISS_Warehouse_Code,DISS_Stock_Detail_Code, DISS_Material_Code

			Delete FROM #temp_online_stock
		where EXISTS (SELECT TOP 1 'x' from #Non_Moving_stock_Issue a, eip.sqlscm.SCM_T_Warehouse_Stock b  where TWHS_Job_Code = HISS_Job_Code 
																		and TWHS_Warehouse_Code = HISS_Warehouse_Code 
																			AND TWHS_Stock_Detail_Code =DISS_Stock_Detail_Code 
																			and TWHS_Material_Code = DISS_Material_Code)

																			/*MRN*/
		SELECT HMRN_Job_Code, HMRN_Warehouse_Code, DMRN_Material_Code, HMRN_Stock_Detail_Code, SUM(DMRN_Accepted_Qty) DMRN_Accepted_Qty, 
			SUM(DMRN_Native_Currency_Material_Value)DMRN_Native_Currency_Material_Value 		
			into #temp_MRN_detail_Non_moving
		FROM eip.SQLSCM.SCM_H_MRN
		INNER JOIN eip.SQLSCM.SCM_D_MRN ON (HMRN_MRN_Number = DMRN_MRN_Number 
														AND HMRN_Company_Code = DMRN_Company_Code)
		WHERE
			 --HMRN_MRN_Date between @from_date and @to_date
			 ---and DMRN_Material_Code  between @from_item AND  @to_item 
			-- and HMRN_Company_Code = @company_code
		EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock a, eip.sqlscm.SCM_T_Warehouse_Stock b  WHERE a.TWHS_Job_Code = HMRN_Job_Code
																		AND TWHS_Warehouse_Code = HMRN_Warehouse_Code
																		AND a.TWHS_Material_Code = DMRN_Material_Code
																		AND HMRN_Stock_type_Code = 4
																		AND b.TWHS_Stock_Detail_Code = HMRN_Stock_Detail_Code)
		group BY HMRN_Job_Code, HMRN_Warehouse_Code, DMRN_Material_Code, HMRN_Stock_Detail_Code

	/*DC*/
		select HDC_Job_Code, HDC_Warehouse_Code, DDC_Material_Code, HDC_Stock_Detail_Code, SUM(DDC_Qty) DDC_Qty, sum(DDC_Value) DDC_Value
		into #temp_DC_detail_Non_moving
		from eip.SQLSCM.SCM_H_DC,
			eip.SQLSCM.SCM_D_DC
		where HDC_DC_Number = DDC_DC_Number
			--and HDC_Date between @from_date and @to_date
			--and DDC_Material_Code  between @from_item AND  @to_item  
			--and HDC_Company_Code = @COMPANY_CODE
			and HDC_DS_Code <> 8
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock a, eip.sqlscm.SCM_T_Warehouse_Stock b  WHERE a.TWHS_Job_Code = HDC_Job_Code
																		AND TWHS_Warehouse_Code = HDC_Warehouse_Code
																		AND a.TWHS_Material_Code = DDC_Material_Code
																		AND HDC_Stock_Type_Code = 4
																		AND TWHS_Stock_Detail_Code = HDC_Stock_Detail_Code)
		
		group BY HDC_Job_Code, HDC_Warehouse_Code, DDC_Material_Code, HDC_Stock_Detail_Code

	/*IJSTN*/
		SELECT HIJST_From_Job_Code, HIJST_From_Warehouse_Code, DIJST_Material_Code, HIJST_From_Stock_Type_Detail_Code, 
			SUM(DIJST_Quantity) DIJST_Quantity, SUM(DIJST_Material_Value) DIJST_Material_Value
		into #temp_IJSTN_detail_Non_moving
		FROM eip.sqlscm.SCM_H_Inter_Job_Stock_Transfer_Note,
			 eip.SQLSCM.SCM_D_Inter_Job_Stock_Transfer_Note
		where HIJST_IJSTN_Number = DIJST_IJSTN_Number
			--and HIJST_IJSTN_Date between @from_date and @to_date
			--and DIJST_Material_Code  between @from_item AND  @to_item 
			--and HIJST_Company_Code =  @COMPANY_CODE 
			AND EXISTS (SELECT TOP 1 'X' FROM #temp_online_stock a, eip.sqlscm.SCM_T_Warehouse_Stock b  WHERE a.TWHS_Job_Code = HIJST_From_Job_Code
																			AND b.TWHS_Warehouse_Code = HIJST_From_Warehouse_Code
																			AND a.TWHS_Material_Code = DIJST_Material_Code
																			AND HIJST_From_Stock_Type_Code = 4
																			AND b.TWHS_Stock_Detail_Code  = HIJST_From_Stock_Type_Detail_Code)
		group by HIJST_From_Job_Code, HIJST_From_Warehouse_Code, DIJST_Material_Code, HIJST_From_Stock_Type_Detail_Code


	alter table #temp_online_stock add MRN_Qty money
		alter table #temp_online_stock add MRN_Value money
--drop table #temp_MRN_detail_Non_moving
	/*MRN Update*/
		update #temp_online_stock
			SET MRN_Qty = mrn.DMRN_Accepted_Qty,
				MRN_Value = mrn.DMRN_Native_Currency_Material_Value
		from #temp_MRN_detail_Non_moving mrn, eip.sqlscm.SCM_T_Warehouse_Stock b
		where b.TWHS_Job_Code = mrn.HMRN_Job_Code
			and b.twhs_Warehouse_code = mrn.HMRN_Warehouse_Code
			and b.TWHS_Stock_Detail_Code = mrn.HMRN_Stock_Detail_Code
			and b.tWHS_Material_Code = mrn.DMRN_Material_Code
	select *from #temp_MRN_detail_Non_moving

	alter table #temp_online_stock add dc_Qty money
		alter table #temp_online_stock add dc_Value money
	/*DC Update*/
		Update #temp_online_stock
			SET DC_Qty = DDC_Qty,
				DC_Value = DDC_Value
		from #temp_DC_detail_Non_moving, eip.sqlscm.SCM_T_Warehouse_Stock b
		where b.TWHS_Job_Code = HDC_Job_Code
		and TWHS_Warehouse_Code = HDC_Warehouse_Code
		and TWHS_Stock_Detail_Code = HDC_Stock_Detail_Code
		and b.TWHS_Material_Code = DDC_Material_Code

alter table #temp_online_stock add ijstn_Qty money
		alter table #temp_online_stock add ijstn_Value money
	/*IJSTN Update*/
		Update #temp_online_stock
			SET IJSTN_qty = DIJST_Quantity,
				IJSTN_Value = DIJST_Material_Value
		From #temp_IJSTN_detail_Non_moving, eip.sqlscm.SCM_T_Warehouse_Stock b
			where b.TWHS_Job_Code = HIJST_From_Job_Code
				and TWHS_Warehouse_Code = HIJST_From_Warehouse_Code
				and b.TWHS_Material_Code = DIJST_Material_Code
				and TWHS_Stock_Detail_Code = HIJST_From_Stock_Type_Detail_Code


				select *from #temp_online_stock




 