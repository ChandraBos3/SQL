 use EIP
 go

 --   SQLWOM.#WOM_SP_WO_ConstZon_Details '30-Mar-2018', '31-Mar-2018', 1, 523
 create PROCEDURE SQLWOM.#WOM_SP_WO_ConstZon_Details
(
			@dtFromDate   DATE,
			@dtToDate   DATE, 
			@intCompanyCode INT,
			@intUID INT,
			@ChrConstZonApplicable CHAR(1) = 'A',
			@intReturnMessage		INT = NULL OUTPUT,            
			@strReturnParameters	VARCHAR(500) = NULL OUTPUT,
			@intLoginAuditNumber	INT = 0
)
AS
SET NOCOUNT ON
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
BEGIN
	--EXEC SQLACS.ACS_SP_User_Session_Validate @intUserID = @intUID, @intProcedureID = @@PROCID,
	--@intReturnMessage = @intReturnMessage OUTPUT, @intLoginAuditNumber = @intLoginAuditNumber  

	--IF @intReturnMessage != 90043 
	BEGIN
		SET @intReturnMessage = NULL

				DECLARE  @xml_iSTDet int  
				DECLARE @XML_Material_List TABLE  
				(  
				WO_Number VARCHAR(30) ,  
				Material_Code VARCHAR(50)  
				)  			
		               
				Create Table #Temp_WO_Company_Rate (Temp_Material_Code varchar(15), Temp_Item_Markup INT, Temp_Item_Version INT,
				Temp_Job_Location INT,Temp_Currency_Code INT , LastWORate_Company money,)
				

CREATE TABLE #Temp_SCM_PO_Details
(
                        Temp_WO_Number VARCHAR(30),
                        Temp_WO_Amendment_No Int,
                        Temp_WO_Date     DATE,
                        Temp_Job_Code    VarChar(15),
                        Temp_Vendor_Code    VarChar(15),
                        Temp_Currency_Code   Int,
                        Temp_Location_Code Int,
                        Temp_Material_Code VARCHAR(50),
						Temp_Item_Markup INT,
						Temp_Item_Version INT,
                        Temp_ConstZon_Applicable Char(1),
                        Temp_RC_Applicable Char(1),
                        Temp_Counter_Offer_Basic_Rate Money,
                        Temp_WO_Basic_Rate          Money,
						Temp_WO_Qty  Money,
						Temp_WO_Value Money,
                        Temp_National_Low_Rate Money,
						Temp_ConstZon_Lower_bound_Rate Money,
						Temp_ConstZon_Upper_bound_Rate Money,
						Temp_Last_WO_Rate_For_Location Money,
						Temp_Last_WO_Rate_From_Other_Location Money,
						Temp_UOM INT,
						Temp_Created_By INT,
						Temp_Location_Code_WO INT,
						Temp_Location_Desc VARCHAR(1000),
						Temp_Reason_for_Higher_Price VARCHAR(2000),
						Temp_Last_WO_Rate_From_Other_Location_Code_WO INT,
						Temp_WO_Total_Amount money
)

----------------Fresh WO Request

INSERT INTO #Temp_SCM_PO_Details
                        (Temp_WO_Number, Temp_WO_Amendment_No, Temp_WO_Date, Temp_Job_Code, Temp_Vendor_Code, 
                        Temp_Currency_Code, Temp_Material_Code, Temp_Item_Version, Temp_Item_Markup, Temp_WO_Basic_Rate,Temp_WO_Qty,
						Temp_WO_Value, 
                        Temp_Counter_Offer_Basic_Rate, Temp_ConstZon_Applicable, Temp_RC_Applicable, Temp_National_Low_Rate,Temp_UOM,
						Temp_Created_By,Temp_Reason_for_Higher_Price,Temp_WO_Total_Amount)
	SELECT DISTINCT HWORQ_Request_Number, 0,
										HWORQ_Date, HWORQ_Job_Code, HWORQ_BA_Code, HWORQ_Currency_Code, 
										DWORQ_Item_Code, DWORQ_Version, DWORQ_Markup_Code, DWORQ_Item_Rate,DWORQ_QTY,DWORQ_Item_Value,
										0, CASE WHEN DWORC_Rate_Applicable IN ('Y','R') THEN 'Y' ELSE 'N' END, 
										CASE WHEN DWORC_Rate_Applicable IN ('R') THEN 'Y' ELSE 'N' END,
										0, DWORQ_UOM_Code, HWORQ_Inserted_By, DWORC_Remarks,HWORQ_Total_Amount
	FROM SQLWOM.WOM_H_Work_Order_Request, SQLWOM.WOM_D_Work_Order_Request, --SQLWOM.WOM_M_Job_Item_Codes, 
			SQLWOM.WOM_D_WO_Request_ConstZon_Details
	WHERE HWORQ_Request_Number = DWORQ_Request_Number AND HWORQ_Date >= @dtFromDate AND HWORQ_Date <= @dtToDate
					AND HWORQ_DS_Code <> 8 AND DWORQ_Request_Number = DWORC_Request_Number
					AND DWORQ_Item_Code = DWORC_Item_Code AND DWORQ_Version = DWORC_Version AND DWORQ_Markup_Code = DWORC_Markup_Code
				--	AND HWORQ_Job_Code = MJITC_Job_Code AND DWORQ_Item_Code = MJITC_Item_Code AND DWORQ_Version = MJITC_Version
				--	AND MJITC_Company_Code = @intCompanyCode 
					AND HWORQ_Company_Code = @intCompanyCode
										--AND ((@ChrConstZonApplicable = 'A') or 
										--		(@ChrConstZonApplicable = 'Y' and DWOCD_Rate_Applicable in ('Y','R')) or 
										--		(@ChrConstZonApplicable = 'N' and DWOCD_Rate_Applicable ='N'))


----------------Fresh WO

INSERT INTO #Temp_SCM_PO_Details
                        (Temp_WO_Number, Temp_WO_Amendment_No, Temp_WO_Date, Temp_Job_Code, Temp_Vendor_Code, 
                        Temp_Currency_Code, Temp_Material_Code, Temp_Item_Version, Temp_Item_Markup, Temp_WO_Basic_Rate,Temp_WO_Qty,
						Temp_WO_Value, 
                        Temp_Counter_Offer_Basic_Rate, Temp_ConstZon_Applicable, Temp_RC_Applicable, Temp_National_Low_Rate,Temp_UOM,
						Temp_Created_By,Temp_Reason_for_Higher_Price,Temp_WO_Total_Amount)
	SELECT DISTINCT HWO_WO_Number, 0,
										HWO_WO_Date, HWO_Job_Code, HWO_BA_Code, HWO_Currency_Code, 
										DWO_Item_Code, DWO_Version, DWO_Markup_Code, DWO_Item_Rate,DWO_WO_QTY,DWO_Item_Value,
										0, CASE WHEN DWOCD_Rate_Applicable IN ('Y','R') THEN 'Y' ELSE 'N' END, 
										CASE WHEN DWOCD_Rate_Applicable IN ('R') THEN 'Y' ELSE 'N' END,
										0, DWO_UOM_Code, HWO_Inserted_By, DWOCD_Remarks,HWO_Total_Amount
	FROM SQLWOM.WOM_H_Work_Orders, SQLWOM.WOM_D_Work_Orders, --SQLWOM.WOM_M_Job_Item_Codes, 
		sqlwom.WOM_D_Work_Order_ConstZon_Details
	WHERE HWO_WO_Number = DWO_WO_Number AND HWO_WO_Date >= @dtFromDate AND HWO_WO_Date <= @dtToDate
					AND HWO_DS_Code <> 8 AND DWO_WO_Number = DWOCD_WO_Number
					AND DWO_Item_Code = DWOCD_Item_Code AND DWO_Version = DWOCD_Version AND DWO_Markup_Code = DWOCD_Markup_Code
					--AND HWO_Job_Code = MJITC_Job_Code AND DWO_Item_Code = MJITC_Item_Code AND DWO_Version = MJITC_Version
					--AND MJITC_Company_Code = @intCompanyCode 
					AND HWO_Company_Code = @intCompanyCode
										--AND ((@ChrConstZonApplicable = 'A') or 
												--(@ChrConstZonApplicable = 'Y' and DWOCD_Rate_Applicable in ('Y','R')) or 
												--(@ChrConstZonApplicable = 'N' and DWOCD_Rate_Applicable ='N'))

------------------------Amended WO

INSERT INTO #Temp_SCM_PO_Details
                (Temp_WO_Number, Temp_WO_Amendment_No, Temp_WO_Date, Temp_Job_Code, Temp_Vendor_Code, 
                Temp_Currency_Code, Temp_Material_Code, Temp_Item_Version, Temp_Item_Markup, Temp_WO_Basic_Rate,Temp_WO_Qty,
						Temp_WO_Value, 
                Temp_Counter_Offer_Basic_Rate, Temp_ConstZon_Applicable, Temp_RC_Applicable, Temp_National_Low_Rate,Temp_UOM,
				Temp_Created_By,Temp_Reason_for_Higher_Price,Temp_WO_Total_Amount)
SELECT DISTINCT HWOA_WO_Number, HWOA_Amendment_Number,
										HWOA_WO_Amendment_Date, HWO_Job_Code, HWO_BA_Code, HWO_Currency_Code,
										DWOA_Item_Code, DWOA_Version, DWOA_Markup_Code, DWOA_Item_Rate,DWOA_WO_Qty, dwoa_item_value,
										0, CASE WHEN DWOAC_Rate_Applicable IN ('Y','R') THEN 'Y' ELSE 'N' END, 
										CASE WHEN DWOAC_Rate_Applicable IN ('R') THEN 'Y' ELSE 'N' END,
										0, DWOA_UOM_Code, HWOA_Inserted_By, DWOAC_Remarks,HWOA_Total_Amount
	FROM SQLWOM.WOM_H_WOA_Request, SQLWOM.WOM_D_WOA_Request, SQLWOM.WOM_H_Work_Orders, 
			SQLWOM.WOM_D_WOA_ConstZon_Details
	WHERE HWOA_WO_Number = DWOA_WO_Number AND DWOA_Amendment_Number = DWOAC_WO_Amendment_Number
	                AND HWOA_WO_Amendment_Date >= @dtFromDate AND HWOA_WO_Amendment_Date <= @dtToDate
					AND HWOA_WO_Number = HWO_WO_Number  
					AND HWOA_DS_Code <> 8 AND DWOA_WO_Number = DWOAC_WO_Number
					AND DWOA_Item_Code = DWOAC_Item_Code AND DWOA_Version = DWOAC_Version AND DWOA_Markup_Code = DWOAC_Markup_Code
				--	AND HWORQ_Job_Code = MJITC_Job_Code AND DWORQ_Item_Code = MJITC_Item_Code AND DWORQ_Version = MJITC_Version
				--	AND MJITC_Company_Code = @intCompanyCode 
					AND HWO_Company_Code = @intCompanyCode
					 
 
---------------Last WO Rate
				UPDATE #Temp_SCM_PO_Details SET Temp_Location_Code_WO = MAB_City_Code
				FROM #Temp_SCM_PO_Details, SQLMAS.Gen_M_Jobs, SQLMAS.GEN_M_Address_Book
				WHERE MJOB_Job_Code = Temp_Job_Code AND MJOB_AB_Code = MAB_AB_Code

				INSERT INTO #Temp_WO_Company_Rate (Temp_Material_Code, Temp_Item_Version, Temp_Item_Markup, 
				 Temp_Currency_Code, Temp_Job_Location, LastWORate_Company)
				SELECT DWO_Item_Code, DWO_Version, DWO_Markup_Code, HWO_Currency_Code, MAB_City_Code, Max(DWO_Item_Rate) 
						FROM SQLWOM.WOM_H_Work_Orders, SQLWOM.WOM_D_Work_Orders,
								#Temp_SCM_PO_Details,
								SQLMAS.Gen_M_Jobs, SQLMAS.GEN_M_Address_Book
						WHERE  HWO_Company_Code = @intCompanyCode 
								AND HWO_WO_Number = DWO_WO_Number AND HWO_WO_DATE < @dtFromDate
								AND DWO_Item_Code = Temp_Material_Code AND DWO_Markup_Code = Temp_Item_Version 
								AND HWO_Currency_Code = Temp_Currency_Code
								AND HWO_DS_Code = 3  
								AND MJOB_Job_Code = HWO_Job_Code AND MJOB_AB_Code = MAB_AB_Code
				GROUP BY  DWO_Item_Code, DWO_Version, DWO_Markup_Code, HWO_Currency_Code, MAB_City_Code
				
				UPDATE #Temp_SCM_PO_Details SET Temp_Last_WO_Rate_For_Location = b.LastWORate_Company
				FROM  #Temp_SCM_PO_Details a, #Temp_WO_Company_Rate b
				WHERE b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_WO = b.Temp_Job_Location
				AND A.Temp_Item_Version = B.Temp_Item_Version AND A.Temp_Item_Version = B.Temp_Item_Version
				AND a.Temp_Item_Markup = b.Temp_Item_Markup

				SELECT b.Temp_Material_Code, b.Temp_Currency_Code, MAX(b.LastWORate_Company) LastWORate_Company INTO #TEMP_WORATE
				FROM  #Temp_SCM_PO_Details a, #Temp_WO_Company_Rate b
				WHERE  b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_WO <> b.Temp_Job_Location
                AND a.Temp_Currency_Code = b.Temp_Currency_Code AND A.Temp_Item_Version = B.Temp_Item_Version
				AND A.Temp_Item_Markup = B.Temp_Item_Markup
				GROUP BY b.Temp_Material_Code, b.Temp_Currency_Code

				UPDATE #Temp_SCM_PO_Details SET Temp_Last_WO_Rate_From_Other_Location = c.LastWORate_Company, 
				Temp_Last_WO_Rate_From_Other_Location_Code_WO = b.Temp_Job_Location
				FROM  #Temp_SCM_PO_Details a, #Temp_WO_Company_Rate b, #TEMP_WORATE C
				WHERE  b.Temp_Material_Code = A.Temp_Material_Code AND a.Temp_Location_Code_WO <> b.Temp_Job_Location
                AND a.Temp_Currency_Code = b.Temp_Currency_Code and b.Temp_Material_Code = c.Temp_Material_Code
				and b.Temp_Currency_Code = c.Temp_Currency_Code and b.LastWORate_Company = c.LastWORate_Company 
	 
			 						 EXEC SQLBSS.#BSS_SP_Const_rate_updation
 
--UPDATE #Temp_WOM _WO_Details set Temp_Last_WO_Rate_For_Location= Temp_WO_Basic_Rate

--UPDATE #Temp_WOM _WO_Details set Temp_Last_WO_Rate_From_Other_Location= Temp_WO_Basic_Rate
 
SELECT Temp_WO_Number WO_Number, Temp_WO_Amendment_No Amendment_No,
 Temp_WO_Date WO_Date, 
						Temp_Job_Code Job_Code,
						replace( replace( replace( replace( replace( replace( replace( replace(replace( MJOB_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-')    MJOB_Description, 
						Temp_Vendor_Code Vendor_Code, 
						replace( replace( replace( replace( replace( replace( replace( replace(replace(MBA_BA_Name,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-')   Vendor_Name,
                        MCUR_Description Currency, Temp_Material_Code Material_Code, 
						 replace( replace( replace( replace( replace( replace( replace( replace(replace(MJITC_Item_Description,char(9),'-'),char(10),'-'),char(11),'-'),char(12),'-'),char(13),'-'),char(14),'-'),'''','-'),'"','-'),',','-')   Material_Name,
						Temp_WO_Basic_Rate WO_Material_Basic_Rate, --Temp_Counter_Offer_Basic_Rate Material_Counter_Offer_Basic_Rate, 
						Temp_WO_Qty WO_Qty,
						Temp_WO_Value WO_Value, 
						Temp_ConstZon_Applicable ConstZon_Applicable,-- Temp_RC_Applicable RC_Applicable, 
						--Temp_National_Low_Rate National_Low_Rate,
						Temp_ConstZon_Lower_bound_Rate ConstZon_Lower_bound_Rate,
						Temp_ConstZon_Upper_bound_Rate ConstZon_Upper_bound_Rate, 
						Temp_Last_WO_Rate_For_Location Last_WO_Rate_For_Location, 		
						Temp_Last_WO_Rate_From_Other_Location Last_WO_Rate_From_Other_Location	, --Temp_UOM,
						MEMP_Employee_ID Creator_PSNo , MEMP_Name Created_By, Temp_Reason_for_Higher_Price,
						--Temp_Location_Code Location_Code, 
						Temp_Location_Desc Location_Desc ,
						Temp_WO_Total_Amount
						--UCITY_Name Last_WO_Rate_From_Other_Location_Desc
						FROM 
						SQLMAS.GEN_M_Jobs, SQLMAS.GEN_M_Business_Associates,SQLWOM.WOM_M_Job_Item_Codes,
						SQLMAS.GEN_M_Currencies, SQLMAS.GEN_M_Users, SQLMAS.GEN_M_Employees,
						#Temp_SCM_PO_Details
					 	--LEFT JOIN SQLMAS.GEN_U_Cities ON UCITY_City_Code = Temp_Last_WO_Rate_From_Other_Location_Code_WO
 where --Temp_WO_Basic_Rate <> Temp_Counter_Offer_Basic_Rate AND 
                 Temp_Job_Code = MJITC_Job_Code AND Temp_Material_Code = MJITC_Item_Code 
				AND Temp_Item_Version = MJITC_Version	AND MJITC_Company_Code = @intCompanyCode 
				AND Temp_Job_Code = MJOB_Job_Code
				 AND Temp_Vendor_Code = MBA_BA_Code AND MBA_Company_Code = @intCompanyCode
				 AND Temp_Currency_Code = MCUR_Currency_Code
				 AND Temp_Created_By = MUSER_USER_ID AND MUSER_Company_Code = @intCompanyCode
				 AND MUSER_Reference_ID = MEMP_Employee_ID AND MEMP_Company_Code = @intCompanyCode		 
				 --and Temp_ConstZon_Applicable = 'Y'
				 -- and Temp_ConstZon_Lower_bound_Rate is null
				 --AND Temp_ConstZon_Applicable in ('Y','R')
				 
END
END


go 




 go
create Procedure SQLBSS.#BSS_SP_Const_rate_updation
(
@Error VARCHAR(100)=null OUTPUT
)
AS
/*
Created By : Jeyanthi.J
Created On : 26-Feb-2018
Purpose: To Update Constzon Reference Price for the Item

declare @Error VARCHAR(100)
Exec #BSS_SP_Const_rate_updation 
select @Error
*/

Declare @Cnt int, @i int, @jobcode varchar(15), @itemcode varchar(15), @UOM INT,@Currency INT
Declare @CityCode int, @CityDesc varchar(100),@StateCode int, @StateDesc varchar(100),@ZoneCode int

IF OBJECT_ID('tempdb..#Temp_SCM_PO_Details','u') IS NULL 	
BEGIN
SET @Error = 'No Data Exists'
END
ELSE
BEGIN
SELECT DISTINCT Temp_job_code,Temp_location_code INTO #temp_JOB FROM #Temp_SCM_PO_Details
ALTER TABLE #temp_JOB ADD slno int Identity

Select @Cnt =Count(*) from #temp_JOB
SET @i =1

While @i<=@Cnt
Begin
	Select @jobcode =Temp_job_code from #temp_JOB where slno=@i

	 Select TOP 1 @StateCode = Mab.MAB_State_Code,@StateDesc = GUS.USTAT_Name,@CityCode = mab.MAB_City_Code,@CityDesc = GUC.UCITY_Name
						 FROM Eip.Sqlmas.Gen_M_Jobs MJ 
                     Left Join Eip.Sqlmas.Gen_L_Job_Cluster_Elements JCE on (MJ.Mjob_Job_Code = JCE.LJCE_Job_Code)
                     Left Join eip.sqlmas.GEN_M_Address_Book  MAB on ( MJ.Mjob_AB_Code=Mab.MAB_AB_Code)
                     Left Join Eip.Sqlmas.GEN_U_Cities GUC on (Mab.MAB_City_Code=GUC.UCITY_City_Code)
                     Left Join eip.sqlmas.GEN_U_States GUS on (GUC.UCITY_State_Code = GUS.USTAT_State_Code )					 
          Where Mjob_Job_Code = @JobCode
		   
		IF NOT EXISTS ( Select 'X' from  sqlbss.BSS_M_RA_Location Where MRALO_Location_Code = @CityCode and MRALO_Location_code in(108,200,267,331,463,2482,10587) )
          BEGIN
		 
                     SELECT TOP 1 @ZoneCode = LRAZC_ZONE_CODE FROM EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] WHERE LRAZC_CITY_CODE = @CityCode AND LRAZC_STATE_CODE = @StateCode
                     SELECT TOP 1 @CityCode = LRAZC_CITY_CODE FROM EIP.[SQLBSS].[BSS_L_RA_ZONE_CITY] WHERE LRAZC_ZONE_CODE = @ZoneCode
                     and exists (select 'x' from sqlbss.BSS_M_RA_Location c where  MRALO_Location_Code = LRAZC_CITY_CODE and  MRALO_Location_code in(108,200,267,331,463,2482,10587) )                     
					 
          END 

		  Update #temp_JOB set Temp_Location_Code =@CityCode  FROM #temp_JOB Where  slno=@i  	
		  
SET @i=@i+1

End	      

		  Update #Temp_SCM_PO_Details set Temp_Location_Code =c.Temp_Location_Code, Temp_Location_Desc =MRALO_Description
		  FROM #Temp_SCM_PO_Details a,  #temp_JOB c,  sqlbss.BSS_M_RA_Location
		  Where a.temp_job_code=C.temp_job_code and c.Temp_Location_Code =MRALO_Location_code
		  
		  Update #Temp_SCM_PO_Details set Temp_Location_Code =c.Temp_Location_Code, Temp_ConstZon_Lower_bound_Rate =btra_overall_minimum_range, Temp_ConstZon_Upper_bound_Rate =btra_overall_maximum_range
		  FROM #Temp_SCM_PO_Details a, sqlbss.BSS_T_Rate_Analysis b , #temp_JOB c
		  Where a.temp_job_code=C.temp_job_code and c.Temp_Location_Code =BTRA_Location_code and Temp_Material_Code =BTRA_EIP_Item_code and Temp_Currency_Code   =BTRA_Currency and Temp_UOM =BTRA_Item_UOM
		  
		-- select * from #Temp_SCM_PO_Details

END










GO