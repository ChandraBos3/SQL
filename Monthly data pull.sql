
/**        Job Cluster         **/
drop table #job_cluster
select a.* , b.MJOB_Job_Code as job_code_cluster,
REPLACE(b.MJOB_Description,',','') as job_description,
replace(d1.MCLED_Description, ',' , '') as CE_ic,
--replace(d2.MCLED_Description, ',' , '') as CE_sbu,
replace(d3.MCLED_Description, ',' , '') as CE_bu,
--d4.MCLED_Description as CE_seg,
d5.MCLED_Description as CE_cluster,
--d6.MCLED_Description as CE_reg,
d7.MCLED_Description as CE_loc,
--d8.MCLED_Description as CE_zone,
--d9.MCLED_Description as CE_area,
a.LJCE_Company_Code as company_code
into #job_cluster
from eip.sqlmas.GEN_M_Jobs b
inner join eip.sqlmas.GEN_L_Job_Cluster_Elements a  on a.LJCE_Job_Code = b.MJOB_Job_Code 

left join eip.sqlmas.GEN_M_Cluster_Element_Details d1  on a.LJCE_IC_Code = d1.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d2  on a.LJCE_SBG_Code = d2.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d3  on a.LJCE_BU_Code = d3.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d4  on a.LJCE_Sub_BU_Code = d4.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d5  on a.LJCE_Cluster_Office_Code = d5.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d6  on a.LJCE_Region_Code = d6.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d7  on a.LJCE_Location_Code = d7.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d8  on a.LJCE_Zone_Code = d8.MCLED_CED_Code 
left join eip.sqlmas.GEN_M_Cluster_Element_Details d9  on a.LJCE_Area_Code  = d9.MCLED_CED_Code 
--where a.LJCE_company_code = 1 
--and MJOB_Main_Sub_Dept = 'M' 

select distinct CE_ic , CE_bu from #job_cluster

/**         Work Order Data       **/

drop table #wo_invoice_detail
select HWO_Payment_Centre,HWO_WO_Number,hbill_bill_number , hbill_bill_date ,year(hbill_bill_date) as year,  month(hbill_bill_date) as month , 
b.HBILL_From_Date,b.HBILL_to_Date,
dwmbl_item_code,dwmbl_version, DWMBL_PBS_Code, 
lower(replace(replace(replace(replace(replace(replace(d.MPBS_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as  activity_cat_2, 
dwmbl_asset_code, c.dwo_uom_code , u.UUOM_Description as unit_desc, DWMBL_Job_Code, DWMBL_Stage_Percentage, 
lower(replace(replace(replace(replace(replace(replace(e.MAST_NAME, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '), (char(13)), ' '),  (char(9)), ' ') ,(char(10)), ' ')) as  asset_name,
lower(replace(replace(replace(replace(replace(replace(f.MAGRP_Group_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as  asset_group,
lower(replace(replace(replace(replace(replace(replace(g.MJITC_item_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   activity_desc_1,
lower(replace(replace(replace(replace(replace(replace(i.MIGRP_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   activity_cat_1,
lower(replace(replace(replace(replace(replace(replace(b2.MWOTP_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   activity_cat_0,
x.*,
case when DWMBL_PBS_Code is NULL then 'Asset' else case when DWMBL_PBS_Code like 'IDC%' then 'IDC' else 'NON IDC' end  end as IDC_flag,
case when HWO_Payment_Centre  = 'SZ000010' then 1 else 0 end as SSC_flag,
DWMBL_Stage_Number,
DWMBL_Qty as tot_DWMBL_Qty, 
case when (DWMBL_Stage_Number <> 0 ) then (DWMBL_Stage_Percentage/100) * dwmbl_qty else dwmbl_qty end as  volume,
DWMBL_Amount as value,
b1.hwo_ba_code as vendor_code,
lower(replace(replace(replace(replace(replace(replace(v.MBA_BA_Name, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as  vendor_name,
case when len(g.MJITC_item_Description) > 8 then 1 else 0 end as activity_desc1_flag,
case when len(c.DWO_Additional_Description) > 8 then 1 else 0 end as activity_desc2_flag,
lower(replace(replace(replace(replace(replace(replace(c.DWO_Additional_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   activity_desc_2
into #wo_invoice_detail
--  select count(*)
from eip.sqlwom.wom_d_bills a
	    inner join eip.sqlwom.wom_h_bills b							on b.hbill_bill_number = a.dwmbl_bill_number and year(hbill_bill_date) >= 2016
		left join eip.sqlwom.WOM_H_Work_Orders b1					on  b.HBILL_WO_Number = b1.HWO_WO_Number and b.hbill_Company_Code = b1.HWO_Company_Code
		left join eip.SQLMAS.GEN_M_WO_Types b2						on b1.HWO_WOT_code = b2.MWOTP_WOT_Code
		left join eip.sqlwom.wom_d_work_orders c					on a.dwmbl_wo_number = c.dwo_wo_number and a.dwmbl_item_code = c.dwo_item_code and a.dwmbl_version = c.dwo_version and b1.HWO_WO_Number = c.dwo_wo_number
		left join eip.sqlmas.gen_m_project_breakdown_structure d	on a.dwmbl_job_code=  d.MPBS_Job_Code and a.DWMBL_PBS_Code =  d.MPBS_PBS_Code
		left join eip.sqlmas.GEN_M_Asset e							on e.Mast_asset_code = a.dwmbl_asset_code and e.MAST_current_job_code = a.DWMBL_Job_Code and e.Mast_company_code = 1 
		left join eip.SQLmas.GEN_M_Asset_Groups f					on e.MAST_Group_Code = f.MAGRP_Group_Code and f.MAGRP_company_code = e.MAST_Company_Code and f.MAGRP_Company_Code = 1 
		left join eip.sqlwom.WOM_M_Job_Item_Codes g					on g.MJITC_Job_Code = DWMBL_Job_Code   and g.MJITC_Item_Code = dwmbl_item_code   and g.MJITC_Item_Version = DWMBL_Item_Version
		left join eip.sqlmas.gen_M_Item_Groups i					on g.MJITC_Item_Group_Code = i.MIGRP_Item_Group_Code and i.MIGRP_Company_code = 1
		left join eip.sqlmas.gen_u_unit_of_measurement u			on u.UUOM_UOM_Code = c.dwo_uom_code
		left join #job_cluster x									on x.job_code_cluster = DWMBL_Job_Code
		left join eip.sqlmas.GEN_M_Business_Associates v			on b1.hwo_ba_code = v.MBA_BA_Code and b1.HWO_Company_Code = v.MBA_Company_Code
where b.hbill_company_code = 1 and DWMBL_Amount <> 0 
--and HWO_Payment_Centre = 'SZ000010'
-- For international change this to != 72 
and HWO_Currency_Code = 72
--	group by HWO_Payment_Centre, hbill_bill_number , hbill_bill_date , dwmbl_item_code,dwmbl_version, DWMBL_PBS_Code, d.MPBS_Description, dwmbl_asset_code, DWMBL_Stage_Number, dwo_uom_code, UUOM_Description, DWMBL_Job_Code,DWMBL_Stage_Percentage
order by HWO_Payment_Centre, hbill_bill_number , hbill_bill_date , DWMBL_Job_Code

-- select * from #wo_invoice_detail where DWMBL_PBS_Code like 'IDC%'

/** Invoice level data creation for work orders  **/
drop table #wo_invoice
select year, month,hbill_bill_number,HWO_WO_Number,hbill_bill_date,HBILL_From_Date,HBILL_to_Date,dwmbl_asset_code,unit_desc,asset_name,asset_group,activity_cat_0,activity_cat_1,activity_cat_2,LJCE_IC_Code,job_code_cluster,job_description,
CE_ic,CE_bu,CE_loc,company_code,IDC_flag,SSC_flag,activity_desc1_flag , activity_desc2_flag,
	sum(volume) as volume,
	sum(value) as value,
	vendor_code,activity_desc_2,activity_desc_1
into #wo_invoice
from  #wo_invoice_detail where (value <> 0 or volume <> 0)
group by year, month,hbill_bill_number,HWO_WO_Number,hbill_bill_date,HBILL_From_Date,HBILL_to_Date,dwmbl_asset_code,unit_desc,asset_name,asset_group,activity_cat_0,activity_cat_1,activity_cat_2,LJCE_IC_Code,job_code_cluster,job_description,
CE_ic,CE_bu,CE_loc,company_code,IDC_flag,SSC_flag,vendor_code,activity_desc_2,activity_desc_1,activity_desc1_flag , activity_desc2_flag

select * from #wo_invoice

select top 10 * from #wo_invoice_detail

/** Monthly WO data pull **/
select  year, month,hbill_bill_number,HWO_WO_Number,hbill_bill_date,HBILL_From_Date,HBILL_to_Date,dwmbl_asset_code,unit_desc,asset_name,asset_group,activity_cat_0,activity_cat_1,activity_cat_2,LJCE_IC_Code,job_code_cluster ,job_description,
CE_ic,CE_bu,CE_loc,company_code,IDC_flag,SSC_flag,activity_desc1_flag , activity_desc2_flag, volume, value,vendor_code,
lower(replace(replace(replace(replace(replace(activity_desc_1, '"' ,' '  ), '|' ,' '  ) ,'  ', ' '), (char(13)), ' '), (char(10)), ' ')) as   activity_desc_1,
lower(replace(replace(replace(replace(replace(activity_desc_2, '"' ,' '  ), '|' ,' '  ) ,'  ', ' '), (char(13)), ' '), (char(10)), ' ')) as   activity_desc_2
from #wo_invoice 
Where year >= 2017 and month >= 4 and (value <> 0 or volume <> 0) and -- change year/month as required
CE_ic = 'Buildings & Factories' -- comment out or change to respective IC as required


/** Monthly PO-MRN data pull **/
/** Copy/paste #po_mrn_1 query from mrn_po_join_query.sql here **/

/**         Purchase Order Data with MRN information           **/
drop table #po_mrn_1
select  a.HMR_MR_Date as material_request_date,
year(b.HPO_PO_Date) as year,
month(b.HPO_PO_Date) as month,
b.HPO_PO_Date,
b.HPO_po_Number  as material_po_number,
b.HPO_MR_Number as mr_number,
b.HPO_Delivery_Start_Date as delivery_start_date,
b.HPO_Delivery_End_Date as delivery_end_date,
b.HPO_Warehouse_Code as warehouse_code,
b.HPO_ba_code as vendor_code,
a1.[MBA_BA_Name] as vendor_name,
b.HPO_Offer_Number as vendor_offer_number,
c.DPO_Delivery_Start_Date as det_delivery_start_date,
c.DPO_Delivery_End_Date as det_delivery_end_date,
c.DPO_Material_Code as material_code, 
c.DPO_Amendment_Number,
c.dpo_qty old_qty,
c.DPO_Value old_value,
c.DPO_Basic_Rate , c.DPO_Net_Rate, 
(c.DPO_Qty - c.Dpo_cancelled_qty) volume,
((c.DPO_Qty - c.Dpo_cancelled_qty) * c.DPO_Net_Rate) value,
c.DPO_Pending_Qty, c.DPO_Cancelled_Qty, c.DPO_GIN_Qty, c.DPO_MRN_Qty,
f.DPOT_Direct_Supply,
b.HPO_Currency_Code,
curr.MCUR_Short_Description,
x.*,
lower(replace(replace(replace(replace(replace(replace(g.MMATC_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   Material_cat_desc,
lower(replace(replace(replace(replace(replace(replace(e.MMGRP_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   Material_grp_desc,
lower(replace(replace(replace(replace(replace(replace(d.mmat_short_name, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   material_name,
lower(replace(replace(replace(replace(replace(replace(d.MMAT_Material_description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   Material_desc,
lower(replace(replace(replace(replace(replace(replace(b.HPO_Buyer_Remarks, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   HPO_Buyer_Remarks,
lower(replace(replace(replace(replace(replace(replace(a.HMR_remarks, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   HMR_remark,
lower(replace(replace(replace(replace(replace(replace(C.DPO_remarks, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   DPO_remark,
lower(replace(replace(replace(replace(replace(replace(u.UUOM_Description, '|' ,' '  ), ',' ,' '  ) ,'  ', ' '),  (char(9)), ' ') ,(char(13)), ' '), (char(10)), ' ')) as   unit_desc

into #po_mrn_1
from eip.sqlscm.SCM_H_Purchase_Orders b 
left join  eip.SQLSCM.SCM_H_Material_Request a   on  a.HMR_MR_Number = b.HPO_MR_Number and a.HMR_company_code = b.HPO_Company_Code and b.HPO_Currency_Code = 72
left join eip.SQLSCM.SCM_D_Purchase_Orders	c on b.HPO_PO_Number = c.DPO_PO_Number
left join eip.SQLMAS.GEN_M_Materials d	on b.HPO_Company_Code = d.MMAT_Company_Code and c.DPO_Material_Code = d.MMAT_Material_Code
left join eip.SQLMAS.GEN_M_Material_Groups e	on b.HPO_Company_Code = e.MMGRP_Company_Code and d.MMAT_MG_Code = e.MMGRP_MG_Code
left join eip.sqlscm.scm_d_purchase_order_terms f on b.hpo_po_number = f.dpot_po_number and b.HPO_Last_Amendment_Number = f.dpot_amendment_number
left join eip.sqlmas.GEN_M_Material_classes g on g.mmatc_class_code = e.MMGRP_Class_Code and g.MMATC_Company_Code = e.MMGRP_Company_Code
left join #job_cluster x on x.job_code_cluster = b.HPO_Job_Code
left join eip.sqlmas.gen_u_unit_of_measurement u on d.mmat_uom_code = u.UUOM_UOM_Code
left join EIP.[SQLMAS].[GEN_M_Business_Associates] a1 on b.HPO_Company_Code = a1.[MBA_Company_Code] and b.HPO_BA_Code = a1.MBA_BA_Code
left join [EIP].[SQLMAS].[GEN_M_Currencies] curr on curr.[MCUR_Currency_Code] = b.HPO_Currency_Code
where -- year(b.HPO_PO_Date) in (2016) and  
a.HMR_MR_Date >= '2017-04-01' and
-- b.HPO_PO_Date >= '2017-04-01' and
b.HPO_Company_Code = 1 and b.HPO_DS_Code <> 8 and ((c.DPO_Qty - c.Dpo_cancelled_qty) * c.DPO_Net_Rate) > 0 and
-- CE_ic = 'Buildings & Factories

select * from #po_mrn_1

select *from eip.sqlmas.GEN_M_Cluster_Element_Details