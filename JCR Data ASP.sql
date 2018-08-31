USE EPM
GO

/*
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'B'	--	B&F	
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'E'	--	PT&D
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'TI'	--	TI
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'SW'	--	SMART WORLD COMMUNICATION
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'WS'	--	WATER & EFFLUENT TREATMENT
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'I'	--	HEAVY CIVIL
SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary 1, 'U'	--	Metallurgical & Material Handling
*/				
Create PROCEDURE SQLPMP.#LNTSP_PMP_Get_JCR_CostHead_Summary
(
	@currencyInTerms    INT			=	1,
	@sectorCode			VARCHAR(15)	=	NULL
)
AS
SET NOCOUNT ON
BEGIN 
	
	BEGIN TRY
	
	             CREATE TABLE #detailedAnalysis(
       [sectorCode] [varchar](15) NULL,
       [sectorDescription] [varchar](500) NULL,
       [buCode] [varchar](15) NULL,
       [buDescription] [varchar](500) NULL,
       [jobCode] [varchar](15) NOT NULL,
       [jobDescription] [varchar](2500) NULL,
       [pbsCode] [varchar](15) NOT NULL,
       [pbsDescription] [varchar](2500) NULL,
       [pbsSortOrder] [int] NULL,
       [isQuantifiable] [char](1) NULL,
       [pbsUoM] [nvarchar](max) NULL,
       [boqCode] [varchar](50) NOT NULL,
       [boqDescription] [varchar](max) NULL,
       [boqSortOrder] [int] NULL,
       [isRollupApplicable] [char](1) NULL,
       [conversionFactor] [numeric](19, 4) NULL,
       [boqUoM] [nvarchar](max) NULL,
       [totalQuantity] [numeric](38, 4) NULL,
       [executedQuantity] [numeric](38, 4) NULL,
       [balanceQuantity] [numeric](38, 4) NULL,
       [expectedScACERate] [numeric](38, 4) NULL,
       [expectedMaterialACERate] [numeric](38, 4) NULL,
       [expectedPlantACERate] [numeric](38, 4) NULL,
       [expectedTotalACERate] [numeric](38, 4) NULL,
       [expectedACEAmount] [numeric](38, 7) NULL,
       [actualScRate] [numeric](38, 4) NULL,
       [actualMaterialRate] [numeric](38, 4) NULL,
       [actualPlantRate] [numeric](38, 4) NULL,
       [actualTotalRate] [numeric](38, 4) NULL,
       [actualScAmount] [numeric](38, 7) NULL,
       [actualMaterialAmount] [numeric](38, 7) NULL,
       [actualPlantAmount] [numeric](38, 7) NULL,
       [actualTotalAmount] [numeric](38, 7) NULL,
       [etcScRate] [numeric](38, 4) NULL,
       [etcMaterialRate] [numeric](38, 4) NULL,
       [etcPlantRate] [numeric](38, 4) NULL,
       [etcTotalRate] [numeric](38, 4) NULL,
       [etcAmount] [numeric](38, 7) NULL,
       [expectedscACE_amount] [numeric](38, 7)  NULL,
       [expected_mat_ACE_amount] [numeric](38, 7) NULL,
       [expected_Plant_ACE_amount] [numeric](38, 7)  NULL,
       [bpCode] [int] NOT NULL,
       [toDate] [datetime] NULL,
	   [labourCost]	[DECIMAL] (38,19),
	   [MaterialCost][DECIMAL](38,19),
	[PlantCost] [DECIMAL](38,19)
)

	
		
		DELETE FROM #detailedAnalysis

		DECLARE
		@jobBeginCount	INT	=	1,
		@jobEndCount	INT	=	0

		CREATE TABLE #jobDetails
		(
			rowNumber	INT	IDENTITY(1,1)
			,jobCode	VARCHAR(15)
			,toDate		DATETIME
			,bpCode		INT
		)

		INSERT INTO #jobDetails
		(
			jobCode
			,toDate
		)
		SELECT	TCM_Job_Code
				,TPBP_To_Date
		FROM
		(SELECT	TCM_Job_Code
				,TPBP_To_Date
				,r= ROW_NUMBER() OVER ( PARTITION BY TCM_Job_Code ORDER BY TPBP_To_Date DESC )
		FROM EPM.SQLEPM.EPM_M_Control_Master F
		JOIN EPM.SQLPMP.PMP_T_Project_Base_Plans
		ON (TCM_Job_Code				=	TPBP_Job_Code)
		JOIN EPM.SQLPMP.Job_Master j
		ON (TCM_Job_Code				=	j.job_code)
		JOIN EPM.SQLPMP.Sector_Master ic
		ON (j.Sector_Code				=	ic.Sector_Code)
		WHERE	(j.Sector_Code			=	@sectorCode	OR @sectorCode IS NULL)	AND
				TCM_PMP_CE_Tag			=	'Y'				AND
				TPBP_PST_Code			=	3000			AND
				TPBP_DS_Code			IN	('BPDS0002','BPDS0003')		
				AND NOT EXISTS (SELECT 'I' FROM EPM.SQLEPM.EPM_M_Control_Master T WHERE F.TCM_Job_Code = T.TCM_Job_Code AND T.TCM_PMP_CE_Legacy_Tag = 'Y')
		GROUP BY TCM_Job_Code,TPBP_To_Date)tbl
		WHERE	tbl.r <= 6

		UPDATE #jobDetails
		SET		bpCode			=	TPBP_BP_Code
		FROM EPM.SQLPMP.PMP_T_Project_Base_Plans
		WHERE	TPBP_Job_Code	=	jobCode	AND
				TPBP_To_Date	=	toDate	AND
				TPBP_DS_Code	IS NOT NULL

		SELECT @jobEndCount = MAX(rowNumber)
		FROM #jobDetails

		WHILE @jobBeginCount <= @jobEndCount
			BEGIN

				DECLARE
				@jobCode	VARCHAR(15),
				@bpCode		INT,
				@toDate		DATETIME

				SELECT	@jobCode	=	jobCode,
						@bpCode		=	bpCode,
						@toDate		=	toDate
				FROM #jobDetails
				WHERE rowNumber = @jobBeginCount

				DECLARE
				@companyCode	INT,
				@isQuantifiable	CHAR(1),
				@pbsSortOrder	INT,
				@beginCount		INT	=	1,
				@endCount		INT	=	0

				SELECT @companyCode	=	m.MCOMP_Company_Code
				FROM EPM.SQLPMP.Job_Master j
				JOIN EPM.SQLMAS.GEN_M_Companies m
				ON (j.company_code	=	m.MCOMP_Abbr_Code)
				WHERE job_code		=	@jobCode

				CREATE TABLE #pbsCode
				(
					rowNumber	INT IDENTITY(1,1)
					,pbsCode	VARCHAR(15) 
				)

				INSERT INTO #pbsCode
				(
					pbsCode
				)
				SELECT	LPWB_PBS_Code
				FROM EPM.SQLPMP.PMP_L_PBS_Work_BOQ
				JOIN EPM.SQLPMP.PMP_T_Work_BOQs
				ON (LPWB_Job_Code		=	TWB_Job_Code	AND
					LPWB_BP_Code		=	TWB_BP_Code		AND
					LPWB_BOQ_Code		=	TWB_BoQ_Code)
				WHERE	LPWB_Job_Code	=	@jobCode		AND
						LPWB_BP_Code	=	@bpCode
				GROUP BY LPWB_PBS_Code
	
				SELECT @endCount = MAX(rowNumber)
				FROM #pbsCode

				WHILE @beginCount <= @endCount
					BEGIN
						DECLARE
						@pbsCode			VARCHAR(15)
					
						SELECT @pbsCode	=	pbsCode
						FROM #pbsCode
						WHERE rowNumber	=	@beginCount

						SELECT	@isQuantifiable	=	TPBS_Is_Quantifiable,
								@pbsSortOrder	=	TPBS_Sort_Order
						FROM EPM.SQLPMP.PMP_T_Project_Breakdown_Structure
						WHERE	TPBS_Job_Code	=	@jobCode	AND
								TPBS_BP_Code	=	@bpCode		AND
								TPBS_PBS_Code	=	@pbsCode

						CREATE TABLE #boQDetails
						(
							boQCode								VARCHAR(50) PRIMARY KEY CLUSTERED
							,boQShortDescription				VARCHAR(500)
							,boQDescription						VARCHAR(MAX)
							,boQUomSymbol						NVARCHAR(MAX)
							,pbsCode							VARCHAR(15)
							,pbsDescription						VARCHAR(1000)
							,pbsUomSymbol						NVARCHAR(MAX)
							,isQuantifiable						CHAR(1)
							,quantityRollup						CHAR(1)
							,conversionFactor					DECIMAL(38,4)
							,workDoneQuantity					DECIMAL(38,4)
							,remainingQuantity					DECIMAL(38,4)
							,aceQuantity						DECIMAL(38,4)
							,aceAmountForSc						DECIMAL(38,19)
							,aceAmountForMaterial				DECIMAL(38,19)
							,aceAmountForPlant					DECIMAL(38,19)
							,aceRateForSc						AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE aceAmountForSc / aceQuantity END
							,aceRateForMaterial					AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE aceAmountForMaterial / aceQuantity END
							,aceRateForPlant					AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE aceAmountForPlant / aceQuantity END
							,expectedActualAmountForSc			AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE (aceAmountForSc / aceQuantity) * 
							workDoneQuantity END
							,expectedActualAmountForMaterial	AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE (aceAmountForMaterial / aceQuantity) * 
							workDoneQuantity END
							,expectedActualAmountForPlant		AS CASE WHEN aceQuantity = 0 OR aceQuantity IS NULL THEN 0 ELSE (aceAmountForPlant / aceQuantity) * 
							workDoneQuantity END
							,etcAmountForSc						DECIMAL(38,19)
							,etcAmountForMaterial				DECIMAL(38,19)
							,etcAmountForPlant					DECIMAL(38,19)
							,etcRateForSc						AS CASE WHEN remainingQuantity = 0 OR remainingQuantity IS NULL THEN 0 ELSE etcAmountForSc / remainingQuantity END
							,etcRateForMaterial					AS CASE WHEN remainingQuantity = 0 OR remainingQuantity IS NULL THEN 0 ELSE etcAmountForMaterial / 
							remainingQuantity END
							,etcRateForPlant					AS CASE WHEN remainingQuantity = 0 OR remainingQuantity IS NULL THEN 0 ELSE etcAmountForPlant / 
							remainingQuantity END
						)

						CREATE TABLE #actuals
						(
							actualPbs	VARCHAR(15) PRIMARY KEY CLUSTERED
							,sc			DECIMAL(38,4)
							,material	DECIMAL(38,4)
							,plant		DECIMAL(38,4)
						)

						INSERT INTO #actuals
						(
							actualPbs
						)
						SELECT @pbsCode
	
						UPDATE #actuals
						SET sc					=	ISNULL(TPACS_Total_Cost,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	2

						UPDATE #actuals
						SET sc					=	ISNULL(sc,0) + ISNULL(TPACS_Total_Cost,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	4

						UPDATE #actuals
						SET plant				=	ISNULL(TPACS_Total_Cost,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	5

						UPDATE #actuals
						SET plant				=	ISNULL(plant,0) + ISNULL(TPACS_Deferred_For_PlantandMachineries,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	6

						UPDATE #actuals
						SET plant				=	ISNULL(plant,0) + ISNULL(TPACS_Overhead_For_PlantandMachineries,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	3

						UPDATE #actuals
						SET material			=	ISNULL(TPACS_Total_Cost,0)
						FROM
						(SELECT SUM(ISNULL(TPACS_Total_Cost,0)) TPACS_Total_Cost
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	IN	(7,8))PBS

						UPDATE #actuals
						SET material			=	ISNULL(material,0) + ISNULL(TPACS_Deferred_For_Materials,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	6

						UPDATE #actuals
						SET material			=	ISNULL(material,0) + ISNULL(TPACS_OverHead_For_Materials,0)
						FROM EPM.SQLPMP.PMP_T_PBS_Actual_Cost_Head_Summary
						WHERE	TPACS_Job_code	=	@jobCode	AND
								TPACS_BP_Code	=	@bpCode		AND
								TPACS_PBS_Code	=	@pbsCode	AND
								TPACS_CH_Code	=	3
	
						CREATE TABLE #boqRate
						(
							activityCode	VARCHAR(15)
							,boqCode		VARCHAR(50)
							,labour			DECIMAL(38,4)
							,plant			DECIMAL(38,4)
							,material		DECIMAL(38,4)
							,rate			DECIMAL(38,4)
							,amount			DECIMAL(38,4)
							,labourCost		DECIMAL(38,4)
							,plantCost		DECIMAL(38,4)
							,materialCost	DECIMAL(38,4)
							,totalCost		DECIMAL(38,4)
							,recCode		INT
							,isActive		CHAR(1)
						)	

						INSERT INTO #boqRate
						SELECT	
							TRED_Activity_Code activityCode,
							TRED_Work_BOQ_Code boqCode,	
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then isnull(LCTG,0)/TWB_Remaining_Quantity  else 0 end labour,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then isnull(AGRP,0)/TWB_Remaining_Quantity  else 0 end plant,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then (isnull(MGRP,0) + isnull(MCGR,0))/TWB_Remaining_Quantity else 0 end material,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 
							then isnull(LCTG,0)/TWB_Remaining_Quantity + isnull(AGRP,0)/TWB_Remaining_Quantity + (isnull(MGRP,0) + isnull(MCGR,0))/TWB_Remaining_Quantity 
							else 0 end rate,
							isnull(LCTG,0)+isnull(AGRP,0)+isnull(MGRP,0) + isnull(MCGR,0) amount,
							isnull(LCTG,0) labourCost,
							isnull(AGRP,0) plantCost,
							isnull(MGRP,0) + isnull(MCGR,0) materialCost,
							isnull(LCTG,0) + isnull(AGRP,0) + isnull(MGRP,0) + isnull(MCGR,0) totalCost,
							TRED_REC_Code recCode,
							TRED_IsActive isActive
						from
						(
							select	TRED_Activity_Code,
									TRED_Work_BOQ_Code,
									TRED_RT_Code,
									TRED_Effective_Cost,
									TRED_REC_Code,
									TRED_IsActive
							from EPM.SQLPMP.PMP_T_Resource_Estimation_Details
							where	TRED_Job_Code	=	@jobCode	and
									TRED_BP_Code	=	@bpCode		
						)resourceCost
						pivot
						(
							sum(TRED_Effective_Cost) 
							for TRED_RT_Code in (LCTG,AGRP,MGRP,MCGR)
						)pivotResourceCost
						join EPM.SQLPMP.PMP_T_Work_BOQs
						on (TRED_Work_BOQ_Code	=	TWB_BoQ_Code)
						where	TWB_Job_Code	=	@jobCode	and
								TWB_BP_Code		=	@bpCode

						UNION 

						select	
							TRED_Activity_Code activityCode,
							TRED_Work_BOQ_Code boqCode,	
							isnull(LCTG,0) labour,
							isnull(AGRP,0) plant,
							(isnull(MGRP,0) + isnull(MCGR,0)) material,
							isnull(LCTG,0)+ isnull(AGRP,0) + (isnull(MGRP,0) + isnull(MCGR,0)) rate,
							isnull(LCTG,0)+isnull(AGRP,0)+isnull(MGRP,0) + isnull(MCGR,0) amount,
							isnull(LCTG,0) labourCost,
							isnull(AGRP,0) plantCost,
							isnull(MGRP,0) + isnull(MCGR,0) materialCost,
							isnull(LCTG,0) + isnull(AGRP,0) + isnull(MGRP,0) + isnull(MCGR,0) totalCost,
							TRED_REC_Code recCode,
							TRED_IsActive isActive
						from
						(
							select	TRED_Activity_Code,
									TRED_Work_BOQ_Code,
									TRED_RT_Code,
									TRED_Effective_Cost,
									TRED_REC_Code,
									TRED_IsActive
							from EPM.SQLPMP.PMP_T_Resource_Estimation_Details
							where	TRED_Job_Code	=	@jobCode	and
									TRED_BP_Code	=	@bpCode		
						)resourceCost
						pivot
						(
							sum(TRED_Effective_Cost) 
							for TRED_RT_Code in (LCTG,AGRP,MGRP,MCGR)
						)pivotResourceCost
						join EPM.SQLPMP.GEN_M_Indirect_Cost_Heads
						on (TRED_Work_BOQ_Code	=	MICH_IDC_Code	AND
							MICH_Company_Code	=	@companyCode)

						INSERT INTO #boQDetails
						(
							boQCode
							,boQShortDescription
							,boQDescription
							,boQUomSymbol
							,pbsCode		
							,pbsDescription
							,pbsUomSymbol
							,isQuantifiable
							,quantityRollup
							,conversionFactor
							,workDoneQuantity
							,remainingQuantity
							,etcAmountForSc
							,etcAmountForMaterial
							,etcAmountForPlant
						)
						SELECT	TWB_BoQ_Code
								,TWB_Short_Description
								,CASE WHEN TWB_Full_Description IS NULL THEN TWB_Description WHEN TWB_Description IS NULL 
								THEN TWB_Short_Description ELSE TWB_Full_Description END
								,boq.UUOM_Symbol 
								,TPBS_PBS_Code
								,CASE WHEN TPBS_Description IS NULL THEN TPBS_Short_Description ELSE TPBS_Description END
								,pbs.UUOM_Symbol
								,TPBS_Is_Quantifiable
								,LPWB_Is_Quantity_Rollup
								,LPWB_Conversion_Factor
								,ISNULL(TWB_Workdone_Quantity,0)
								,ISNULL(TWB_Remaining_Quantity,0)
								,SUM(labourCost)
								,SUM(materialCost)
								,SUM(plantCost)
						FROM EPM.SQLPMP.PMP_L_PBS_Work_BOQ
						JOIN EPM.SQLPMP.PMP_T_Work_BOQs
						ON (LPWB_Job_Code		=	TWB_Job_Code	AND
							LPWB_BP_Code		=	TWB_BP_Code		AND
							LPWB_BOQ_Code		=	TWB_BoQ_Code)
						JOIN EPM.SQLPMP.GEN_U_Unit_Of_Measurement boq
						ON (TWB_UOM_Code		=	UUOM_UOM_Code)
						JOIN EPM.SQLPMP.PMP_T_Project_Breakdown_Structure
						ON (LPWB_Job_Code		=	TPBS_Job_Code	AND
							LPWB_BP_Code		=	TPBS_BP_Code	AND
							LPWB_PBS_Code		=	TPBS_PBS_Code)
						JOIN EPM.SQLPMP.GEN_U_Unit_Of_Measurement pbs
						ON (TPBS_UOM_Code		=	pbs.UUOM_UOM_Code)
						LEFT JOIN #boqRate
						ON (TWB_BoQ_Code		=	boqCode			AND
							isActive			=	'Y')
						WHERE	LPWB_Job_Code	=	@jobCode		AND
								LPWB_BP_Code	=	@bpCode			AND
								LPWB_PBS_Code	=	@pbsCode
						GROUP BY TWB_BoQ_Code,TWB_Full_Description,TWB_Description,TWB_Short_Description,boq.UUOM_Symbol,pbs.UUOM_Symbol,TPBS_Is_Quantifiable
						,LPWB_Is_Quantity_Rollup,LPWB_Conversion_Factor,TWB_Workdone_Quantity,TWB_Remaining_Quantity,TPBS_PBS_Code,TPBS_Description,TPBS_Short_Description

	
						DELETE FROM #boQDetails
						WHERE ISNULL(workDoneQuantity,0) + ISNULL(remainingQuantity,0)  = 0
	

						CREATE TABLE #boqRateForAce
						(
							activityCode	VARCHAR(15)
							,boqCode		VARCHAR(50)
							,labour			DECIMAL(38,4)
							,plant			DECIMAL(38,4)
							,material		DECIMAL(38,4)
							,rate			DECIMAL(38,4)
							,amount			DECIMAL(38,4)
							,labourCost		DECIMAL(38,4)
							,plantCost		DECIMAL(38,4)
							,materialCost	DECIMAL(38,4)
							,totalCost		DECIMAL(38,4)
							,recCode		INT
							,isActive		CHAR(1)
						)	

						INSERT INTO #boqRateForAce
						SELECT	
							TRED_Activity_Code activityCode,
							TRED_Work_BOQ_Code boqCode,	
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then isnull(LCTG,0)/TWB_Remaining_Quantity  else 0 end labour,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then isnull(AGRP,0)/TWB_Remaining_Quantity  else 0 end plant,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 then (isnull(MGRP,0) + isnull(MCGR,0))/TWB_Remaining_Quantity else 0 end material,
							case when isnull(TWB_Remaining_Quantity,0) <> 0.0000 
							then isnull(LCTG,0)/TWB_Remaining_Quantity + isnull(AGRP,0)/TWB_Remaining_Quantity + (isnull(MGRP,0) + isnull(MCGR,0))/TWB_Remaining_Quantity 
							else 0 end rate,
							isnull(LCTG,0)+isnull(AGRP,0)+isnull(MGRP,0) + isnull(MCGR,0) amount,
							isnull(LCTG,0) labourCost,
							isnull(AGRP,0) plantCost,
							isnull(MGRP,0) + isnull(MCGR,0) materialCost,
							isnull(LCTG,0) + isnull(AGRP,0) + isnull(MGRP,0) + isnull(MCGR,0) totalCost,
							TRED_REC_Code recCode,
							TRED_IsActive isActive
						from
						(
							select	TRED_Activity_Code,
									TRED_Work_BOQ_Code,
									TRED_RT_Code,
									TRED_Effective_Cost,
									TRED_REC_Code,
									TRED_IsActive
							from EPM.SQLPMP.PMP_T_Resource_Estimation_Details
							where	TRED_Job_Code	=	@jobCode	and
									TRED_BP_Code	=	99992		
						)resourceCost
						pivot
						(
							sum(TRED_Effective_Cost) 
							for TRED_RT_Code in (LCTG,AGRP,MGRP,MCGR)
						)pivotResourceCost
						join EPM.SQLPMP.PMP_T_Work_BOQs
						on (TRED_Work_BOQ_Code	=	TWB_BoQ_Code)
						where	TWB_Job_Code	=	@jobCode	and
								TWB_BP_Code		=	99992

						UNION 

						select	
							TRED_Activity_Code activityCode,
							TRED_Work_BOQ_Code boqCode,	
							isnull(LCTG,0) labour,
							isnull(AGRP,0) plant,
							(isnull(MGRP,0) + isnull(MCGR,0)) material,
							isnull(LCTG,0)+ isnull(AGRP,0) + (isnull(MGRP,0) + isnull(MCGR,0)) rate,
							isnull(LCTG,0)+isnull(AGRP,0)+isnull(MGRP,0) + isnull(MCGR,0) amount,
							isnull(LCTG,0) labourCost,
							isnull(AGRP,0) plantCost,
							isnull(MGRP,0) + isnull(MCGR,0) materialCost,
							isnull(LCTG,0) + isnull(AGRP,0) + isnull(MGRP,0) + isnull(MCGR,0) totalCost,
							TRED_REC_Code recCode,
							TRED_IsActive isActive
						from
						(
							select	TRED_Activity_Code,
									TRED_Work_BOQ_Code,
									TRED_RT_Code,
									TRED_Effective_Cost,
									TRED_REC_Code,
									TRED_IsActive
							from EPM.SQLPMP.PMP_T_Resource_Estimation_Details
							where	TRED_Job_Code	=	@jobCode	and
									TRED_BP_Code	=	99992		
						)resourceCost
						pivot
						(
							sum(TRED_Effective_Cost) 
							for TRED_RT_Code in (LCTG,AGRP,MGRP,MCGR)
						)pivotResourceCost
						join EPM.SQLPMP.GEN_M_Indirect_Cost_Heads
						on (TRED_Work_BOQ_Code	=	MICH_IDC_Code	AND
							MICH_Company_Code	=	@companyCode)

						UPDATE #boQDetails
						SET	aceQuantity			=	TWB_Contract_Quantity,
							aceAmountForSc		=	labourCost,
							aceAmountForMaterial=	materialCost,
							aceAmountForPlant	=	plantCost
						FROM
						(SELECT	boqCode boQ
								,TWB_Contract_Quantity
								,SUM(labourCost) labourCost
								,SUM(materialCost) materialCost
								,SUM(plantCost) plantCost
						FROM #boqRateForAce
						JOIN EPM.SQLPMP.PMP_T_Work_BOQs
						ON TWB_BoQ_Code			=	boqCode
						WHERE	isActive		=	'Y'				AND
								TWB_Job_Code	=	@jobCode		AND
								TWB_BP_Code		=	99992
						GROUP BY boqCode,TWB_Contract_Quantity)boq
						WHERE	boQCode			=	boq.boQ

						INSERT INTO #boQDetails
						(
							pbsCode
							,pbsDescription
							,pbsUomSymbol
							,boQCode
							,boQShortDescription
							,boQDescription
							,isQuantifiable
							,quantityRollup
							,conversionFactor
							,etcAmountForSc
							,etcAmountForMaterial
							,etcAmountForPlant
						)
						SELECT	TCECAD_PBS_Code
								,TPBS_Description
								,UUOM_Symbol
								,'ZZZY-Enabling'
								,'Enabling Cost'
								,'Enabling Cost'
								,'N'
								,'N'
								,0
								,SUM((TCECAD_Cost * TCECED_Labour_Cost_Allocation_Percentage) / 100)
								,SUM((TCECAD_Cost * TCECED_Material_Cost_Allocation_Percentage) / 100)
								,SUM((TCECAD_Cost * TCECED_Plant_Cost_Allocation_Percentage) / 100)
						FROM EPM.SQLPMP.PMP_T_Common_Enabling_Cost_Allocation_Details
						JOIN EPM.SQLPMP.PMP_T_Common_Enabling_Cost_Estimation_Details
						ON (TCECAD_Job_Code		=	TCECED_Job_Code		AND
							TCECAD_BP_Code		=	TCECED_BP_Code		AND
							TCECAD_CECED_Code	=	TCECED_CECED_Code)
						JOIN EPM.SQLPMP.PMP_T_Project_Breakdown_Structure
						ON (TCECAD_Job_Code		=	TPBS_Job_Code		AND
							TCECAD_BP_Code		=	TPBS_BP_Code		AND
							TCECAD_PBS_Code		=	TPBS_PBS_Code)
						JOIN EPM.SQLPMP.GEN_U_Unit_Of_Measurement
						ON (TPBS_UOM_Code		=	UUOM_UOM_Code)
						WHERE	TCECAD_Job_Code	=	@jobCode			AND
								TCECAD_BP_Code	=	@bpCode				AND
								TCECAD_PBS_Code	=	@pbsCode
						GROUP BY TCECAD_Job_Code,TCECAD_BP_Code,TCECAD_PBS_Code,TPBS_Description,UUOM_Symbol

						UPDATE #boQDetails
						SET	aceAmountForSc		=	pbs.sc,
							aceAmountForMaterial=	pbs.m,
							aceAmountForPlant	=	pbs.p
						FROM 
						(SELECT	SUM((TCECAD_Cost * TCECED_Labour_Cost_Allocation_Percentage) / 100) sc
								,SUM((TCECAD_Cost * TCECED_Material_Cost_Allocation_Percentage) / 100) m
								,SUM((TCECAD_Cost * TCECED_Plant_Cost_Allocation_Percentage) / 100) p
						FROM EPM.SQLPMP.PMP_T_Common_Enabling_Cost_Allocation_Details
						JOIN EPM.SQLPMP.PMP_T_Common_Enabling_Cost_Estimation_Details
						ON (TCECAD_Job_Code		=	TCECED_Job_Code		AND
							TCECAD_BP_Code		=	TCECED_BP_Code		AND
							TCECAD_CECED_Code	=	TCECED_CECED_Code)
						WHERE	TCECAD_Job_Code	=	@jobCode			AND
								TCECAD_BP_Code	=	99992				AND
								TCECAD_PBS_Code	=	@pbsCode
						GROUP BY TCECAD_Job_Code,TCECAD_BP_Code,TCECAD_PBS_Code)pbs
						WHERE	boQCode			=	'ZZZY-Enabling'

						UPDATE #boQDetails
						SET boQUomSymbol		=	pbsUom,
							pbsCode				=	pbs,
							pbsDescription		=	pbsDesc,
							pbsUomSymbol		=	pbsUom,
							workDoneQuantity	=	workDoneQty,
							remainingQuantity	=	remainingQty,
							aceQuantity			=	aceQty
						FROM 
						(SELECT	pbsCode pbs
								,pbsDescription pbsDesc
								,pbsUomSymbol pbsUom
								,SUM(workDoneQuantity) workDoneQty
								,SUM(remainingQuantity) remainingQty
								,SUM(aceQuantity) aceQty
						FROM
						(SELECT	pbsCode		
								,pbsDescription					
								,pbsUomSymbol					
								,CASE WHEN isQuantifiable = 'Y' THEN (CASE WHEN quantityRollup = 'Y' THEN conversionFactor * workDoneQuantity ELSE 0 END) ELSE 0 END	
								workDoneQuantity				
								,CASE WHEN isQuantifiable = 'Y' THEN (CASE WHEN quantityRollup = 'Y' THEN conversionFactor * remainingQuantity ELSE 0 END) ELSE 0 END 
								remainingQuantity	
								,CASE WHEN isQuantifiable = 'Y' THEN (CASE WHEN quantityRollup = 'Y' THEN conversionFactor * aceQuantity ELSE 0 END) ELSE 0 END aceQuantity					
						FROM #boQDetails)boq
						JOIN #actuals
						ON (boq.pbsCode	=	actualPbs)
						GROUP BY pbsCode,pbsDescription,pbsUomSymbol)pbs
						WHERE	boQCode	IN ('ZZZY-Enabling','ZZZZ-Common P&M')

						INSERT INTO #detailedAnalysis
						(
							jobCode				
							,pbsCode				
							,pbsDescription	
							,pbsSortOrder		
							,isQuantifiable			
							,pbsUoM					
							,boqCode				
							,boqDescription			
							,isRollupApplicable		
							,boqUoM					
							,totalQuantity			
							,executedQuantity		
							,balanceQuantity		
							,expectedScACERate		
							,expectedMaterialACERate
							,expectedPlantACERate	
							,expectedTotalACERate	
							,expectedACEAmount		
							,actualScRate			
							,actualMaterialRate		
							,actualPlantRate		
							,actualTotalRate
							,actualScAmount
							,actualMaterialAmount
							,actualPlantAmount		
							,actualTotalAmount		
							,etcScRate				
							,etcMaterialRate		
							,etcPlantRate			
							,etcTotalRate			
							,etcAmount		
							,bpCode
							,toDate	
						)

						SELECT	@jobCode
								,pbsCode
								,pbsDescription
								,@pbsSortOrder
								,@isQuantifiable
								,pbsUomSymbol
								,pbsCode
								,NULL
								,NULL
								,NULL
								,SUM(boq.workDoneQuantity) + SUM(boq.remainingQuantity) totalQuantity
								,SUM(boq.workDoneQuantity) workDoneQuantity
								,SUM(boq.remainingQuantity) remainingQuantity
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN SUM(boq.expectedActualAmountForSc) ELSE (SUM(boq.expectedActualAmountForSc) / 
								SUM(boq.workDoneQuantity)) END expectedRateForSc
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN SUM(boq.expectedActualAmountForMaterial) ELSE (SUM(boq.expectedActualAmountForMaterial) / 
								SUM(boq.workDoneQuantity)) END expectedRateForMaterial 
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN SUM(boq.expectedActualAmountForPlant) ELSE (SUM(boq.expectedActualAmountForPlant) / 
								SUM(boq.workDoneQuantity)) END expectedRateForPlant
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN ((SUM(boq.expectedActualAmountForSc) + SUM(boq.expectedActualAmountForMaterial) + 
								SUM(boq.expectedActualAmountForPlant))) 
								ELSE (((SUM(boq.expectedActualAmountForSc) + SUM(boq.expectedActualAmountForMaterial) + SUM(boq.expectedActualAmountForPlant))) / 
								SUM(boq.workDoneQuantity)) END expectedTotalRate
								,SUM(boq.expectedActualAmountForSc + boq.expectedActualAmountForMaterial + boq.expectedActualAmountForPlant)/@currencyinterms expectedAmount 
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN 0 ELSE (ISNULL(sc,0) / SUM(boq.workDoneQuantity)) END actualRateForSc
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN 0 ELSE (ISNULL(material,0) / SUM(boq.workDoneQuantity)) END actualRateForMaterial 
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN 0 ELSE (ISNULL(plant,0) / SUM(boq.workDoneQuantity)) END actualRateForPlant
								,CASE WHEN SUM(boq.workDoneQuantity) = 0 THEN 0 ELSE (((ISNULL(sc,0)) + (ISNULL(material,0)) + (ISNULL(plant,0))) / @currencyinterms / 
								SUM(boq.workDoneQuantity)) END actualTotalRate
								,(ISNULL(sc,0))/@currencyinterms actualSc
								,(ISNULL(material,0))/@currencyinterms actualMaterial
								,(ISNULL(plant,0))/@currencyinterms actualPlant
								,((ISNULL(sc,0)) + (ISNULL(material,0)) + (ISNULL(plant,0))) / @currencyinterms actualTotalAmount
								,CASE WHEN SUM(boq.remainingQuantity) = 0 THEN SUM(boq.etcAmountForSc) ELSE (SUM(boq.etcAmountForSc) / SUM(boq.remainingQuantity)) 
								END etcRateForSc
								,CASE WHEN SUM(boq.remainingQuantity) = 0 THEN SUM(boq.etcAmountForMaterial) ELSE (SUM(boq.etcAmountForMaterial) / SUM(boq.remainingQuantity)) 
								END etcRateForMaterial
								,CASE WHEN SUM(boq.remainingQuantity) = 0 THEN SUM(boq.etcAmountForPlant) ELSE (SUM(boq.etcAmountForPlant) / SUM(boq.remainingQuantity)) 
								END etcRateForPlant
								,CASE WHEN SUM(boq.remainingQuantity) = 0 THEN (SUM(boq.etcAmountForSc + boq.etcAmountForMaterial + boq.etcAmountForPlant)) 
								ELSE ((SUM(boq.etcAmountForSc + boq.etcAmountForMaterial + boq.etcAmountForPlant)) / SUM(boq.remainingQuantity)) END etcTotalRate
								,SUM(boq.etcAmountForSc + boq.etcAmountForMaterial + boq.etcAmountForPlant)/@currencyinterms etcAmount
								,@bpCode
								,@toDate
						FROM
						(SELECT	pbsCode		
								,pbsDescription					
								,pbsUomSymbol					
								,CASE WHEN isQuantifiable = 'Y' THEN (CASE WHEN quantityRollup = 'Y' THEN conversionFactor * workDoneQuantity ELSE 0 END) ELSE 0 
								END workDoneQuantity				
								,CASE WHEN isQuantifiable = 'Y' THEN (CASE WHEN quantityRollup = 'Y' THEN conversionFactor * remainingQuantity ELSE 0 END) ELSE 0 
								END remainingQuantity					
								,CONVERT(DECIMAL(38,4),expectedActualAmountForSc) expectedActualAmountForSc		
								,CONVERT(DECIMAL(38,4),expectedActualAmountForMaterial) expectedActualAmountForMaterial
								,CONVERT(DECIMAL(38,4),expectedActualAmountForPlant) expectedActualAmountForPlant	
								,CONVERT(DECIMAL(38,4),etcAmountForSc) etcAmountForSc				
								,CONVERT(DECIMAL(38,4),etcAmountForMaterial) etcAmountForMaterial			
								,CONVERT(DECIMAL(38,4),etcAmountForPlant) etcAmountForPlant	
						FROM #boQDetails)boq
						JOIN #actuals
						ON (boq.pbsCode	=	actualPbs)
						GROUP BY pbsCode,pbsDescription,pbsUomSymbol,sc,material,plant
	
						INSERT INTO #detailedAnalysis
						(
							jobCode				
							,pbsCode				
							,pbsDescription	
							,pbsSortOrder		
							,isQuantifiable			
							,pbsUoM					
							,boqCode				
							,boqDescription	
							,boqSortOrder		
							,isRollupApplicable	
							,conversionFactor	
							,boqUoM					
							,totalQuantity			
							,executedQuantity		
							,balanceQuantity		
							,expectedScACERate		
							,expectedMaterialACERate
							,expectedPlantACERate	
							,expectedTotalACERate	
							,expectedACEAmount		
							,actualScRate			
							,actualMaterialRate		
							,actualPlantRate		
							,actualTotalRate
							,actualScAmount
							,actualMaterialAmount
							,actualPlantAmount		
							,actualTotalAmount		
							,etcScRate				
							,etcMaterialRate		
							,etcPlantRate			
							,etcTotalRate			
							,etcAmount	
							,bpCode
							,toDate				
						)
						SELECT	@jobCode
								,pbsCode
								,pbsDescription
								,@pbsSortOrder
								,isQuantifiable
								,pbsUomSymbol
								,boQCode			
								,boQShortDescription
								,@pbsSortOrder + ROW_NUMBER() OVER ( ORDER BY (boQCode))
								,quantityRollup
								,conversionFactor
								,boQUomSymbol	
								,workDoneQuantity + remainingQuantity
								,workDoneQuantity 				
								,remainingQuantity
								,CONVERT(DECIMAL(38,4),aceRateForSc) expectedRateForSc					
								,CONVERT(DECIMAL(38,4),aceRateForMaterial) expectedRateForMaterial	 			
								,CONVERT(DECIMAL(38,4),aceRateForPlant) expectedRateForPlant		
								,CASE WHEN workDoneQuantity + remainingQuantity = 0 THEN 0 ELSE CONVERT(DECIMAL(38,4), (((ISNULL(aceAmountForSc,0) + 
								ISNULL(aceAmountForMaterial,0) + ISNULL(aceAmountForPlant,0))) / (ISNULL(workDoneQuantity,0) + ISNULL(remainingQuantity,0)))) END expectedTotalRate
								,CASE WHEN workDoneQuantity + remainingQuantity = 0 THEN 0 ELSE CONVERT(DECIMAL(38,19), (((ISNULL(aceAmountForSc,0) + 
								ISNULL(aceAmountForMaterial,0) + ISNULL(aceAmountForPlant,0))) / (ISNULL(workDoneQuantity,0) + ISNULL(remainingQuantity,0))) * workDoneQuantity) 
								END expectedAmount
								,0 actualRateForSc
								,0 actualRateForMaterial 
								,0 actualRateForPlant
								,0 actualTotalRate
								,0 actualSc
								,0 actualMaterial
								,0 actualPlant
								,0 actualTotalAmount
								,CONVERT(DECIMAL(38,4),etcRateForSc) etcRateForSc					
								,CONVERT(DECIMAL(38,4),etcRateForMaterial) etcRateForMaterial				
								,CONVERT(DECIMAL(38,4),etcRateForPlant) etcRateForPlant
								,CASE WHEN remainingQuantity = 0 THEN 0 ELSE (CONVERT(DECIMAL(38,4),etcAmountForSc + etcAmountForMaterial + etcAmountForPlant) / remainingQuantity) 
								END etcTotalRate
								,CASE WHEN remainingQuantity = 0 THEN 0 ELSE ((CONVERT(DECIMAL(38,19),etcAmountForSc + etcAmountForMaterial + etcAmountForPlant) / 
								remainingQuantity) * remainingQuantity) END etcAmount		
								,@bpCode
								,@toDate					
						FROM #boQDetails
						ORDER BY boQCode

						DROP TABLE #boQDetails
						DROP TABLE #actuals
						DROP TABLE #boqRate
						DROP TABLE #boqRateForAce
			
						SET @beginCount = @beginCount + 1
					END

				DROP TABLE #pbsCode

				SET @jobBeginCount = @jobBeginCount + 1
			END
     
		UPDATE #detailedAnalysis
		SET	sectorCode			=	ic.Sector_Code,
			sectorDescription	=	ic.Sector_Description,
			buCode				=	bu.bu_code,
			buDescription		=	bu.bu_description,
			jobDescription		=	j.job_description
		FROM EPM.SQLPMP.Job_Master j
		JOIN EPM.SQLPMP.Sector_Master ic
		ON (j.Sector_Code	=	ic.Sector_Code)
		JOIN EPM.SQLPMP.business_unit_master bu
		ON (j.bu_code		=	bu.bu_code)
		WHERE	jobCode		=	j.job_code

		UPDATE boq
		SET actualScAmount			=	CASE WHEN (pbs.expectedScACERate * pbs.executedQuantity) = 0
										THEN 0 ELSE (pbs.actualScAmount / (pbs.expectedScACERate * pbs.executedQuantity)) *  (boq.expectedScACERate * boq.executedQuantity) END,
			actualMaterialAmount	=	CASE WHEN (pbs.expectedMaterialACERate * pbs.executedQuantity) = 0
										THEN 0 ELSE (pbs.actualMaterialAmount / (pbs.expectedMaterialACERate * pbs.executedQuantity)) *  
										(boq.expectedMaterialACERate * boq.executedQuantity) END,
			actualPlantAmount		=	CASE WHEN (pbs.expectedPlantACERate * pbs.executedQuantity) = 0
										THEN 0 ELSE (pbs.actualPlantAmount / (pbs.expectedPlantACERate * pbs.executedQuantity)) *  
										(boq.expectedPlantACERate * boq.executedQuantity) END,
			actualTotalAmount		=	CASE WHEN (pbs.expectedTotalACERate * pbs.executedQuantity) = 0
										THEN 0 ELSE (pbs.actualTotalAmount / (pbs.expectedTotalACERate * pbs.executedQuantity)) *  
										(boq.expectedTotalACERate * boq.executedQuantity) END			
		FROM #detailedAnalysis boq, #detailedAnalysis pbs
		WHERE boq.pbsCode	=	pbs.boqCode

		UPDATE #detailedAnalysis
		SET actualScRate	=	CASE WHEN executedQuantity = 0 THEN 0 ELSE actualScAmount / executedQuantity END,
			actualMaterialRate	=	CASE WHEN executedQuantity = 0 THEN 0 ELSE actualMaterialAmount / executedQuantity END,
			actualPlantRate	=	CASE WHEN executedQuantity = 0 THEN 0 ELSE actualPlantAmount / executedQuantity END,
			actualTotalRate	=	CASE WHEN executedQuantity = 0 THEN 0 ELSE actualTotalAmount / executedQuantity END
		WHERE	pbsCode		<>	boqCode
				SELECT	sectorCode				
				,replace(replace(replace(replace(replace(replace(replace(replace(replace(sectorDescription,CHAR(15), ''),CHAR(14), ''), CHAR(13), ''), CHAR(12), ''),CHAR(11), ''),CHAR(10), ''),CHAR(9), ''),'''','f'),  '"','i')sectorDescription		
				,buCode					
				,replace(replace(replace(replace(replace(replace(replace(replace(replace(buDescription,CHAR(15), ''),CHAR(14), ''), CHAR(13), ''), CHAR(12), ''),CHAR(11), ''),CHAR(10), ''),CHAR(9), ''),'''','f'),  '"','i') buDescription			
				,jobCode
				,bpCode	
				,CONVERT(VARCHAR(15), toDate, 106) documentMonth		
				,replace(replace(replace(replace(replace(replace(replace(replace(replace(jobDescription,CHAR(15), ''),CHAR(14), ''), CHAR(13), ''), CHAR(12), ''),CHAR(11), ''),CHAR(10), ''),CHAR(9), ''),'''','f'),  '"','i') jobDescription			
				,pbsCode				
				,replace(replace(replace(replace(replace(replace(replace(replace(replace(pbsDescription,CHAR(15), ''),CHAR(14), ''), CHAR(13), ''), CHAR(12), ''),CHAR(11), ''),CHAR(10), ''),CHAR(9), ''),'''','f'),  '"','i') pbsDescription			
				,pbsSortOrder			
				,isQuantifiable			
				,pbsUoM					
				,boqCode				
				,replace(replace(replace(replace(replace(replace(replace(replace(replace(boqDescription,CHAR(15), ''),CHAR(14), ''), CHAR(13), ''), CHAR(12), ''),CHAR(11), ''),CHAR(10), ''),CHAR(9), ''),'''','f'),  '"','i') boqDescription			
				,boqSortOrder			
				,isRollupApplicable		
				,conversionFactor		
				,boqUoM					
				,totalQuantity			
				,executedQuantity		
				,balanceQuantity		
				,expectedScACERate		
				,expectedMaterialACERate
				,expectedPlantACERate	
				,expectedTotalACERate	
				,expectedACEAmount		
				,actualScRate			
				,actualMaterialRate		
				,actualPlantRate		
				,actualTotalRate		
				,actualScAmount			
				,actualMaterialAmount	
				,actualPlantAmount		
				,actualTotalAmount		
				,etcScRate				
				,etcMaterialRate		
				,etcPlantRate			
				,etcTotalRate			
				,etcAmount	
				,labourCost
				,materialCost
				,plantCost
					
		FROM #detailedAnalysis
		ORDER BY sectorDescription, buDescription, jobCode, toDate, pbsSortOrder, boqSortOrder

	END TRY
	BEGIN CATCH
		
		PRINT 'ERROR BLOCK'

		DECLARE 
		@ErrorMessage	NVARCHAR(4000),
		@ErrorSeverity	INT,
		@ErrorState		INT,
		@ErrorLine		INT

		SELECT	@ErrorMessage	=	ERROR_MESSAGE(),
				@ErrorSeverity	=	ERROR_SEVERITY(),
				@ErrorState		=	ERROR_STATE(),
				@ErrorLine		=	ERROR_LINE()

		RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState, @ErrorLine)

		SELECT *
		FROM #detailedAnalysis
		ORDER BY sectorDescription, buDescription, jobCode, pbsSortOrder, boqSortOrder

	END CATCH

END
