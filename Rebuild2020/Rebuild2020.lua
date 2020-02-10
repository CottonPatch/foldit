

function main()
  -- Called from 1 place in xpcall()...
  
	--require('mobdebug').start("192.168.1.108") unfortunately this doesn't work in the FoldIt environment
	DefineGlobalVariables()

	print("\nRebuild2020")
	print("\n  Hello " .. user.GetPlayerName() .. "!")

	CheckForLowStartingScore()
  
	Populate_g_ScorePartsTable()

	DisplayPuzzleProperties()

	g_OrigSelectedSegmentRanges = FindSelectedSegmentRanges() -- only used in CleanUp()

	local l_bOkayToContinue
	l_bOkayToContinue = bAskUserToSelect_RebuildOptions() -- Major code in here!

	-- l_bOkayToContinue = false -- to debug
	if l_bOkayToContinue == false then
		-- The user clicked the Cancel button.
		return -- exit script...
	end

	Display_SelectedOptions()

	g_bSegmentsToRebuildBooleanTable =
		ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(g_SegmentRangesToRebuildTable)

	g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
    g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle

	if g_UserSelected_NumberOf_SegmentRanges_ToSkip > 0 then
    
		local l_RememberThisValue = g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle
    
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
      g_UserSelected_NumberOf_SegmentRanges_ToSkip
		g_RunCycle = 0
    
		PrepareToRebuildSegmentRanges("drw") -- <-- This is not what you are looking for, see below...
    
		g_UserSelected_NumberOf_SegmentRanges_ToSkip = 0
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle = l_RememberThisValue
    
	end
  
  for l_RunCycle = 1, g_UserSelected_NumberOfRunCycles do
      
		g_RunCycle = l_RunCycle
    
 		print("\nScore: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
      " Start of Run " .. g_RunCycle .. " of " .. g_UserSelected_NumberOfRunCycles .. "," ..
      " Rebuilding the " .. g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle .. 
      " worst scoring segment ranges," .. 
      " with " .. g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments .. 
      " to " .. g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments ..
      " consecutive segments:")

		--print("\nRun " .. g_RunCycle .. " of " .. g_UserSelected_NumberOfRunCycles .. "," ..
		 -- " rebuilding " .. g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle ..
     -- " segment ranges...")
    
    -- Here's what you are looking for!!!
		-- Here's what you are looking for!!!
    
		PrepareToRebuildSegmentRanges("drw") -- <<<--- This is what you are looking for!!!
		
		-- Here's what you are looking for!!!
		-- Here's what you are looking for!!!
    
		
		-- Uncomment the methods you want to use...
		-- PrepareToRebuildSegmentRanges("all")
		-- PrepareToRebuildSegmentRanges("areas")
		-- PrepareToRebuildSegmentRanges("fj")
		-- PrepareToRebuildSegmentRanges("simple")
    
		--CheckOnlyRetryAlreadyTriedSegments_IfPointsGainedIsMoreThan()
    
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle +
			g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle
    
	end

	CleanUp()

end -- main()
-- Start of Setting Up Things module...
function DefineGlobalVariables()
  -- Called from main()...

	g_bDebugMode = false
	if _G ~= nil then
		g_bDebugMode = true
		SetupLocalDebugFuntions()
	end
	--
	-- *** Start of Table Declarations...***
	--
  
  g_ActiveScorePartsTable = {}
  -- Used in Populate_g_ActiveScorePartsTable() and
  --         Populate_g_ScorePartsTable()..
  --g_ActiveScorePartsTable = {ScorePart_Name}
  
	g_CysteineSegmentsTable = {}
	--  Used in CountDisulfideBonds(),
  --          Populate_g_CysteineSegmentsTable(), and
  --          DisplayPuzzleProperties()
	--g_CysteineSegmentsTable={SegmentIndex}

	g_ScorePart_Scores_Table = {}
	--  Used in Populate_g_ScorePart_Scores_Table(),
	--          Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(),
	--          Update_g_ScorePart_Scores_Table_SetOfScorePartsWithMatchingPoseTotalScore_And_FirstInASet_...
  --          and RebuildMany_SegmentRanges()
	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
		spst_ScorePart_Number = 1
		spst_ScorePart_Score = 2
		spst_PoseTotalScore = 3
		spst_SetOfScorePartsWithMatchingPoseTotalScore = 4 -- examples: "4", "5=7=12", "6=9", "8=11=13"
		spst_bFirstInASetOfScorePartsWithMatchingPoseTotalScore = 5 -- 'true' means a first in a set of
    --                                                              ScoreParts with matching
    --                                                              PoseTotalScore's,
    --                                                             'false' means a another in a set of
    --                                                              ScoreParts with matching
    --                                                              PoseTotalScore's

	g_ScorePartsTable = {}
	--  Used in Populate_g_ScorePartsTable(), Populate_g_ScorePart_Scores_Table(),
	--          Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(),
	--          AskUserToSelect_ScoreParts_ToStabilize(),
  --          AskUserToSelect_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments(),
	--          bAskUserToSelect_RebuildOptions() and RebuildMany_SegmentRanges()
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
		spt_ScorePart_Number = 1
		spt_ScorePart_Name = 2 -- could have been called "SlotName", but since
                           -- most of the "slots" are ScoreParts...
		spt_bScorePartIsActive = 3  -- User can change this to false
		spt_LongName = 4
  
	g_SegmentRangesToRebuildTable = {}
	--  Used in Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges(), DefineGlobalVariables(),
	--          Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--          Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(), 
  --          Display_SegmentRanges(), Display_SelectedOptions(), AskUserToSelect_Segments_ToRebuild(),
  --          bAskUserToSelect_RebuildOptions(), RebuildSelectedSegments(), 
  --          RebuildMany_SegmentRanges(), PrepareToRebuildSegmentRanges() and main()
	-- g_SegmentRangesToRebuildTable={StartSegment, EndSegment}
		srtrt_StartSegment = 1
		srtrt_EndSegment = 2
	-- g_SegmentRangesToRebuildTable initially includes all the segments in the main protein (ie; no ligands)

	g_SegmentsAlreadyRebuiltTable = {}
	--  Used in SetSegmentsAlreadyRebuilt(),
  --          bSegmentIsAllowedToBeRebuilt(),
  --          CheckIfAlreadyRebuiltSegmentsMustBeIncluded() and
	--          ResetSegmentsAlreadyRebuiltTable()
	-- g_SegmentsAlreadyRebuiltTable={true/false}
	-- g_SegmentsAlreadyRebuiltTable keeps track of which segments have already been processed...

	g_SegmentScoresTable = {}
	--  Used in Get_ScorePart_Score() and
  --          Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()
	-- g_SegmentScoresTable={SegmentScore}
	-- g_SegmentScoresTable is optimized for quickly searching for 
	-- the worst scoring segments, so we can work on those first.
  
	g_bSegmentsToRebuildBooleanTable = {}
	--  Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(),
	--          bSegmentIsAllowedToBeRebuilt() and
  --          main()
	-- g_bSegmentsToRebuildBooleanTable={true/false}


	g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table = {}
	--  Used by Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(), and
	--          AskUserToSelect_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments()
	--g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table={ScorePart_Name}
	--
	-- ***...end of Table Declarations.***
  
  
  -- The following 2 global variables not not sorted alphabetically because they need to be set before
  -- other global variables are set...
  
	g_SegmentCount_WithLigands = structure.GetCount()
	--  Used in DefineGlobalVariables(), InvertSegmentRangesTable(),
	--          ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(), FindSelectedSegments(),
	--          Calculate_SegmentRange_Score(), Get_ScorePart_Score(), Populate_g_ActiveScorePartsTable(),
	--          DisplayPuzzleProperties() and AskUserToSelect_Segments_ToRebuild()
	-- g_SegmentCount_WithLigands = The number of segments (amino acids) in the
	-- protein plus number of segments in ligand
	-- print("structure.GetCount()=[" .. structure.GetCount() .. "]")

	g_SegmentCount_WithoutLigands = g_SegmentCount_WithLigands -- minus ligand segments (see below)
	--  Used in 24 functions...
	-- g_SegmentCount_WithLigands = The number of segments (amino acids) in the protein plus the
  --                              segments in any ligands
	-- g_SegmentCount_WithoutLigands = The number of segments without structure type="M" (ligands)
  
	-- Now, subtract the ligand segments...
	local l_SegmentIndex
	for l_SegmentIndex = g_SegmentCount_WithLigands, 1, -1 do
		l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
		-- The function GetSecondaryStructure() returns a segment's secondary
		-- structure type, as a single letter...
		-- "E" = Sheet, "H" = Helix, "L" = Loop, "M" = Ligand (M for molecule)
		-- print("structure.GetSecondaryStructure(" .. l_SegmentIndex .. ")=[" ..
		--  l_GetSecondaryStructureType .. "]")
		if l_GetSecondaryStructureType == "M" then
		-- Don't include Ligands in g_SegmentCount_WithoutLigands...
			g_SegmentCount_WithoutLigands = g_SegmentCount_WithoutLigands - 1
		end
	end
	-- print("g_SegmentCount_WithoutLigands=[" .. g_SegmentCount_WithoutLigands .. "]")
	g_SegmentRangesToRebuildTable = {{1, g_SegmentCount_WithoutLigands}} 
  -- ...Ligand segment numbers are always after the protein segment numbers.

  
  -- The following non-UserSelectable boolean variables are sorted alphabetically as much as possible...
	
	g_bBetterRecentBest = false
		--  Used in TemporarilyDisable_ConditionChecking() and ReEnable_NormalConditionChecking()...
	
	g_bFoundAHighGain = true
	
	g_bFreeDesignPuzzle = false
	--  Used in DisplayPuzzleProperties() -- for informational display to user only.
		
	g_bHasDensity = false
	--  Used in CheckForLowStartingScore() and DisplayPuzzleProperties()
	
	g_bHasLigand = (g_SegmentCount_WithoutLigands < g_SegmentCount_WithLigands)
	--  Used in Populate_g_ScorePartsTable(), 
	
	g_bMaxClashImportance = true
	--  Used in SetClashImportance() and ShakeAndOrWiggle()
	
	g_bOnlyRebuildLoops = true -- only rebuild loop segments

	g_bProbableSymmetryPuzzle = false
  
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
  -- Used in RebuildMany_SegmentRanges(),
  --         ConvertAllSegmentsToLoops() and
  --         CleanUp()...
  -- g_bSavedSecondaryStructure can only be set here and in ConvertAllSegmentsToLoops().
  
	g_bSketchBookPuzzle = false
  local l_PuzzleName = puzzle.GetName()
  if string.find(l_PuzzleName, "Sketchbook") then
		print("Note: This is a Sketchbook Puzzle.")
		g_bSketchBookPuzzle = true
  end  
  
  
  -- The following boolean UserSelectable variables are sorted alphabetically...
    
	g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = true
  --  Used in 7 functions...
	-- ...User can change this on the Select Rebuild Options page.
  if g_bDebugMode == true then
    g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = false
  end

	g_bUserSelected_ConvertAllSegmentsToLoops = true -- Why is the default true?
	--  Used in Display_SelectedOptions(), bAskUserToSelect_RebuildOptions() and 
	--          RebuildMany_SegmentRanges
	
  g_bUserSelected_FuseBestPosition = true
	--  Used in CheckForLowStartingScore(), Display_SelectedOptions(), AskMoreOptions() and
	--          RebuildMany_SegmentRanges()
  
	g_bUserSelected_Mutate_After_FuseBestPosition = false
	--  Used in DefineGlobalVariables(), AskUserForMutateOptions(), bAskUserToSelect_RebuildOptions() and
	--          RebuildMany_SegmentRanges()

	g_bUserSelected_Mutate_After_Stabilize = false
	--  Used in DefineGlobalVariables(), AskUserForMutateOptions(), bAskUserToSelect_RebuildOptions() and
	--          RebuildMany_SegmentRanges()

	g_bUserSelected_Mutate_After_Rebuild = false
	--  Used in AskUserForMutateOptions(), bAskUserToSelect_RebuildOptions(),
	--          RebuildOneSegmentRangeManyTimes()

	g_bUserSelected_Mutate_Before_FuseBestPosition = false
	g_bUserSelected_Mutate_During_Stabilize = false
	g_bUserSelected_Mutate_OnlySelected_Segments = false
	g_bUserSelected_Mutate_SelectedAndNearby_Segments = false
  
	g_bUserSelected_PerformExtraStabilize = false	
	g_bUserSelected_SelectAllScorePartsToStabilize = true
	g_bUserSelected_SelectMain4ScorePartsToStabilize = false
	g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments = true -- false = include nearby segments
	g_bUserSelected_ShakeAndWiggle_WithSelected_Segments = true -- (after each rebuild) not too slow
	g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments = false 
  g_bUserSelected_Stabilize = true
   -- ...true = very slow.

	g_bUserSelected_KeepDisulfideBonds_Intact = false
	--  Used in bOneOrMoreDisulfideBondsHaveBroken(), RememberSolutionWithDisulfideBondsIntact(),
	--          CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact(), DisplayPuzzleProperties(),
	--          bAskUserToSelect_RebuildOptions(), RebuildSelectedSegments(),
	--          RebuildOneSegmentRangeManyTimes() and RebuildMany_SegmentRanges()
  
  
  -- The following non-UserSelectable variables are sorted alphatecally...

	g_PointsGained_Current_RebuildSegmentRange = 0
	--  Used in bSegmentIsAllowedToBeRebuilt() and
	--          RebuildMany_SegmentRanges()

	g_DensityWeight = 0
	--  Used in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts(),
	--          CheckForLowStartingScore() and DisplayPuzzleProperties()

	g_FirstRebuildSegment = 0
	g_LastRebuildSegment = 0
	g_LastSegmentScore = 0
  
  g_OriginalNumberOfDisulfideBonds = 0
	--  Used in Populate_g_CysteineSegmentsTable(), bOneOrMoreDisulfideBondsHaveBroken(), 
	--          Populate_g_ActiveScorePartsTable(), DisplayPuzzleProperties() and
	--          AskUserToSelectRebuildOptions()

	g_QuickSaveStackPosition = 60 -- Uses slot 60 and higher...
  
	g_RebuildClashImportance = 0 -- clash importance while rebuild
	--  Used in RebuildOneSegmentRangeManyTimes()
  
	g_RunCycle = 0  
 	
	g_Score_AtStartOf_Script = GetPoseTotalScore()
	--  Used in CleanUp()...
  
  g_Score_ScriptBest = GetPoseTotalScore()
  --  Used in SaveBest() and others...
  
	g_SegmentRangeIndex = 0
  
  -- The following UserSelected variables are sorted alphabetically as much as possible...
  
	g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle = 1
	--  Used in AskMoreOptions() and main()
    
	local l_NumberOfBands = band.GetCount()
	g_bUserSelected_Disable_Bands_DuringRebuild = l_NumberOfBands > 0
	-- Used in bAskUserToSelect_RebuildOptions() and RebuildSelectedSegments()
  -- ...sets default to true if there are any bands.
  
	g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan =
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
	--  Used in DefineGlobalVariables(), AskMoreOptions() and RebuildMany_SegmentRanges()
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan < 10000 then -- was 40
		g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan = 10000 -- was 40
	end
  --if g_bDebugMode == true then
  --  g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan = 10000
  --end
  
	g_UserSelected_Mutate_ClashImportance = 0.9
	--  Used in MutateSideChainsOfSelectedSegments() and 
  --          AskUserForMutateOptions()

	g_UserSelected_Mutate_SphereRadius = 8 -- Angstroms
	--  Used in MutateSideChainsOfSelectedSegments(),
  --          AskUserForMutateOptions() and 
  --          AskUserToSelectRebuildOptions()

	g_UserSelected_NumberOf_SegmentRanges_ToSkip = 0 -- set to any value other than 0, to debug related code
	--  Used in Display_SelectedOptions(), bAskUserToSelect_RebuildOptions() and main()
  
	g_UserSelected_NumberOfRunCycles = 40 -- Set it very high if you want to run forever
	--  Used in bAskUserToSelect_RebuildOptions(), RebuildSelectedSegments(),
	--          PrepareToRebuildSegmentRanges() and main()
  if g_bDebugMode == true then
    g_UserSelected_NumberOfRunCycles = 10 -- 5 is high enough for debug mode
  end

	g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle = 10 -- set to at least 10
	--  Used in AskMoreOptions(), RebuildSelectedSegments() and RebuildOneSegmentRangeManyTimes()

	g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan = 
    g_SegmentCount_WithLigands
	-- Used in DefineGlobalVariables(),
  --         bSegmentIsAllowedToBeRebuilt() and 
  --         Display_SelectedOptions()
	-- Default to one point per segment? Seems pretty arbitrary to me...
  
	-- "To Allow" or "To Force"?
	-- Example:
	-- g_SegmentCount_WithoutLigands = 135
	-- g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan = 135
  -- ...Pretty simple formula
	if g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan > 500 then
		g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan = 500
	end
  
	g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4 
	--  Used in bAskUserToSelect_RebuildOptions(), RebuildSelectedSegments() and 
	--          PrepareToRebuildSegmentRanges()
  -- ...any more than 4 consecutive segments does not appear to be fruitful;
  -- Actually, 4 consecutive segments is not great.
  -- And, 3 consecutive segments is barely better then 4.
  -- Really, most of the gains are with just 2 consecutive segments!
  
	g_UserSelected_Shake_ClashImportance = 0.31 -- clash imortance while shaking
 	g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave = 0

	g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle = 4
	--  Used in DefineGlobalVariables(), AskMoreOptions(), PrepareToRebuildSegmentRanges() and main()
	-- Increase g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle by
	--  g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle, after every run cycle...
	-- This allows the worst scoring segments to get more rebuild time...
	-- g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle:
	g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
    g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle
  
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
	--  Because g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4,
  --  this will be the final segment range configuration, and will look like this:
  --  {{1-4},{2-5},{3-6},{4-7} ... {132-135}}
	
	g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
	--  Used in DefineGlobalVariables(), Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--          Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(),
	--          bAskUserToSelect_RebuildOptions() and PrepareToRebuildSegmentRanges()
	g_RequiredNumberOfConsecutiveSegments = g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments
	--  Used in bAskUserToSelect_RebuildOptions(), RebuildSelectedSegments() and
	--          PrepareToRebuildSegmentRanges()
  
	g_UserSelected_WiggleFactor = 1

  -- ...end of UserSelected variables sorted alphabetically as much as possible.

  -- The following variables are not sorted alphabetically because they 
  -- depend on above variables to be set first...

	g_bProteinHasMutableSegments = false
	-- Used in DefineGlobalVariables(),
  --         MutateSideChainsOfSelectedSegments(),
  --         DisplayPuzzleProperties() and 
	--         bAskUserToSelect_RebuildOptions()
	local l_NumberOfMutableSegments = GetNumberOfMutableSegments()
	if l_NumberOfMutableSegments > 0 then
		g_bProteinHasMutableSegments = true
		g_bUserSelected_Mutate_After_FuseBestPosition = true
		g_bUserSelected_Mutate_After_Stabilize = true
		g_bUserSelected_Mutate_SelectedAndNearby_Segments = true
	end
  
	if g_bSketchBookPuzzle == true then
	   g_bUserSelected_ConvertAllSegmentsToLoops = false
	   g_bUserSelected_FuseBestPosition = false
	   g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan = 500
	end
  if g_bDebugMode == true then
    g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan = 50
  end  

	g_UserSelected_ClashImportanceFactor = behavior.GetClashImportance()
	-- Used in DefineGlobalVariables(), SetClashImportance() and AskUserToCheck_ClashImportance()
	-- Set Clash Importance Factor...
	-- note: we don't actually have a g_ClashImportance variable,
	--       we only have a g_UserSelected_ClashImportanceFactor variable.
	--       we do, however, have an l_ClashImportance variable in function SetClashImportance() above.
	-- print("behavior.GetClashImportance()=[" .. g_UserSelected_ClashImportanceFactor .. "].")
	if g_UserSelected_ClashImportanceFactor < 0.99 then
		AskUserToCheck_ClashImportance()
	end

	g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan = 
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
	--  Used in DefineGlobalVariables(), AskMoreOptions() and RebuildMany_SegmentRanges()
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan < 30 then
		g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan = 30
	end
  
  
  -- The remaining lines of this function are related to Condition Checking,
  -- and are not sorted alphanetically...  

	-- Start of Temporarily Disable Condition Checking module...
	-- Temporarily disable condition checking...
	if g_bSketchBookPuzzle == false then
    -- Could probably just call TemporarilyDisable_ConditionChecking() here...
		behavior.SetFiltersDisabled(true) 
    -- ...Enables faster CPU processing, but your score improvements are not saved to foldit...
	end

	local l_Score_WithConditionChecking_TemporarilyDisabled = GetPoseTotalScore()
    
  -- debugging...
  --l_Score_WithConditionChecking_TemporarilyDisabled =
  --  l_Score_WithConditionChecking_TemporarilyDisabled + 500
	  
	-- Re-enable normal condition checking...
	if g_bSketchBookPuzzle == false then
    -- Could probably just call ReEnable_NormalConditionChecking() here...
		behavior.SetFiltersDisabled(false)
    -- ...Disables faster CPU processing, so your score improvements will be saved to foldit...
	end
	
	local l_Score_WithNormalConditionChecking_Enabled = GetPoseTotalScore()
		
	g_ComputedMaximumPotentialBonusPoints = 
    l_Score_WithConditionChecking_TemporarilyDisabled - l_Score_WithNormalConditionChecking_Enabled 
  --  Used in DefineGlobalVariables() and 
  --          DisplayPuzzleProperties()...
  -- Compute the maximum potential bonus points (not available in beginner puzzles)...
		
  g_UserSelected_MaximumPotentialBonusPoints = g_ComputedMaximumPotentialBonusPoints
  --  Used in Ask_TemporarilyDisable_ConditionChecking_Options() and 
  --          SaveBest()...
	
	g_bUserSelected_TemporarilyDisable_ConditionChecking = false
	--  Used in DefineGlobalVariables(), CleanUp(),
  --          Ask_TemporarilyDisable_ConditionChecking_Options() and SaveBest()
	-- TemporarilyDisable_ConditionChecking (enables faster CPU processing, but
  -- your score improvements will not be counted in foldit's Undo history)...
  -- ...false means "Enable Normal Condition Checking".
  
  if math.abs(g_UserSelected_MaximumPotentialBonusPoints) > 0.1 then
    
		print("\nl_Score_WithConditionChecking_TemporarilyDisabled: " ..
          PrettyNumber(l_Score_WithConditionChecking_TemporarilyDisabled) ..
          "\nl_Score_WithNormalConditionChecking_Enabled: " ..
          PrettyNumber(l_Score_WithNormalConditionChecking_Enabled) ..
          "\ng_MaximumPotentialBonusPoints: " .. g_UserSelected_MaximumPotentialBonusPoints)
		
		g_bUserSelected_TemporarilyDisable_ConditionChecking = true
    
		-- Ask user for their desired maximum bonus...
		Ask_TemporarilyDisable_ConditionChecking_Options()
	end
  
	if g_bUserSelected_TemporarilyDisable_ConditionChecking == true then
		TemporarilyDisable_ConditionChecking()
	end
	-- ...end of Temporarily Disable Condition Checking module.

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
	
	function RandomFloat(n1, n2) -- e.g.; RandomFloat(3, 9) --> 4.30195013275552
		l_RandomFloat = math.random() * (n2 - n1) + n1
		return l_RandomFloat
	end

 -- g_Debug_CurrentEnergyScore provides some control over current score during debug...
 -- g_Debug_CurrentEnergyScore goes up and down randomly after each call to:
 --   MutateSidechainsSelected, MutateSidechainsAll, RebuildSelected, 
 --   ShakeSidechainsAll, ShakeSidechainsSelected, 
 --   WiggleAll and WiggleSelected...
	g_Debug_CurrentEnergyScore = -999999
  g_Debug_ScriptBestEnergyScore = g_Debug_CurrentEnergyScore
  g_Debug_QuickSaveEnergyScore = 0
	
	current = {}
 	pose = {} -- same structure as "current" above
 	recentbest = {} --

  current.UpdateEnergyScore = function()
    -- This is not a foldit function. This function is only
    -- used by the following debug version of the foldit functions:    --
    -- structure.MutateSidechainsSelected
    -- structure.MutateSidechainsAll
    -- structure.RebuildSelected
    -- structure.ShakeSidechainsAll
    -- structure.ShakeSidechainsSelected
    -- structure.WiggleAll
    -- structure.WiggleSelected    
    
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
	behavior.GetClashImportance = function()
		-- local l_ClashImportance = 1
		local l_ClashImportance
		l_ClashImportance = math.random()
		if l_ClashImportance > .7 then
			-- Give 1 a better chance...
			l_ClashImportance = 1
		end
		
		return l_ClashImportance
	end
	behavior.SetClashImportance = function(l_ClashImportance) return end
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
	freeze.IsFrozen = function(l_SegmentIndex)
		local l_bBackboneIsFrozen = false
		local l_bSideChainIsFrozen = false
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
	--   puzzle.StartOver

	--   recipe.CompareNumbers
	--   recipe.GetRandomSeed -- does not work properly on Windows OS
	--   recipe.ReportStatus -- Could be helpful, but does not allow capturing the results, only prints it
	--   recipe.SectionEnd
	--   recipe.SectionStart -- Count be helpful, but...
	--   rotamer.GetCount
	--   rotamer.SetRotamer

	save = {}
   -- Called from 11 places...
	save.Quickload = function(l_IntegerSlot)
    g_Debug_CurrentEnergyScore = g_Debug_QuickSaveEnergyScore
    return
  end
  -- Called from 13 places...
	save.Quicksave = function(l_IntegerSlot)
    g_Debug_QuickSaveEnergyScore = g_Debug_CurrentEnergyScore
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
	selection.IsSelected = function(l_SegmentIndex)
		l_bIsSelected = math.random(2) == 1
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
	
	structure.GetSecondaryStructure = function(l_SegmentIndex)
		
		--l_SecondaryStructures = 'HEL' -- H=Helix, E=Sheet, L=Loop, M=Ligand
		l_SecondaryStructures = 'HELM' -- H=Helix, E=Sheet, L=Loop, M=Ligand
		l_RandomSecondaryStructure = RandomCharOfString(l_SecondaryStructures)
		return l_RandomSecondaryStructure
		
	end
	structure.IsLocked = function(l_SegmentIndex)
		l_bIsLocked = math.random(2) == 1
		if 1 == 1 then
			return l_bIsLocked
		end
	 
		-- The old method...
		if (l_SegmentIndex == 124 or l_SegmentIndex == 129 or
				l_SegmentIndex == 131 or l_SegmentIndex == 132) then
			return false
		else
			return true
		end
	end
	structure.IsMutable = function(l_SegmentIndex)
		l_bIsMutable = math.random(2) == 1
		if 1 == 1 then
			return l_bIsMutable
		end
		return false
	end
	structure.MutateSidechainsAll = function(l_Iterations) 
    current.UpdateEnergyScore()
  end
	structure.MutateSidechainsSelected = function(l_Iterations) 
    current.UpdateEnergyScore()
  end
	structure.RebuildSelected = function(l_Iterations)
    current.UpdateEnergyScore()
	end
	structure.SetSecondaryStructureSelected = function(l_StringSecondaryStructure) return end
	structure.ShakeSidechainsAll = function(l_Iterations)
    current.UpdateEnergyScore()
	end
	structure.ShakeSidechainsSelected = function(l_Iterations)
    current.UpdateEnergyScore()
	end
	structure.WiggleAll = function(l_Iterations,l_bBackbone,l_bSideChains)
    current.UpdateEnergyScore()
	end
	structure.WiggleSelected = function(l_Iterations,l_bBackbone,l_bSideChains)
    current.UpdateEnergyScore()
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
	--   structure.LocalWiggleAll = function(l_Iterations, l_Backbone, l_Sidechains)
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
  current.UpdateEnergyScore()

end -- function SetupLocalDebugFuntions()
function GetPoseTotalScore(l_pose)
  -- Called from 21 functions...
  
  -- If something was done that could have changed the current score, like 
  -- Rebuild, Shake, Wiggle, etc, then call this function for the latest score.
  
  -- The value of GetPoseTotalScore() can go up and down drastically after any call to rebuild,
  -- shake, wiggle or mutate; therefore, you cannot expect to get the best score obtained 
  -- during this run of this script by calling GetPoseTotalScore(), even if you call SaveBest()
  -- first. However, SaveBest() does update g_Score_ScriptBest. So you could (and should!) call
  -- SaveBest() after every Rebuild, Shake, Wiggle, etc, then get the best score from 
  -- g_Score_ScriptBest.
  -- A pose is everything, including the main protein and any ligands.

	if l_pose == nil then
		l_pose = current -- the class "current"
	end
	local l_Total = l_pose.GetEnergyScore()

	return l_Total

end
function GetNumberOfMutableSegments()
  -- Called from DisplayPuzzleProperties() and
  --             DefineGlobalVariables() (this one breaks the rule of define first, use next)...

	local l_GetNumberOfMutableSegments = 0

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		if structure.IsMutable(l_SegmentIndex) then
      
			l_GetNumberOfMutableSegments = l_GetNumberOfMutableSegments + 1
      
		end
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
  
	return l_GetNumberOfMutableSegments

end -- function GetNumberOfMutableSegments()
-- ...end of Setting Up Things module.
-- Start of Ask and Display User Options module...
function AskUserToCheck_ClashImportance()
  -- Called from DefineGlobalVariables()...

	local l_Ask = dialog.CreateDialog("Warning: Clash Importance is not 1")
	l_Ask.l2 = dialog.AddLabel("Clash Importance is currently: [" .. 
    tostring(g_UserSelected_ClashImportanceFactor) .. "]")
	l_Ask.l2 = dialog.AddLabel("Clash Importance will always be multiplied by")
	l_Ask.l3 = dialog.AddLabel("ClashImportanceFactor which is currently: [" ..
    g_UserSelected_ClashImportanceFactor .. "].")
	l_Ask.l4 = dialog.AddLabel("If you want to change the ClashImportanceFactor,")
	l_Ask.l5 = dialog.AddLabel("stop this script, and set the Clash Importance")
	l_Ask.l6 = dialog.AddLabel("in the FoldIt program (which will become this")
	l_Ask.l7 = dialog.AddLabel("script's ClashImportanceFactor), then restart")
	l_Ask.l8 = dialog.AddLabel("this script.")
	l_Ask.continue = dialog.AddButton("Continue", 1)
	dialog.Show(l_Ask)
  
end -- function AskUserToCheck_ClashImportance()
function PrettyNumber(l_DirtyFloat)
  -- Called from DefineGlobalVariables(), 
  --             DisplayPuzzleProperties(),
  --             RebuildSelectedSegments() and 
  --             2 places in RebuildMany_SegmentRanges()...
  
  -- This is the new version of RoundToThirdDecimal()...
  
  local l_MaybeDirtyFloat = RoundTo(l_DirtyFloat, 1000)  
  local l_PrettyString = string.format("%.3f", l_MaybeDirtyFloat)  
  
  return l_PrettyString
  
end -- function PrettyNumber(l_DirtyFloat)
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
function Ask_TemporarilyDisable_ConditionChecking_Options()
  -- Called from DefineGlobalVariables()...
  
	local l_Ask = dialog.CreateDialog("Temporary Fast CPU Processing")
	l_Ask.bUserSelected_TemporarilyDisable_ConditionChecking = 
    dialog.AddCheckbox("Temporarily disable condition checking",
    g_bUserSelected_TemporarilyDisable_ConditionChecking)
	l_Ask.l1 = dialog.AddLabel("Computed maximum potential bonus points: " ..
    g_UserSelected_MaximumPotentialBonusPoints)
	l_Ask.l2 = dialog.AddLabel("If this is not the correct maximum potential bonus,")
  l_Ask.l3 = dialog.AddLabel("enter the correct value here:")
  
	if g_UserSelected_MaximumPotentialBonusPoints < 0 then
		 g_UserSelected_MaximumPotentialBonusPoints = 0
	end
  
	l_Ask.UserSelected_MaximumPotentialBonusPoints = 
    dialog.AddTextbox("Set Max Bonus:", g_UserSelected_MaximumPotentialBonusPoints)
  l_Ask.l5 = dialog.AddLabel("Design puzzles typically include several conditions.")
  l_Ask.l6 = dialog.AddLabel("If all conditions are met then any potential penalty")
  l_Ask.l7 = dialog.AddLabel("points (negative points) are removed from your score")
  l_Ask.l8 = dialog.AddLabel("and any potential bonus points are added to your")
  l_Ask.l9 = dialog.AddLabel("score. Evaluating these conditions can slow down")
  l_Ask.l10 = dialog.AddLabel("shake, wiggle, and other operations. 'Temporarily")
  l_Ask.l11 = dialog.AddLabel("disable condition checking' disables condition")
  l_Ask.l12 = dialog.AddLabel("checking as much as possible, to speed up the")
  l_Ask.l13 = dialog.AddLabel("rebuild process. While condition checking is disabled")
  l_Ask.l14 = dialog.AddLabel("our current score is only a 'potential-score-if-all-")
  l_Ask.l15 = dialog.AddLabel("conditions-are-met'. We won't know our actual score")
  l_Ask.l16 = dialog.AddLabel("until we re-enable condition checking, to see if the")
  l_Ask.l17 = dialog.AddLabel("conditions are met. The value in 'Set Max Bonus'")
  l_Ask.l18 = dialog.AddLabel("shows the potential bonus (if all conditions are")
  l_Ask.l19 = dialog.AddLabel("met), or zero if there's currently a penalty. The")
  l_Ask.l20 = dialog.AddLabel("'Set Max Bonus' value determines when to re-enable")
  l_Ask.l21 = dialog.AddLabel("condition checking. Once our current score (with")
  l_Ask.l22 = dialog.AddLabel("condition checking disabled) plus the Set Max Bonus")
  l_Ask.l23 = dialog.AddLabel("value is greater than the last saved real best score,")
  l_Ask.l24 = dialog.AddLabel("we will re-enable condition checking and hopefully")
  l_Ask.l25 = dialog.AddLabel("we will realize the loss of penalties points and the")
  l_Ask.l26 = dialog.AddLabel("gain of bonus points. The last real best score is")
  l_Ask.l27 = dialog.AddLabel("only updated when condition checking is enabled.")
  
	l_Ask.continue = dialog.AddButton("Continue", 1)
	dialog.Show(l_Ask)
	g_UserSelected_MaximumPotentialBonusPoints = 
    l_Ask.UserSelected_MaximumPotentialBonusPoints.value
    
	if g_UserSelected_MaximumPotentialBonusPoints == "" then
		g_UserSelected_MaximumPotentialBonusPoints = 0
	end
  
	g_bUserSelected_TemporarilyDisable_ConditionChecking =
    l_Ask.bUserSelected_TemporarilyDisable_ConditionChecking.value
    
end -- function Ask_TemporarilyDisable_ConditionChecking_Options()
function TemporarilyDisable_ConditionChecking()
  -- Called from SaveBest() and 
  --             DefineGlobalVariables()...
  
	-- Enables faster CPU processing, but your scores will not be counted...

	behavior.SetFiltersDisabled(true)
  
	if g_bBetterRecentBest == true then -- set in ReEnable_NormalConditionChecking() below...
		save.Quicksave(99) -- Save
		save.Quickload(98) -- Load
		recentbest.Save() -- Save the current pose as the recentbest pose.  
		save.Quickload(99) -- Load
    
    g_bBetterRecentBest = false -- not sure why this line wasn't here earlier.
	end
  
end -- function TemporarilyDisable_ConditionChecking()
function CheckForLowStartingScore()
  -- Called from main()...

  -- Change defaults if the starting score is low (or negative)...
  local l_LowScore = 0 -- This was 4000, but why? Perhaps 4000 was a good low limit for ED puzzles.

  local l_Current_PoseTotalScore = GetPoseTotalScore()

	if g_bHasDensity == true then
    
		local l_DensitySubScore = Calculate_SegmentRange_Score("density")
		local l_WeightedDensitySubScore = l_DensitySubScore  * (g_DensityWeight + 1)
		local l_ScoreWithoutElectronDensity = l_Current_PoseTotalScore - l_WeightedDensitySubScore
    
		if l_ScoreWithoutElectronDensity > 4000 then
			print("\n  This is an electron density puzzle: Since the starting score of " ..
                 PrettyNumber(l_ScoreWithoutElectronDensity) .. " is already greater than 4000 points" ..
              " (high enough without")
      print( "  including Electron Density), we will keep the default" ..
              " options of: 'Stabilize' and 'fuse best position'.")
			return
		end
	end

	if l_Current_PoseTotalScore >= l_LowScore then
		return -- score is high enough for now...
  end

	print("\n  Since the starting score of " .. PrettyNumber(l_Current_PoseTotalScore) ..
         " is less than " .. l_LowScore .. " points, to speed things up, we will temporarily")
  print("  suspend Stabilize and fusing best position" ..
         " until the score increases above " .. l_LowScore .. " points.")
       -- The More Options page only provides a way to set these variables to false,
       -- which would do nothing in this case. So the following statement is not true...
       -- " However, these defaults can be changed on the More options page.")
	g_bUserSelected_FuseBestPosition = false
	g_bUserSelected_Stabilize = false

end -- function CheckForLowStartingScore()
function Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment, l_pose)
  -- Called from 1 place recursively in Calculate_SegmentRange_Score(),
  --             2 places inDisplayPuzzleProperties(),
  --             2 places in Get_ScorePart_Score(), 
  --             1 place in Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts() and 
  --             1 place in CheckForLowStartingScore()...

	-- Note: l_ScorePart_NameOrTable is optional, if it's nil we use
	--       GetSegmentEnergyScore instead of GetSegmentEnergySubscore.

	-- Note: l_ScorePart_NameOrTable can be either a single string, or a table of strings.

	-- Note: Each Segment can have up to 20 named ScoreParts.
	--       e.g.; 1=Clashing, 2=Pairwise, 3=Packing, Hiding, Bonding, Ideality, Backbone,
	--             Sidechain, Reference...

	if l_pose == nil then
		 -- "pose" is the current conformation / folding configuration of the protein and ligands
		l_pose = pose -- This class name "pose" must be kept lower case.
	end

	local l_ScoreTotal = 0
	local l_ScorePart_Score = 0
	local l_ScorePart_Name = ""
	if type(l_ScorePart_NameOrTable) == "table" then
    -- Calculate the total score of a segment range, but
    -- only include the ScoreParts of the passed in list of ScoreParts...
		for l_ScorePart_NameOrTableIndex = 1, #l_ScorePart_NameOrTable do
			-- recursion...
			-- Call back with each ScorePart in the ScorePart_NameOrTable...
			l_ScorePart_Name = l_ScorePart_NameOrTable[l_ScorePart_NameOrTableIndex]
			l_ScorePart_Score = Calculate_SegmentRange_Score(l_ScorePart_Name, l_StartSegment, 
                                                       l_EndSegment, l_pose)
			l_ScoreTotal = l_ScoreTotal + l_ScorePart_Score
		end
	else
    -- Calculate the total score of all segment ranges and include all ScoreParts...
    -- I suspect if you ended up here, it was by accident (i.e., a coding error),
    -- because you should have just called GetPoseTotalScore(l_pose) directly instead!
		if l_ScorePart_NameOrTable == nil and l_StartSegment == nil and l_EndSegment == nil then            
			local l_Current_PoseTotalScore = GetPoseTotalScore(l_pose)
			return l_Current_PoseTotalScore
		end
		if l_StartSegment == nil then
			l_StartSegment = 1
		end
		if l_EndSegment == nil then
			l_EndSegment = g_SegmentCount_WithLigands -- include ligands? why?
		end
		if l_StartSegment > l_EndSegment then
			l_StartSegment, l_EndSegment = l_EndSegment, l_StartSegment
		end
		if l_pose == nil then -- based on the check at the top of this function, 
													-- I don't think this will ever be nil here
			l_pose = current -- the class "current"
		end
		if l_ScorePart_NameOrTable == nil then
			for l_SegmentIndex = l_StartSegment, l_EndSegment do
				local l_SegmentEnergyScore = l_pose.GetSegmentEnergyScore(l_SegmentIndex)
				l_ScoreTotal = l_ScoreTotal + l_SegmentEnergyScore
				-- print("l_pose.GetSegmentEnergyScore(" .. l_SegmentIndex .. ")=[" ..
				--  l_pose.GetSegmentEnergyScore(l_SegmentIndex) .. "]")
			end
		else
			l_ScorePart_Name = l_ScorePart_NameOrTable
			-- this time it's not actually a table, rather just a single ScorePart_Name
			for l_SegmentIndex = l_StartSegment, l_EndSegment do
				l_ScorePart_Score = l_pose.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name)
				l_ScoreTotal = l_ScoreTotal + l_ScorePart_Score
				-- print("l_pose.GetSegmentEnergySubscore(" .. l_SegmentIndex .. "," .. l_ScorePart_Name .. ")=["
				--  .. l_pose.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name) .. "]")
			end
		end
	end

	return l_ScoreTotal

end -- Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment, l_pose)
function Populate_g_ScorePartsTable()
  -- Called from main()...

	-- Quick fix for failing first rebuild...
	for l_ScorePart_Number = 3, 12 do
		save.Quicksave(l_ScorePart_Number) -- Save
	end

	-- What's in ScoreParts (Slots) 1 and 2, I wonder?
	-- ScorePart (Slot) 3 always stores the best score

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	g_ScorePartsTable = {
		{4, 'total', true, '4 (total)'},
		{5, 'loctotal', true, '5 (loctotal)'}
	}
	local l_ScorePart_Number = 6 -- Note, there are more "slot" numbers than "ScorePart" numbers.
	local l_ScorePart_Name
	local l_bIsActive
	local l_LongName

	if g_bHasLigand == true then
		-- l_ScorePart_Number = 6 -- we know, we know
		l_ScorePart_Name = 'ligand'
		l_bIsActive = true
		l_LongName = l_ScorePart_Number .. " (" .. l_ScorePart_Name .. ")"
    
		g_ScorePartsTable[#g_ScorePartsTable + 1] = 
      {l_ScorePart_Number, l_ScorePart_Name, l_bIsActive, l_LongName}
      
		l_ScorePart_Number = l_ScorePart_Number + 1 -- now it's 7.
	end

	Populate_g_ActiveScorePartsTable()
	--local g_ActiveScorePartsTable = {
		-- This table has only one field, ScorePart_Name, per row.
		-- Example entries: Clashing, Pairwise, Packing, Hiding, Bonding, 
		-- Ideality, Other Bonding, Backbone, Sidechain, Disulfides, Reference,
		-- Structure, Holes, Surface Area, Interchain Docking, Neighbor Vector,
		-- Symmetry, Van del Waals, Density, Other...
	--}

	-- Continue to populate g_ScorePartsTable with one row per ActiveScorePart...
	for l_ActiveScorePartsTableIndex = 1, #g_ActiveScorePartsTable do
    
		l_ScorePart_Name = g_ActiveScorePartsTable[l_ActiveScorePartsTableIndex]
    
		-- Add one g_ScorePartsTable row for each ActiveScorePart, except for the 'Reference' ScorePart...
		if l_ScorePart_Name ~= 'Reference' then -- NOT equal to!
      
			l_bIsActive = true
			l_LongName = l_ScorePart_Number .. " (" ..
        g_ActiveScorePartsTable[l_ActiveScorePartsTableIndex] .. ")"
        
			-- Finally, add the new g_ScorePartsTable record...
			g_ScorePartsTable[#g_ScorePartsTable + 1] = 
        {l_ScorePart_Number, l_ScorePart_Name, l_bIsActive, l_LongName}
        
			l_ScorePart_Number = l_ScorePart_Number + 1
		end
	end

end -- Populate_g_ScorePartsTable()
function Populate_g_ActiveScorePartsTable()
  -- Called from Populate_g_ScorePartsTable()...

	local l_ScorePart_NamesTable = puzzle.GetPuzzleSubscoreNames()
	-- The l_ScorePart_NamesTable, has 1 field per record... ScorePart_Name.
	-- Example entries: Clashing, Pairwise, Packing, Hiding, Bonding, 
	 -- Ideality, Other Bonding, Backbone, Sidechain, Disulfides, Reference,
	 -- Structure, Holes, Surface Area, Interchain Docking, Neighbor Vector,
	 -- Symmetry, Van del Waals, Density, Other...
	
	-- Note: The function GetPuzzleSubscoreNames() would be better named as GetPuzzleScorePartNames()...

	g_ActiveScorePartsTable = {
		-- The g_ActiveScorePartsTable table, is a subset of the l_ScorePart_NamesTable, thus also
		-- has only one field, called ScorePart_Name, per record.
		}
	local l_ScorePart_Name = ""
	local l_ScorePartActivity = 0 -- Score from only one ScorePart in only one of the protein's segments...
  local l_RunningTotalOfScorePartActivity
 
	--print("\nActivating ScoreParts based on ScorePart Score activity greater than 10 points...\n")

  -- It might seem confusing to use the sum of absolute values, but what we are looking for here is
  -- a magnitude of activity, both positive and negative. If we didn't use the absolute value, then
  -- we could end up adding a +100 and -100 points = 0 total, which would look like no activity. But
  -- there really is activity. Lots of activity, in both positive and negative ways...

	-- Loop through all possible ScoreParts...
	for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do
    
		l_ScorePart_Name = l_ScorePart_NamesTable[l_ScorePart_NamesTableIndex]
    
    l_RunningTotalOfScorePartActivity = 0
    
		-- Look at each Segment to see if it has activity (a score) for the current ScorePart...
		for l_SegmentIndex = 1, g_SegmentCount_WithLigands do
      
      l_ScorePartActivity = math.abs(current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name))
        
      l_RunningTotalOfScorePartActivity = l_RunningTotalOfScorePartActivity + l_ScorePartActivity
        
      if l_RunningTotalOfScorePartActivity > 10 or
        (l_ScorePart_Name == 'Disulfides' and g_OriginalNumberOfDisulfideBonds > 0) then

        g_ActiveScorePartsTable[#g_ActiveScorePartsTable + 1] = l_ScorePart_Name      
        
        -- Note: The value of l_ScorePartActivity above 10 is irrelevent. 10 points was enough to
        -- trigger activating the ScorePart. At this point we do not continue to add on to the
        -- 10 points; instead, we activate the ScorePart and break out of this inner loop to
        -- start evaluating the next ScorePart...
      
        print("  Active ScorePart: " .. l_ScorePart_Name)
        
        break
      
      end -- if l_RunningTotalOfScorePartActivity > 10 or ...
        
    end -- for l_SegmentIndex = 1, g_SegmentCount_WithLigands do
    
	end -- for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do

end -- Populate_g_ActiveScorePartsTable()
function DisplayPuzzleProperties()
  -- Called from main()...

	--print("\nPuzzle properties...\n")
  
	print("  Puzzle name: " .. puzzle.GetName() .. "")
	print("  Puzzle ID: " .. puzzle.GetPuzzleID() .. "")
	-- print("  Puzzle description: [" .. puzzle.GetDescription() .. "]")

	print("  Protein has " .. g_SegmentCount_WithoutLigands .. " segments.")
	
	-- Find out if the puzzle has mutables
	local l_MutablesList
	local l_NumberOfMutableSegments
	l_NumberOfMutableSegments = GetNumberOfMutableSegments()

	if g_bProteinHasMutableSegments == true then
  print("  Protein has " .. l_NumberOfMutableSegments .. " mutable segments.")
	end

	local l_HalfOfTheProteinSegments
	l_HalfOfTheProteinSegments = g_SegmentCount_WithoutLigands / 2
	if l_NumberOfMutableSegments > l_HalfOfTheProteinSegments then
		g_bFreeDesignPuzzle = true
		print("  Since more than half of the protein's segments are mutable, " ..
             l_NumberOfMutableSegments .." of " .. g_SegmentCount_WithoutLigands ..
          ", this is considered a design puzzle.")
	end

	-- Find out if the puzzle has any disulfide bonds...
	Populate_g_CysteineSegmentsTable()
	if #g_CysteineSegmentsTable > 1 then
		print("  Puzzle has " .. #g_CysteineSegmentsTable .. " cysteine segments.")
		if g_OriginalNumberOfDisulfideBonds > 0 then
			print("  Puzzle has " .. g_OriginalNumberOfDisulfideBonds .. " disulfide bonds.")
			g_bUserSelected_KeepDisulfideBonds_Intact = true -- so much for the user deciding...
		end
	end

	local l_SegmentTotal = Calculate_SegmentRange_Score(nil, 1, g_SegmentCount_WithLigands)
	-- print("l_SegmentTotal=[" .. l_SegmentTotal .. "]")

	-- Find out if the puzzle has Density scores and their weight if any...
	local l_DensityTotal = Calculate_SegmentRange_Score("density")
	-- print("l_DensityTotal=[" .. l_DensityTotal .. "]")

	g_bHasDensity = math.abs(l_DensityTotal) > 0.0001
	-- print("g_bHasDensity=[" .. tostring(g_bHasDensity) .. "]")

  local l_Current_PoseTotalScore = GetPoseTotalScore()
	if g_bHasDensity == true then
    -- How was this formula derived? What if PoseTotalScore is negative?
    if l_Current_PoseTotalScore > 0 then
      g_DensityWeight = 
        (l_Current_PoseTotalScore - g_ComputedMaximumPotentialBonusPoints - l_SegmentTotal - 8000) /
          l_DensityTotal
    end
		print("  Puzzle has Density scores. The density weight = " .. 
      PrettyNumber(g_DensityWeight) .. " points")
	end

	-- Check if this is likely a symmetry puzzle...
	if g_bHasDensity == false then    
		local l_ComputedScore = math.abs(l_Current_PoseTotalScore - l_SegmentTotal - 8000) -- why?
		-- print("PoseTotalScore: " .. PrettyNumber(l_Current_PoseTotalScore ) .. 
    --      " ComputedScore: " .. PrettyNumber(l_ComputedScore) .. "")
		g_bProbableSymmetryPuzzle = l_ComputedScore > 2
		if g_bProbableSymmetryPuzzle == true then
			print("  Puzzle is a symmetry puzzle or has bonuses")
		end
	end
  
	if g_bHasLigand == true then
    print("  Puzzle has a ligand (small extra molecule near the protein)." ..
          " Ligand scoring is active in ScorePart (slot) 6.")
  end 
  
  print("  Starting score: " .. PrettyNumber(l_Current_PoseTotalScore))

end -- DisplayPuzzleProperties()
function Populate_g_CysteineSegmentsTable()
  -- Called from DisplayPuzzleProperties()...

	--g_CysteineSegmentsTable={SegmentIndex}
	g_CysteineSegmentsTable = FindSegmentsWithAminoAcidType("c")
	g_OriginalNumberOfDisulfideBonds = CountDisulfideBonds()
  
end -- function Populate_g_CysteineSegmentsTable()
function FindSegmentsWithAminoAcidType(In_AminoAcidType)
  -- Called from Populate_g_CysteineSegmentsTable()...
  
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
			local l_GetAminoAcid = structure.GetAminoAcid(l_SegmentIndex) -- e.g., "c"
		if l_GetAminoAcid == In_AminoAcidType then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
	end
	return l_SegmentsTable
  
end -- function FindSegmentsWithAminoAcidType(In_AminoAcidType)
function CountDisulfideBonds()
  -- Called from Populate_g_CysteineSegmentsTable() and
  --             bOneOrMoreDisulfideBondsHaveBroken()...
  
	local l_Count = 0
	for l_SegmentIndex = 1, #g_CysteineSegmentsTable do
		if bIsADisulfideBondSegment(g_CysteineSegmentsTable[l_SegmentIndex]) then
			l_Count = l_Count + 1
		end
	end
	return l_Count
  
end -- function CountDisulfideBonds()
function bIsADisulfideBondSegment(l_SegmentIndex)
  -- Called from CountDisulfideBonds()...
  
	-- Disulfide bonds in proteins are formed between the thiol groups of cysteine 
	-- residues (segments/amino acids) by the process of oxidative folding. The other
	-- sulfur-containing amino acid, methionine, cannot form disulfide bonds...
	-- Disulfide bonds (bridges) help stabilize tertiary structures in proteins...
	if structure.IsLocked(l_SegmentIndex) == true then
		-- print("structure.IsLocked(" .. l_SegmentIndex .. ")=[" ..
		--  tostring(structure.IsLocked(l_SegmentIndex)) .. "]")
		-- We don't include locked segments, because we can't modify them anyhow, right? I think.
		return false
	end
	local l_ScorePart = "disulfides"
	-- We already know this is a cysteine segment, but is it also bonded to another cysteine segment,
	-- via a disulfide bond. We can find out by checking if this segment has a disulfide score > 0...
	local DisulfidesEnergySubscore =
		tonumber(tostring(current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart)))
	-- print("GetSegmentEnergySubscore(" .. l_SegmentIndex .. ", 'disulfides')=[" .. 
	--  DisulfidesEnergySubscore .. "]")
	if DisulfidesEnergySubscore > 0 then
		return true
	end
	return false
  
end -- function bIsADisulfideBondSegment(l_SegmentIndex)
function FindSelectedSegmentRanges()
  -- Called from 1 place in SetSegmentRangeSecondaryStructureType,
  --             2 places in AskUserToSelect_Segments_ToRebuild() and
  --             1 place in main()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindSelectedSegments())
  
end -- function FindSelectedSegmentRanges()
function FindSelectedSegments()
  -- Called from FindSelectedSegmentRanges()...
  
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithLigands do
    
		if selection.IsSelected(l_SegmentIndex) then
      
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
      
		end
    
	end
  
	return l_SegmentsTable
  
end -- function FindSelectedSegments()
function ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)
-- Called from CleanUpSegmentRangesTable(),
  --             GetCommonSegmentRangesInBothTables(),
  --             FindFrozenSegmentRanges(),
  --             FindLockedSegmentRanges(),
  --             FindLockedSegmentRanges(),
  --             FindSelectedSegmentRanges() and 
  --             FindSegmentRangesWithSecondaryStructureType()...
  
  -- Note: Most functions assume that the segment ranges 
  --       are well formed (i.e., sorted and no overlaps)

	-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}

	local l_SegmentRangesTable = {}
	local l_StartSegment = 0
	local l_EndSegment = -1

	table.sort(l_SegmentsTable)

	-- seems like a simpler way would be just to
	-- 1) get the first one: l_StartSegment = l_SegmentsTable[1]
	-- 2) get the last one: l_EndSegment = l_SegmentsTable[#l_SegmentsTable]
	-- 3) add to SegmentSetTable: l_SegmentRangesTable[#l_SegmentRangesTable + 1] =
	--    {l_StartSegment, l_EndSegment}
	-- Oh, I see, there can be many gaps in between, so we have to deal with it, right!

	for l_TableIndex = 1, #l_SegmentsTable do
    
		if l_SegmentsTable[l_TableIndex] ~= l_EndSegment + 1 and
			 l_SegmentsTable[l_TableIndex] ~= l_EndSegment then
         
			-- note: duplicates are removed
			if l_EndSegment > 0 then
				l_SegmentRangesTable[#l_SegmentRangesTable + 1] = {l_StartSegment, l_EndSegment}
			end
      
			l_StartSegment = l_SegmentsTable[l_TableIndex]
      
		end
    
		l_EndSegment = l_SegmentsTable[l_TableIndex]

	end

	if l_EndSegment > 0 then
		l_SegmentRangesTable[#l_SegmentRangesTable + 1] = {l_StartSegment, l_EndSegment}
	end

	return l_SegmentRangesTable
  
end -- function ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)
function bAskUserToSelect_RebuildOptions()
  -- Called from main()...
  
	local l_bUserWantsToSelectSegmentsToRebuild = false
	--local l_bUserWantsToSelectSegmentsToRebuild = true -- allows debugging offline

	local l_bUserWantsToSelectMutateOptions = false
	if g_bProteinHasMutableSegments == true then
		l_bUserWantsToSelectMutateOptions = true
	end
  
	local l_AskResult = 0
  
	repeat
    
		local l_Ask = dialog.CreateDialog("Select Rebuild Options")
    
		l_Ask.L1 =
			dialog.AddLabel("Number of consecutive segments to rebuild:")
		l_Ask.g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments =
			dialog.AddSlider("  Starting with:",
				g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments, 1, 10, 0)
		l_Ask.g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments =
			dialog.AddSlider("  Continue thru:",
				g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments, 1, 10, 0)
      
		if g_bSketchBookPuzzle == true then
			l_Ask.L2 = dialog.AddLabel("For a sketch book puzzle:")
			l_Ask.L3 = dialog.AddLabel("Save the current position if the")
			l_Ask.L4 = dialog.AddLabel("current rebuild gain is more than:")
			l_Ask.g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave =
				dialog.AddSlider("  Points:",
					g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave, 0, 100, 0)
		end
    
		l_Ask.L5 = dialog.AddLabel("Wiggle more when Clash Importance is maximum:")
		l_Ask.g_UserSelected_WiggleFactor = 
      dialog.AddSlider("  WiggleFactor:", g_UserSelected_WiggleFactor, 1, 5, 0)
    
		l_Ask.L6 = dialog.AddLabel("Select ScoreParts to stabilize, last choice overrides:")
		l_Ask.g_bUserSelected_SelectAllScorePartsToStabilize =
      dialog.AddCheckbox("Select all ScoreParts", g_bUserSelected_SelectAllScorePartsToStabilize)
		l_Ask.g_bUserSelected_SelectMain4ScorePartsToStabilize =
			dialog.AddCheckbox("Select the top 4 scoring ScoreParts (faster)",
        g_bUserSelected_SelectMain4ScorePartsToStabilize)
		l_Ask.bSelectScorePartsToStabilize =
      dialog.AddCheckbox("Manully select ScoreParts from a list...", false)
      
		l_Ask.L7 = dialog.AddLabel("Maximum number of full cycles to run:")
		l_Ask.g_UserSelected_NumberOfRunCycles = 
      dialog.AddSlider("  Run cycles:", g_UserSelected_NumberOfRunCycles, 1, 40, 0)
    
		l_Ask.L8 = dialog.AddLabel("Skip the first X number of segments ranges. User")
    l_Ask.L9 = dialog.AddLabel("usually sets this value after a script crashes, or")
    l_Ask.L10 = dialog.AddLabel("the power goes out.")
		l_Ask.g_UserSelected_NumberOf_SegmentRanges_ToSkip = dialog.AddSlider("  X segments:",
				g_UserSelected_NumberOf_SegmentRanges_ToSkip, 0, g_SegmentCount_WithoutLigands, 0)
      
		l_Ask.l_bUserWantsToSelectSegmentsToRebuild =
			dialog.AddCheckbox("Select Segments to Rebuild...", l_bUserWantsToSelectSegmentsToRebuild)
      
		if g_bProteinHasMutableSegments == true then
			l_Ask.l_bUserWantsToSelectMutateOptions =
				dialog.AddCheckbox("Select Mutate Options...", l_bUserWantsToSelectMutateOptions)
		end
    
		l_Ask.g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments =
			dialog.AddCheckbox("Shake and Wiggle only selected segments",
			g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments)
    
		l_Ask.L11 = dialog.AddLabel("Select ScoreParts to include when calculating worst")
		l_Ask.L12 = dialog.AddLabel("scoring segments:")
		l_Ask.bUserWantsToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments =
			dialog.AddCheckbox("Select worst scoring ScoreParts...", false)
      
		if g_OriginalNumberOfDisulfideBonds > 1 then
			l_Ask.g_bUserSelected_KeepDisulfideBonds_Intact = 
				dialog.AddCheckbox("Keep sulfide bonds intact", g_bUserSelected_KeepDisulfideBonds_Intact)
		end
    
		l_Ask.g_bUserSelected_ConvertAllSegmentsToLoops =
			dialog.AddCheckbox("Convert all segments to loops", g_bUserSelected_ConvertAllSegmentsToLoops)
      
		l_Ask.L13 = dialog.AddLabel("Always allow rebuilding already rebuilt segments:")
		l_Ask.g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = dialog.AddCheckbox("Always allow",
			g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments)
    
		l_Ask.g_bUserSelected_Disable_Bands_DuringRebuild =
			dialog.AddCheckbox("Disable bands during rebuild", g_bUserSelected_Disable_Bands_DuringRebuild)
      
		l_Ask.AskResult1 = dialog.AddButton("OK", 1)
		l_Ask.AskResult0 = dialog.AddButton("Cancel", 0)
		l_Ask.AskResult2 = dialog.AddButton("More options", 2)
    
		l_AskResult = dialog.Show(l_Ask)
		if l_AskResult > 0 then -- 0 = Cancel
      
			g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments =
        l_Ask.g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments.value
			g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments =
        l_Ask.g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments.value
        
			g_UserSelected_NumberOfRunCycles = l_Ask.g_UserSelected_NumberOfRunCycles.value
      
			g_UserSelected_NumberOf_SegmentRanges_ToSkip =
        l_Ask.g_UserSelected_NumberOf_SegmentRanges_ToSkip.value
			g_bUserSelected_Disable_Bands_DuringRebuild = l_Ask.g_bUserSelected_Disable_Bands_DuringRebuild.value
			g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments =
        l_Ask.g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments.value
        
			g_bUserSelected_ConvertAllSegmentsToLoops = l_Ask.g_bUserSelected_ConvertAllSegmentsToLoops.value
      
			if g_bSketchBookPuzzle == true then
				g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave = 
					ask.g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave.value
			end
      
			g_UserSelected_WiggleFactor = l_Ask.g_UserSelected_WiggleFactor.value
      
			local spt_bScorePartIsActive = 3
      
			-- Check for changes to included/selected (activated) ScoreParts (slots)...
			local l_bIncluded_WorstScoreParts_HasChanged = false
      
			if g_bUserSelected_SelectAllScorePartsToStabilize ~=
        l_Ask.g_bUserSelected_SelectAllScorePartsToStabilize.value then
        
				g_bUserSelected_SelectAllScorePartsToStabilize =
          l_Ask.g_bUserSelected_SelectAllScorePartsToStabilize.value
        
				l_bIncluded_WorstScoreParts_HasChanged = true
        
				if g_bUserSelected_SelectAllScorePartsToStabilize == true then
					-- User chose to include all ScoreParts (slots)...
          
					-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
					for l_ScorePartsTableIndex=1, #g_ScorePartsTable do
						-- Update the g_ScorePartsTable...
						g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = true
					end
				end
			end
      
			if g_bUserSelected_SelectMain4ScorePartsToStabilize ~=
        l_Ask.g_bUserSelected_SelectMain4ScorePartsToStabilize.value then
        
				g_bUserSelected_SelectMain4ScorePartsToStabilize =
          l_Ask.g_bUserSelected_SelectMain4ScorePartsToStabilize.value
        
				l_bIncluded_WorstScoreParts_HasChanged = true
        
				if g_bUserSelected_SelectMain4ScorePartsToStabilize == true then
          
					-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
					for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
            
						local l_ScorePart_Number, l_ScorePart_Name
						l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
						l_ScorePart_Name = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
            
						-- Update the g_ScorePartsTable...
						if l_ScorePart_Number == 4 or
							 l_ScorePart_Name == 'Backbone' or
							 l_ScorePart_Name == 'Hiding' or
							 l_ScorePart_Name == 'Packing'
							 then
							g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = true
						else
							g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = false
						end
					end
				end
			end
      
			if l_Ask.bSelectScorePartsToStabilize.value == true then
				AskUserToSelect_ScoreParts_ToStabilize() -- perhaps return l_bIncluded_WorstScoreParts_HasChanged
				l_bIncluded_WorstScoreParts_HasChanged = true
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
			end
      
			if l_Ask.bUserWantsToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments.value == true then
        
				AskUserToSelect_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments()
        -- ...perhaps should return l_bIncluded_WorstScoreParts_HasChanged.
				l_bIncluded_WorstScoreParts_HasChanged = true
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
			end
      
			if l_bIncluded_WorstScoreParts_HasChanged == true then
        
				print("\nUser has selected the following ScoreParts to" ..
               " include when calculating worse scoring segments:")
             
				local l_bScorePart_IsActive, l_ScorePart_Number, l_ScorePart_Name
        
				-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
				for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
					l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
					l_ScorePart_Name = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
					l_bScorePart_IsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
					if l_bScorePart_IsActive == true then
						print("  Active ScorePart ".. l_ScorePart_Number .." (".. l_ScorePart_Name .. ")")
					end
				end
        
      end
      
			l_bUserWantsToSelectSegmentsToRebuild = l_Ask.l_bUserWantsToSelectSegmentsToRebuild.value
      
			if l_bUserWantsToSelectSegmentsToRebuild == true then
        
				g_bUserSelected_SelectMain4ScorePartsToStabilize = false
				g_bUserSelected_SelectAllScorePartsToStabilize = false
        
				-- l_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
				local l_SegmentRangesToRebuildTable = {}
				l_SegmentRangesToRebuildTable = AskUserToSelect_Segments_ToRebuild()
				if l_SegmentRangesToRebuildTable ~= nil and #l_SegmentRangesToRebuildTable ~= 0 then
					g_SegmentRangesToRebuildTable = l_SegmentRangesToRebuildTable
				end
        
				print("  Selected Segment Ranges: [" ..
					ConvertSegmentRangesTableToListOfSegmentRanges(g_SegmentRangesToRebuildTable) .. "]")
        
				l_bUserWantsToSelectSegmentsToRebuild = false -- this will turn off the check box on the top menu
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
        
      else
        
				-- By default do not include frozen, locked or ligand segments...
				g_SegmentRangesToRebuildTable =
					SegmentRangesMinus(g_SegmentRangesToRebuildTable, FindFrozenSegmentRanges())
				g_SegmentRangesToRebuildTable =
					SegmentRangesMinus(g_SegmentRangesToRebuildTable, FindLockedSegmentRanges())
				g_SegmentRangesToRebuildTable =
					SegmentRangesMinus(g_SegmentRangesToRebuildTable, 
            FindSegmentRangesWithSecondaryStructureType("M"))
          
      end
      
			if g_bProteinHasMutableSegments == true then
        
				if l_Ask.l_bUserWantsToSelectMutateOptions.value == true then
					AskUserForMutateOptions()
          
				print("\nSelected Mutate Options:\n")
        
					local l_Message = "  When to Mutate:"
					if g_bUserSelected_Mutate_After_Rebuild == true then
            l_Message = l_Message .. " [after each rebuild]" end
					if g_bUserSelected_Mutate_During_Stabilize == true then
						l_Message = l_Message .. " [during Stabilize]" end
					if g_bUserSelected_Mutate_After_Stabilize == true then
						l_Message = l_Message .. " [after Stabilize]" end
					if g_bUserSelected_Mutate_Before_FuseBestPosition == true then
						l_Message = l_Message .. " [before fusing best position]" end
					if g_bUserSelected_Mutate_After_FuseBestPosition == true then
						l_Message = l_Message .. " [after fusing best position]" end
					print(l_Message)

					l_Message = "  Mutate area: "
					if g_bUserSelected_Mutate_OnlySelected_Segments == true then
						l_Message = l_Message .. "Only the selected segments."
					elseif g_bUserSelected_Mutate_SelectedAndNearby_Segments == true then
						l_Message = l_Message .. "The selected and near by segments within a radius of [" ..
							g_UserSelected_Mutate_SphereRadius .. "] Angstroms."
					else
						l_Message = l_Message .. "The entire protein."
					end
					print(l_Message)
          
					l_bUserWantsToSelectMutateOptions = false -- turn off the "Select Mutate Options" checkbox
					if l_AskResult == 1 then -- 1 = OK
						l_AskResult = 4 -- 4 = Go back to top menu
					end
				end
			end
      
			g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments =
        l_Ask.g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments.value
      
			if g_OriginalNumberOfDisulfideBonds > 1 then
				g_bUserSelected_KeepDisulfideBonds_Intact = l_Ask.g_bUserSelected_KeepDisulfideBonds_Intact.value
			end
      
			if l_AskResult == 2 then
				AskMoreOptions()
			end
      
		end -- if l_AskResult > 0 then
    
	until l_AskResult < 2 -- 0 = Cancel, 1 = OK, 2 = More Options, 3 = ?, 4 = Go back to top menu

	-- Cancel or OK was pressed...

	local l_bOkayToContinue = false
	if l_AskResult == 1 then -- 0 = Cancel, 1 = OK
		l_bOkayToContinue = true
	end

	return l_bOkayToContinue

end -- bAskUserToSelect_RebuildOptions()
function AskUserToSelect_ScoreParts_ToStabilize()
  -- Called from bAskUserToSelect_RebuildOptions()...

	local l_title = "Select ScoreParts to Stabilize"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("After rebuilding each segment range several times,")
  l_Ask.l2 = dialog.AddLabel("select the best scoring poses of each of the below")
  l_Ask.l3 = dialog.AddLabel("selected ScoreParts to Stabilize (shake and wiggle")
  l_Ask.l4 = dialog.AddLabel("regionally) to look for more score gains:")
	local l_ScorePart_Number, l_ScorePart_Name, l_bScorePart_IsActive

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	for l_TableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number    = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Number]
		l_ScorePart_Name      = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Name]
		l_bScorePart_IsActive = g_ScorePartsTable[l_TableIndex][spt_bScorePartIsActive]
    
    if l_ScorePart_Name == "loctotal" or
       l_ScorePart_Name == 'Backbone' or
       l_ScorePart_Name == 'Hiding' or
       l_ScorePart_Name == 'Packing' then
       l_ScorePart_Name = l_ScorePart_Name .. "*"
    end
    
		l_Ask[l_ScorePart_Name] =
			dialog.AddCheckbox(l_ScorePart_Number .. " " .. l_ScorePart_Name, l_bScorePart_IsActive)
      
	end
	l_Ask.l5 = dialog.AddLabel("* asterisk indicates one of the top 4 scoring parts")

	l_Ask.OK = dialog.AddButton("OK", 1)
	l_Ask.Cancel = dialog.AddButton("Cancel", 0)

	if dialog.Show(l_Ask) > 0 then
    
		for l_TableIndex = 1, #g_ScorePartsTable do
			l_ScorePart_Name = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Name]
      if l_ScorePart_Name == "loctotal" or
         l_ScorePart_Name == 'Backbone' or
         l_ScorePart_Name == 'Hiding' or
         l_ScorePart_Name == 'Packing' then
         l_ScorePart_Name = l_ScorePart_Name .. "*"
      end    
      
			-- Update the g_ScorePartsTable...
			g_ScorePartsTable[l_TableIndex][spt_bScorePartIsActive] = l_Ask[l_ScorePart_Name].value
		end
    
	end

end -- AskUserToSelect_ScoreParts_ToStabilize()
function AskUserToSelect_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments()
  -- Called from bAskUserToSelect_RebuildOptions()...

  local l_title = "Calculating worst scoring segments"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("Select ScoreParts to include when calculating worst")
	l_Ask.l2 = dialog.AddLabel("scoring segments:")
	local l_ScorePart_Name

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	for l_TableIndex = 3, #g_ScorePartsTable do
		l_ScorePart_Name = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Name]
    
     if l_ScorePart_Name == "loctotal" or
       l_ScorePart_Name == 'Backbone' or
       l_ScorePart_Name == 'Hiding' or
       l_ScorePart_Name == 'Packing' then
       l_ScorePart_Name = l_ScorePart_Name .. "*"
    end
    
		l_Ask[l_ScorePart_Name] = dialog.AddCheckbox(l_ScorePart_Name, false)
    
	end
	l_Ask.l3 = dialog.AddLabel("* asterisk indicates one of the top 4 scoring parts")

	l_Ask.OK = dialog.AddButton("OK", 1)
	l_Ask.Cancel = dialog.AddButton("Cancel", 0)
	g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table = {}

	if dialog.Show(l_Ask) > 0 then
    
		for l_TableIndex = 3, #g_ScorePartsTable do
			l_ScorePart_Name = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Name]
      if l_ScorePart_Name == "loctotal" or
         l_ScorePart_Name == 'Backbone' or
         l_ScorePart_Name == 'Hiding' or
         l_ScorePart_Name == 'Packing' then
         l_ScorePart_Name = l_ScorePart_Name .. "*"
      end
      
			if l_Ask[l_ScorePart_Name].value == true then
        
        local l_TableCount = #g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table
        
				g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table[l_TableCount + 1] =
					string.gsub(l_ScorePart_Name, "*", "")
          
          --print("l_ScorePart_Name without asterisk:" .. l_ScorePart_Name)
			end
      
		end
    
	end

end -- AskUserToSelect_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments()
function AskUserToSelect_Segments_ToRebuild()
  -- Called from bAskUserToSelect_RebuildOptions()...

	title = "Select Segments To Rebuild"

	-- g_SegmentRangesToRebuildTable={StartSegment, EndSegment}
	l_ListOfSegmentRanges = ConvertSegmentRangesTableToListOfSegmentRanges(g_SegmentRangesToRebuildTable)
  -- e.g.;  "1-3 2-4 6-8 10-11 13-15 20-24" 
	
	local l_SegmentRangesToRebuildTable = g_SegmentRangesToRebuildTable

	if l_SelectionOptions == nil then l_SelectionOptions = {} end

	-- Set up default options if this is the first time in this function (remember, we can return here)...
	if l_SelectionOptions.bAllowAskingToIncludeLigandSegments == nil then
		 l_SelectionOptions.bAllowAskingToIncludeLigandSegments = false end -- never appears to be true.
	if l_SelectionOptions.bAllowAskingToIncludeLockedSegments == nil then
		 l_SelectionOptions.bAllowAskingToIncludeLockedSegments = false end -- never appears to be true.
	if l_SelectionOptions.bAllowAskingToIncludeFrozenSegments == nil then
		 l_SelectionOptions.bAllowAskingToIncludeFrozenSegments = false end -- never appears to be true.
	if l_SelectionOptions.bAllowAskingToIncludeOnlySelectedSegments == nil then
		 l_SelectionOptions.bAllowAskingToIncludeOnlySelectedSegments = true end
	if l_SelectionOptions.bAllowAskingToIncludeOnlyUnSelectedSegments == nil then
		 l_SelectionOptions.bAllowAskingToIncludeOnlyUnSelectedSegments = true end
	if l_SelectionOptions.bUserWantsToSelectSegmentRanges == nil then
		 l_SelectionOptions.bUserWantsToSelectSegmentRanges = true end

	-- Set up default options if this is the first time in this function (remember, we can return here)...
	if l_SelectionOptions.bIncludeLoopSegments == nil then
		 l_SelectionOptions.bIncludeLoopSegments = true end -- Include Loop segments by default.
	if l_SelectionOptions.bIncludeHelixSegments == nil then
		 l_SelectionOptions.bIncludeHelixSegments = true end -- Include Helix segments by default.
	if l_SelectionOptions.bIncludeSheetSegments == nil then
		 l_SelectionOptions.bIncludeSheetSegments = true end -- Include Sheet segments by default.
	if l_SelectionOptions.bIncludeLigandSegments == nil then
		 l_SelectionOptions.bIncludeLigandSegments = false end -- never appears to be true.
	if l_SelectionOptions.bIncludeLockedSegments == nil then
		 l_SelectionOptions.bIncludeLockedSegments = false end -- never appears to be true.
	if l_SelectionOptions.bIncludeFrozenSegments == nil then
		 l_SelectionOptions.bIncludeFrozenSegments = false end -- never appears to be true.
	if l_SelectionOptions.bIncludeOnlySelectedSegments == nil then
		 l_SelectionOptions.bIncludeOnlySelectedSegments = false end
	if l_SelectionOptions.bIncludeOnlyUnSelectedSegments == nil then
		 l_SelectionOptions.bIncludeOnlyUnSelectedSegments = false end

	local l_bErrorFound = false

	repeat
    
		local l_Ask = dialog.CreateDialog(title)
    
		if l_bErrorFound == true then
			l_Ask.E1 = dialog.AddLabel("Errors found! Try again. Check output box.")
			l_bErrorFound = false
		end
    
		if l_SelectionOptions.bUserWantsToSelectSegmentRanges == true then
			l_Ask.R1 = dialog.AddLabel("Select segment ranges to rebuild:")
			l_Ask.ListOfSegmentRanges = dialog.AddTextbox("  Ranges:", l_ListOfSegmentRanges)
			l_Ask.R2 = dialog.AddLabel("Below selections override above list:")
		end
    
		l_Ask.bIncludeLoopSegments = dialog.AddCheckbox("Include loop segments",
			l_SelectionOptions.bIncludeLoopSegments)

		l_Ask.bIncludeHelixSegments = dialog.AddCheckbox("Include helix segments",
			l_SelectionOptions.bIncludeHelixSegments)
    
		l_Ask.bIncludeSheetSegments = dialog.AddCheckbox("Include sheet segments",
			l_SelectionOptions.bIncludeSheetSegments)
    
		if l_SelectionOptions.bAllowAskingToIncludeLigandSegments == true then -- never appears to be true.
			l_Ask.bIncludeLigandSegments = dialog.AddCheckbox("Include ligand segments",
				l_SelectionOptions.bIncludeLigandSegments)
		elseif l_SelectionOptions.bIncludeLigandSegments == false then -- never appears to be true.
			l_Ask.noligands = dialog.AddLabel("Ligand segments will not be included")
		end
    
		if l_SelectionOptions.bAllowAskingToIncludeLockedSegments == true then -- never appears to be true.
			l_Ask.bIncludeLockedSegments = dialog.AddCheckbox("Include locked segments",
				l_SelectionOptions.bIncludeLockedSegments)
		elseif l_SelectionOptions.bIncludeLockedSegments == false then
			l_Ask.nolocks = dialog.AddLabel("Locked segments will not be included")
		end
    
		if l_SelectionOptions.bAllowAskingToIncludeFrozenSegments == true then -- never appears to be true.
			l_Ask.bIncludeFrozenSegments = dialog.AddCheckbox("Include frozen segments",
				l_SelectionOptions.bIncludeFrozenSegments)
		elseif l_SelectionOptions.bIncludeFrozenSegments == false  then
			l_Ask.nofrozen = dialog.AddLabel("Frozen segments will not be included")
		end
    
		if l_SelectionOptions.bAllowAskingToIncludeOnlySelectedSegments == true then
			l_Ask.bIncludeOnlySelectedSegments = dialog.AddCheckbox("Only work on selected segments",
				l_SelectionOptions.bIncludeOnlySelectedSegments)
		end
    
		if l_SelectionOptions.bAllowAskingToIncludeOnlyUnSelectedSegments == true then
			l_Ask.bIncludeOnlyUnSelectedSegments = dialog.AddCheckbox("Only work on unselected segments",
				l_SelectionOptions.bIncludeOnlyUnSelectedSegments)
		end
    
		l_Ask.OK = dialog.AddButton("OK", 1)
		l_Ask.Cancel = dialog.AddButton("Cancel", 0)
    
		if dialog.Show(l_Ask) > 0 then
      
			local l_ListOfSegmentRanges = l_Ask.ListOfSegmentRanges.value
      
			if l_SelectionOptions.bUserWantsToSelectSegmentRanges == true and
				l_ListOfSegmentRanges ~= "" then
          
				local function bCheckIfValidSegmentNumbers(l_SegmentsTable)
					-- l_SegmentsTable = {
					-- l_SegmentsTable has one field per row...
					-- PositiveSegmentNumber
					-- }
          
					-- Now checking...
					if #l_SegmentsTable % 2 ~= 0 then
						print("Not an even number of segments found in l_SegmentsTable")
						return false
					end
          
					for l_SegmentIndex = 1, #l_SegmentsTable do
						if l_SegmentsTable[l_SegmentIndex] == 0 or
							l_SegmentsTable[l_SegmentIndex] > g_SegmentCount_WithLigands then
							--l_SegmentsTable[l_SegmentIndex] > structure.GetCount() then
							print("Segment number " .. l_SegmentsTable[l_SegmentIndex] ..
								" is not a valid segment number")
							return false
						end
					end
          
					return true
				end
        
				local function Convert_ListOfSegmentRanges_To_SegmentRangesTable(l_ListOfSegmentRanges)
          
					-- l_ListOfSegmentRanges = e.g., {"1-3 9-11 134-135"}
					-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}
					-- l_SegmentRangesToRebuildTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
          
					local l_SegmentsTable = {}
					local l_SegmentRangesToRebuildTable = {}
					local l_NoNegatives = '%d+'
          
					--for l_SegmentIndex in string.gfind(l_ListOfSegmentRanges, l_NoNegatives) do
					for l_SegmentIndex in string.gmatch(l_ListOfSegmentRanges, l_NoNegatives) do
            
						-- Insert one row into the l_SegmentsTable...
						table.insert(l_SegmentsTable, tonumber(l_SegmentIndex))
					end
          
					if bCheckIfValidSegmentNumbers(l_SegmentsTable) then
            
						for l_SegmentIndex = 1, #l_SegmentsTable / 2 do
              
							local l_StartSegment = l_SegmentsTable[2 * l_SegmentIndex - 1]
							local l_EndSegment = l_SegmentsTable[2 * l_SegmentIndex]
              
							-- Insert one row into the l_SegmentRangesToRebuildTable...
							l_SegmentRangesToRebuildTable[l_SegmentIndex] = {l_StartSegment, l_EndSegment}
						end
            
						l_SegmentRangesToRebuildTable = CleanUpSegmentRangesTable(l_SegmentRangesToRebuildTable)
            
          else
            
						l_bErrorFound = true
						l_SegmentRangesToRebuildTable = {}
            
					end
					return l_SegmentRangesToRebuildTable
          
        end
        
				-- Convert l_ListOfSegmentRanges to l_SegmentRangesToRebuildTable...
				local l_ConvertedSegmentRangesTable =
					Convert_ListOfSegmentRanges_To_SegmentRangesTable(l_ListOfSegmentRanges)
          
				if l_ConvertedSegmentRangesTable ~= "" then
					l_SegmentRangesToRebuildTable = l_ConvertedSegmentRangesTable
				end
        
				-- Not sure what I screwed up here...
				--if l_bErrorFound == false then
				--  l_SegmentRangesToRebuildTable =
				--    GetCommonSegmentRangesInBothTables(l_SegmentRangesToRebuildTable,
        --    l_SegmentRangesToRebuildTable)
				--end
        
      end
      
			l_SelectionOptions.bIncludeLoopSegments = l_Ask.bIncludeLoopSegments.value
			if l_SelectionOptions.bIncludeLoopSegments == false then
				-- User does not want to include loop segments...
				l_SegmentRangesToRebuildTable = SegmentRangesMinus(l_SegmentRangesToRebuildTable,
					FindSegmentRangesWithSecondaryStructureType("L"))
			end
      
			l_SelectionOptions.bIncludeHelixSegments = l_Ask.bIncludeHelixSegments.value
			if l_SelectionOptions.bIncludeHelixSegments == false then
				-- User does not want to include helix segments...
				l_SegmentRangesToRebuildTable = SegmentRangesMinus(l_SegmentRangesToRebuildTable,
					FindSegmentRangesWithSecondaryStructureType("H"))
			end
      
			l_SelectionOptions.bIncludeSheetSegments = l_Ask.bIncludeSheetSegments.value
			if l_SelectionOptions.bIncludeSheetSegments == false then
				-- User does not want to include sheet segments...
				l_SegmentRangesToRebuildTable = SegmentRangesMinus(l_SegmentRangesToRebuildTable,
					FindSegmentRangesWithSecondaryStructureType("E"))
			end
      
			if l_SelectionOptions.bAllowAskingToIncludeLigandSegments == true then -- never appears to be true.
				l_SelectionOptions.bIncludeLigandSegments = l_Ask.bIncludeLigandSegments.value
			end
			if l_SelectionOptions.bIncludeLigandSegments == false then -- This never appears to be true.
				l_SegmentRangesToRebuildTable = SegmentRangesMinus(l_SegmentRangesToRebuildTable,
					FindSegmentRangesWithSecondaryStructureType("M"))
			end
      
			if l_SelectionOptions.bAllowAskingToIncludeLockedSegments == true then -- never appears to be true.
				l_SelectionOptions.bIncludeLockedSegments = l_Ask.bIncludeLockedSegments.value
			end
			if l_SelectionOptions.bIncludeLockedSegments == false then -- never appears to be true.
				l_SegmentRangesToRebuildTable = 
          SegmentRangesMinus(l_SegmentRangesToRebuildTable, FindLockedSegmentRanges())
			end
      
			if l_SelectionOptions.bAllowAskingToIncludeFrozenSegments == true then -- never appears to be true.
				l_SelectionOptions.bIncludeFrozenSegments = l_Ask.bIncludeFrozenSegments.value
			end
			if l_SelectionOptions.bIncludeFrozenSegments == false then
				l_SegmentRangesToRebuildTable = 
          SegmentRangesMinus(l_SegmentRangesToRebuildTable, FindFrozenSegmentRanges())
			end
      
			if l_SelectionOptions.bAllowAskingToIncludeOnlySelectedSegments == true then
				l_SelectionOptions.bIncludeOnlySelectedSegments =
					l_Ask.bIncludeOnlySelectedSegments.value
			end      
			if l_SelectionOptions.bIncludeOnlySelectedSegments == true then
				l_SegmentRangesToRebuildTable =
					GetCommonSegmentRangesInBothTables(l_SegmentRangesToRebuildTable, FindSelectedSegmentRanges())
			end
      
			if l_SelectionOptions.bAllowAskingToIncludeOnlyUnSelectedSegments == true then
				l_SelectionOptions.bIncludeOnlyUnSelectedSegments =
					l_Ask.bIncludeOnlyUnSelectedSegments.value
			end
			if l_SelectionOptions.bIncludeOnlyUnSelectedSegments == true then
				l_SegmentRangesToRebuildTable =
					GetCommonSegmentRangesInBothTables(l_SegmentRangesToRebuildTable,
						InvertSegmentRangesTable(FindSelectedSegmentRanges()))
			end
      
    end
  
	until l_bErrorFound == false

	return l_SegmentRangesToRebuildTable

end -- AskUserToSelect_Segments_ToRebuild()
function ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
  -- Called from CleanUpSegmentRangesTable() and
  --             2 places in GetCommonSegmentRangesInBothTables()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}

	if l_SegmentRangesTable == nil then
		return {}
	end

	local l_SegmentsTable = {}
	local l_StartSegment, l_EndSegment

	for l_TableIndex = 1, #l_SegmentRangesTable do
    
		l_StartSegment = l_SegmentRangesTable[l_TableIndex][1]
		l_EndSegment = l_SegmentRangesTable[l_TableIndex][2]
    
		for l_SegmentIndex = l_StartSegment, l_EndSegment do
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
    
	end

	return l_SegmentsTable
  
end -- function ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
function CleanUpSegmentRangesTable(l_SegmentRangesTable)
  -- Called from AskUserToSelect_Segments_ToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}

	-- This makes it well formed...
	local l_SegmentsTable = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
	local l_CleanedUpSegmentRangesTable = ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)

	return l_CleanedUpSegmentRangesTable

end -- function CleanUpSegmentRangesTable(l_SegmentRangesTable)
function SegmentRangesMinus(l_SegmentRangesTable1, l_SegmentRangesTable2)
  -- Called from 6 places in AskUserToSelect_Segments_ToRebuild() and
  --             3 places in bAskUserToSelect_RebuildOptions()...
  
	return GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1,
                   InvertSegmentRangesTable(l_SegmentRangesTable2))
  
end -- function SegmentRangesMinus(l_SegmentRangesTable1, l_SegmentRangesTable2)
function GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, l_SegmentRangesTable2)
  -- Called from SegmentRangesMinus() and 
  --             2 places in AskUserToSelect_Segments_ToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}

	local l_SegmentsTable1 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable1)
	local l_SegmentsTable2 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable2)
	local l_SegmentsInBothTables = FindCommonSegmentsInBothTables(l_SegmentsTable1,l_SegmentsTable1)
	local l_GetCommonSegmentRangesInBothTables = 
		ConvertSegmentsTableToSegmentRangesTable(l_SegmentsInBothTables)

	return l_GetCommonSegmentRangesInBothTables
  
end -- function GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, l_SegmentRangesTable2)
function FindCommonSegmentsInBothTables(l_SegmentsTable1, l_SegmentsTable2)
  -- Called from GetCommonSegmentRangesInBothTables()...
  
	-- l_SegmentsTable1={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}
	-- l_SegmentsTable2={SegmentIndex} e.g., {4,5,6,7,9,10,11,134}
	-- l_CommonSegmentsTable={SegmentIndex} e.g., {9,10,11,134}

	local l_CommonSegmentsInBothTables={}

	table.sort(l_SegmentsTable1)
	table.sort(l_SegmentsTable2)

	if #l_SegmentsTable2 == 0 then
		return l_CommonSegmentsInBothTables
	end

	local SegmentIndex

	local j = 1
  
	for l_TableIndex = 1, #l_SegmentsTable1 do
    
		SegmentIndex1 = l_SegmentsTable1[l_TableIndex]
    
		while l_SegmentsTable2[j] < SegmentIndex1 do
      
			j = j + 1
			if j > #l_SegmentsTable2 then
				-- shortcut to exit early if we have reached the end of table 2 already...
				return l_CommonSegmentsInBothTables
			end
      
		end
    
		-- Add one row to the l_CommonSegmentsInBothTables...
		if l_SegmentsTable1[l_TableIndex] == l_SegmentsTable2[j] then
      
			l_CommonSegmentsInBothTables[#l_CommonSegmentsInBothTables + 1] = l_SegmentsTable1[l_TableIndex]
      
		end
    
	end

	return l_CommonSegmentsInBothTables

end -- function FindCommonSegmentsInBothTables(l_SegmentsTable1, l_SegmentsTable2)
function InvertSegmentRangesTable(l_SegmentRangesTable, l_MaxSegmentIndex)
  -- Called from SegmentRangesMinus() and 
  --             AskUserToSelect_Segments_ToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_InvertedSegmentRangesTable={StartSegment, EndSegment} e.g., {{4,8},{12,133}}

	-- Returns all segment ranges not in the passed in segment ranges ...
	-- l_MaxSegmentIndex is added for ligand
	local l_InvertedSegmentRangesTable = {}

	if l_MaxSegmentIndex == nil then
		-- l_MaxSegmentIndex = structure.GetCount()
		l_MaxSegmentIndex = g_SegmentCount_WithLigands
	end

	if #l_SegmentRangesTable == 0 then
		return {{1, l_MaxSegmentIndex}} -- Return the entire range of segments.
	end

	if l_SegmentRangesTable[1][1] ~= 1 then
		l_InvertedSegmentRangesTable[1] = {1, l_SegmentRangesTable[1][1] - 1}
	end

	for l_TableIndex = 2, #l_SegmentRangesTable do
    
		l_InvertedSegmentRangesTable[#l_InvertedSegmentRangesTable + 1] =
			{l_SegmentRangesTable[l_TableIndex - 1][2] + 1,
			 l_SegmentRangesTable[l_TableIndex][1] - 1}
     
	end

	if l_SegmentRangesTable[#l_SegmentRangesTable][2] ~= l_MaxSegmentIndex then
    
		l_InvertedSegmentRangesTable[#l_InvertedSegmentRangesTable + 1] =
			{l_SegmentRangesTable[#l_SegmentRangesTable][2] + 1, l_MaxSegmentIndex}
      
	end

	return l_InvertedSegmentRangesTable
  
end -- function InvertSegmentRangesTable(l_SegmentRangesTable, l_MaxSegmentIndex)
function FindSegmentRangesWithSecondaryStructureType(l_SecondaryStructureType)
  -- Called from 4 places in AskUserToSelect_Segments_ToRebuild() and 
  --             1 place  in bAskUserToSelect_RebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindSegmentsWithSecondaryStructureType(l_SecondaryStructureType))
  
end -- function FindSegmentRangesWithSecondaryStructureType(l_SecondaryStructureType)
function FindSegmentsWithSecondaryStructureType(In_SecondaryStructureType)
  -- Called from FindSegmentRangesWithSecondaryStructureType()...
  
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
  
		local l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)  --eg L,E,H,M
    
		if l_GetSecondaryStructureType == In_SecondaryStructureType then
    
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
      
		end
    
	end
  
	return l_SegmentsTable
  
end -- function FindSegmentsWithSecondaryStructureType(In_SecondaryStructureType)
function FindLockedSegmentRanges()
  -- Called from AskUserToSelect_Segments_ToRebuild() and
  --             bAskUserToSelect_RebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindLockedSegments())
  
end -- function FindLockedSegmentRanges()
function FindLockedSegments()
  -- Called from FindLockedSegmentRanges()...
  
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		if structure.IsLocked(l_SegmentIndex) then
      
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
      
		end
    
	end
  
	return l_SegmentsTable
  
end -- function FindLockedSegments()
function FindFrozenSegmentRanges()
  -- Called from AskUserToSelect_Segments_ToRebuild() and
  --             bAskUserToSelect_RebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindFrozenSegments())
  
end -- function FindFrozenSegmentRanges()
function FindFrozenSegments()
  -- Called from FindFrozenSegmentRanges()...

	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		local l_bBackboneIsFrozen = false
		local l_bSideChainIsFrozen = false
		l_bBackboneIsFrozen, l_bSideChainIsFrozen = freeze.IsFrozen(l_SegmentIndex)
    
		if l_bBackboneIsFrozen == true or l_bSideChainIsFrozen == true then
      
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
			print("  Frozen Segment[" .. l_SegmentIndex .. "]")
      
		end
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
  
	return l_SegmentsTable
  
end -- function FindFrozenSegments()
function AskUserForMutateOptions()
  -- Called from bAskUserToSelect_RebuildOptions()...

	local l_Ask = dialog.CreateDialog("Mutate Options")
	
	l_Ask.l1 = dialog.AddLabel("Mutate after rebuild:")
	l_Ask.g_bUserSelected_Mutate_After_Rebuild =
    dialog.AddCheckbox("After rebuild", g_bUserSelected_Mutate_After_Rebuild)
	
	l_Ask.l2 = dialog.AddLabel("Mutate during Stabilize:")
	l_Ask.g_bUserSelected_Mutate_During_Stabilize =
		dialog.AddCheckbox("During Stabilize", g_bUserSelected_Mutate_During_Stabilize)
		
	l_Ask.l3 = dialog.AddLabel("Mutate after Stabilize:")
	l_Ask.g_bUserSelected_Mutate_After_Stabilize =
		dialog.AddCheckbox("After Stabilize", g_bUserSelected_Mutate_After_Stabilize)
		
	l_Ask.l4 = dialog.AddLabel("Mutate before fuse best position:")
	l_Ask.g_bUserSelected_Mutate_Before_FuseBestPosition =
    dialog.AddCheckbox("Before fuse", g_bUserSelected_Mutate_Before_FuseBestPosition)
	
	l_Ask.l5 = dialog.AddLabel("Mutate after fuse best position:")
	l_Ask.g_bUserSelected_Mutate_After_FuseBestPosition =
    dialog.AddCheckbox("After fuse", g_bUserSelected_Mutate_After_FuseBestPosition)

	l_Ask.l6 = dialog.AddLabel("What to rebuild. Second option overrides first. ")
	l_Ask.l7 = dialog.AddLabel("If neither option is checked then rebuild all segments.")
	l_Ask.g_bUserSelected_Mutate_OnlySelected_Segments =
		dialog.AddCheckbox("Only the selected segments", g_bUserSelected_Mutate_OnlySelected_Segments)
	l_Ask.g_bUserSelected_Mutate_SelectedAndNearby_Segments =
		dialog.AddCheckbox("The selected and nearby segments",
      g_bUserSelected_Mutate_SelectedAndNearby_Segments)
	l_Ask.l8 = dialog.AddLabel("Mutate sphere radius, Angstroms, for nearby segments")
	l_Ask.g_UserSelected_Mutate_SphereRadius =
		dialog.AddSlider("  Sphere Radius:", g_UserSelected_Mutate_SphereRadius, 3, 15, 0)
    -- ...default is 8 Angstroms.
	l_Ask.g_UserSelected_Mutate_ClashImportance =
		dialog.AddSlider("  Clash Importance:", g_UserSelected_Mutate_ClashImportance, 0.1, 1, 2)

	l_Ask.OK = dialog.AddButton("OK", 1) l_Ask.Cancel = dialog.AddButton("Cancel", 0)
	if dialog.Show(l_Ask) > 0 then
		g_bUserSelected_Mutate_After_Rebuild = l_Ask.g_bUserSelected_Mutate_After_Rebuild.value
		g_bUserSelected_Mutate_During_Stabilize =
      l_Ask.g_bUserSelected_Mutate_During_Stabilize.value
		g_bUserSelected_Mutate_After_Stabilize =
      l_Ask.g_bUserSelected_Mutate_After_Stabilize.value
		g_bUserSelected_Mutate_Before_FuseBestPosition =
      l_Ask.g_bUserSelected_Mutate_Before_FuseBestPosition.value
		g_bUserSelected_Mutate_After_FuseBestPosition = l_Ask.g_bUserSelected_Mutate_After_FuseBestPosition.value
		g_bUserSelected_Mutate_OnlySelected_Segments = l_Ask.g_bUserSelected_Mutate_OnlySelected_Segments.value
		g_bUserSelected_Mutate_SelectedAndNearby_Segments =
      l_Ask.g_bUserSelected_Mutate_SelectedAndNearby_Segments.value
		if g_bUserSelected_Mutate_SelectedAndNearby_Segments == true then
			-- The g_bUserSelected_Mutate_SelectedAndNearby_Segments option 
      -- overrides the g_bUserSelected_Mutate_OnlySelected_Segments option...
			g_bUserSelected_Mutate_OnlySelected_Segments = false
		end
		g_UserSelected_Mutate_SphereRadius = l_Ask.g_UserSelected_Mutate_SphereRadius.value
		g_UserSelected_Mutate_ClashImportance = l_Ask.g_UserSelected_Mutate_ClashImportance.value
    
	end

end -- AskUserForMutateOptions()
function AskMoreOptions()
  -- called from bAskUserToSelect_RebuildOptions()...

	local l_Ask = dialog.CreateDialog("More Options")

	l_Ask.l_0 = dialog.AddLabel("Perform Extra Stabilize (shake and wiggle more)")
	l_Ask.g_bUserSelected_PerformExtraStabilize =
		dialog.AddCheckbox("Extra", g_bUserSelected_PerformExtraStabilize) -- default is false

	l_Ask.l_1 = dialog.AddLabel("Move on to more consecutive segments per")
	l_Ask.l_2 = dialog.AddLabel("range if current rebuild gains more than:")
	l_Ask.g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan =
		dialog.AddSlider("  Points:",
			g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan, 0, 500, 0)
      -- ...default is 40 or less.

	l_Ask.l_3 = dialog.AddLabel("Skip fusing best position if current rebuild loses")
	l_Ask.l_4 = dialog.AddLabel("more than (Points * # of segments per range / 3):")
	l_Ask.g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan = 
		dialog.AddSlider("  Points:", 
      g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan, -5, 200, 0)

	l_Ask.l_7 = dialog.AddLabel("Only allow rebuilding already rebuilt segments")
	l_Ask.l_9 = dialog.AddLabel("if current rebuild gains more than:")
	l_Ask.g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan =
		dialog.AddSlider("  Points:",
			g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan, 0, 500, 0) 
      -- ...default depends on number of segments.

	l_Ask.l_10 = dialog.AddLabel("Number of times to rebuild each segment range")
	l_Ask.l_11 = dialog.AddLabel("per run cycle:") -- default is 15 (or 10)
	l_Ask.g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle =
		dialog.AddSlider("  Rebuilds:", 
      g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle, 1, 100, 0)

	l_Ask.l_12 = dialog.AddLabel("Starting number of segment ranges to rebuild per")
	l_Ask.l_13 = dialog.AddLabel("run cycle:")
	l_Ask.g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		dialog.AddSlider("  Ranges / cycle:",
			g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle, 1,
      g_SegmentCount_WithoutLigands, 0)

	l_Ask.l_14 = dialog.AddLabel("Additional number of segment ranges to rebuild per")
	l_Ask.l_15 = dialog.AddLabel("run cycle to add after each run cycle completes:")
	l_Ask.g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		dialog.AddSlider("  Add ranges:",
			g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle, 0, 4, 0)

	l_Ask.l_16 = dialog.AddLabel("Shake and Wiggle (with SideChains and Backbone)")
	l_Ask.l_17 = dialog.AddLabel("with selected and nearby segments after each rebuild")
	l_Ask.l_18 = dialog.AddLabel("(with clash importance: 1)")
	l_Ask.g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments =
		dialog.AddCheckbox("Very SLOW!",
			g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments)
		
	l_Ask.l_19 = dialog.AddLabel("Shake and Wiggle with selected segments after")
	l_Ask.l_20 = dialog.AddLabel("each rebuild.")
	l_Ask.g_bUserSelected_ShakeAndWiggle_WithSelected_Segments = 
		dialog.AddCheckbox("Not too slow", g_bUserSelected_ShakeAndWiggle_WithSelected_Segments)

	l_Ask.l_21 = dialog.AddLabel("... with clash importance:")
	l_Ask.g_UserSelected_Shake_ClashImportance = 
    dialog.AddSlider(" CI:", g_UserSelected_Shake_ClashImportance, 0, 1, 2)
	
	l_Ask.l_22 = dialog.AddLabel("Stabilize instead of local shake")
	l_Ask.l_23 = dialog.AddLabel("only:")
	l_Ask.g_bUserSelected_Stabilize =
    dialog.AddCheckbox("Normal", g_bUserSelected_Stabilize)
	l_Ask.g_bUserSelected_FuseBestPosition =
    dialog.AddCheckbox("Fuse best position", g_bUserSelected_FuseBestPosition)
	
	l_Ask.OK = dialog.AddButton("OK", 1)
	dialog.Show(l_Ask)

	g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan =
		l_Ask.g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan.value
    -- ...default is 40 or less.
	g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan =
    l_Ask.g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan.value

	g_bUserSelected_PerformExtraStabilize = l_Ask.g_bUserSelected_PerformExtraStabilize.value
  -- ...default is false.
  
	g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan =
    l_Ask.g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan.value

	g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle =
		l_Ask.g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle.value

	g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		l_Ask.g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle.value
	g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		l_Ask.g_UserSelected_AdditionalNumberOf_SegmentRanges_ToRebuild_PerRunCycle.value
	
	g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments =
		l_Ask.g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments.value
	g_bUserSelected_ShakeAndWiggle_WithSelected_Segments =
    l_Ask.g_bUserSelected_ShakeAndWiggle_WithSelected_Segments.value
	
	g_UserSelected_Shake_ClashImportance = l_Ask.g_UserSelected_Shake_ClashImportance.value
	g_bUserSelected_Stabilize = l_Ask.g_bUserSelected_Stabilize.value
  
	g_bUserSelected_FuseBestPosition = l_Ask.g_bUserSelected_FuseBestPosition.value

end -- AskMoreOptions()
function Display_SelectedOptions()
  -- Called from main()...

	print("\nSelected Options:\n")

	-- Script defaults:
	-- g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
	-- g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4

	--print("  Start Processing With This Many Consecutive Segments: [" ..
	--	g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments .. "]")
	--print("  Stop After Processing With This Many Consecutive Segments: [" ..
	--	g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments .. "]")

	print("  Segments to work on: [" ..
		ConvertSegmentRangesTableToListOfSegmentRanges(g_SegmentRangesToRebuildTable) .. "]")

	--print("  Number of rebuild-one-segment-range attempts per run cycle: [" ..
	--	g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle .. "]")

	if g_UserSelected_WiggleFactor > 1 then
		print("  Wiggle factor: " .. g_UserSelected_WiggleFactor .. "")
	end

	if g_bUserSelected_ConvertAllSegmentsToLoops == true then
		print("  Converting all segments to loops...")
	end

	if g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments == true then
		print("  Shake and Wiggle (with SideChains and Backbone)" ..
           " with selected and nearby segments after each rebuild" ..
          " (with clash importance = 1.0)")
	elseif g_bUserSelected_ShakeAndWiggle_WithSelected_Segments == true then
		print("  Shake and Wiggle selected segments after each rebuild" ..
          " (with clash importance: " .. g_UserSelected_Shake_ClashImportance .. ")")
	end

	if g_bUserSelected_Stabilize == false then
    print("  Skip Stabilize. Instead, perform local shake.")
	end
	if g_bUserSelected_FuseBestPosition == true then
		print("  Fuse best position of each segment range is Enabled.")
	end

	-- print("  Number of full run cycles: " .. g_UserSelected_NumberOfRunCycles .. "")

	if g_UserSelected_NumberOf_SegmentRanges_ToSkip > 0 then
		print("  Skipping the first " .. g_UserSelected_NumberOf_SegmentRanges_ToSkip .. " worst segment" ..
           " ranges. The user usually sets this value after a script crashes or a power outage.")
	end

	if g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments == true then
		print("  We will always allow rebuilding already rebuilt segments")
	else
		print("  We will only allow rebuilding already rebuilt segments" ..
					 " if current rebuild points gained is more than: " ..
             g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan .. "")
	end

end -- Display_SelectedOptions()
function ConvertSegmentRangesTableToListOfSegmentRanges(l_SegmentRangesTable)
  -- Called from Display_SelectedOptions(), 
  --             AskUserToSelect_Segments_ToRebuild() and
  --             bAskUserToSelect_RebuildOptions()...

	if l_SegmentRangesTable == nil then
		return ""
	end
  
	local l_SegmentString = ""

	for l_TableIndex = 1, #l_SegmentRangesTable do
    
		if l_TableIndex ~= 1 then
			l_SegmentString = l_SegmentString .. ", "
		end
    
		l_SegmentString = l_SegmentString ..
			l_SegmentRangesTable[l_TableIndex][1] .. "-" ..
			l_SegmentRangesTable[l_TableIndex][2]
      
	end -- for l_TableIndex = 1, #l_SegmentRangesTable do

	return l_SegmentString
  
end -- function ConvertSegmentRangesTableToListOfSegmentRanges(l_SegmentRangesTable)
function ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(l_SegmentRangesToRebuildTable)
  -- Called from main()...
  
	-- l_SegmentRangesToRebuildTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_bSegmentsToRebuildBooleanTable={bToWorkOn} -- e.g., {true,true,false,true, ...}

	local l_bSegmentsToRebuildBooleanTable = {}

	-- for l_SegmentIndex = 1, structure.GetCount() do
	for l_SegmentIndex = 1, g_SegmentCount_WithLigands do
    
		l_bSegmentsToRebuildBooleanTable[l_SegmentIndex] =
			bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesToRebuildTable)
      
	end

	return l_bSegmentsToRebuildBooleanTable
  
end -- function ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(l_SegmentRangesToRebuildTable)
function bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesTable)
  -- Called from ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}

	local l_StartSegment, l_EndSegment

	for l_TableIndex = 1, #l_SegmentRangesTable do
    
		l_StartSegment = l_SegmentRangesTable[l_TableIndex][1]
		l_EndSegment = l_SegmentRangesTable[l_TableIndex][2]
    
		if l_SegmentIndex >= l_StartSegment and
			 l_SegmentIndex <= l_EndSegment then
         
			return true
      
		elseif l_SegmentIndex < l_StartSegment then
      
			return false
      
		end
    
	end

	return false
  
end -- function bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesTable)
-- ...end of Ask and Display User Options module.
-- Start of Core Rebuild Functions module...
function PrepareToRebuildSegmentRanges(l_How)
  -- Called from 6 places in main()...
  
	if l_How == "drw" then

		-- drw means Deep Rebuild with Worst scoring segment ranges
    
		-- This method starts the rebuild process with a small number of consecutive
		-- segments, then progressively processes larger numbers of consecutive segments
    
		-- Script defaults:
		-- g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
		-- g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4
    
		local l_Step = 1
		if g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments >
			 g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments then
			l_Step = -1 -- process backwards if needed
		end
    
		local g_MaxNumberOfSegmentRangesToProcess = g_UserSelected_NumberOfRunCycles + 
			g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle
      
		-- "for" loops in lua are interesting in that the loop counter variable,
		-- l_RequiredNumberOfConsecutiveSegments in this case, is always treated
		-- as a local variable. Changes to the loop counter value are only seen 
		-- within the loop, and nowhere else, not in any called functions, nor after
		-- the loop completes, nada. Not even if you attempt to declare the variable
		-- locally before starting the "for" loop (in this case loop counter variable
		-- is treated as a completely different local variable, only visable inside the loop)
		-- This means you cannot use a global variable as the loop counter variable,
		-- because as the loop counter increments, no other functions will be able
		-- to see the change...
		for l_RequiredNumberOfConsecutiveSegments =
			g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments,
			g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments,
			l_Step do
        
			-- ...and that's why we have to do this...
			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments
			
			Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()
			
			--print("\nRun " .. g_RunCycle .. " of " .. g_UserSelected_NumberOfRunCycles .. "," ..
			--  " " .. g_RequiredNumberOfConsecutiveSegments .. " of " .. 
			--  g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments ..
      --  " consecutive segments," ..
			--	" Current score: " .. PrettyNumber(l_Current_PoseTotalScore) .. "")
      
			-- Here's what you are looking for...
			-- Here's what you are looking for...
			RebuildMany_SegmentRanges()
			-- Here's what you are looking for...
			-- Here's what you are looking for...
      
		end
    
	elseif l_How == "fj" then
    
		Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()
    
		-- l_WorstSegmentRangesTable={StartSegment=1, EndSegment=2}
		-- note the different format from g_WorstSegmentsTable
		l_WorstSegmentRangesTable = {}
    
		local l_CurrentSegmentRange = {}
		local l_StartSegment
		local l_EndSegment
    
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		for l_TableIndex = 1, #g_SegmentRangesToRebuildTable do
      
			l_CurrentSegmentRange = g_SegmentRangesToRebuildTable[l_TableIndex]
      
			l_StartSegment = l_CurrentSegmentRange[srtrt_StartSegment] --start segment of worst area
			l_EndSegment = l_CurrentSegmentRange[srtrt_EndSegment] --end segment of worst area
      
			for l_SegmentIndex = l_StartSegment, l_EndSegment do
        
				for l_WorstSegmentIndex = 1, g_RequiredNumberOfConsecutiveSegments do
          
					if l_SegmentIndex + l_WorstSegmentIndex <= l_EndSegment then
            
						-- Finally, add one row to l_WorstSegmentRangesTable,
						-- which will eventually be copied to the g_SegmentRangesToRebuildTable below...
            
            -- l_WorstSegmentRangesTable={StartSegment=1, EndSegment=2}
						l_WorstSegmentRangesTable[#l_WorstSegmentRangesTable + 1] =
							{l_SegmentIndex, l_SegmentIndex + l_WorstSegmentIndex}
					end
				end
			end
      
		end
		g_SegmentRangesToRebuildTable = l_WorstSegmentRangesTable
		RebuildMany_SegmentRanges()
    
	elseif l_How == "all" then
    
		g_SegmentRangesToRebuildTable = {}

		-- Script defaults:
			g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
			g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4
    
		for l_RequiredNumberOfConsecutiveSegments =
			g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments,
			g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments do
        
			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments
      
			for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
        
				local l_StartSegment = l_SegmentIndex
				local l_EndSegment = g_RequiredNumberOfConsecutiveSegments + l_SegmentIndex - 1
        
				if l_EndSegment <= g_SegmentCount_WithoutLigands then
          
					-- g_SegmentRangesToRebuildTable = {StartSegment, EndSegment}
					g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = 
            {l_StartSegment, l_EndSegment}
				end
        
			end
		end
		RebuildMany_SegmentRanges()
    
	elseif l_How == "simple" then
    
		Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()
		RebuildMany_SegmentRanges()
    
	elseif l_How=="segments" then
    
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		g_SegmentRangesToRebuildTable = {}
		Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
		RebuildMany_SegmentRanges()
    
	end
  
end -- PrepareToRebuildSegmentRanges(l_How)
function Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges(l_RecursionLevel)
  -- Called from 3 places in PrepareToRebuildSegmentRanges() and 
  --             1 place  recursively below...

	if l_RecursionLevel == nil then
		l_RecursionLevel = 1
	end

  --print("\nSearching for the " .. g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle .. 
  --       " worst scoring segment ranges (each range containing " ..
  --        g_RequiredNumberOfConsecutiveSegments .. " consecutive segments)...")

  CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
  
	-- l_WorstScoringSegmentRangesTable={Segment Score, StartSegment}
	l_WorstScoringSegmentRangesTable = {}

	-- g_SegmentScoresTable = {SegmentScore}
	Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()

	local l_SkipTheseSegments = ""
	local l_NumberOfSegmentsSkipping = 0
	local l_StartSegment, l_EndSegment

	local l_FirstPossibleSegmentThatCanStartARangeOfSegments = 1

	local l_LastPossibleSegmentThatCanStartARangeOfSegments =
		g_SegmentCount_WithoutLigands - g_RequiredNumberOfConsecutiveSegments + 1
	-- An example:
	-- g_SegmentCount_WithoutLigands = 5 -- this is the last non-ligand segment
	-- g_RequiredNumberOfConsecutiveSegments = 3  -- we must have this many segments
                                                -- in our segment range
	-- l_LastPossibleSegmentThatCanStartARangeOfSegments = 5 - 3 + 1 = 3
	-- So our last possible segment range would be {2, 3, 4}

	local l_CurrentWorseScoringSegment
	local l_bSegmentIsAllowedToBeRebuilt
	local l_bSegmentRangeIsAllowedToBeRebuilt
	local l_bSegmentRangeToWorkOn
	local l_SegmentScore
  
	for l_CurrentWorseScoringSegment =
		l_FirstPossibleSegmentThatCanStartARangeOfSegments,
		l_LastPossibleSegmentThatCanStartARangeOfSegments do
      
    l_bSegmentIsAllowedToBeRebuilt = bSegmentIsAllowedToBeRebuilt(l_CurrentWorseScoringSegment)
    if l_bSegmentIsAllowedToBeRebuilt == true then
      
      l_StartSegment = l_CurrentWorseScoringSegment
      l_EndSegment = l_CurrentWorseScoringSegment + g_RequiredNumberOfConsecutiveSegments - 1
      -- An Example:
      -- l_StartSegment = 1
      -- l_EndSegment = 1 + 3 - 1 = 3
      -- SegmentRange = {1, 2, 3}
      
      l_bSegmentRangeIsAllowedToBeRebuilt = bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment)
      
      if l_bSegmentRangeIsAllowedToBeRebuilt == true then
        
        l_SegmentScore = Get_ScorePart_Score(l_StartSegment, l_EndSegment)
        
        -- Add a row to the l_WorstScoringSegmentRangesTable which will be used
        -- below to populate the g_SegmentRangesToRebuildTable...
        -- Note: The only reason we add the l_SegmentScore as the first field
        --       in the l_WorstScoringSegmentRangesTable, is so we can sort the table from
        --       lowest to highest Segment Scores.
        -- Note: Although we are only placing the l_StartSegment in this table, and
        --       not the l_EndSegment, this is still a segment *range* table. We just
        --       don't need the l_EndSegment in this table, because we will calculate
        --       it later as l_StartSegment + g_RequiredNumberOfConsecutiveSegments - 1
        --       Also, we don't want the l_EndSegment is this table because it would
        --       break the SortBySegmentScore() function used below...
        l_WorstScoringSegmentRangesTable[#l_WorstScoringSegmentRangesTable + 1] =
          {l_SegmentScore, l_StartSegment}
          
      end
      
		else -- l_bSegmentIsAllowedToBeRebuilt ~= true
      
      l_NumberOfSegmentsSkipping = l_NumberOfSegmentsSkipping + 1
      
      if l_SkipTheseSegments ~= "" then
        l_SkipTheseSegments = l_SkipTheseSegments .. ", "
      end
      l_SkipTheseSegments = l_SkipTheseSegments .. l_CurrentWorseScoringSegment
      
		end -- if l_bSegmentIsAllowedToBeRebuilt == true then
    
	end
  
	if l_NumberOfSegmentsSkipping > 0 then
    
		 --too much noise...print("\n  Skipping the following " .. l_NumberOfSegmentsSkipping ..
     --      " already rebuilt (or unselected) segments: [" .. l_SkipTheseSegments .. "]")
	end

	-- Note: The only reason we add the l_SegmentScore as the first field
	--       in the l_WorstScoringSegmentRangesTable, is so we can sort the table from
	--       lowest to highest Segment Score.
	-- Please Remember!! This is one row per *segment*, not one row per segment range!
	--        So, if there are 135 non-ligand segments, this table
	--        will have 135 rows, every time this function is called!
	l_WorstScoringSegmentRangesTable =
		SortBySegmentScore(l_WorstScoringSegmentRangesTable, -- <<<--- This is what you are looking for!!!
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle)
	-- Example table entries {{50.111, 1}, {20.32, 2}, {0.234, 3}, {30.5, 6}, {10.3, 7}},
	-- would be sorted as {{0.234, 3}, {10.3, 7}, {20.32, 2}, {30.5, 6}, {50.111, 1}}

	local l_NumberOfSegmentRangesToProcessThisRunCycle = #l_WorstScoringSegmentRangesTable

	if l_NumberOfSegmentRangesToProcessThisRunCycle > 
     g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle then
		l_NumberOfSegmentRangesToProcessThisRunCycle =
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle
	end

	 -- l_WorstScoringSegmentRangesTable={SegmentScore=1, StartSegment=2}
	local wst_SegmentScore = 1
	local wst_StartSegment = 2
	local l_WorstSegmentTableRow = {}

	-- Finally populate the g_SegmentRangesToRebuildTable...

	g_SegmentRangesToRebuildTable = {}

	-- Note: In the for loop below, we increment l_WorstScoringSegmentsTableIndex by 1,
	-- instead of by g_RequiredNumberOfConsecutiveSegments. That's because we want a rolling
	-- list of segment ranges. This gives us lots of possible segment combinations to
	-- work on...
	-- Example:
	--   Segment list = 1,2,3,4,5,6
	--   We want 3 consecutive segments per segment range
	--   Resulting segment ranges: {1,2,3},{2,3,4},{3,4,5},{4,5,6}
	for l_WorstScoringSegmentsTableIndex = 1, l_NumberOfSegmentRangesToProcessThisRunCycle do
    
		l_WorstSegmentTableRow = l_WorstScoringSegmentRangesTable[l_WorstScoringSegmentsTableIndex]
    -- Example table row entries {0.234, 3}, where the first field is the
    -- SegmentScore and the second field is the SegmentIndex.
    
		l_StartSegment = l_WorstSegmentTableRow[wst_StartSegment] -- remember, this is the second field
    
		l_EndSegment = l_StartSegment + g_RequiredNumberOfConsecutiveSegments - 1
    
		-- Finally, add a row to the g_SegmentRangesToRebuildTable...
    
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
    
	end

	if l_RecursionLevel == 1 and #l_WorstScoringSegmentRangesTable == 0 then
    
    -- The next two lines get called from two places:
    -- 1) Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges() -- Here, in this fuction.
    -- 2) CheckIfAlreadyRebuiltSegmentsMustBeIncluded() -- Bottom of that function.
    -- I don't think these two lines are ever called from here because of the call to 
    -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded() at the beginning of this function. I mean,
    -- that's the whole point of CheckIfAlreadyRebuiltSegmentsMustBeIncluded(), right?
    print("\nMessage from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()..." ..
          "\nNot enough consecutive not-already-rebuilt segments available to create a segment range;" ..
          "\ntherefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
         
		ResetSegmentsAlreadyRebuiltTable()
    
		-- Recursion...
		l_RecursionLevel = l_RecursionLevel + 1
		Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges(l_RecursionLevel)
    
	end

end -- Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges(l_RecursionLevel)
function CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()...

  -- If we cannot find enough consecutive not-already-rebuilt segments available to meet
	-- the minimum, we will set all the entries in the g_SegmentsAlreadyRebuiltTable to false.
  -- This will allow all already-rebuilt segments to be treated as not-already-rebuilt segments.
	-- Then, when we are forming segment ranges to process, we will be able to meet the
	-- minimun number of consecutive segments per segment range required by the user.

	local l_ConsecutiveSegmentsCounter = 0
  local l_SegmentRangeCounter = 0
	for l_TableIndex = 1, g_SegmentCount_WithoutLigands do
    
    if bSegmentIsAllowedToBeRebuilt(l_TableIndex) == false then
			-- Since this segment is not allowed to be rebuilt, it cannot be
      -- counted as a consecutive segment. Start the counter over again...
			l_ConsecutiveSegmentsCounter = 0
      
		else
			l_ConsecutiveSegmentsCounter = l_ConsecutiveSegmentsCounter + 1
		end
    
		if l_ConsecutiveSegmentsCounter >= g_RequiredNumberOfConsecutiveSegments then
      
			-- Yeah, another segment range with enough consecutive Segments to meet 
      -- the minimun required segments per segment range, despite having a bunch
      -- of already-rebuilt (or ineligable because they are frozen or locked) 
      -- segments in our way...
      -- Let's add this to our segment range counter and continue looking for more...
      l_SegmentRangeCounter = l_SegmentRangeCounter + 1
      
      if l_SegmentRangeCounter >= g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle then
        
			-- Yeah, we have enough segments ranges to get started rebuilding. Let's return and get to it...
        return
        
      end
      
		end -- if l_ConsecutiveSegmentsCounter >= g_RequiredNumberOfConsecutiveSegments then
    
	end -- for l_TableIndex = 1, g_SegmentCount_WithoutLigands do

	-- Since there are not enough non-done segments in a row to meet the minimum, 
	-- let's set all the entries in the g_SegmentsAlreadyRebuiltTable to false.
	-- This should give us plenty of segments to work with...
  -- Too much noise in the log file...
	--print("\n  Not enough consecutive not-already-rebuilt segments available to create a segment range;" ..
  --     "\n  therefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
       
  ResetSegmentsAlreadyRebuiltTable()
       
end -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)
  -- Called from bSegmentRangeIsAllowedToBeRebuilt()...

  -- Normally all worst scoring segment ranges are selected to be rebuilt.
  -- They can only be removed on the "Select Segments to Rebuild" page...
  -- g_bSegmentsToRebuildBooleanTable is populated in main()
  if g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == false then
			return false -- note how this option overrides the below options.
	end

  if g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments == true then
		return true
	end
  
  -- g_PointsGained_Current_RebuildSegmentRange is set in RebuildMany_SegmentRanges()...
  if g_PointsGained_Current_RebuildSegmentRange > 
    g_UserSelected_OnlyAllowRebuildingAlreadyRebuilt_Segments_IfCurrentRebuild_GainsMoreThan then
    return true
  end
  
  if g_SegmentsAlreadyRebuiltTable[l_SegmentIndex] == true then
    return false
  end
  
  -- This segment has not already been rebuilt and
  -- the user did not unselect the segment range...
  return true
  
end -- function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)
function SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
  -- Called from RebuildMany_SegmentRanges()...

  -- Loop through the given segment range and set the g_SegmentsAlreadyRebuiltTable
  -- values to true for each segments in the given range...
  for l_TableIndex = l_StartSegment, l_EndSegment do
    
    -- Update one row in the g_SegmentsAlreadyRebuiltTable...
    g_SegmentsAlreadyRebuiltTable[l_TableIndex] = true
  end

end -- SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
function Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()
  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()...

	if GetPoseTotalScore() == g_LastSegmentScore then
    -- If PoseTotalScore has not changed since the last time we set Segment Scores,
    -- then we assume the segment scores also have not changed. So we leave them alone.
    -- Is this a fallacy?
		return 
	end

	local l_SegmentScore, l_Reference_ScorePart, l_Density_ScorePart

	-- Fortunately this is the only function that sets and checks g_LastSegmentScore...
	g_LastSegmentScore = GetPoseTotalScore()

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		if g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == true then
      
			if #g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table == 0 then
				-- If the user did not select specific ScoreParts to include when calculating
        -- worst scoring segments, the default calculation for segment score is:
				-- l_SegmentScore = SegmentEnergyScore - Reference_ScorePart + weighted Density_ScorePart
				l_SegmentScore = current.GetSegmentEnergyScore(l_SegmentIndex)
					-- If this segment is not a Mutable, then
					-- subtract back out (of the SegmentScore) the Reference_ScorePart...
				local l_bThisSegmentIsMutable = structure.IsMutable(l_SegmentIndex)
				if l_bThisSegmentIsMutable == false then
					l_Reference_ScorePart = current.GetSegmentEnergySubscore(l_SegmentIndex, 'Reference')
					l_SegmentScore = l_SegmentScore - l_Reference_ScorePart
				end
				-- If a Density component exists, add extra points to the SegmentScore...
				if math.abs(g_DensityWeight) > 0 then --the Density component has extra weighted points
					l_Density_ScorePart = current.GetSegmentEnergySubscore(l_SegmentIndex, 'Density')
					l_SegmentScore = l_SegmentScore + g_DensityWeight * l_Density_ScorePart
				end
			else
				l_SegmentScore = 
          Calculate_SegmentRange_Score(
            g_UserSelected_ScoreParts_ToIncludeWhenCalculatingWorseScoring_Segments_Table,
            l_SegmentIndex, l_SegmentIndex)
			end
      
      -- The first time this function is called we add one row per segment of the protein
      -- to the g_SegmentScoresTable. On subsequent calls we simply update each row, because
      -- the number of segments never changes. No need to delete the table and recreate it 
      -- each time this function is called...
			-- This is the only place where this table is populated and updated...
      -- Note: l_SegmentIndex is always sequential from 1 to g_SegmentCount_WithoutLigands...
			g_SegmentScoresTable[l_SegmentIndex] = l_SegmentScore
      
    end -- If g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == true then
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do

end -- Populate_g_SegmentScoresTable_BasedOnUserSelected_ScoreParts()
function bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment)
  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()
  
  -- First, let's make sure each segment in the range is allowed to be rebuilt...
  -- If any one segment in the this segment range is not allowed to be rebuilt, 
  -- then this entire segment range is not allowed to be rebuilt...
  for l_SegmentIndex = l_StartSegment, l_EndSegment do
    if bSegmentIsAllowedToBeRebuilt(l_SegmentIndex) == false then
      return false -- it only takes one false to fail.
    end
  end
 
  return true
  
end -- function bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment)
function Get_ScorePart_Score(l_StartSegment, l_EndSegment, l_Attr)
  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges() and
  --             Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()...
  
  -- I think this function could/should be merged into the more frequently used
  -- Calculate_SegmentRange_Score() function!

	local l_PartScore = 0

	if l_Attr == 'total' then
    
		l_PartScore = GetPoseTotalScore()
    
	elseif l_Attr == nil then
		--is only called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges
    
		for l_SegmentIndex = l_StartSegment, l_EndSegment do
      
			-- g_SegmentScoresTable = {SegmentScore}
			-- This is the only place this table is read...
      -- How is this any different than calling GetPoseTotalScore()?
      -- Oh, I see, this is only for a range of segments...
      -- Might be interesting to compare the value of GetPoseTotalScore() to
      -- using this "for" loop to sum up all of the segments in the protein 
      -- (with ligand?) to see if the two values match.
      -- Also, how is this any differnt than the below 'loctotal' score?
			l_PartScore = l_PartScore + g_SegmentScoresTable[l_SegmentIndex]
		end
    
  elseif l_Attr == 'loctotal' then --total segment scores
    
		l_PartScore = Calculate_SegmentRange_Score(nil, l_StartSegment, l_EndSegment)
    
  elseif l_Attr == 'ligand' then --ligand score
    
		for l_SegmentIndex = g_SegmentCount_WithoutLigands + 1, g_SegmentCount_WithLigands do
			l_PartScore = l_PartScore + current.GetSegmentEnergyScore(l_SegmentIndex)
		end
    
	else
    -- Geez, why didn't you just call Calculate_SegmentRange_Score() directly?
    -- Also, why is l_Attr the last param in this function, but it's the first in
    -- param in Calculate_SegmentRange_Score???
		l_PartScore = Calculate_SegmentRange_Score(l_Attr, l_StartSegment, l_EndSegment)
    
	end
	return l_PartScore
end
function SortBySegmentScore(l_Table, l_NumberOfItems)

  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()...
	-- Backward bubble sorting, lowest on top, only needed l_NumberOfItems
	for x = 1, l_NumberOfItems do
		for y = x + 1, #l_Table do
			if l_Table[x][1] > l_Table[y][1] then
				l_Table[x], l_Table[y] = l_Table[y], l_Table[x]
			end
		end
	end
  
	return l_Table
  
end -- function SortBySegmentScore(l_Table, l_NumberOfItems)
function ResetSegmentsAlreadyRebuiltTable()
  -- Called from Init_g_SegmentRangesTable_WithWorstScoring_SegmentRanges()...

	for l_TableIndex = 1, g_SegmentCount_WithoutLigands do
		g_SegmentsAlreadyRebuiltTable[l_TableIndex] = false
	end

end -- function ResetSegmentsAlreadyRebuiltTable()
function RebuildMany_SegmentRanges()
  -- Called from 5 places in PrepareToRebuildSegmentRanges()...
  
 	local l_StartSegment = 0
	local l_EndSegment = 0

-- g_RunCycle=0 means skip first X number of worst segment ranges. 
-- Selected by the user after a script crash or power outage.
  if g_RunCycle == 0 then    
    for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do      
   		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
      l_StartSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_StartSegment]
      l_EndSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_EndSegment]      
      SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
    end    
    return    
  end 

	Display_SegmentRanges()

	local l_Current_PoseTotalScore = 0
	local l_DeepRebuildGain = 0
	local l_Score_Before_SeveralChangesToSegmentRange = 0
	local l_DisplayGainFromThis = "" -- to report where gains came from
	local l_CurrentHighScore = 0
  
	if g_bUserSelected_ConvertAllSegmentsToLoops == true then
		ConvertAllSegmentsToLoops()  -- why?
	end

	save.Quicksave(3) -- Save
	recentbest.Save() -- Save the current pose as the recentbest pose.  

	-- This is the real meat of this script...
	-- After laboriously determining which segment ranges to work on, 
  -- we finally get to rebuild, shake and wiggle them...

	-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
	for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do
    
		g_SegmentRangeIndex = l_SegmentRangeIndex
    
		l_Score_Before_SeveralChangesToSegmentRange = g_Score_ScriptBest
    
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		l_StartSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_StartSegment]
		l_EndSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_EndSegment]
    
		l_DisplayGainFromThis = "" -- to report where gains came from
		l_CurrentHighScore = -99999999
		
		g_FirstRebuildSegment = l_StartSegment
		g_LastRebuildSegment = l_EndSegment
		
		RememberSolutionWithDisulfideBondsIntact()
    
		if g_bSketchBookPuzzle == true then
			g_bFoundAHighGain = false
		end
   
    local l_Points_Before_RebuildOneSegmentRangeManyTimes = 0
    local l_Points_After_RebuildOneSegmentRangeManyTimes = 0
    
    l_Points_Before_RebuildOneSegmentRangeManyTimes = g_Score_ScriptBest
    
    -- Here's what you are looking for!!!
    -- Here's what you are looking for!!!
    RebuildOneSegmentRangeManyTimes(l_StartSegment, l_EndSegment)
    -- Here's what you are looking for!!!
    -- Here's what you are looking for!!!
    
    l_Points_After_RebuildOneSegmentRangeManyTimes = GetPoseTotalScore()

    if l_Points_After_RebuildOneSegmentRangeManyTimes > 
       l_Points_Before_RebuildOneSegmentRangeManyTimes then
         
      if g_bSketchBookPuzzle == false then
        
        -- We just performed several rebuild attempts on one segment range.
        -- Each of those rebuilt solutions was saved to foldit's undo history.
        -- We now need to restore the best one of those recently saved solutions
        -- as the current solution...
        local l_Score_Before_RecentBestRestore = 0
        local l_Score_After_RecentBestRestore = 0
        
        local l_GetRecentBestScore = 0
        l_GetRecentBestScore = GetRecentBestScore() -- <<<--- This is semi important!
        
        if l_GetRecentBestScore > g_Score_ScriptBest then
          
          l_Score_Before_RecentBestRestore = g_Score_ScriptBest
          
          -- Save the current solution just in case we break any disufide
          -- bonds while restoring the recentbest solution...
          RememberSolutionWithDisulfideBondsIntact()
          
          -- Restore the recentbest solution, from foldit's undo history...
          recentbest.Restore() -- <<<--- This is important!
          
          -- Make sure the restored solution didn't break any disulfide bonds.
          -- If it did, then undo the restore...
          CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
          
          l_Score_After_RecentBestRestore = GetPoseTotalScore()
          -- Get the updated Pose Total Score from the restored solution...
          -- Or, if a disulfide bond was broken by the restore, then we get
          -- the score of the solution as it was just before the restore.
          
          if l_Score_After_RecentBestRestore > l_Score_Before_RecentBestRestore then
            
            SaveBest() -- <-- Updates g_Score_ScriptBest
            
            print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
              " after Restore Recent Best" ..
              " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
            
            -- Note: This is only one of the two places where we call
            --       Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields.
            --       The other call to
            --       Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields
            --       is in RebuildOneSegmentRangeManyTimes(), about 200 lines up from here...
            Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment,
              l_EndSegment, 0)
            
          end -- if l_Score_After_RecentBestRestore > l_Score_Before_RecentBestRestore then
        end -- if l_GetRecentBestScore > l_Current_PoseTotalScore then 
      end -- if g_bSketchBookPuzzle == false then
      
      -- We just rebuilt one segment range many times. Now we are going to 
      -- look at ScorePart score immprovements...
      Update_g_ScorePart_Scores_Table_SetOfScorePartsWithMatchingPoseTotalScore_And_FirstInASet_Fields()
      
      --never! print(" ") -- add blank line
      
      -- Let's see if we can gain more points by 
      -- Shaking and Wiggling nearby segments...
      local l_SphereRadius = 12
      SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
      
      -- For each one of the above segment range rebuild attempts that successfully 
      -- gained points, we saved and associated the protein's pose (stucture) and 
      -- PoseTotalScore with the ScoreParts that also improved during the same rebuild. 
      -- Now, we will step through each one of improved ScoreParts poses for this
      -- segment range and see if regional shaking and wiggling will futher improve our
      -- score...
      -- The ScorePart_Number is not only just a number associated with a ScorePart_Name,
      -- it's also the foldit Undo history slot number where the protein's best-scoring- 
      -- ScorePart pose was stored.
      
      local l_Score_Before_Stabilize = 0
      local l_Score_After_Stabilize = 0      
      local l_Score_Before_Regional_ShakeAndWiggle = 0
      local l_Score_After_Regional_ShakeAndWiggle = 0
      local l_CurrentHighestScoring_ScorePart_Number = 3 
      -- ...set to 3 just in case it does not get set below, because, because, whatever.

      --g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
      --                          SetOfScorePartsWithMatchingPoseTotalScore=4,
      --                          bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
      for l_ScorePart_Scores_TableIndex = 1, #g_ScorePart_Scores_Table do
        
        if g_ScorePart_Scores_Table[l_ScorePart_Scores_TableIndex]
          [spst_bFirstInASetOfScorePartsWithMatchingPoseTotalScore] == true then
          
          local l_ScorePart_Number =
            g_ScorePart_Scores_Table[l_ScorePart_Scores_TableIndex][spst_ScorePart_Number]
          local l_SetOfScorePartsWithMatchingPoseTotalScore = 
            g_ScorePart_Scores_Table[l_ScorePart_Scores_TableIndex]
                                    [spst_SetOfScorePartsWithMatchingPoseTotalScore]
          if string.len(l_SetOfScorePartsWithMatchingPoseTotalScore) <= 2 then
            l_SetOfScorePartsWithMatchingPoseTotalScore = ""
          else
            l_SetOfScorePartsWithMatchingPoseTotalScore = " " .. 
              l_SetOfScorePartsWithMatchingPoseTotalScore 
          end
          
          local l_ScorePartText = ", ScorePart " ..
                g_ScorePartsTable[l_ScorePart_Number - 3][spt_LongName] ..
                l_SetOfScorePartsWithMatchingPoseTotalScore
          
          -- Reload the saved protein pose (protein shape)...
          save.Quickload(l_ScorePart_Number) -- ScorePart_Number is being used as a Slot number here.
          
          RememberSolutionWithDisulfideBondsIntact()
          
          if g_bUserSelected_Stabilize == true then
            
            l_Score_Before_Stabilize = g_Score_ScriptBest
            
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!
            StabilizeSegmentRange(l_StartSegment, l_EndSegment)
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!
            
            CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
            
            l_Score_After_Stabilize = GetPoseTotalScore()
            
            if l_Score_After_Stabilize > l_Score_Before_Stabilize then
              
              l_CurrentHighestScoring_ScorePart_Number = l_ScorePart_Number
              
              if g_bUserSelected_PerformExtraStabilize == true then -- default is false
                l_FunctionName = "Extra Stabilize"
              else
                l_FunctionName = "Stabilize"
              end
              
              SaveBest() -- <-- Updates g_Score_ScriptBest
              
              -- g_ScorePartsTable{ScorePart_Number=1, ScorePart_Name=2, bScorePart_IsActive=3, LongName=4}
              print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
                " after " .. l_FunctionName .. " ScorePart " ..
                g_ScorePartsTable[l_ScorePart_Number - 3][spt_LongName] ..
                l_SetOfScorePartsWithMatchingPoseTotalScore ..
                " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
              -- SetOfScorePartsWithMatchingPoseTotalScore examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
            
            end -- if l_Score_After_Stabilize > l_Score_Before_Stabilize then
            
          else -- g_bUserSelected_Stabilize == false
            
            -- Perform local ShakeAndWiggle w/SideChains instead...
            
            local l_Iterations = 1
            local l_bShake_And_Wiggle_OnlySelectedSegments = true
            
            SetClashImportance(1)
            
            l_Score_Before_Regional_ShakeAndWiggle = g_Score_ScriptBest
            
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!
            ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
            ShakeAndOrWiggle("WiggleSideChains", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!
            
            CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
            l_Score_After_Regional_ShakeAndWiggle = GetPoseTotalScore()
            
            if l_Score_After_Regional_ShakeAndWiggle > l_Score_Before_Regional_ShakeAndWiggle then
              
              l_CurrentHighestScoring_ScorePart_Number = l_ScorePart_Number
                
              SaveBest() -- <-- Updates g_Score_ScriptBest
              
              -- g_ScorePartsTable{ScorePart_Number=1, ScorePart_Name=2, bScorePart_IsActive=3, LongName=4}
              print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
                " after Regional ShakeAndWiggle w/Sidechains ScorePart " ..
                g_ScorePartsTable[l_ScorePart_Number - 3][spt_LongName] ..
                l_SetOfScorePartsWithMatchingPoseTotalScore ..
                " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
              -- SetOfScorePartsWithMatchingPoseTotalScore examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
            
            end -- if l_Score_After_Regional_ShakeAndWiggle > l_Score_Before_Regional_ShakeAndWiggle then
            
          end -- if g_bUserSelected_Stabilize == true then          
          
          if g_bUserSelected_Mutate_After_Stabilize == true then
            
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!
            MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "", l_ScorePartText)
            -- Here's what you are looking for!!!
            -- Here's what you are looking for!!!

          end -- if g_bUserSelected_Mutate_After_Stabilize == true then
          
          save.Quicksave(l_ScorePart_Number) -- Save          
            
        end -- if g_ScorePart_Scores_Table[l_ScorePart_Scores_TableIndex][spst_bFirstInASetOfScorePartsW...
        
      end -- for l_ScorePart_Scores_TableIndex = 1, #g_ScorePart_Scores_Table do
      
      -- Load the best ScorePart pose...
      save.Quickload(l_CurrentHighestScoring_ScorePart_Number)
      
      local l_Score_After_SeveralChangesToSegmentRange = 0
      l_Score_After_SeveralChangesToSegmentRange = GetPoseTotalScore()
      
      local l_PotentialPointLoss = l_Score_Before_SeveralChangesToSegmentRange - 
                                   l_Score_After_SeveralChangesToSegmentRange
                                    
      local l_MaxLossAllowed = g_UserSelected_SkipFusingBestPosition_IfCurrentRebuild_LosesMoreThan * 
                              (l_EndSegment - l_StartSegment + 1) / 3
                              
      if g_bUserSelected_FuseBestPosition == true and 
         l_PotentialPointLoss < l_MaxLossAllowed then
        
        -- This checks for g_bUserSelected_Mutate_After_Stabilize == false because
        -- if it were true, then we would have already performed the mutate above, after the
        -- Stabilize. duh
        if g_bUserSelected_Mutate_Before_FuseBestPosition == true and
           g_bUserSelected_Mutate_After_Stabilize == false then
             
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
            MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "", "")
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          
        end -- if g_bUserSelected_Mutate_Before_FuseBestPosition == true and g_bUserSelected_Mutate_Af...
        
        save.Quicksave(4) -- Save        
        
        local l_Score_Before_FuseBestPosition = 0
        local l_Score_After_FuseBestPosition = 0
        
        l_Score_Before_FuseBestPosition = g_Score_ScriptBest

        if g_bUserSelected_KeepDisulfideBonds_Intact == true then
          
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          -- note: using the global value for 4th parameter here...
          FuseBestPosition(4, RememberSolutionWithDisulfideBondsIntact,
            CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact,
            g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments)
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          
        else
          
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          FuseBestPosition(4, nil, nil, g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments)
          -- Here's what you are looking for!!!          
          -- Here's what you are looking for!!!          
        
        end
        
        l_Score_After_FuseBestPosition = GetPoseTotalScore()
        
        if l_Score_After_FuseBestPosition > l_Score_Before_FuseBestPosition then 
          
          SaveBest() -- <-- Updates g_Score_ScriptBest
          
          print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
            " after FuseBestPosition" ..
            " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
        
        end       
        
        if g_bUserSelected_Mutate_After_FuseBestPosition == true then
          
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "", "")
          -- Here's what you are looking for!!!
          -- Here's what you are looking for!!!
          
        end
        
      end -- if g_bUserSelected_FuseBestPosition == true and 
      
      save.Quickload(3) -- Load (Best pose is always stored in slot 3)
      
    else  -- if l_Points_After_RebuildOneSegmentRangeManyTimes > l_Points_Before_RebuildOneSegmentRange...
      
      -- We did not find an improvement, so let's restore the last known good position...
      save.Quickload(3) -- Load (Best pose is always stored in slot 3)
      
    end -- if l_Points_After_RebuildOneSegmentRangeManyTimes > l_Points_Before_RebuildOneSegmentRangeMan...
    
    local l_bBondsBroke = bOneOrMoreDisulfideBondsHaveBroken()
    
		if g_bUserSelected_KeepDisulfideBonds_Intact == true and l_bBondsBroke == true then
        
				print("\nOne or more disulfide bonds have broken. This should never happen." ..
              "\nPlease report this to someone (who? Foldit? or the maker of this script?)." ..
              "\nDiscarding score gains and restoring last known vaild protein pose.\n")
				CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
        
        -- I don't like this call to SaveBest() here. Perhaps move it into 
        -- CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact() if it makes 
        -- sense; otherwise, just remove it from here...
        SaveBest() -- <-- Updates g_Score_ScriptBest
      
		end
    
		SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment) -- <<-- This is important.
    
    -- I think this should be the end of this function!
    
    
    -- I really don't like this next check...
    -- Does this check really improve the build process? Or, does it simply skip a bunch of
    -- really good rebuild prospects of segment ranges with fewer consecutive segments...
    -- We need indisputable comparison data to prove this is a good idea...
    -- Comparison data should include many puzzle types, with score and time elapsed comparisons.
    local l_Score_After_SeveralChangesToSegmentRange = GetPoseTotalScore()
    
		local l_DeepRebuildGain = 0
		l_DeepRebuildGain = l_Score_After_SeveralChangesToSegmentRange -
                        l_Score_Before_SeveralChangesToSegmentRange
    
     -- This will be checked in bSegmentIsAllowedToBeRebuilt...
    g_PointsGained_Current_RebuildSegmentRange = l_DeepRebuildGain
    
		-- The default for g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan
    -- is 40 or less. If we just gained more than
    -- g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan, 
		-- then we figure, that's good enough for now. It is now time to move on to 
		-- more consecutive segments per segment range...But why such a low number?
    l_RemainingSegmentRanges = #g_SegmentRangesToRebuildTable - l_SegmentRangeIndex
    
		if l_DeepRebuildGain > g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan and 
       l_RemainingSegmentRanges > 0 then
         
      print("\n  The rebuild gain of " .. PrettyNumber(l_DeepRebuildGain) .. " is greater than the" ..
              " 'Move on to more consecutive segments per range if current rebuild gains" ..
            "\n  more than' value of " ..
                g_UserSelected_MoveOnToMoreSegmentsPerRange_IfCurrentRebuild_GainsMoreThan .. 
               " points (this value can be changed on the 'More Options' page);" ..
               " therefore, we will now skip the" .. 
            "\n  remaining " .. l_RemainingSegmentRanges .. " segment ranges with " ..
                g_RequiredNumberOfConsecutiveSegments .. 
               " consecutive segments, and begin processing segments ranges with " ..
                (g_RequiredNumberOfConsecutiveSegments + 1) .. " consecutive segments.")
      
			break -- for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do
      
		end
    
	end -- for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do
  
  -- This is basically the end of the Run X of Y. Let's get ready to start the next Run...
  
	if g_bUserSelected_ConvertAllSegmentsToLoops == true and g_bSavedSecondaryStructure == true then
    
		save.LoadSecondaryStructure() -- <-- this is a very interesting concept. Couldn't this, reloading of
    -- previously stored secondary structure, cause a major decrease in PoseTotalScore???    
    -- Also, since there are likely many more Runs to process, will we be saving off the secondary
    -- structure again at the beginning of the next Run? And if so, why bother saving and loading
    -- the secondary stucture every Run. Why not just save it once at the begging of the script,
    -- and reload it at the end of the script. Anyhow, does it really make since to change the
    -- secondary structure at all? Doesn't that just denature the protein? I am soo confused.
    
	end

end -- RebuildMany_SegmentRanges()
function Display_SegmentRanges()
  -- Called from RebuildMany_SegmentRanges()...
  
	-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}

	local l_ListOfSegmentRanges = ""
	local l_MaxNumberOfSegmentRangesToDisplay = #g_SegmentRangesToRebuildTable

	if l_MaxNumberOfSegmentRangesToDisplay > 100 then
		l_MaxNumberOfSegmentRangesToDisplay = 100
	end

	for l_SegmentIndex = 1, l_MaxNumberOfSegmentRangesToDisplay do
    
    if l_ListOfSegmentRanges ~= "" then
      l_ListOfSegmentRanges = l_ListOfSegmentRanges .. ", "
    end
    
		l_ListOfSegmentRanges = l_ListOfSegmentRanges ..
						g_SegmentRangesToRebuildTable[l_SegmentIndex][srtrt_StartSegment] .. "-" ..
						g_SegmentRangesToRebuildTable[l_SegmentIndex][srtrt_EndSegment]
            
	end -- for l_SegmentIndex = 1, l_MaxNumberOfSegmentRangesToDisplay do

  l_ListOfSegmentRanges = "Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
    " Segment ranges: " .. l_ListOfSegmentRanges
      
    -- #g_SegmentRangesToRebuildTable 
   
  if string.len(l_ListOfSegmentRanges) > 127 then
    l_ListOfSegmentRanges = string.sub(l_ListOfSegmentRanges, 1, 127) .. "..."
  end 
    
	print(l_ListOfSegmentRanges)

end -- Display_SegmentRanges()
function ConvertAllSegmentsToLoops()
  -- Called from RebuildMany_SegmentRanges()...

  -- Turn entire structure into loops...

	local l_bAnyChange = false

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		local l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
		if l_GetSecondaryStructureType ~= "L" then
			-- We have found at least one none loop segment...
			l_bAnyChange = true
			break
		end
    
	end

	if l_bAnyChange == true then
  
		save.SaveSecondaryStructure()  -- We undo this later with a call to save.LoadSecondaryStructure()
		g_bSavedSecondaryStructure = true -- This reminds us to undo this change later in the script
		selection.SelectAll()
		structure.SetSecondaryStructureSelected("L")
    
	end
  
end -- function ConvertAllSegmentsToLoops()
function RememberSolutionWithDisulfideBondsIntact()
  -- Called from 4 functions...
  
	if g_bUserSelected_KeepDisulfideBonds_Intact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
	-- User wants to keep disulfide bonds intact...
	-- As a precaution, let's save our current solution... If the next build
	-- breaks any disufide bonds, we can (and will) revert back to this solution...
	SaveCurrentSolutionToQuickSaveStack()
  
end -- function RememberSolutionWithDisulfideBondsIntact()
function SaveCurrentSolutionToQuickSaveStack()
  -- Called from RememberSolutionWithDisulfideBondsIntact(),
  --             StabilizeSegmentRange() and
  --             RebuildOneSegmentRangeManyTimes()...
  
	if g_QuickSaveStackPosition >= 100 then
		print("Error in SaveCurrentSolutionToQuickSaveStack(), Quicksave stack overflow, exiting script")
		exit()
	end
	save.Quicksave(g_QuickSaveStackPosition) -- Save
	g_QuickSaveStackPosition = g_QuickSaveStackPosition + 1
  
end -- function SaveCurrentSolutionToQuickSaveStack()
function RebuildOneSegmentRangeManyTimes(l_StartSegment, l_EndSegment)
  -- Called from RebuildMany_SegmentRanges()..
  
	Populate_g_ScorePart_Scores_Table()

	if l_StartSegment > l_EndSegment then
		l_StartSegment, l_EndSegment = l_EndSegment, l_StartSegment
	end --switch around if needed

  local l_Score_Before_RebuildSelectedSegments = 0
  local l_Score_After_RebuildSelectedSegments = 0
  
	local l_MaxRounds = 
		g_UserSelected_NumberOfTimesToRebuildEach_SegmentRange_PerRunCycle -- default is 10
    
	for l_Round = 1, l_MaxRounds do
   
		if g_bSketchBookPuzzle == true then 
			save.Quickload(3)
		end       
   
		-- Here's what you are looking for...
		-- Here's what you are looking for...
    
		RebuildSelectedSegments(l_StartSegment, l_EndSegment, l_Round, l_MaxRounds)
    
		-- Here's what you are looking for...
		-- Here's what you are looking for...
    
    
    
    
    RememberSolutionWithDisulfideBondsIntact()
    
    local l_Iterations = 1
    local l_bShake_And_Wiggle_OnlySelectedSegments = true
    
    if g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments == true then
      
      -- Very slow!!!
     
      local l_SphereRadius = 9 -- Angstroms
      SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
      
      SetClashImportance(1)
      
      local l_Score_Before_ShakeAndWiggle = 0
      local l_Score_After_ShakeAndWiggle = 0
      
      l_Score_Before_ShakeAndWiggle = g_Score_ScriptBest
      
      -- Here's what you are looking for...
      -- Here's what you are looking for...
      l_Iterations = 1
      ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
      l_Iterations = 2
      ShakeAndOrWiggle("WiggleSideChains", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
      selection.DeselectAll()
      selection.SelectRange(l_StartSegment, l_EndSegment)
      l_Iterations = 4
      ShakeAndOrWiggle("WiggleBackbone", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
      -- Here's what you are looking for...
      -- Here's what you are looking for...      
      
      -- why call this again here...
      SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
     
      l_Score_After_ShakeAndWiggle = GetPoseTotalScore()
      
      if l_Score_After_ShakeAndWiggle > l_Score_Before_ShakeAndWiggle then
        
        SaveBest() -- <-- Updates g_Score_ScriptBest
        
        print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
          " after regional ShakeAndWiggle w/2xSideChains & 4xBackbone, "..
          l_Round .. " of " .. 
          l_MaxRounds ..
          " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
      
      end -- if l_Score_After_LocalShakeAndWiggle > l_Score_Before_LocalShakeAndWiggle then
      
    elseif g_bUserSelected_ShakeAndWiggle_WithSelected_Segments == true then
      
      -- Not too slow...
      
      SetClashImportance(g_UserSelected_Shake_ClashImportance)
      
      l_Iterations = 1
      
      local l_Score_Before_LocalShakeAndWiggle = 0
      local l_Score_After_LocalShakeAndWiggle = 0
      
      l_Score_Before_LocalShakeAndWiggle = g_Score_ScriptBest
      
      -- Here's what you are looking for...
      -- Here's what you are looking for...
      ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)        
      -- Here's what you are looking for...
      -- Here's what you are looking for...
      
      l_Score_After_LocalShakeAndWiggle = GetPoseTotalScore()
      
      if l_Score_After_LocalShakeAndWiggle > l_Score_Before_LocalShakeAndWiggle then
        
        SaveBest() -- <-- Updates g_Score_ScriptBest
        
        print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
          " after local ShakeAndWiggle, " .. l_Round .. " of " .. 
          l_MaxRounds ..
          " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
      
      end
      
    end -- if g_bUserSelected_ShakeAndWiggle_WithSideChainsAndBackbone_WithSelectedAndNearby_Segments ==...
   
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    local l_RoundXofYText = " round " .. l_Round .. " of " .. l_MaxRounds
   
    if g_bUserSelected_Mutate_After_Rebuild == true then
      
      -- Here's what you are looking for...
      -- Here's what you are looking for...
      MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, l_RoundXofYText, "")
      -- Here's what you are looking for...
      -- Here's what you are looking for...
      
    end
      
    -- We have just rebuilt (and optionally, local shaked, wiggled and mutated) 
    -- only one segment range and only one attempt. 
    -- Next, we are going to check for ScorePart improvements for this one 
    -- specific rebuild attempt.
    -- For each ScorePart that improves, associate the current pose (and PoseTotalScore)
    -- of the protein to that ScorePart.
    -- Later, in RebuildMany_SegmentRanges(), after all the rebuild attempts (and optional local
    -- shakes, wiggles and mutates) have completed for this one segment range, we will then
    -- step through each of the saved best ScorePart poses and regionally shake and wiggle
    -- them to see if we can further improve our score...
    Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment, l_EndSegment)
   
	end -- for l_Round = 1, l_MaxRounds do
	
	SetClashImportance(1) -- This call to SetClashImportance is probably not needed here because we
  -- normally SetClashImportance just before each rebuild, shake, wiggle and mutate. I'll double check 1st

	return

end -- RebuildOneSegmentRangeManyTimes()
function Populate_g_ScorePart_Scores_Table()
  -- Called from RebuildOneSegmentRangeManyTimes()...

	g_ScorePart_Scores_Table = {} -- reset it

	local l_ScorePart_Number = 0
	local l_ScorePart_Score = 0
	local l_PoseTotalScore = 0
	local l_SetOfScorePartsWithMatchingPoseTotalScore = ''
	local l_bFirstInASetOfScorePartsWithMatchingPoseTotalScore = false

	local l_bScorePart_IsActive

	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
  
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
  
		l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_bScorePart_IsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
    
		if l_bScorePart_IsActive == true then
    
			g_ScorePart_Scores_Table[#g_ScorePart_Scores_Table + 1] =
				{l_ScorePart_Number, l_ScorePart_Score, l_PoseTotalScore,
         l_SetOfScorePartsWithMatchingPoseTotalScore, l_bFirstInASetOfScorePartsWithMatchingPoseTotalScore}
         
		end
    
	end

end -- Populate_g_ScorePart_Scores_Table()
function SetClashImportance(l_ClashImportance)
  -- Called from 8 functions...
  
	if l_ClashImportance > 0.99 then
		g_bMaxClashImportance = true
	else
		g_bMaxClashImportance = false
	end
  
	behavior.SetClashImportance(l_ClashImportance * g_UserSelected_ClashImportanceFactor)
  
end -- function SetClashImportance(l_ClashImportance)
function RebuildSelectedSegments(l_StartSegment, l_EndSegment, l_Round, l_MaxRounds)
  -- Called from RebuildOneSegmentRangeManyTimes()...

	local l_MaxIterations = 3

  -- We have to set clash importance and select segment range every time this function is 
  -- called (each rebuild round) because shakes, wiggles and mutates will change these values...
	SetClashImportance(g_RebuildClashImportance) -- g_RebuildClashImportance is always 0, so what's the point
	selection.DeselectAll()
	selection.SelectRange(l_StartSegment, l_EndSegment)
  
	if g_bUserSelected_Disable_Bands_DuringRebuild == true then
		band.DisableAll() -- will re-enable after rebuild.
	end

  for l_CurrentIteration = 1, l_MaxIterations do
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.RebuildSelected(l_CurrentIteration)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
  
    l_Score_After_Rebuild = GetPoseTotalScore()
    if l_Score_After_Rebuild > g_Score_ScriptBest then
      SaveBest() -- <-- Updates g_Score_ScriptBest
      print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
        " after RebuildSelected(" .. l_CurrentIteration .. "x)" ..
        " round " .. l_Round .. " of " .. l_MaxRounds ..
        " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
    elseif l_Score_After_Rebuild < g_Score_ScriptBest then
      -- Should will undo our last change because it dropped our score...
      recentbest.Restore()
    end

  end -- for l_CurrentIteration = 1, l_MaxIterations do

	if g_bUserSelected_Disable_Bands_DuringRebuild == true then
		band.EnableAll()
	end

end -- RebuildSelectedSegments()
function bOneOrMoreDisulfideBondsHaveBroken()

  -- Called from 1 place in RememberSolutionWithDisulfideBondsIntact(),
  --             1 place in RebuildSelectedSegments(), and
  --             1 place in RebuildMany_SegmentRanges()...
  
	if g_bUserSelected_KeepDisulfideBonds_Intact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
  
	-- User wants to keep disulfide bonds intact...
	local l_NumberOfDisulfideBonds = CountDisulfideBonds()
  
	if  l_NumberOfDisulfideBonds < g_OriginalNumberOfDisulfideBonds then
		return true
	end  
  
	return false
  
end -- function bOneOrMoreDisulfideBondsHaveBroken()
function CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
  -- Called from 4 functions...
	if g_bUserSelected_KeepDisulfideBonds_Intact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
  
	-- User wants to keep disulfide bonds intact...
	if bOneOrMoreDisulfideBondsHaveBroken() == true then
		-- Well, we can't be breaking disulfide bonds, now can we?
		LoadLastSavedSolutionFromQuickSaveStack()
	else
		-- Looks like everything is kosher, so let's keep our current solution
		-- (improvements, I hope), and remove the last saved solution from the stack...
		RemoveLastSavedSolutionFromQuickSaveStack()
	end
  
end -- function CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
function LoadLastSavedSolutionFromQuickSaveStack()
  -- Called from CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact(),
  --             StabilizeSegmentRange() and
  --             RebuildOneSegmentRangeManyTimes()...
  
	if g_QuickSaveStackPosition <= 60 then
		print("Quicksave stack underflow, exiting script")
		exit()
	end
  
	g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	save.Quickload(g_QuickSaveStackPosition) -- Load

end -- function LoadLastSavedSolutionFromQuickSaveStack()
function RemoveLastSavedSolutionFromQuickSaveStack()
  -- Called from CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact() and
  --             StabilizeSegmentRange()...
  
	if g_QuickSaveStackPosition > 60 then
		g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	end
  
end -- function RemoveLastSavedSolutionFromQuickSaveStack()
function SaveBest() -- <-- Updates g_Score_ScriptBest
  -- Called from 1 place in FuseBestPositionEnd(), 
  --             4 times in FuseBestPosition(),
  --             1 time  in Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(),
  --             1 time  in RebuildOneSegmentRangeManyTimes(), and 
  --             2 times in RebuildMany_SegmentRanges()...
  
  -- Note 1: As long as you call SaveBest() after every rebuild, shake, wiggle and mutate, then
  --         g_Score_ScriptBest will always have the best score ever encounter during the script run.
  -- Note 2: The value of GetPoseTotalScore() can go up and down drastically after any call to rebuild,
  --         shake, wiggle or mutate; therefore, you cannot always expect to find the best score by calling
  --         GetPoseTotalScore().
  
  if g_bUserSelected_TemporarilyDisable_ConditionChecking == true then
    
   	local l_PoseTotalScore_WithConditionChecking_Disabled = GetPoseTotalScore()
  	local l_PotentialScore_IfAllConditionsAreMet = 
          l_PoseTotalScore_WithConditionChecking_Disabled + g_UserSelected_MaximumPotentialBonusPoints
    
    if (l_PotentialScore_IfAllConditionsAreMet <= g_Score_ScriptBest) then
      return
    end
    
    -- Do not attempt to improve g_Score_ScriptBest if:
    -- 1) Normal condition checking is temporarily disabled, and
    -- 2) Reenabling normal condition checking would not likely improve our g_Score_ScriptBest.
    
    -- When normal condition checking is disabled, our scores are only potential scores; that is,
    -- if all conditions are met. We won't know if all conditions are met until we re-enable
    -- normal condition checking. We only temporarily disable normal condition checking to speed
    -- up the rebuild process, and only when there are potential bonus points to be earned.
  end
  
  if g_bUserSelected_TemporarilyDisable_ConditionChecking == true then
    -- Temporarily re-enable normal condition checking, so we
    -- can look at real scores instead of potential scores...
    ReEnable_NormalConditionChecking()
  end
  
  -- With normal condition checking re-enabled, a call to GetPoseTotalScore()
  -- will return an actual, real, counted, foldit-saved, current pose total score...
  local l_Current_PoseTotalScore = GetPoseTotalScore()
  local l_Real_PointsGained = l_Current_PoseTotalScore - g_Score_ScriptBest  
  
  local l_MinimumGain_ForSave = 0
  if g_bSketchBookPuzzle == true then
    l_MinimumGain_ForSave = g_UserSelected_SketchBookPuzzle_MinimumGain_ForSave
  end
  
  if l_Real_PointsGained > l_MinimumGain_ForSave or 
    (l_Real_PointsGained > 0 and g_bFoundAHighGain == true) then
    
    g_Score_ScriptBest = l_Current_PoseTotalScore  -- <<<--- This is what you are looking for!!!
    
    if g_bUserSelected_FuseBestPosition == false and g_Score_ScriptBest > 0 then
      print("\nNow that the total score is positive, we will switch back on: " ..
            "'Stabilize' and 'fuse best position'.\n")
      g_bUserSelected_FuseBestPosition = true
      g_bUserSelected_Stabilize = true
    end
    
    save.Quicksave(3) -- Save -- Slot 3 always contains the best scoring pose!
    g_bFoundAHighGain = true -- not exactly sure how this one works yet.
  end
  
  if g_bUserSelected_TemporarilyDisable_ConditionChecking == true then
    -- Disable condition checking again (re-enable fast CPU processing)...
    TemporarilyDisable_ConditionChecking()
  end

end -- SaveBest()
function ReEnable_NormalConditionChecking()
  -- Called from SaveBest() and
  --             CleanUp()...
  
	-- Disables faster CPU processing, so your scores will be counted...

	local l_RecentBest_PoseTotalScore = GetPoseTotalScore(recentbest) -- class "recentbest"
  local l_Current_PoseTotalScore = GetPoseTotalScore()
  
	if l_RecentBest_PoseTotalScore > l_Current_PoseTotalScore then
    
    g_bBetterRecentBest = true -- read in TemporarilyDisable_ConditionChecking() above...
		save.Quicksave(99) -- Save
		recentbest.Restore() -- Keep the current pose if it's better; otherwise, restore the recentbest pose.
		save.Quicksave(98) -- Save
		save.Quickload(99) -- Load
    
	end
  
	behavior.SetFiltersDisabled(false) -- <<<--- Important
  
end -- function ReEnable_NormalConditionChecking()
function SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_Radius)
  -- Called from 3 functions...
	selection.DeselectAll()

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
		for l_InnerLoopSegmentIndex = l_StartSegment, l_EndSegment do
			if structure.GetDistance(l_InnerLoopSegmentIndex, l_SegmentIndex) < l_Radius then
				selection.Select(l_SegmentIndex)
				break
			end
		end
	end
  
end -- function SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_Radius)
function ShakeAndOrWiggle(l_How, l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
  -- Called from 5 functions...
  
	if l_How == nil then -- l_How is optional; the default is "WiggleAll"
		l_How = "WiggleAll"
	end
	if l_Iterations == nil then -- l_Iterations is optional; the default is 3 iterations
		l_Iterations = 3
	end
	if l_bShake_And_Wiggle_OnlySelectedSegments == nil then
		-- l_bShake_And_Wiggle_OnlySelectedSegments is optional; the default is to do all segments
		l_bShake_And_Wiggle_OnlySelectedSegments = false
	end

	local l_WiggleFactor = 1
	if g_bMaxClashImportance == true then
		l_WiggleFactor = g_UserSelected_WiggleFactor
	end

	l_bWiggleBackbone  = true
	l_bWiggleSideChains = true

	if l_How == "ShakeAndWiggle" then
		-- Shake is not considered to do much in second or more rounds
    
		if l_bShake_And_Wiggle_OnlySelectedSegments == true then
      
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
			structure.ShakeSidechainsSelected(1)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
      
    local l_Score_After_Shake = GetPoseTotalScore()
    if l_Score_After_Shake > g_Score_ScriptBest then
      SaveBest() -- <-- Updates g_Score_ScriptBest
      print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
        " after ShakeSidechainsSelected(1x)" ..
        " round " .. l_Round .. " of " .. l_MaxRounds ..
        " with segments " .. l_StartSegment .. "-" .. l_EndSegment)
    elseif l_Score_After_Shake < g_Score_ScriptBest then
      -- Should will undo our last change because it dropped our score...
      recentbest.Restore()
    end
      
      
     
		else
      
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
			structure.ShakeSidechainsAll(1)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
      
      
      
      
		end
	end
	
	if l_How == "WiggleBackbone" then -- only wiggle backbone, do not wiggle side chains
		l_bWiggleSideChains = false
	end

	if l_How == "WiggleSideChains" then -- ws = only wiggle side chains, do not wiggle backbone
		l_bWiggleBackbone = false
	end

	-- Lets amplify the iterations for a bigger effect...
	l_Iterations = 2 * l_WiggleFactor * l_Iterations

	if l_bShake_And_Wiggle_OnlySelectedSegments == true then
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.WiggleSelected(l_Iterations, l_bWiggleBackbone, l_bWiggleSideChains)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    
    
    
    
	else
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.WiggleAll(l_Iterations, l_bWiggleBackbone, l_bWiggleSideChains)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    
    
    
	end

end -- ShakeAndOrWiggle(l_How, l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
function MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, l_RoundXofYText,
                                            l_ScorePartText)
  -- Called from RebuildOneSegmentRangeManyTimes(),
  --             StabilizeSegmentRange() and
  --             3 places in RebuildMany_SegmentRanges()...

	if g_bProteinHasMutableSegments == false then
		return
	end
  -- Let's make this look like RebuildSelectedSegments as much as possible...

	local l_MaxIterations = 2
  
	SetClashImportance(g_UserSelected_Mutate_ClashImportance) -- default is 0.9 (close to 1)

	-- Mutate what user selected to do...
--	if g_bUserSelected_Mutate_OnlySelected_Segments == true then
    
		selection.DeselectAll()
		selection.SelectRange(l_StartSegment, l_EndSegment)
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.MutateSidechainsSelected(l_MaxIterations)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    l_Score_After_Mutate = GetPoseTotalScore()
    if l_Score_After_Mutate > g_Score_ScriptBest then
      SaveBest() -- <-- Updates g_Score_ScriptBest
      print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
        " after MutateSidechainsSelected(2x)" ..
        l_RoundXofYText ..
        " with segments " .. l_StartSegment .. "-" .. l_EndSegment ..
        l_ScorePartText)
    elseif l_Score_After_Mutate < g_Score_ScriptBest then
      recentbest.Restore()
    end
    
--  elseif g_bUserSelected_Mutate_SelectedAndNearby_Segments == true then
  
		SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, g_UserSelected_Mutate_SphereRadius)
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.MutateSidechainsSelected(l_MaxIterations)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    l_Score_After_Mutate = GetPoseTotalScore()
    if l_Score_After_Mutate > g_Score_ScriptBest then
      SaveBest() -- <-- Updates g_Score_ScriptBest
      print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
        " after MutateSidechainsSelected(2x)" ..
        l_RoundXofYText ..
        " within " .. g_UserSelected_Mutate_SphereRadius .. " angstroms of" ..
        " segments " .. l_StartSegment .. "-" .. l_EndSegment ..
        l_ScorePartText)
    elseif l_Score_After_Mutate < g_Score_ScriptBest then
      recentbest.Restore()
    end
   
--  else -- if g_bUserSelected_Mutate_OnlySelected_Segments == true then
    
		selection.SelectAll()
    
    RememberSolutionWithDisulfideBondsIntact()
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		--structure.MutateSidechainsSelected(l_MaxIterations)
    structure.MutateSidechainsAll(l_MaxIterations)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
    CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
    
    l_Score_After_Mutate = GetPoseTotalScore()
    if l_Score_After_Mutate > g_Score_ScriptBest then        
      SaveBest() -- <-- Updates g_Score_ScriptBest
      print("Score: " .. PrettyNumber(g_Score_ScriptBest) .. "," ..
        l_RoundXofYText ..
        " after MutateSidechainsAll(2x)" ..
        " with all segments" ..
        l_ScorePartText)
    elseif l_Score_After_Mutate < g_Score_ScriptBest then
      recentbest.Restore()
    end
    
--	end -- if g_bUserSelected_Mutate_OnlySelected_Segments == true then

end -- MutateSideChainsOfSelectedSegments()
function Update_g_ScorePart_Scores_Table_SetOfScorePartsWithMatchingPoseTotalScore_And_FirstInASet_Fields()
  -- Called from RebuildMany_SegmentRanges()...
  
	-- Create a list of all ScoreParts, grouped by matching PoseTotalScore values...
	-- For each ScorePart_Scores_Table row (or the first of a group of rows with matching 
  -- PoseTotalScore values), set the bFirstInASetOfScorePartsWithMatchingPoseTotalScore flag to true...

	-- Create a list of all ScorePart_Numbers, grouped by matching PoseTotalScore values...
	-- It will look something like this 1=5=7 2=3=9 4 6=8...
	local l_OrganizedListOfAllScorePart_Numbers = ""

	-- Create a table with one row per g_ScorePart_Scores_Table row, and set each row's
	-- Done status to false. This way, when we look ahead in the g_ScorePart_Scores_Table for
	-- ScoreParts with a matching PoseTotalScore value, we can set those rows to Done, so we can
	-- skip them (because we will have already added them to the l_OrganizedListOfAllScorePart_Numbers)...
	local l_ScorePartScoresDoneStatusTable = {}
	for l_TableIndex = 1, #g_ScorePart_Scores_Table do
		l_ScorePartScoresDoneStatusTable[l_TableIndex] = false
	end

	-- Go through every row in the g_ScorePart_Scores_Table and look for other row's
	-- with a matching PoseTotalScore value...
	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
	for l_TableIndex = 1, #g_ScorePart_Scores_Table do
    
		-- Skip the ScoreParts which have already been accounted for in the inner loop below...
		if l_ScorePartScoresDoneStatusTable[l_TableIndex] == false then
      
			local l_Current_ScorePart_Number = g_ScorePart_Scores_Table[l_TableIndex][spst_ScorePart_Number]
			local l_Current_PoseTotalScore = g_ScorePart_Scores_Table[l_TableIndex][spst_PoseTotalScore]
      
			-- Start creating a List of ScorePart_Numbers with matching PoseTotalScore values...
			-- Note: The l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue could end up with just a single
			-- ScorePart_Number if no other rows have a matching PoseTotalScore value. And this is okay...
			local l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue = l_Current_ScorePart_Number
      -- ...add first ScorePart_Number.
      
			-- For each ScorePart_Scores_Table row (or the first of a group with matching PoseTotalScores),
      -- set the bFirstInASetOfScorePartsWithMatchingPoseTotalScore flag to true...
      -- The value of this field is checked in RebuildMany_SegmentRanges()...
			g_ScorePart_Scores_Table[l_TableIndex][spst_bFirstInASetOfScorePartsWithMatchingPoseTotalScore] =
        true 
      
			-- Now, for each row in g_ScorePart_Scores_Table, loop through the table
			-- a second time, (starting at the first row we have not yet looked at),
			-- to find other rows with a matching PoseTotalScore value...
			for l_PotentialMatchIndex = l_TableIndex + 1, #g_ScorePart_Scores_Table do
        
				local l_PoseTotalScore = g_ScorePart_Scores_Table[l_PotentialMatchIndex][spst_PoseTotalScore]
				local l_ScorePart_Number = g_ScorePart_Scores_Table[l_PotentialMatchIndex][spst_ScorePart_Number]
        
				if l_PoseTotalScore == l_Current_PoseTotalScore then
					-- Ah ha, we found another ScorePart_Scores_Table row with a matching PoseTotalScore value...
          
					-- Let's add this l_ScorePart_Number to the
          --  l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue...
					l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue =
						l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue .. "=" .. l_ScorePart_Number

					-- Since we will be adding this ScorePart_Number to the organized list of all
					-- ScorePart_Numbers below, will need to skip this ScorePart_Number in the outter loop;
					-- otherwise, we would end up with duplicates in our organized list...
					l_ScorePartScoresDoneStatusTable[l_PotentialMatchIndex] = true
          
				end
			end
      
			-- SetOfScorePartsWithMatchingPoseTotalScore examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
			g_ScorePart_Scores_Table[l_TableIndex][spst_SetOfScorePartsWithMatchingPoseTotalScore] =
        l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue
        
			l_OrganizedListOfAllScorePart_Numbers = l_OrganizedListOfAllScorePart_Numbers ..
				"\n  PoseTotalScore value: [" .. PrettyNumber(l_Current_PoseTotalScore) .. "]" ..
				" ScorePart_Numbers: [" .. l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue .."]"
		end
    
	end

	--print("\n  List of all ScoreParts (grouped by matching PoseTotalScore value):\n" ..
	--	l_OrganizedListOfAllScorePart_Numbers)

end -- Update_g_ScorePart_Scores_Table_SetOfScorePartsWithMatchingPoseTotalScore_And_FirstInASet_Fields()
function Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment,
                                                                                   l_EndSegment)
  -- Called from RebuildOneSegmentRangeManyTimes() and 
  --             RebuildMany_SegmentRanges()...
  
  -- Check for ScorePart improvements for this particular segment range rebuild attempt.
  -- For each ScorePart that improves, associate the current pose of the protein to 
  -- that ScorePart. After all the rebuild attempts (with their local shakes, wiggles
  -- and mutates) for this segment range have completed, we will step through each of
  -- the saved best ScorePart poses and regionally shake and wiggle them to see if we
  -- can further improve our score...
  
  -- Example g_ScorePartsTable entries...
  -- g_ScorePartsTable={
  -- ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4
  -- }
	-- {{4, "total",      true, "4 (total)"},     {5, "loctotal",  true, "5 (loctotal)"},
  --  {6, "ligand",     true, "6 (ligand)"},    {7, "Clashing",  true, "7 (Clashing)"},
  --  {8, "Pairwise",   true, "8 (Pairwise)"},  {9, "Packing",   true, "9 (Packing)"},
  --  {10, "Hiding",    true, "10 (Hiding)"},   {11, "Bonding",  true, "11 (Bonding)"},
  --  {12, "Ideality",  true, "12 (Ideality)"}, {13, "Backbone", true, "13 (Backbone)"},
  --  {14, "Sidechain", true, "14 (Sidechain)"}}
    
	-- Example l_ActiveScorePartsScoreTable entries...
  --l_ActiveScorePartsScoreTable={
		local aspst_ScorePart_Number = 1
		local aspst_ScorePart_Score = 2
	--}
  -- {{4, -6977.2286118734919},   {5, -12.456666312787226},
  --  {6, 32.926353206790921},    {7, 0.78147661683925884},
  --  {8, 0.85188072449657337},   {9, -0.013940290319947923},
  --  {10, 1.4852902498961473},   {11, 0.54829136056463312},
  --  {12, 0.089609316803455741}, {13, -0.59525161763844237},
  --  {14, 0.32827495834027864}}
  
  -- Example g_ScorePart_Scores_Table entries...
  -- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, 
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5
  --{{ 4,-2070.4815006125,-2070.4815006125,"",false},{ 5,4.2974272030,-8544.6292812514,"",false},
  -- { 6,   41.9906112341,-5500.1149833617,"",false},{ 7,0.4566169644,-4424.6808476751,"",false},
  -- { 8,    1.3090043250,-5500.1149833617,"",false},{ 9,0.3907275101,-8544.6292812514,"",false},
  -- {10,    1.3220077059,-4424.6808476751,"",false},{11,0.3854063676,-4424.6808476751,"",false},
  -- {12,    1.3755310009,-5500.1149833617,"",false},{13,1.2065804745,-4424.6808476751,"",false},
  -- {14,    0.2095337681,-5500.1149833617,"",false}}
  
	-- Create a new list of active ScoreParts, then call
	-- Get_ScorePart_Score() to get each ScorePart's scores...
	local l_ActiveScorePartsScoreTable = {}  -- {1=ScorePart_Number, 2=ScorePart_Score}
	local l_ScorePart_Number, l_ScoreType, l_bScorePart_IsActive, l_ScorePart_Score
  
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number    = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_ScorePart_Name      = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
		l_bScorePart_IsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
    
		if l_bScorePart_IsActive == true then
      
			-- Here is where we are getting the actual score to save...
			l_ScorePart_Score = Get_ScorePart_Score(l_StartSegment, l_EndSegment, l_ScorePart_Name)
			l_ActiveScorePartsScoreTable[#l_ActiveScorePartsScoreTable + 1] = 
        {l_ScorePart_Number, l_ScorePart_Score}
		end
    
	end

	local l_NewScorePart_Score, l_OldScorePart_Score
  
	local l_Current_PoseTotalScore = GetPoseTotalScore()
  -- note 1: Several g_ScorePart_Scores_Table rows will have the same l_Current_PoseTotalScore.

  -- Let's keep track of any ScorePart improvements. If there are improvements for
  -- a particular ScorePart, save the protein's pose for later regional shaking and wiggling...
	-- Update the global ScorePart_Scores_Table with each new ScorePart Score...
	-- g_ScorePart_Scores_Table={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           SetOfScorePartsWithMatchingPoseTotalScore=4,
  --                           bFirstInASetOfScorePartsWithMatchingPoseTotalScore=5}
	for l_TableIndex = 1, #g_ScorePart_Scores_Table do
		l_NewScorePart_Score = l_ActiveScorePartsScoreTable[l_TableIndex][aspst_ScorePart_Score]
		l_OldScorePart_Score = g_ScorePart_Scores_Table[l_TableIndex][spst_ScorePart_Score]
    
		if l_NewScorePart_Score > l_OldScorePart_Score then
			l_ScorePart_Number = l_ActiveScorePartsScoreTable[l_TableIndex][aspst_ScorePart_Number]
      
			-- Save current solution (protein's pose) to FoldIt. After we finish rebuilding this
      -- segment range several times, we will reload the successful poses (the rebuilds
      -- that gained ScorePart points) and apply some regional shakes and wiggles to find more
      -- gains...
			g_ScorePart_Scores_Table[l_TableIndex][spst_ScorePart_Score] = l_NewScorePart_Score
			g_ScorePart_Scores_Table[l_TableIndex][spst_PoseTotalScore] = l_Current_PoseTotalScore
      
			save.Quicksave(l_ScorePart_Number) -- Save <<<--- Important!
      -- I assume we will later re-load these poses and work on them more. But what function
      -- does that occur in? And does that function give credit to this function for storing
      -- these hot poses?
      
		end
	end
  local debug = 1

end -- Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
function StabilizeSegmentRange(l_StartSegment, l_EndSegment)
  -- Called from 1 place in RebuildMany_SegmentRanges()...

--This is next place i need to work on......
	local l_Iterations = 1
	local l_bShake_And_Wiggle_OnlySelectedSegments = true -- note, this is true this time...

	-- Do not accept Stabilize losses...
	local l_Score_FunctionBest = g_Score_ScriptBest -- No! GetPoseTotalScore()
	
	-- As a precaution, let's save our current solution... If the next build
	-- decreases our score, then we will revert back to this solution...
	SaveCurrentSolutionToQuickSaveStack()
	
	SetClashImportance(0.1)
  
	l_bShake_And_Wiggle_OnlySelectedSegments = true -- note, this is true this time...
	ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	if g_bUserSelected_Mutate_During_Stabilize == true then
		SetClashImportance(1)
		MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "", "")
	end
	
	if g_bUserSelected_PerformExtraStabilize == true then -- default is false
    
		SetClashImportance(0.4)
    
		l_bShake_And_Wiggle_OnlySelectedSegments = false -- and it's false this time...
		ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
    
		SetClashImportance(1)
    
		-- Note the third parameter uses the global value instead of the local value here...
		ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments)
	end
	
	SetClashImportance(1)
	
	recentbest.Save() -- Save the current pose as the recentbest pose.  
	l_Iterations = 3
  
	l_bShake_And_Wiggle_OnlySelectedSegments = false -- and it's false this time, too...
	ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
  
	recentbest.Restore()-- Keep the current pose if it's better; otherwise, restore the recentbest pose.
	
	local l_Score_After_ShakeAndWiggle = GetPoseTotalScore()
  
	if l_Score_After_ShakeAndWiggle > l_Score_FunctionBest then
    
    l_Score_FunctionBest = l_Score_After_ShakeAndWiggle --<-- Pointless, right?
    -- Should we call SaveBest() here? nah, the calling function already calls SaveBest()

		-- Keep the current solution and remove the last saved solution from the Quicksave stack...
		RemoveLastSavedSolutionFromQuickSaveStack()
	else
		-- This build was a failure, so load the last saved solution from the Quicksave stack...
		LoadLastSavedSolutionFromQuickSaveStack()
	end
	
end -- function StabilizeSegmentRange(l_StartSegment, l_EndSegment)
function FuseBestPosition(l_SlotNumber, l_DoPreFunction, l_DoPostFunction,
                          l_bShake_And_Wiggle_OnlySelectedSegments)
  -- Called from 2 places in RebuildMany_SegmentRanges()...

	local l_Current_PoseTotalScore = GetPoseTotalScore()
	
	if l_SlotNumber == nil then
		l_SlotNumber = 4
		save.Quicksave(l_SlotNumber) -- Save
	end

	recentbest.Save() -- Save the current pose as the recentbest pose.  
	
	FuseBestPosition1(0.3, 0.6, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	FuseBestPositionEnd(l_DoPreFunction, l_DoPostFunction)
	l_Current_PoseTotalScore = reFuseBestPosition(l_Current_PoseTotalScore, l_SlotNumber)

	FuseBestPosition2(0.3, 1, l_DoPreFunction, l_DoPostFunction)
	-- Keep the current pose if it's better; otherwise, restore the recentbest pose...
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest() -- <-- Updates g_Score_ScriptBest; does the call to FuseBestPosition not already do this?
	l_Current_PoseTotalScore = reFuseBestPosition(l_Current_PoseTotalScore, l_SlotNumber)

	FuseBestPosition1(0.05, 1, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest() -- <-- Updates g_Score_ScriptBest
	l_Current_PoseTotalScore = reFuseBestPosition(l_Current_PoseTotalScore, l_SlotNumber)

	FuseBestPosition2(0.7, 0.5, l_DoPreFunction, l_DoPostFunction)
	FuseBestPositionEnd()
	l_Current_PoseTotalScore = reFuseBestPosition(l_Current_PoseTotalScore, l_SlotNumber)

	FuseBestPosition1(0.07, 1, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest() -- <-- Updates g_Score_ScriptBest
	
	reFuseBestPosition(l_Current_PoseTotalScore, l_SlotNumber)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest() -- <-- Updates g_Score_ScriptBest

end -- function FuseBestPosition(l_SlotNumber, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_Onl...
function FuseBestPosition1(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction,
		l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
  -- Called from 3 places in FuseBestPosition()...

	if l_DoPreFunction ~= nil then
		l_DoPreFunction()
	end
	
	if l_bShake_And_Wiggle_OnlySelectedSegments == nil then
		l_bShake_And_Wiggle_OnlySelectedSegments = true
	end
	
	local l_Iterations = 1
	
	SetClashImportance(l_ClashImportanceBefore)
	ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	l_bShake_And_Wiggle_OnlySelectedSegments = false

	SetClashImportance(l_ClashImportanceAfter)
	ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	if l_DoPostFunction ~= nil then
		l_DoPostFunction()    
	end
	
end -- function FuseBestPosition1(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction...
function FuseBestPositionEnd(l_DoPreFunction, l_DoPostFunction)
  -- Called from 2 places in FuseBestPosition()...
	
	if l_DoPreFunction ~= nil then
		l_DoPreFunction()
	end
	
	local l_Iterations = 1
	local l_bShake_And_Wiggle_OnlySelectedSegments = false
	l_Iterations = 3 -- why 3 here?

	SetClashImportance(1)
	ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	
	if l_DoPostFunction ~= nil then
		l_DoPostFunction()
	end
	
	SaveBest() -- <-- Updates g_Score_ScriptBest
  
end -- function FuseBestPositionEnd(l_DoPreFunction, l_DoPostFunction)
function GetRecentBest(l_DoPreFunction, l_DoPostFunction)
  -- Called from FuseBestPositionEnd() and
  --             4 places in FuseBestPosition()...
  
	-- Keep the current pose if it's as good as or better than
  -- recent best; otherwise, restore the recentbest pose.
  
	local l_RecentBest_PoseTotalScore = GetRecentBestScore()
	local l_Current_PoseTotalScore = GetPoseTotalScore()
  
	if l_Current_PoseTotalScore >= l_RecentBest_PoseTotalScore  then
    return
  end
    
  if l_DoPreFunction ~= nil then
    l_DoPreFunction()
  end
  
  recentbest.Restore() -- Keep the current pose if it's better; otherwise, restore the recentbest pose.
  
  if l_DoPostFunction ~= nil then
    l_DoPostFunction()
  end
  
  -- No need to call SaveBest here, because g_Score_ScriptBest
  -- would have already seen this high score...recently :-)    
  
end -- function GetRecentBest(l_DoPreFunction, l_DoPostFunction)
function GetRecentBestScore()
  -- Called from GetRecentBest() and 
  --             RebuildMany_SegmentRanges()...
  
	l_RecentBest_PoseTotalScore = GetPoseTotalScore(recentbest) --...the class "recentbest".
  
	return l_RecentBest_PoseTotalScore
  
end
function FuseBestPosition2(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction,
		l_DoPostFunction)
  -- Called from 2 places in FuseBestPosition()...

	if l_DoPreFunction ~= nil then
		l_DoPreFunction()
	end
		
	local l_Iterations = 1
	local l_bShake_And_Wiggle_OnlySelectedSegments = false
	
	SetClashImportance(l_ClashImportanceBefore)
	ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	SetClashImportance(1)
	ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	SetClashImportance(l_ClashImportanceAfter)
	ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	if l_DoPostFunction ~= nil then
		l_DoPostFunction()
	end
	
end -- function FuseBestPosition2(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction...
function reFuseBestPosition(l_Score_Before_FuseBestPosition, l_SlotNumber)
  -- Called from 5 places in FuseBestPosition()...
  
  -- I think this function should somehow be merged with SaveBest(), because they
  -- both do very similar things...
  -- Also, I don't think we need to have the value of l_Score_Before_FuseBestPosition
  -- passed in. We could just use a global variable like g_Score_ScriptBest to remember
  -- the last best position, like SaveBest() does. Okay, Okay, I don't really love
  -- global variables, but I am all about consistancy in code...
  -- Also, why use Slot 4 here? Why not just stick with slot 3?? I mean really, why?
  
	--local l_Score_Before_FuseBestPosition -- see input parameter 1 above  
  local l_Score_After_FuseBestPosition = GetPoseTotalScore() -- <- "After" here is correct! Not Before!
  local l_ReturnTheBetterScore = 0
	
	if l_Score_After_FuseBestPosition > l_Score_Before_FuseBestPosition then
    
		-- The new score is better, so save the
    -- current position, and return the new score...
    -- not sure if I should call SaveBest() here yet. See discussion with myself below...
		save.Quicksave(l_SlotNumber)
		l_ReturnTheBetterScore = l_Score_After_FuseBestPosition
    
    -- Should we call SaveBest() here? No? Because SaveBest() always saves to 
    -- slot 3? But would it hurt to store the current pose in slots 4 and 3? hmm?
    -- Why does this use slot 4, anyway? hmm?
    -- What's so special about Fusing that requires it to have its own slot?
    
	elseif l_Score_After_FuseBestPosition < l_Score_Before_FuseBestPosition then
    
		-- The new score is not as good, so load the,
    -- previous position and return the previous score...
		save.Quickload(l_SlotNumber)
    l_ReturnTheBetterScore = l_Score_Before_FuseBestPosition
    
	end
	
	return l_ReturnTheBetterScore
	
end -- function reFuseBestPosition(l_Score_Before_FuseBestPosition, l_SlotNumber)	
function Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
  -- Called from PrepareToRebuildSegmentRanges() when l_How = 'segments'
  
	if g_bRebuildLoopsOnly then
		local l_bDone = false
		local l_StartSegment = 0
		repeat -- loop segments
			l_StartSegment = l_StartSegment + 1
			local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)
			if l_SecondaryStructureTypeStart == "L" then -- only loop segments here, see below for other
				l_StartSegment = Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)
			end
			if l_StartSegment == g_SegmentCount_WithoutLigands then
				-- We hit the end of the loop possible segments...
				l_bDone = true
			end
		until l_bDone == true
	end

	if g_bRebuildSheetsAndLoops == true or g_bRebuildHelicesAndLoops == true then
		local l_bDone = false
		local l_StartSegment = 0
		repeat -- other than loop segments
			l_StartSegment = l_StartSegment + 1
			-- Starting at the very first segment, look for the start of all non-loop segments...
			-- When we find s non-loop section, we will create a range of segments inluding are
			-- the loop-segments to the left of the non-loop segment and all the segments to the right
			-- with the same segment type as this found non-loop segment
			local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)
			if l_SecondaryStructureTypeStart ~= "L" then -- anything other than loop segments here
				-- ah ha, we found a non-loop section, now go add it to the segment ranges table...
				l_StartSegment = Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)
				-- l_StartSegment now points to the following segment to the right of all the segments which
				-- had matching segment types.  And the process continues, until we hit the end of the
				-- non-ligand section of the segment list.
			end
			if l_StartSegment == g_SegmentCount_WithoutLigands then
				-- We hit the end of the non-ligand segments, time to bail out...
				l_bDone = true
			end
		until l_bDone == true
	end

end -- Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
function Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)
  -- Called from Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()...

	-- Add mulitple loop segments in a SegmentRange to the g_SegmentRangesToRebuildTable...

	local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)
	local l_EndSegment = l_StartSegment
	for l_SegmentIndex = l_StartSegment + 1, g_SegmentCount_WithoutLigands do
		local l_SecondaryStructureTypeNext = structure.GetSecondaryStructure(l_SegmentIndex)
		if l_SecondaryStructureTypeNext == l_SecondaryStructureTypeStart then
			l_EndSegment = l_SegmentIndex
		else
			break
		end
	end

	-- Script defaults:
	-- g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
	-- g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4
	local l_RequiredNumberOfConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Add one row to the g_SegmentRangesToRebuildTable...
	if l_RequiredNumberOfConsecutiveSegments >=
    g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments then
    
		if g_bRebuildLoopsOnly == true then
			-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
			g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
		end
	end
	return l_EndSegment

end -- Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)
function Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)
  -- Called from Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()...

	-- Example:
	-- 1) Let's start with a list of segments looking like this:
	--    sheeet, loop, loop, loop, helix, helix, helix, helix, loop, loop, ligand, ligand, ...
	-- 2) Let's say the passed in l_StartSegment is pointing to the first helix segment in the
	--    above example. In this case, it is segment number 5
	-- 3) We take note that we started with a helix, 'E', segment
	-- 4) We set our EndSegment to this segment number, 5 (we will increment this number to include
	--    all of the following helix segments later in this function)
	-- 5) If there are more segments to the left of this starting segment, which there are, we start
	--    searching to the left for the first non-loop, 'L' segment, which turns out to be a sheet,
	--    and is segment number 1 (note, we are allowing loop segments in the segment range we are creating)
	-- 6) l_StartSegment is now 2 (still pointing to the last loop segment) and l_EndSegment is still 3
	-- 7) Next, we jump down to the second part of this funtion.
	-- 8) If our End Segment is still within the non-ligand section, which it is,
	--    We search forward for the last segment with the same segment type as the
	--    passed in segment. In this example, we have 4 helix segments in a row, so our
	--    End Segment now points to segment number 6 (actually, we go one too far, to 7,
	--    then back up one, to 6, so whatever)
	-- 9) We make sure we are working with a segment type the user selected us to
	--    work on. Let's assume in the example, we are; otherwise, we would leave the function
	-- 10) We move on to the third and final part of this function, where we insert a
	--     row into the g_SegmentRanges table with our example range of 2 to 6, which includes all
	--     of the preceding loop segments and all of the following segments with matching segment
	--     types.

	-- Determine what type of segment we are looking at (e.g., sheet, helix)
	local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)

	local l_EndSegment = l_StartSegment -- note: we will increment this number to include
		--  all of the matching segments to the right later in this function...

	--- If there are more segments to the left of the passed in starting segment, we start
	--  searching to the left for the first non-loop, 'L' segment...
	if l_StartSegment > 1 then
		for l_SegmentIndex = l_StartSegment - 1, 1, -1 do
			local l_SecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
      
			-- Note, we are including loop segments in the segment range we are creating here...
		 if l_SecondaryStructureType == "L" then
				l_StartSegment = l_SegmentIndex
			else
				-- We have backed up to the left most loop segment in this segment range...
				break
			end
		end
	end

	-- Make sure we are still in the non-ligand section of segments (ligand segments are always last)...
	if l_EndSegment < g_SegmentCount_WithoutLigands - 1 then
    
		local l_bChange = false -- Start off assuming we are still looking at the same segment types...
    
		repeat
			-- Search forward for the last segment with the same segment type as the passed in segment...
			l_EndSegment = l_EndSegment + 1
			if l_EndSegment == g_SegmentCount_WithoutLigands then
				-- We hit the end of the non-ligand segments...
				break
			end
			local l_SecondaryStructureType = structure.GetSecondaryStructure(l_EndSegment)
			if l_bChange == false then
				if l_SecondaryStructureType ~= l_SecondaryStructureTypeStart then
					l_bChange = true
				end
			end
		until l_bChange == true and l_SecondaryStructureType ~= "L"
		if l_EndSegment < g_SegmentCount_WithoutLigands then
			l_EndSegment = l_EndSegment - 1
		end
	end
  
	if g_bRebuildSheetsAndLoops == false and l_SecondaryStructureTypeStart == "E" then
		-- If we are not supposed to be working on sheets, 'E', and we are looking at a
		-- sheet segment, then get out of here...
		return l_EndSegment
    
	end
	if g_bRebuildHelicesAndLoops == false and l_SecondaryStructureTypeStart == "H" then
		-- If we are not supposed to be working on helices, 'H', and we are looking at a
		-- helix segment, then get out of here...
		return l_EndSegment
	end

	-- Script defaults:
	-- g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments = 2
	-- g_UserSelected_ResetToStartValueAfterRebuildingWithThisMany_Consecutive_Segments = 4
	local l_NumberofConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Make sure this segment range contains the minimum number of consecutive segments
	-- as require by the user. If not, we will just skip processing this segment range,
	-- and continue to look for segment ranges with enough segments as required...
	-- If we allowed segment ranges with less than the required minimum, we might end up
	-- rebuilding segment ranges of a single segment, which and that would not be efficient or practical...
	if l_NumberofConsecutiveSegments >= g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments then
		-- Not sure why we are using g_UserSelected_StartRebuildingWithThisMany_Consecutive_Segments here
		-- instead of g_RequiredNumberOfConsecutiveSegments. Things that make you go hmmm.
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}

		-- Add one row to the g_SegmentRangesToRebuildTable...
		g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
	end
  
	return l_EndSegment

end -- Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)
-- ...end of Core Rebuild Functions module.
-- Start of Clean Up module...
function CleanUp(l_ErrorMessage)
  -- Called from main() and
  --             xpcall()...
	
	print("\n  Restoring Clash Importance, initial selection, best result and structures...done.")
	SetClashImportance(1)
	save.Quickload(3) -- Load

	if g_bUserSelected_TemporarilyDisable_ConditionChecking == true then
		ReEnable_NormalConditionChecking()
	end
	if g_bSavedSecondaryStructure == true then
		save.LoadSecondaryStructure()
	end

	-- Reset the Segment selection back to the way they were before we started this program...
	selection.DeselectAll()
	if g_OrigSelectedSegmentRanges ~= nil then
		-- g_OrigSelectedSegmentRanges is populated before we call main()...
		SelectSegmentRanges(g_OrigSelectedSegmentRanges)
	end
	if l_ErrorMessage ~= nil then
		print(l_ErrorMessage)
	end
	
  local l_Score_AtEndOf_Script = g_Score_ScriptBest
	print("\nStarting Score: " .. PrettyNumber(g_Score_AtStartOf_Script) ..
        "\nPoints Gained: " .. PrettyNumber(l_Score_AtEndOf_Script - g_Score_AtStartOf_Script) ..
        "\nFinal Score: " .. PrettyNumber(l_Score_AtEndOf_Script) ..
        "\n")
end -- function CleanUp(l_ErrorMessage)
function SelectSegmentRanges(l_SegmentRangesTable)
  -- Called from CleanUp()...

	-- l_SegmentRangesTable = {
		local sst_StartSegment = 1
		local sst_EndSegment = 2
	-- }
	selection.DeselectAll()

	if l_SegmentRangesTable ~= nil then
    
		for l_SetIndex = 1, #l_SegmentRangesTable do
      
			local l_StartSegment = l_SegmentRangesTable[l_SetIndex][sst_StartSegment]
			local l_EndSegment = l_SegmentRangesTable[l_SetIndex][sst_EndSegment]
			selection.SelectRange(l_StartSegment, l_EndSegment)
      
		end
    
	end

end -- function SelectSegmentRanges(l_SegmentRangesTable)
-- ...end of Clean Up module.
-- Start of Documentation module...
function ScriptDocumentation()
  -- Called from 0 places. Just stuck it in a fuction so I could fold it (hide it in the editor)...
	--[[
	Notes:
		1. This script uses a lot of foldit save slots. Best score is always stored in slot 3
		2. Learn more about the original script "Tvdl enhanced DRW 3.0.2" by "Timo van der Laan"
	     here: https://foldit.fandom.com/wiki/EDRW
		3. See also "Tvdl enhanced DRW 3.1.1" with small fixes and improvements:
		   here: https://fold.it/portal/recipe/102840 
		4. See also a different script approach, "Constructor v1.05" by "Grom"
		   here: https://fold.it/portal/recipe/46192

	Description:
	1. This is a long run rebuilder script. The goal of this script is to rebuild selected and/or lowest scoring segments and segment ranges several times to find better scoring positions (aka: poses / conformations / shapes). If working on a design puzzle, this script will also look for better scoring amino acids for each (mutable / changeable) segment.
	Definitions:
	"Rebuild:" Rebuilding attempts to find a better shape for a section of your protein by trying the shapes of similar proteins. Rebuild works with "fragments" of three segments. Rebuild works by looking in its database for fragments with a similar amino acid sequence. The shape of the matching fragments is then applied to your protein. For more details read this article: https://foldit.fandom.com/wiki/Rebuild
	"Mutate:" means "change to a different amino acid". In Foldit design puzzles, some segments are mutable, meaning their amino acids can be changed.  Mutate picks the best amino acid for one or more segments based on criteria known only to the Foldit design team. For more details, read this article: https://foldit.fandom.com/wiki/Mutate
	"Design puzzle:" In a Design puzzle, the goal is to create a completely new protein. Players can change at least part of the primary structure of the protein, using the mutate tool to change the amino acids. The goal of most design puzzles is to create a protein that will fold up on its own the same way that proteins do in nature. Read more here: https://foldit.fandom.com/wiki/Design_puzzle
	"Shake:" The Shake tool automatically seeks out better sidechain positions (rotations). A global shake affects all unlocked, non-frozen sidechains. A local shake affects only selected sidechains. Read more here: https://foldit.fandom.com/wiki/Shake
	"Wiggle:" Wiggle automatically seeks better backbone and sidechain positions. Wiggle can work on both the backbone and the sidechains at the same time, or backbone and sidechains can be wiggled separately. Unlike shake, wiggle can change the shape of the backbone. Wiggle and shake are the most basic automatic tools in Foldit. Read more here: https://foldit.fandom.com/wiki/Wiggle
	"Selection Interface:" is the newer of the two Foldit game interfaces. The selection interface involves selecting segments. The selection interface makes it possible to perform some tasks manually that are impossible without using recipes in the original user interface. More information about this newer, and arguably more useful interface can be found here: https://foldit.fandom.com/wiki/Selection_Interface
	"Segment:" In Foldit, proteins are made up of segments. A segment is also called a residue (referring the "amino acid residues" after the formation of a peptide bond). To see more information about a segment, hover over the segment with the mouse and hit the tab key. Read more about segments here: https://foldit.fandom.com/wiki/Segment
	"Segment range:" two or more consecutive / continuous segments. "Segment range" is not an official foldit term. Although, selection.SelectRange(StartSegment, EndSegment) is a valid function.
	"Pose:" Position / conformation / shape of everything, including the main protein and any ligands.
	"Slot:" In Foldit, quicksaves are numbered "slots" used to store different poses or solutions of a protein.
	"Fuse best solution:" is a strategy employed by many recipes in Foldit. A fuse attempts to consolidate changes in the protein by using shake and wiggle while varying clashing importance. Learn more here: https://foldit.fandom.com/wiki/Fuse
	"ScorePart:" In Foldit, each segment of the protein has its own score. Score parts contribute to the score for a segment. The value of a specific score part is called a subscore. The score parts which typically influence the overall score the most are Clashing, Packing, Hiding, and Backbone. Read more about Score Parts here: https://foldit.fandom.com/wiki/Score_part
	"Clashing:" The clashing score part is related to clashes, which occur when atoms are too close to each other. If atoms are too close, their electron clouds repel each other, which destabilizes the protein. Read more about clashes here: https://foldit.fandom.com/wiki/Clashes
	"Packing:" The packing score part reflects the extent that atoms are surrounded by other atoms. Packing is closely related to the idea of voids, spaces in the protein that aren't well packed.
	"Hiding:" The hiding score part is based on the hydrophobicity of the sidechain. In general, hydrophobic (orange) sidechains need to point inward, forming a hydrophobic core, while hydrophilic (blue) side chains need to point outward.
	"Backbone:" The backbone score part is based on the configuration of backbone atoms. The backbone score is directly affected by dihedral angles (see Dihedral angle: https://en.wikipedia.org/wiki/Dihedral_angle).
	"Sidechain:" The sidechain score part is derived from statistics which relate the shape of the sidechain to the shape of the backbone. A more negative score means that the configuration is rarer in nature, and thus less likely to be correct.
	"Disulfides:" The disulfide score part is based the quality of a disulfide bond (aka:disulfide bridge). The disulfide score part is found only on cysteine segments.
	"Disulfide Bond:" Also known as a "disulfide bridge", is a strong bond that can form between two cysteines. The strength of disulfide bridges helps stabilize a protein. Disulfide bridges are especially common in proteins that are secreted from cells. For example, disfulfide bridges are common in keratin, a type of protein found in skin, fingernails, hooves, and hair. Disulfide bridges contribute to curly hair. Read more very useful info about Disulfide Bonds here: https://foldit.fandom.com/wiki/Disulfide_Bridge
	"Ideality:" The ideality score part is based on how close the bond lengths, angles, and torsion angles of the peptide bonds between residues are to ideal values. Torsion angles depend on atoms of preceding and following residues, so the ideality subscores of neighboring residues affect each other.
	"Bonding:" The bonding score part is based on the hydrogen bonds between segments.
	"Density:" The density score part is used on electron density puzzles, and shows how well a segment is covered by the electron density cloud.
	"Reference:" The reference score part is the "reference energy" of each amino acid. Its main use is in design puzzles as a "normalization" factor, to correct for the bias for larger sidechains. (Larger sidechains are not necessarily more stable in nature.) The reference score part can't be changed.
	"Pairwise:" The pairwise score part is based on the electrostatic energy of any charged but unbonded atoms within a certain distance of the atoms in a segment. Pairwise has begun appearing as a significant score part since Foldit upgraded to use REF2015 in early 2018. Learn more here: https://fold.it/portal/node/2004944
	"Clash Importance:" Actually, named "Clashing Importance", or CI is a Foldit setting that controls how strongly clashes between atoms push the protein apart. Clashing importance varies between 0.0 and 1.0. At CI = 0.0, Foldit is content to let two atoms occupy the same space at the same time. At CI = 1.0, atoms are pushed apart when they even start to get close to each other. CI = 1.0 represents the "real world" importance of clashes. Learn more about CI here: https://foldit.fandom.com/wiki/Clashing_Importance
	"Primary structure:" The primary structure of a protein is the sequence of amino acids that make up the protein. The primary structure is also called the primary sequence, amino acid sequence or AA sequence. Learn more here: https://foldit.fandom.com/wiki/Primary_Structure
	"Secondary structure:" refers to repeating patterns that help shape a protein. The patterns are the result of hydrogen bonds that form between atoms in the protein's backbone. Sheets and helixes are the types of secondary structure which have a specific pattern of bonds. Parts of the protein that aren't in a sheet or a helix are called loop. Loop sections don't have any definitive pattern to their hydrogen bonds. Read more here: https://foldit.fandom.com/wiki/Secondary_Structure
	"Tertiary structure:" refers to the overall three-dimensional shape of a protein, also known as the conformation or pose. Perfecting tertiary structure is the main goal of Foldit.
	"Bands:" are one of the most important tools in Foldit. Bands were originally called "Rubber Bands", and as the name implies, they tend to pull things together. Foldit bands can also be used to push things apart, which is difficult with real rubber bands. Learn more here: https://foldit.fandom.com/wiki/Band
	"Electron Density Puzzle:" Electron Density Puzzles consist of an unsolved protein and an electron density "cloud" ("ED cloud"). The Electron Density cloud represents where the electrons of the protein's amino acids are likely to be found. The cloud is determined experimentally, and provides insight into the native structure of the protein. The goal of Electron Density puzzles is to fit the protein neatly into the Electron Density cloud, so that little or no part of the protein structure sticks out of the cloud. Learn more here: https://foldit.fandom.com/wiki/Electron_Density_Puzzles
	"Layer filter:"
	"Ligand:"
	2. Each rebuild is scored in different ways and saved if better.
	3. After rebuild finishes, script tries to stabilize each different saved position.
	4. Because some positions are better in more than one way, sometimes there is only one position to stabilize. Could this be written more clearly?
	5. On the best position a fuse is run if it looks promising enough.

	Features (most have user selectable parameters):
	1. Can be used in design puzzles, has mutate options for that.
	2. For each selected segment range, the script will only "recompute the next" (attempt another?) rebuild if there has been enough gain. Is this true? What exactly does this mean?
	3. It will not atttempt to rebuild the exact same selected segments a second time. Really?
	4. It will not try a FuseBestPosition if the loss is too great depending on the size of the rebuild.
	5. It will not attempt to rebuild frozen or locked segments.
	6. User can specify what segments of the protein to work on.
	7. User can select to keep intact or ignore disulfide bonds (thanks Brow42).
	8. If the starting score is negative, default is no wiggles will be done to avoid exploding the protein.
	9. If stopped, this script will reset original Clash Importance, best score and secondary structures.
	10. User can skip X number of worst scoring segment ranges (handy after a crash).
	11. It breaks off rebuild attempts if no chance of success.
	12. It works on puzzles even if the score is < -1000000 (but will be slower).
	13. FuseBestPosition and Stabilize can be suppressed (this is the default, if the score is negative from the start)
	14. User can specify to disable bands when rebuilding and enable them afterwards.
	NEW in version 2
	15. User can choose which ScoreParts will be stabilized.
	16. User can choose which ScoreParts count for finding worst scoring segments.
	17. It will recognize puzzle properties and set defaults for them.
	18. Instead of skipping cycles user can specify number of worst segment ranges to skip (variable name "g_UserSelected_NumberOf_SegmentRanges_ToSkip"). Uh oh. How is this different from number 10 above?
	19. On electron density puzzles the other components are given proper weight for finding worst.
	20. Cleaned up code.
	2.1.0 Added code for processing only previously done segments
	2.1.1 Changed some max and min slider values and autodetects Layer Filter.
	2.2.0 Added ligand ScorePart.
	2.3.0 Changed other by Density. What does this mean?
	2.4.0 Dynamic list of active ScoreParts,
				Puts back the old selection when stopped,
				Added alternative local cleanup after rebuild,
				Resets the original structure if mutated after rebuild for the next rebuild,
				Set default mutate settings if a design puzzle.
	2.4.1 Added WiggleFactor, removed reference as a ScorePart.
	2.5.0 Added g_bUserSelected_ShakeAndWiggle_OnlySelectedSegments option. Thanks Susume.
	2.5.1 Added finding wins during Stabilize wiggle.
	2.6.0 Changed defaults and user interface.
	2.7.0 Added option to disable slow filters on design puzzles.
	2.8.0 Added more general way to disable slow filters on design puzzles.
	2.8.1 Fixed filter problem when high bonus.
	2.8.2 Add call to CleanUp after main stops normally.
	3.0.0 Made a Remix version in the same source.  Really? A search in this file for "remix" turns up nada.
	3.0.1 Fixed density weight computation if filters are active.

	]]--
  
end -- function ScriptDocumentation()
-- ...end of Documentation module.

-- Start of Call Main module...
-- xpcall(main, CleanUp) -- run in protected mode, so if the program crashes
--                         we can fail gracefully, by calling CleanUp()...
main() -- Call main() directly when debugging to more easily find the program line that caused an
--        exception / program abort. It makes it more obvious where the error occured.
-- ...end of Call Main module...
