
function DefineGlobalVariables()
  -- Called from main()...

  --local alien=require"alien"
  --local kernel32=alien.load("kernel32.dll")

	g_bDebugMode = false
	if _G ~= nil then
		g_bDebugMode = true
		--SetupLocalDebugFuntions()
	end  
  
  ---------------------------------------------------------
	-- *** Start of Table Declarations...***
  ---------------------------------------------------------
  
  g_ActiveScorePartsTable = {} -- was ActiveSub[]
  -- Used in Populate_g_ScorePartsTable() and
  --         Populate_g_ActiveScorePartsTable()
  --g_ActiveScorePartsTable = {ScorePart_Name}
  
	g_bSegmentsAlreadyRebuiltTable = {} -- was disj[]
	-- Used in CheckIfAlreadyRebuiltSegmentsMustBeIncluded(),
  --         bSegmentIsAllowedToBeRebuilt(),
  --         SetSegmentsAlreadyRebuilt(),
  --         ResetSegmentsAlreadyRebuiltTable()
	-- g_bSegmentsAlreadyRebuiltTable={true/false}
	-- g_bSegmentsAlreadyRebuiltTable keeps track of which segments have already been processed...
  
	g_bUserSelectd_SegmentsAllowedToBeRebuiltTable = {} -- was WORKONbool[]
	-- Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(),
	--         bSegmentIsAllowedToBeRebuilt() and main()
	-- g_bUserSelectd_SegmentsAllowedToBeRebuiltTable={true/false}

	g_CysteineSegmentsTable = {}
	-- Used in Populate_g_CysteineSegmentsTable(),
  --         DisulfideBonds_GetCount() and
  --         DisplayPuzzleProperties()
	-- g_CysteineSegmentsTable={SegmentIndex}
  
	g_ScorePart_Scores_Table = {} -- was Scores[]
	-- Used in Populate_g_ScorePart_Scores_Table(),
	--         Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(),
	--         Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInS...
  --         and RebuildManySegmentRanges()
	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --                           bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
		spst_ScorePart_Number = 1
		spst_ScorePart_Score = 2
		spst_PoseTotalScore = 3
		spst_StringOfScorePartNumbersWithSamePoseTotalScore = 4 -- examples: "4", "5=7=12", "6=9", "8=11=13"
		spst_bFirstInStringOfScorePartNumbersWithSamePoseTotalScore = 5 -- 'true' means the first in a
  --                                                                    set of ScoreParts with the
  --                                                                    same PoseTotalScore,
  --                                                                   'false' means just a another
  --                                                                    in a set of ScoreParts with    
  --                                                                    the same PoseTotalScore

	g_ScorePartsTable = {} -- was ScoreParts[]
	-- Used in Populate_g_ScorePartsTable(),
  --         AskUserToSelectRebuildOptions(),
  --         AskUserToSelectScorePartsForStabilize(),
  --         AskUserToSelectScorePartsForCalculatingWorseScoringSegments(),
  --         RebuildManySegmentRanges(),
  --         Populate_g_ScorePart_Scores_Table() and
	--         Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
		spt_ScorePart_Number = 1
		spt_ScorePart_Name = 2 -- could have been called "SlotName", but since
    --                        most of the "slots" are ScoreParts...
		spt_bScorePartIsActive = 3  -- User can change this to false
		spt_LongName = 4

	g_SegmentScoresTable = {}
	-- Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts() and
  --         Calculate_ScorePart_Score()
	-- g_SegmentScoresTable={SegmentScore}
	-- g_SegmentScoresTable is optimized for quickly searching for 
	-- the lowest scoring segments, so we can work on those first.
  
	g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable = {} -- was scrPart[]
	-- Used by AskUserToSelectScorePartsForCalculatingWorseScoringSegments() and
  --         Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(), and
	-- g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable={ScorePart_Name}

  g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = {} -- was WORKON[]
	-- g_UserSelected_SegmentRangesAllowedToBeRebuiltTable is initiallly 
  -- set to {1, g_SegmentCount_WithoutLigands} (i.e., all the segments
  -- in the main protein) in DefineGlobalVariables() then the user can
  -- change this value in AskUserToSelectSegmentsRangesToRebuild() plus
  -- AskUserToSelectRebuildOptions() and finally we remove all frozen,
  -- locked and ligand segments in main(). This is important because we
  -- don't want to waste any time attempting to rebuild, mutate, shake
  -- or wiggle any segments that are not allowed to do so.

	g_XLowestScoringSegmentRangesTable = {} -- was areas[]
	-- Used in DefineGlobalVariables(),
  --         AskUserToSelectRebuildOptions(),
  --         AskUserToSelectSegmentsRangesToRebuild(),
  --         DisplayUserSelectedOptions(),
  --         main(),
  --         Populate_g_XLowestScoringSegmentRangesTable(),
  --         PrepareToRebuildSegmentRanges(),
  --         Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--         Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(), 
  --         RebuildManySegmentRanges(),
  --         DisplayXLowestScoringSegmentRanges() and
  --         RebuildSelectedSegments()
	-- g_XLowestScoringSegmentRangesTable={StartSegment, EndSegment}
		srtrt_StartSegment = 1
		srtrt_EndSegment = 2
    
  ---------------------------------------------------------
	-- ***...end of Table Declarations.***
  ---------------------------------------------------------
  
  ---------------------------------------------------------
  -- The following 2 global variables are not sorted 
  -- alphabetically with the others below because some
  -- of the other global variables depend on these to
  -- be set first...
  ---------------------------------------------------------
	g_SegmentCount_WithLigands = structure.GetCount()
	-- Used in 9 functions...But some could probably use g_SegmentCount_WithoutLigands instead!
	-- g_SegmentCount_WithLigands = The number of segments (amino acids) in the base
  --                              protein plus number of segments in any ligands (nearby molecules)

	g_SegmentCount_WithoutLigands = g_SegmentCount_WithLigands
	-- Used in 24 functions...
	-- g_SegmentCount_WithoutLigands = The number of segments (amino acids) in the just
  --                                 the protein (not including any ligand segments).
	--                                 The number of segments without structure type="M" (ligands)
  -- Now, subtract the ligand segments...
	local l_SegmentIndex
	for l_SegmentIndex = g_SegmentCount_WithLigands, 1, -1 do
		l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
		-- The function GetSecondaryStructure() returns a segment's
		--  secondary structure type, as a single letter...
		-- "E" = Sheet, "H" = Helix, "L" = Loop, "M" = Ligand (M for molecule)
		if l_GetSecondaryStructureType == "M" then
		-- Subtract the ligand segment...
			g_SegmentCount_WithoutLigands = g_SegmentCount_WithoutLigands - 1
		end
	end
  -- ...Ligand segment numbers are always after the protein segment numbers.

  ---------------------------------------------------------
  -- The following variables are sorted
  -- alphabetically as much as possible...
  ---------------------------------------------------------
  
	g_bBetterRecentBest = false
  -- Used in NormalConditionChecking_TemporarilyDisable() and NormalConditionChecking_ReEnable()...
	
	g_bFoundAHighGain = true
  -- Used in RebuildManySegmentRanges() and SaveBst()
	
	g_bFreeDesignPuzzle = false
	-- Used in DisplayPuzzleProperties()
  -- For informational display in log file only.
		
	g_bHasDensity = false
	-- Used in CheckForLowStartingScore() and DisplayPuzzleProperties()
	
	g_bHasLigand = (g_SegmentCount_WithoutLigands < g_SegmentCount_WithLigands)
	-- Used in Populate_g_ScorePartsTable() and DisplayPuzzleProperties()
	
	g_bMaxClashImportance = true
	-- Used in SetClashImportance() and WiggleSelected()
	
	g_bProbableSymmetryPuzzle = false
  -- Used in DisplayPuzzleProperties() -- for informational display in log file only.
  
	g_NumberOfMutableSegments = 0
	-- Used in DefineGlobalVariables(),
  --         AskUserToSelectRebuildOptions(),
  --         DisplayPuzzleProperties() and 
  --         MutateSideChainsOfSelectedSegments()
  
	g_bRebuildHelicesAndLoops = true 
  -- Used in Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable and 
  --         Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable
  -- Rebuild helix segments + surrounding loop segments.
  -- This is the only place g_bRebuildHelicesAndLoops is set.
	
  g_bRebuildSheetsAndLoops = false
  -- Used in Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable() and
  --         Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable()...
  -- Rebuild sheet segments + surrounding loop segments.
  -- This is the only place g_bRebuildSheetsAndLoops is set.
  
	g_bSavedSecondaryStructure = false
  -- Used in RebuildManySegmentRanges(),
  --         ConvertAllSegmentsToLoops() and
  --         CleanUp()...
  -- g_bSavedSecondaryStructure can only be set here and in ConvertAllSegmentsToLoops().
  
	g_bSketchBookPuzzle = false
  -- Used in DefineGlobalVariables(),
  --         DisplayPuzzleProperties(),
  --         AskUserToSelectRebuildOptions(),
  --         RebuildManySegmentRanges(),
  --         RebuildOneSegmentRangeManyTimes() and
  --         SaveBst()
  local l_PuzzleName = puzzle.GetName()  
  if string.find(l_PuzzleName, "Sketchbook") then
    g_bSketchBookPuzzle = true
	end
  
	g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = true
  -- Used in 7 functions...
	-- ...User can change this on the Select Rebuild Options page.
  --if g_bDebugMode == true then
  --  g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = false
  --end

	g_bUserSelected_ConvertAllSegmentsToLoops = true
  -- Remember loops are not helices. Loops are just plain swiggly lines...
  -- Used in AskUserToSelectRebuildOptions(), DisplayUserSelectedOptions() and RebuildManySegmentRanges()
	
	local l_NumberOfBands = band.GetCount()
	g_bUserSelected_DisableBandsDuringRebuild = l_NumberOfBands > 0
	-- Used in AskUserToSelectRebuildOptions() and RebuildSelectedSegments()
  -- Set default to true if there are any bands.
  
	g_bUserSelected_DuringFuseAndStabilizeShakeAndWiggleSelectedAndNearbySegments = false
  -- Used in AskUserToSelectRebuildOptions(), RebuildManySegmentRanges() and StabilizeSegmentRange()
  -- When set to false then include nearby segments.
  
	g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild = false
  -- Used in AskUserToSelectMoreOptions(), DisplayUserSelectedOptions() and
  --         RebuildOneSegmentRangeManyTimes()
  -- If the value of this variable is true the rebuild process will be very slow!
  
  g_bUserSelected_FuseBestScorePartPose = true
	-- Used in CheckForLowStartingScore(), AskUserToSelectMoreOptions(), DisplayUserSelectedOptions() and
	--         RebuildManySegmentRanges()
  
	g_bUserSelected_KeepDisulfideBondsIntact = false
	-- Used in AskUserToSelectRebuildOptions(), DisplayPuzzleProperties(),
  --         RebuildManySegmentRanges(), RebuildOneSegmentRangeManyTimes(), RebuildSelectedSegments(),
  --         DisulfideBonds_RememberSolutionWithThemIntact(), 
	--         DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact() and
  --         DisulfideBonds_DidAnyOfThemBreak()
  
	g_bUserSelected_Mutate_After_FuseBestScorePartPose = false
	-- Used in DefineGlobalVariables(), AskUserToSelectMutateOptions(), AskUserToSelectRebuildOptions() and
	--         RebuildManySegmentRanges()

	g_bUserSelected_Mutate_After_Rebuild = false
	-- Used in AskUserToSelectMutateOptions(), AskUserToSelectRebuildOptions(),
	--         RebuildOneSegmentRangeManyTimes()
  
	g_bUserSelected_Mutate_After_Stabilize = false
	-- Used in DefineGlobalVariables(), AskUserToSelectMutateOptions(), AskUserToSelectRebuildOptions() and
	--         RebuildManySegmentRanges()

	g_bUserSelected_Mutate_Before_FuseBestScorePartPose = false
  -- Used in AskUserToSelectRebuildOptions(), AskUserToSelectMutateOptions() and
  --         RebuildManySegmentRanges()
  
	g_bUserSelected_Mutate_During_Stabilize = false
  -- Used in AskUserToSelectRebuildOptions(), AskUserToSelectMutateOptions() and
  --         StabilizeSegmentRange()
  
	g_bUserSelected_Mutate_OnlySelected_Segments = false
  -- Used in AskUserToSelectRebuildOptions(), AskUserToSelectMutateOptions() and
  --         MutateSideChainsOfSelectedSegments()
  
	g_bUserSelected_Mutate_SelectedAndNearby_Segments = false
  -- Used in DefineGlobalVariables(), AskUserToSelectRebuildOptions(), AskUserToSelectMutateOptions() and
  -- MutateSideChainsOfSelectedSegments()
  
  g_bUserSelected_NormalStabilize = true
  --  Used in CheckForLowStartingScore(), AskUserToSelectMoreOptions(), DisplayUserSelectedOptions(),
  --  RebuildManySegmentRanges() and SaveBst()
  
	g_bUserSelected_PerformExtraStabilize = false
  -- Used in AskUserToSelectMoreOptions(), RebuildManySegmentRanges() and StabilizeSegmentRange()
  
	g_bUserSelected_SelectAllScorePartsForStabilize = true
  -- Used in AskUserToSelectRebuildOptions
  
	g_bUserSelected_SelectMain4ScorePartsForStabilize = false
  -- Used in AskUserToSelectRebuildOptions()
  
  g_bUserSelected_SelectScorePartsForStabilize = false
  -- Used in AskUserToSelectRebuildOptions()
  
	g_DensityWeight = 0
	-- Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(),
	--         CheckForLowStartingScore() and DisplayPuzzleProperties()
  
	g_LastSegmentScore = 0
  -- Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()
  
  g_OriginalNumberOfDisulfideBonds = 0
	-- Used in Populate_g_CysteineSegmentsTable(), Populate_g_ActiveScorePartsTable(), 
	--         AskUserToSelectRebuildOptions(), DisplayPuzzleProperties() and
	--         DisulfideBonds_DidAnyOfThemBreak()

	g_CurrentRebuildPointsGained = 0
	-- Used in bSegmentIsAllowedToBeRebuilt() and RebuildManySegmentRanges()
  
	g_QuickSaveStackPosition = 60 -- Uses slot 60 and higher...
  -- Used in QuickSaveStack_SaveCurrentSolution(),
  --         QuickSaveStack_LoadLastSavedSolution() and
  --         QuickSaveStack_RemoveLastSavedSolution()
  
	g_RebuildClashImportance = 0
	-- Used in RebuildOneSegmentRangeManyTimes()
  -- Clash importance value to use during the rebuild step.
  -- Always set to 0, so we really don't need it. 
  
  g_round_x_of_y = "" -- For log file reporting; Example: " round 1 of 10"
  -- Used in RebuildManySegmentRanges(),
  --         RebuildOneSegmentRangeManyTimes(),
  --         RebuildSelectedSegments(), 
  --         ShakeSelected() and
  --         MutateSideChainsOfSelectedSegments()

  g_RunCycle = 0
  -- Used in main() and
  --         RebuildManySegmentRanges(),
 	
	g_Score_AtStartOf_Script = Score()
	-- Used in CleanUp()...
  
  g_Score_ScriptBest = Score()
  -- Used in SaveBst() and many others...
  
  g_ScorePartText = "" -- Example: " ScorePart 4 (total)", " ScorePart 6 (ligand) 6=7=11" 
  
  g_ScriptStartTime = os.clock()
  
  g_Stats_Run_StartTime = os.clock()
  g_Stats_Run_EndTime = os.clock()
  
  g_Stats_Run_TotalSecondsUsed_RebuildSelected = 0.0001 -- prevent divide by zero error
  g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected = 0.0001
  g_Stats_Run_TotalSecondsUsed_WiggleSelected = 0.0001
  g_Stats_Run_TotalSecondsUsed_WiggleAll = 0.0001
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected = 0.0001
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll = 0.0001

  g_Stats_Script_TotalSecondsUsed_RebuildSelected = 0
  g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected = 0
  g_Stats_Script_TotalSecondsUsed_WiggleSelected = 0
  g_Stats_Script_TotalSecondsUsed_WiggleAll = 0
  g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected = 0
  g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll = 0
  
  g_Stats_Run_TotalPointsGained_RebuildSelected = 0
  g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected = 0
  g_Stats_Run_TotalPointsGained_WiggleSelected = 0
  g_Stats_Run_TotalPointsGained_WiggleAll = 0
  g_Stats_Run_TotalPointsGained_MutateSidechainsSelected = 0
  g_Stats_Run_TotalPointsGained_MutateSidechainsAll = 0
  
  g_Stats_Script_TotalPointsGained_RebuildSelected = 0
  g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected = 0
  g_Stats_Script_TotalPointsGained_WiggleSelected = 0
  g_Stats_Script_TotalPointsGained_WiggleAll = 0
  g_Stats_Script_TotalPointsGained_MutateSidechainsSelected = 0
  g_Stats_Script_TotalPointsGained_MutateSidechainsAll = 0  
  
  g_Stats_Run_SuccessfulAttempts_RebuildSelected = 0
  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected = 0
  g_Stats_Run_SuccessfulAttempts_WiggleSelected = 0
  g_Stats_Run_SuccessfulAttempts_WiggleAll = 0
  g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected = 0
  g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll = 0
  
  g_Stats_Script_SuccessfulAttempts_RebuildSelected = 0
  g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected = 0
  g_Stats_Script_SuccessfulAttempts_WiggleSelected = 0
  g_Stats_Script_SuccessfulAttempts_WiggleAll = 0
  g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected = 0
  g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll = 0
  
  g_Stats_Run_NumberOfAttempts_RebuildSelected = 0.1 -- prevent divide by zero error
  g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected = 0.1
  g_Stats_Run_NumberOfAttempts_WiggleSelected = 0.1
  g_Stats_Run_NumberOfAttempts_WiggleAll = 0.1
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected = 0.1
  g_Stats_Run_NumberOfAttempts_MutateSidechainsAll = 0.1    
	
  g_Stats_Script_NumberOfAttempts_RebuildSelected = 0
  g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected = 0
  g_Stats_Script_NumberOfAttempts_WiggleSelected = 0
  g_Stats_Script_NumberOfAttempts_WiggleAll = 0
  g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected = 0
  g_Stats_Script_NumberOfAttempts_MutateSidechainsAll = 0
  
	g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle = 1
	-- Used in AskUserToSelectMoreOptions() and main()
  
	g_UserSelected_AfterRebuild_ShakeSegmentRange_ClashImportance = 0.31
  -- Used in AskUserToSelectMoreOptions(),
  --         DisplayUserSelectedOptions() and
  --         RebuildOneSegmentRangeManyTimes()
  -- Clash imortance to use while shaking

	g_UserSelected_ClashImportanceFactor = behavior.GetClashImportance()
	-- Used in DefineGlobalVariables(), SetClashImportance() and AskUserToCheckClashImportance()
	-- Set Clash Importance Factor...
	-- note: we don't actually have a g_ClashImportance variable,
	--       we only have a g_UserSelected_ClashImportanceFactor variable.
	--       we do, however, have an l_ClashImportance variable in function SetClashImportance() above.
	-- print("behavior.GetClashImportance()=[" .. g_UserSelected_ClashImportanceFactor .. "].")
	if g_UserSelected_ClashImportanceFactor < 0.99 then
		CheckCI() -- now AskUserToCheckClashImportance()
	end
  
	g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle = 0 -- was reBuild
  -- see main() for definition
  -- Used in main(), Populate_g_XLowestScoringSegmentRangesTable(),
  -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
	-- Yah, not really convinced this one helps yet.
  
	g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
	-- Used in DefineGlobalVariables(), AskUserToSelectMoreOptions() and RebuildManySegmentRanges()
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan < 10000 then
		g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan = 10000 -- was 40
	end
  --if g_bDebugMode == true then
  --  g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan = 10000
  --end
  
	g_UserSelected_Mutate_ClashImportance = 0.9
	-- Used in MutateSideChainsOfSelectedSegments() and 
  --         AskUserToSelectMutateOptions()

	g_UserSelected_Mutate_SphereRadius = 8 -- Angstroms
	-- Used in MutateSideChainsOfSelectedSegments(),
  --         AskUserToSelectMutateOptions() and 
  --         AskUserToSelectRebuildOptions()

	g_UserSelected_NumberOfSegmentRangesToSkip = 0 -- set to any value other than 0, to debug related code
	-- Used in DisplayUserSelectedOptions(), AskUserToSelectRebuildOptions() and main()
  
	g_UserSelected_NumberOfRunCycles = 5 -- 10 is plenty, 5 is usually enough for most tests
  -- Set it very high if you want to run forever
	-- Used in AskUserToSelectRebuildOptions(), RebuildSelectedSegments(),
	--         PrepareToRebuildSegmentRanges() and main()
  if g_bDebugMode == true then
    g_UserSelected_NumberOfRunCycles = 5 -- is high enough for debug mode
  end

	g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle = 10 -- set to at least 10
	-- Used in AskUserToSelectMoreOptions(), RebuildSelectedSegments() and RebuildOneSegmentRangeManyTimes()

	g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 
    g_SegmentCount_WithLigands
	-- Used in DefineGlobalVariables(), bSegmentIsAllowedToBeRebuilt() and DisplayUserSelectedOptions()
	-- Default to one point per segment? Seems pretty arbitrary to me...
	-- Example:
	-- g_SegmentCount_WithoutLigands = 135
	-- g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 135
  -- ...Pretty simple formula
	if g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan >
    500 then
		g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 500
	end
  
	g_UserSelected_ResetToStartValueAfterRebuildingWithThisManyConsecutiveSegments = 4 -- was maxLen
	-- Used in AskUserToSelectRebuildOptions(), RebuildSelectedSegments() and 
	--         PrepareToRebuildSegmentRanges()
  -- ...any more than 4 consecutive segments does not appear to be fruitful;
  -- Actually, 4 consecutive segments is not great.
  -- And, 3 consecutive segments is barely better then 4.
  -- Really, most of the gains are with just 2 consecutive segments!
  
 	g_UserSelected_SketchBookPuzzle_MinimumGainForSave = 0
  -- Used in AskUserToSelectRebuildOptions() and SaveBst()

	g_UserSelected_SkipFuseBestScorePartPose_IfCurrentRebuild_LosesMoreThan = 
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
	-- Used in DefineGlobalVariables(), AskUserToSelectMoreOptions() and RebuildManySegmentRanges()
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_SkipFuseBestScorePartPose_IfCurrentRebuild_LosesMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_SkipFuseBestScorePartPose_IfCurrentRebuild_LosesMoreThan < 30 then
		g_UserSelected_SkipFuseBestScorePartPose_IfCurrentRebuild_LosesMoreThan = 30
	end
  
	g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle = 4
	-- Used in DefineGlobalVariables(), AskUserToSelectMoreOptions(),
  --         PrepareToRebuildSegmentRanges() and main()
  
	-- ConsecutiveSegments is the number of adjacent segments required per segment range.
	-- Example:
	--  If the entire protein's segments (amino acid sequence) are numbered like this:
	--  {1,2,3,4,5,6,7,8,9, ... 134, 135}
	--  We rebuild/shake/wiggle the protein in small chunks called segment ranges.
	--  If our RequiredNumberOfConsecutiveSegments is 2, then our segment ranges will look like this:
	--  {{1-2},{2-3},{3-4},{4-5} ... {134-135}},
	--  We start our rebuild/shake/wiggle process with only segments 1 and 2,
	--  next, we rebuild/shake/wiggle segments 2 and 3,
	--  then, we rebuild/shake/wiggle segments 3 and 4, and so on...
	--  After rebuilding segment ranges with 2 consecutive segments we increment
	--  g_RequiredNumberOfConsecutiveSegments by 1, to 3 consecutive segments.
	--  Now our segment ranges look like this: {{1-3},{2-4},{3-5},{4-6} ... {133-135}}
	--  Next, we rebuild/shake/wiggle segments 1, 2 and 3,
	--  then rebuild/shake/wiggle segments 2, 3 and 4, and so on...
	--  After rebuilding segment ranges with 3 consecutive segments we once again increment
	--  g_RequiredNumberOfConsecutiveSegments by 1, to 4 consecutive segments.
	--  Because g_UserSelected_ResetToStartValueAfterRebuildingWithThisManyConsecutiveSegments = 4,
  --  this will be the final segment range configuration, and will look like this:
  --  {{1-4},{2-5},{3-6},{4-7} ... {132-135}}
	
	g_UserSelected_StartRebuildingWithThisManyConsecutiveSegments = 2 -- was minLen
	-- Used in DefineGlobalVariables(), Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--         Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(),
	--         AskUserToSelectRebuildOptions() and PrepareToRebuildSegmentRanges()
  
	g_UserSelected_WiggleFactor = 1
  -- Used in AskUserToSelectRebuildOptions(), DisplayUserSelectedOptions() and WiggleSelected()

  -- ...end of global variables sorted alphabetically as much as possible.

  g_with_segments_x_thru_y = "" -- For log file reporting; Example: " w/segments 1-3"
  -- Used in RebuildManySegmentRanges(), RebuildOneSegmentRangeManyTimes(), RebuildSelectedSegments(), 
  --         ShakeSelected() and MutateSideChainsOfSelectedSegments()

  ---------------------------------------------------------
  -- The following are conditional overrides
  -- or otherwise computed variables...
  ---------------------------------------------------------

	--g_NumberOfMutableSegments = GetNumberOfMutableSegments()
  g_NumberOfMutableSegments = 1
	if g_NumberOfMutableSegments > 0 then
		g_bUserSelected_Mutate_After_FuseBestScorePartPose = true -- was set to false by default above
		g_bUserSelected_Mutate_After_Stabilize = true -- was set to false by default above
		-- user can decide!!! g_bUserSelected_Mutate_SelectedAndNearby_Segments = true
    --                    was set to false by default above
	end
	if g_bSketchBookPuzzle == true then
	   g_bUserSelected_ConvertAllSegmentsToLoops = false -- was set to true by default above
	   g_bUserSelected_FuseBestScorePartPose = false -- was set to true by default above
	   g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 500
    -- ... was set to g_SegmentCount_WithLigands by default above
	end
  if g_bDebugMode == true then
    g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 50
  end  
  
	g_RequiredNumberOfConsecutiveSegments = 
    g_UserSelected_StartRebuildingWithThisManyConsecutiveSegments
	--  Used in AskUserToSelectRebuildOptions(), RebuildSelectedSegments() and
	--          PrepareToRebuildSegmentRanges()
  
	g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = {{1, g_SegmentCount_WithoutLigands}}
  -- ...was WORKON[]
  -- testing...
  -- g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = {{1, g_SegmentCount_WithLigands}}
    -- See usage of g_UserSelected_SegmentRangesAllowedToBeRebuiltTable above in table definition section.
  
  ------------------------------------------------------------
  -- The remaining lines of this function are related to 
  -- Condition Checking, and are not sorted alphabetically...  
  ------------------------------------------------------------
  ------------------------------------------------------------
	-- Start of Temporarily Disable Condition Checking module...
  ------------------------------------------------------------
-- Temporarily disable normal condition checking...
	if g_bSketchBookPuzzle == false then
    -- Could probably just call NormalConditionChecking_TemporarilyDisable() here...
    
    -- Disable normal condition checking to get current score + potential bonus points.
    -- This assumes the conditions for getting bonus points are not yet met. And this is normally
    -- true when this is the first time working on this puzzle. However, if we have already been
    -- working on this puzzle and have already met the conditions for getting the bonus points,
    -- this is will just get the current score.
    
		behavior.SetFiltersDisabled(true) -- Disable condition checking to get current score w/bonus points.
    
    -- ...enables faster CPU processing, but your score improvements are not saved to foldit.
	end

	local l_CurrentPoseTotalScoreWithPotentialBonusPoints = Score()
    
  -- debugging...
  --l_CurrentPoseTotalScoreWithPotentialBonusPoints =
  --  l_CurrentPoseTotalScoreWithPotentialBonusPoints + 500
	  
	-- Re-enable normal condition checking...
	if g_bSketchBookPuzzle == false then
    -- Could probably just call NormalConditionChecking_ReEnable() here...
		behavior.SetFiltersDisabled(false) -- Disables faster CPU processing, so your score 
    --                                    improvements will be saved to foldit's undo history.
	end
	
	local l_Score_WithNormalConditionChecking_Enabled = Score()
		
  -- Compute the maximum potential bonus points (not available in beginner puzzles)
	g_ComputedMaximumPotentialBonusPoints = 
    l_CurrentPoseTotalScoreWithPotentialBonusPoints - l_Score_WithNormalConditionChecking_Enabled 
  -- Used in DefineGlobalVariables() and DisplayPuzzleProperties()
		
  g_UserSelected_MaximumPotentialBonusPoints = g_ComputedMaximumPotentialBonusPoints
  --  Used in AskUserToSelectNormlConditionCheckingOptions() and SaveBst()
	
	g_bUserSelected_NormalConditionChecking_TemporarilyDisable = false --i.e.Enable Normal Condition Checking
	--  Used in DefineGlobalVariables(), CleanUp(), SaveBst() and
  --          AskUserToSelectNormlConditionCheckingOptions()
	-- ...enables faster CPU processing, but your score improvements will not be counted in foldit's Undo
  --    history.
  
  if math.abs(g_UserSelected_MaximumPotentialBonusPoints) > 0.1 then
    
		print("\nPotential score, including bonus points," ..
           " when and if bonus conditions are met: " ..
             PrettyNumber(l_CurrentPoseTotalScoreWithPotentialBonusPoints) ..
          "\n - Actual score right now: " ..
             PrettyNumber(l_Score_WithNormalConditionChecking_Enabled) ..
          "\n = Potential bonus points to gain," ..
           " when and if bonus conditions are met: " ..
             g_UserSelected_MaximumPotentialBonusPoints)
		
		g_bUserSelected_NormalConditionChecking_TemporarilyDisable = true
    
		-- Ask user to verify maximum potential bonus points...
		AskUserToSelectNormlConditionCheckingOptions()
	end
  
	if g_bUserSelected_NormalConditionChecking_TemporarilyDisable == true then
		NormalConditionChecking_TemporarilyDisable()
	end
  -----------------------------------------------------------
	-- ...end of Temporarily Disable Condition Checking module.
  -----------------------------------------------------------

end -- DefineGlobalVariables()
function SetupLocalDebugFuntions()
  -- Called from DefineGlobalVariables()...

	-- All of the following built-in FoldIt Lua functions are described here:
	-- https://foldit.fandom.com/wiki/Foldit_Lua_Functions
	
	math.randomseed (os.time ()) -- this must be done or our random numbers will never change...
	function RandomCharOfString(s)
		local r = math.random(#s) -- e.g.; math.random (5)  --> an integer number from 1 to 5
		return s:sub(r, r) -- e.g.; string.sub ("ABCDEF", 2, 2)  --> "B"
	end
	
	function RandomFloat(l_Min, l_Max) -- e.g.; RandomFloat(3, 9) --> 4.30195013275552
		l_RandomFloat = math.random() * (l_Max - l_Min) + l_Min
		return l_RandomFloat
	end

 -- g_Debug_CurrentEnergyScore provides some control over current score during debug...
 -- g_Debug_CurrentEnergyScore goes up and down randomly after each call to:
 --   MutateSidechainsSelected, MutateSidechainsAll, RebuildSelected, 
 --   ShakeSidechainsAll, ShakeSidechainsSelected, 
 --   WiggleAll and WiggleSelected...
	g_Debug_CurrentEnergyScore = -999999
  g_Debug_ScriptBestEnergyScore = g_Debug_CurrentEnergyScore
  g_Debug_QuickSaveEnergyScore = {}
	
	current = {}
 	pose = {} -- same structure as "current" above
 	recentbest = {} --

  current.RandomlyChange_g_Debug_CurrentEnergyScore = function()
    -- This is not a foldit function. This function is only
    -- used by the following debug version of the foldit functions:    --
    -- MutateSidechainsSelected,MutateSidechainsAll,RebuildSelected,ShakeSidechainsAll,
    -- ShakeSidechainsSelected,WiggleAll,WiggleSelected    
    
		-- Time to get a new random score..
		local l_EnergyScore = RandomFloat(-10000, 10000)    
    
		if l_EnergyScore > g_Debug_ScriptBestEnergyScore then
      
			-- Only allow small incremental improvements...
			if g_Debug_ScriptBestEnergyScore ~= -999999 then -- allow the first score to be whatever.
				if l_EnergyScore - g_Debug_ScriptBestEnergyScore > 100 then
					l_EnergyScore = g_Debug_ScriptBestEnergyScore + RandomFloat(0, 100)
				end
			end
      
      g_Debug_ScriptBestEnergyScore = l_EnergyScore
      
    end
      
		g_Debug_CurrentEnergyScore = l_EnergyScore
    
  end
  
	current.GetEnergyScore = function()
		-- Returns the overall score for the current pose of the protein...
		-- In production the score depends on whether condition checking is enabled or
    -- disabled (behavior.GetFiltersDisabled); however, in development, enabling or
    -- disabling condition checking does not affect the score...
		return g_Debug_CurrentEnergyScore      
	end
 	pose.GetEnergyScore = function()
		return g_Debug_CurrentEnergyScore
	end
  recentbest.GetEnergyScore = function()
    -- g_Debug_ScriptBestEnergyScore is always the best (although not
    -- necessarily the most recent. Well, it's close enough for debugging.)
    g_Debug_CurrentEnergyScore = g_Debug_ScriptBestEnergyScore
    return g_Debug_CurrentEnergyScore
  end
  
	current.GetSegmentEnergyScore = function(l_SegmentIndex)    
		local l_SegmentEnergyScore
		l_SegmentEnergyScore = RandomFloat(-10, 10) -- was (-200, 200)
		return l_SegmentEnergyScore
	end
	pose.GetSegmentEnergyScore = function(l_SegmentIndex)
    return current.GetSegmentEnergyScore(l_SegmentIndex) -- same as above
	end
  
	current.GetSegmentEnergySubscore = function(l_SegmentIndex, l_ScorePart)
		local l_SegmentEnergySubscore
			
		l_ScorePart = string.lower(l_ScorePart)
		if l_ScorePart == "disulfides" then
			l_SegmentEnergySubscore = "-0"
		elseif l_ScorePart == "reference" then
			l_SegmentEnergySubscore = "0.1"
		else
			l_SegmentEnergySubscore = RandomFloat(-1, 1)
		end
		return l_SegmentEnergySubscore
  end
	pose.GetSegmentEnergySubscore = function(l_SegmentIndex, l_ScorePart)
    return current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart) -- same as above
	end
	
	recentbest.Restore = function()
    -- g_Debug_ScriptBestEnergyScore is always the best (although not
    -- necessarily the most recent. Well, it's close enough for debugging.)
    g_Debug_CurrentEnergyScore = g_Debug_ScriptBestEnergyScore
	end
	recentbest.Save = function()
    -- We already save the recent best as g_Debug_ScriptBestEnergyScore. Well, recent enough.
	end
  
	band = {}
	band.DisableAll = function() end
	band.EnableAll = function() end
	band.GetCount = function()
		l_BandCount = math.random(20) --> an integer number from 1 to 20
		return l_BandCount
	end
	behavior = {}
  g_Debug_ClashImportance = -1 -- -1 forces it to get a new (positive) value 
  --                               at first call to behavior.GetClashImportance.
	behavior.GetClashImportance = function()
    
		-- local l_ClashImportance = 1
    if g_Debug_ClashImportance >=0 then
      return g_Debug_ClashImportance
    end

    -- Let first value be whatever...
		g_Debug_ClashImportance = math.random()
		if g_Debug_ClashImportance > .7 then
			-- Give 1 a better chance...
			g_Debug_ClashImportance = 1
		end
		
		return g_Debug_ClashImportance
	end
	behavior.SetClashImportance = function(l_ClashImportance)
    g_Debug_ClashImportance = l_ClashImportance
    return
  end
	behavior.SetFiltersDisabled = function(l_TrueOrFalse) return end
  
  -- currently not used...
	--   help
	--   absolutebest.GetEnergyScore
	--   absolutebest.GetSegmentEnergyScore
	--   absolutebest.GetSegmentEnergySubscore
	--   absolutebest.Restore -- could be helpful
	--   band.GetLength=function() return math.random() * math.random(-5, 5) --> -5 <= x < 5 end
	--   band.Add, band.Delete, band.DeleteAll
	--   band.AddBetweenSegments, band.AddToBandEndpoint
	--   band.Enable, band.IsEnabled, band.Disable,
	--   band.SetGoalLength, band.GetGoalLength,
	--   band.SetStrength, band.GetStrength
	--   behavior.GetFiltersDisabled
	--   behavior.SetWigglePower, behavior.GetWigglePower
	--   behavior.HighPowerAllowed
	--   contactmap.GetHeat = function(l_Segment1, l_Segment2) return l_HeatOfTwoSegments end
	--   contactmap.IsContact = function(l_Segment1, l_Segment2) return b_TwoSegmentsAreInContact end
	--   creditbest.AreConditionsMet
	--   creditbest.GetEnergyScore
	--   creditbest.GetSegmentEnergyScore
	--   creditbest.GetSegmentEnergySubscore
	--   creditbest.Restore -- maybe helpful
  --   current.AreConditionsMet -- should we use this?
	--   recentbest.GetSegmentEnergyScore
	--   recentbest.AreConditionsMet
	--   recentbest.GetSegmentEnergySubscore

	dialog = {}
	--local l_bDebugMenus = true -- allows debugging menus locally
	local l_bDebugMenus = false
	dialog.AddButton = function(l_ButtonText, l_ButtonValue)
		if l_bDebugMenus == true then
			print("  AddButton:" .. l_ButtonText .. "," .. tostring(l_ButtonValue))
		end
		return {value = l_ButtonValue}
	end
	dialog.AddCheckbox = function(l_CheckBoxText, l_bCheckBoxTrueFalse)
		if l_bDebugMenus == true then
			print("  AddCheckbox:" .. l_CheckBoxText .. "," .. tostring(l_bCheckBoxTrueFalse))
		end
		return {value = l_bCheckBoxTrueFalse}
	end
	dialog.AddLabel = function(l_LabelText)
		if l_bDebugMenus == true then
			print("  AddLabel:" .. l_LabelText)
		end
		return 0
	end
	dialog.AddSlider =
		function(l_SliderText, l_NumberValue, l_NumberMinimum, l_NumberMaximum, l_NumberPrecision)
		if l_bDebugMenus == true then
			print("  AddSlider:" .. l_SliderText .. "," .. l_NumberValue .. "," .. l_NumberMinimum ..
				"," .. l_NumberMaximum .. "," .. l_NumberPrecision)
		end
		return {value = l_NumberValue}
	end
	dialog.AddTextbox = function(l_TextBoxTitle, l_TextBoxValue)
		if l_bDebugMenus == true then
			print("  AddTextbox:" .. l_TextBoxTitle .. "," .. l_TextBoxValue)
		end
		return {value = l_TextBoxValue}
	end
	dialog.CreateDialog = function(l_DialogTitle)
		if l_bDebugMenus == true then
			print("\nCreateDialog:" .. l_DialogTitle)
		end
		local l_DialogTable = {}
		return l_DialogTable
	end
	dialog.Show = function(l_DialogTable)
		local l_ButtonClicked = 1
		return l_ButtonClicked
	end

  -- currently not used...
  --   filter.AreAllEnabled
	--   filter.ConditionSatisfied
	--   filter.IsEnabled, filter.Enable, filter.EnableAll, filter.Disable, filter.DisableAll
	--   filter.GetBonus, filter.GetBonusTotal
	--   filter.GetNames, filter.GetEnabledNames, filter.GetDisabledNames
	--   filter.HasBonus

	freeze = {}
  
  g_Debug_bBackboneIsFrozen = {}
  g_Debug_bSideChainIsFrozen = {}
	freeze.IsFrozen = function(l_SegmentIndex)
   local l_bBackboneIsFrozen
    if g_Debug_bBackboneIsFrozen[l_SegmentIndex] == nil then
      if g_Debug_bIsMutable[l_SegmentIndex] == true or
         --g_Debug_bIsLocked[l_SegmentIndex] == true or
         g_Debug_bIsLigand[l_SegmentIndex] == true then
        -- Since it is already something else, set this one to false...
        g_Debug_bBackboneIsFrozen[l_SegmentIndex] = false
      else
        l_bBackboneIsFrozen = math.random(10) == 1 -- 1 in 10 random chance of being frozen
        g_Debug_bBackboneIsFrozen[l_SegmentIndex] = l_bBackboneIsFrozen
      end
    else
      l_bBackboneIsFrozen = g_Debug_bBackboneIsFrozen[l_SegmentIndex]
    end
   local l_bSideChainIsFrozen
    if g_Debug_bSideChainIsFrozen[l_SegmentIndex] == nil then
      if g_Debug_bIsMutable[l_SegmentIndex] == true or
         --g_Debug_bIsLocked[l_SegmentIndex] == true or
         g_Debug_bIsLigand[l_SegmentIndex] == true then
        -- Since it is already something else, set this one to false...
        g_Debug_bSideChainIsFrozen[l_SegmentIndex] = false
      else
        l_bSideChainIsFrozen = math.random(10) == 1 -- 1 in 10 random chance of being frozen
        g_Debug_bSideChainIsFrozen[l_SegmentIndex] = l_bSideChainIsFrozen
      end
    else
      l_bSideChainIsFrozen = g_Debug_bSideChainIsFrozen[l_SegmentIndex]
    end
		return l_bBackboneIsFrozen, l_bSideChainIsFrozen
	end
  
	-- currently not used...
	--   freeze.Freeze, freeze.FreezeAll, freeze.FreezeSelected, freeze.Unfreeze, freeze.UnfreezeAll
	--   freeze.GetCount = fuction() return(l_NumSegsWithFrozenBackbone,l_NumSegsWithFrozenSidechain) end

	puzzle = {}
	--puzzle.GetPuzzleScorePartNames <-- should have been called this. Oh well. Noboby's perfect :-)
	puzzle.GetPuzzleSubscoreNames = function() -- "SubscoreName" here really means "ScorePart_Name".
		l_PuzzleScorePart_Names =
		{
			"Clashing",
			"Pairwise",
			"Packing",
			"Hiding",
			"Bonding",
			"Ideality",
			-- 7 = "Other Bonding",
			"Backbone",
			"Sidechain",
			"Disulfides",
			"Reference"
			-- 12 = "Structure",
			-- 13 = "Holes",
			-- 14 = "Surface Area",
			-- 15 = "Interchain Docking",
			-- 16 = "Neighbor Vector",
			-- 17 = "Symmetry",
			-- 18 = "Van der Waals",
			-- 19 = "Density",
			-- 20 = "Other"
		}
		return l_PuzzleScorePart_Names
	end
	puzzle.GetName = function ()
		l_PuzzleName = "1458: Small Monomer Design"
		return l_PuzzleName
	end
	puzzle.GetDescription = function ()
		l_PuzzleDescription = "This puzzle challenges players to design a protein with 65-75 residues. "
		return l_PuzzleDescription
	end
	puzzle.GetPuzzleID = function()
		l_PuzzleID = "2008367"
		return l_PuzzleID
	end
  
	-- currently not used...
	--   puzzle.GetExpirationTime,
	--   puzzle.GetStructureName
	--   puzzle.StartOver -- cound be useful!
	--   recipe.CompareNumbers -- might be useful, if it's what I think it is. Reliably work w/floats?
	--   recipe.GetRandomSeed -- does not work properly on Windows OS
	--   rotamer.GetCount
	--   rotamer.SetRotamer
  
  recipe = {}
  recipe.SectionStart = function () end -- no good. Does not allow capturing the results, only prints it;
  --                                       doesn't include time spent on anything!  
  recipe.ReportStatus = function () end
  recipe.SectionEnd = function () end 

	save = {}
   -- Called from 11 places...
	save.Quickload = function(l_IntegerSlot)
    -- simply brilliant...
    g_Debug_CurrentEnergyScore = g_Debug_QuickSaveEnergyScore[l_IntegerSlot]
    return
  end
  -- Called from 13 places...
	save.Quicksave = function(l_IntegerSlot)
    g_Debug_QuickSaveEnergyScore[l_IntegerSlot] = g_Debug_CurrentEnergyScore
    return
  end 
	save.LoadSecondaryStructure = function() return end -- Called from 2 places
	save.SaveSecondaryStructure = function() return end -- Called from 1 place
  
	-- currently not used...
	--   save.GetSolutions - could be useful.
	--   save.LoadSolution
	--   save.LoadSolutionByName
	--   save.QuicksaveEmpty
	--   save.SaveSolution
	--   scoreboard.GetGroupRank, scoreboard.GetGroupScore
	--   scoreboard.GetRank, scoreboard.GetScore, scoreboard.GetScoreType

  selection = {}
	selection.DeselectAll = function() return end
  g_Debug_bIsSelected = {}
	selection.IsSelected = function(l_SegmentIndex)
		local l_bIsSelected
    if g_Debug_bIsSelected[l_SegmentIndex] == nil then
      -- if not already set, then set it to a random value...
      l_bIsSelected = math.random(10) == 1 -- 1 in 10 random chance of being selected
      g_Debug_bIsSelected[l_SegmentIndex] = l_bIsSelected
    else
      -- if it's already set, then just return its value...
      l_bIsSelected = g_Debug_bIsSelected[l_SegmentIndex]
    end
		return l_bIsSelected
	end
	selection.Select = function(l_SegmentIndex) return end
	selection.SelectAll = function() return end
	selection.SelectRange = function(l_StartSegment, l_EndSegment) return end
	
  -- currently not used...
	--   selection.Deselect
	--   selection.GetCount
	
	structure = {}
	structure.GetAminoAcid = function(l_SegmentIndex)
		l_AminoAcids = 'wifpylvmkchardentsqg'  
		l_RandomAminoAcid = RandomCharOfString(l_AminoAcids)
		if 1 == 1 then
			return l_RandomAminoAcid
		end
		
	end
	structure.GetCount = function()
		 l_RandomCount = math.random(80, 180)
		 return l_RandomCount
	end
	structure.GetDistance = function(x,i)
		l_Distance = math.random(80) -- in angstroms
		return l_Distance
	end
  
  g_Debug_GetSecondaryStructure = {}
  g_Debug_bIsLigand = {}
  g_Debug_bGetSecondaryStructureFirstTime = true
	structure.GetSecondaryStructure = function(l_SegmentIndex)
    if g_Debug_bGetSecondaryStructureFirstTime == true then
      g_Debug_bGetSecondaryStructureFirstTime = false
      local l_RandomishNumber = math.random(0, 30)
      --g_SegmentCount_WithoutLigands = g_SegmentCount_WithLigands - l_RandomishNumber
    end
      
		local l_bIsLigand = false
    local l_RandomSecondaryStructure
    if g_Debug_GetSecondaryStructure[l_SegmentIndex] == nil then
      --if l_SegmentIndex > g_SegmentCount_WithoutLigands then
      --  l_RandomSecondaryStructure = 'M' -- 'M' for Molecule
      --  l_bIsLigand = true
      --  g_SegmentCount_WithoutLigands = g_SegmentCount_WithoutLigands + 1
      --else
        l_SecondaryStructures = 'HELLLLLLLL' -- H=Helix, E=Sheet, L=Loop, M=Ligand
        l_RandomSecondaryStructure = RandomCharOfString(l_SecondaryStructures)
        -- For more realistic looking fake data, if the segment is not a ligand (already
        -- checked above) we only allow a segment to be either a Frozen, a Locked or a 
        -- Mutable segment. We do not allow them to be any two or more of these at the same
        -- time. In reality, I think any segment could be any one attribute and also be
        -- Frozen and/or Locked at the same time, but we'll ignore that for now. 
      --end
      g_Debug_GetSecondaryStructure[l_SegmentIndex] = l_RandomSecondaryStructure
      g_Debug_bIsLigand[l_SegmentIndex] = l_bIsLigand
    else
      l_RandomSecondaryStructure = g_Debug_GetSecondaryStructure[l_SegmentIndex]
    end
    return l_RandomSecondaryStructure
	end
  
  g_Debug_bIsLocked = {}
 	structure.IsLocked = function(l_SegmentIndex)
    local l_bIsLocked
    if g_Debug_bIsLocked[l_SegmentIndex] == nil then
      if g_Debug_bIsMutable[l_SegmentIndex] == true or
         --g_Debug_bBackboneIsFrozen[l_SegmentIndex] == true or
         --g_Debug_bSideChainIsFrozen[l_SegmentIndex] == true or
         g_Debug_bIsLigand[l_SegmentIndex] == true then
        -- Since it is already something else, set this one to false...
        g_Debug_bIsLocked[l_SegmentIndex] = false
      else
        l_bIsLocked = math.random(10) == 1 -- 1 in 10 random chance of being locked
        g_Debug_bIsLocked[l_SegmentIndex] = l_bIsLocked
      end
    else
      l_bIsLocked = g_Debug_bIsLocked[l_SegmentIndex]
    end
    return l_bIsLocked
  end 
  
  g_Debug_bIsMutable = {}
	structure.IsMutable = function(l_SegmentIndex)
    local l_bIsMutable
    if g_Debug_bIsMutable[l_SegmentIndex] == nil then
      if g_Debug_bBackboneIsFrozen[l_SegmentIndex] == true or
         g_Debug_bSideChainIsFrozen[l_SegmentIndex] == true or
         g_Debug_bIsLocked[l_SegmentIndex] == true or
         g_Debug_bIsLigand[l_SegmentIndex] == true then
        -- Since it is already something else, set this one to false...
        g_Debug_bIsMutable[l_SegmentIndex] = false
      else
        l_bIsMutable = math.random(10) == 1 -- 1 in 10 random chance of being mutable
        g_Debug_bIsMutable[l_SegmentIndex] = l_bIsMutable
      end
    else
      l_bIsMutable = g_Debug_bIsMutable[l_SegmentIndex]
    end
    return l_bIsMutable
  end 
	structure.MutateSidechainsAll = function(l_Iterations) 
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
  end
	structure.MutateSidechainsSelected = function(l_Iterations) 
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
  end
	structure.RebuildSelected = function(l_Iterations)
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	structure.SetSecondaryStructureSelected = function(l_StringSecondaryStructure) return end
	structure.ShakeSidechainsAll = function(l_Iterations)
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	structure.ShakeSidechainsSelected = function(l_Iterations)
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	structure.WiggleAll = function(l_Iterations,l_bBackbone,l_bSideChains)
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	structure.WiggleSelected = function(l_Iterations,l_bBackbone,l_bSideChains)
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
  
 	user = {}
	user.GetPlayerName = function() return "ProteinProgrammingLanguage" end

	-- currently not used...
	--   structure.CanMutate = function(l_SegmentIndex, l_AminoAcid)
	--   structure.DeleteCut = function(l_SegmentIndex)
	--   structure.DeleteResidue = function(l_SegmentIndex)
	--   structure.GetAtomCount = function(l_SegmentIndex) return math.random(8) end
	--   structure.GetNote = function(l_SegmentIndex)
	--   structure.GetSymCount = function() -- count be helpful
	--   structure.IdealizeSelected = function()  -- might be helpful
	--   structure.InsertCut = function(l_SegmentIndex)
	--   structure.InsertResidue = function(l_SegmentIndex)
	--   structure.IsHydrophobic = function(l_SegmentIndex) return math.random(2) == 1 end
	--   structure.LocalWiggleAll = function(l_Iterations, l_Backbone, l_Sidechains) -- how is this different
	--   structure.LocalWiggleSelected = function(l_Iterations, l_Backbone, l_Sidechains)
	--   structure.RemixSelected = function(integer l_StartQuicksave, l_NumResult)
	--   structure.SetAminoAcid = function(l_SegmentIndex, l_AminoAcid)
	--   structure.SetAminoAcidSelected = function(l_AminoAcid)
	--   structure.SetNote = function(l_SegmentIndex, l_Note)
	--   structure.SetSecondaryStructure = function(l_SegmentIndex, l_SecondaryStructure)
	--   ui.AlignGuide = function(l_SegmentIndex)
	--   ui.CenterViewport = function()
	--   ui.GetPlatform = function()
	--   ui.GetTrackName = function()
	--   undo.SetUndo = function(l_bEnable)
  --   user.GetGroupID = function()
	--   user.GetGroupName = function()
	--   user.GetPlayerID = function()
  
  -- Well, we gotta start somewhere, right...
  current.RandomlyChange_g_Debug_CurrentEnergyScore()

end -- function SetupLocalDebugFuntions()
function PaddedNumber(l_DirtyFloat, l_PadWidth, l_AfterDecimal)
  -- Called from ()...
  
  local l_PrettyString = string.format("%" .. l_PadWidth .. "." .. l_AfterDecimal .. "f", l_DirtyFloat)  
  return l_PrettyString
  
end -- function PrettyNumber(l_DirtyFloat)
function PaddedString(l_String, l_PadWidth)
  -- Called from ()...
  
  local l_PrettyString = string.format("%" .. l_PadWidth .. "s", l_String)
  
  return l_PrettyString
  
end -- function PaddedString(l_String, l_PadWidth)
function RoundTo(l_DirtyFloat, l_RoundTo)
  -- Called from PrettyNumber()..
  
  local x = .5
  if l_DirtyFloat * l_RoundTo < 0 then
    x = -.5 
  end
  
  Integer, Decimal = math.modf(l_DirtyFloat * l_RoundTo + x)
  l_MaybeDirtyFloat = Integer / l_RoundTo -- any division can accidentally introduce 0.000000000000001
  
  return l_MaybeDirtyFloat
  
end -- function RoundTo(l_DirtyFloat, l_RoundTo)
function PrettyNumber(l_DirtyFloat)
  -- Called from DefineGlobalVariables(), 
  --             DisplayPuzzleProperties(),
  --             RebuildSelectedSegments() and 
  --             2 places in RebuildManySegmentRanges()...
  
  -- This is the new version of RoundToThirdDecimal()...
  
  local l_MaybeDirtyFloat = RoundTo(l_DirtyFloat, 1000)  
  local l_PrettyString = string.format("%.3f", l_MaybeDirtyFloat)  
  
  return l_PrettyString
  
end -- function PrettyNumber(l_DirtyFloat)
function GetPoseTotalScore()
  return(Score())
end
--[[
    Based on Rav3n_pl Deep Rebuild v3.x
    WARNING!
    1) Script uses a lot of save slots
    2) Best score are always in slot 3

Description:
This is a long run rebuilder. Idea is to rebuild given/found area so many tyimes to found better position.
Each rebuild is scored in different ways and saved if better.
After rebuild finishes script is trying to stabilize each different saved position.
Because some positions are best in more than 1 way sometimes it is only 1 positions to stabilize.
On the best position a fuze is run if it looks promissing enough.

Changed by: Timo van der Laan 17-12-2011 till 28-12-2012
]]--
--[[
Overview:

This version of Rav3n_pl DRW has several new features.

First of all it is made totally V2 and uses option dialogs.
It has an optimised fuze and qStab, and will run a lot faster as the original.
The main optimalisation is that futile shakes and allready tried rebuilds are skipped.
Another one is that unprommissing fuzes can be skipped.
Features (most have parameters):
1. Can be used in design puzzles, has mutate options for that.
2. It will only recompute the next rebuild if there has been enough gain
3. It will not try to rebuild the exact same segments for a second time
4. It will not try a fuze if the loss is too great depending on the size of the rebuild
5. It will not try to rebuild frozen or locked parts
6. You can specify what parts of the protein to work on.
7. If you want it can keep disulfide bridges intact (thanks Brow42)
8. If the starting score is negative, default is that no wiggles will be done to avoid exploding the protein.
9. If stopped, it will reset CI, best score and secondary structures.
10. You can skip a number of worst parts (handy after a crash)
11. It breaks off rebuild tries if no chance of success.
12. It works on puzzles even if the score is < -1000000 (but will be slower).
13. Fuze and qStab can be suppressed (default if score is negative from the start)
14. You can specify to disable bands when rebuilding and enable them afterwards.
NEW in version 2
15. You can choose which slots will be active
16. You can choose which segment scoreparts count for finding worst
17. It will recognize puzzle properties and set defaults for it
18. Instead of skipping cycles you can specify nr of worst to skip
19. On ED puzzles the other component is given proper weight for finding worst
20. Code has been cleaned up
21. And something special for Auntdeen :-)
2.1.0 Added code for disjunct searching, fixed bridgesaving init.
2.1.1 Changed some max and min slider values and autodetects Layer Filter
2.2.0 Added ligand slot
2.3.0 GRRR Had to change other by Density
2.4.0 Dynamic list of active subscores,
      Puts back the old selection when stopped,
      Added rebuildnumber to the gainslot,
      Added alternative local cleanup after rebuild,
      Resets the original structure if mutated after rebuild for the next rb,
      Sets default mutate settings if a design puzzle.
2.4.1 Added WiggleFactor, remove reference as a slot
2.5.0 Added localshakes option Susume thanks
2.5.1 Wins during qstab wiggle will now be found.
2.6.0 Defaults and userinterface changed
2.7.0 Added option to disable slow filters on design puzzles
2.8.0 More general way to disable slow filters on design puzzles
2.8.1 Fixed filter problem when high bonus
2.8.2 Cleanup also after DRW stops normally
3.0.0 Made a Remix version in the same source
3.0.1 Fixed density weight computation if filters are active
]]--
-- Handy shorts module
	g_bDebugMode = false
	if _G ~= nil then
		g_bDebugMode = true
		SetupLocalDebugFuntions()
	end  
normal= 1 -- (current.GetExplorationMultiplier() == 0)
segCnt=structure.GetCount()
segCnt2=segCnt
while structure.GetSecondaryStructure(segCnt2)=="M" do segCnt2=segCnt2-1 end
CIfactor=1 
maxCI=true
function CI(CInr)
    if CInr > 0.99 then maxCI=true else maxCI=false end
    behavior.SetClashImportance(CInr*CIfactor)
end
function CheckCI() -- now AskUserToCheckClashImportance()
   local ask=dialog.CreateDialog("Clash importance is not 1")
   ask.l1=dialog.AddLabel("Last change to change it")
   ask.l2=dialog.AddLabel("CI settings will be multiplied by set CI")
   ask.continue=dialog.AddButton("Continue",1)
   dialog.Show(ask)
end
if behavior.GetClashImportance() < 0.99 then CheckCI() end
CIfactor=behavior.GetClashImportance()
-- Score functions
function Score(pose)
    if pose==nil then pose=current end
    local total= pose.GetEnergyScore()
    -- FIX for big negatives

        if total < -999999 and total > -1000001 then total=SegScore(pose) end

    if normal then
        return total
    else
        return total*pose.GetExplorationMultiplier()
    end
end
function SegScore(pose)
    if pose==nil then pose=current end
    local total=8000
    for i=1,segCnt2 do
        total=total+pose.GetSegmentEnergyScore(i)
    end
    return total
end
function RBScore()
    return Score(recentbest)
end
function round3(x)--cut all afer 3-rd place
    return x-x%0.001
end
-- Module Filteractive
Filterscore=Score()
if SKETCHBOOKPUZZLE == false then behavior.SetSlowFiltersDisabled(true) end
FilterOffscore=Score()
if SKETCHBOOKPUZZLE == false then behavior.SetSlowFiltersDisabled(false) end
maxbonus=Filterscore-FilterOffscore
CURBONUS=maxbonus
function Filter()
   local ask=dialog.CreateDialog("Slow filters seem to be active")
   ask.disable=dialog.AddCheckbox("Run with disabled slow filters",Filteractive)
   ask.l1=dialog.AddLabel("Current bonus is: "..maxbonus)
   ask.l2=dialog.AddLabel("If this is not the maximum bonus put in a number")
   if maxbonus < 0 then maxbonus=0 end
   ask.maxbonus=dialog.AddTextbox("Set maxbonus:",maxbonus)
   ask.l3=dialog.AddLabel("Scores will only be checked for real gains if")
   ask.l4=dialog.AddLabel("Score with filter off+maxbonus is a potential gain")
   ask.continue=dialog.AddButton("Continue",1)
   dialog.Show(ask)
   maxbonus=ask.maxbonus.value
if maxbonus=="" then maxbonus=0 end
   Filteractive=ask.disable.value
end
BetterRecentBest=false
function FilterOff()
    -- Filters off but restore a better recentbest with filter off
    behavior.SetSlowFiltersDisabled(true)
    if BetterRecentBest then
        save.Quicksave(99)
        save.Quickload(98)
        recentbest.Save()
        save.Quickload(99)
    end
end
function FilterOn()
    -- Filter on but remember recent best if better than current
    BetterRecentBest= Score(recentbest) > Score()
    if BetterRecentBest then
        save.Quicksave(99)
        recentbest.Restore()
        save.Quicksave(98)
        save.Quickload(99)
    end
    behavior.SetSlowFiltersDisabled(false)
end
Filteractive=(math.abs(maxbonus) > 0.1)
if Filteractive then
   --Filters active, give people a choice
   --And ask what the maximum bonus is.
   Filter()
end
-- End of module Filteractive
MINGAIN=0
foundahighgain=true
bestScore=Score() -- now g_Score_ScriptBest = GetPoseTotalScore()
if Filteractive then FilterOff() end
function SaveBest()
  if (not Filteractive) or -- now if g_bUserSelected_NormalConditionChecking_TemporarilyDisable == true then
    (Score()+maxbonus>bestScore) then
    if Filteractive then  -- now if g_bUserSelected_NormalConditionChecking_TemporarilyDisable == true then
      FilterOn() -- now NormalConditionChecking_ReEnable()
    end
    local g = Score() - bestScore
    if g > MINGAIN or (g > 0 and foundahighgain) then
      if g > 0.01 then
        --print("Gained another "..round3(g).." pts.")
      end
      bestScore=Score() -- bestScore is now g_Score_ScriptBest
      g_Score_ScriptBest = bestScore -- added for stats reporting
      save.Quicksave(3)
      foundahighgain=true
   end
   if Filteractive then FilterOff() end
  end
end
WF=1 -- New WiggleFactor
function Wiggle(how, iters, minppi,onlyselected,l_FromWhere)
  -- Wiggle function
  -- Optimized due to Susumes ideas
  -- Note the extra parameter to be used if only selected parts must be done
  --score conditioned recursive wiggle/shake
  --fixed a bug, absolute difference is the threshold now
  if how==nil then how="wa" end
  if iters==nil then iters=3 end
  
  if minppi==nil then minppi=0.1 end
  if onlyselected==nil then onlyselected=false end
  local wf=1
  if maxCI then wf=WF end
  local l_ClashImportance = behavior.GetClashImportance()
  local l_ClashImportanceText = " ClashImp " .. PaddedNumber(l_ClashImportance, 0, 2)    
  
    --if iters>0 then
        --iters=iters-1
        local sp=Score()
        if onlyselected then
            if how == "s" then
                -- Shake is not considered to do much in second or more rounds
                local l_TimeBefore = os.clock()
                

                
                structure.ShakeSidechainsSelected(1)
                
                
                
                local l_TimeAfter = os.clock()
                local l_SecondsUsed = l_TimeAfter - l_TimeBefore
                
                local l_Score_After_Shake = GetPoseTotalScore()
                local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
                if l_ScoreImprovement > 0.001 then
                  print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                        PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                        PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                        l_FromWhere .. ":1xShakeSidechainsSelected" ..
                        g_round_x_of_y ..
                        g_with_segments_x_thru_y ..
                        g_ScorePartText ..
                        l_ClashImportanceText)        
                  g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected =
                  g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected + l_ScoreImprovement
                  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected =
                  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected + 1
                  --SaveBest() -- <-- Updates g_Score_ScriptBest
                elseif l_Score_After_Shake < g_Score_ScriptBest then
                  -- Should we undo our last change because it dropped our score...
                  --recentbest.Restore()
                end
                g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected =
                g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected + l_SecondsUsed
                g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected =
                g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected + 1                
                
                return
            elseif how == "wb" then 
              local l_TimeBefore = os.clock()
              
              
              
              structure.WiggleSelected(2*wf*iters,true,false)
              
              
              
              local l_TimeAfter = os.clock()
              local l_SecondsUsed = l_TimeAfter - l_TimeBefore
              
              local l_Score_After_Wiggle = GetPoseTotalScore()
              local l_ScoreImprovement = l_Score_After_Wiggle - g_Score_ScriptBest
              if l_ScoreImprovement > 0.001 then
                print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                      PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                      PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                      l_FromWhere .. ":" ..
                      2*wf*iters .. "xWiggleSelected(" ..
                      "Bb=" .. tostring(l_bWBackbone) .. "," ..
                      "SC=" .. tostring(l_bWSideChains) .. ")" ..
                      g_round_x_of_y ..
                      g_with_segments_x_thru_y ..
                      g_ScorePartText ..
                      l_ClashImportanceText)
                    
                g_Stats_Run_TotalPointsGained_WiggleSelected =
                g_Stats_Run_TotalPointsGained_WiggleSelected + l_ScoreImprovement
                g_Stats_Run_SuccessfulAttempts_WiggleSelected =
                g_Stats_Run_SuccessfulAttempts_WiggleSelected + 1
                --SaveBest() -- <-- Updates g_Score_ScriptBest
              elseif l_Score_After_Wiggle < g_Score_ScriptBest then
                -- Should we undo our last change because it dropped our score...
                --recentbest.Restore()
              end
              g_Stats_Run_TotalSecondsUsed_WiggleSelected =
              g_Stats_Run_TotalSecondsUsed_WiggleSelected + l_SecondsUsed
              g_Stats_Run_NumberOfAttempts_WiggleSelected =
              g_Stats_Run_NumberOfAttempts_WiggleSelected + 1
            
            elseif how == "ws" then 
              local l_TimeBefore = os.clock()
              
              
              
              structure.WiggleSelected(2*wf*iters,false,true)
              
              local l_TimeAfter = os.clock()
              local l_SecondsUsed = l_TimeAfter - l_TimeBefore
              
              local l_Score_After_Wiggle = GetPoseTotalScore()
              local l_ScoreImprovement = l_Score_After_Wiggle - g_Score_ScriptBest
              if l_ScoreImprovement > 0.001 then
                print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                      PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                      PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                      l_FromWhere .. ":" ..
                      2*wf*iters .. "xWiggleSelected(" ..
                      "Bb=" .. tostring(l_bWBackbone) .. "," ..
                      "SC=" .. tostring(l_bWSideChains) .. ")" ..
                      g_round_x_of_y ..
                      g_with_segments_x_thru_y ..
                      g_ScorePartText ..
                      l_ClashImportanceText)
                    
                g_Stats_Run_TotalPointsGained_WiggleSelected =
                g_Stats_Run_TotalPointsGained_WiggleSelected + l_ScoreImprovement
                g_Stats_Run_SuccessfulAttempts_WiggleSelected =
                g_Stats_Run_SuccessfulAttempts_WiggleSelected + 1
                --SaveBest() -- <-- Updates g_Score_ScriptBest
              elseif l_Score_After_Wiggle < g_Score_ScriptBest then
                -- Should we undo our last change because it dropped our score...
                --recentbest.Restore()
              end
              g_Stats_Run_TotalSecondsUsed_WiggleSelected =
              g_Stats_Run_TotalSecondsUsed_WiggleSelected + l_SecondsUsed
              g_Stats_Run_NumberOfAttempts_WiggleSelected =
              g_Stats_Run_NumberOfAttempts_WiggleSelected + 1
              
              
            elseif how == "wa" then 
              local l_TimeBefore = os.clock()
              
              
              
              structure.WiggleSelected(2*wf*iters,true,true)
              
              local l_TimeAfter = os.clock()
              local l_SecondsUsed = l_TimeAfter - l_TimeBefore
              
              local l_Score_After_Wiggle = GetPoseTotalScore()
              local l_ScoreImprovement = l_Score_After_Wiggle - g_Score_ScriptBest
              if l_ScoreImprovement > 0.001 then
                print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                      PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                      PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                      l_FromWhere .. ":" ..
                      2*wf*iters .. "xWiggleSelected(" ..
                      "Bb=" .. tostring(l_bWBackbone) .. "," ..
                      "SC=" .. tostring(l_bWSideChains) .. ")" ..
                      g_round_x_of_y ..
                      g_with_segments_x_thru_y ..
                      g_ScorePartText ..
                      l_ClashImportanceText)
                    
                g_Stats_Run_TotalPointsGained_WiggleSelected =
                g_Stats_Run_TotalPointsGained_WiggleSelected + l_ScoreImprovement
                g_Stats_Run_SuccessfulAttempts_WiggleSelected =
                g_Stats_Run_SuccessfulAttempts_WiggleSelected + 1
                --SaveBest() -- <-- Updates g_Score_ScriptBest
              elseif l_Score_After_Wiggle < g_Score_ScriptBest then
                -- Should we undo our last change because it dropped our score...
                --recentbest.Restore()
              end
              g_Stats_Run_TotalSecondsUsed_WiggleSelected =
              g_Stats_Run_TotalSecondsUsed_WiggleSelected + l_SecondsUsed
              g_Stats_Run_NumberOfAttempts_WiggleSelected =
              g_Stats_Run_NumberOfAttempts_WiggleSelected + 1
              
              
            end
        else
            if how == "s" then
                -- Shake is not considered to do much in second or more rounds
                local l_TimeBefore = os.clock()
                
                
                
                structure.ShakeSidechainsAll(1)
                
                
                
                local l_TimeAfter = os.clock()
                local l_SecondsUsed = l_TimeAfter - l_TimeBefore
                
                local l_Score_After_Shake = GetPoseTotalScore()
                local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
                if l_ScoreImprovement > 0.001 then
                  print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                        PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                        PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                        l_FromWhere .. ":1xShakeSidechainsAll" ..
                        g_round_x_of_y ..
                        g_with_segments_x_thru_y ..
                        g_ScorePartText ..
                        l_ClashImportanceText)        
                  g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected =
                  g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected + l_ScoreImprovement
                  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected =
                  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected + 1
                  --SaveBest() -- <-- Updates g_Score_ScriptBest
                elseif l_Score_After_Shake < g_Score_ScriptBest then
                  -- Should we undo our last change because it dropped our score...
                  --recentbest.Restore()
                end
                g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected =
                g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected + l_SecondsUsed
                g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected =
                g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected + 1    
                
                return
            elseif how == "wb" then
              local l_TimeBefore = os.clock()
              
              
              
              structure.WiggleAll(2*wf*iters,true,false)
              
              
              
                local l_TimeAfter = os.clock()
                local l_SecondsUsed = l_TimeAfter - l_TimeBefore
                
                local l_Score_After_Shake = GetPoseTotalScore()
                local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
                if l_ScoreImprovement > 0.001 then
                  print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                        PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                        PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                        --l_FromWhere .. ":1xShakeSidechainsAll" ..
                        2*wf*iters .. "xWiggleAll(Bb=true,SC=false)" ..
                        g_round_x_of_y ..
                        g_with_segments_x_thru_y ..
                        g_ScorePartText ..
                        l_ClashImportanceText)        
                  g_Stats_Run_TotalPointsGained_WiggleAll =
                  g_Stats_Run_TotalPointsGained_WiggleAll + l_ScoreImprovement
                  g_Stats_Run_SuccessfulAttempts_WiggleAll =
                  g_Stats_Run_SuccessfulAttempts_WiggleAll + 1
                  --SaveBest() -- <-- Updates g_Score_ScriptBest
                elseif l_Score_After_Shake < g_Score_ScriptBest then
                  -- Should we undo our last change because it dropped our score...
                  --recentbest.Restore()
                end
                g_Stats_Run_TotalSecondsUsed_WiggleAll =
                g_Stats_Run_TotalSecondsUsed_WiggleAll + l_SecondsUsed
                g_Stats_Run_NumberOfAttempts_WiggleAll =
                g_Stats_Run_NumberOfAttempts_WiggleAll + 1    
                
            elseif how == "ws" then
              local l_TimeBefore = os.clock()
              
              
              structure.WiggleAll(2*wf*iters,false,true)
              
              
              
                local l_TimeAfter = os.clock()
                local l_SecondsUsed = l_TimeAfter - l_TimeBefore
                
                local l_Score_After_Shake = GetPoseTotalScore()
                local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
                if l_ScoreImprovement > 0.001 then
                  print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                        PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                        PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                        2*wf*iters .. "xWiggleAll(Bb=false,SC=true)" ..
                        g_round_x_of_y ..
                        g_with_segments_x_thru_y ..
                        g_ScorePartText ..
                        l_ClashImportanceText)        
                  g_Stats_Run_TotalPointsGained_WiggleAll =
                  g_Stats_Run_TotalPointsGained_WiggleAll + l_ScoreImprovement
                  g_Stats_Run_SuccessfulAttempts_WiggleAll =
                  g_Stats_Run_SuccessfulAttempts_WiggleAll + 1
                  --SaveBest() -- <-- Updates g_Score_ScriptBest
                elseif l_Score_After_Shake < g_Score_ScriptBest then
                  -- Should we undo our last change because it dropped our score...
                  --recentbest.Restore()
                end
                g_Stats_Run_TotalSecondsUsed_WiggleAll =
                g_Stats_Run_TotalSecondsUsed_WiggleAll + l_SecondsUsed
                g_Stats_Run_NumberOfAttempts_WiggleAll =
                g_Stats_Run_NumberOfAttempts_WiggleAll + 1    
                
            elseif how == "wa" then
              local l_TimeBefore = os.clock()
              
              
              structure.WiggleAll(2*wf*iters,true,true)
              
              
              
                local l_TimeAfter = os.clock()
                local l_SecondsUsed = l_TimeAfter - l_TimeBefore
                
                local l_Score_After_Shake = GetPoseTotalScore()
                local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
                if l_ScoreImprovement > 0.001 then
                  print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
                        PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
                        PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
                        2*wf*iters .. "xWiggleAll(Bb=true,SC=true)" ..
                        g_round_x_of_y ..
                        g_with_segments_x_thru_y ..
                        g_ScorePartText ..
                        l_ClashImportanceText)        
                  g_Stats_Run_TotalPointsGained_WiggleAll =
                  g_Stats_Run_TotalPointsGained_WiggleAll + l_ScoreImprovement
                  g_Stats_Run_SuccessfulAttempts_WiggleAll =
                  g_Stats_Run_SuccessfulAttempts_WiggleAll + 1
                  --SaveBest() -- <-- Updates g_Score_ScriptBest
                elseif l_Score_After_Shake < g_Score_ScriptBest then
                  -- Should we undo our last change because it dropped our score...
                  --recentbest.Restore()
                end
                g_Stats_Run_TotalSecondsUsed_WiggleAll =
                g_Stats_Run_TotalSecondsUsed_WiggleAll + l_SecondsUsed
                g_Stats_Run_NumberOfAttempts_WiggleAll =
                g_Stats_Run_NumberOfAttempts_WiggleAll + 1    
                
            end
        end
        --if math.abs(Score()-sp) > minppi then return Wiggle(how, iters, minppi,onlyselected) end
    --end
end
function SegmentListToSet(list)
    local result={}
    local f=0
    local l=-1
    table.sort(list)
    for i=1,#list do
        if list[i] ~= l+1 and list[i] ~= l then
            -- note: duplicates are removed
            if l>0 then result[#result+1]={f,l} end
            f=list[i]
        end
        l=list[i]
    end
    if l>0 then result[#result+1]={f,l} end
    --print("list to set")
    --SegmentPrintSet(result)
    return result
end
function SegmentSetToList(set)
    local result={}
    for i=1,#set do
        --print(set[i][1],set[i][2])
        for k=set[i][1],set[i][2] do
            result[#result+1]=k
        end
    end
    return result
end
function SegmentCleanSet(set)
-- Makes it well formed
    return SegmentListToSet(SegmentSetToList(set))
end
function SegmentInvertSet(set,maxseg)
-- Gives back all segments not in the set
-- maxseg is added for ligand
    local result={}
    if maxseg==nil then maxseg=structure.GetCount() end
    if #set==0 then return {{1,maxseg}} end
    if set[1][1] ~= 1 then result[1]={1,set[1][1]-1} end
    for i=2,#set do
        result[#result+1]={set[i-1][2]+1,set[i][1]-1}
    end
    if set[#set][2] ~= maxseg then result[#result+1]={set[#set][2]+1,maxseg} end
    return result
end
function SegmentInvertList(list)
    table.sort(list)
    local result={}
    for i=1,#list-1 do
       for j=list[i]+1,list[i+1]-1 do result[#result+1]=j end
    end
    for j=list[#list]+1,segCnt2 do result[#result+1]=j end
    return result
end
function SegmentInList(s,list)
    table.sort(list)
    for i=1,#list do
        if list[i]==s then return true
        elseif list[i]>s then return false
        end
    end
    return false
end
function SegmentInSet(set,s)
    for i=1,#set do
        if s>=set[i][1] and s<=set[i][2] then return true
        elseif s<set[i][1] then return false
        end
    end
    return false
end
function SegmentJoinList(list1,list2)
    local result=list1
    if result == nil then return list2 end
    for i=1,#list2 do result[#result+1]=list2[i] end
    table.sort(result)
    return result
end
function SegmentJoinSet(set1,set2)
    return SegmentListToSet(SegmentJoinList(SegmentSetToList(set1),SegmentSetToList(set2)))
end
function SegmentCommList(list1,list2)
    local result={}
    table.sort(list1)
    table.sort(list2)
    if #list2==0 then return result end
    local j=1
    for i=1,#list1 do
        while list2[j]<list1[i] do
            j=j+1
            if j>#list2 then return result end
        end
        if list1[i]==list2[j] then result[#result+1]=list1[i] end
    end
    return result
end
function SegmentCommSet(set1,set2)
    return SegmentListToSet(SegmentCommList(SegmentSetToList(set1),SegmentSetToList(set2)))
end
function SegmentSetMinus(set1,set2)
    return SegmentCommSet(set1,SegmentInvertSet(set2))
end
function SegmentPrintSet(set)
    print(SegmentSetToString(set))
end
function SegmentSetToString(set)
    local line = ""
    for i=1,#set do
        if i~=1 then line=line..", " end
        line=line..set[i][1].."-"..set[i][2]
    end
    return line
end
function SegmentSetInSet(set,sub)
    if sub==nil then return true end
    -- Checks if sub is a proper subset of set
    for i=1,#sub do
        if not SegmentRangeInSet(set,sub[i]) then return false end
    end
    return true
end
function SegmentRangeInSet(set,range)
    if range==nil or #range==0 then return true end
    local b=range[1]
    local e=range[2]
    for i=1,#set do
        if b>=set[i][1] and b<=set[i][2] then
            return (e<=set[i][2])
        elseif e<=set[i][1] then return false end
    end
    return false
end
function SegmentSetToBool(set)
    local result={}
    for i=1,structure.GetCount() do
        result[i]=SegmentInSet(set,i)
    end
    return result
end
--- End of Segment Set module
-- Module Find Segment Types
function FindMutablesList()
    local result={}
    for i=1,segCnt2 do if structure.IsMutable(i) then result[#result+1]=i end end
    return result
end
function FindMutables()
    return SegmentListToSet(FindMutablesList())
end
function FindFrozenList()
    local result={}
    for i=1,segCnt2 do if freeze.IsFrozen(i) then result[#result+1]=i end end
    return result
end
function FindFrozen()
    return SegmentListToSet(FindFrozenList())
end
function FindLockedList()
    local result={}
    for i=1,segCnt2 do if structure.IsLocked(i) then result[#result+1]=i end end
    return result
end
function FindLocked()
    return SegmentListToSet(FindLockedList())
end
function FindSelectedList()
    local result={}
    for i=1,segCnt do if selection.IsSelected(i) then result[#result+1]=i end end
    return result
end
function FindSelected()
    return SegmentListToSet(FindSelectedList())
end
function FindAAtypeList(aa)
    local result={}
    for i=1,segCnt2 do
        if structure.GetSecondaryStructure(i)== aa then result[#result+1]=i end
    end
    return result
end
function FindAAtype(aa)
    return SegmentListToSet(FindAAtypeList(aa))
end
function FindAminotype(at) --NOTE: only this one gives a list not a set
    local result={}
    for i=1,segCnt2 do
        if structure.GetAminoAcid(i) == at then result[#result+1]=i end
    end
    return result
end
-- end Module Find Segment Types
-- Module to compute subscores
function GetSubscore(types,seg1,seg2,pose) -- now Calculate_SegmentRange_Score()
    local result=0
    if type(types) == "table" then
        for i=1,#types do result=result+GetSubscore(types[i],seg1,seg2,pose) end
    else
        if types==nil and seg1==nil and seg2==nil then return Score(pose) end
        if seg1==nil then seg1=1 end
        if seg2==nil then seg2=segCnt end --includes ligands!
        if seg1>seg2 then seg1,seg2=seg2,seg1 end
        if pose==nil then pose=current end
        if types==nil then
            for i=seg1,seg2 do result=result+pose.GetSegmentEnergyScore(i) end
        else
            for i=seg1,seg2 do result=result+pose.GetSegmentEnergySubscore(i,types) end
        end
    end
    if normal then return result else return result*pose.GetExplorationMultiplier() end
end
function FindActiveSubscores(show) -- now Populate_g_ActiveScorePartsTable()
    local result={}
    local Subs=puzzle.GetPuzzleSubscoreNames()
    local Showlist ="Computing Active Subscores"
    if show then print(Showlist) end
    for i=1,#Subs do -- now l_ScorePart_NamesTable[]
        local total=0
        for j=1,segCnt do
            if Subs[i] == 'disulfides' and nrofbridges>0 then total=11 end
            total=total+math.abs(current.GetSegmentEnergySubscore(j,Subs[i]))
            if total>10 then
                result[#result+1]=Subs[i]
                if show then print("Active subscore: "..Subs[i]) end
                break
            end
        end
    end
    return result
end
-- End module to compute subscores
-- Position stack module 1.0 - uses slot 60 and higher
Stackmin=60
StackMarks={}
StackPos=60
function PushPosition()
    if StackPos==100 then
        print("Position stack overflow, exiting")
        exit()
    end
    save.Quicksave(StackPos)
    StackPos=StackPos+1
end
function PopPosition()
    if StackPos==60 then
        print("Position stack underflow, exiting")
        exit()
    end
    StackPos=StackPos-1
    save.Quickload(StackPos)
end
function PushMarkPosition()
    StackMarks[#StackMarks+1]=StackPos
    PushPosition()
end
function PopMarkPosition()
    if #StackMarks == 0 then
        print("No marked position found, just popping")
    else
        StackPos=StackMarks[#StackMarks]+1
        StackMarks[#StackMarks]= nil
    end
    PopPosition()
end
function GetTopPosition()
    if StackPos==60 then
        print("No top position on the stack, exiting")
        exit()
    end
    save.Quickload(StackPos-1)
end
function ClrTopPosition()
    if StackPos > 60 then StackPos=StackPos-1 end
end
-- Start of module for bridgechecking
Cyslist={}
savebridges=false -- default no bridgechecking
nrofbridges=0
function setCyslist()
    Cyslist=FindAminotype("c")
    nrofbridges=CountBridges()
end
function IsBridge(i)
    if structure.IsLocked(i) then return false end
    return ''..current.GetSegmentEnergySubscore(i,'disulfides') ~= '-0'
end
function CountBridges()
    local count = 0
    for i = 1,#Cyslist do
        if IsBridge(Cyslist[i]) then count = count + 1 end
    end
    return count
end
function BridgesBroken()
    return savebridges == true and CountBridges() < nrofbridges
end
function Bridgesave()
    if savebridges then PushPosition() end
end
function Bridgerestore()
    if savebridges then
        if BridgesBroken() then PopPosition() else ClrTopPosition() end
    end
end
-- End module bridgechecking
-- Module find puzzle properties
HASMUTABLE=false
HASDENSITY=false
HASLIGAND= (segCnt2<segCnt)
DENSITYWEIGHT=0
PROBABLESYM=false
FREEDESIGN=false
SKETCHBOOKPUZZLE=false
function SetPuzzleProperties()
    print("Computing puzzle properties")
    -- Find out if the puzzle has mutables
    local MutList=FindMutablesList()
    HASMUTABLE= (#MutList>0)
    if HASMUTABLE then print("Mutables found") end
    FREEDESIGN= (segCnt2/2 < #MutList)
    if FREEDESIGN then print("Design puzzle") end

    -- Find out if the puzzle has possible bridges
    setCyslist()
    if #Cyslist > 1 then
        print("Puzzle has more than 1 cystine")
        if nrofbridges > 0 then
            print("Puzzle has bridges")
            savebridges=true
        end
    end

    -- Find out is the puzzle has Density scores and their weight if any
    local Densitytot=GetSubscore("density")
    local segtot=GetSubscore(nil,1,segCnt)
    HASDENSITY= math.abs(Densitytot) > 0.0001
    if normal and HASDENSITY then
        print("Puzzle has Density scores")
        DENSITYWEIGHT=(Score()-CURBONUS-segtot-8000)/Densitytot
        print("The Density component has an extra weight of "..round3(DENSITYWEIGHT))
    end

    -- Check if the puzzle is a probable symmetry one
    if normal and not HASDENSITY then
        PROBABLESYM=math.abs(Score()-segtot-8000) > 2
        if PROBABLESYM then print("Puzzle is a symmetry puzzle or has bonuses") end
    end

    name=puzzle.GetName()
    if string.find(name,"Sketchbook") then
     print("SketchbookPuzzle")
     SKETCHBOOKPUZZLE=true
    end
end
SetPuzzleProperties()
-- End of module find puzzle properties
-- Standard Fuze module
-- Picks up all gains by using recentbest
function GetRB(prefun,postfun) -- get recent best pose
    if RBScore()> Score() then
        if prefun ~= nil then prefun() end
        recentbest.Restore()
        if postfun ~= nil then postfun() end
    end
end
function FuzeEnd(prefun,postfun)
    if prefun ~= nil then prefun() end
    CI(1)
-- Wiggle("wa",1,nil,nil,"FuzeEnd")
-- Wiggle("s",1,nil,nil,"FuzeEnd")
    Wiggle(nil,nil,nil,nil,"FuzeEnd")
    GetRB(prefun,postfun)
    if postfun ~= nil then postfun() end
    SaveBest()
end
function Fuze1(ci1,ci2,prefun,postfun,globshake)
    if prefun ~=nil then prefun() end
    if globshake==nil then globshake=true end
    CI(ci1)
    Wiggle("s",1,nil,globshake,"Fuze1a")
    CI(ci2)
    Wiggle("wa",1,nil,nil,"Fuze1b")
    if postfun ~= nil then postfun() end
end
function Fuze2(ci1,ci2,prefun,postfun)
    if prefun ~= nil then prefun() end
    CI(ci1)
    Wiggle("wa",1,nil,nil,"Fuze2a")
    CI(1)
    Wiggle("wa",1,nil,nil,"Fuze2b")
    CI(ci2)
    Wiggle("wa",1,nil,nil,"Fuze2b")
    if postfun ~= nil then postfun() end
end
function reFuze(scr,slot)
    local s=Score()
    if s<scr then
        save.Quickload(slot)
    else
        scr=s
        save.Quicksave(slot)
    end
    return scr
end
function Fuze(slot,prefun,postfun,globshake)
    local scr=Score()
    if slot == nil then slot=4 save.Quicksave(slot) end

    recentbest.Save()
    Fuze1(0.3,0.6,prefun,postfun,globshake)
    FuzeEnd(prefun,postfun)
    scr=reFuze(scr,slot)
    Fuze2(0.3,1,prefun,postfun)
    GetRB(prefun,postfun)
    SaveBest()
    scr=reFuze(scr,slot)
    Fuze1(0.05,1,prefun,postfun,globshake)
    GetRB(prefun,postfun)
    SaveBest()
    scr=reFuze(scr,slot)
    Fuze2(0.7,0.5,prefun,postfun) FuzeEnd()
    scr=reFuze(scr,slot)
    Fuze1(0.07,1,prefun,postfun,globshake)
    GetRB(prefun,postfun)
    SaveBest()
    reFuze(scr,slot)
    GetRB(prefun,postfun)
    SaveBest()
end
-- end standard Fuze module
-- Module setsegmentset
function SetSelection(set) -- now CleanUpSelectedSegmentRanges()
    selection.DeselectAll()
    if set ~= nil then for i=1,#set do
        selection.SelectRange(set[i][1],set[i][2])
    end end
end
function SelectAround(ss,se,radius,nodeselect) -- now SelectSegmentsNearSegmentRange()
    if nodeselect~=true then selection.DeselectAll() end
    for i=1, segCnt2 do
        for x=ss,se do
            if structure.GetDistance(x,i)<radius then selection.Select(i) break end
        end
    end
end
function SetAAtype(set,aa)
    local saveselected=FindSelected()
    SetSelection(set)
    structure.SetSecondaryStructureSelected(aa)
    SetSelection(saveselected)
end
-- Module AllLoop
SAVEDstructs=false
function AllLoop() -- now ConvertAllSegmentsToLoops()
  --turning entire structure to loops
    local anychange=false
    for i=1,segCnt2 do
        if structure.GetSecondaryStructure(i)~="L" then
            anychange=true
            break
        end
    end
    if anychange then
        save.SaveSecondaryStructure()
        SAVEDstructs=true
        selection.SelectAll()
        structure.SetSecondaryStructureSelected("L")
    end
end
function qStab() -- now StabilizeSegmentRange()
    -- Do not accept qstab losses
    local curscore=Score()
    PushPosition()
    CI(0.1)
    Wiggle("s",1,nil,true,"qStab1") --shake only selected part
    if InQstab then
        CI(1)
        doMutate("During qStab")
    end
    if fastQstab==false then
        CI(0.4)
        Wiggle("wa",1,nil,nil,"qStab2")
        CI(1)
        Wiggle("s",1,nil,localshakes,"qStab3")
    end
    CI(1)
    recentbest.Save()
    Wiggle(nil,nil,nil,nil,"qStab4")
    recentbest.Restore()
    if Score() < curscore then PopPosition() else ClrTopPosition() end
end -- function qStab() 
function Cleanup(err)
  
  g_Stats_Script_ElaspedSeconds = os.clock() - g_ScriptStartTime
  
  g_Stats_Script_TotalPointsGained_Total = 
    g_Stats_Script_TotalPointsGained_RebuildSelected +
    g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected +
    g_Stats_Script_TotalPointsGained_WiggleSelected +
    g_Stats_Script_TotalPointsGained_WiggleAll +
    g_Stats_Script_TotalPointsGained_MutateSidechainsSelected +
    g_Stats_Script_TotalPointsGained_MutateSidechainsAll
  
  g_Stats_Script_TotalSecondsUsed_Total = 
    g_Stats_Script_TotalSecondsUsed_RebuildSelected +
    g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected +
    g_Stats_Script_TotalSecondsUsed_WiggleSelected +
    g_Stats_Script_TotalSecondsUsed_WiggleAll +
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected +
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll
  
  g_Stats_Script_SuccessfulAttempts_Total = 
    g_Stats_Script_SuccessfulAttempts_RebuildSelected +
    g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected +
    g_Stats_Script_SuccessfulAttempts_WiggleSelected +
    g_Stats_Script_SuccessfulAttempts_WiggleAll +
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected +
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll
    
  g_Stats_Script_NumberOfAttempts_Total = 
    g_Stats_Script_NumberOfAttempts_RebuildSelected +
    g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected +
    g_Stats_Script_NumberOfAttempts_WiggleSelected +
    g_Stats_Script_NumberOfAttempts_WiggleAll +
    g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected +
    g_Stats_Script_NumberOfAttempts_MutateSidechainsAll
    
  -- Future improvements for stats:
  -- 1) The script sum total of the many action seconds is close to double the actual script elasped
  --    time. For example 93,826 vs 55,061 seconds. To get a more accurate time spent, divide the 
  --    time per action by the total time of all actions. This will give a reasonable percent of time
  --    taken. Then multiply this percentage by the actual time elapsed. For example RebuildSelected
  --    says it took 83540 of the 93826 total action seconds. This represents 89% of the total actual
  --    elapsed time of 55061 seconds or 49,024 actual seconds (or 817 minutes or 13.6 hours)
  -- 2) Maybe add overall % success rate next to individual action success rate. For example:
  --    RebuildSelected Success Rate: 15/2701  (0.56%)  15/766  (1.96%) overall
  --    ShakeSidechainsSelected:      10/1278  (0.78%)  10/766  (1.31%) overall
  --    WiggleAll:                   737/1098 (67.15%) 737/766 (96.21%) overall
  --    ...then again, this doesn't really add much useful info.
  
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("End of Script Stats:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("From:                       Points Gained      Minutes Used    Pts/Min     Success Rate:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
                                        
  print("RebuildSelected          " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected, 9, 3) .. "" .. 
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_RebuildSelected /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_RebuildSelected /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected /
                (g_Stats_Script_TotalSecondsUsed_RebuildSelected / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_RebuildSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_RebuildSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_RebuildSelected /
                 g_Stats_Script_NumberOfAttempts_RebuildSelected * 100, 4, 2) .. "%)", 9))
  print("ShakeSidechainsSelected  " ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected /
                (g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected /
                 g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleSelected           " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_WiggleSelected /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_WiggleSelected /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected /
                (g_Stats_Script_TotalSecondsUsed_WiggleSelected / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_WiggleSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_WiggleSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_WiggleSelected /
                 g_Stats_Script_NumberOfAttempts_WiggleSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleAll                " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_WiggleAll /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_WiggleAll /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll /
                (g_Stats_Script_TotalSecondsUsed_WiggleAll / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_WiggleAll .. "/" ..  
    PaddedNumber(g_Stats_Script_NumberOfAttempts_WiggleAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_WiggleAll /
                 g_Stats_Script_NumberOfAttempts_WiggleAll * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsSelected " ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected /
                (g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected /
                 g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsAll      " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll /
                 g_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
    PaddedNumber(g_Stats_Script_ElaspedSeconds * 
                (g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll /
                 g_Stats_Script_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll /
                (g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_MutateSidechainsAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll /
                 g_Stats_Script_NumberOfAttempts_MutateSidechainsAll * 100, 4, 2) .. "%)", 9))
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("Run total                " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_Total, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_Total /
                 g_Stats_Script_TotalPointsGained_Total * 100, 5, 1) .. "%)", 9) ..
    
    PaddedNumber(g_Stats_Script_ElaspedSeconds / 60, 9, 3) .. "" ..
    
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalSecondsUsed_Total /
                 g_Stats_Script_TotalSecondsUsed_Total * 100, 5, 1) .. "%)", 9) ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_Total /
                (g_Stats_Script_TotalSecondsUsed_Total / 60), 9, 0) .. "  " ..
    PaddedString(g_Stats_Script_SuccessfulAttempts_Total .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_Total, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_Total /
                 g_Stats_Script_NumberOfAttempts_Total * 100, 4, 2) .. "%)", 9))
  print("------------------------ ------------------  ----------------  -------  ------------------")

  local l_Score_AtEndOf_Script = g_Score_ScriptBest
	print("\nStarting Score: " .. PrettyNumber(g_Score_AtStartOf_Script) ..
        "\nPoints Gained: " .. PrettyNumber(l_Score_AtEndOf_Script - g_Score_AtStartOf_Script) ..
        "\nFinal Score: " .. PrettyNumber(l_Score_AtEndOf_Script) ..
        "\nElapsed Time " .. PrettyNumber(g_Stats_Script_ElaspedSeconds) .. " seconds or " ..
        PaddedNumber(g_Stats_Script_ElaspedSeconds / 60, 5, 3) .. " minutes or " ..
        PaddedNumber(g_Stats_Script_ElaspedSeconds / 3600, 5, 3) .. " hours" ..
        "\n")
      
    print("Restoring CI, initial selection, best result and structures")
    CI(1)
    save.Quickload(3)

    if Filteractive then FilterOn() end
    if SAVEDstructs==true then save.LoadSecondaryStructure() end
    selection.DeselectAll()
    if SAFEselection ~= nil then SetSelection(SAFEselection) end
    if err ~= nill then
      print(err)
    end
       
end -- function Cleanup()
-- Module AskSelections
function AskForSelections(title,mode) -- now AskUserToSelectSegmentsRangesToRebuild()
    local result={{1,structure.GetCount()}} -- All segments
    if mode == nil then mode={} end
    if mode.askloops==nil then mode.askloops=true end
    if mode.asksheets==nil then mode.asksheets=true end
    if mode.askhelixes==nil then mode.askhelixes=true end
    if mode.askligands==nil then mode.askligands=false end
    if mode.askselected==nil then mode.askselected=true end
    if mode.asknonselected==nil then mode.asknonselected=true end
    if mode.askmutateonly==nil then mode.askmutateonly=true end
    if mode.askignorelocks==nil then mode.askignorelocks=true end
    if mode.askignorefrozen==nil then mode.askignorefrozen=true end
    if mode.askranges==nil then mode.askranges=true end
    if mode.defloops==nil then mode.defloops=true end
    if mode.defsheets==nil then mode.defsheets=true end
    if mode.defhelixes==nil then mode.defhelixes=true end
    if mode.defligands==nil then mode.defligands=false end
    if mode.defselected==nil then mode.defselected=false end
    if mode.defnonselected==nil then mode.defnonselected=false end
    if mode.defmutateonly==nil then mode.defmutateonly=false end
    if mode.defignorelocks==nil then mode.defignorelocks=false end
    if mode.defignorefrozen==nil then mode.defignorefrozen=false end
    local Errfound=false
  repeat
    local ask = dialog.CreateDialog(title)
    if Errfound then
        ask.E1=dialog.AddLabel("Try again, ERRORS found, check output box")
        result={{1,structure.GetCount()}} --reset start
        Errfound=false
    end
    if mode.askloops then
        ask.loops = dialog.AddCheckbox("Work on loops",mode.defloops)
    elseif not mode.defloops then
        ask.noloops= dialog.AddLabel("Loops will be auto excluded")
    end
    if mode.askhelixes then
        ask.helixes = dialog.AddCheckbox("Work on helixes",mode.defhelixes)
    elseif not mode.defhelixes then
        ask.nohelixes= dialog.AddLabel("Helixes will be auto excluded")
    end
    if mode.asksheets then
        ask.sheets = dialog.AddCheckbox("Work on sheets",mode.defsheets)
    elseif not mode.defsheets then
        ask.nosheets= dialog.AddLabel("Sheets will be auto excluded")
    end
    if mode.askligands then
        ask.ligands = dialog.AddCheckbox("Work on ligands",mode.defligands)
    elseif not mode.defligands then
        ask.noligands= dialog.AddLabel("Ligands will be auto excluded")
    end
    if mode.askselected then ask.selected = dialog.AddCheckbox("Work only on selected",mode.defselected) end
    if mode.asknonselected then ask.nonselected = dialog.AddCheckbox("Work only on nonselected",mode.defnonselected) end
    if mode.askmutateonly then ask.mutateonly = dialog.AddCheckbox("Work only on mutateonly",mode.defmutateonly) end
    if mode.askignorelocks then
        ask.ignorelocks =dialog.AddCheckbox("Dont work on locked ones",true)
    elseif mode.defignorelocks then
        ask.nolocks=dialog.AddLabel("Locked ones will be auto excluded")
    end
    if mode.askignorefrozen then
        ask.ignorefrozen = dialog.AddCheckbox("Dont work on frozen",true)
    elseif mode.defignorefrozen then
        ask.nofrozen=dialog.AddLabel("Frozen ones will be auto excluded")
    end
    if mode.askranges then
        ask.R1=dialog.AddLabel("Or put in segmentranges. Above selections also count")
        ask.ranges=dialog.AddTextbox("Ranges","")
    end
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    if dialog.Show(ask) > 0 then
        -- We start with all the segments including ligands
        if mode.askloops then mode.defloops=ask.loops.value end
        if not mode.defloops then
            result=SegmentSetMinus(result,FindAAtype("L"))
        end
        if mode.asksheets then mode.defsheets=ask.sheets.value end
        if not mode.defsheets then
            result=SegmentSetMinus(result,FindAAtype("E"))
        end
        if mode.askhelixes then mode.defhelixes=ask.helixes.value end
        if not mode.defhelixes then
            result=SegmentSetMinus(result,FindAAtype("H"))
        end
        if mode.askligands then mode.defligands=ask.ligands.value end
        if not mode.defligands then
            result=SegmentSetMinus(result,FindAAtype("M"))
        end
        if mode.askignorelocks then mode.defignorelocks=ask.ignorelocks.value end
        if mode.defignorelocks then
            result=SegmentSetMinus(result,FindLocked())
        end
        if mode.askignorefrozen then mode.defignorefrozen=ask.ignorefrozen.value end
        if mode.defignorefrozen then
            result=SegmentSetMinus(result,FindFrozen())
        end
        if mode.askselected then mode.defselected=ask.selected.value end
        if mode.defselected then
            result=SegmentCommSet(result,FindSelected())
        end
        if mode.asknonselected then mode.defnonselected=ask.nonselected.value end
        if mode.defnonselected then
            result=SegmentCommSet(result,SegmentInvertSet(FindSelected()))
        end
        if mode.askranges and ask.ranges.value ~= "" then
            local rangetext=ask.ranges.value
            local function Checknums(nums)
                -- Now checking
                if #nums%2 ~= 0 then
                    print("Not an even number of segments found")
                    return false
                end
                for i=1,#nums do
                    if nums[i]==0 or nums[i]>structure.GetCount() then
                        print("Number "..nums[i].." is not a segment")
                        return false
                    end
                end
                return true
            end

            local function ReadSegmentSet(data)
                local nums = {}
                local NoNegatives='%d+' -- - is not part of a number
                local result={}
                for v in string.gfind(data,NoNegatives) do
                    table.insert(nums, tonumber(v))
                end
                if Checknums(nums) then
                    for i=1,#nums/2 do
                        result[i]={nums[2*i-1],nums[2*i]}
                    end
                    result=SegmentCleanSet(result)
                else Errfound=true result={} end
                return result
            end
            local rangelist=ReadSegmentSet(rangetext)
            if not Errfound then
                result=SegmentCommSet(result,rangelist)
            end
        end
    end
  until not Errfound
    return result
end
-- end of module AskSelections
progname="DRW "
action="rebuild"
function Sort(tab,items) -- now SortBySegmentScore()
  --BACWARD bubble sorting - lowest on top, only needed items
    for x=1,items do --items do
        for y=x+1,#tab do
            if tab[x][1]>tab[y][1] then
                tab[x],tab[y]=tab[y],tab[x]
            end
        end
    end
    return tab
end
function AddDone(first,last) -- now SetSegmentsAlreadyRebuilt()
    if donotrevisit then
        Donepart[first+(last-first)*segCnt2]=true
        Blocked[#Blocked+1]=first+(last-first)*segCnt2
    end
    if disjunct then
        for i=first,last do Disj[i]=true end
    end
end
function CheckDone(first,last) -- now bSegmentRangeIsAllowedToBeRebuilt()
    if not donotrevisit then return false end
    local result=
      Donepart[first+(last-first)*segCnt2] -- now deprecated
    if disjunct then
        for i=first,last do 
          if Disj[i] then -- now g_bSegmentsAlreadyRebuiltTable[]
          result=true end end
    end
    return result
end
function ChkDisjunctList(n) -- now CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
    if not disjunct then return end
    local maxlen=0
    for i=1,segCnt2 do
        if Disj[i] then -- now g_bSegmentsAlreadyRebuiltTable[]
          maxlen=0 else maxlen=maxlen+1 end
        if maxlen == n then return end
    end
    -- No part is big enough so clear Disjunctlist
    print("Clearing disjunct list")
    for i=1,segCnt2 do
        Disj[i]=false -- now g_bSegmentsAlreadyRebuiltTable[]
    end
end
function ClearDoneList() -- now ResetSegmentsAlreadyRebuiltTable()

    for i=1,#Blocked do 
      Donepart[Blocked[i]]=false -- now deprecated
    end
    if disjunct then
        --clear disjunctlist also
        for i=1,segCnt2 do 
        Disj[i]=false -- now g_bSegmentsAlreadyRebuiltTable[]
        end
    end
    Blocked={}
    curclrscore=Score()
end
function ChkDoneList() -- now CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
    if not donotrevisit and not disjunt then return end
    if Score() > curclrscore+clrdonelistgain then
        if donotrevisit then 
          ClearDoneList() -- now ResetSegmentsAlreadyRebuiltTable()
        end
    end
end
--end of administration part
function FindWorst(firsttime) -- now Populate_g_XLowestScoringSegmentRangesTable
    print("Searching worst scoring parts of len "..len)
    ChkDisjunctList(len)
    wrst={} -- now l_XLowestScoringSegmentRangesTable[]
    GetSegmentScores()
    local skiplist=""
    local nrskip=0
    for i=1,segCnt2-len+1 do
        if not CheckDone(i,i+len-1) and MustWorkon(i,i+len-1)
        then
            local s=getPartscore(i,i+len-1)
            wrst[#wrst+1]={s,i} -- now l_XLowestScoringSegmentRangesTable[]
        else
            if CheckDone(i,i+len-1)
            then
                if nrskip==0 then print("Skipping") end
                nrskip=nrskip+1
                skiplist=skiplist..i.."-"..(i+len-1).." "
                if nrskip%7==0 then
                    print(skiplist)
                    skiplist=""
                end
            end
        end
    end
    if nrskip%7 ~= 0 then print(skiplist) end
    if nrskip > 0 then print("Number of skips: "..nrskip) end
    wrst=Sort(wrst,reBuild) -- now l_XLowestScoringSegmentRangesTable[]
    areas={} -- now g_XLowestScoringSegmentRangesTable[]
    local rb=reBuild
    if rb>#wrst then rb=#wrst end -- now l_XLowestScoringSegmentRangesTable[]
    for i=1,rb do
        local w=wrst[i] -- now l_XLowestScoringSegmentRangesTable[]
        local ss=w[2]
        areas[#areas+1]={ss,ss+len-1} -- now g_XLowestScoringSegmentRangesTable[]
    end
    if firsttime and #wrst == 0 then -- now l_XLowestScoringSegmentRangesTable[]
        print("No possibilities left so clearing Done list")
        ClearDoneList()
        FindWorst(false) -- recursion
    end
end -- FindWorst()
-- Rebuild section
function localRebuild(maxiters) -- now RebuildSelectedSegments()
  -- Called from ReBuild() below; now RebuildOneSegmentRangeManyTimes()
  -- Calls structure.RebuildSelected(); foldit code
  
  local l_TimeBefore = os.clock()

  if maxiters==nil then
    maxiters = 3
  end
  local s=Score()
  local i=0
  if bandflip then band.DisableAll() end
  Bridgesave()
  
  repeat
    
    i=i+1
    if i > maxiters then
      break
    end
          
    -- Important!!!
    -- Important!!!
    -- Important!!!
    structure.RebuildSelected(i)
    -- Important!!!
    -- Important!!!
    -- Important!!!       
        
  until Score()~=s and BridgesBroken() == false
    
  if bandflip then
    band.EnableAll()
  end
  Bridgerestore()
  
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  l_Score_After_Rebuild = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Rebuild - g_Score_ScriptBest
  if l_ScoreImprovement > 0.001 then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" .. 
          PaddedNumber(l_ScoreImprovement, 8, 3) .. " " .. 
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          i .. "xRebuildSelected" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y)
        
    g_Stats_Run_TotalPointsGained_RebuildSelected =
    g_Stats_Run_TotalPointsGained_RebuildSelected + l_ScoreImprovement
    g_Stats_Run_SuccessfulAttempts_RebuildSelected = 
    g_Stats_Run_SuccessfulAttempts_RebuildSelected + 1
  elseif l_Score_After_Rebuild < g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " " .. 
      PaddedNumber(l_ScoreImprovement, 8, 3) .. " " .. 
      PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
      i .. "xRebuildSelected" ..
      g_round_x_of_y ..
      g_with_segments_x_thru_y)
    g_Stats_Run_SuccessfulAttempts_RebuildSelected = 
    g_Stats_Run_SuccessfulAttempts_RebuildSelected + 1
    -- the original code would break here and return done=true at the end of this function
    -- the original code did not call recentbest.Restore()
    -- Should we undo our last change because it caused a drop in our score?
    -- Maybe not. We might allow a small drop with the hope to 
    -- recover points with a mutate, shake and wiggle...
    --recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_RebuildSelected = 
  g_Stats_Run_TotalSecondsUsed_RebuildSelected + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_RebuildSelected = 
  g_Stats_Run_NumberOfAttempts_RebuildSelected + 1
  
  if Score() ~= s then 
    return true 
  else 
    return false
  end
    
end -- function localRebuild(maxiters); now RebuildSelectedSegments()
function ReBuild(ss,se,tries) -- now RebuildOneSegmentRangeManyTimes()
  -- Called from DeepRebuild() way below; now RebuildManySegmentRanges()
  -- Calls localRebuild() above; now RebuildSelectedSegments()
  
  ClearScores() --reset score tables
  if ss>se then ss,se=se,ss end --switch if needed
  local Foundone=false
  local l_NumberOfTimesStructureChanged = 0
  
  for try = 1, tries do -- perform loop for number of tries
    
    if SKETCHBOOKPUZZLE then save.Quickload(3) end
    selection.DeselectAll()
    CI(rebuildCI)
    selection.SelectRange(ss,se)
    g_with_segments_x_thru_y = " w/segments " .. ss .. "-" .. se		

    -- local extra_rebuilds = 1
    -- if savebridges then extra_rebuilds=3 end --extra if bridges keep breaking
    local done
    -- repeat
    
    -- Important!!!
    -- Important!!!
    -- Important!!!      
    done = localRebuild(try) -- above; now RebuildSelectedSegments()
    -- Important!!!
    -- Important!!!
    -- Important!!!      
  
    -- extra_rebuilds = extra_rebuilds -1
    -- until done or extra_rebuilds == 0
    SaveBest()
    
    if done==true then
      l_NumberOfTimesStructureChanged = l_NumberOfTimesStructureChanged + 1
      Foundone=true
      Bridgesave()
      
      if doSpecial==true then
        SelectAround(ss,se,9)
        CI(1)
        Wiggle("s",1,nil,true,"ReBuild1")
        Wiggle("ws",2,nil,true,"ReBuild2")
        selection.DeselectAll()
        selection.SelectRange(ss,se)
        Wiggle("wb",4,nil,true,"ReBuild3")
        SelectAround(ss,se,9)
      elseif doShake==true then
        CI(shakeCI)
        Wiggle("s",1,nil,true,"ReBuild4")
      end
      
      Bridgerestore()
      if AfterRB then
        PushPosition() --save the current position for next round
        doMutate("AfterRebuild")
      end
      SaveScores(ss,se,try)
      if AfterRB then PopPosition() end
        
    end -- if done==true then
    
  -- if (try > 3 or savebridges) and Foundone==false then
    if Foundone==false then
      --print("No valid rebuild found on this section")
      --print("After 9 or more rebuild attempts, giving up")
      break            
    end
      
  end -- for try=1,tries do
  
  CI(1)
  
  print("l_NumberOfTimesStructureChanged = " .. l_NumberOfTimesStructureChanged)
	  
  return Foundone
  
end -- function ReBuild(ss,se,tries); now RebuildOneSegmentRangeManyTimes()
-- end rebuild section
-- section to compute segmentscore(part)s
function getPartscore(ss,se,attr) -- now Get_ScorePart_Score()
    local s=0
    if attr=='total' then
        s=Score()
    elseif attr==nil then --is only called from findWorst
        for i=ss,se do
            s=s+SegmentScores[i]
        end
    elseif attr=='loctotal' then --total segment scores
        s=GetSubscore(nil,ss,se)
    elseif attr=='ligand' then --ligand score
        for i=segCnt2+1,segCnt do s=s+current.GetSegmentEnergyScore(i) end
    else
        s=GetSubscore(attr,ss,se)
    end
    return s
end
function InitWORKONbool() -- now see main()
    WORKONbool= -- now g_bSegmentsToRebuildBooleanTable[]
      SegmentSetToBool( -- see main()
        WORKON) -- now 

  -- Differences between the "WORKON/WORKONbool" tables and the "areas" table:

  -- WORKON is a "segment range" table: now UserSelectedSegmentRangesToRebuild[]
  -- WORKON starts out as {{1,SegmentCountWithoutLigands}}
  -- The user can change the values in the WORKON table on the "Select Segments to Rebuild" page.
  -- Then we remove all Frozen, Locked and Ligand segments from WORKON. 
  -- Lastly, we convert WORKON to WORKONbool

  -- WORKONbool is a "segment" table:
  -- This has the same segments as those represented by the segment ranges in WORKON.
  -- Being at the "segment" level and boolean format, makes it easy to check individual
  -- segments to see if they are allowed to be rebuilt.

  -- "areas" is a "segment range" table:  now g_XLowestScoringSegmentRangesTable[]
  -- "areas" are the Lowest Scoring Segment Ranges about to be rebuilt, etc

  -- The rebuild process is primarily driven by the "areas" table. But when forming segment ranges it calls
  -- MustWorkon() which checks the "WORKONbool" table to make sure the range does not contain any frozen,
  -- locked or ligand segment.
end
function MustWorkon(i,j) -- now bSegmentRangeIsAllowedToBeRebuilt() + bSegmentIsAllowedToBeRebuilt()
    for k=i,j do if not 
      WORKONbool[k] -- now g_bSegmentsToRebuildBooleanTable[]
      then return false end end
    return true
end
function GetSegmentScores() -- now Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()
    if lastSegScores~=Score() then
        lastSegScores=Score()
        for i=1,segCnt2 do
            if WORKONbool[i] then -- now g_bSegmentsToRebuildBooleanTable[]
                if #scrPart==0 then
                    -- if nothing specified by user default is
                    -- segmentenergy - reference + extra Density score
                    SegmentScores[i]=current.GetSegmentEnergyScore(i)
                    if not structure.IsMutable(i) then --ignore reference part but NOT for mutables)
                        SegmentScores[i]=SegmentScores[i]-current.GetSegmentEnergySubscore(i,'reference')
                    end
                    if math.abs(DENSITYWEIGHT) > 0 then --the Density component has extra weight
                        SegmentScores[i]=SegmentScores[i]+DENSITYWEIGHT*current.GetSegmentEnergySubscore(i,'density')
                    end
                else
                    SegmentScores[i]=GetSubscore(scrPart,i,i)
                end
            end
        end
    end
end
-- end section segmentscore(part)s
-- Administration of the different slots and best scores
Scores={} --{save_no,points,totscore,showlist,todo,rbnr} -- now g_ScorePart_Scores_Table
-- Compute which scoreparts to use
ActiveSub= -- now g_ActiveScorePartsTable[]
FindActiveSubscores(false) -- was true -- now Populate_g_ActiveScorePartsTable()
ScoreParts={ --{save_no,name,active,longname} -- now g_ScorePartsTable[] -- now in Populate_g_ScorePartsTable()
    {4,'total',true,'4(total)'},
    {5,'loctotal',true,'5(loctotal)'}
}
nextslot=6
if HASLIGAND then -- now in Populate_g_ScorePartsTable()
    ScoreParts[#ScoreParts+1] = { nextslot,'ligand',true,nextslot..'(ligand)'}
    nextslot=nextslot+1
    print("Ligand slot enabled")
end
for i=1,#ActiveSub do -- now in Populate_g_ScorePartsTable()
    if ActiveSub[i] ~='Reference' then
        ScoreParts[#ScoreParts+1] = { nextslot,ActiveSub[i],true,nextslot..'('..ActiveSub[i]..')' }
        nextslot=nextslot+1
    end
end
function ClearScores() -- now Populate_g_ScorePart_Scores_Table()
    Scores={} -- now g_ScorePart_Scores_Table[]
    for i=1,#ScoreParts do -- now g_ScorePartsTable[]
        if ScoreParts[i][3] then
            Scores[#Scores+1]={ScoreParts[i][1],-9999999,-9999999,'',false,-1}
        end
    end
    slotScr={}
end
function SaveScores(ss,se,RBnr) -- Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields
    local scr={} -- now l_ActiveScorePartsScoreTable[]
    for i=1,#ScoreParts do -- now g_ScorePartsTable[]
        if ScoreParts[i][3] then
            scr[#scr+1]= -- now l_ActiveScorePartsScoreTable[]
            {ScoreParts[i][1],getPartscore(ss,se,ScoreParts[i][2])}
        end
    end
    local totscore=Score() -- now GetPoseTotalScore()
    for i=1,#Scores do -- now g_ScorePart_Scores_Table[]
        local s=scr[i][2]
        if s>Scores[i][2] then
            local slot=scr[i][1] -- now ScorePart_Number
            save.Quicksave(slot) --print("Saved slot ",slot," pts" ,s) --debug
            Scores[i][2]=s
            Scores[i][3]=totscore
            Scores[i][6]=RBnr
        end
    end
    SaveBest()
end
function ListSlots()--Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_...
  -- was Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInString()
  --Give overview of slot occupation
  --And sets which slots to process
    local Donelist={} -- now l_ScorePartScoresDoneStatusTable[]
    for i=1,#Scores do -- now g_ScorePart_Scores_Table[]
      Donelist[i]=false end -- now l_ScorePartScoresDoneStatusTable[]
    local Report=""
    for i=1,#Scores do -- now g_ScorePart_Scores_Table[] 
      if not Donelist[i] then -- now l_ScorePartScoresDoneStatusTable[]
        local Curlist=" "..
          Scores[i][1] -- now g_ScorePart_Scores_Table[]
        Scores[i][5]=true --This one we have to process
        -- Now find identical filled slots
        for j=i+1,#Scores do if Scores[j][3] == Scores[i][3] then -- now g_ScorePart_Scores_Table[]
            Curlist=Curlist.."="..
              Scores[j][1] -- now g_ScorePart_Scores_Table[]
            Donelist[j]=true -- now l_ScorePartScoresDoneStatusTable[]
        end end
        Scores[i][4]= -- now g_ScorePart_Scores_Table[]
          Curlist -- now g_ScorePart_Scores_Table[]
        Report=Report.." "..Curlist
    end end
    print("Slotlist:"..Report)
end
-- end of administration of slots and scores
function PrintAreas() -- now DisplaySegmentRanges()
    if #areas<19 then -- now g_XLowestScoringSegmentRangesTable[]
        local a=""
        local x=0
        for i=1,#areas do -- now g_XLowestScoringSegmentRangesTable[]
            x=x+1
            a=a..areas[i][1].."-"..areas[i][2].." " -- now g_XLowestScoringSegmentRangesTable[]
            if x>6 then
                print(a)
                a=""
                x=0
            end
        end
        if x>0 then print(a) end
    else
        print("It is "..#areas.." places, not listing.") -- now g_XLowestScoringSegmentRangesTable[]
    end
end
function AddLoop(sS) -- now Add_Loop_SegmentRange_To_SegmentRangesTable()
    local ss=sS
    local ssStart=structure.GetSecondaryStructure(ss)
    local se=ss
    for i=ss+1,segCnt2 do
        if structure.GetSecondaryStructure(i)==ssStart then se=i
        else break end
    end
    if se-ss+2>minLen and loops==true then
        areas[#areas+1]={ss,se} -- now g_XLowestScoringSegmentRangesTable[]
    end
    return se
end
function AddOther(sS) -- now Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable()
    local ss=sS
    local ssStart=structure.GetSecondaryStructure(ss)

    local se=ss
    if ss>1 then
        for i=ss-1,1,-1 do --search bacward for start
            local sec=structure.GetSecondaryStructure(i)
            if sec=="L" then ss=i
            else break end
        end
    end
    if se<segCnt2-1 then --now forward to find end
        local change=false
        repeat
            se=se+1
            if se==segCnt2 then break end
            local sec=structure.GetSecondaryStructure(se)
            if change==false then
                if sec~=ssStart then change=true end
            end
        until change==true and sec~="L"
        if se<segCnt2 then se=se-1 end
    end
    if sheets==false and ssStart=="E" then return se end
    if helices==false and ssStart=="H" then return se end
    if se-ss+2>minLen then
        areas[#areas+1]={ss,se} -- now g_XLowestScoringSegmentRangesTable[]
    end
    return se
end
function FindAreas() -- now Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
    if loops then
        local done=false
        local ss=0
        repeat--loops
            ss=ss+1
            local ses=structure.GetSecondaryStructure(ss)
            if ses=="L" then
                ss=AddLoop(ss)
            end
            if ss==segCnt2 then done=true end
        until done~=false
    end
    if sheets or helices then
        local done=false
        local ss=0
        repeat--other
            ss=ss+1
            local ses=structure.GetSecondaryStructure(ss)
            if ses~="L" then
                ss=AddOther(ss)
            end
            if ss==segCnt2 then done=true end
        until done~=false
    end
end
firstRBseg=0
lastRBseg=0
function MutateSel(maxitter, l_FromWhere) -- now MutateSideChainsOfSelectedSegments()
  if maxitter == nil then maxitter=2 end
  local l_TimeBefore = os.clock()
    
    
    
  structure.MutateSidechainsSelected(maxitter)
  
  
    
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  l_Score_After_Mutate = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Mutate - g_Score_ScriptBest
  if l_ScoreImprovement > 0.001 then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
          PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsSelected" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText)
    
    g_Stats_Run_TotalPointsGained_MutateSidechainsSelected =
    g_Stats_Run_TotalPointsGained_MutateSidechainsSelected + l_ScoreImprovement
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected =
      g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected + 1
    --SaveBest() -- <-- Updates g_Score_ScriptBest
  
  elseif l_Score_After_Mutate < g_Score_ScriptBest then
    --recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected =
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected =
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected + 1    
    
end
function MutateAll(l_FromWhere) -- now MutateSideChainsAll()
    selection.SelectAll()
    MutateSel(maxitter, l_FromWhere)
end
function doMutate(l_FromWhere)  -- now MutateSideChainsOfSelectedSegments()
    if not HASMUTABLE then return end
    -- Do not accept loss if mutating
    local curscore=Score()
    PushPosition()
    CI(MutateCI)
    Bridgesave()
    if MUTRB then
        selection.DeselectAll()
        selection.SelectRange(firstRBseg,lastRBseg)
        MutateSel(nil, l_FromWhere)
    elseif MUTSur then
        SelectAround(firstRBseg,lastRBseg,MutSphere)
        MutateSel(nil, l_FromWhere)
    else
        MutateAll(l_FromWhere)
    end
    Bridgerestore()
    if Score() < curscore then PopPosition() else ClrTopPosition() end
end
function DeepRebuild() -- now RebuildManySegmentRanges()
  -- Called from DRcall() below; now PrepareToRebuildSegmentRanges()
  -- Calls ReBuild() way above; now RebuildOneSegmentRangeManyTimes()
  
  local ss=Score()
  print("Deep"..action.." started at score: "..round3(ss))
  if struct==false then AllLoop() end
  save.Quicksave(3)
  recentbest.Save()

  for i = 1, #areas do -- now g_XLowestScoringSegmentRangesTable[]
    
    local ss1=Score()
    local s=areas[i][1] -- now g_XLowestScoringSegmentRangesTable[]
    local e=areas[i][2] -- now g_XLowestScoringSegmentRangesTable[]
    local CurrentHigh=0
    local CurrentAll="" -- to report where gains came from
    local CurrentHighScore= -99999999
    firstRBseg=s
    lastRBseg=e
    Bridgesave()
    
    if Runnr > 0 then --Runnr 0 is to skip worst parts
      
      --print("DR "..Runnr.."."..(e-s+1).."."..i.." "..s.."-"..e.." "..
      --     rebuilds.." times. Wait... Current score: "..round3(Score()))
      if SKETCHBOOKPUZZLE then
        foundahighgain=false
      end
      
      -- Important!!!
      -- Important!!!
      -- Important!!!      
      if ReBuild(s,e,rebuilds) == true then -- way above; now RebuildOneSegmentRangeManyTimes()        
      -- Important!!!
      -- Important!!!
      -- Important!!!        

        if SKETCHBOOKPUZZLE == false then
          -- Make sure we do not miss an improvement during rebuild
          if RBScore() > bestScore then
              Bridgesave()
              recentbest.Restore()
              Bridgerestore()
              if Score() > bestScore+0.00001 then
                  print("Found a missed gain!!!")
                  SaveScores(s,e,0)
              end
          end
        end
        
        ListSlots()
        for r=1,#Scores do
            if Scores[r][5] then
                local slot=Scores[r][1]
                save.Quickload(slot)
                SelectAround(s,e,12) --local shake after rebuild/remix
                Bridgesave()
                if not skipqstab then qStab()
                else
                    CI(1)
                    Wiggle("s",1,nil,true,"DeepBuild1")
                    Wiggle("ws",1,nil,true,"DeepBuild1")
                end
                Bridgerestore()
                if AfterQstab then doMutate("AfterQstab") end
                save.Quicksave(slot)
                if Score() > CurrentHighScore then
                     CurrentHigh=slot
                     CurrentAll=Scores[r][4].."(RB"..Scores[r][6]..")"
                     CurrentHighScore=Score()
                end
                SaveBest()
                print("Stabilized score: "..round3(Score()).." from slot "..ScoreParts[slot-3][4])
            end
        end
        save.Quickload(CurrentHigh)
        
        if not skipfuze and ss1-Score() < maxlossbeforefuze*(e-s+1)/3 then
            print("Fuzing best position.")
            if not AfterQstab and BeFuze then doMutate("BeforeFuze") end
            save.Quicksave(4)
            if savebridges then
              Fuze(4,Bridgesave,Bridgerestore,localshakes)
            else
              Fuze(4,nil,nil,localshakes)
            end
            if AfterFuze then
              doMutate("AfterFuze")
            end
        end -- if not skipfuze and ss1-Score() < maxlossbeforefuze*(e-s+1)/3 then
        
        SaveBest()
        save.Quickload(3)
        
      else
        
        save.Quickload(3)
        
      end
      
    end -- if Runnr > 0 then
    
    if savebridges then
        if BridgesBroken() then
            -- THIS SHOULD NOT HAPPEN
            print("Unexpected bridge broken, pls report\n")
            print("Restoring a good position, discarding wins\n")
            Bridgerestore()
            save.Quicksave(3)
            bestScore=Score()
        else Bridgerestore()
        end
    else
      Bridgerestore()
    end
    
    if ss1+0.00001 < Score() then
      --print("Gain from slots ",CurrentAll)
    end
    
    AddDone(s,e)
    ChkDoneList()
    
    if Score()-ss > minGain then
      print("\n  The current rebuild gain of " .. PrettyNumber(Score()-ss) ..
               " is greater than the 'Move on to more consecutive segments per range if" ..
               " current rebuild points gained is more than' value of " ..
                minGain .. 
               " points (this value can be changed on the 'More Options' page);" ..
               " therefore, we will now skip the" .. 
            "\n  remaining " .. 0 .. " segment ranges with " ..
                g_RequiredNumberOfConsecutiveSegments .. 
               " consecutive segments, and begin processing segments ranges with " ..
                (g_RequiredNumberOfConsecutiveSegments + 1) .. " consecutive segments.")      
      
      
      break
    end
    
  end -- for i = 1, #areas do 

  print("Deep"..action.." gain: "..round3(Score()-ss))
  
  if struct==false and SAVEDstructs then
    save.LoadSecondaryStructure()
  end
  
end -- function DeepRebuild(); now RebuildManySegmentRanges()
function DRcall(how) -- now PrepareToRebuildSegmentRanges()
  -- Called from DRW() way below; now main()
  -- Calls DeepRebuild() above; now RebuildManySegmentRanges()
  
  if how=="drw" then
    
    local stepsize=1
    if minLen>maxLen then stepsize= -1 end
    for i=minLen,maxLen,stepsize do --search from minl to maxl worst segments
      len=i
      FindWorst(true) -- Populate_g_SegmentRangesTable_WithWorstScoringSegmentRanges()
      --fills areas table. Comment it if you have set them by hand
      
      PrintAreas() -- now DisplaySegmentRanges()
      
      -- Important!!!
      -- Important!!!
      -- Important!!!      
      DeepRebuild() -- see above; now RebuildManySegmentRanges()
      -- Important!!!
      -- Important!!!
      -- Important!!!      
      
    end -- for i=minLen,maxLen,stepsize do
  
  elseif how=="fj" then --DRW len cutted on pieces
    FindWorst(true) --add to areas table worst part
    areas2={}  -- now l_XLowestScoringSegmentRangesTable[]
    for a=1,#areas do -- now g_XLowestScoringSegmentRangesTable[]
      local s=areas[a] --{ss,se} -- now g_XLowestScoringSegmentRangesTable[]
      local ss=s[1] --start segment of worst area
      local se=s[2] --end segment of worst area
      for i=ss,se do
        for x=1,len do
          if i+x<=se then
            areas2[#areas2+1]={i,i+x} -- now l_XLowestScoringSegmentRangesTable[]
          end
        end
      end
    end
    areas=areas2 -- now g_ and l_XLowestScoringSegmentRangesTable[]
    PrintAreas()
    DeepRebuild()
  elseif how=="all" then
    areas={} -- now g_XLowestScoringSegmentRangesTable[]
    for i=minLen,maxLen do
        for x=1,segCnt2 do
            if i+x-1<=segCnt2 then
                areas[#areas+1]={x,x+i-1} -- now g_XLowestScoringSegmentRangesTable[]
            end
        end
    end
    PrintAreas()
    DeepRebuild()
  elseif how=="simple" then
    FindWorst(true)
    PrintAreas()
    DeepRebuild()
  elseif how=="areas" then -- now g_XLowestScoringSegmentRangesTable[]
    areas={} -- now g_XLowestScoringSegmentRangesTable[]
    FindAreas()
    PrintAreas()
    DeepRebuild()
  end
end
function AskMoreOptions()
    local ask=dialog.CreateDialog("More "..progname.." options")
    ask.fastQstab=dialog.AddCheckbox("Do a fast qStab",fastQstab)
    ask.ll3 = dialog.AddLabel("Force next round if gain is more")
    ask.minGain = dialog.AddSlider("MinGain:",minGain,0,500,0)
    ask.ll4 = dialog.AddLabel("Skip fuze if loss is more")
    ask.ll5 = dialog.AddLabel("Threshold used is RBlength*threshold/3")
    ask.maxLoss = dialog.AddSlider("Skip fuze:",maxlossbeforefuze,-5,200,0)
    ask.donotrevisit = dialog.AddCheckbox("Do not things twice",donotrevisit)
    ask.l1=dialog.AddLabel("Clear no revisit list if gain is more")
    ask.revlist=dialog.AddSlider("Cleargain:",clrdonelistgain,0,500,0)
    ask.l2=dialog.AddLabel("Number of "..action.." each pass")

    ask.nrrebuilds=dialog.AddSlider(action..":",rebuilds,1,100,0)

    ask.reBuild=dialog.AddSlider("#in first cycle:",reBuild,1,segCnt2,0)
    ask.reBuildm=dialog.AddSlider("#add each cycle:",reBuildmore,0,4,0)
    ask.doSpecial=dialog.AddCheckbox("Local cleanup after "..action.." SLOW",doSpecial)
    ask.doShake=dialog.AddCheckbox("Or Shake after "..action,doShake)
    ask.shakeCI=dialog.AddSlider("Shake CI:",shakeCI,0,1,2)
    ask.skipqstab=dialog.AddCheckbox("Local shake instead of Qstab",skipqstab)
    ask.skipfuze=dialog.AddCheckbox("Skip Fuze",skipfuze)
    ask.OK = dialog.AddButton("OK",1)
    dialog.Show(ask)
    fastQstab=ask.fastQstab.value
    minGain=ask.minGain.value
    maxlossbeforefuze=ask.maxLoss.value
    clrdonelistgain=ask.revlist.value

    rebuilds=ask.nrrebuilds.value

    reBuild=ask.reBuild.value
    reBuildmore=ask.reBuildm.value
    doShake=ask.doShake.value
    doSpecial=ask.doSpecial.value
    shakeCI=ask.shakeCI.value
    skipqstab=ask.skipqstab.value
    donotrevisit=ask.donotrevisit.value
    skipfuze=ask.skipfuze.value
end
function AskMutateOptions()
    local ask = dialog.CreateDialog("Mutate Options")
    ask.AfterRB = dialog.AddCheckbox("Mutate after "..action,AfterRB)
    ask.InQstab = dialog.AddCheckbox("Mutate during Qstab",InQstab)
    ask.AfterQstab = dialog.AddCheckbox("Mutate after Qstab",AfterQstab)
    ask.BeFuze = dialog.AddCheckbox("Mutate before Fuze",BeFuze)
    ask.AfterFuze = dialog.AddCheckbox("Mutate after Fuze",AfterFuze)
    ask.l1=dialog.AddLabel("-----What to rebuild, last one counts or all")
    ask.OnlyRB=dialog.AddCheckbox("Mutate only "..action.." part",MUTRB)
    ask.OnlySur=dialog.AddCheckbox("Mutate "..action.." and surround",MUTSur)
    ask.l2=dialog.AddLabel("Sphere size to use with surround")
    ask.SurSize=dialog.AddSlider("Sphere:",MutSphere,3,15,0)
    ask.MutateCI=dialog.AddSlider("MutateCI:",MutateCI,0.1,1,2)
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    if dialog.Show(ask) > 0 then
        AfterRB=ask.AfterRB.value
        InQstab=ask.InQstab.value
        AfterQstab=ask.AfterQstab.value
        BeFuze=ask.BeFuze.value
        AfterFuze=ask.AfterFuze.value
        MutateCI=ask.MutateCI.value
        MutSphere=ask.SurSize.value
        MUTRB=ask.OnlyRB.value
        MUTSur=ask.OnlySur.value
        if MUTSur then MUTRB=false end
    end
end
function printOptions(title) -- now DisplayUserSelectedOptions()
    print(title.." Based on rav4pl DRW 3.4")
    print("Length of "..action..": "..minLen.." to "..maxLen)
    print(action.." area: "..
      SegmentSetToString( -- now ConvertSegmentRangesTableToListOfSegmentRanges()
      WORKON)) -- now g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[]
    print("Nr of "..action.." each try: "..rebuilds)
    if WF>1 then print("Wiggle factor "..WF) end
    if not struct then print("Convert everything to loops") end
    if not donotrevisit then print("Will retry already tried "..action)
    else
        print("Clear retry blockings if gain raises above "..clrdonelistgain.." pts")
    end
    if doSpecial then print("Local cleanup after "..action)
    elseif doShake then
        print("Initial shake after "..action.." with CI="..shakeCI)
    end
    if skipqstab then print("Local shake instead of qStab") end
    if skipfuze then print("Skipping Fuzes") end
    print("Nr of full cycles: "..maxnrofRuns)
    if nrskip > 0 then print("SKIPPING "..nrskip.." worst segmentparts") end
    if disjunct then print("Running in disjunct mode") end
end
function AskSubScores() -- now AskUserToSelectScorePartsForStabilize()
    local ask = dialog.CreateDialog("Slot selection "..progname..DRWVersion)
    ask.l1=dialog.AddLabel("Specify which slots based on scorepart to use")
    for i=1,#ScoreParts do -- now g_ScorePartsTable[]
        ask[ScoreParts[i][2]]= -- now g_ScorePartsTable[]
          dialog.AddCheckbox(ScoreParts[i][1].." ".. -- now g_ScorePartsTable[]
          ScoreParts[i][2], -- now g_ScorePartsTable[]
          ScoreParts[i][3]) -- now g_ScorePartsTable[]
    end
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    if dialog.Show(ask) > 0 then
      for i=1,#ScoreParts do  -- now g_ScorePartsTable[]
        ScoreParts[i][3]= -- now g_ScorePartsTable[]
          ask[ScoreParts[i][2]].value -- now g_ScorePartsTable[]
      end
    end
end
function AskSelScores() -- now AskUserToSelectScorePartsForCalculatingWorseScoringSegments()
    local ask = dialog.CreateDialog("Set worst searching "..progname..DRWVersion)
    ask.l1=dialog.AddLabel("Specify which worst subscoretotal(s) to count")
    for i=3,#ScoreParts do
        ask[ScoreParts[i][2]]=dialog.AddCheckbox(ScoreParts[i][2],false)
    end
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    scrPart={} -- now g_UserSelected_ScorePartsForCalculatingWorseScoringSegmentsTable[]
    if dialog.Show(ask) > 0 then
      for i=3,#ScoreParts do
        if ask[ScoreParts[i][2]].value then 
          scrPart[#scrPart+1]=ScoreParts[i][2] -- now g_UserSelected_ScorePartsForCalculatingWorseScoringSegmentsTable[]
        end
      end
    end
end
function AskDRWOptions() -- now bAskUserToSelect_RebuildOptions()
    local askresult
    local askmutable=HASMUTABLE
    local ask = dialog.CreateDialog("Tvdl enhanced "..progname..DRWVersion)
    if askmutable then
        print("Setting default mutate options")
        AfterQstab=true
        AfterFuze=true
        MutSur=true
    end
repeat
    ask.l1 = dialog.AddLabel("Length to rebuild, From can be bigger than To")
    ask.minLen = dialog.AddSlider("From length:",minLen,1,10,0)
    ask.maxLen = dialog.AddSlider("To length:",maxLen,1,10,0)
if SKETCHBOOKPUZZLE then
    ask.MINGAIN = dialog.AddSlider("Mingain:",MINGAIN,0,100,0)
end
    ask.lll=dialog.AddLabel("Wiggle more when CI is on its maximum")
    ask.WF = dialog.AddSlider("WiggleFactor:",WF,1,5,0)
    ask.slotl=dialog.AddLabel("Slot selection, last choice counts")
    ask.selall=dialog.AddCheckbox("All slots",SlotAll)
    ask.sel4=dialog.AddCheckbox("4 main slots, faster",Slot4)
    ask.selSP= dialog.AddCheckbox("(Re)select slots",false)

    ask.ll3=dialog.AddLabel("Number of full cycles")
    ask.nrcycles=dialog.AddSlider("Cycles:",maxnrofRuns,1,40,0)

    ask.ll4=dialog.AddLabel("Skip first worst parts (crash resume)")
    ask.nrskip=dialog.AddSlider("Skip parts:",nrskip,0,segCnt2,0)
    ask.SEL= -- now l_bUserWantsToSelectSegmentsToRebuild
      dialog.AddCheckbox("(Re)select where to work on ",false) -- now "Select Segments to Rebuild..."
    if HASMUTABLE then
        ask.MUTS = dialog.AddCheckbox("(Re)set Mutate Options",askmutable)
    end
    ask.localshakes=dialog.AddCheckbox("Do shakes only local",localshakes)
    ask.worst= dialog.AddCheckbox("(Re)set worst search params",false)
    if nrofbridges > 1 then ask.bridge = dialog.AddCheckbox("Keep sulfide bridges intact",savebridges) end

    ask.struct = dialog.AddCheckbox("Do not change all to loop",struct)

    ask.l6=dialog.AddLabel("Search only for disjunct from previous done")
    ask.disjunct=dialog.AddCheckbox("Disjunct",disjunct)
    ask.bandflip=dialog.AddCheckbox("Disable bands during rebuild AND enable after",bandflip)
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    ask.Options = dialog.AddButton("More options",2)
    askresult=dialog.Show(ask)
    if askresult > 0 then
        minLen=ask.minLen.value
        maxLen=ask.maxLen.value

        maxnrofRuns=ask.nrcycles.value

        nrskip=ask.nrskip.value
        bandflip=ask.bandflip.value
        disjunct=ask.disjunct.value

        struct=ask.struct.value

if SKETCHBOOKPUZZLE then
        MINGAIN=ask.MINGAIN.value
end
        WF=ask.WF.value
        SlotAll=ask.selall.value
        if SlotAll then
            for i=1,#ScoreParts do ScoreParts[i][3]=true end
        end
        Slot4=ask.sel4.value
        if Slot4 then
            for i=1,#ScoreParts do
                if ScoreParts[i][1] == 4 then ScoreParts[i][3]=true
                elseif ScoreParts[i][2] == 'Backbone' then ScoreParts[i][3]=true
                elseif ScoreParts[i][2] == 'Hiding' then ScoreParts[i][3]=true
                elseif ScoreParts[i][2] == 'Packing' then ScoreParts[i][3]=true
                else ScoreParts[i][3]=false end
            end
        end
        localshakes=ask.localshakes.value
        if nrofbridges > 1 then savebridges=ask.bridge.value end
        if ask.SEL.value then -- now l_bUserWantsToSelectSegmentsToRebuild
            Slot4=false
            SlotAll=false
            local SelMode={}
            SelMode.askignorefrozen=false
            SelMode.defignorefrozen=true
            SelMode.askignorelocks=false
            SelMode.defignorelocks=true
            SelMode.askligands=false
            SelMode.defligands=false
            WORKON= -- now g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[] 
              AskForSelections( -- now AskUserToSelectSegmentsRangesToRebuild()
                "Tvdl enhanced "..progname..DRWVersion,SelMode)
            print("Selection is now, reselect if not oke:")
            print(SegmentSetToString( -- now ConvertSegmentRangesTableToListOfSegmentRanges()
              WORKON)) -- now g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[]
            if askresult==1 then askresult=4 end --to force return to main menu
        end
        if ask.selSP.value then
            AskSubScores() -- now AskUserToSelectScorePartsForStabilize()
            if askresult==1 then askresult=4 end
        end
        for i=1,#ScoreParts do if ScoreParts[i][3] then
            --print("Active slot "..ScoreParts[i][1].." is "..ScoreParts[i][2])
        end end
        if ask.worst.value then
            AskSelScores() -- now AskUserToSelectScorePartsForCalculatingWorseScoringSegments()
            if askresult==1 then askresult=4 end
        end
        -- Do not try to rebuild frozen or locked parts or ligands
        WORKON=SegmentSetMinus(WORKON,FindFrozen()) -- now g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[]
        WORKON=SegmentSetMinus(WORKON,FindLocked())
        WORKON=SegmentSetMinus(WORKON,FindAAtype("M"))
        if HASMUTABLE then if ask.MUTS.value then
            AskMutateOptions()
            askmutable=false
            if askresult==1 then askresult=4 end --to force return to main menu
        end end
        if HASMUTABLE then
           print("Mutate options are now:")
           local Mess="Mutates "
           if AfterRB then Mess=Mess.."after each rebuild, " end
           if InQstab then Mess=Mess.."inside qStab, " end
           if AfterQstab then Mess=Mess.."after qStab, " end
           if BeFuze then Mess=Mess.."before Fuzing, " end
           if AfterFuze then Mess=Mess.."after Fuzing." end
           print(Mess)
           Mess="Mutate area "
           if MUTRB then Mess=Mess.."is Rebuild parts only"
           elseif MUTSur then Mess=Mess.."is Rebuild part and surroundings"
           else Mess=Mess.."is the whole protein" end
           print(Mess)
        end
        if askresult==2 then AskMoreOptions() end
    end
until askresult < 2
    return askresult > 0
end
for i=3,12 do save.Quicksave(i) end -- ...quick fix for failing first rebuild.
--[[
    USAGE
1. 'drw' - need 'minLen' and 'maxLen'; finding worst scores by len betwen that 2
2. 'fj' - need 'len'; searching len then cutting in pieces 2->len and rebuilds pieces
3. 'all' - need 'minLen' and 'maxLen'; rebuilding ENTIRE prorein (from min to max) like in WalkinRebuild script
4. 'simple' - need 'len'; find and rebuild worst scoring parts of that lenght
5. 'areas' - need secondary structure set and 'true' on at least one of structure
]]--
areas={  -- now g_XLowestScoringSegmentRangesTable[]
--start segment, end segment. use for last line call
--{1,10},
--{20,30},
--{32,35},
}
scrPart={} -- now g_UserSelected_ScorePartsForCalculatingWorseScoringSegmentsTable[]
--options for (5)"areas" setting
loops=true --rebuild loops alone
sheets=false --rebuild sheets + surrounding loops
helices=true --false --rebuild helices + surrounding loops
doShake=true --false --shake rebuilded area (only!) every rebuild, slowing down process
doSpecial=false -- local shake, wiggle sidec, wiggle backbone, even slower
shakeCI=0.31 --clash imortance while shaking
struct=false --set in all loop (if true work in structure mode)
fastQstab=true --false --if true faster stabilize, but longer
reBuild=4 --up to worst parts to look at
reBuildmore=1 --increased by every main cycle
rebuilds=15 --how many rebuilds to try, set at least 10!
rebuildCI=0 --clash importance while rebuild
len=6 --find worst segments part
minLen=2 --or specify minimum len -- now g_UserSelected_StartRebuildingWithThisManyConsecutiveSegments
maxLen=4 --and maximim len -- now g_UserSelected_ResetToStartValueAfterRebuildingWithThisManyConsecutiveSegments
-- New options
maxnrofRuns=5 -- 40 -- Set it very high if you want to run forever
Runnr=0
minGain=(segCnt2-segCnt2%4)/4 -- If less gain then try the next one, else recompute
if minGain < 40 then minGain=40 end
skipqstab=false
skipfuze=false
bandflip= band.GetCount() > 0
maxlossbeforefuze=(segCnt2-segCnt2%4)/4 -- if loss is more no fuze is done
if maxlossbeforefuze < 30 then maxlossbeforefuze=30 end
nrskip=0
localshakes=true
AfterRB=false
InQstab=false
AfterQstab=false
BeFuze=false
AfterFuze=false
MutateCI=0.9
MutSphere=8
MUTRB=false
MUTSur=false
if HASMUTABLE then
    AfterQstab=true
    AfterFuze=true
    MUTSur=true
end
Slot4=false
SlotAll=true
WORKON={{1,segCnt2}} -- now g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[]
-- part to administrate what has been done
Donepart={} --To find fast if to be skipped
Blocked={} --A simple list so we can clear Donepart
Disj={} --To administrate which segments have be touched
disjunct=false
donotrevisit=true
clrdonelistgain=segCnt
if clrdonelistgain > 500 then clrdonelistgain=500 end
curclrscore=Score()
WORKONbool={} -- now g_bSegmentsToRebuildBooleanTable[]
SegmentScores={} --Optimalisation for fast worst search
lastSegScores=0
DRWVersion="3.1.1"
lookformissedgains=true
if SKETCHBOOKPUZZLE then
   lookformissedgains=false
   skipfuze=true
   clrdonelistgain=500
   struct=true
end
-- MAIN PROGRAM
firstDRWcall=true
DRWstartscore=0
function DRW() -- now main()
  -- Called from global code at bottom of script.
  -- Calls DRcall(); way above
  
  DefineGlobalVariables()

    if firstDRWcall then
        printOptions("Tvdl enhanced "..progname..DRWVersion) -- now DisplayUserSelectedOptions()
        firstDRWcall=false
    end
    InitWORKONbool() -- now see main()
    DRWstartscore=Score()
    if nrskip > 0 then
        local sreBuild=reBuild
        reBuild=nrskip
        Runnr=0
        DRcall("drw") -- not what you are looking for.
        nrskip=0
        reBuild=sreBuild
    end

print("------------------------ ------------------  ----------------  -------  ------------------")

  for nrofRuns=1, maxnrofRuns do
        
    Runnr=Runnr+1
      print("Main cycle nr ",Runnr)
   		print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "         " ..
        " " .. PaddedNumber((os.clock() - g_ScriptStartTime)/60, 7, 3) .. "m" ..
        " Start of Run " .. Runnr .. " of " .. maxnrofRuns .. "," ..
        " Rebuild " .. reBuild .. 
        " worst scoring segment ranges," .. 
        " w/" .. minLen .. 
        "-" .. maxLen ..
        " consecutive segments:")
      
      -- Important!!!
      -- Important!!!
      -- Important!!!      
    DRcall("drw") -- way above; now PrepareToRebuildSegmentRanges()
      -- Important!!!
      -- Important!!!
      -- Important!!!      
    
    -- DRcall("areas")
    -- DRcall("fj")
    -- DRcall("all")
    -- DRcall("simple")

    ChkDoneList()
    reBuild=reBuild+reBuildmore
  
      g_Stats_Run_EndTime = os.clock()
    local g_Stats_Run_ElaspedSeconds = g_Stats_Run_EndTime - g_Stats_Run_StartTime
    
    g_Stats_Run_TotalPointsGained_Total = 
      g_Stats_Run_TotalPointsGained_RebuildSelected +
      g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected +
      g_Stats_Run_TotalPointsGained_WiggleSelected +
      g_Stats_Run_TotalPointsGained_WiggleAll +
      g_Stats_Run_TotalPointsGained_MutateSidechainsSelected +
      g_Stats_Run_TotalPointsGained_MutateSidechainsAll
    if g_Stats_Run_TotalPointsGained_Total < 0.0001 then
       g_Stats_Run_TotalPointsGained_Total = 0.0001
    end
      
    g_Stats_Run_TotalSecondsUsed_Total = 
      g_Stats_Run_TotalSecondsUsed_RebuildSelected +
      g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected +
      g_Stats_Run_TotalSecondsUsed_WiggleSelected +
      g_Stats_Run_TotalSecondsUsed_WiggleAll +
      g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected +
      g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll
    
    g_Stats_Run_SuccessfulAttempts_Total = 
      g_Stats_Run_SuccessfulAttempts_RebuildSelected +
      g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected +
      g_Stats_Run_SuccessfulAttempts_WiggleSelected +
      g_Stats_Run_SuccessfulAttempts_WiggleAll +
      g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected +
      g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll
      
    g_Stats_Run_NumberOfAttempts_Total = 
      g_Stats_Run_NumberOfAttempts_RebuildSelected +
      g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected +
      g_Stats_Run_NumberOfAttempts_WiggleSelected +
      g_Stats_Run_NumberOfAttempts_WiggleAll +
      g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected +
      g_Stats_Run_NumberOfAttempts_MutateSidechainsAll
    
    print("------------------------ ------------------  ----------------  -------  ------------------")
    print("End of run " .. Runnr .. " Stats:")
    print("------------------------ ------------------  ----------------  -------  ------------------")
    print("From:                       Points Gained      Minutes Used    Pts/Min     Success Rate:")
    print("------------------------ ------------------  ----------------  -------  ------------------")
                                          
    print("RebuildSelected          " .. 
      PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected, 9, 3) .. "" .. 
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_RebuildSelected /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_RebuildSelected /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected /
                  (g_Stats_Run_TotalSecondsUsed_RebuildSelected / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_RebuildSelected .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_RebuildSelected, 0, 0), 9) .. 
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_RebuildSelected /
                   g_Stats_Run_NumberOfAttempts_RebuildSelected * 100, 4, 2) .. "%)", 9))
    print("ShakeSidechainsSelected  " ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected /
                  (g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected /
                   g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9))
    print("WiggleSelected           " .. 
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_WiggleSelected /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_WiggleSelected /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected /
                  (g_Stats_Run_TotalSecondsUsed_WiggleSelected / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_WiggleSelected .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_WiggleSelected, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_WiggleSelected /
                   g_Stats_Run_NumberOfAttempts_WiggleSelected * 100, 4, 2) .. "%)", 9))
    print("WiggleAll                " .. 
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_WiggleAll /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_WiggleAll /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll /
                   g_Stats_Run_TotalSecondsUsed_WiggleAll / 60, 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_WiggleAll .. "/" ..  
      PaddedNumber(g_Stats_Run_NumberOfAttempts_WiggleAll, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_WiggleAll /
                   g_Stats_Run_NumberOfAttempts_WiggleAll * 100, 4, 2) .. "%)", 9))
    print("MutateSidechainsSelected " ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected /
                  (g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected /
                   g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9))
    print("MutateSidechainsAll      " .. 
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll /
                   g_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
      
      PaddedNumber(g_Stats_Run_ElaspedSeconds * 
                  (g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll /
                   g_Stats_Run_TotalSecondsUsed_Total) / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 4, 2) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll /
                  (g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_MutateSidechainsAll, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll /
                   g_Stats_Run_NumberOfAttempts_MutateSidechainsAll * 100, 4, 2) .. "%)", 9))
    print("------------------------ ------------------  ----------------  -------  ------------------")
    print("Run total                " .. 
      PaddedNumber(g_Stats_Run_TotalPointsGained_Total, 9, 3) .. "" ..
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_Total /
                   g_Stats_Run_TotalPointsGained_Total * 100, 5, 1) .. "%)", 9) ..
               
      PaddedNumber(g_Stats_Run_ElaspedSeconds / 60, 9, 3) .. "" ..
      
      PaddedString("(" ..
      PaddedNumber(g_Stats_Run_TotalSecondsUsed_Total /
                   g_Stats_Run_TotalSecondsUsed_Total * 100, 5, 1) .. "%)", 9) ..
      PaddedNumber(g_Stats_Run_TotalPointsGained_Total /
                  (g_Stats_Run_TotalSecondsUsed_Total / 60), 9, 0) .. "  " ..
      PaddedString(g_Stats_Run_SuccessfulAttempts_Total .. "/" ..
      PaddedNumber(g_Stats_Run_NumberOfAttempts_Total, 0, 0), 9) ..
      PaddedString(" (" ..
      PaddedNumber(g_Stats_Run_SuccessfulAttempts_Total /
                   g_Stats_Run_NumberOfAttempts_Total * 100, 4, 2) .. "%)", 9))
    print("------------------------ ------------------  ----------------  -------  ------------------")
    
    g_Stats_Script_TotalPointsGained_RebuildSelected = 
    g_Stats_Script_TotalPointsGained_RebuildSelected +
       g_Stats_Run_TotalPointsGained_RebuildSelected
    g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected =
    g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected +
       g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected
    g_Stats_Script_TotalPointsGained_WiggleSelected =
    g_Stats_Script_TotalPointsGained_WiggleSelected +
       g_Stats_Run_TotalPointsGained_WiggleSelected
    g_Stats_Script_TotalPointsGained_WiggleAll =
    g_Stats_Script_TotalPointsGained_WiggleAll +
       g_Stats_Run_TotalPointsGained_WiggleAll
    g_Stats_Script_TotalPointsGained_MutateSidechainsSelected =
    g_Stats_Script_TotalPointsGained_MutateSidechainsSelected +
       g_Stats_Run_TotalPointsGained_MutateSidechainsSelected
    g_Stats_Script_TotalPointsGained_MutateSidechainsAll =
    g_Stats_Script_TotalPointsGained_MutateSidechainsAll +
       g_Stats_Run_TotalPointsGained_MutateSidechainsAll
    
    g_Stats_Script_TotalSecondsUsed_RebuildSelected = 
    g_Stats_Script_TotalSecondsUsed_RebuildSelected +
       g_Stats_Run_TotalSecondsUsed_RebuildSelected
    g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected =
    g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected +
       g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected
    g_Stats_Script_TotalSecondsUsed_WiggleSelected =
    g_Stats_Script_TotalSecondsUsed_WiggleSelected +
       g_Stats_Run_TotalSecondsUsed_WiggleSelected
    g_Stats_Script_TotalSecondsUsed_WiggleAll =
    g_Stats_Script_TotalSecondsUsed_WiggleAll +
       g_Stats_Run_TotalSecondsUsed_WiggleAll
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected =
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected +
       g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll =
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll +
       g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll
    
    g_Stats_Script_SuccessfulAttempts_RebuildSelected = 
    g_Stats_Script_SuccessfulAttempts_RebuildSelected +
       g_Stats_Run_SuccessfulAttempts_RebuildSelected
    g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected =
    g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected +
       g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected
    g_Stats_Script_SuccessfulAttempts_WiggleSelected =
    g_Stats_Script_SuccessfulAttempts_WiggleSelected +
       g_Stats_Run_SuccessfulAttempts_WiggleSelected
    g_Stats_Script_SuccessfulAttempts_WiggleAll =
    g_Stats_Script_SuccessfulAttempts_WiggleAll +
       g_Stats_Run_SuccessfulAttempts_WiggleAll
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected =
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected +
       g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll =
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll +
       g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll
    
    g_Stats_Script_NumberOfAttempts_RebuildSelected = 
    g_Stats_Script_NumberOfAttempts_RebuildSelected +
       g_Stats_Run_NumberOfAttempts_RebuildSelected
    g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected =
    g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected +
       g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected
    g_Stats_Script_NumberOfAttempts_WiggleSelected =
    g_Stats_Script_NumberOfAttempts_WiggleSelected +
       g_Stats_Run_NumberOfAttempts_WiggleSelected
    g_Stats_Script_NumberOfAttempts_WiggleAll =
    g_Stats_Script_NumberOfAttempts_WiggleAll +
       g_Stats_Run_NumberOfAttempts_WiggleAll
    g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected =
    g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected +
       g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected
    g_Stats_Script_NumberOfAttempts_MutateSidechainsAll =
    g_Stats_Script_NumberOfAttempts_MutateSidechainsAll +
       g_Stats_Run_NumberOfAttempts_MutateSidechainsAll
    
    g_Stats_Run_StartTime = os.clock()
    
    g_Stats_Run_TotalPointsGained_RebuildSelected = 0
    g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected = 0
    g_Stats_Run_TotalPointsGained_WiggleSelected = 0
    g_Stats_Run_TotalPointsGained_WiggleAll = 0
    g_Stats_Run_TotalPointsGained_MutateSidechainsSelected = 0
    g_Stats_Run_TotalPointsGained_MutateSidechainsAll = 0
    
    g_Stats_Run_TotalSecondsUsed_RebuildSelected = 0.0001 -- prevent divide by zero
    g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected = 0.0001
    g_Stats_Run_TotalSecondsUsed_WiggleSelected = 0.0001
    g_Stats_Run_TotalSecondsUsed_WiggleAll = 0.0001
    g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected = 0.0001
    g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll = 0.0001
    
    g_Stats_Run_SuccessfulAttempts_RebuildSelected = 0
    g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected = 0
    g_Stats_Run_SuccessfulAttempts_WiggleSelected = 0
    g_Stats_Run_SuccessfulAttempts_WiggleAll = 0
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected = 0
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll = 0
    
    g_Stats_Run_NumberOfAttempts_RebuildSelected = 0.1 -- prevent divide by zero
    g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected = 0.1
    g_Stats_Run_NumberOfAttempts_WiggleSelected = 0.1
    g_Stats_Run_NumberOfAttempts_WiggleAll = 0.1
    g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected = 0.1
    g_Stats_Run_NumberOfAttempts_MutateSidechainsAll = 0.1
    
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle +
			g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle  
  
  end -- for nrofRuns=1, maxnrofRuns do

  Cleanup()

end -- function DRW() -- now main()
-- Change defaults if the startscore is negative
if Score() < 4000 then
    local adjust=true
    if HASDENSITY then
        local oscore=GetSubscore("density")
        if Score()-oscore*(DENSITYWEIGHT+1) > 4000 then
            adjust=false
            print("ED puzzle, score high enough not counting ED")
            print("so no auto blocking of qstab and fuze")
        end
    end
    if adjust then
        print("Score < 4000, adjusting defaults")
        print("Now skipping Fuzes, replacing qStab")
        print("Can be changed in More options")
        skipfuze=true
        skipqstab=true
    end
end
SAFEselection=FindSelected()
if AskDRWOptions() then -- now AskUserToSelectRebuildOptions()
    --xpcall(DRW,Cleanup)
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
    DRW() -- above; now main()
    -- Important!!!
    -- Important!!!
    -- Important!!!
    
end -- if AskDRWOptions() then

