
-- Start of Setting Things Up...
function DefineGlobalVariables()
  -- Called from Rebuild1PuzzleForManyRuns()...

  --local alien=require"alien"
  --local kernel32=alien.load("kernel32.dll")

	g_bDebugMode = false
	if _G ~= nil then
		g_bDebugMode = true
		SetupLocalDebugFuntions()
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
  --         Reset_g_bSegmentsAlreadyRebuiltTable()
	-- g_bSegmentsAlreadyRebuiltTable={true/false}
	-- g_bSegmentsAlreadyRebuiltTable keeps track of which segments have already been processed...
  
	g_bUserSelectd_SegmentsAllowedToBeRebuiltTable = {} -- was WORKONbool[]
	-- Used in Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts(),
	--         bSegmentIsAllowedToBeRebuilt() and Rebuild1PuzzleForManyRuns()
	-- g_bUserSelectd_SegmentsAllowedToBeRebuiltTable={true/false}

	g_CysteineSegmentsTable = {}
	-- Used in Populate_g_CysteineSegmentsTable(),
  --         DisulfideBonds_GetCount() and
  --         DisplayPuzzleProperties()
	-- g_CysteineSegmentsTable={SegmentIndex}
  
  g_FrozenLockedOrLigandSegmentsTable = {} -- was (the inverse of) WORKON/WORKONbool

	g_ScorePartScoresTable = {} -- was Scores[]
	-- Used in Reset_g_ScorePart_Scores_Table(),
	--         Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(),
	--         Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInS...
  --         and Rebuild1SegmentRangeSetWithManySegmentRanges()
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
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
  --         AskUserToSelectScorePartsForStabilizePosesOfSelectedScoreParts(),
  --         AskUserToSelectScorePartsForCalculatingWorseScoringSegments(),
  --         Rebuild1SegmentRangeSetWithManySegmentRanges(),
  --         Reset_g_ScorePart_Scores_Table() and
	--         Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
		spt_ScorePart_Number = 1
		spt_ScorePart_Name = 2 -- could have been called "SlotName", but since
    --                        most of the "slots" are ScoreParts...
		spt_bScorePartIsActive = 3  -- User can change this to false
		spt_LongName = 4

	g_SegmentScoresTable = {}
	-- Used in Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts() and
  --         Calculate_ScorePart_Score()
	-- g_SegmentScoresTable={SegmentScore}
	-- g_SegmentScoresTable is optimized for quickly searching for 
	-- the lowest scoring segments, so we can work on those first.
  
	g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable = {} -- was scrPart[]
	-- Used by AskUserToSelectScorePartsForCalculatingWorseScoringSegments() and
  --         Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts(), and
	-- g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable={ScorePart_Name}

  g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = {} -- was WORKON[]
	-- g_UserSelected_SegmentRangesAllowedToBeRebuiltTable is initiallly 
  -- set to {1, g_SegmentCount_WithoutLigands} (i.e., all the segments
  -- in the Rebuild1PuzzleForManyRuns protein) in DefineGlobalVariables() then the user can
  -- change this value in AskUserToSelectSegmentsRangesToRebuild() plus
  -- AskUserToSelectRebuildOptions() and finally we remove all frozen,
  -- locked and ligand segments in Rebuild1PuzzleForManyRuns(). This is important because we
  -- don't want to waste any time attempting to rebuild, mutate, shake
  -- or wiggle any segments that are not allowed to do so.

	g_XLowestScoringSegmentRangesTable = {} -- was areas[]
	-- Used in 11 functions.
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
  -- Used in NormalConditionChecking_DisableForThisEntireScriptRun() and
  --         NormalConditionChecking_TemporarilyReEnableToCheckScore()
	
	g_bFoundAHighGain = true
  -- Used in Rebuild1SegmentRangeSetWithManySegmentRanges() and SaveBest()
	
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
  -- Used in 4 functions
  
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
  -- Used in 3 functions
  -- g_bSavedSecondaryStructure can only be set here and in ConvertAllSegmentsToLoops().
  
	g_bSketchBookPuzzle = false
  -- Used in 6 functions
  local l_PuzzleName = puzzle.GetName()  
  if string.find(l_PuzzleName, "Sketchbook") then
    g_bSketchBookPuzzle = true
	end
  
	g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = false
  -- Used in 7 functions...
	-- ...User can change this on the Select Rebuild Options page.
  --if g_bDebugMode == true then
  --  g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments = false
  --end

	g_bUserSelected_ConvertAllSegmentsToLoops = true
  -- Used in 3 functions
  -- Remember loops are not helices. Loops are just plain swiggly lines...
	
	local l_NumberOfBands = band.GetCount()
	g_bUserSelected_DisableBandsDuringRebuild = l_NumberOfBands > 0
	-- Used in 2 functions.
  -- Set default to true if there are any bands.
  
	g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments = false
  -- Used in 3 functions
  -- When set to false then include nearby segments.
  
	g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild = false
  -- Used in 3 functions
  -- If the value of this variable is true the rebuild process will be very slow!
  
  g_bUserSelected_FuseBestScorePartPose = true
	-- Used in 4 functions
  
	g_bUserSelected_KeepDisulfideBondsIntact = false
	-- Used in 8 functions
  
	g_bUserSelected_MutateAfterFuseBestScorePartPose = false
	-- Used in 4 functions

	g_bUserSelected_MutateAfterRebuild = false
	-- Used in 3 functions
  
	g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts = false
	-- Used in 4 functions

	g_bUserSelected_MutateBeforeFuseBestScorePartPose = false
  -- Used in 3 functions
  
	g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts = false
  -- Used in 3 functions
  
	g_bUserSelected_MutateOnlySelectedSegments = false
  -- Used in 3 functions
  
	g_bUserSelected_MutateSelectedAndNearbySegments = false
  -- Used in 4 functions
  
  g_bUserSelected_StabilizePosesOfSelectedScoreParts = true
  -- Used in 5 functions
  
	g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts = false
  -- Used in 3 functions
  
	g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts = true
  -- Used in AskUserToSelectRebuildOptions
  
	g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts = false
  -- Used in AskUserToSelectRebuildOptions()
  
  g_bUserSelected_ScorePartsFromAListForStabilizePosesOfSelectedScoreParts = false
  -- Used in AskUserToSelectRebuildOptions()
  
	g_DensityWeight = 0
  -- Used in 3 functions
  
	g_LastSegmentScore = 0
  -- Used in Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts()
  
  g_OriginalNumberOfDisulfideBonds = 0
  -- Used in 5 functions

	g_CurrentRebuildPointsGained = 0
	-- Used in bSegmentIsAllowedToBeRebuilt() and Rebuild1SegmentRangeSetWithManySegmentRanges()
  
	g_QuickSaveStackPosition = 60 -- Uses slot 60 and higher...
  -- Used in 3 functions
  
	g_RebuildClashImportance = 0
	-- Used in Rebuild1SegmentRangeForManyRounds()
  -- Clash importance value to use during the rebuild step.
  -- Always set to 0, so we really don't need it. 
  
  g_round_x_of_y = "" -- For log file reporting; Example: " round 1 of 15"
  -- Used in 5 functions

  g_RunCycle = 0 -- was Runnr
  -- Used in Rebuild1PuzzleForManyRuns() and Rebuild1SegmentRangeSetWithManySegmentRanges(),
 	
	g_Score_AtStartOf_Script = GetPoseTotalScore()
	-- Used in CleanUp()...
  
  -- Wait until we determine if condition checking will be disabled for the entire script before
  -- setting g_Score_ScriptBest.
  --g_Score_ScriptBest = GetPoseTotalScore() -- ...used in SaveBest() and many others.
  
  g_ScorePartText = "" -- Example: " ScorePart 4 (total)", " ScorePart 6 (ligand) 6=7=11" 
  
  g_ScriptStartTime = os.clock()
  
  g_Stats_Run_StartTime = os.clock()
  
  g_Stats_Run_TotalSecondsUsed_RebuildSelected = 0
  g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected = 0
  g_Stats_Run_TotalSecondsUsed_WiggleSelected = 0
  g_Stats_Run_TotalSecondsUsed_WiggleAll = 0
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected = 0
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll = 0

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
  
  g_Stats_Run_NumberOfAttempts_RebuildSelected = 0.0001 -- prevent divide by zero error
  g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_WiggleSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_WiggleAll = 0.0001
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_MutateSidechainsAll = 0.0001    
	
  g_Stats_Script_NumberOfAttempts_RebuildSelected = 0
  g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected = 0
  g_Stats_Script_NumberOfAttempts_WiggleSelected = 0
  g_Stats_Script_NumberOfAttempts_WiggleAll = 0
  g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected = 0
  g_Stats_Script_NumberOfAttempts_MutateSidechainsAll = 0
  
	g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle = 1
	-- Used in AskUserToSelectMoreOptions() and Rebuild1PuzzleForManyRuns()
  
	g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance = 0.31
  -- Used in 3 functions
  -- Clash imortance to use while shaking

	g_UserSelected_ClashImportanceFactor = behavior.GetClashImportance()
  -- Used in 3 functions
	-- Set Clash Importance Factor...
	-- note: we don't actually have a g_ClashImportance variable,
	--       we only have a g_UserSelected_ClashImportanceFactor variable.
	--       we do, however, have an l_ClashImportance variable in function SetClashImportance() above.
	-- print("behavior.GetClashImportance()=[" .. g_UserSelected_ClashImportanceFactor .. "].")
	if g_UserSelected_ClashImportanceFactor < 0.99 then
		--AskUserToCheckClashImportance() -- <-- This is just a pain during testing
    SetClashImportance(1) -- <-- much better during testing
	end
  
	g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle = 0 -- was reBuild
  -- Used in 3 functions
  -- see Rebuild1PuzzleForManyRuns() for definition
	-- Yah, not really convinced this one helps yet.
  
	g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
  -- Used in 3 functions
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan < 40 then
		g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan = 40 -- why so low?
	end
  if g_bDebugMode == true then
    --g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan = 10000
  end
  
	g_UserSelected_MutateClashImportance = 0.9
	-- Used in MutateSideChainsOfSelectedSegments() and AskUserToSelectMutateOptions()

	g_UserSelected_MutateSphereRadius = 8 -- Angstroms
  -- Used in 3 functions

	g_UserSelected_NumberOfSegmentRangesToSkip = 0 -- set to any value other than 0, to debug related code
  -- Used in 3 functions
  
	g_UserSelected_NumberOfRunCycles = 10 -- 10 is plenty, 5 is usually enough for most tests
  -- Used in 4 functions
  -- Set it very high if you want to run forever
  if g_bDebugMode == true then
    g_UserSelected_NumberOfRunCycles = 5 -- 5 is high enough for debug mode
  end

	-- Maximum number of rounds (with up to 3 attempts per round) to attempt to favorably change 
  -- the protein structure using structure.RebuildSelected() for each segment range per run cycle:
	g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle = 15 -- set to at least 10
  -- Used in 3 functions

	g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints = 
    g_SegmentCount_WithLigands
  -- Used in 3 functions
	-- Default to one point per segment? Seems pretty arbitrary to me...
	-- Example:
	-- g_SegmentCount_WithoutLigands = 135
	-- g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints = 135
  -- ...Pretty simple formula
	if g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints >
    500 then
		g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints = 500
	end
  
	g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments = 4 -- was maxLen
  -- Used in 3 functions
  -- ...any more than 4 consecutive segments does not appear to be fruitful;
  -- Actually, 4 consecutive segments is not great.
  -- And, 3 consecutive segments is barely better then 4.
  -- Really, most of the gains are with just 2 consecutive segments!
  
 	g_UserSelected_SketchBookPuzzle_MinimumGainForSave = 0
  -- Used in AskUserToSelectRebuildOptions() and SaveBest()

	g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints = 
		(g_SegmentCount_WithoutLigands - (g_SegmentCount_WithoutLigands % 4)) / 4
  -- Used in 3 functions
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCount_WithoutLigands = 135
	--   g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints < 30 then
		g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints = 30
	end
  
	g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle = 4
  -- Used in 4 functions
  
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
	--  Because g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments = 4,
  --  this will be the final segment range configuration, and will look like this:
  --  {{1-4},{2-5},{3-6},{4-7} ... {132-135}}
	
	g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments = 2 -- was minLen
  -- Used in 5 functions
  
	g_UserSelected_WiggleFactor = 1
  -- Used in 3 functions

  -- ...end of global variables sorted alphabetically as much as possible.

  g_with_segments_x_thru_y = "" -- For log file reporting; Example: " w/segments 1-3"
  -- Used in 5 functions

  ---------------------------------------------------------
  -- The following are conditional overrides
  -- or otherwise computed variables...
  ---------------------------------------------------------

	g_NumberOfMutableSegments = GetNumberOfMutableSegments()
	if g_NumberOfMutableSegments > 0 then
		g_bUserSelected_MutateAfterFuseBestScorePartPose = true --  default is false (see above)
		g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts = true -- default is false (see above)
		-- user can decide!!! g_bUserSelected_MutateSelectedAndNearbySegments = true
	end
	if g_bSketchBookPuzzle == true then
	   g_bUserSelected_ConvertAllSegmentsToLoops = false -- was set to true by default above
	   g_bUserSelected_FuseBestScorePartPose = false -- was set to true by default above
	   g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints = 500
    -- ... was set to g_SegmentCount_WithLigands by default above
	end
  if g_bDebugMode == true then
    g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints = 50
  end  
  
	g_RequiredNumberOfConsecutiveSegments = 
    g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments
  -- Used in 3 functions
  
	g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = {{1, g_SegmentCount_WithoutLigands}} -- was WORKON[]
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

  local l_ScoreWithoutPotentialBonusPoints = GetPoseTotalScore()
  local l_ScoreWithPotentialBonusPoints = GetPoseTotalScore()
	if g_bSketchBookPuzzle == false then
    
    -- Disable normal condition checking to get score without potential bonus points:
    -- 1) Includes negative points for (currently applicable?) penalties (if any)
    -- 2) Excludes bonus points earned and unearned (if any)
		behavior.SetFiltersDisabled(true) -- Enables faster CPU processing, but your score
    --                                   improvements will not be saved to foldit's undo history.
    l_ScoreWithoutPotentialBonusPoints = GetPoseTotalScore()
    
    --FilterOffScore = GetPoseTotalScore()
    --print("FilterOffScore: " .. FilterOffScore)    
    
    -- Re-enable normal condition checking to get score with potential bonus points:
    -- 1) Includes negative points for (currently applicable?) penalties (if any)
    -- 2) Includes bonus points already earned (if any) **AND** sometimes includes bonus
    --    points not yet earned??? e.g.; Corona Virus 1805b
    -- 3) If this is a **new** puzzle or a **reset** puzzle, this score will not include any bonus points (???).
    -- However, if this puzzle has already been worked on, and has not been reset, and has satisfied
    -- the conditions for earning bonus points, then this score will include any bonus points earned
    -- so far.
		behavior.SetFiltersDisabled(false) -- Disables faster CPU processing, so your score 
    --                                    improvements will be saved to foldit's undo history.
    l_ScoreWithPotentialBonusPoints = GetPoseTotalScore()
    
    --FilterOnScore = GetPoseTotalScore()
    --print("FilterOnScore: " .. FilterOnScore)    
    
	end	
  
  -- debugging...
  --l_ScoreWithPotentialBonusPoints =
  --  l_ScoreWithPotentialBonusPoints + 500
		
  -- Compute the maximum potential bonus points (not available in beginner puzzles)
	g_ComputedMaximumPotentialBonusPoints = 
    l_ScoreWithPotentialBonusPoints - l_ScoreWithoutPotentialBonusPoints
  -- Used in DefineGlobalVariables() and DisplayPuzzleProperties()
		
  g_UserSelected_MaximumPotentialBonusPoints = g_ComputedMaximumPotentialBonusPoints
  --  Used in AskUserToSelectConditionCheckingOptions() and SaveBest()
	
	g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun = false -- Enable Normal Checking
  -- Used in 4 functions
	-- If normal condition checking is disabled (i.e, set this variable to "true"), then faster CPU
  -- processing is enabled, but your score improvements will not be counted in foldit's Undo history.
  
  --if math.abs(g_UserSelected_MaximumPotentialBonusPoints) > 0.1 then
  if g_UserSelected_MaximumPotentialBonusPoints > 0 then
    -- Normally, we only get here if bonus points HAVE already been earned.
    -- Example puzzles where this occurs:
    --  1801: Revisiting Puzzle 93: Spider Toxin: Score including bonus: 8300; without: 8050; bonus: 250
    -- There does not appear to be a way to detect potential bonus points to be earned. ???
    -- However, for some puzzles, we detect potential bonus points that have not yet been earned.
    -- But, for some odd reason this script detects these unearned bonus points as already earned. Very odd!
    -- Example puzzles where this occurs:
    --  1805b Coronavirus, 
		print("\nCurrent score including bonus points, because some" ..
           " or all of the bonus conditions have already been met: " ..
             PrettyNumber(l_ScoreWithPotentialBonusPoints) ..
          "\n - Score without bonus points: " ..
             PrettyNumber(l_ScoreWithoutPotentialBonusPoints) ..
          "\n = Bonus points earned already: " ..
             g_UserSelected_MaximumPotentialBonusPoints)
  elseif g_UserSelected_MaximumPotentialBonusPoints < 0 then
    -- I don't know what to display here...
		print("\nPotential score, including bonus points," ..
           " when and if bonus conditions are met: " ..
             PrettyNumber(l_ScoreWithPotentialBonusPoints) ..
          "\n - Score without potential bonus points: " ..
             PrettyNumber(l_ScoreWithoutPotentialBonusPoints) ..
          "\n = Potential bonus points to gain," ..
           " when and if bonus conditions are met: " ..
             g_UserSelected_MaximumPotentialBonusPoints)
		
		g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun = true
    
		-- Ask user to verify maximum potential bonus points...
		AskUserToSelectConditionCheckingOptions()
	end
  
	if g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun == true then
		NormalConditionChecking_DisableForThisEntireScriptRun()
	end
  
  -- This was moved from above to take into account if condition checking is disabled for the entire
  -- script.
  g_Score_ScriptBest = GetPoseTotalScore()
  recentbest.Save() -- Foldit automatically remembers recentbest, creditbest and absolutebest from
                    -- the current **AND** from previous runs of the script **even if** you reset the puzzle!
                    -- Restoring a recentbest from a previous run of the script could be confusing
                    -- during testing and debugging of the same puzzle over and over again (e.g.; 
                    -- resetting the puzzle every time between script executions).
                    -- Therefore, we call recentbest.Save() to have the current score, whatever it is,
                    -- set as the recent best for this run of the script.
                    -- Although...perhaps we should restore the recentbest, or absolute best, at the 
                    -- beginning of each script run. This would prevent those super negative scores
                    -- we get when we abort in the middle of a script run and we forgot that we commented
                    -- out the xpcall() method of calling main().
                    -- Nah, again, restoring a previous best score after resetting a puzzle would make it
                    -- difficult to test some aspects of a single puzzle many times.
  save.Quicksave(3) -- Save
  
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
 	recentbest = {}
  absolutebest = {}

  g_Debug_NumberOfTimesWeCalled_RandomlyChange_g_Debug_CurrentEnergyScore = 0
  current.RandomlyChange_g_Debug_CurrentEnergyScore = function()
    -- This is not a foldit function. This function is only
    -- used by the following debug version of the foldit functions:
    -- MutateSidechainsSelected,MutateSidechainsAll,RebuildSelected,ShakeSidechainsAll,
    -- ShakeSidechainsSelected,WiggleAll,WiggleSelected
    
		-- Time to get a new random score..
		local l_EnergyScore = RandomFloat(-10000, 10000)
    
		if l_EnergyScore > g_Debug_ScriptBestEnergyScore then
      
			if g_Debug_ScriptBestEnergyScore ~= -999999 then -- allow the first score to be whatever.
      
        -- If not the first score, only allow small incremental improvements...
        -- However, if we are in the negative score region, allow larger improvements...
        if g_Debug_ScriptBestEnergyScore < 0 then
          l_EnergyScore = g_Debug_ScriptBestEnergyScore + RandomFloat(0, 1000)
				elseif l_EnergyScore - g_Debug_ScriptBestEnergyScore > 100 then
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
	absolutebest.Restore = function() return end -- could be helpful
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
      g_SegmentCount_WithoutLigands = g_SegmentCount_WithLigands - l_RandomishNumber
    end
      
		local l_bIsLigand = false
    local l_RandomSecondaryStructure
    if g_Debug_GetSecondaryStructure[l_SegmentIndex] == nil then
      if l_SegmentIndex > g_SegmentCount_WithoutLigands then
        l_RandomSecondaryStructure = 'M' -- 'M' for Molecule
        l_bIsLigand = true
        g_SegmentCount_WithoutLigands = g_SegmentCount_WithoutLigands + 1
      else
        l_SecondaryStructures = 'HELLLLLLLL' -- H=Helix, E=Sheet, L=Loop, M=Ligand
        l_RandomSecondaryStructure = RandomCharOfString(l_SecondaryStructures)
        -- For more realistic looking fake data, if the segment is not a ligand (already
        -- checked above) we only allow a segment to be either a Frozen, a Locked or a 
        -- Mutable segment. We do not allow them to be any two or more of these at the same
        -- time. In reality, I think any segment could be any one attribute and also be
        -- Frozen and/or Locked at the same time, but we'll ignore that for now. 
      end
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
	g_Debug_NumberOfTimesWeCalled_MutateSidechainsAll = 0
  structure.MutateSidechainsAll = function(l_Iterations)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_MutateSidechainsAll =
      g_Debug_NumberOfTimesWeCalled_MutateSidechainsAll + 1
      
    -- Let's arbitrarily set 10 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 10
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_MutateSidechainsAll
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
  end
  g_Debug_NumberOfTimesWeCalled_MutateSidechainsSelected = 0
	structure.MutateSidechainsSelected = function(l_Iterations) 
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_MutateSidechainsSelected =
      g_Debug_NumberOfTimesWeCalled_MutateSidechainsSelected + 1
      
    -- Let's arbitrarily set 10 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 10
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_MutateSidechainsSelected
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
  end
  
  g_Debug_NumberOfTimesWeCalled_RebuildSelected = 0
	structure.RebuildSelected = function(l_Iterations)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    
    -- Nevermind, the call to structure.RebuildSelected in production appears to always
    -- change the PoseTotalScore
    if 1 == 2 then
      g_Debug_NumberOfTimesWeCalled_RebuildSelected =
        g_Debug_NumberOfTimesWeCalled_RebuildSelected + 1
        
      -- Let's arbitrarily set 10 times to be the high-end of the number of times this function is called.
      local l_HighEnd = 10
      local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_RebuildSelected
      if l_TimesCalled > l_HighEnd * .88 then
        l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
      end    
      local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
      local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
      if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
        return -- no score change this time
      end 
      
    end -- if 1 == 2 then
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	structure.SetSecondaryStructureSelected = function(l_StringSecondaryStructure) return end
	g_Debug_NumberOfTimesWeCalled_ShakeSidechainsAll = 0
  structure.ShakeSidechainsAll = function(l_Iterations)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_ShakeSidechainsAll =
      g_Debug_NumberOfTimesWeCalled_ShakeSidechainsAll + 1
      
    -- Let's arbitrarily set 10 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 10
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_ShakeSidechainsAll
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
  g_Debug_NumberOfTimesWeCalled_ShakeSidechainsSelected = 0
	structure.ShakeSidechainsSelected = function(l_Iterations)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_ShakeSidechainsSelected =
      g_Debug_NumberOfTimesWeCalled_ShakeSidechainsSelected + 1
      
    -- Let's arbitrarily set 10 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 10
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_ShakeSidechainsSelected
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	
  g_Debug_NumberOfTimesWeCalled_WiggleAll = 0
  structure.WiggleAll = function(l_Iterations,l_bBackbone,l_bSideChains)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_WiggleAll =
      g_Debug_NumberOfTimesWeCalled_WiggleAll + 1
      
    -- Let's arbitrarily set 20 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 20
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_WiggleAll
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
    current.RandomlyChange_g_Debug_CurrentEnergyScore()
	end
	g_Debug_NumberOfTimesWeCalled_WiggleSelected = 0
  structure.WiggleSelected = function(l_Iterations,l_bBackbone,l_bSideChains)
    
    -- To make things more realistic...
    -- The more times this function is called the less likely we will 
    -- change the g_Debug_CurrentEnergyScore...
    g_Debug_NumberOfTimesWeCalled_WiggleSelected =
      g_Debug_NumberOfTimesWeCalled_WiggleSelected + 1
      
    -- Let's arbitrarily set 20 times to be the high-end of the number of times this function is called.
    local l_HighEnd = 20
    local l_TimesCalled = g_Debug_NumberOfTimesWeCalled_WiggleSelected
    if l_TimesCalled > l_HighEnd * .88 then
      l_TimesCalled = l_HighEnd * .88  -- 88% The change of staying is slim at 88 <= x <= 89.5
    end    
    local l_PercentOfMax = 100 * (l_TimesCalled / l_HighEnd)
    local l_RandomlyReturnWithNoChange = RandomFloat(l_PercentOfMax, 100)
    if l_RandomlyReturnWithNoChange > 89.5 then -- at least a 10% chance of no score change, and increasing
      return -- no score change this time
    end 
    
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
-- ...end of Setting Things Up.
-- Start of Ask and Display User Options...
function AskUserToCheckClashImportance() -- was CheckCI()
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
  
end -- function AskUserToCheckClashImportance()
function AskUserToSelectMoreOptions()
  -- called from AskUserToSelectRebuildOptions()...

	local l_Ask = dialog.CreateDialog("More Options")

	l_Ask.L_10 = dialog.AddLabel("Starting number of segment ranges to rebuild per")
	l_Ask.L_11 = dialog.AddLabel("run cycle:")
	l_Ask.g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		dialog.AddSlider("  Ranges / cycle:",
			g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle, 1,
      g_SegmentCount_WithoutLigands, 0)

	l_Ask.L_20 = dialog.AddLabel("Additional number of segment ranges to rebuild per")
	l_Ask.L_21 = dialog.AddLabel("run cycle after each run cycle completes:")
	l_Ask.g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle =
		dialog.AddSlider("  Add ranges:",
			g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle, 0, 4, 0)

	l_Ask.L_30 = dialog.AddLabel("Maximum number of rounds (with up to 3 attempts")
  l_Ask.L_31 = dialog.AddLabel("per round) to attempt to favorably change the")
  l_Ask.L_32 = dialog.AddLabel("protein structure using structure.RebuildSelected")
  l_Ask.L_33 = dialog.AddLabel("for each segment range per run cycle:") -- default is 15
	l_Ask.g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle =
		dialog.AddSlider("  Max Rounds:", 
      g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle, 1, 100, 0)
	
	l_Ask.L_90 = dialog.AddLabel("Reject each rebuild with a potential loss exceeding")
	l_Ask.L_92 = dialog.AddLabel("Points x segments per range / 3:") -- default is >= 30
  l_Ask.L_93 = dialog.AddLabel("(For example: 30 x 2 / 3 = 20)")
	l_Ask.g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints = 
		dialog.AddSlider("  Points:", 
      g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints, -5, 200, 0)

	l_Ask.L_40 = dialog.AddLabel("After Each Successful Rebuild:")
	l_Ask.L_41 = dialog.AddLabel("... shake segment range with clash importance:")
	l_Ask.g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance =
    dialog.AddSlider("", 
      g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance, 0, 1, 2)
  
	l_Ask.L_50 = dialog.AddLabel("... plus add 2xRegional plus 4xLocal Wiggles with")
	l_Ask.L_51 = dialog.AddLabel("side chains & backbone w/Clash Importance=1:")
    l_Ask.g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild =
		dialog.AddCheckbox("Very SLOW!",
			g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild)

	l_Ask.L_60 = dialog.AddLabel("Stabilize or simply Shake-n-Wiggle")
	l_Ask.L_61 = dialog.AddLabel("poses of selected score parts:")
	l_Ask.g_bUserSelected_StabilizePosesOfSelectedScoreParts =
    dialog.AddCheckbox("Stabilize", g_bUserSelected_StabilizePosesOfSelectedScoreParts)

	l_Ask.L_70 = dialog.AddLabel("Extra Stabilize (shake and wiggle even more)")
	l_Ask.L_71 = dialog.AddLabel("poses of selected score parts:")
	l_Ask.g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts =
		dialog.AddCheckbox("Extra Stabilize", g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts) -- default is false
  
	l_Ask.g_bUserSelected_FuseBestScorePartPose =
    dialog.AddCheckbox("Fuse best score part pose", g_bUserSelected_FuseBestScorePartPose)

	l_Ask.L_100 = dialog.AddLabel("Move on to more consecutive segments per range")
	l_Ask.L_101 = dialog.AddLabel("if current rebuild points gained is more than:")
	l_Ask.g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
		dialog.AddSlider("  Points:",
			g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan, 0, 500, 0)
      -- ...default is 40 or less (or more?).

	l_Ask.L_110 = dialog.AddLabel("Only allow rebuilding already rebuilt segments")
	l_Ask.L_111 = dialog.AddLabel("if current rebuild gain is more than:")
	l_Ask.g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints =
		dialog.AddSlider("  Points:",
			g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints, 0,
        500, 0) 
      -- ...default depends on number of segments.

	l_Ask.OK = dialog.AddButton("OK", 1)
	dialog.Show(l_Ask)

	g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle =
		l_Ask.g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle.value
	g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle =
		l_Ask.g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle.value
	
	g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle =
		l_Ask.g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle.value

	g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance =
    l_Ask.g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance.value
	
	g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild =
		l_Ask.g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild.value
    
	g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts =
    l_Ask.g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts.value
  -- ...default is false.
  
	g_bUserSelected_StabilizePosesOfSelectedScoreParts = 
    l_Ask.g_bUserSelected_StabilizePosesOfSelectedScoreParts.value
	g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints =
    l_Ask.g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints.value
  
	g_bUserSelected_FuseBestScorePartPose = l_Ask.g_bUserSelected_FuseBestScorePartPose.value

	g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan =
		l_Ask.g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan.value
    -- ...default is 40 or less.
    
	g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints =
  l_Ask.g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints.value

end -- AskUserToSelectMoreOptions()
function AskUserToSelectMutateOptions()
  -- Called from AskUserToSelectRebuildOptions()...

	local l_Ask = dialog.CreateDialog("Mutate Options")
	
	--l_Ask.l1 = dialog.AddLabel("Mutate after rebuild:")
	l_Ask.g_bUserSelected_MutateAfterRebuild =
    dialog.AddCheckbox("Mutate after rebuild selected segments",
      g_bUserSelected_MutateAfterRebuild)
	
	--l_Ask.l2 = dialog.AddLabel("Mutate during stabilize poses of selected score parts:")
	l_Ask.g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts =
		dialog.AddCheckbox("Mutate during stabilize poses of selected score parts",
      g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts)
		
	--l_Ask.l3 = dialog.AddLabel("Mutate after stabilize poses of selected score parts:")
	l_Ask.g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts =
		dialog.AddCheckbox("Mutate after stabilize poses of selected score parts",
      g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts)
		
	--l_Ask.l4 = dialog.AddLabel("Mutate before fuse best score part pose:")
	l_Ask.g_bUserSelected_MutateBeforeFuseBestScorePartPose =
    dialog.AddCheckbox("Mutate before fuse best score part pose",
      g_bUserSelected_MutateBeforeFuseBestScorePartPose)
	
	--l_Ask.l5 = dialog.AddLabel("Mutate after fuse best score part pose:")
	l_Ask.g_bUserSelected_MutateAfterFuseBestScorePartPose =
    dialog.AddCheckbox("Mutate after fuse best score part pose",
      g_bUserSelected_MutateAfterFuseBestScorePartPose)

	l_Ask.l6 = dialog.AddLabel("What to mutate. Second option overrides first. ")
	l_Ask.l7 = dialog.AddLabel("If neither option is checked then mutate all segments.")
	l_Ask.g_bUserSelected_MutateOnlySelectedSegments =
		dialog.AddCheckbox("Mutate only the selected segments", g_bUserSelected_MutateOnlySelectedSegments)
	l_Ask.g_bUserSelected_MutateSelectedAndNearbySegments =
		dialog.AddCheckbox("Mutate selected and nearby segments",
      g_bUserSelected_MutateSelectedAndNearbySegments)
	l_Ask.l8 = dialog.AddLabel("Mutate sphere radius, Angstroms, for nearby segments")
	l_Ask.g_UserSelected_MutateSphereRadius =
		dialog.AddSlider("  Sphere Radius:", g_UserSelected_MutateSphereRadius, 3, 15, 0)
    -- ...default is 8 Angstroms.
	l_Ask.g_UserSelected_MutateClashImportance =
		dialog.AddSlider("  Clash Importance:", g_UserSelected_MutateClashImportance, 0.1, 1, 2)

	l_Ask.OK = dialog.AddButton("OK", 1) l_Ask.Cancel = dialog.AddButton("Cancel", 0)
	if dialog.Show(l_Ask) > 0 then
		g_bUserSelected_MutateAfterRebuild =
      l_Ask.g_bUserSelected_MutateAfterRebuild.value
		g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts =
      l_Ask.g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts.value
		g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts =
      l_Ask.g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts.value
		g_bUserSelected_MutateBeforeFuseBestScorePartPose =
      l_Ask.g_bUserSelected_MutateBeforeFuseBestScorePartPose.value
		g_bUserSelected_MutateAfterFuseBestScorePartPose =
      l_Ask.g_bUserSelected_MutateAfterFuseBestScorePartPose.value
		g_bUserSelected_MutateOnlySelectedSegments =
      l_Ask.g_bUserSelected_MutateOnlySelectedSegments.value
		g_bUserSelected_MutateSelectedAndNearbySegments =
      l_Ask.g_bUserSelected_MutateSelectedAndNearbySegments.value
		if g_bUserSelected_MutateSelectedAndNearbySegments == true then
			-- The g_bUserSelected_MutateSelectedAndNearbySegments option 
      -- overrides the g_bUserSelected_MutateOnlySelectedSegments option...
			g_bUserSelected_MutateOnlySelectedSegments = false
		end
		g_UserSelected_MutateSphereRadius = l_Ask.g_UserSelected_MutateSphereRadius.value
		g_UserSelected_MutateClashImportance = l_Ask.g_UserSelected_MutateClashImportance.value

	end

end -- AskUserToSelectMutateOptions()
function AskUserToSelectRebuildOptions() -- was AskDRWOptions()
  -- Called from Rebuild1PuzzleForManyRuns() was DRW()
  -- Calls AskUserToSelectSegmentsRangesToRebuild() -- was AskForSelections()
  -- Calls AskUserToSelectMutateOptions()
  
	local l_bUserWantsToSelectSegmentsToRebuild = false
	--local l_bUserWantsToSelectSegmentsToRebuild = true -- allows debugging offline

	local l_bUserWantsToSelectMutateOptions = false
	if g_NumberOfMutableSegments > 0 then
		l_bUserWantsToSelectMutateOptions = true
	end
  
	local l_AskResult = 0
  
	repeat
    
		local l_Ask = dialog.CreateDialog("Select Rebuild Options")    
    
		l_Ask.L10 = dialog.AddLabel("Skip the first X number of segments ranges. User")
    l_Ask.L11 = dialog.AddLabel("usually sets this value after a script crashes, or")
    l_Ask.L12 = dialog.AddLabel("the power goes out.")
		l_Ask.g_UserSelected_NumberOfSegmentRangesToSkip = dialog.AddSlider("  X segments:",
				g_UserSelected_NumberOfSegmentRangesToSkip, 0, g_SegmentCount_WithoutLigands, 0)
    
		l_Ask.L20 = dialog.AddLabel("Maximum number of full run cycles:")
		l_Ask.g_UserSelected_NumberOfRunCycles = 
      dialog.AddSlider("  Run cycles:", g_UserSelected_NumberOfRunCycles, 1, 40, 0)
    
		l_Ask.L30 =
			dialog.AddLabel("Number of consecutive segments to rebuild per run:")
		l_Ask.g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments =
			dialog.AddSlider("  Start run with:",
				g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments, 1, 10, 0)
		l_Ask.g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments =
			dialog.AddSlider("  End run after:",
				g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments, 1, 10, 0)
      
		l_Ask.l_bUserWantsToSelectSegmentsToRebuild =
			dialog.AddCheckbox("Select Segments to Rebuild...", l_bUserWantsToSelectSegmentsToRebuild)
      
		l_Ask.bUserWantsToSelectScorePartsForCalculatingWorseScoringSegments =
			dialog.AddCheckbox("Select ScoreParts for calculating worst scoring", false)
		l_Ask.L40 = dialog.AddLabel("      segments...")
      
    if g_OriginalNumberOfDisulfideBonds > 1 then
			l_Ask.g_bUserSelected_KeepDisulfideBondsIntact = 
				dialog.AddCheckbox("Keep disulfide bonds intact", g_bUserSelected_KeepDisulfideBondsIntact)
		end
      
    l_Ask.g_bUserSelected_DisableBandsDuringRebuild =
			dialog.AddCheckbox("Disable bands during rebuild", g_bUserSelected_DisableBandsDuringRebuild)      
      
		l_Ask.g_bUserSelected_ConvertAllSegmentsToLoops =
			dialog.AddCheckbox("Convert all segments to loops", g_bUserSelected_ConvertAllSegmentsToLoops)
      
		l_Ask.L50 = dialog.AddLabel("Select ScoreParts for Stabilize Poses of Selected")
		l_Ask.L51 = dialog.AddLabel("ScoreParts, last choice overrides:")
		l_Ask.g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts =
      dialog.AddCheckbox("Select all ScoreParts",
        g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts)
		l_Ask.g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts =
			dialog.AddCheckbox("Select the top 4 scoring ScoreParts (faster)",
        g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts)
		l_Ask.g_bUserSelected_ScorePartsFromAListForStabilizePosesOfSelectedScoreParts =
      dialog.AddCheckbox("Select ScoreParts from a list...", false)
    
    l_Ask.g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments =
      dialog.AddCheckbox("During Stabilize and Fuse, shake and ",
        g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments)   
    l_Ask.L60 = dialog.AddLabel("      wiggle selected AND nearby segments.")
      
		if g_NumberOfMutableSegments > 0 then
			l_Ask.l_bUserWantsToSelectMutateOptions =
				dialog.AddCheckbox("Select Mutate Options...", l_bUserWantsToSelectMutateOptions)
		end
    
		l_Ask.L70 = dialog.AddLabel("Wiggle more when Clash Importance is maximum:")
		l_Ask.g_UserSelected_WiggleFactor = 
      dialog.AddSlider("  WiggleFactor:", g_UserSelected_WiggleFactor, 1, 5, 0)
		
		if g_bSketchBookPuzzle == true then
			l_Ask.L80 = dialog.AddLabel("For a sketch book puzzle:")
			l_Ask.L81 = dialog.AddLabel("Save the current pose if the")
			l_Ask.L82 = dialog.AddLabel("current rebuild gain is more than:")
			l_Ask.g_UserSelected_SketchBookPuzzle_MinimumGainForSave =
				dialog.AddSlider("  Points:",
					g_UserSelected_SketchBookPuzzle_MinimumGainForSave, 0, 100, 0)
		end
    
		l_Ask.g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments =
      dialog.AddCheckbox("Always allow rebuilding already rebuilt",
			g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments)
    l_Ask.L90 = dialog.AddLabel("      segments")
      
		l_Ask.AskResult1 = dialog.AddButton("OK", 1)
		l_Ask.AskResult0 = dialog.AddButton("Cancel", 0)
		l_Ask.AskResult2 = dialog.AddButton("More options", 2)
    
		l_AskResult = dialog.Show(l_Ask)
		if l_AskResult > 0 then -- 0 = Cancel
      
			-- Number of segment ranges to skip
      g_UserSelected_NumberOfSegmentRangesToSkip =
        l_Ask.g_UserSelected_NumberOfSegmentRangesToSkip.value
      
      -- Number of run cycles...
			g_UserSelected_NumberOfRunCycles =
        l_Ask.g_UserSelected_NumberOfRunCycles.value
      
      -- Start rebuilding with this many consecutive segments...
			g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments =
        l_Ask.g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments.value
        
      -- Reset to start value after rebuilding with this many consecutive segments
			g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments =
        l_Ask.g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments.value
        
      l_bUserWantsToSelectSegmentsToRebuild = l_Ask.l_bUserWantsToSelectSegmentsToRebuild.value
      
			if l_bUserWantsToSelectSegmentsToRebuild == true then
        
				-- l_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
				local l_SegmentRangesToRebuildTable = {}
				l_SegmentRangesToRebuildTable = 
        
      -- User wants to select segments to rebuild...
      -- User wants to select segments to rebuild...
      -- User wants to select segments to rebuild...
          AskUserToSelectSegmentsRangesToRebuild() -- was AskForSelections()
      -- User wants to select segments to rebuild...
      -- User wants to select segments to rebuild...
      -- User wants to select segments to rebuild...          
          
				if l_SegmentRangesToRebuildTable ~= nil and #l_SegmentRangesToRebuildTable ~= 0 then
					g_UserSelected_SegmentRangesAllowedToBeRebuiltTable = l_SegmentRangesToRebuildTable
           -- ...was WORKON[]
				end
        
				print("  User Selected Segment Ranges [" ..
          ConvertSegmentRangesTableToListOfSegmentRanges(
          g_UserSelected_SegmentRangesAllowedToBeRebuiltTable) .. "]")
        
				l_bUserWantsToSelectSegmentsToRebuild = false -- this will turn off the check box on the top menu
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
        
      end
      
      -- User wants to select ScoreParts for calculating worse scoring segments...
      -- Note: The following 2 ScorePart options are NOT related (atleast, not directly):
      --   1)  "Select ScoreParts for calculating worse segments":
      --       This selection gets used before we even start rebuilding segment ranges. 
      --       In fact, it helps determine which segments to include in the segment 
      --       ranges to rebuild.
      --   2)  "Select ScoreParts for StabilizePosesOfSelectedScoreParts":
      --       This selected gets used after one segment range has been rebuilt many 
      --       times and we are determining which single rebuild pose, of the many rebuilt,
      --       to futher Stabilize and Fuse (Mutate, Shake and Wiggle) for more points.
      if l_Ask.bUserWantsToSelectScorePartsForCalculatingWorseScoringSegments.value == true then
        
				AskUserToSelectScorePartsForCalculatingWorseScoringSegments() -- was AskSelScores()
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
        
      end
      
      -- Keep disulfide bonds intact...
			if g_OriginalNumberOfDisulfideBonds > 1 then
				g_bUserSelected_KeepDisulfideBondsIntact = l_Ask.g_bUserSelected_KeepDisulfideBondsIntact.value
			end
      
      -- Disable bands during rebuild...
			g_bUserSelected_DisableBandsDuringRebuild =
        l_Ask.g_bUserSelected_DisableBandsDuringRebuild.value
      
      -- Convert all segments to loops...
			g_bUserSelected_ConvertAllSegmentsToLoops =
        l_Ask.g_bUserSelected_ConvertAllSegmentsToLoops.value      
      
      -- Select ScoreParts for StabilizePosesOfSelectedScoreParts...
      --   These selected ScoreParts are used after one segment range has been rebuilt many 
      --   times and we are determining which single rebuild pose, of the many rebuilt,
      --    to futher Stabilize and Fuse (Mutate, Shake and Wiggle) for more points.
			if g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts ~=
        l_Ask.g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts.value then
        
				g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts =
          l_Ask.g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts.value
        
        if g_bUserSelected_AllScorePartsForStabilizePosesOfSelectedScoreParts == true then
        
          -- This only gets triggered when the user:
          -- 1) Unchecks the Select all ScoreParts for StabilizePosesOfSelectedScoreParts checkbox
          -- 2) Switches to a differnt selection page
          -- 3) Comes back to this selection page, re-checks this checkbox and clicks OK         
          
          -- User selected all ScoreParts (slots) for StabilizePosesOfSelectedScoreParts...
          -- g_ScorePartsTable={ScorePart_Number=1,ScorePart_Name=2,l_bScorePart_IsActive=3,LongName=4}
          for l_ScorePartsTableIndex=1, #g_ScorePartsTable do
            -- Update the g_ScorePartsTable...
            g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = true
          end
        end
			end
      
      -- Select the Top 4 Scoring ScoreParts for StabilizePosesOfSelectedScoreParts...
			if g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts ~=
        l_Ask.g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts.value then
        
				g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts =
          l_Ask.g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts.value
        
				if g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts == true then
          
          print("\nUser selected the following top 4 scoring ScoreParts for Stabilize Poses of Selected" ..
            " Score Parts:")
          
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
              print("  ".. l_ScorePart_Name)        
						else
							g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = false
						end
					end
				end
			end
      
      -- Select ScoreParts from a list for Stabilze...
			if l_Ask.g_bUserSelected_ScorePartsFromAListForStabilizePosesOfSelectedScoreParts.value == true then
        
        g_bUserSelected_ScorePartsFromAListForStabilizePosesOfSelectedScoreParts = true
      
        AskUserToSelectScorePartsForStabilizePosesOfSelectedScoreParts() 
        if l_AskResult == 1 then -- 1 = OK
          l_AskResult = 4 -- 4 = Go back to top menu
        end
			end
      
      -- During Stabilize and Fuse, shake and wiggle selected AND nearby segments...
			g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments =
        l_Ask.g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments.value
        
			if g_NumberOfMutableSegments > 0 then
        
				if l_Ask.l_bUserWantsToSelectMutateOptions.value == true then
					AskUserToSelectMutateOptions()
          DisplayUserSelectedMutateOptions()
          
					l_bUserWantsToSelectMutateOptions = false -- unchecks the "Select Mutate Options" checkbox
					if l_AskResult == 1 then -- 1 = OK
						l_AskResult = 4 -- 4 = Go back to top menu
					end
				end
			end
      
      -- Wiggle Factor...
      g_UserSelected_WiggleFactor = l_Ask.g_UserSelected_WiggleFactor.value
      
      -- SketchBook puzzle minimum gain for save...
      if g_bSketchBookPuzzle == true then
				g_UserSelected_SketchBookPuzzle_MinimumGainForSave = 
					ask.g_UserSelected_SketchBookPuzzle_MinimumGainForSave.value
			end
      
      -- Always allow rebuilding already rebuilt segments...
			g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments =
        l_Ask.g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments.value
      
      -- More Options button was pressed...
			if l_AskResult == 2 then
				AskUserToSelectMoreOptions()
			end
      
		end -- if l_AskResult > 0 then
    
	until l_AskResult < 2 -- 0 = Cancel, 1 = OK, 2 = More Options, 3 = ?, 4 = Go back to top menu

	-- Cancel or OK was pressed...
	local l_bOkayToContinue = false
	if l_AskResult == 1 then -- 0 = Cancel, 1 = OK
		l_bOkayToContinue = true
	end

	return l_bOkayToContinue

end -- AskUserToSelectRebuildOptions() -- was AskDRWOptions()
function AskUserToSelectScorePartsForCalculatingWorseScoringSegments() -- was AskSelScores()
  -- Called from AskUserToSelectRebuildOptions()...

  local l_title = "Calculating worst scoring segments"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("Select ScoreParts for calculating worst scoring")
	l_Ask.l2 = dialog.AddLabel("segments:")
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
  
	g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable = {}

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
        
        local l_TableCount = #g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable
        
				g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable[l_TableCount + 1] =
					string.gsub(l_ScorePart_Name, "*", "")
          
          --print("l_ScorePart_Name without asterisk:" .. l_ScorePart_Name)
			end
      
		end    
    
    print("\nUser Selected the following ScoreParts for calculating worst scoring segments:")
    local l_ScorePart_Name
    -- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
    for l_TableIndex = 1, #g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable do 
      l_ScorePart_Name = g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable[l_TableIndex]
      print("  ".. l_ScorePart_Name)
    end
    
	end

end -- AskUserToSelectScorePartsForCalculatingWorseScoringSegments()
function AskUserToSelectScorePartsForStabilizePosesOfSelectedScoreParts() -- was AskSubScores()
  -- Called from AskUserToSelectRebuildOptions()...

	local l_title = "Select ScoreParts for Stabilize Score Part Poses"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("After rebuilding each segment range several times,")
  l_Ask.l2 = dialog.AddLabel("select the best scoring poses of each of the below")
  l_Ask.l3 = dialog.AddLabel("selected ScoreParts to Stabilize (shake and wiggle)")
  l_Ask.l4 = dialog.AddLabel("for possibly more score gains:")
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
    
    print("\nUser selected the following ScoreParts for Stabilize Score Part Poses:")
    
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
      
      if l_Ask[l_ScorePart_Name].value == true then 
        print("  ".. l_ScorePart_Name)        
      end 
		end
    
	end

end -- AskUserToSelectScorePartsForStabilizePosesOfSelectedScoreParts()
function AskUserToSelectSegmentsRangesToRebuild() -- was AskForSelections()
  -- Called from AskUserToSelectRebuildOptions() was AskDRWOptions()

	title = "Select Segment Ranges To Rebuild"

	-- g_XLowestScoringSegmentRangesTable={StartSegment, EndSegment} -- was WORKON[]
	l_ListOfSegmentRanges = 
    ConvertSegmentRangesTableToListOfSegmentRanges(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable)
  -- e.g.;  "1-3 2-4 6-8 10-11 13-15 20-24" 
	
	local l_SegmentRangesToRebuildTable = g_UserSelected_SegmentRangesAllowedToBeRebuiltTable
  -- ...was WORKON[]

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
							l_SegmentsTable[l_SegmentIndex] > g_SegmentCount_WithLigands then -- ok w/ligands. no biggie.
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

end -- AskUserToSelectSegmentsRangesToRebuild()
function AskUserToSelectConditionCheckingOptions()
  -- Called from DefineGlobalVariables()...
	local l_Ask = dialog.CreateDialog("Bonus points detected")
	l_Ask.g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun = 
    dialog.AddCheckbox("Disable normal condition checking this",
    g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun)
	l_Ask.L_100 = dialog.AddLabel("          entire script run")
	l_Ask.L_110 = dialog.AddLabel("Computed maximum potential bonus points: " ..
    g_UserSelected_MaximumPotentialBonusPoints)
	l_Ask.L_120 = dialog.AddLabel("If this is not the correct maximum potential bonus,")
  l_Ask.L_130 = dialog.AddLabel("enter the correct value here:")
  
	if g_UserSelected_MaximumPotentialBonusPoints < 0 then
		 g_UserSelected_MaximumPotentialBonusPoints = 0
	end
  
	l_Ask.UserSelected_MaximumPotentialBonusPoints = 
    dialog.AddTextbox("Set Max Bonus:", g_UserSelected_MaximumPotentialBonusPoints)
  l_Ask.L_200 = dialog.AddLabel("Design puzzles typically include several conditions.")
  l_Ask.L_210 = dialog.AddLabel("If all conditions are met then any potential penalty")
  l_Ask.L_220 = dialog.AddLabel("points (negative points) are removed from your score")
  l_Ask.L_230 = dialog.AddLabel("and any potential bonus points are added to your")
  l_Ask.L_240 = dialog.AddLabel("score. Evaluating these conditions can slow down")
  l_Ask.L_250 = dialog.AddLabel("shake, wiggle, and other operations. 'Disable normal")
  l_Ask.L_260 = dialog.AddLabel("condition checking this entire script run' disables")
  l_Ask.L_270 = dialog.AddLabel("condition checking as much as possible to speed up the")
  l_Ask.L_280 = dialog.AddLabel("rebuild process. While condition checking is disabled")
  l_Ask.L_290 = dialog.AddLabel("our current score is only a 'potential-score-if-all-")
  l_Ask.L_300 = dialog.AddLabel("conditions-are-met'. We won't know our actual score")
  l_Ask.L_310 = dialog.AddLabel("until we re-enable condition checking, to see if the")
  l_Ask.L_320 = dialog.AddLabel("conditions are met. The value in 'Set Max Bonus'")
  l_Ask.L_330 = dialog.AddLabel("shows the potential bonus (if all conditions are")
  l_Ask.L_340 = dialog.AddLabel("met), or zero if there's currently a penalty. The")
  l_Ask.L_350 = dialog.AddLabel("'Set Max Bonus' value determines when to re-enable")
  l_Ask.L_360 = dialog.AddLabel("condition checking. Once our current score (with")
  l_Ask.L_370 = dialog.AddLabel("condition checking disabled) plus the Set Max Bonus")
  l_Ask.L_380 = dialog.AddLabel("value is greater than the last saved real best score,")
  l_Ask.L_390 = dialog.AddLabel("we will re-enable condition checking and hopefully")
  l_Ask.L_400 = dialog.AddLabel("we will realize the loss of penalties points and the")
  l_Ask.L_410 = dialog.AddLabel("gain of bonus points. The script current best score is")
  l_Ask.L_420 = dialog.AddLabel("only updated when condition checking is enabled.")
  
	l_Ask.continue = dialog.AddButton("Continue", 1)
	dialog.Show(l_Ask)
	g_UserSelected_MaximumPotentialBonusPoints = 
    l_Ask.UserSelected_MaximumPotentialBonusPoints.value
    
	if g_UserSelected_MaximumPotentialBonusPoints == "" then
		g_UserSelected_MaximumPotentialBonusPoints = 0
	end
  
	g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun =
    l_Ask.g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun.value
    
end -- function AskUserToSelectConditionCheckingOptions()
function DisplayPuzzleProperties()
  -- Called from Rebuild1PuzzleForManyRuns()...

  -- Puzzle name and ID...
	print("  Puzzle name: " .. puzzle.GetName() .. "")
	print("  Puzzle ID: " .. puzzle.GetPuzzleID() .. "")
	-- print("  Puzzle description: [" .. puzzle.GetDescription() .. "]")

  -- Is this a sketchbook puzzle...
  if g_bSketchBookPuzzle == true then
		print("Note: This is a Sketchbook Puzzle.")
  end
  
  -- Is this considered a design puzzle...
	local l_HalfOfTheProteinSegments
	l_HalfOfTheProteinSegments = g_SegmentCount_WithoutLigands / 2
	if g_NumberOfMutableSegments > l_HalfOfTheProteinSegments then
		g_bFreeDesignPuzzle = true
		print("  Since more than half of the protein's segments are mutable, " ..
             g_NumberOfMutableSegments .." of " .. g_SegmentCount_WithoutLigands ..
          ", this is considered a design puzzle.")
	end

	-- Find out if the puzzle has any disulfide bonds...
	Populate_g_CysteineSegmentsTable()
	if #g_CysteineSegmentsTable > 1 then
		print("  Puzzle has " .. #g_CysteineSegmentsTable .. " cysteine segments.")
		if g_OriginalNumberOfDisulfideBonds > 0 then
			print("  Puzzle has " .. g_OriginalNumberOfDisulfideBonds .. " disulfide bonds.")
			g_bUserSelected_KeepDisulfideBondsIntact = true -- so much for the user deciding...
		end
	end
  -- Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment)
	local l_Score_TotalOfAllSegmentsIncludingLigands =
    Calculate_SegmentRange_Score(nil, 1, g_SegmentCount_WithLigands) -- w/ligands?
	-- print("l_Score_TotalOfAllSegmentsIncludingLigands=
  --  [" .. l_Score_TotalOfAllSegmentsIncludingLigands .. "]")

	-- Find out if the puzzle has Density scores and their weight if any...
  -- Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment)
	local l_DensityTotal = Calculate_SegmentRange_Score("density", nil, nil)
	-- print("l_DensityTotal=[" .. l_DensityTotal .. "]")

	g_bHasDensity = math.abs(l_DensityTotal) > 0.0001
	-- print("g_bHasDensity=[" .. tostring(g_bHasDensity) .. "]")

  local l_Current_PoseTotalScore = GetPoseTotalScore()
	if g_bHasDensity == true then
    -- How was this formula derived? What if PoseTotalScore is negative?
    if l_Current_PoseTotalScore > 0 then
      g_DensityWeight = 
        (l_Current_PoseTotalScore 
       - g_ComputedMaximumPotentialBonusPoints
       - l_Score_TotalOfAllSegmentsIncludingLigands
       - 8000)
       / l_DensityTotal
    end
		print("  Puzzle has Density scores. The density weight = " .. 
      PrettyNumber(g_DensityWeight) .. " points")
	end

	-- Check if this is likely a symmetry puzzle...
	if g_bHasDensity == false then    
		local l_ComputedScore = 
      math.abs(l_Current_PoseTotalScore
             - l_Score_TotalOfAllSegmentsIncludingLigands
             - 8000) -- why 8000?
		-- print("PoseTotalScore " .. PrettyNumber(l_Current_PoseTotalScore ) .. 
    --      " ComputedScore " .. PrettyNumber(l_ComputedScore) .. "")
		g_bProbableSymmetryPuzzle = l_ComputedScore > 2
		if g_bProbableSymmetryPuzzle == true then
			print("  Puzzle is a symmetry puzzle or has bonuses")
		end
	end
  
	if g_bHasLigand == true then
    print("  Puzzle has a ligand (small extra molecule near the protein)." ..
           " Ligand scoring is active in ScorePart (slot) 6.")
  end 
  
  print("  Starting score " .. PrettyNumber(l_Current_PoseTotalScore))

end -- DisplayPuzzleProperties()
function DisplayUserSelectedMutateOptions()
        
  print("\nUser Selected Mutate Options:\n")
        
  local l_Message = "  When to Mutate:"
  if g_bUserSelected_MutateAfterRebuild == true then
    l_Message = l_Message .. " [After each Rebuild]" end
  if g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts == true then
    l_Message = l_Message .. " [During StabilizePosesOfSelectedScoreParts]" end
  if g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts == true then
    l_Message = l_Message .. " [After StabilizePosesOfSelectedScoreParts]" end
  if g_bUserSelected_MutateBeforeFuseBestScorePartPose == true then
    l_Message = l_Message .. " [Before FuseBestScorePartPose]" end
  if g_bUserSelected_MutateAfterFuseBestScorePartPose == true then
    l_Message = l_Message .. " [After FuseBestScorePartPose]" end
  print(l_Message)

  l_Message = "  Mutate area: "
  if g_bUserSelected_MutateOnlySelectedSegments == true then
    l_Message = l_Message .. "Only the selected segments."
  elseif g_bUserSelected_MutateSelectedAndNearbySegments == true then
    l_Message = l_Message .. "The selected and near by segments within a radius of " ..
      g_UserSelected_MutateSphereRadius .. " Angstroms."
  else
    l_Message = l_Message .. "The entire protein."
  end
  print(l_Message)

end -- function DisplayUserSelectedMutateOptions()
function DisplayUserSelectedOptions() -- was printOptions()
  -- Called from Rebuild1PuzzleForManyRuns() was DRW()

	print("\nUser Selected Rebuild Options:\n")

	-- print("  Number of full run cycles: " .. g_UserSelected_NumberOfRunCycles .. "")

	if g_UserSelected_NumberOfSegmentRangesToSkip > 0 then
		print("  User selected to skip the first " .. g_UserSelected_NumberOfSegmentRangesToSkip ..
           " lowest scoring segment ranges." ..
           " The user usually sets this value after a script crashes or a power outage.")
	end

	--print("  Start Rebuilding With This Many Consecutive Segments: " ..
	--	g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments) -- default = 2
	--print("  Reset To Start Value After Processing With This Many Consecutive Segments: " ..
	--	g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments) -- default = 4

	-- print("  Maximum number of rounds (with up to 3 attempts per round) to attempt to favorably change" ..
  --  " the protein structure using structure.RebuildSelected() for each segment range per run cycle: " ..
	--	g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle)

  if g_OriginalNumberOfDisulfideBonds > 1 then
    if g_bUserSelected_KeepDisulfideBondsIntact == true then
      print("  User selected to keep disulfide bonds intact.")
    else
      print("  User did not select to keep disulfide bonds intact.")
    end 
  end

  if g_bUserSelected_DisableBandsDuringRebuild == true then
    print("  User selected to disable bands during rebuild.")
  else
    print("  User did not select to disable bands during rebuild.")
  end

	if g_bUserSelected_ConvertAllSegmentsToLoops == true then
		print("  User selected to convert all segments to loops.")
  else
    print("  User selected to not convert all segments to loops.")
	end

	print("  User selected to shake segment range with clash importance " .. 
          g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance ..
        " after each rebuild.") 
        
  -- Lets amplify the iterations for a bigger effect...
  local l_Iterations = 1
	local l_WiggleFactor = 1
	if g_bMaxClashImportance == true then
		l_WiggleFactor = g_UserSelected_WiggleFactor
	end
	l_Iterations = 2 * l_WiggleFactor * l_Iterations
  
	if g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild == true then
    
		print("  User selected to add " .. (2 * l_Iterations) .. "xRegional plus " ..
            (4 * l_Iterations) .. "xLocal Wiggles w/SideChains & Backbone," ..
           " w/Clash Importance = 1.0 after each Rebuild; Will be very slow!")
	end
  
  if g_bUserSelected_TheTop4ScoringScorePartsForStabilizePosesOfSelectedScoreParts == true then
    print("  User selected the top 4 scoring ScoreParts for StabilizePosesOfSelectedScoreParts.")
  elseif g_bUserSelected_ScorePartsFromAListForStabilizePosesOfSelectedScoreParts == true then
    print("  User selected ScoreParts from a list for StabilizePosesOfSelectedScoreParts.")
  else
    print("  User selected all ScoreParts for StabilizePosesOfSelectedScoreParts.")
  end
  
	if g_bUserSelected_StabilizePosesOfSelectedScoreParts == true then
    print("  User selected StabilizePosesOfSelectedScoreParts w/1xShakeSelected and " ..
      (3 * l_Iterations) .. "xWiggleAll.")
  else
    print("  User selected simple ShakeAndWiggle: w/1xShakeSelected and " .. l_Iterations ..
      "xWiggleSelected.")
	end
  
	if g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts == true then
    print("  User selected Extra StabilizePosesOfSelectedScoreParts w/" .. l_Iterations ..
      "xWiggleAll and 1xShakeSelected.")
  end 
  
  if g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments == false then
    
		print("  User selected to shake and wiggle only selected segments during Stabilize and Fuse.")        
  else
		print("  User selected to shake and wiggle selected AND nearby segments during" ..
           " Stabilize and Fuse. Slow!")     
  end

	if g_bUserSelected_FuseBestScorePartPose == true then
		print("  User selected to Fuse best score part pose of each segment range.")
  else
		print("  User selected not to Fuse best score part pose of each segment range.")
	end

	if g_UserSelected_WiggleFactor > 1 then
		print("  User selected a Wiggle Factor of " .. g_UserSelected_WiggleFactor .. "")
	end

	if g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments == true then
		print("  User selected to always allow rebuilding already rebuilt segments" ..
           " without regard to number of points gained from rebuild.")
	else
		print("  User selected to only allow rebuilding already rebuilt segments" ..
					" if current rebuild gain is more than " ..
          g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints ..
          " points.")
	end

end -- DisplayUserSelectedOptions()
-- ...end of Ask and Display User Options.
-- Start of Support Functions...
function Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable() -- was FindAreas()
  -- Called from Rebuild1RunWithManySegmentRangeSets() when l_How = 'segments'
  
	if g_bRebuildLoopsOnly == true then
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
function Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment) -- AddOther()
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
	-- g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments = 2
	-- g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments = 4
	local l_NumberofConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Make sure this segment range contains the minimum number of consecutive segments
	-- as require by the user. If not, we will just skip processing this segment range,
	-- and continue to look for segment ranges with enough segments as required...
	-- If we allowed segment ranges with less than the required minimum, we might end up
	-- rebuilding segment ranges of a single segment, which and that would not be efficient or practical...
	if l_NumberofConsecutiveSegments >= g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments then
		-- Not sure why we are using g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments here
		-- instead of g_RequiredNumberOfConsecutiveSegments. Things that make you go hmmm.
		-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2} -- was areas[]

		-- Add one row to the g_XLowestScoringSegmentRangesTable...
		g_XLowestScoringSegmentRangesTable[#g_XLowestScoringSegmentRangesTable + 1] =
      {l_StartSegment, l_EndSegment}
	end
  
	return l_EndSegment

end -- Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)
function Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment) -- was AddLoop()
  -- Called from Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()...

	-- Add mulitple loop segments in a SegmentRange to the g_XLowestScoringSegmentRangesTable...

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
	-- g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments = 2
	-- g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments = 4
	local l_RequiredNumberOfConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Add one row to the g_XLowestScoringSegmentRangesTable... formerlt areas[]
	if l_RequiredNumberOfConsecutiveSegments >=
    g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments then
    
		if g_bRebuildLoopsOnly == true then
			-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}
			g_XLowestScoringSegmentRangesTable[#g_XLowestScoringSegmentRangesTable + 1] =
        {l_StartSegment, l_EndSegment}
		end
	end
	return l_EndSegment

end -- Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)
function bIsADisulfideBondSegment(l_SegmentIndex)
  -- Called from DisulfideBonds_GetCount()...
  
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
function bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesTable)
  -- Called from ConvertSegmentRangesTableToSegmentsBooleanTable()...
  
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
function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)
  -- Called from bSegmentRangeIsAllowedToBeRebuilt()...

  -- g_bUserSelectd_SegmentsAllowedToBeRebuiltTable[] is populated in Rebuild1PuzzleForManyRuns() from 
  -- g_UserSelected_SegmentRangesAllowedToBeRebuiltTable[] which is is initially
  -- set to {{1, g_SegmentCount_WithoutLigands}} in DefineGlobalVariables() then
  -- the user can change this value in AskUserToSelectSegmentsRangesToRebuild()
  -- plus AskUserToSelectRebuildOptions(), and finally we remove all frozen,
  -- locked and ligand segments in Rebuild1PuzzleForManyRuns()...
  if g_bUserSelectd_SegmentsAllowedToBeRebuiltTable[l_SegmentIndex] == false then -- was WORKONbool[]
    --if g_FrozenLockedOrLigandSegmentsTable[l_SegmentIndex] == true then
		return false -- Note: this option overrides the below options.
	end

  if g_bUserSelected_AlwaysAllowRebuildingAlreadyRebuilt_Segments == true then
		return true
	end
  
  if g_CurrentRebuildPointsGained >
    g_UserSelected_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildGainIsMoreThanXPoints then
    -- g_CurrentRebuildPointsGained is added to in Rebuild1SegmentRangeSetWithManySegmentRanges()
    -- g_CurrentRebuildPointsGained is never reset to zero
    return true
  end
  
  if g_bSegmentsAlreadyRebuiltTable[l_SegmentIndex] == true then -- was Disj[]
    -- Don't rebuild already rebuilt segments until we run out of segments to
    -- rebuild. When we run out of segments to rebuild we will reset all segments
    -- in the g_bSegmentsAlreadyRebuiltTable to false.
    return false
  end
  
  -- This segment has not already been rebuilt and the user did
  -- not remove it on the "Select Segments to Rebuild" page...
  return true
  
end -- function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)
function bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment) -- was CheckDone(),MustWorkon
  -- Called from Populate_g_XLowestScoringSegmentRangesTable()
  
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
function Calculate_ScorePart_Score(l_ScorePart_Name, l_StartSegment, l_EndSegment) -- was getPartscore
  -- Called from Populate_g_XLowestScoringSegmentRangesTable() and
  --             Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()...
  
  -- I think this function could/should be merged into the more frequently used
  -- Calculate_SegmentRange_Score() function. No, don't do that. They each serve
  -- a different purpose. Just look at their names to see what each one does. And
  -- does well. 
  -- Okay, sure calling: 
  --  Calculate_ScorePart_Score(nil, l_StartSegment, l_EndSegment), 
  --    which uses g_SegmentScoresTable[l_SegmentIndex]
  --    might get the same result as calling:
  --  Calculate_SegmentRange_Score(nil, l_StartSegment, l_EndSegment),
  --    which uses current.GetSegmentEnergyScore(l_SegmentIndex)
  -- And calling:
  --  Calculate_ScorePart_Score("loctotal", l_StartSegment, l_EndSegment)
  --    is the same as calling...
  --  Calculate_SegmentRange_Score(nil, l_StartSegment, l_EndSegment)
  -- And calling:
  --  Calculate_ScorePart_Score("total", l_StartSegment, l_EndSegment)
  --    is the same as calling...
  --  Calculate_SegmentRange_Score(nil, nil, nil)
  -- And pretty much any call to 
  --  Calculate_ScorePart_Score() with a ScorePart_Name other than 'total', 'loctotal' and 'ligand',
  --    would be same as calling
  --  Calculate_SegmentRange_Score() with the same ScorePart_Name

	local l_ScorePart_Score = 0
    
	if l_ScorePart_Name == nil then
    
		-- Note: This "if" case is only called from 
    --       Populate_g_XLowestScoringSegmentRangesTable,
    --       and is only called with a very small range of segments, like 
    --       1-3, 2-4, 3-5 in the first run, then
    --       1-4, 2-5, 3-6 in the second run, and so on...
    
		for l_SegmentIndex = l_StartSegment, l_EndSegment do
      
			-- g_SegmentScoresTable = {SegmentScore}
			-- The only place that reads g_SegmentScoresTable is this function.
      -- The only place that updates g_SegmentScoresTable is 
      --    Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts.
      --
      -- Note: This is different than calling GetPoseTotalScore() because
      --       this is only for a small range of segments, not all segments...
			l_ScorePart_Score = l_ScorePart_Score + g_SegmentScoresTable[l_SegmentIndex]
		end
    
    return l_ScorePart_Score    
  end

	if l_ScorePart_Name == 'total' then
    
    -- Example usage: from Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields,
    --                when stepping through each ScorePart to update the ScorePart_Scores field...
		l_ScorePart_Score = GetPoseTotalScore()
    return l_ScorePart_Score    
    
  end
  
  if l_ScorePart_Name == 'loctotal' then --total segment scores
    -- Note: Calling...
    --        Calculate_ScorePart_Score("loctotal", l_StartSegment, l_EndSegment)
    --       is the same as calling...
    --        Calculate_SegmentRange_Score(nil, l_StartSegment, l_EndSegment)
    
		l_ScorePart_Score = Calculate_SegmentRange_Score(nil, l_StartSegment, l_EndSegment)
    return l_ScorePart_Score    
    
  end
    
  if l_ScorePart_Name == 'ligand' then --ligand score
    
		for l_SegmentIndex = g_SegmentCount_WithoutLigands + 1, g_SegmentCount_WithLigands do -- w/ligands!
			l_ScorePart_Score = l_ScorePart_Score + current.GetSegmentEnergyScore(l_SegmentIndex)
		end
    return l_ScorePart_Score    
    
	end 
  
  -- Example usage:
  -- 1) from Calculate_ScorePart_Score() with l_ScorePart_Name == 'Clashing' from
  --    Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
  --    when stepping through each ScorePart to update the ScorePart_Scores field...
  -- Geez, why didn't you just call Calculate_SegmentRange_Score directly? Well, we
  -- could have, but then Calculate_SegmentRange_Score would need to handle the
  -- above 'total', 'loctotal' and 'ligand' cases above. That would be easy to do.
  -- Just move those cases into Calculate_SegmentRange_Score, after the line that
  -- reads 'l_ScorePart_Name = l_ScorePart_NameOrTable'!!!
  -- Geez Calculate_SegmentRange_Score() could probably handle the one remaining
  -- case in this function where l_ScorePart_Name is nil. We just need to make sure
  -- 'g_SegmentScoresTable[l_SegmentIndex]' and 
  -- 'current.GetSegmentEnergyScore(l_SegmentIndex)' return the same value!
  l_ScorePart_Score = Calculate_SegmentRange_Score(l_ScorePart_Name, l_StartSegment, l_EndSegment)
	return l_ScorePart_Score

end
function Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment) -- GetSubScore
  -- was GetSubscore()
  -- Called from 1 place recursively in Calculate_SegmentRange_Score(),
  --             2 places inDisplayPuzzleProperties(),
  --             2 places in Calculate_ScorePart_Score(), 
  --             1 place in Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts() and 
  --             1 place in CheckForLowStartingScore()...

	-- Note: l_ScorePart_NameOrTable is optional, if it's nil we use
	--       GetSegmentEnergyScore instead of GetSegmentEnergySubscore.

	-- Note: l_ScorePart_NameOrTable can be either a single string, or a table of strings.

	-- Note: Each Segment can have up to 20 named ScoreParts.
	--       e.g.; 1=Clashing, 2=Pairwise, 3=Packing, Hiding, Bonding, Ideality, Backbone,
	--             Sidechain, Reference...

	local l_ScoreTotal = 0
	local l_ScorePart_Score = 0
	local l_ScorePart_Name = ""
  
  -- A table of ScoreParts was passed in...
	if type(l_ScorePart_NameOrTable) == "table" then
    -- Calculate the total score of a segment range, but
    -- only include the ScoreParts of the passed in list of ScoreParts...
		for l_ScorePart_NameOrTableIndex = 1, #l_ScorePart_NameOrTable do
			-- recursion...
			-- Call back with each ScorePart in the ScorePart_NameOrTable...
			l_ScorePart_Name = l_ScorePart_NameOrTable[l_ScorePart_NameOrTableIndex]
			l_ScorePart_Score = Calculate_SegmentRange_Score(l_ScorePart_Name, l_StartSegment, 
                                                       l_EndSegment)
			l_ScoreTotal = l_ScoreTotal + l_ScorePart_Score      
		end
    return l_ScoreTotal
  end 
  
  -- Nothing was passed in...
	if l_ScorePart_NameOrTable == nil and l_StartSegment == nil and l_EndSegment == nil then            
    -- Calculate the total score of all segment ranges and include all ScoreParts...
    -- I suspect if you ended up here, it was by accident (i.e., a coding error),
    -- because you should have just called GetPoseTotalScore(l_pose) directly instead!
    local l_Current_PoseTotalScore = GetPoseTotalScore(l_pose)
    return l_Current_PoseTotalScore
  end 
  
  if l_StartSegment == nil then
    -- Example usage: from DisplayPuzzleProperties() to calulate
    --                l_DensityTotal, where ScorePart_Name = "density"...
    l_StartSegment = 1
  end
  
  if l_EndSegment == nil then
    -- Example usage: from DisplayPuzzleProperties() to calulate
    --                l_DensityTotal, where ScorePart_Name = "density"...
    l_EndSegment = g_SegmentCount_WithLigands -- why w/ligands? Because, although we can't modify the
    --                                           ligand segments, we can and do get points from them.
  end
  
  if l_StartSegment > l_EndSegment then
    l_StartSegment, l_EndSegment = l_EndSegment, l_StartSegment
  end
  
  -- Only a segment range was passed in (no ScorePart)...
  if l_ScorePart_NameOrTable == nil then
    -- Examples usage:
    -- 1) from DisplayPuzzleProperties() to calculate:
    --    a) l__Score_TotalOfAllSegmentsIncludingLigands, which 
    --       is then used to compute g_DensityWeight, and
    --    b) l_ComputedScore, which is used to determine g_bProbableSymmetryPuzzle
    -- 2) from Calculate_ScorePart_Score() with l_ScorePart_Name == 'loctotal' from
    --    Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
    --    when stepping through each ScorePart to update the ScorePart_Scores field...
    for l_SegmentIndex = l_StartSegment, l_EndSegment do
      local l_SegmentEnergyScore = current.GetSegmentEnergyScore(l_SegmentIndex)
      l_ScoreTotal = l_ScoreTotal + l_SegmentEnergyScore
      -- print("current.GetSegmentEnergyScore(" .. l_SegmentIndex .. ")=[" ..
      --  current.GetSegmentEnergyScore(l_SegmentIndex) .. "]")
    end
    return l_ScoreTotal
  end
  
  -- Hopefully a ScorePart was passed in...
  l_ScorePart_Name = l_ScorePart_NameOrTable
  -- This time l_ScorePart_Name is not actually a table; 
  -- rather, it's just a single ScorePart_Name...
  -- Example usage:
  -- 1) from DisplayPuzzleProperties() to calulate
  --    l_DensityTotal, where ScorePart_Name = "density"...
  -- 2) from Calculate_ScorePart_Score() with l_ScorePart_Name == 'Clashing' from
  --    Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
  --    when stepping through each ScorePart to update the ScorePart_Scores field...
  for l_SegmentIndex = l_StartSegment, l_EndSegment do
    l_ScorePart_Score = current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name)
    l_ScoreTotal = l_ScoreTotal + l_ScorePart_Score
    -- print("current.GetSegmentEnergySubscore(" .. l_SegmentIndex .. "," .. l_ScorePart_Name .. ")=["
    --  .. current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name) .. "]")
  end
  
	return l_ScoreTotal

end -- Calculate_SegmentRange_Score(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment)
function CheckForLowStartingScore()
  -- Called from Rebuild1PuzzleForManyRuns()...

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
              " options of: 'Stabilize selected score part poses' and 'fuse best score part pose'.")
			return
		end
	end

	if l_Current_PoseTotalScore >= l_LowScore then
		return -- score is high enough for now...
  end

	print("\n  Since the starting score of " .. PrettyNumber(l_Current_PoseTotalScore) ..
         " is less than " .. l_LowScore .. " points, to speed things up, we will temporarily")
  print("  skip stabilizing all score part poses and fusing best score part pose" ..
         " until the score increases above " .. l_LowScore .. " points.")
	g_bUserSelected_FuseBestScorePartPose = false
	g_bUserSelected_StabilizePosesOfSelectedScoreParts = false

end -- function CheckForLowStartingScore()
function CheckIfAlreadyRebuiltSegmentsMustBeIncluded() -- was ChkDisjunctList()
  -- Called from Populate_g_XLowestScoringSegmentRangesTable() was FindWorst()
  -- Calls bSegmentIsAllowedToBeRebuilt()
  
  -- If we cannot find enough consecutive not-already-rebuilt segments available to meet
	-- the minimum, we will set all the entries in the g_bSegmentsAlreadyRebuiltTable to false.
  -- This will allow all already-rebuilt segments to be treated as not-already-rebuilt segments.
	-- Then, when we are forming segment ranges to rebuild, we will be able to meet the
	-- minimun number of consecutive segments per segment range required by the user.

	local l_ConsecutiveSegmentsCounter = 0
  local l_SegmentRangeCounter = 0
	for l_TableIndex = 1, g_SegmentCount_WithoutLigands do
    
    if bSegmentIsAllowedToBeRebuilt(l_TableIndex) == false then -- was used Disj[] table
			-- Since this segment is not allowed to be rebuilt, it cannot be
      -- counted as a consecutive segment. Start the counter over again...
			l_ConsecutiveSegmentsCounter = 0
      
		else
			l_ConsecutiveSegmentsCounter = l_ConsecutiveSegmentsCounter + 1
		end
    
		if l_ConsecutiveSegmentsCounter >= g_RequiredNumberOfConsecutiveSegments then
      
			-- Yay, another segment range with enough consecutive Segments to meet 
      -- the minimun required segments per segment range, despite having a bunch
      -- of already-rebuilt (or ineligable because they are frozen or locked) 
      -- segments in our way...
      -- Let's add this to our segment range counter and continue looking for more...
      l_SegmentRangeCounter = l_SegmentRangeCounter + 1
      
      if l_SegmentRangeCounter >= g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle then
        
			-- Yay, we have enough segments ranges to get started rebuilding. Let's return and get to it...
        return
        
      end
      
		end -- if l_ConsecutiveSegmentsCounter >= g_RequiredNumberOfConsecutiveSegments then
    
	end -- for l_TableIndex = 1, g_SegmentCount_WithoutLigands do

	-- Since there are not enough non-done segments in a row to meet the minimum, 
	-- let's set all the entries in the g_bSegmentsAlreadyRebuiltTable to false.
	-- This should give us plenty of segments to work with...
  -- Too much noise in the log file...
	print("Not enough consecutive not-already-rebuilt segments available to create a segment range;" ..
      "\ntherefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
       
  Reset_g_bSegmentsAlreadyRebuiltTable()
       
end -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
function bCheckIfFrozenLockedOrLigandSegment(l_SegmentIndex)
      
  -- Check if Frozen
  local l_bBackboneIsFrozen
  local l_bSideChainIsFrozen
  l_bBackboneIsFrozen, l_bSideChainIsFrozen = freeze.IsFrozen(l_SegmentIndex)
  
  if l_bBackboneIsFrozen == true or l_bSideChainIsFrozen == true then
    return true
  end
  
  -- Check if this is a Locked segment (the easiest to check)...
  if structure.IsLocked(l_SegmentIndex) == true then
    return true
  end

  -- Check if this is a Ligand segment...
	local l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)  --eg L,E,H,M
	if l_GetSecondaryStructureType == "M" then -- "M" for Molecule
    return true
  end
  
end -- function bCheckIfFrozenLockedOrLigandSegment(l_SegmentIndex)
function CleanUpSegmentRangesTable(l_SegmentRangesTable)
  -- Called from AskUserToSelectSegmentsRangesToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}

	-- This makes it well formed...
	local l_SegmentsTable = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
	local l_CleanedUpSegmentRangesTable = ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)

	return l_CleanedUpSegmentRangesTable

end -- function CleanUpSegmentRangesTable(l_SegmentRangesTable)
function ConvertAllSegmentsToLoops()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges()...

  -- Turn entire structure into loops...
  -- Remember loops are not helices. Loops are just plain swiggly lines...
  -- Why not just do this at the beginning and end of the script, instead
  -- of at the beginning and end of every Segment Range Set.

	local l_bFoundSomethingOtherThanALoopSegment = false

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		local l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
		if l_GetSecondaryStructureType ~= "L" then
			-- We have found at least one none loop segment...
			l_bFoundSomethingOtherThanALoopSegment = true
			break
		end
    
	end

	if l_bFoundSomethingOtherThanALoopSegment == true then
  
		save.SaveSecondaryStructure()  -- We reload this saved secondary structure at the end of 
    --                                Rebuild1SegmentRangeSetWithManySegmentRanges() with a 
    --                                call to save.LoadSecondaryStructure()
		g_bSavedSecondaryStructure = true -- This reminds us to undo this change in 
    --                                   Rebuild1SegmentRangeSetWithManySegmentRanges()
		selection.SelectAll()
		structure.SetSecondaryStructureSelected("L") -- We undo this change at the end of 
    --                                              Rebuild1SegmentRangeSetWithManySegmentRanges()
    --                                              with a call to save.LoadSecondaryStructure()    
	end
  
end -- function ConvertAllSegmentsToLoops()
function ConvertSegmentRangesTableToListOfSegmentRanges(l_SegmentRangesTable)
  -- Called from DisplayUserSelectedOptions(), 
  --             AskUserToSelectSegmentsRangesToRebuild() and
  --             AskUserToSelectRebuildOptions()...

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
function ConvertSegmentRangesTableToSegmentsBooleanTable(l_SegmentRangesToRebuildTable)-- was InitWORKONbool
  -- ...was InitWORKONbool(), I think.
  -- Called from Rebuild1PuzzleForManyRuns() was DRW()
  
	-- l_SegmentRangesToRebuildTable={StartSegment, EndSegment} e.g., {{1,3},{5,7},{9,11}}
	-- l_bSegmentsToRebuildBooleanTable={bToRebuild} -- e.g., {true,true,true,false,true, ...}

	local l_bSegmentsToRebuildBooleanTable = {}

	for l_SegmentIndex = 1, g_SegmentCount_WithLigands do -- why w/ligands?
    
		l_bSegmentsToRebuildBooleanTable[l_SegmentIndex] =
			bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesToRebuildTable)
      
	end

	return l_bSegmentsToRebuildBooleanTable
  
end -- function ConvertSegmentRangesTableToSegmentsBooleanTable(l_SegmentRangesToRebuildTable)
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
function DisplayDetailsOfIncludedSegments()
  
  local l_SelectedSegmentRanges -- to do?
  local l_SkippedSegmentRanges -- maybe?
  
  local l_FrozenBackboneSegmentRanges
  local l_FrozenSideChainSegmentRanges
  l_FrozenBackboneSegmentRanges, l_FrozenSideChainSegmentRanges = FindFrozenSegmentRanges()
  
  -- Always remove Frozen Backbone segments...
  local l_ListOfFrozenBackboneSegmentRanges =
    ConvertSegmentRangesTableToListOfSegmentRanges(l_FrozenBackboneSegmentRanges)
  if l_ListOfFrozenBackboneSegmentRanges == "" then
    l_ListOfFrozenBackboneSegmentRanges = "none"
  end
  print("\n  Frozen Backbone Segment Ranges: " .. l_ListOfFrozenBackboneSegmentRanges)
  g_UserSelected_SegmentRangesAllowedToBeRebuiltTable =  -- was WORKON[]
    SegmentRangesMinus(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable, l_FrozenBackboneSegmentRanges)
  
  -- Always remove Frozen SideChain segments...
  local l_ListOfFrozenSideChainSegmentRanges =
    ConvertSegmentRangesTableToListOfSegmentRanges(l_FrozenSideChainSegmentRanges)
  if l_ListOfFrozenSideChainSegmentRanges == "" then
    l_ListOfFrozenSideChainSegmentRanges = "none"
  end
  print("  Frozen SideChain Segment Ranges: " .. l_ListOfFrozenSideChainSegmentRanges)  
  g_UserSelected_SegmentRangesAllowedToBeRebuiltTable =
    SegmentRangesMinus(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable, l_FrozenSideChainSegmentRanges)
  
  -- Always remove Locked segments...
  local l_LockedSegmentRanges
  l_LockedSegmentRanges = FindLockedSegmentRanges()
  local l_ListOfLockedSegmentRanges =
    ConvertSegmentRangesTableToListOfSegmentRanges(l_LockedSegmentRanges)
  if l_ListOfLockedSegmentRanges == "" then
    l_ListOfLockedSegmentRanges = "none"
  end
  print("  Locked Segment Ranges: " .. l_ListOfLockedSegmentRanges)
  g_UserSelected_SegmentRangesAllowedToBeRebuiltTable =
    SegmentRangesMinus(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable, l_LockedSegmentRanges)
  
  if g_SegmentCount_WithLigands > g_SegmentCount_WithoutLigands then 
    print("  Ligand Segment Range: " .. g_SegmentCount_WithoutLigands + 1 .. "-" ..
      g_SegmentCount_WithLigands)
  end
  
    -- Which segments are mutable...
  local l_MutableSegmentRanges
  l_MutableSegmentRanges = FindMutableSegmentRanges()
  local l_ListOfMutableSegmentRanges =
    ConvertSegmentRangesTableToListOfSegmentRanges(l_MutableSegmentRanges)
  if l_ListOfMutableSegmentRanges == "" then
    l_ListOfMutableSegmentRanges = "none"
  end
  print("  Mutable Segment Ranges: " .. l_ListOfMutableSegmentRanges)
  -- Do not subtract out the mutable segments...
  --g_UserSelected_SegmentRangesAllowedToBeRebuiltTable =
  --  SegmentRangesMinus(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable, l_MutableSegmentRanges)
  
    -- Puzzle Number of segments...
  if g_SegmentCount_WithLigands > g_SegmentCount_WithoutLigands then 
    print("  Puzzle has " .. g_SegmentCount_WithLigands .. " segments")
  end

  -- Number of base protein segments...
	print("  Protein has " .. g_SegmentCount_WithoutLigands .. " segments")  
  
  -- Number of ligand segments...
  if g_SegmentCount_WithLigands > g_SegmentCount_WithoutLigands then 
    print("  Ligand has " .. g_SegmentCount_WithLigands - g_SegmentCount_WithoutLigands .. " segments")
  end 
	
  -- Number of mutable segments...
	if g_NumberOfMutableSegments > 0 then
    print("  Protein has " .. g_NumberOfMutableSegments .. " mutable segments")
	end
  
  Populate_g_FrozenLockedOrLigandSegments() -- presently, just informational.
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
	g_bUserSelectd_SegmentsAllowedToBeRebuiltTable =  -- was WORKONbool[]
  
		ConvertSegmentRangesTableToSegmentsBooleanTable( -- was SegmentSetToBool()
      
      g_UserSelected_SegmentRangesAllowedToBeRebuiltTable) -- was WORKON[]
  -- Important!!!
  -- Important!!!
  -- Important!!!  
  
	print("  User selected segment ranges to rebuild: " ..
		ConvertSegmentRangesTableToListOfSegmentRanges(g_UserSelected_SegmentRangesAllowedToBeRebuiltTable))
  
end -- function DisplayDetailsOfIncludedSegments()
function DisplayEndOfRunStatistics()
  
  local l_Stats_Run_EndTime = os.clock()
  local l_Stats_Run_ElaspedMinutes = (l_Stats_Run_EndTime - g_Stats_Run_StartTime) / 60
  
  local l_Stats_Run_TotalPointsGained_Total = 
    g_Stats_Run_TotalPointsGained_RebuildSelected +
    g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected +
    g_Stats_Run_TotalPointsGained_WiggleSelected +
    g_Stats_Run_TotalPointsGained_WiggleAll +
    g_Stats_Run_TotalPointsGained_MutateSidechainsSelected +
    g_Stats_Run_TotalPointsGained_MutateSidechainsAll
  if l_Stats_Run_TotalPointsGained_Total < 0.0001 then
     l_Stats_Run_TotalPointsGained_Total = 0.0001
  end
    
  local l_Stats_Run_TotalSecondsUsed_Total = 
    g_Stats_Run_TotalSecondsUsed_RebuildSelected +
    g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected +
    g_Stats_Run_TotalSecondsUsed_WiggleSelected +
    g_Stats_Run_TotalSecondsUsed_WiggleAll +
    g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected +
    g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll
  
  local l_Stats_Run_SuccessfulAttempts_Total = 
    g_Stats_Run_SuccessfulAttempts_RebuildSelected +
    g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected +
    g_Stats_Run_SuccessfulAttempts_WiggleSelected +
    g_Stats_Run_SuccessfulAttempts_WiggleAll +
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected +
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll
    
  local l_Stats_Run_NumberOfAttempts_Total = 
    g_Stats_Run_NumberOfAttempts_RebuildSelected +
    g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected +
    g_Stats_Run_NumberOfAttempts_WiggleSelected +
    g_Stats_Run_NumberOfAttempts_WiggleAll +
    g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected +
    g_Stats_Run_NumberOfAttempts_MutateSidechainsAll
    
  -- The script sum total of the many action seconds is close to double the actual script elasped
  -- time. For example 93 vs 55 seconds. To get a more accurate time spent, we divide the 
  -- time per action by the total time of all actions. This gives a reasonable percent of time
  -- taken per action. We then multiply this percentage by the actual time elapsed. For example
  -- RebuildSelected says it took 83 of the 93 total action seconds. This represents 89% of
  -- the total actual elapsed time of 55 seconds or 49 actual seconds

  local l_PercentTimeUsed_RebuildSelected = 
        g_Stats_Run_TotalSecondsUsed_RebuildSelected / l_Stats_Run_TotalSecondsUsed_Total
  local l_PercentTimeUsed_ShakeSidechainsSelected = 
        g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected / l_Stats_Run_TotalSecondsUsed_Total
  local l_PercentTimeUsed_WiggleSelected =
        g_Stats_Run_TotalSecondsUsed_WiggleSelected / l_Stats_Run_TotalSecondsUsed_Total
  local l_PercentTimeUsed_WiggleAll =
        g_Stats_Run_TotalSecondsUsed_WiggleAll / l_Stats_Run_TotalSecondsUsed_Total
  local l_PercentTimeUsed_MutateSidechainsSelected =
        g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected / l_Stats_Run_TotalSecondsUsed_Total
  local l_PercentTimeUsed_MutateSidechainsAll =
        g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll / l_Stats_Run_TotalSecondsUsed_Total

  -- Approximate minutes used (not 100% accurate because clock is only accurate to +/- 0.001 seconds)
  local l_Stats_Run_TotalMinutesUsed_RebuildSelected =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_RebuildSelected
     if l_Stats_Run_TotalMinutesUsed_RebuildSelected < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_RebuildSelected = 0.0001
     end
  local l_Stats_Run_TotalMinutesUsed_ShakeSidechainsSelected =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_ShakeSidechainsSelected
     if l_Stats_Run_TotalMinutesUsed_ShakeSidechainsSelected < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_ShakeSidechainsSelected = 0.0001
     end
  local l_Stats_Run_TotalMinutesUsed_WiggleSelected =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_WiggleSelected
     if l_Stats_Run_TotalMinutesUsed_WiggleSelected < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_WiggleSelected = 0.0001
     end
  local l_Stats_Run_TotalMinutesUsed_WiggleAll =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_WiggleAll
     if l_Stats_Run_TotalMinutesUsed_WiggleAll < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_WiggleAll = 0.0001
     end
  local l_Stats_Run_TotalMinutesUsed_MutateSidechainsSelected =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_MutateSidechainsSelected
     if l_Stats_Run_TotalMinutesUsed_MutateSidechainsSelected < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_MutateSidechainsSelected = 0.0001
     end
  local l_Stats_Run_TotalMinutesUsed_MutateSidechainsAll =
        l_Stats_Run_ElaspedMinutes * l_PercentTimeUsed_MutateSidechainsAll
     if l_Stats_Run_TotalMinutesUsed_MutateSidechainsAll < 0.0001 then
        l_Stats_Run_TotalMinutesUsed_MutateSidechainsAll = 0.0001
     end
  
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("End of run " .. g_RunCycle .. " Stats:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("From:                       Points Gained      Minutes Used    Pts/Min     Success Rate:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
                                        
  print("RebuildSelected          " .. 
    PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_RebuildSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_RebuildSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_RebuildSelected /
                 l_Stats_Run_TotalMinutesUsed_RebuildSelected, 9, 0) .. "  " ..
               
    PaddedString(g_Stats_Run_SuccessfulAttempts_RebuildSelected .. "/" ..
    PaddedNumber(g_Stats_Run_NumberOfAttempts_RebuildSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_RebuildSelected /
                 g_Stats_Run_NumberOfAttempts_RebuildSelected * 100, 4, 2) .. "%)", 9))
  print("ShakeSidechainsSelected  " ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_ShakeSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_ShakeSidechainsSelected /
                 l_Stats_Run_TotalMinutesUsed_ShakeSidechainsSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected /
                 g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleSelected           " .. 
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_WiggleSelected, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_WiggleSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleSelected /
                 l_Stats_Run_TotalMinutesUsed_WiggleSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Run_SuccessfulAttempts_WiggleSelected .. "/" ..
    PaddedNumber(g_Stats_Run_NumberOfAttempts_WiggleSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_WiggleSelected /
                 g_Stats_Run_NumberOfAttempts_WiggleSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleAll                " .. 
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_WiggleAll, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_WiggleAll * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_WiggleAll /
                 l_Stats_Run_TotalMinutesUsed_WiggleAll, 9, 0) .. "  " ..
               
    PaddedString(g_Stats_Run_SuccessfulAttempts_WiggleAll .. "/" ..  
    PaddedNumber(g_Stats_Run_NumberOfAttempts_WiggleAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_WiggleAll /
                 g_Stats_Run_NumberOfAttempts_WiggleAll * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsSelected " ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_MutateSidechainsSelected, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsSelected /
                 l_Stats_Run_TotalMinutesUsed_MutateSidechainsSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected /
                 g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsAll      " .. 
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll /
                 l_Stats_Run_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Run_TotalMinutesUsed_MutateSidechainsAll, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_MutateSidechainsAll * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Run_TotalPointsGained_MutateSidechainsAll /
                 l_Stats_Run_TotalMinutesUsed_MutateSidechainsAll, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll .. "/" ..
    PaddedNumber(g_Stats_Run_NumberOfAttempts_MutateSidechainsAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll /
                 g_Stats_Run_NumberOfAttempts_MutateSidechainsAll * 100, 4, 2) .. "%)", 9))
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("Run total                " .. 
    PaddedNumber(l_Stats_Run_TotalPointsGained_Total, 9, 3) .. "   (100%)" ..
             
    PaddedNumber(l_Stats_Run_ElaspedMinutes, 9, 3) .. "   (100%)" ..
             
    PaddedNumber(l_Stats_Run_TotalPointsGained_Total /
                (l_Stats_Run_TotalSecondsUsed_Total / 60), 9, 0) .. "  " ..
              
    PaddedString(l_Stats_Run_SuccessfulAttempts_Total .. "/" ..
    PaddedNumber(l_Stats_Run_NumberOfAttempts_Total, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(l_Stats_Run_SuccessfulAttempts_Total /
                 l_Stats_Run_NumberOfAttempts_Total * 100, 4, 2) .. "%)", 9))
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
  
  g_Stats_Run_TotalSecondsUsed_RebuildSelected = 0
  g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected = 0
  g_Stats_Run_TotalSecondsUsed_WiggleSelected = 0
  g_Stats_Run_TotalSecondsUsed_WiggleAll = 0
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected = 0
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll = 0
  
  g_Stats_Run_SuccessfulAttempts_RebuildSelected = 0
  g_Stats_Run_SuccessfulAttempts_ShakeSidechainsSelected = 0
  g_Stats_Run_SuccessfulAttempts_WiggleSelected = 0
  g_Stats_Run_SuccessfulAttempts_WiggleAll = 0
  g_Stats_Run_SuccessfulAttempts_MutateSidechainsSelected = 0
  g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll = 0
  
  g_Stats_Run_NumberOfAttempts_RebuildSelected = 0.0001 -- prevent divide by zero
  g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_WiggleSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_WiggleAll = 0.0001
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected = 0.0001
  g_Stats_Run_NumberOfAttempts_MutateSidechainsAll = 0.0001
    
end -- function DisplayEndOfRunStatistics()

function DisplayEndOfScriptStatistics()  
    
  local l_ScriptEndTime = os.clock()
  local l_Stats_Script_ElaspedMinutes = (l_ScriptEndTime - g_ScriptStartTime) / 60
  
  local l_Stats_Script_TotalPointsGained_Total = 
    g_Stats_Script_TotalPointsGained_RebuildSelected +
    g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected +
    g_Stats_Script_TotalPointsGained_WiggleSelected +
    g_Stats_Script_TotalPointsGained_WiggleAll +
    g_Stats_Script_TotalPointsGained_MutateSidechainsSelected +
    g_Stats_Script_TotalPointsGained_MutateSidechainsAll
    if l_Stats_Script_TotalPointsGained_Total < 0.0001 then
       l_Stats_Script_TotalPointsGained_Total = 0.0001
    end
  
  local l_Stats_Script_TotalSecondsUsed_Total = 
    g_Stats_Script_TotalSecondsUsed_RebuildSelected +
    g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected +
    g_Stats_Script_TotalSecondsUsed_WiggleSelected +
    g_Stats_Script_TotalSecondsUsed_WiggleAll +
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected +
    g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll
  
  local l_Stats_Script_SuccessfulAttempts_Total = 
    g_Stats_Script_SuccessfulAttempts_RebuildSelected +
    g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected +
    g_Stats_Script_SuccessfulAttempts_WiggleSelected +
    g_Stats_Script_SuccessfulAttempts_WiggleAll +
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected +
    g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll
    
  local l_Stats_Script_NumberOfAttempts_Total = 
    g_Stats_Script_NumberOfAttempts_RebuildSelected +
    g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected +
    g_Stats_Script_NumberOfAttempts_WiggleSelected +
    g_Stats_Script_NumberOfAttempts_WiggleAll +
    g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected +
    g_Stats_Script_NumberOfAttempts_MutateSidechainsAll
    
  local l_PercentTimeUsed_RebuildSelected = 
        g_Stats_Script_TotalSecondsUsed_RebuildSelected / l_Stats_Script_TotalSecondsUsed_Total
  local l_PercentTimeUsed_ShakeSidechainsSelected = 
        g_Stats_Script_TotalSecondsUsed_ShakeSidechainsSelected / l_Stats_Script_TotalSecondsUsed_Total
  local l_PercentTimeUsed_WiggleSelected =
        g_Stats_Script_TotalSecondsUsed_WiggleSelected / l_Stats_Script_TotalSecondsUsed_Total
  local l_PercentTimeUsed_WiggleAll =
        g_Stats_Script_TotalSecondsUsed_WiggleAll / l_Stats_Script_TotalSecondsUsed_Total
  local l_PercentTimeUsed_MutateSidechainsSelected =
        g_Stats_Script_TotalSecondsUsed_MutateSidechainsSelected / l_Stats_Script_TotalSecondsUsed_Total
  local l_PercentTimeUsed_MutateSidechainsAll =
        g_Stats_Script_TotalSecondsUsed_MutateSidechainsAll / l_Stats_Script_TotalSecondsUsed_Total

  -- Approximate minutes used (not 100% accurate because clock is only accurate to +/- 0.001 seconds)
  local l_Stats_Script_TotalMinutesUsed_RebuildSelected =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_RebuildSelected
     if l_Stats_Script_TotalMinutesUsed_RebuildSelected < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_RebuildSelected = 0.0001
     end
  local l_Stats_Script_TotalMinutesUsed_ShakeSidechainsSelected =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_ShakeSidechainsSelected
     if l_Stats_Script_TotalMinutesUsed_ShakeSidechainsSelected < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_ShakeSidechainsSelected = 0.0001
     end
  local l_Stats_Script_TotalMinutesUsed_WiggleSelected =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_WiggleSelected
     if l_Stats_Script_TotalMinutesUsed_WiggleSelected < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_WiggleSelected = 0.0001
     end
  local l_Stats_Script_TotalMinutesUsed_WiggleAll =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_WiggleAll
     if l_Stats_Script_TotalMinutesUsed_WiggleAll < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_WiggleAll = 0.0001
     end
  local l_Stats_Script_TotalMinutesUsed_MutateSidechainsSelected =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_MutateSidechainsSelected
     if l_Stats_Script_TotalMinutesUsed_MutateSidechainsSelected < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_MutateSidechainsSelected = 0.0001
     end
  local l_Stats_Script_TotalMinutesUsed_MutateSidechainsAll =
        l_Stats_Script_ElaspedMinutes * l_PercentTimeUsed_MutateSidechainsAll
     if l_Stats_Script_TotalMinutesUsed_MutateSidechainsAll < 0.0001 then
        l_Stats_Script_TotalMinutesUsed_MutateSidechainsAll = 0.0001
     end
  
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("End of Script Stats:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("From:                       Points Gained      Minutes Used    Pts/Min     Success Rate:")
  print("------------------------ ------------------  ----------------  -------  ------------------")
  
  print("RebuildSelected          " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_RebuildSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_RebuildSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_RebuildSelected /
                 l_Stats_Script_TotalMinutesUsed_RebuildSelected, 9, 0) .. "  " ..
               
    PaddedString(g_Stats_Script_SuccessfulAttempts_RebuildSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_RebuildSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_RebuildSelected /
                 g_Stats_Script_NumberOfAttempts_RebuildSelected * 100, 4, 2) .. "%)", 9))
  print("ShakeSidechainsSelected  " ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_ShakeSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_ShakeSidechainsSelected /
                 l_Stats_Script_TotalMinutesUsed_ShakeSidechainsSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_ShakeSidechainsSelected /
                 g_Stats_Script_NumberOfAttempts_ShakeSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleSelected           " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_WiggleSelected, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_WiggleSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleSelected /
                 l_Stats_Script_TotalMinutesUsed_WiggleSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Script_SuccessfulAttempts_WiggleSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_WiggleSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_WiggleSelected /
                 g_Stats_Script_NumberOfAttempts_WiggleSelected * 100, 4, 2) .. "%)", 9))
  print("WiggleAll                " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_WiggleAll, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_WiggleAll * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_WiggleAll /
                 l_Stats_Script_TotalMinutesUsed_WiggleAll, 9, 0) .. "  " ..
               
    PaddedString(g_Stats_Script_SuccessfulAttempts_WiggleAll .. "/" ..  
    PaddedNumber(g_Stats_Script_NumberOfAttempts_WiggleAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_WiggleAll /
                 g_Stats_Script_NumberOfAttempts_WiggleAll * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsSelected " ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_MutateSidechainsSelected, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsSelected /
                 l_Stats_Script_TotalMinutesUsed_MutateSidechainsSelected, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_MutateSidechainsSelected /
                 g_Stats_Script_NumberOfAttempts_MutateSidechainsSelected * 100, 4, 2) .. "%)", 9))
  print("MutateSidechainsAll      " .. 
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll, 9, 3) .. "" ..
    PaddedString("(" ..
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll /
                 l_Stats_Script_TotalPointsGained_Total * 100, 4, 2) .. "%)", 9) ..
    
    PaddedNumber(l_Stats_Script_TotalMinutesUsed_MutateSidechainsAll, 9, 3) .. "" ..      
    PaddedString("(" ..
    PaddedNumber(l_PercentTimeUsed_MutateSidechainsAll * 100, 4, 2) .. "%)", 9) ..
             
    PaddedNumber(g_Stats_Script_TotalPointsGained_MutateSidechainsAll /
                 l_Stats_Script_TotalMinutesUsed_MutateSidechainsAll, 9, 0) .. "  " ..
              
    PaddedString(g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll .. "/" ..
    PaddedNumber(g_Stats_Script_NumberOfAttempts_MutateSidechainsAll, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(g_Stats_Script_SuccessfulAttempts_MutateSidechainsAll /
                 g_Stats_Script_NumberOfAttempts_MutateSidechainsAll * 100, 4, 2) .. "%)", 9))
  print("------------------------ ------------------  ----------------  -------  ------------------")
  print("Script total             " ..
    PaddedNumber(l_Stats_Script_TotalPointsGained_Total, 9, 3) .. "   (100%)" ..
             
    PaddedNumber(l_Stats_Script_ElaspedMinutes, 9, 3) .. "   (100%)" ..
             
    PaddedNumber(l_Stats_Script_TotalPointsGained_Total /
                (l_Stats_Script_TotalSecondsUsed_Total / 60), 9, 0) .. "  " ..
              
    PaddedString(l_Stats_Script_SuccessfulAttempts_Total .. "/" ..
    PaddedNumber(l_Stats_Script_NumberOfAttempts_Total, 0, 0), 9) ..
    PaddedString(" (" ..
    PaddedNumber(l_Stats_Script_SuccessfulAttempts_Total /
                 l_Stats_Script_NumberOfAttempts_Total * 100, 4, 2) .. "%)", 9))
  print("------------------------ ------------------  ----------------  -------  ------------------")
    
  local l_Score_AtEndOf_Script = g_Score_ScriptBest
	print("\nStarting Score: " .. PrettyNumber(g_Score_AtStartOf_Script) ..
        "\nPoints Gained: " .. PrettyNumber(l_Score_AtEndOf_Script - g_Score_AtStartOf_Script) ..
        "\nFinal Score: " .. PrettyNumber(l_Score_AtEndOf_Script) ..
        "\nElapsed Time " .. PaddedNumber(l_Stats_Script_ElaspedMinutes, 5, 3) .. " minutes or " ..
        PaddedNumber(l_Stats_Script_ElaspedMinutes / 60, 5, 3) .. " hours" ..
        "\n")

end -- function DisplayEndOfScriptStatistics()

function DisplayXLowestScoringSegmentRanges() -- was PrintAreas()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges()...
  
	-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}

	local l_ListOfSegmentRanges = ""
	local l_MaxNumberOfSegmentRangesToDisplay = #g_XLowestScoringSegmentRangesTable -- was areas[]

	if l_MaxNumberOfSegmentRangesToDisplay > 100 then
		l_MaxNumberOfSegmentRangesToDisplay = 100
	end

	for l_SegmentIndex = 1, l_MaxNumberOfSegmentRangesToDisplay do
    
    if l_ListOfSegmentRanges ~= "" then
      l_ListOfSegmentRanges = l_ListOfSegmentRanges .. ","
    end
    
		l_ListOfSegmentRanges = l_ListOfSegmentRanges ..
						g_XLowestScoringSegmentRangesTable[l_SegmentIndex][srtrt_StartSegment] .. "-" ..
						g_XLowestScoringSegmentRangesTable[l_SegmentIndex][srtrt_EndSegment]
            
	end -- for l_SegmentIndex = 1, l_MaxNumberOfSegmentRangesToDisplay do

  --l_ListOfSegmentRanges = "Score " .. PrettyNumber(g_Score_ScriptBest) ..
  l_ListOfSegmentRanges = PaddedNumber(g_Score_ScriptBest, 9, 3) ..
    "          " ..
    PaddedNumber((os.clock() - g_ScriptStartTime) / 60, 7, 3) .. "m" ..
    " Segment ranges:" .. l_ListOfSegmentRanges
      
    -- #g_XLowestScoringSegmentRangesTable 
   
  if string.len(l_ListOfSegmentRanges) > 127 then
    l_ListOfSegmentRanges = string.sub(l_ListOfSegmentRanges, 1, 127) .. "..."
  end 
    
	print(l_ListOfSegmentRanges)

end -- DisplayXLowestScoringSegmentRanges()
function DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
  -- Called from 4 functions...
	if g_bUserSelected_KeepDisulfideBondsIntact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
  
	-- User wants to keep disulfide bonds intact...
	if DisulfideBonds_DidAnyOfThemBreak() == true then
		-- Well, we can't be breaking disulfide bonds, now can we?
		QuickSaveStack_LoadLastSavedSolution()
	else
		-- Looks like everything is kosher, so let's keep our current solution
		-- (improvements, I hope), and remove the last saved solution from the stack...
		QuickSaveStack_RemoveLastSavedSolution()
	end
  
end -- function DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
function DisulfideBonds_DidAnyOfThemBreak()
  -- Called from 3 functions
  
	if g_bUserSelected_KeepDisulfideBondsIntact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
  
	-- User wants to keep disulfide bonds intact...
	local l_NumberOfDisulfideBonds = DisulfideBonds_GetCount()
  
	if  l_NumberOfDisulfideBonds < g_OriginalNumberOfDisulfideBonds then
		return true
	end  
  
	return false
  
end -- function DisulfideBonds_DidAnyOfThemBreak()
function DisulfideBonds_GetCount()
  -- Called from Populate_g_CysteineSegmentsTable() and
  --             DisulfideBonds_DidAnyOfThemBreak()...
  
	local l_Count = 0
	for l_SegmentIndex = 1, #g_CysteineSegmentsTable do
		if bIsADisulfideBondSegment(g_CysteineSegmentsTable[l_SegmentIndex]) then
			l_Count = l_Count + 1
		end
	end
	return l_Count
  
end -- function DisulfideBonds_GetCount()
function DisulfideBonds_RememberSolutionWithThemIntact()
  -- Called from 4 functions...
  
	if g_bUserSelected_KeepDisulfideBondsIntact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
	-- User wants to keep disulfide bonds intact...
	-- As a precaution, let's save our current solution... If the next build
	-- breaks any disufide bonds, we can (and will) revert back to this solution...
	QuickSaveStack_SaveCurrentSolution()
  
end -- function DisulfideBonds_RememberSolutionWithThemIntact()
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
function FindFrozenSegmentRanges()
  -- Called from AskUserToSelectSegmentsRangesToRebuild() and
  --             AskUserToSelectRebuildOptions()...
  local l_FrozenBackboneSegmentsTable
  local l_FrozenSideChainSegmentsTable
  l_FrozenBackboneSegmentsTable, l_FrozenSideChainSegmentsTable = FindFrozenSegments()
  
  local l_FrozenBackboneSegmentRangesTable =
    ConvertSegmentsTableToSegmentRangesTable(l_FrozenBackboneSegmentsTable)
  local l_FrozenSideChainSegmentRangesTable =
    ConvertSegmentsTableToSegmentRangesTable(l_FrozenSideChainSegmentsTable)  
  
	return l_FrozenBackboneSegmentRangesTable, l_FrozenSideChainSegmentRangesTable
  
end -- function FindFrozenSegmentRanges()
function FindFrozenSegments()
  -- Called from FindFrozenSegmentRanges()...
  -- Let it go, let it go...

	-- l_FrozenSegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_FrozenBackboneSegmentsTable = {}
  local l_FrozenSideChainSegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		local l_bBackboneIsFrozen
		local l_bSideChainIsFrozen
		l_bBackboneIsFrozen, l_bSideChainIsFrozen = freeze.IsFrozen(l_SegmentIndex)
    
		--if l_bBackboneIsFrozen == true or l_bSideChainIsFrozen == true then -- partially frozen?? 
    if l_bBackboneIsFrozen == true then
			l_FrozenBackboneSegmentsTable[#l_FrozenBackboneSegmentsTable + 1] = l_SegmentIndex
		end
    if l_bSideChainIsFrozen == true then
			l_FrozenSideChainSegmentsTable[#l_FrozenSideChainSegmentsTable + 1] = l_SegmentIndex
		end
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
  
	return l_FrozenBackboneSegmentsTable, l_FrozenSideChainSegmentsTable
  
end -- function FindFrozenSegments()
function FindLockedSegmentRanges()
  -- Called from AskUserToSelectSegmentsRangesToRebuild() and
  --             AskUserToSelectRebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindLockedSegments())
  
end -- function FindLockedSegmentRanges()
function FindLockedSegments()
  -- Called from FindLockedSegmentRanges()...
   
  -- Funny thing about displaying Lua tables in the ZeroBrane debugger Watch window:
  -- (and perhaps in any debugger, but this is the first time I have noticed)
  -- If you assign the first value in the table to index 1, e.g., MyTable[1] = true,
  -- the vertical representation of the table will look like this:
  -- true
  -- false
  -- true
  -- false
  -- However, if instead you make the first assignment to any index other than 1,
  -- e.g., MyTable[2], the vertical representation of the table will look like this:
  -- [2] = false
  -- [3] = true
  -- [4] = false
  -- and I suppose this makes sense, because if it did not display the index
  -- value, one would incorrectly assume the first row is assigned to index 1, which
  -- it isn't in this example. Note also, if you assign values to several indices other
  -- than 1, then later assign a value to index=1, the index values will disappear
  -- in the debugger Watch window. So, the lesson learned here is: If you want to see index
  -- values for a table in the debugger Watch window, be sure to never assign index 1
  -- to a value. :-)
  -- Also interesting: If you assign values to 1, 3 and 5, it will look like this:
  -- true
  -- [3] = true
  -- [5] = false
  
	-- l_LockedSegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135} 
	local l_LockedSegmentsTable = {}
  for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
    if structure.IsLocked(l_SegmentIndex) == true then
      l_LockedSegmentsTable[#l_LockedSegmentsTable + 1] = l_SegmentIndex
		end
    
	end
  
	return l_LockedSegmentsTable
  
end -- function FindLockedSegments()
function FindMutableSegmentRanges()
  -- Called from AskUserToSelectSegmentsRangesToRebuild() and
  --             AskUserToSelectRebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindMutableSegments())
  
end -- function FindMutableSegmentRanges()
function FindMutableSegments()
  -- Called from FindMutableSegmentRanges()...

	-- l_MutableSegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135} 
	local l_MutableSegmentsTable = {}
  for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
    if structure.IsMutable(l_SegmentIndex) == true then
      l_MutableSegmentsTable[#l_MutableSegmentsTable + 1] = l_SegmentIndex
		end
    
	end
  
	return l_MutableSegmentsTable
  
end -- function FindMutableSegments()
function FindSegmentRangesWithSecondaryStructureType(l_SecondaryStructureType)
  -- Called from 4 places in AskUserToSelectSegmentsRangesToRebuild() and 
  --             1 place  in AskUserToSelectRebuildOptions()...
  
	return ConvertSegmentsTableToSegmentRangesTable(FindSegmentsWithSecondaryStructureType(l_SecondaryStructureType))
  
end -- function FindSegmentRangesWithSecondaryStructureType(l_SecondaryStructureType)
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
function FindSelectedSegmentRanges()
  -- Called from 3 functions
  
	return ConvertSegmentsTableToSegmentRangesTable(FindSelectedSegments())
  
end -- function FindSelectedSegmentRanges()
function FindSelectedSegments()
  -- Called from FindSelectedSegmentRanges()...
  
	-- l_SelectedSegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SelectedSegmentsTable = {}
  
	for l_SegmentIndex = 1, g_SegmentCount_WithLigands do -- why w/ligands?
    
		if selection.IsSelected(l_SegmentIndex) then
      
			l_SelectedSegmentsTable[#l_SelectedSegmentsTable + 1] = l_SegmentIndex
      
		end
    
	end
  
	return l_SelectedSegmentsTable
  
end -- function FindSelectedSegments()
function GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, l_SegmentRangesTable2)
  -- Called from SegmentRangesMinus() and 
  --             2 places in AskUserToSelectSegmentsRangesToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}

	local l_SegmentsTable1 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable1)
	local l_SegmentsTable2 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable2)
	local l_SegmentsInBothTables = FindCommonSegmentsInBothTables(l_SegmentsTable1,l_SegmentsTable2)
	local l_GetCommonSegmentRangesInBothTables = 
		ConvertSegmentsTableToSegmentRangesTable(l_SegmentsInBothTables)

	return l_GetCommonSegmentRangesInBothTables
  
end -- function GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, l_SegmentRangesTable2)
function GetNumberOfMutableSegments()
  -- Called from DisplayPuzzleProperties() and
  --             DefineGlobalVariables() (this one breaks the rule of define first, use next)...

	local l_GetNumberOfMutableSegments = 0

	for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
    
		if structure.IsMutable(l_SegmentIndex) == true then
      
			l_GetNumberOfMutableSegments = l_GetNumberOfMutableSegments + 1
      
		end
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
  
	return l_GetNumberOfMutableSegments

end -- function GetNumberOfMutableSegments()
function GetPoseTotalScore(l_pose) -- was Score()
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
function GetXLowestSortedValues(l_Table, l_NumberOfItems) -- was Sort()

  -- Called from Populate_g_XLowestScoringSegmentRangesTable()...
	-- Backward bubble sorting, lowest on top, only needed l_NumberOfItems
	for x = 1, l_NumberOfItems do
		for y = x + 1, #l_Table do
			if l_Table[x][1] > l_Table[y][1] then
				l_Table[x], l_Table[y] = l_Table[y], l_Table[x]
			end
		end
	end
  
	return l_Table
  
end -- function GetXLowestSortedValues(l_Table, l_NumberOfItems)
function InvertSegmentRangesTable(l_SegmentRangesTable, l_MaxSegmentIndex)
  -- Called from SegmentRangesMinus() and 
  --             AskUserToSelectSegmentsRangesToRebuild()...
  
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_InvertedSegmentRangesTable={StartSegment, EndSegment} e.g., {{4,8},{12,133}}

	-- Returns all segment ranges not in the passed in segment ranges ...
	-- l_MaxSegmentIndex is added for ligand
	local l_InvertedSegmentRangesTable = {}

	if l_MaxSegmentIndex == nil then -- appears to always be nil.
		l_MaxSegmentIndex = g_SegmentCount_WithLigands -- w/ligands? okay, I suppose. not thrilled about it.
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
function NormalConditionChecking_TemporarilyReEnableToCheckScore()
  -- Called from SaveBest() and CleanUp()...

  -- If recent best pose was better, remember it, while we check the score, then restore it again.
	local l_RecentBest_PoseTotalScore = GetPoseTotalScore(recentbest) -- class "recentbest"
  local l_Current_PoseTotalScore = GetPoseTotalScore()
	if l_RecentBest_PoseTotalScore > l_Current_PoseTotalScore then
    
    -- Save the recent best pose in slot 98. We will restore this pose "as-recentbest" again
    -- very soon, right after we check the score (to see if the conditions are met to get the 
    -- bonus points), when we re-disable-normal-condition-checking-for-this-entire-script-run...
    
    g_bBetterRecentBest = true -- read in NormalConditionChecking_DisableForThisEntireScriptRun below
    
		save.Quicksave(99) -- Temporarily save off the current pose in slot 99, we will restore it in a sec.
		recentbest.Restore() -- Save the recent best pose in slot 98. We will restore this pose "as-recentbest"
                         -- very soon, after we check the score, when we re-disable normal condition
                         -- checking.
		save.Quicksave(98)
		save.Quickload(99) -- Restore the current pose from slot 99. No harm no foul.
    
	end
  
	-- Disable faster CPU processing, so your scores will be counted...
  -- Important !!!
  -- Important !!!
	behavior.SetFiltersDisabled(false) -- temporarily re-enable normal condition checking to check score.
  -- Important !!!
  -- Important !!!
  
end -- function NormalConditionChecking_TemporarilyReEnableToCheckScore()
function NormalConditionChecking_DisableForThisEntireScriptRun()
  -- Called from SaveBest() and DefineGlobalVariables()...
  
	-- Enable faster CPU processing, but your scores will not be counted...
  -- Important !!!
  -- Important !!!
	behavior.SetFiltersDisabled(true) -- re-disable-normal-condition-checking-for-this-entire-script-run
  -- Important !!!
  -- Important !!!
  
	if g_bBetterRecentBest == true then --set in NormalConditionChecking_TemporarilyReEnableToCheckScore above
    
    -- Set things back the way they were before we prepared to check the score for bonus points.
    
		save.Quicksave(99) -- Temporarily save off the current pose in slot 99, we will reload it in a sec.
		save.Quickload(98) -- Restore the pose from slot 98 and set it back as the "recentbest" pose.
		recentbest.Save() -- Now things are back to the way they were before we prepared to check for
                      -- bonus points.
		save.Quickload(99)  -- Reload the current pose we stored in slot 99, just a second ago.
    
    g_bBetterRecentBest = false -- not sure why this line wasn't here earlier.
    
	end
  
end -- function NormalConditionChecking_DisableForThisEntireScriptRun()
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
function Populate_g_ActiveScorePartsTable() -- was FindActiveSubscores()
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
	for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do -- was Subs[]
    
		l_ScorePart_Name = l_ScorePart_NamesTable[l_ScorePart_NamesTableIndex]
    
    l_RunningTotalOfScorePartActivity = 0
    
		-- Look at each Segment to see if it has activity (a score) for the current ScorePart...
		for l_SegmentIndex = 1, g_SegmentCount_WithLigands do -- w/ligands, ok, I guess.
      
      l_ScorePartActivity = math.abs(current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name))
        
      l_RunningTotalOfScorePartActivity = l_RunningTotalOfScorePartActivity + l_ScorePartActivity
        
      if l_RunningTotalOfScorePartActivity > 10 or
        (l_ScorePart_Name == 'Disulfides' and g_OriginalNumberOfDisulfideBonds > 0) then

        g_ActiveScorePartsTable[#g_ActiveScorePartsTable + 1] = l_ScorePart_Name      
        
        -- Note: The value of l_ScorePartActivity above 10 is irrelevent. 10 points was enough to
        -- trigger activating the ScorePart. At this point we do not continue to add on to the
        -- 10 points; instead, we activate the ScorePart and break out of this inner loop to
        -- start evaluating the next ScorePart...
      
        --print("  Active ScorePart: " .. l_ScorePart_Name)
        
        break
      
      end -- if l_RunningTotalOfScorePartActivity > 10 or ...
        
    end -- for l_SegmentIndex = 1, g_SegmentCount_WithLigands do
    
	end -- for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do

end -- Populate_g_ActiveScorePartsTable()
function Populate_g_CysteineSegmentsTable()
  -- Called from DisplayPuzzleProperties()...

	--g_CysteineSegmentsTable={SegmentIndex}
	g_CysteineSegmentsTable = FindSegmentsWithAminoAcidType("c")
	g_OriginalNumberOfDisulfideBonds = DisulfideBonds_GetCount()
  
end -- function Populate_g_CysteineSegmentsTable()
function Populate_g_FrozenLockedOrLigandSegments()
  
  g_FrozenLockedOrLigandSegmentsTable = {}
  l_FrozenLockedOrLigandSegmentsTable = {}
  
  for l_SegmentIndex = 1, g_SegmentCount_WithLigands  do
    
    if bCheckIfFrozenLockedOrLigandSegment(l_SegmentIndex) == true then
        g_FrozenLockedOrLigandSegmentsTable[l_SegmentIndex]  = true
        l_FrozenLockedOrLigandSegmentsTable[#l_FrozenLockedOrLigandSegmentsTable + 1] = l_SegmentIndex
    end
    
  end
  
  local l_FrozenLockedOrLigandSegmentRangesTable =
    ConvertSegmentsTableToSegmentRangesTable(l_FrozenLockedOrLigandSegmentsTable)
  
  local l_ListOfFrozenLockedOrLigandSegmentRanges = 
    ConvertSegmentRangesTableToListOfSegmentRanges(l_FrozenLockedOrLigandSegmentRangesTable)
    
  print("  Frozen Locked or Ligand SegmentRanges: " ..
    l_ListOfFrozenLockedOrLigandSegmentRanges)  
  
end
function Populate_g_ScorePartsTable() -- was in global code
  -- Called from Rebuild1PuzzleForManyRuns()...

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
function Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts() -- was GetSegmentScores()
  -- Called from Populate_g_XLowestScoringSegmentRangesTable() -- was FindWorst()

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
    
    -- Make sure the user has selected this segment to be rebuilt and
    -- make sure this is not a frozen, locked or ligand segment...
		if g_bUserSelectd_SegmentsAllowedToBeRebuiltTable[l_SegmentIndex] == true then -- was WORKONbool[]
      
			if #g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable == 0 then -- was scrPart[]
				-- If the user did not select ScoreParts for calculating worst
        -- scoring segments, the default calculation for segment score is:
				-- l_SegmentScore = SegmentEnergyScore - Reference_ScorePart +
        --                  weighted Density_ScorePart
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
          Calculate_SegmentRange_Score( -- was GetSubscore()
            g_UserSelected_ScorePartsForCalculatingLowestScoringSegmentsTable, -- was scrPart[]
            l_SegmentIndex, l_SegmentIndex)
			end
      
      -- The first time this function is called we add one row per user
      -- selected non-frozen-locked-or-ligand segment of the protein to
      -- the g_SegmentScoresTable. On subsequent calls we simply update
      -- each row, because the number of segments never changes. No need
      -- to delete the table and recreate it each time this function is
      -- called.
			-- This is the only place where this table is populated and updated.
      -- l_SegmentIndex is sequential from 1 to g_SegmentCount_WithoutLigands
      -- with gaps for user non-selected, frozen, locked and ligand segments.
      -- g_SegmentScoresTable is only used by Calculate_ScorePart_Score(),
      -- which is used by both Populate_g_XLowestScoringSegmentRangesTable() and
      -- Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
			g_SegmentScoresTable[l_SegmentIndex] = l_SegmentScore
      
    end -- If g_bUserSelectd_SegmentsAllowedToBeRebuiltTable[l_SegmentIndex] == true then
    
	end -- for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do

end -- Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts()
function Populate_g_XLowestScoringSegmentRangesTable(l_RecursionLevel) -- FindWorst()
  -- Called from Rebuild1RunWithManySegmentRangeSets() and 
  --             recursively below...
  -- Calls CheckIfAlreadyRebuiltSegmentsMustBeIncluded() -- was ChkDisjunctList()
  -- Calls Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts() -- was GetSegmentScores()

	if l_RecursionLevel == nil then
		l_RecursionLevel = 1
	end

  --print("\nSearching for the " .. g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle .. 
  --       " worst scoring segment ranges (each range containing " ..
  --        g_RequiredNumberOfConsecutiveSegments .. " consecutive segments)...")

  CheckIfAlreadyRebuiltSegmentsMustBeIncluded() -- was ChkDisjunctList()  

	-- g_SegmentScoresTable = {SegmentScore}
	Populate_g_SegmentScoresTable_BasedOnUserSelectedScoreParts() -- was GetSegmentScores()

	local l_ToBeSortedSegmentRangeScoreTable = {} -- {Segment Score, StartSegment}
  local l_XLowestScoringSegmentRangesTable = {}
  
	local l_SkipTheseSegmentRanges = ""
	local l_NumberOfSegmentRangesSkipping = 0
	local l_StartSegment, l_EndSegment

	local l_bSegmentIsAllowedToBeRebuilt = true
	local l_bSegmentRangeIsAllowedToBeRebuilt = true
	local l_SegmentRangeScore = 0
  
  local l_FirstPossibleSegmentThatCanStartARangeOfSegments = 1
	local l_LastPossibleSegmentThatCanStartARangeOfSegments =
		g_SegmentCount_WithoutLigands - g_RequiredNumberOfConsecutiveSegments + 1
	-- An example:
	-- g_SegmentCount_WithoutLigands = 5 -- this is the last non-ligand segment
	-- g_RequiredNumberOfConsecutiveSegments = 3  -- we must have this many segments
                                                -- in our segment range
	-- l_LastPossibleSegmentThatCanStartARangeOfSegments = 5 - 3 + 1 = 3
	-- So our last possible segment range would be {3, 4, 5}

	for l_StartSegment =
		l_FirstPossibleSegmentThatCanStartARangeOfSegments,
		l_LastPossibleSegmentThatCanStartARangeOfSegments do
      
    l_StartSegment = l_StartSegment
    l_EndSegment = l_StartSegment + g_RequiredNumberOfConsecutiveSegments - 1
    -- An Example:
    -- l_StartSegment = 1
    -- l_EndSegment = 1 + 3 - 1 = 3
    -- SegmentRange = {1-3}
    
    l_bSegmentIsAllowedToBeRebuilt = bSegmentIsAllowedToBeRebuilt(l_StartSegment) -- checks several things
    if l_bSegmentIsAllowedToBeRebuilt == true then
      
      l_bSegmentRangeIsAllowedToBeRebuilt = bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment)
      -- ...was MustWorkon()
      
      if l_bSegmentRangeIsAllowedToBeRebuilt == true then
        
        local l_ScorePart_Name = nil
        l_SegmentRangeScore = Calculate_ScorePart_Score(l_ScorePart_Name, l_StartSegment, l_EndSegment) 
        -- ...was getPartscore()
        
        -- Note: Add a row to l_ToBeSortedSegmentRangeScoreTable, which will be
        --       used below to populate the g_XLowestScoringSegmentRangesTable...
        -- Note: The only reason we add the l_SegmentRangeScore as the first field
        --       in the l_ToBeSortedSegmentRangeScoreTable, is so we can sort the table from
        --       lowest to highest Segment Scores.
        -- Note: Although we are only placing the l_StartSegment in this table, and
        --       not the l_EndSegment, this is still a segment *range* table. We just
        --       don't need the l_EndSegment in this table, because we will calculate
        --       it later as l_StartSegment + g_RequiredNumberOfConsecutiveSegments - 1
        --       Also, we don't want the l_EndSegment is this table because it would
        --       break the GetXLowestSortedValues() function used below...
        l_ToBeSortedSegmentRangeScoreTable[#l_ToBeSortedSegmentRangeScoreTable + 1] = -- was wrst[]
          {l_SegmentRangeScore, l_StartSegment}
          
      end
      
		else -- l_bSegmentIsAllowedToBeRebuilt ~= true
      
      l_NumberOfSegmentRangesSkipping = l_NumberOfSegmentRangesSkipping + 1
      
      if l_SkipTheseSegmentRanges ~= "" then
        l_SkipTheseSegmentRanges = l_SkipTheseSegmentRanges .. ","
      end
      l_SkipTheseSegmentRanges = l_SkipTheseSegmentRanges .. l_StartSegment .. "-" .. l_EndSegment
      
		end -- if l_bSegmentIsAllowedToBeRebuilt == true then
    
	end
  
	if l_NumberOfSegmentRangesSkipping > 0 then
    
		 --too much noise...print("\n  Skipping the following " .. l_NumberOfSegmentRangesSkipping ..
     --      " already rebuilt (or unselected) segments: [" .. l_SkipTheseSegmentRanges .. "]")
	end

	-- Note: The only reason we add the l_SegmentRangeScore as the first field in the 
	--       l_ToBeSortedSegmentRangeScoreTable, is so we can sort the table from
	--       lowest to highest Segment Score.
	-- Please Remember! This is one row per *segment range*, not one row per segment!
  
  --- This is what you are looking for!!!
  --- This is what you are looking for!!!
	l_XLowestScoringSegmentRangesTable =
  
		GetXLowestSortedValues(l_ToBeSortedSegmentRangeScoreTable, -- <<<--- was Sort()
      
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle)
  --- This is what you are looking for!!!
  --- This is what you are looking for!!!
    
	-- Example table entries {{50.111, 1}, {20.32, 2}, {0.234, 3}, {30.5, 6}, {10.3, 7}},
	-- would be sorted as {{0.234, 3}, {10.3, 7}, {20.32, 2}, {30.5, 6}, {50.111, 1}}

	local l_NumberOfSegmentRangesToProcessThisRunCycle = #l_XLowestScoringSegmentRangesTable

	if l_NumberOfSegmentRangesToProcessThisRunCycle > 
     g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle then
		l_NumberOfSegmentRangesToProcessThisRunCycle =
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle
	end

	 -- l_WorstScoringSegmentRangesTable={SegmentScore=1, StartSegment=2}
	local wst_SegmentScore = 1
	local wst_StartSegment = 2
	local l_SegmentRangeScoreRow = {}

	-- Finally populate the g_XLowestScoringSegmentRangesTable[] -- was areas[]
  g_XLowestScoringSegmentRangesTable = {}  -- was areas[]

	-- Note: In the for loop below, we increment l_WorstScoringSegmentsTableIndex by 1,
	--       instead of by g_RequiredNumberOfConsecutiveSegments. That's because we want
	--       a rolling list of segment ranges. This gives us lots of possible segment
	--       combinations to work on...
	-- Example:
	--       Segment list = 1,2,3,4,5,6
	--       We want 3 consecutive segments per segment range:
	--       Resulting segment ranges: {1,2,3},{2,3,4},{3,4,5},{4,5,6}
	for l_TableIndex = 1, l_NumberOfSegmentRangesToProcessThisRunCycle do
    
		l_SegmentRangeScoreRow = l_XLowestScoringSegmentRangesTable[l_TableIndex]
    -- Note: Example table row entries {0.234, 3}, where the first field
    --       is the SegmentScore and the second field is the SegmentIndex.
    
		l_StartSegment = l_SegmentRangeScoreRow[wst_StartSegment] -- remember, this is the second field
    
		l_EndSegment = l_StartSegment + g_RequiredNumberOfConsecutiveSegments - 1
    
		-- Finally, add a row to the g_XLowestScoringSegmentRangesTable...
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
		g_XLowestScoringSegmentRangesTable[#g_XLowestScoringSegmentRangesTable + 1] =
      {l_StartSegment, l_EndSegment}
    -- Important!!!
    -- Important!!!
    -- Important!!!
    
	end

	if l_RecursionLevel == 1 and #l_XLowestScoringSegmentRangesTable == 0 then
    
    -- The next two lines get called from two places:
    -- 1) Populate_g_XLowestScoringSegmentRangesTable() -- Here, in this fuction.
    -- 2) CheckIfAlreadyRebuiltSegmentsMustBeIncluded() -- Bottom of that function.
    -- I don't think these two lines are ever called from here because of the call to 
    -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded() at the beginning of this function. I mean,
    -- that's the whole point of CheckIfAlreadyRebuiltSegmentsMustBeIncluded(), right?
    print("\nMessage from Populate_g_XLowestScoringSegmentRangesTable()..." ..
          "\nNot enough consecutive not-already-rebuilt segments available to create a segment range;" ..
          "\ntherefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
         
		Reset_g_bSegmentsAlreadyRebuiltTable() -- was ClearDoneList()
    
		-- Recursion...
		l_RecursionLevel = l_RecursionLevel + 1
		Populate_g_XLowestScoringSegmentRangesTable(l_RecursionLevel) -- was FindWorst()
    
	end

end -- Populate_g_XLowestScoringSegmentRangesTable() -- was FindWorst()
function PrettyNumber(l_DirtyFloat)
  -- Called from 3 functions  
  -- This is the new version of RoundToThirdDecimal()...
  
  local l_MaybeDirtyFloat = RoundTo(l_DirtyFloat, 1000)  
  local l_PrettyString = string.format("%.3f", l_MaybeDirtyFloat)  
  
  return l_PrettyString
  
end -- function PrettyNumber(l_DirtyFloat)
function QuickSaveStack_LoadLastSavedSolution()
  -- Called from 3 functions
  
	if g_QuickSaveStackPosition <= 60 then
		print("Quicksave stack underflow, exiting script")
		exit()
	end
  
	g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	save.Quickload(g_QuickSaveStackPosition) -- Load

end -- function QuickSaveStack_LoadLastSavedSolution()
function QuickSaveStack_RemoveLastSavedSolution()
  -- Called from 2 functions
  
	if g_QuickSaveStackPosition > 60 then
		g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	end
  
end -- function QuickSaveStack_RemoveLastSavedSolution()
function QuickSaveStack_SaveCurrentSolution()
  -- Called from 3 functions
  
	if g_QuickSaveStackPosition >= 100 then
		print("Error in QuickSaveStack_SaveCurrentSolution(), Quicksave stack overflow, exiting script")
		exit()
	end
	save.Quicksave(g_QuickSaveStackPosition) -- Save
	g_QuickSaveStackPosition = g_QuickSaveStackPosition + 1
  
end -- function QuickSaveStack_SaveCurrentSolution()
function Reset_g_ScorePart_Scores_Table() -- was ClearScores()
  -- Called from Rebuild1SegmentRangeForManyRounds()...

	g_ScorePartScoresTable = {} -- reset it

	local l_ScorePart_Number = 0
	local l_ScorePart_Score = -999999
	local l_PoseTotalScore = 0
	local l_StringOfScorePartNumbersWithSamePoseTotalScore = ''
	local l_bFirstInStringOfScorePartNumbersWithSamePoseTotalScore = false

	local l_bScorePart_IsActive

	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --                           bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
  
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
  
		l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_bScorePart_IsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
    
		if l_bScorePart_IsActive == true then
    
			g_ScorePartScoresTable[#g_ScorePartScoresTable + 1] =
				{l_ScorePart_Number, l_ScorePart_Score, l_PoseTotalScore,
         l_StringOfScorePartNumbersWithSamePoseTotalScore,
         l_bFirstInStringOfScorePartNumbersWithSamePoseTotalScore}
         
		end
    
	end

end -- Reset_g_ScorePart_Scores_Table()
function Reset_g_bSegmentsAlreadyRebuiltTable() -- was ClearDoneList()
  -- Called from Populate_g_XLowestScoringSegmentRangesTable()...

	for l_TableIndex = 1, g_SegmentCount_WithoutLigands do
		g_bSegmentsAlreadyRebuiltTable[l_TableIndex] = false
	end

end -- function Reset_g_bSegmentsAlreadyRebuiltTable()
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
function SaveBest() -- <-- Updates g_Score_ScriptBest
  -- Called from 3 functions
  
  -- Note 1: As long as you call SaveBest() after every rebuild, shake, wiggle and mutate, then
  --         g_Score_ScriptBest will always have the best score ever encounter during the script run.
  -- Note 2: The value of GetPoseTotalScore() can go up and down drastically after any call to rebuild,
  --         shake, wiggle or mutate; therefore, you cannot always expect to find the best score by calling
  --         GetPoseTotalScore().
  
  if g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun == true then
    
    -- Do not attempt to improve g_Score_ScriptBest if:
    -- 1) Normal condition checking is disabled, and
    -- 2) Reenabling normal condition checking would not likely improve our g_Score_ScriptBest.
    
   	local l_PoseTotalScore_WithConditionChecking_Disabled = GetPoseTotalScore()
  	local l_PotentialScore_IfAllConditionsAreMet = 
          l_PoseTotalScore_WithConditionChecking_Disabled + g_UserSelected_MaximumPotentialBonusPoints
    
    if (l_PotentialScore_IfAllConditionsAreMet <= g_Score_ScriptBest) then
      return
    end
    
    -- Time to turn condition checking back on...
    g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun = false
    
    -- When normal condition checking is disabled, our scores are only potential scores; that is,
    -- only if all conditions are met. We won't know if all conditions are met until we re-enable
    -- normal condition checking. We only disable normal condition checking to speed up the rebuild
    -- process, but only when there are potential bonus points to be earned.
  end
  
  if g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun == true then
    -- Temporarily re-enable normal condition checking, so we
    -- can look at real scores instead of potential scores...
    NormalConditionChecking_TemporarilyReEnableToCheckScore()
  end
  
  -- With normal condition checking re-enabled, a call to GetPoseTotalScore()
  -- will return an actual, real, counted, foldit-saved, current pose total score...
  local l_Current_PoseTotalScore = GetPoseTotalScore()
  local l_Real_PointsGained = l_Current_PoseTotalScore - g_Score_ScriptBest  
  
  local l_MinimumGain_ForSave = 0.001
  if g_bSketchBookPuzzle == true then
    l_MinimumGain_ForSave = g_UserSelected_SketchBookPuzzle_MinimumGainForSave
  end
  
  if l_Real_PointsGained >= l_MinimumGain_ForSave or 
    (l_Real_PointsGained >= 0.001 and g_bFoundAHighGain == true) then
    
    -- Important !!!
    -- Important !!!
    g_Score_ScriptBest = l_Current_PoseTotalScore  -- <<<--- This is what you are looking for!!!
    -- Important !!!
    -- Important !!!
    
    if g_bUserSelected_FuseBestScorePartPose == false and g_Score_ScriptBest > 0 then
      print("\nNow that the total score is positive, we will switch back on: " ..
            "'stabilize selected score part poses' and 'fuse best score part pose'.\n")
      g_bUserSelected_FuseBestScorePartPose = true
      g_bUserSelected_StabilizePosesOfSelectedScoreParts = true
    end
    
    --recentbest.Save() -- ...foldit already does this automatically!
    save.Quicksave(3) -- Save -- Slot 3 always contains the best scoring pose!
    g_bFoundAHighGain = true -- not exactly sure how this one works yet.
  end
  
  if g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun == true then
    -- Disable condition checking again (re-enable fast CPU processing)...
    NormalConditionChecking_DisableForThisEntireScriptRun()
  end

end -- SaveBest()
function SegmentRangesMinus(l_SegmentRangesTable1, l_SegmentRangesTable2)
  -- Called from 6 places in AskUserToSelectSegmentsRangesToRebuild() and
  --             3 places in AskUserToSelectRebuildOptions()...
  
	return GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1,
                   InvertSegmentRangesTable(l_SegmentRangesTable2))
  
end -- function SegmentRangesMinus(l_SegmentRangesTable1, l_SegmentRangesTable2)
function SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_Radius) -- was SelectAround()
  -- Called from 3 functions
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
function SetClashImportance(l_ClashImportance)
  -- Called from 8 functions...
  
	if l_ClashImportance > 0.99 then
		g_bMaxClashImportance = true
	else
		g_bMaxClashImportance = false
	end
  
	behavior.SetClashImportance(l_ClashImportance * g_UserSelected_ClashImportanceFactor)
  
end -- function SetClashImportance(l_ClashImportance)
function SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment) -- was AddDone()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges()...

  -- Loop through the given segment range and set the g_bSegmentsAlreadyRebuiltTable
  -- values to true for each segments in the given range...
  for l_TableIndex = l_StartSegment, l_EndSegment do
    
    -- Update one row in the g_bSegmentsAlreadyRebuiltTable...
    g_bSegmentsAlreadyRebuiltTable[l_TableIndex] = true
  end

end -- SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
function Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment,--SaveSco
                                                                                   l_EndSegment)
  -- was SaveScores()
  -- Called from 2 functions
  
  -- We have just rebuilt (and optionally, mutated, shaked and wiggled) only one segment
  -- range and only one attempt. Next, we are going to check for ScorePart improvements
  -- for this one specific rebuild attempt. For each ScorePart that improves, associate
  -- the current pose (and PoseTotalScore) of the protein to that ScorePart. Later, after
  -- all these rebuild attempts, in Rebuild1SegmentRangeSetWithManySegmentRanges() we will 
  -- step through each of these best saved score part poses and mutate, shake and wiggle them 
  -- some more to see if we can further improve their scores...
  
  -- Example g_ScorePartsTable entries...
  -- g_ScorePartsTable={}
  --   ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4
	-- {{4, "total",      true, "4 (total)"},     {5, "loctotal",  true, "5 (loctotal)"},
  --  {6, "ligand",     true, "6 (ligand)"},    {7, "Clashing",  true, "7 (Clashing)"},
  --  {8, "Pairwise",   true, "8 (Pairwise)"},  {9, "Packing",   true, "9 (Packing)"},
  --  {10, "Hiding",    true, "10 (Hiding)"},   {11, "Bonding",  true, "11 (Bonding)"},
  --  {12, "Ideality",  true, "12 (Ideality)"}, {13, "Backbone", true, "13 (Backbone)"},
  --  {14, "Sidechain", true, "14 (Sidechain)"}}
    
	-- Example l_ActiveScorePartsScoreTable entries...
  -- l_ActiveScorePartsScoreTable={}
		local aspst_ScorePart_Number = 1
		local aspst_ScorePart_Score = 2
  -- {{ 4,-6977.2286118734919}, {5, -12.456666312787226},
  --  { 6,   32.9263532067909}, {7,   0.781476616839258},
  --  { 8,    0.8518807244965}, {9,  -0.013940290319947},
  --  {10,    1.4852902498961}, {11,  0.548291360564633},
  --  {12,    0.0896093168034}, {13, -0.595251617638442},
  --  {14,    0.3282749583402}}
  
  -- Example g_ScorePartScoresTable entries (before updating fields 4 and 5)...
  -- g_ScorePartScoresTable={}
  --   ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, 
  --   StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --   bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5
  --{{ 4,-2070.4815006125,-2070.4815006125,"",false},{ 5,4.2974272030,-8544.6292812514,"",false},
  -- { 6,   41.9906112341,-5500.1149833617,"",false},{ 7,0.4566169644,-4424.6808476751,"",false},
  -- { 8,    1.3090043250,-5500.1149833617,"",false},{ 9,0.3907275101,-8544.6292812514,"",false},
  -- {10,    1.3220077059,-4424.6808476751,"",false},{11,0.3854063676,-4424.6808476751,"",false},
  -- {12,    1.3755310009,-5500.1149833617,"",false},{13,1.2065804745,-4424.6808476751,"",false},
  -- {14,    0.2095337681,-5500.1149833617,"",false}}
  
	-- Create a new list of active ScoreParts, then call
	-- Calculate_ScorePart_Score() to get each ScorePart's scores...
	local l_ActiveScorePartsScoreTable = {} -- {1=ScorePart_Number, 2=ScorePart_Score}
	local l_ScorePart_Number, l_ScoreType, l_bScorePart_IsActive, l_ScorePart_Score
  
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number    = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_ScorePart_Name      = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
		l_bScorePart_IsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
    
		if l_bScorePart_IsActive == true then
      
			-- Here is where we are getting the actual score to save...
			l_ScorePart_Score = Calculate_ScorePart_Score(l_ScorePart_Name, l_StartSegment, l_EndSegment)
			l_ActiveScorePartsScoreTable[#l_ActiveScorePartsScoreTable + 1] = 
                                                                    {l_ScorePart_Number, l_ScorePart_Score}
		end
    
	end

	local l_NewScorePart_Score, l_OldScorePart_Score
  
	local l_Current_PoseTotalScore = GetPoseTotalScore()
  -- note 1: Several g_ScorePartScoresTable rows will have the same l_Current_PoseTotalScore.

  -- Let's keep track of any ScorePart improvements. If there are improvements for
  -- a particular ScorePart, save the protein's pose for later regional shaking and wiggling...
	-- Update the global ScorePart_Scores_Table with each new ScorePart Score...
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --                           bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
	for l_TableIndex = 1, #g_ScorePartScoresTable do
		l_NewScorePart_Score = l_ActiveScorePartsScoreTable[l_TableIndex][aspst_ScorePart_Score]
		l_OldScorePart_Score = g_ScorePartScoresTable[l_TableIndex][spst_ScorePart_Score]
    
		if l_NewScorePart_Score > l_OldScorePart_Score then
			l_ScorePart_Number = l_ActiveScorePartsScoreTable[l_TableIndex][aspst_ScorePart_Number]
      
			-- Save current solution (protein's pose) to FoldIt. After we finish rebuilding this
      -- segment range several times, we will reload the successful poses (the rebuilds
      -- that gained ScorePart points) and apply some regional shakes and wiggles to find more
      -- gains...
			g_ScorePartScoresTable[l_TableIndex][spst_ScorePart_Score] = l_NewScorePart_Score
			g_ScorePartScoresTable[l_TableIndex][spst_PoseTotalScore] = l_Current_PoseTotalScore
      
      -- Important!!!
      -- Important!!!
      -- Important!!!
			save.Quicksave(l_ScorePart_Number) -- "Save"
      -- Important!!!
      -- Important!!!
      -- Important!!!
      -- See Rebuild1SegmentRangeSetWithManySegmentRanges() for the corresponding save.Quickload()
      
		end
	end
  local debug = 1

end -- Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
function Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInString()
  -- was ListSlots()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges()...
  
	-- Create a string of ScorePart numbers with the same PoseTotalScore...
	-- For example: 1=5=7 2=3=9 4 6=8, ScoreParts 1, 5 and 7 have the same PoseTotalScore, SortParts
  -- 2, 3 and 9 have the same PoseTotalScore and SortParts 6 and 8 have the same PoseTotalScore.
  -- Allow me to explain how these different SortParts ended up having the same PoseTotalScore...
  -- After each rebuild attempt of the same segment range (normally 10 attempts per segment range),
  -- each score part might have slightly improved. Well, for each of the score parts that improved
  -- for that particular rebuild (could be one or it could be many scorepart that improved), we 
  -- associate the same pose total score of that rebuild to each of the improved score parts.
  -- An example: 
  -- 1) Say we just completed rebuild round 7 of 10, and scoreparts 2, 3 and 9 were the 
  --    only 3 of the 20ish scoreparts to improve.. We set the remember-this-PoseTotalScore
  --    of each of these score parts to the current PoseTotalScore (i.e., we update the 
  --    PoseTotalScore field of the g_ScorePartScoresTable for the rows with scorepart
  --    numbers 2, 3 and 9).
  -- 2) Next, we just completed round 8 of 10 and only score parts 1, 5 and 7 improved. So we
  --    assign the latest best PoseTotalScore to score parts 1, 5 and 7.
  -- 3) Next, we just completed round 9 of 10 and only score parts 6 and 8 improved. So we assign
  --    assign the new latest and greatest PoseTotalScore to score parts 6 and 8.
  -- 4) Next we just completed round 10 of 10 and only score part 4 improved. So we assign the
  --    latest PoseTotalScore to score part 4.
  -- 5) Now, at this point is we were to build a string of score part numbers with the same
  --    PoseTotalScore, it would look something like this: "1=5=7 2=3=9 4 6=8"
  -- Now you know...
  -- So, what's the purpose of grouping ScoreParts with the same PoseTotalScore? The point of grouping
  -- like score part poses together is to only have to attempt to improve one each of the unique poses.
  -- Basically, we assume if the PoseTotalScore is the same, then those poses must be the same. Odd
  -- assumption, but it's probably correct most of the time.
  -- 
	-- For each ScorePart_Scores_Table row with a unique PoseTotalScore (or the first of a group of
  -- rows with the same PoseTotalScore), set the bFirstInStringOfScorePartNumbersWithSamePoseTotalScore
  -- flag to true. In the example of 1=5=7 2=3=9 4 6=8, rows with numbers 1, 2, 4 and 6 will be set to
  -- true and rows with numbers 3, 5 and 7 will be set to false.
  
  -- Let's get started by creating a table with one row per g_ScorePartScoresTable row, and set
  -- each row's Done status to false. This way, when we look ahead in the g_ScorePartScoresTable
  -- for ScoreParts with the same PoseTotalScore value, we can set those rows to Done, so we can
	-- skip them (because we will have already added them to the
  -- l_StringOfScorePartNumbersWithSamePoseTotalScore)...
	local l_ScorePartScoresDoneStatusTable = {}
	for l_TableIndex = 1, #g_ScorePartScoresTable do
		l_ScorePartScoresDoneStatusTable[l_TableIndex] = false
	end

	local l_Combined_StringOfScorePartNumbersWithSamePoseTotalScore = ""  

	-- Go through every row in the g_ScorePartScoresTable and look for other row's
	-- with the same PoseTotalScore value...
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --                           bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
	for l_TableIndex = 1, #g_ScorePartScoresTable do
    
		-- Skip the ScoreParts which have already been accounted for in the inner loop below...
		if l_ScorePartScoresDoneStatusTable[l_TableIndex] == false then
      
			local l_OuterLoop_ScorePart_Number = g_ScorePartScoresTable[l_TableIndex][spst_ScorePart_Number]
			local l_OuterLoop_PoseTotalScore = g_ScorePartScoresTable[l_TableIndex][spst_PoseTotalScore]
      
			-- Start building the StringOfScorePartNumbersWithSamePoseTotalScore...
			-- Note: The string could end up with just a single ScorePart number if
      --       no other rows have the same PoseTotalScore. And this is okay...
			local l_StringOfScorePartNumbersWithSamePoseTotalScore = l_OuterLoop_ScorePart_Number
      -- ...add first ScorePart_Number.
      local l_NumberOfScorePartsIncluded = 1
      
      -- For each ScorePart_Scores_Table row with a unique PoseTotalScore (or the
      -- first in the string or scorepart numbers with the same PoseTotalScore), set
      -- the bFirstInStringOfScorePartNumbersWithSamePoseTotalScore flag to true. 
      -- This field will be checked in Rebuild1SegmentRangeSetWithManySegmentRanges()...
			g_ScorePartScoresTable[l_TableIndex]
        [spst_bFirstInStringOfScorePartNumbersWithSamePoseTotalScore] = true 
      
			-- Next, for each row in g_ScorePartScoresTable, loop through the table
			-- a second time, (starting at the first row we have not yet looked at),
			-- to find other rows with the same PoseTotalScore value...
			for l_PotentialMatchIndex = l_TableIndex + 1, #g_ScorePartScoresTable do
        
				local l_InnerLoop_PoseTotalScore = 
              g_ScorePartScoresTable[l_PotentialMatchIndex][spst_PoseTotalScore]
				local l_InnerLoop_ScorePart_Number =
              g_ScorePartScoresTable[l_PotentialMatchIndex][spst_ScorePart_Number]
        
				if l_InnerLoop_PoseTotalScore == l_OuterLoop_PoseTotalScore then
					-- Ah ha, we found another ScorePart_Scores_Table
          -- row with the same PoseTotalScore value. Yay...
          l_NumberOfScorePartsIncluded = l_NumberOfScorePartsIncluded + 1
          
					-- Let's add this ScorePart number to the
          -- l_StringOfScorePartNumbersWithSamePoseTotalScore...
					l_StringOfScorePartNumbersWithSamePoseTotalScore =
						l_StringOfScorePartNumbersWithSamePoseTotalScore .. "=" .. l_InnerLoop_ScorePart_Number

					-- Since we justed added this ScorePart number to the 
          -- StringOfScorePartNumbersWithSamePoseTotalScore we need to 
          -- skip this ScorePart number in the outer loop; otherwise, we 
          -- would end up with duplicates in the string...
					l_ScorePartScoresDoneStatusTable[l_PotentialMatchIndex] = true
          
				end -- if l_InnerLoop_PoseTotalScore == l_OuterLoop_PoseTotalScore then
        
			end -- for l_PotentialMatchIndex = l_TableIndex + 1, #g_ScorePartScoresTable do
      
      if l_NumberOfScorePartsIncluded >= #g_ScorePartScoresTable then
        l_StringOfScorePartNumbersWithSamePoseTotalScore = "all" -- this will save space in the log file
      end
      
			-- StringOfScorePartNumbersWithSamePoseTotalScore examples: 4, 5=7=12, 6=9, 8=11=13
			g_ScorePartScoresTable[l_TableIndex][spst_StringOfScorePartNumbersWithSamePoseTotalScore] =
        l_StringOfScorePartNumbersWithSamePoseTotalScore
        
			l_Combined_StringOfScorePartNumbersWithSamePoseTotalScore =
      l_Combined_StringOfScorePartNumbersWithSamePoseTotalScore ..
				"\n  PoseTotalScore value: [" .. PrettyNumber(l_OuterLoop_PoseTotalScore) .. "]" ..
				" ScorePart_Numbers: [" .. l_StringOfScorePartNumbersWithSamePoseTotalScore .."]"
		end
    
	end

	--print("\n  Combined_StringOfScorePartNumbersWithSamePoseTotalScore: " ..
  --         l_Combined_StringOfScorePartNumbersWithSamePoseTotalScore)

end -- Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInString()
-- ...end of Support Functions.
-- Start of My Favorite Functions...
function Rebuild1PuzzleForManyRuns() -- was DRW()
  -- Called from 1 place in xpcall()...
  -- Calls Rebuild1RunWithManySegmentRangeSets() was DRcall()
  
  -- Rebuild 1 Puzzle for User Selected Number Of Run Cycles, where:
  --  1) each run rebuilds segment range sets from X to Y number of consecutive segments, and
  --  2) each subsequent run rebuilds more segment ranges per segment range set...
  
  -- In the grand scheme of things, see below --->>>We Are Here Now<<<---
  -- An example (using default values):
  -- Start of Script...
  -- Rebuild 1 Puzzle for 15 runs, where <<<---We are Here Now<<<---
  --   Run 1 rebuilds 3 segment range sets, where
  --       Set 1 contains 4 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 4 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 4 segment ranges, each range includes 4 consecutive segments
  --   Run 2 rebuilds 3 segment range sets, where
  --       Set 1 contains 5 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 5 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 5 segment ranges, each range includes 4 consecutive segments
  --   Run 3 rebuilds 3 segment range sets, where
  --       Set 1 contains 6 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 6 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 6 segment ranges, each range includes 4 consecutive segments
  --   ...
  --   Run 15 rebuilds 3 segment ranges sets, where
  --       Set 1 contains 18 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 18 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 18 segment ranges, each range includes 4 consecutive segments
  -- ...End of Script
  
	--require('mobdebug').start("192.168.1.108") unfortunately this doesn't work in the FoldIt environment
	DefineGlobalVariables()
  
	print("\nRebuild2020")
	print("\n  Hello " .. user.GetPlayerName() .. "!")

	CheckForLowStartingScore()  
  
	Populate_g_ScorePartsTable()

	DisplayPuzzleProperties()

	g_OrigSelectedSegmentRanges = FindSelectedSegmentRanges() -- only used in CleanUp()

	local l_bOkayToContinue
	l_bOkayToContinue = AskUserToSelectRebuildOptions() -- Major code in here!
	if l_bOkayToContinue == false then
		-- The user clicked the Cancel button.
		return -- exit script...
	end

	DisplayUserSelectedOptions() -- was printOptions()
  
  DisplayDetailsOfIncludedSegments()
  
	g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
    g_UserSelected_StartingNumberOf_SegmentRanges_ToRebuild_PerRunCycle

	if g_UserSelected_NumberOfSegmentRangesToSkip > 0 then
    
		local l_RememberThisValue = g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle
    
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
      g_UserSelected_NumberOfSegmentRangesToSkip
		g_RunCycle = 0
    
    -- Not! what you are looking for! See below...
		Rebuild1RunWithManySegmentRangeSets("drw") -- was DRcall()
    
		g_UserSelected_NumberOfSegmentRangesToSkip = 0
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle = l_RememberThisValue
    
	end -- if g_UserSelected_NumberOfSegmentRangesToSkip > 0 then
  
  print("------------------------ ------------------  ----------------  -------  ------------------")
  
  for l_RunCycle = 1, g_UserSelected_NumberOfRunCycles do
      
		g_RunCycle = l_RunCycle
    
 		print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "         " ..
      " " .. PaddedNumber((os.clock() - g_ScriptStartTime)/60, 7, 3) .. "m" ..
      " Start of Run " .. g_RunCycle .. " of " .. g_UserSelected_NumberOfRunCycles .. "," ..
      " Rebuild " .. g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle .. 
      " worst scoring segment ranges," .. 
      " w/" .. g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments .. 
      "-" .. g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments ..
      " consecutive segments:")
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
		Rebuild1RunWithManySegmentRangeSets("drw") -- below; was DRcall()
    -- Important!!!
    -- Important!!!
    -- Important!!!
		
		-- Uncomment the methods you want to use...
		-- Rebuild1RunWithManySegmentRangeSets("all")
		-- Rebuild1RunWithManySegmentRangeSets("areas")
		-- Rebuild1RunWithManySegmentRangeSets("fj")
		-- Rebuild1RunWithManySegmentRangeSets("simple")
    
    DisplayEndOfRunStatistics()    
    
		g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle =
      g_UserSelected_MaxNumberOf_SegmentRanges_ToRebuild_ThisRunCycle +
			g_UserSelected_AdditionalNumberOfSegmentRangesToRebuild_PerRunCycle
    
	end -- for l_RunCycle = 1, g_UserSelected_NumberOfRunCycles do

	CleanUp()

end -- Rebuild1PuzzleForManyRuns() -- was DRW()

function Rebuild1RunWithManySegmentRangeSets(l_How) -- was DRcall()
  -- Called from Rebuild1PuzzleForManyRuns() above; was DRW()
  -- Calls Rebuild1SegmentRangeSetWithManySegmentRanges() below; was DeepRebuild()
 
 -- In the grand scheme of things, see below --->>>We Are Here Now<<<---
  -- Start of Script...
  -- Rebuild 1 Puzzle for 15 runs, where
  --   Run 1 rebuilds 3 segment range sets, where <<<---We are Here Now<<<---
  --       Set 1 contains 4 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 4 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 4 segment ranges, each range includes 4 consecutive segments
  --   Run 2 rebuilds 3 segment range sets, where
  --       Set 1 contains 5 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 5 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 5 segment ranges, each range includes 4 consecutive segments
  --   Run 3 rebuilds 3 segment range sets, where
  --       Set 1 contains 6 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 6 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 6 segment ranges, each range includes 4 consecutive segments
  --   ...
  --   Run 15 rebuilds 3 segment ranges sets, where
  --       Set 1 contains 18 segment ranges, each range includes 2 consecutive segments
  --       Set 2 contains 18 segment ranges, each range includes 3 consecutive segments
  --       Set 3 contains 18 segment ranges, each range includes 4 consecutive segments
  -- ...End of Script  
  
	if l_How == "drw" then

		-- drw means Deep Rebuild with Worst scoring segment ranges
    
		-- This method starts the rebuild process with a small number of consecutive
		-- segments, then progressively rebuilds larger numbers of consecutive segments
    
		local l_Step = 1
		if g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments > -- default = 2
			 g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments then -- default = 4
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
			g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments,
			g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments,
			l_Step do
        
			-- ...and that's why we have to do this...
			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments
			
			Populate_g_XLowestScoringSegmentRangesTable() -- was FindWorst()
			
      -- Important!!!
      -- Important!!!
      -- Important!!!
			Rebuild1SegmentRangeSetWithManySegmentRanges() -- below; was DeepRebuild()
      -- Important!!!
      -- Important!!!
      -- Important!!!
      
		end
    
	elseif l_How == "fj" then
    
		Populate_g_XLowestScoringSegmentRangesTable()
    
		l_XLowestScoringSegmentRangesTable = {} -- {StartSegment=1, EndSegment=2}
    
		local l_CurrentSegmentRange = {}
		local l_StartSegment
		local l_EndSegment
    
		-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}
		for l_TableIndex = 1, #g_XLowestScoringSegmentRangesTable do
      
			l_CurrentSegmentRange = g_XLowestScoringSegmentRangesTable[l_TableIndex]
      
			l_StartSegment = l_CurrentSegmentRange[srtrt_StartSegment]
			l_EndSegment = l_CurrentSegmentRange[srtrt_EndSegment]
      
			for l_SegmentIndex = l_StartSegment, l_EndSegment do
        
				for l_ConsecutiveSegmentIndex = 1, g_RequiredNumberOfConsecutiveSegments do
          
					if l_SegmentIndex + l_ConsecutiveSegmentIndex <= l_EndSegment then
            
						-- Finally, add one row to l_WorstSegmentRangesTable,
						-- which will eventually be copied to the g_XLowestScoringSegmentRangesTable below...
            
            -- l_WorstSegmentRangesTable={StartSegment=1, EndSegment=2}
						l_XLowestScoringSegmentRangesTable[#l_XLowestScoringSegmentRangesTable + 1] =
							{l_SegmentIndex, l_SegmentIndex + l_ConsecutiveSegmentIndex}
					end
				end
			end
      
		end
		g_XLowestScoringSegmentRangesTable = l_XLowestScoringSegmentRangesTable
		Rebuild1SegmentRangeSetWithManySegmentRanges()
    
	elseif l_How == "all" then
    
		g_XLowestScoringSegmentRangesTable = {}

		-- Script defaults:
			g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments = 2
			g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments = 4
    
		for l_RequiredNumberOfConsecutiveSegments =
			g_UserSelected_StartRunRebuildingWithThisManyConsecutiveSegments,
			g_UserSelected_EndRunAfterRebuildingWithThisManyConsecutiveSegments do
        
			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments
      
			for l_SegmentIndex = 1, g_SegmentCount_WithoutLigands do
        
				local l_StartSegment = l_SegmentIndex
				local l_EndSegment = g_RequiredNumberOfConsecutiveSegments + l_SegmentIndex - 1
        
				if l_EndSegment <= g_SegmentCount_WithoutLigands then
          
					-- g_XLowestScoringSegmentRangesTable = {StartSegment, EndSegment}
					g_XLowestScoringSegmentRangesTable[#g_XLowestScoringSegmentRangesTable + 1] = 
            {l_StartSegment, l_EndSegment}
				end
        
			end
		end
		Rebuild1SegmentRangeSetWithManySegmentRanges()
    
	elseif l_How == "simple" then
    
		Populate_g_XLowestScoringSegmentRangesTable()
		Rebuild1SegmentRangeSetWithManySegmentRanges()
    
	elseif l_How=="segments" then
    
		g_XLowestScoringSegmentRangesTable = {} -- {StartSegment=1, EndSegment=2}
		Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
		Rebuild1SegmentRangeSetWithManySegmentRanges()
    
	end
  
end -- Rebuild1RunWithManySegmentRangeSets(l_How) -- was DRcall()
function Rebuild1SegmentRangeSetWithManySegmentRanges() -- was DeepRebuild()
  -- Called from Rebuild1RunWithManySegmentRangeSets() above; was DRcall()
  -- Calls Rebuild1SegmentRangeForManyRounds() below; was ReBuild()
  
  -- In the grand scheme of things, see below --->>>We Are Here Now<<<---  
  -- Start of Script...
  -- Rebuild 1 Puzzle for 15 runs, where
  --   Run 1 rebuilds 3 segment range sets, where
  --     Set 1 contains 4 segment ranges, each range includes 2 consecutive segments <<<---We are Here Now
  --     Set 2 contains 4 segment ranges, each range includes 3 consecutive segments
  --     Set 3 contains 4 segment ranges, each range includes 4 consecutive segments
  --   Run 2 rebuilds 3 segment range sets, where
  --     Set 1 contains 5 segment ranges, each range includes 2 consecutive segments
  --     Set 2 contains 5 segment ranges, each range includes 3 consecutive segments
  --     Set 3 contains 5 segment ranges, each range includes 4 consecutive segments
  --   Run 3 rebuilds 3 segment range sets, where
  --     Set 1 contains 6 segment ranges, each range includes 2 consecutive segments
  --     Set 2 contains 6 segment ranges, each range includes 3 consecutive segments
  --     Set 3 contains 6 segment ranges, each range includes 4 consecutive segments
  --   ...
  --   Run 15 rebuilds 3 segment ranges sets, where
  --     Set 1 contains 18 segment ranges, each range includes 2 consecutive segments
  --     Set 2 contains 18 segment ranges, each range includes 3 consecutive segments
  --     Set 3 contains 18 segment ranges, each range includes 4 consecutive segments
  -- ...End of Script  
  
 	local l_StartSegment = 0
	local l_EndSegment = 0
  local l_bStructureChanged = false
  local l_NumberOfTimesStructureChanged = 0

-- g_RunCycle=0 means skip first X number of worst segment ranges. 
-- Selected by the user after a script crash or power outage.
  if g_RunCycle == 0 then    
    for l_SegmentRangeIndex = 1, #g_XLowestScoringSegmentRangesTable do      
   		-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}
      l_StartSegment = g_XLowestScoringSegmentRangesTable[l_SegmentRangeIndex][srtrt_StartSegment]
      l_EndSegment = g_XLowestScoringSegmentRangesTable[l_SegmentRangeIndex][srtrt_EndSegment]      
      SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
    end    
    return    
  end 

	DisplayXLowestScoringSegmentRanges() -- was PrintAreas()

	if g_bUserSelected_ConvertAllSegmentsToLoops == true then
		ConvertAllSegmentsToLoops()
    -- Remember loops are not helices. Loops are just plain swiggly lines...
	end

	-- This is the real meat of this script...
	-- After laboriously determining which segment ranges to work on, 
  -- we finally get to rebuild, shake and wiggle them...

	-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, l_bScorePart_IsActive=3, LongName=4}
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
  --                           StringOfScorePartNumbersWithSamePoseTotalScore=4,
  --                           bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
	for l_SegmentRangeIndex = 1, #g_XLowestScoringSegmentRangesTable do -- was areas[]    
    
		local l_Score_Before_SeveralChangesToSegmentRange = g_Score_ScriptBest
    
		-- g_XLowestScoringSegmentRangesTable={StartSegment=1, EndSegment=2}
		l_StartSegment = g_XLowestScoringSegmentRangesTable[l_SegmentRangeIndex][srtrt_StartSegment]
		l_EndSegment = g_XLowestScoringSegmentRangesTable[l_SegmentRangeIndex][srtrt_EndSegment]
    g_with_segments_x_thru_y = " w/segments " .. l_StartSegment .. "-" .. l_EndSegment
    g_ScorePartText = "" 
    
		-- DisulfideBonds_RememberSolutionWithThemIntact() -- only call this just before calling one of foldit's
    --                                                    rebuild, mutate, shake or wiggle functions.    
		if g_bSketchBookPuzzle == true then
			g_bFoundAHighGain = false
		end
   
    -- Important!!!
    -- Important!!!
    -- Important!!!
    l_NumberOfTimesStructureChanged = Rebuild1SegmentRangeForManyRounds(l_StartSegment, l_EndSegment)
                                                                                            --was ReBuild()
    -- Important!!!
    -- Important!!!
    -- Important!!!
    
    local l_Score_After_RebuildOneSegmentRangeManyTimes = GetPoseTotalScore()
    
    if l_NumberOfTimesStructureChanged > 0 then
    
      -- We just rebuilt one segment range many times. 
      -- Now let's look for ScorePart score improvements...
      Update_g_ScorePart_Scores_Table_StringOfScorePartNumbersWithSamePoseTotalScore_And_FirstInString()
      -- was ListSlots()
      
      -- For each of the above segment range rebuild attempts that successfully changed the protein's
      -- structure, we saved the protein's structure (pose) and any PoseTotalScore and ScoreParts Scores
      -- improvements for each rebuild. 
      -- We will now find the one best improved pose based on ScoreParts scores for this
      -- segment range and see if more mutating, shaking and wiggling will futher improve
      -- our score...
      -- The ScorePart_Number is not only just a number associated with a ScorePart_Name,
      -- it's also the foldit Undo history slot number where the protein's best-scoring- 
      -- score part pose was stored.
      
      local l_bFirstInASet = false
      local l_NumberOfFirstInASets = 0
      local l_Current_ImprovedScorePart_PoseTotalScore = 0
      local l_Best_ImprovedScorePart_PoseTotalScore = -999999
      local l_Best_ImprovedScorePart_Number = 3 -- set to 3 just in case something goes horribly wrong
      local l_Best_ImprovedScorePart_Text = ""
      local l_Best_ImprovedScorePart_StringOfScorePartNumbersWithSamePoseTotalScore = ""

      --g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3,
      --                          StringOfScorePartNumbersWithSamePoseTotalScore=4,
      --                          bFirstInStringOfScorePartNumbersWithSamePoseTotalScore=5}
      
       print("Searching for best scoring score parts...")

      for l_ScorePart_Scores_TableIndex = 1, #g_ScorePartScoresTable do -- original table name: Scores
        
        l_bFirstInASet = g_ScorePartScoresTable[l_ScorePart_Scores_TableIndex]
                                              [spst_bFirstInStringOfScorePartNumbersWithSamePoseTotalScore]
          
        if l_bFirstInASet == true then
          
          l_NumberOfFirstInASets = l_NumberOfFirstInASets + 1
          -- if l_NumberOfFirstInASets does not get higher than 1, then it means every
          -- ScorePart's PoseTotalScore was the same. In other words, most likely none of
          -- the many rebuilds improved the PoseTotalScore. In this case, displaying
          -- the StringOfScorePartNumbersWithSamePoseTotalScore in the log file for any
          -- further improvements is not interesting. So, let's clear g_ScorePartText, to
          -- keep the log file to the minimum.
          
          local l_ScorePart_Number = g_ScorePartScoresTable[l_ScorePart_Scores_TableIndex]
                                                             [spst_ScorePart_Number]
          local l_StringOfScorePartNumbersWithSamePoseTotalScore = 
                              g_ScorePartScoresTable[l_ScorePart_Scores_TableIndex]
                                                      [spst_StringOfScorePartNumbersWithSamePoseTotalScore]
                                                      
                                                      
          if l_StringOfScorePartNumbersWithSamePoseTotalScore == "all" then 
            g_ScorePartText = " ScoreParts:All"
          else
            --if string.len(l_StringOfScorePartNumbersWithSamePoseTotalScore) <= 2 then
            --  l_StringOfScorePartNumbersWithSamePoseTotalScore = ""
            --else
            --  l_StringOfScorePartNumbersWithSamePoseTotalScore = " " .. 
            --    l_StringOfScorePartNumbersWithSamePoseTotalScore 
            --end
            
            -- g_ScorePartsTable{ScorePart_Number=1, ScorePart_Name=2, bScorePart_IsActive=3, LongName=4}
            g_ScorePartText = " ScoreParts:" ..
              --g_ScorePartsTable[l_ScorePart_Number - 3][spt_LongName] .. too much for log file
              l_StringOfScorePartNumbersWithSamePoseTotalScore
            -- g_ScorePartText examples: " ScorePart 4 (total)", " ScorePart 6 (ligand) 6=7=11"
            -- StringOfScorePartNumbersWithSamePoseTotalScore examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
            
          end -- if l_StringOfScorePartNumbersWithSamePoseTotalScore = "all" then 
          
          -- Reload the saved protein pose (protein shape)...
          -- Important!!!
          -- Important!!!
          -- Important!!!
          save.Quickload(l_ScorePart_Number) -- "Load"
          -- Important!!!
          -- Important!!!
          -- Important!!!
          -- See Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields() way above 
          -- for the corresponding save.Quicksave(l_ScorePart_Number) -- "Save"
          
          -- Note 1: ScorePart_Number is being used as a Slot number here.
          -- Note 2: Some of these poses will have lower PoseTotalScores than g_ScoreScriptBest.
          -- That's okay because after we perform some mutates, shakes and wiggles, they might just
          -- become our new best scoring pose!
          -- See Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields()
          -- for the corresponding save.Quicksave(), "Save"
          
          -- Prepare to StabilizePosesOfSelectedScoreParts...
          
          if g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments == true then
              
            local l_SphereRadius = 12
            SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
            g_with_segments_x_thru_y = " Within " .. l_SphereRadius .. " angstroms of" ..
                                       " segments:" .. l_StartSegment .. "-" .. l_EndSegment
              
          else
            
            selection.DeselectAll()
            selection.SelectRange(l_StartSegment, l_EndSegment)            
            g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment
            
          end

          if g_bUserSelected_StabilizePosesOfSelectedScoreParts == true then          
            
            -- User selected StabilizePosesOfSelectedScoreParts (previously known as qStab) ...
            
            -- Important!!!
            -- Important!!!
            -- Important!!!
            StabilizeOnePoseOfSelectedScoreParts(l_StartSegment, l_EndSegment) -- below; was qStab()
            -- Important!!!
            -- Important!!!
            -- Important!!!
            
          else
            
            -- User selected ShakeAndWiggle instead...
            
            SetClashImportance(1)
            
            -- Important!!!
            -- Important!!!
            -- Important!!!
            ShakeSelected("SimpleS&W")  -- FromWhere; below
            WiggleSelected(1, false, true, "SimpleS&W") -- Iterations,bWBackbone,bWSideChains,
            --                                                        FromWhere
            -- Important!!!
            -- Important!!!
            -- Important!!!
            
          end -- if g_bUserSelected_StabilizePosesOfSelectedScoreParts == true then          
          
          if g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts == true then
            
            -- Important!!!
            -- Important!!!
            -- Important!!!
            MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment,
              "AfterStabilize")
              --"AfterStabilizePosesOfSelectedScoreParts")
            -- Important!!!
            -- Important!!!
            -- Important!!!
              
          end -- if g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts == true then
          
          -- Important!!!
          -- Important!!!
          -- Important!!!
          save.Quicksave(l_ScorePart_Number) -- "Save" (2nd save. After improvements, hopefully.)
          -- Important!!!
          -- Important!!!
          -- Important!!!
          -- See just below in this function for the corresponding save.Quickload() "Load"
          
          l_Current_ImprovedScorePart_PoseTotalScore = GetPoseTotalScore()
          
          if l_Current_ImprovedScorePart_PoseTotalScore > 
                l_Best_ImprovedScorePart_PoseTotalScore then
            
            -- We will reload the one best improved score part pose after,
            -- we finish checking every ScorePart for an improvement...
            
            -- Is this stupid? Won't the highest scoring pose already 
            -- be the current pose? It's not like we are rebuilding one
            -- pose per ScorePart (where each ScorePartName improved the most; not most, latest! Booo!)
            -- No, we are not rebulding anything. We are shaking,
            -- wiggling and mutating at most #OfScoreParts (usually around 11 
            -- ScoreParts, e.g., 4 thru 14, i.e., "total, loctotal, clashing...pairwise...")
            -- Some of the ScoreParts will have the same pose (assumed the same b/c they
            -- have the same PoseTotalScore), and we will only shake, wiggle and mutate
            -- the unique poses, so there will be less than #OfScoreParts poses to
            -- shake, wiggle and mutate. During the many rebuilds, each time the total
            -- score improves, we look to see which scoreparts improved. For those
            -- scoreparts that improved, we assign the latest PoseTotalScore to that scorepart.
            -- Scorepart 4, total, always improves when the total score improves, so 
            -- Scorepart 4 is always updated when the total score improves. I assume
            -- that every PoseTotalScore improvement is a result of at least one ScorePart 
            -- improvement; therefore, scorepart 4 will always match at least one
            -- other scorepart. So, each PoseTotalScore associated with each ScorePart,
            -- is the PoseTotalScore from the last rebuild that that ScorePart contributed
            -- to an improvement of the PoseTotalScore. Is this really all that significant?
            -- I mean, so what, it might have been a tiny improvement and very early on in
            -- the rebuilds (of the whopping 10 rebuilds). I say we just stick with the 
            -- current best pose and move on. How about some empirical data to prove this? Like,
            -- what were the points gained during "StabilizePosesOfSelectedScoreParts" versus "Rebuild",
            -- "Mutate" or "Fuse"? Ah, I need to improve our reporting statistics, don't I?
            -- Some anecdotal evidence: Points gained from...
            -- Rebuild: 1,31,41,4,11,
            -- StabilizePosesOfSelectedScoreParts: 609 (scorepart 4, total, doesn't count!) (anyhow, we
            -- will still perform the StabilizePosesOfSelectedScoreParts, even if we decide not to improve
            -- each ScoreParts latest improvement! 
            -- So...what. scrap it?)
            -- StabilizePosesOfSelectedScoreParts: 60 scorepart 7, .9 (scorepart 4, total, again, total 
            -- doesn't count!)
            -- Mutate: 61, 6, 11, 14
            -- Fuse best score part pose: .001, .002
            --print("Stabilized score: " .. 
            --  PaddedNumber(l_Current_ImprovedScorePart_PoseTotalScore, 1,3) ..
            --  " from slot: " .. l_ScorePart_Number)
            l_Best_ImprovedScorePart_Number = l_ScorePart_Number
            l_Best_ImprovedScorePart_Text = g_ScorePartText
            l_Best_ImprovedScorePart_StringOfScorePartNumbersWithSamePoseTotalScore =
              l_StringOfScorePartNumbersWithSamePoseTotalScore

            l_Best_ImprovedScorePart_PoseTotalScore =
                l_Current_ImprovedScorePart_PoseTotalScore
               
          end        
          
        end -- if l_bFirstInASet == true then
        
      end -- for l_ScorePart_Scores_TableIndex = 1, #g_ScorePartScoresTable do    
    
      -- Load the best score part pose...
      -- Important!!!
      -- Important!!!
      -- Important!!!
      save.Quickload(l_Best_ImprovedScorePart_Number) -- "Load"
      -- Important!!!
      -- Important!!!
      -- Important!!!
      -- See just above in this function for the corresponding save.Quicksave() "Save"
 
      -- Prepare to Fuse best SorePart Pose...
      
      local l_Plural = "s "
      if string.len(g_ScorePartText) <= 2 then l_Plural = " " end
      print("Found best scoring score part" .. l_Plural .. 
             l_Best_ImprovedScorePart_StringOfScorePartNumbersWithSamePoseTotalScore ..
           " with score of " .. PaddedNumber(l_Best_ImprovedScorePart_PoseTotalScore, 1, 3))
         
      g_ScorePartText = l_Best_ImprovedScorePart_Text

      local l_Score_After_SeveralChangesToSegmentRange = GetPoseTotalScore()
      
      local l_PotentialPointLoss = l_Score_Before_SeveralChangesToSegmentRange - 
                                   l_Score_After_SeveralChangesToSegmentRange
                                    
      local l_MaxLossAllowed = g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints * 
                              (l_EndSegment - l_StartSegment + 1) / 3
                              
      if g_bUserSelected_FuseBestScorePartPose == true then
        
        if l_PotentialPointLoss > l_MaxLossAllowed then
          -- This will never happen because we only restore poses with the same or improved
          -- PoseTotalScore.
          
          print("  Skipping Fuse best score part pose because Potential Loss of " .. 
              l_PotentialPointLoss .. " points is " ..
              "greater than Max Loss Allowed of " .. l_MaxLossAllowed .. ".")        
          
        else
          
          -- The following checks if g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts ==
          -- false because if it were true, then we would have already performed the mutate above, after
          -- the StabilizePosesOfSelectedScoreParts.
          if g_bUserSelected_MutateBeforeFuseBestScorePartPose == true and
             g_bUserSelected_MutateAfterStabilizePosesOfSelectedScoreParts == false then
               
              -- Important!!!
              -- Important!!!
              -- Important!!!
              MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment,
                "BeforeFuse") -- below
                --"BeforeFuseBestScorePartPose") -- below
              -- Important!!!
              -- Important!!!
              -- Important!!!
            
          end -- if g_bUserSelected_MutateBeforeFuseBestScorePartPose == true and g_bUserSelected_Mut...
          
          -- Continue preparing to Fuse the best score part pose...
          
          save.Quicksave(4) -- "Save"; Well, I don't think slot 4 means the same as it used to. 
          --                         I need to check the original code to see if it is still needed.
          --                         The name for ScorePart/Slot 4 is "Total", which is the total of 
          --                         all score part scores.
          if g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments == true then
            
            local l_SphereRadius = 12
            SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
            g_with_segments_x_thru_y = " Within " .. l_SphereRadius .. " angstroms of" ..
                                       " segments:" .. l_StartSegment .. "-" .. l_EndSegment
            
          else
            
            selection.DeselectAll()
            selection.SelectRange(l_StartSegment, l_EndSegment)            
            g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment
            
          end
          
          -- Important!!!
          -- Important!!!
          -- Important!!!
          FuseBestScorePartPose() -- below; was Fuze()
          -- Important!!!
          -- Important!!!
          -- Important!!!
          
          save.Quicksave(4) -- Save (hopefully improved) Fused pose as ScorePart/Slot 4
          
          if g_bUserSelected_MutateAfterFuseBestScorePartPose == true then
            
            -- Important!!!
            -- Important!!!
            -- Important!!!
            MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment,
              "AfterFuse") -- below
              --"AfterFuseBestScorePartPose") -- below
            -- Important!!!
            -- Important!!!
            -- Important!!!
          end
          
        end --  if l_PotentialPointLoss > l_MaxLossAllowed then
        
      end -- if g_bUserSelected_FuseBestScorePartPose == true then
      
    end -- if l_bStructureChanged == true then
      
    local l_bBondsBroke = DisulfideBonds_DidAnyOfThemBreak()
    
		if g_bUserSelected_KeepDisulfideBondsIntact == true and l_bBondsBroke == true then
        
				print("\nOne or more disulfide bonds are broken at a point where they should not be." ..
              "\nNormally this should never happen because we should be calling" ..
               " DisulfideBonds_RememberSolutionWithThemIntact() before any rebuild, mutate, shake or" ..
               " wiggle." ..
               "\nAnd we should be calling DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()" ..
               " after any rebuild, mutate, shake or wiggle." ..
              "\nIf you are getting this message in the log file, then check the code to" ..
               " make sure the above mentioned calls are being made as required." ..
              "\nDiscarding score gains and restoring last known vaild protein pose.\n")
				DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
        
		end
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
		SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment) -- was
    -- Important!!!
    -- Important!!!
    -- Important!!!
    
    -- I think this should be the end of this function!
    
    
    local l_Score_After_SeveralMoreChangesToSegmentRange = GetPoseTotalScore()
    
		g_CurrentRebuildPointsGained = l_Score_After_SeveralMoreChangesToSegmentRange -
                                   l_Score_Before_SeveralChangesToSegmentRange
    -- g_CurrentRebuildPointsGained is checked in bSegmentIsAllowedToBeRebuilt().
    
    l_RemainingSegmentRanges = #g_XLowestScoringSegmentRangesTable - l_SegmentRangeIndex
    
    -- I really don't like this next check...
    -- Does this check really improve the build process? Or, does it simply skip a bunch of
    -- really good rebuild prospects of segment ranges with fewer consecutive segments...
    -- We need indisputable comparison data to prove this is a good idea...
    -- Comparison data should include many puzzle types, with score and time elapsed comparisons.
		if (g_CurrentRebuildPointsGained -
      g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan) > 0.001 and
      l_RemainingSegmentRanges > 0 then
    
		-- The default for g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan
    -- is 40 or less. Why such a low number?
    
    -- We just gained > g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan;
		-- therefore, we figure that's good enough for now. It is now time to move on to more consecutive
    -- segments per segment range...
      
      print("The current rebuild gain of " .. PrettyNumber(g_CurrentRebuildPointsGained) ..
            " points for this segment range is greater than the 'Move on to more consecutive" ..
            " segments per range if current rebuild points gained is more than' value of " ..
            g_UserSelected_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildPointsGainedIsMoreThan .. 
            " points (this value can be changed on the 'More Options' page);" ..
            " therefore, we will now skip the remaining " .. l_RemainingSegmentRanges ..
            " segment ranges with " .. g_RequiredNumberOfConsecutiveSegments .. 
            " consecutive segments, and begin processing segments ranges with " ..
            (g_RequiredNumberOfConsecutiveSegments + 1) .. " consecutive segments.")
      
			break -- for l_SegmentRangeIndex = 1, #g_XLowestScoringSegmentRangesTable do
      
		end
  
	end -- for l_SegmentRangeIndex = 1, #g_XLowestScoringSegmentRangesTable do
  
	if g_bUserSelected_ConvertAllSegmentsToLoops == true and g_bSavedSecondaryStructure == true then
    
    -- The following is needed because of the call to ConvertAllSegmentsToLoops() at the beginning
    -- of this function.
    
		save.LoadSecondaryStructure() -- <-- this is a very interesting concept. Couldn't this, reloading of
    -- previously stored secondary structure, cause a major increase/decrease in PoseTotalScore?
    -- Also, since there are likely many more Runs to process, will we be saving off the secondary
    -- structure again at the beginning of the next Run? And if so, why bother saving and loading
    -- the secondary stucture every Run. Why not just save it once at the beginning of the script,
    -- and reload it at the end of the script. Anyhow, does it really make sense to change the
    -- secondary structure at all? Doesn't that just denature the protein? I am soo confused.
    
	end
  
end -- Rebuild1SegmentRangeSetWithManySegmentRanges() -- was DeepRebuild()
function Rebuild1SegmentRangeForManyRounds(l_StartSegment, l_EndSegment) -- was ReBuild()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges() above; was DeepRebuild()
  -- Calls RebuildSelectedSegmentsForMax3Attempts() below; was localRebuild()
  -- Calls ShakeSelected() below
  -- Calls WiggleSelected() below
  -- Calls MutateSideChainsOfSelectedSegments() below
  -- Calls Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields() way above
  
	Reset_g_ScorePart_Scores_Table() -- was ClearScores()

	if l_StartSegment > l_EndSegment then
		l_StartSegment, l_EndSegment = l_EndSegment, l_StartSegment
	end --switch around if needed

  local l_Score_Before_RebuildSelectedSegmentsForOneRound = 0
  local l_Score_After_RebuildSelectedSegmentsForOneRound = 0
  local l_bStructureChanged = false
  local l_NumberOfTimesStructureChanged = 0
  
	-- Maximum number of rounds (with up to 3 attempts per round) to attempt to favorably change 
  -- the protein structure using structure.RebuildSelected for each segment range per run cycle:
	local l_MaxRounds = 
		g_UserSelected_MaxNumberOfRoundsToRebuildEachSegmentRangePerRunCycle -- default is 15
    
  recentbest.Restore() -- can't hurt.
  
	for l_Round = 1, l_MaxRounds do
   
    g_round_x_of_y = " Round:" .. l_Round .. "of" .. l_MaxRounds
    g_ScorePartText = ""
   
		if g_bSketchBookPuzzle == true then 
			save.Quickload(3) -- I doubt this is needed! And possibly dangerous.
		end       
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
		l_bStructureChanged = 
      RebuildSelectedSegmentsForMax3Attempts(l_StartSegment, l_EndSegment) -- localRebuild()
    -- Important!!!
    -- Important!!!
    -- Important!!!
    
    -- NEW!!! We are looking for ANY change to the structure, 
    -- with a positive OR a slightly negative score change!!!
    if l_bStructureChanged == true then
      
      l_NumberOfTimesStructureChanged = l_NumberOfTimesStructureChanged + 1
      
      -- Shake segment range (currently selected segments) with user selected clash importance...
      g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment
      l_ClashImportance = g_UserSelected_AfterRebuildShakeSegmentRangeClashImportance
      SetClashImportance(l_ClashImportance)
      
      -- Important!!!
      -- Important!!!
      -- Important!!!
      ShakeSelected("AfterRebuild") -- FromWhere; below
      -- Important!!!
      -- Important!!!
      -- Important!!!
      
      if g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild == true then
        -- User selected "After Each Rebuild - Add 2xRegional plus 4xLocal Wiggles - Very slow!"
        --               " (w/SideChains, w/Backbone, w/Clash Importance = 1.0)"
        
        local l_SphereRadius = 9 -- Angstroms; maybe record in the log file? Or too boring?...
        SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)            
        g_with_segments_x_thru_y = " Within " .. l_SphereRadius .. " angstroms of" ..
                                   " segments:" .. l_StartSegment .. "-" .. l_EndSegment
        
        SetClashImportance(1)
        
      -- Important!!!
      -- Important!!!
      -- Important!!!
        ShakeSelected("AfterRebuild") -- FromWhere; below
        WiggleSelected(2, false, true, "AfterRebuild") -- Iterations,w/Bb,w/SC,FromWhere; below
      -- Important!!!
      -- Important!!!
      -- Important!!!
        ShakeSelected("AfterRebuild") -- FromWhere; below
      -- Important!!!
      -- Important!!!
      -- Important!!!
        
        selection.DeselectAll()
        selection.SelectRange(l_StartSegment, l_EndSegment)
        g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment		
        
      -- Important!!!
      -- Important!!!
      -- Important!!!
        ShakeSelected("AfterRebuild") -- FromWhere; below
        WiggleSelected(4, true, false, "AfterRebuild") -- Iterations, bWBackbone, bWSideChains, FromWhere
      -- Important!!!
      -- Important!!!
      -- Important!!!
        
      end -- if g_bUserSelected_ExtraShakeAndWiggles_AfterRebuild == true then
     
      if g_bUserSelected_MutateAfterRebuild == true then
        
        -- Important!!!
        -- Important!!!
        -- Important!!!
        MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "AfterRebuild") -- below
        -- Important!!!
        -- Important!!!
        -- Important!!!
        
      end -- if g_bUserSelected_MutateAfterRebuild == true then
        
      -- We have just rebuilt (and optionally, mutated, shaked and wiggled) only one segment
      -- range and only one attempt. Next, we are going to check for ScorePart improvements
      -- for this one specific rebuild attempt. For each ScorePart that improves, associate
      -- the current pose (and PoseTotalScore) of the protein to that ScorePart. Later, after
      -- all these rebuild attempts, in Rebuild1SegmentRangeSetWithManySegmentRanges() above,
      -- we will step through each of these best saved score part poses and mutate, shake and
      -- wiggle them some more to see if we can further improve their scores...
          
      -- Important!!!
      -- Important!!!
      -- Important!!!
      Update_g_ScorePart_Scores_Table_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment,
                                                                                l_EndSegment) -- SaveScores
      -- Important!!!
      -- Important!!!
      -- Important!!!
          
    end -- if l_bStructureChanged == true then
    
    -- If there was no favorable (i.e.; increase in points or very small decrease in points) change to 
    -- the structure then stop processing this segment range and move on to the next one...
    if l_bStructureChanged == false then
      -- This section is unlikely now that we allow large negative scores to continue on to stabilize...
      
      -- new!!!
      recentbest.Restore()
      
      if l_Round < l_MaxRounds then
        print(PaddedNumber(g_Score_ScriptBest, 9, 3) ..
              "                    " ..
              "Rebuilding round" ..
              g_round_x_of_y ..
              g_with_segments_x_thru_y ..
              " Rejected 3 times in a row: moving on to next segment range")
        
      end
      break -- for l_Round = 1, l_MaxRounds do
      
    end
   
	end -- for l_Round = 1, l_MaxRounds do
  
  g_round_x_of_y = "" --<-- This will help clean up the log file, by not showing round x of y 
  --                        during parts of code, like stabilize and fuse, when we are not in
  --                        the above "for" loop. Especially when calling WiggleAll(), which
  --                        is like 99% of the lines of the log file! Hello
	
	SetClashImportance(1) -- This call to SetClashImportance is probably not needed here because we
  --                       normally SetClashImportance just before each rebuild, shake, wiggle and
  --                       mutate. I'll double check.
  --print("l_NumberOfTimesStructureChanged = " .. l_NumberOfTimesStructureChanged)
	return l_NumberOfTimesStructureChanged

end -- Rebuild1SegmentRangeForManyRounds() -- was ReBuild()
function RebuildSelectedSegmentsForMax3Attempts(l_StartSegment, l_EndSegment) -- was localRebuild()
  -- Called from Rebuild1SegmentRangeForManyRounds() above; was Rebuild()
  -- Calls structure.RebuildSelected() foldit code
  
  -- For Round X of Y, Rebuild Selected Segments a Maximum of 3 Attempts...

  local l_TimeBefore = os.clock()
  local l_ScoreImprovement = 0
  local l_bStructureChanged = false
  local l_MaxLossAllowed = g_UserSelected_RejectEachRebuildWithAPotentialLossExceedingXPoints * 
                          (l_EndSegment - l_StartSegment + 1) / 3
  
	-- We have to set clash importance and select segment range every time this function is 
  -- called (each rebuild round) because shakes, wiggles and mutates will change these values...
	SetClashImportance(g_RebuildClashImportance) -- g_RebuildClashImportance is always 0, so what's the point
	selection.DeselectAll()
	selection.SelectRange(l_StartSegment, l_EndSegment)
  g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment		
  
	if g_bUserSelected_DisableBandsDuringRebuild == true then
		band.DisableAll() -- will re-enable after rebuild.
	end

  local l_MaxAttemptsPerRound = 3 -- the original code used l_Round here from Rebuild()
  for l_CurrentAttemptForThisRound = 1, l_MaxAttemptsPerRound do
    
    local l_RebuildIterations = l_CurrentAttemptForThisRound
    
    DisulfideBonds_RememberSolutionWithThemIntact() -- was Bridgesave()
    
    -- Important!!!
    -- Important!!!
    -- Important!!!
		structure.RebuildSelected(l_RebuildIterations) -- foldit code
    -- Important!!!
    -- Important!!!
    -- Important!!!
		
    DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact() -- was Bridgerestore()
  
    local l_TimeAfter = os.clock()
    local l_SecondsUsed = l_TimeAfter - l_TimeBefore
    l_Score_After_Rebuild = GetPoseTotalScore()
    l_ScoreImprovement = l_Score_After_Rebuild - g_Score_ScriptBest
    
    if l_Score_After_Rebuild ~= g_Score_ScriptBest then
      l_bStructureChanged = true
    end      
    
    if l_Score_After_Rebuild > g_Score_ScriptBest then      
      print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" .. 
            PaddedNumber(l_ScoreImprovement, 8, 3) .. " " .. 
            PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
            l_RebuildIterations .. "xRebuildSelected" ..
            g_round_x_of_y ..
            g_with_segments_x_thru_y ..
            " Structure changed: move to next round")
      g_Stats_Run_TotalPointsGained_RebuildSelected =
      g_Stats_Run_TotalPointsGained_RebuildSelected + l_ScoreImprovement
      g_Stats_Run_SuccessfulAttempts_RebuildSelected = 
      g_Stats_Run_SuccessfulAttempts_RebuildSelected + 1
      SaveBest() -- <-- Updates g_Score_ScriptBest
          
    elseif l_Score_After_Rebuild == g_Score_ScriptBest then        
      print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " .. 
            "         " .. 
            PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
            l_RebuildIterations .. "xRebuildSelected" ..
            g_round_x_of_y ..
            g_with_segments_x_thru_y ..
            " No Score Change")
        
    elseif l_Score_After_Rebuild < g_Score_ScriptBest then      
      -- We allow any loss of points here...
      print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " .. 
            "         " .. 
            PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
            l_RebuildIterations .. "xRebuildSelected" ..
            g_round_x_of_y ..
            g_with_segments_x_thru_y ..
            " Structure changed: move to next round" ..
            " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
      -- argh! recentbest.Restore()    
    end
    g_Stats_Run_TotalSecondsUsed_RebuildSelected = 
    g_Stats_Run_TotalSecondsUsed_RebuildSelected + l_SecondsUsed
    g_Stats_Run_NumberOfAttempts_RebuildSelected = 
    g_Stats_Run_NumberOfAttempts_RebuildSelected + 1
      
    if l_bStructureChanged == true then
      
      break -- We break out of the rebuild attempts loop after the first successful rebuild.
    
    end -- if l_bStructureChanged == true then
    
  end -- for l_CurrentAttemptForThisRound = 1, l_MaxAttemptsPerRound do

	if g_bUserSelected_DisableBandsDuringRebuild == true then
		band.EnableAll()
	end
  return l_bStructureChanged

end -- RebuildSelectedSegmentsForMax3Attempts() -- was localRebuild()
function ShakeSelected(l_FromWhere)
  -- Called from 5 functions above and below
      
  local l_TimeBefore = os.clock()
  
  local l_ClashImportance = behavior.GetClashImportance()
  local l_ClashImportanceText = " ClashImp:" .. PaddedNumber(l_ClashImportance, 0 , 2)

	-- Shake is not considered to do much in second or more 
  -- rounds; therefore, we always set Iterations = 1...
    
  DisulfideBonds_RememberSolutionWithThemIntact()
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
  structure.ShakeSidechainsSelected(1) -- Iterations; foldit code
  -- Important!!!
  -- Important!!!
  -- Important!!!
  
  DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
    
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  local l_Score_After_Shake = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Shake - g_Score_ScriptBest
  
  if l_Score_After_Shake > g_Score_ScriptBest then
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
    SaveBest() -- <-- Updates g_Score_ScriptBest
    
  elseif l_Score_After_Shake == g_Score_ScriptBest then    
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
      "         " ..
      PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
      l_FromWhere .. ":1xShakeSidechainsSelected" ..
      g_round_x_of_y ..
      g_with_segments_x_thru_y ..
      g_ScorePartText ..
      l_ClashImportanceText ..
      " No score change")
        
  elseif l_Score_After_Shake < g_Score_ScriptBest then
    -- Undo this Shake because it decreased our score...(not yet!)
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":1xShakeSidechainsSelected" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText ..
          l_ClashImportanceText ..
          " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Accepted:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Rejected:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
    -- argh! recentbest.Restore()
    
  end
  g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected =
  g_Stats_Run_TotalSecondsUsed_ShakeSidechainsSelected + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected =
  g_Stats_Run_NumberOfAttempts_ShakeSidechainsSelected + 1 
   
end -- ShakeSelected(l_FromWhere)
function WiggleSelected(l_Iterations, l_bWBackbone, l_bWSideChains, l_FromWhere)
  -- Called from 5 functions above
  
  local l_TimeBefore = os.clock()
  
  local l_ClashImportance = behavior.GetClashImportance()
  local l_ClashImportanceText = " ClashImp:" .. PaddedNumber(l_ClashImportance, 0, 2)

	-- Lets amplify the iterations for a bigger effect...
	local l_WiggleFactor = 1
	if g_bMaxClashImportance == true then
		l_WiggleFactor = g_UserSelected_WiggleFactor
	end
	local l_WF_Iterations = 2 * l_WiggleFactor * l_Iterations

  DisulfideBonds_RememberSolutionWithThemIntact()
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
  structure.WiggleSelected(l_WF_Iterations, l_bWBackbone, l_bWSideChains) -- foldit code
  -- Important!!!
  -- Important!!!
  -- Important!!!
  
  DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
  
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  local l_Score_After_Wiggle = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Wiggle - g_Score_ScriptBest
  if l_Score_After_Wiggle > g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
          PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" ..
          l_WF_Iterations .. "xWiggleSelected(" ..
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
    SaveBest() -- <-- Updates g_Score_ScriptBest
    
  elseif l_Score_After_Wiggle == g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" ..
          l_WF_Iterations .. "xWiggleSelected(" ..
          "Bb=" .. tostring(l_bWBackbone) .. "," ..
          "SC=" .. tostring(l_bWSideChains) .. ")" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText ..
          l_ClashImportanceText ..
          " No score change")
        
  elseif l_Score_After_Wiggle < g_Score_ScriptBest then
    -- Undo this WiggleSelected because it decreased our score...(not yet!)
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" ..
          l_WF_Iterations .. "xWiggleSelected(" ..
          "Bb=" .. tostring(l_bWBackbone) .. "," ..
          "SC=" .. tostring(l_bWSideChains) .. ")" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText ..
          l_ClashImportanceText .. 
          " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Rejected:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
    -- argh! recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_WiggleSelected =
  g_Stats_Run_TotalSecondsUsed_WiggleSelected + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_WiggleSelected =
  g_Stats_Run_NumberOfAttempts_WiggleSelected + 1
    
end -- WiggleSelected(l_ClashImportance, l_FromWhere)
function WiggleAll(l_Iterations, l_FromWhere)
  -- Called from 5 functions above and below
  
  local l_TimeBefore = os.clock()
  
  selection.SelectAll() -- is this needed, when calling structure.WiggleAll? Probably!
  local l_ClashImportance = behavior.GetClashImportance()
  local l_ClashImportanceText = ""
  if l_ClashImportance == 1 then
    l_ClashImportanceText = " ClashImp:1"
  else
  -- Clash Importance for WiggleAll is almost always 1 (perhaps by accident even; see the note 
  -- at the end of this function), so it's not usually interesting in the log file. But if it's
  -- not 1, then it might be interesting...
    l_ClashImportanceText = " ClashImp:" .. PaddedNumber(l_ClashImportance, 0, 2)
  end
  
	-- Lets amplify the iterations for a bigger effect...
	local l_WiggleFactor = 1
	if g_bMaxClashImportance == true then
		l_WiggleFactor = g_UserSelected_WiggleFactor
	end
	l_Iterations = 2 * l_WiggleFactor * l_Iterations
  
	l_bWiggleBackbone  = true
	l_bWiggleSideChains = true

  DisulfideBonds_RememberSolutionWithThemIntact()
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
  structure.WiggleAll(l_Iterations, l_bWiggleBackbone, l_bWiggleSideChains) -- foldit code
  -- Important!!!
  -- Important!!!
  -- Important!!!
  
  DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
  
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  local l_Score_After_Wiggle = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Wiggle - g_Score_ScriptBest
  if l_Score_After_Wiggle > g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
          PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" .. l_Iterations .. "xWiggleAll(Bb,SC)" ..
          g_round_x_of_y ..
          g_ScorePartText ..
          l_ClashImportanceText)
       
    local l_SecondsUsed = 0
    g_Stats_Run_TotalPointsGained_WiggleAll =
    g_Stats_Run_TotalPointsGained_WiggleAll + l_ScoreImprovement
    g_Stats_Run_SuccessfulAttempts_WiggleAll =
    g_Stats_Run_SuccessfulAttempts_WiggleAll + 1
    SaveBest() -- <-- Updates g_Score_ScriptBest
    
  elseif l_Score_After_Wiggle == g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" .. l_Iterations .. "xWiggleAll(Bb,SC)" ..
          g_round_x_of_y ..
          g_ScorePartText ..
          l_ClashImportanceText ..
          " No score change")
  
  elseif l_Score_After_Wiggle < g_Score_ScriptBest then
    -- Undo this WiggleAll because it decreased our score... (not here!)
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":" .. l_Iterations .. "xWiggleAll(Bb,SC)" ..
          g_round_x_of_y ..
          g_ScorePartText ..
          l_ClashImportanceText ..
          " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Rejected:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
    -- argh! recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_WiggleAll =
  g_Stats_Run_TotalSecondsUsed_WiggleAll + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_WiggleAll =
  g_Stats_Run_NumberOfAttempts_WiggleAll + 1

  SetClashImportance(1) --<--we almost always set clash importance before calling any rebuild,
  --                         mutate, shake or wiggle. So, you would think that setting clash
  --                         importance to any value here at the end of this function would not make
  --                         any difference. But... in the unusual case of FuseBestScorePartPose, almost
  --                         as if by accident (maybe it is), clash importance does not get set between
  --                         two calls to WiggleAll (once, at the end of both Fuse1 and Fuse2, 
  --                         and then again back in FuseBestScorePartPose). It just so happens
  --                         that this second call to WiggleAll, with the clash importance set to
  --                         1 from this function, is where most of the lines in the log file come
  --                         from. Huh. Do most of our points come from WiggleAll? I wonder.

end -- function WiggleAll(l_ClashImportance, l_FromWhere)
function MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, l_FromWhere)
  -- Called from 3 functions above and below

	if g_NumberOfMutableSegments < 1 then
		return
	end
 
 	if g_bUserSelected_MutateOnlySelectedSegments == false and
     g_bUserSelected_MutateSelectedAndNearbySegments == false then
    -- User unchecked both "OnlySelected" and "SelectedAndNearby",
    -- so we will mutate all segments...
    return MutateSideChainsAll(l_FromWhere)
  end  
  
  local l_TimeBefore = os.clock()
  
	-- Mutate what user selected to do...
	if g_bUserSelected_MutateOnlySelectedSegments == true then
    
		selection.DeselectAll()
		selection.SelectRange(l_StartSegment, l_EndSegment)
    g_with_segments_x_thru_y = " Segments:" .. l_StartSegment .. "-" .. l_EndSegment          
  
  else -- if g_bUserSelected_MutateSelectedAndNearbySegments == true then
    
    local l_SphereRadius = g_UserSelected_MutateSphereRadius
 		SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
    g_with_segments_x_thru_y = " Within " .. l_SphereRadius .. " angstroms of" ..    
                               " segments:" .. l_StartSegment .. "-" .. l_EndSegment
  end
    
	SetClashImportance(g_UserSelected_MutateClashImportance) -- default is 0.9 (close to 1)
  local l_MaxIterations = 2  

  DisulfideBonds_RememberSolutionWithThemIntact()
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
	structure.MutateSidechainsSelected(l_MaxIterations) -- foldit code
  -- Important!!!
  -- Important!!!
  -- Important!!!
  
  DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
  
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  l_Score_After_Mutate = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Mutate - g_Score_ScriptBest
  if l_Score_After_Mutate > g_Score_ScriptBest then
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
    SaveBest() -- <-- Updates g_Score_ScriptBest
    
  elseif l_Score_After_Mutate == g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsSelected" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText ..
          " No Score Change")
    
  elseif l_Score_After_Mutate < g_Score_ScriptBest then
    -- Undo this Mutate because it decreased our score...(not yet!)
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsSelected" ..
          g_round_x_of_y ..
          g_with_segments_x_thru_y ..
          g_ScorePartText ..
          " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Rejected:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
    -- argh! recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected =
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsSelected + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected =
  g_Stats_Run_NumberOfAttempts_MutateSidechainsSelected + 1

end -- MutateSideChainsOfSelectedSegments()
function MutateSideChainsAll(l_FromWhere)
  -- Called from MutateSideChainsOfSelectedSegments() above
 
	if g_NumberOfMutableSegments < 1 then
		return
	end

  local l_TimeBefore = os.clock()
  
  selection.SelectAll() -- is this needed, when calling structure.MutateSideChainsAll? Probably!
	SetClashImportance(g_UserSelected_MutateClashImportance) -- default is 0.9 (close to 1)
	local l_MaxIterations = 2  
  
  DisulfideBonds_RememberSolutionWithThemIntact()
  
  -- Important!!!
  -- Important!!!
  -- Important!!!
  structure.MutateSidechainsAll(l_MaxIterations) --- foldit code
  -- Important!!!
  -- Important!!!
  -- Important!!!
  
  DisulfideBonds_CheckIfWeNeedToRestoreSolutionWithThemIntact()
  
  local l_TimeAfter = os.clock()
  local l_SecondsUsed = l_TimeAfter - l_TimeBefore
  
  l_Score_After_Mutate = GetPoseTotalScore()
  local l_ScoreImprovement = l_Score_After_Mutate - g_Score_ScriptBest
  if l_Score_After_Mutate > g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. " +" ..
          PaddedNumber(l_ScoreImprovement, 8, 3) .. " " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsAll" ..
          g_round_x_of_y ..
          g_ScorePartText)
    
    g_Stats_Run_TotalPointsGained_MutateSidechainsAll =
    g_Stats_Run_TotalPointsGained_MutateSidechainsAll + l_ScoreImprovement
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll =
    g_Stats_Run_SuccessfulAttempts_MutateSidechainsAll + 1
    SaveBest() -- <-- Updates g_Score_ScriptBest
    
  elseif l_Score_After_Mutate == g_Score_ScriptBest then
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsAll" ..
          g_round_x_of_y ..
          g_ScorePartText ..
          " No score change")
  
  elseif l_Score_After_Mutate < g_Score_ScriptBest then
    -- Undo this Mutate because it decreased our score...(not yet!)
    print(PaddedNumber(g_Score_ScriptBest, 9, 3) .. "  " ..
          "         " ..
          PaddedNumber(l_SecondsUsed, 6, 3) .. "s " ..
          l_FromWhere .. ":2xMutateSidechainsAll" ..
          g_round_x_of_y ..
          g_ScorePartText ..
          " " .. PaddedNumber(l_ScoreImprovement, 1, 3))
          --" Rejected:" .. PaddedNumber(l_ScoreImprovement, 1, 3))
    -- argh! recentbest.Restore()
  end
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll =
  g_Stats_Run_TotalSecondsUsed_MutateSidechainsAll + l_SecondsUsed
  g_Stats_Run_NumberOfAttempts_MutateSidechainsAll =
  g_Stats_Run_NumberOfAttempts_MutateSidechainsAll + 1    
  
end -- MutateSideChainsAll(l_FromWhere)
function StabilizeOnePoseOfSelectedScoreParts(l_StartSegment, l_EndSegment) -- was qStab()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges() above

	SetClashImportance(0.1)
	--ShakeSelected("StabilizeScorePartPose")
  ShakeSelected("Stabilize")
	
	if g_bUserSelected_MutateDuringStabilizePosesOfSelectedScoreParts == true then
		SetClashImportance(1)
		--MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "StabilizePosesOfSelectedScoreParts")
    MutateSideChainsOfSelectedSegments(l_StartSegment, l_EndSegment, "Stabilize")
	end
	
	if g_bUserSelected_ExtraStabilizePosesOfSelectedScoreParts == true then -- default is false
    
    SetClashImportance(0.4)
    --WiggleAll(1, "ExtraStabilizePosesOfSelectedScoreParts") -- Iterations, FromWhere
    WiggleAll(1, "ExtraStabilize") -- Iterations, FromWhere
    
		-- Note the third parameter uses the global value instead of the local value here...
    SetClashImportance(1)
		--ShakeSelected("ExtraStabilizePosesOfSelectedScoreParts")
    ShakeSelected("ExtraStabilize")

	end
	
	SetClashImportance(1)
  --WiggleAll(3, "StabilizePosesOfSelectedScoreParts") -- Iterations, FromWhere
  WiggleAll(3, "Stabilize") -- Iterations, FromWhere
  recentbest.Restore() -- will keep current if best

end -- function StabilizeOnePoseOfSelectedScoreParts(l_StartSegment, l_EndSegment)
function FuseBestScorePartPose()
  -- Called from Rebuild1SegmentRangeSetWithManySegmentRanges() above

	Fuse1(0.3, 0.6) -- ClashImp_Before, ClashImp_After
  Fuse3()
	Fuse2(0.3, 1) -- ClashImportance_Before, ClashImportance_After
  
	Fuse1(0.05, 1) -- ClashImp_Before, ClashImp_After
  
	Fuse2(0.7, 0.5) -- ClashImportance_Before, ClashImportance_After
  Fuse3()
	Fuse1(0.07, 1) -- ClashImp_Before, ClashImp_After
	
end -- function FuseBestScorePartPose()
function Fuse1(l_ClashImportanceBefore, l_ClashImportanceAfter)
  -- Called from FuseBestScorePartPose() above

	SetClashImportance(l_ClashImportanceBefore)
	ShakeSelected("Fuse1")
	
  SetClashImportance(l_ClashImportanceAfter)
  WiggleAll(1, "Fuse1") -- Iterations, FromWhere
  
  recentbest.Restore() -- will keep current if best
	
end -- function Fuse1(l_ClashImportanceBefore, l_ClashImportanceAfter)
function Fuse2(l_ClashImportance_Before, l_ClashImportance_After)
  -- Called from FuseBestScorePartPose() above

	SetClashImportance(l_ClashImportance_Before)
  WiggleAll(1, "Fuse2") -- Iterations, FromWhere
	
  SetClashImportance(1)
  WiggleAll(1, "Fuse2") -- Iterations, FromWhere
	
  SetClashImportance(l_ClashImportance_After)
  WiggleAll(1, "Fuse2") -- Iterations, FromWhere
  
  recentbest.Restore() -- will keep current if best

end -- function Fuse2(l_ClashImportanceBefore, l_ClashImportanceAfter)
function Fuse3()
  -- Called from FuseBestScorePartPose() above

  SetClashImportance(1)
  WiggleAll(3, "Fuse3") -- Iterations, FromWhere

  recentbest.Restore() -- will keep current if best

end -- function Fuse2(l_ClashImportanceBefore, l_ClashImportanceAfter)

-- ...end of My Favorite Functions.
-- Start of Clean Up functions...
function CleanUp(l_ErrorMessage)
  -- Called from Rebuild1PuzzleForManyRuns() above or xpcall() below
	
	print("Cleaning up: Restoring Clash Importance, Initial Selection, Best Result and Secondary Structures.")
	SetClashImportance(1)
	save.Quickload(3) -- Load

	if g_bUserSelected_NormalConditionChecking_DisableForThisEntireScriptRun == true then
		NormalConditionChecking_TemporarilyReEnableToCheckScore() -- well, not temporarily this time...
	end
	if g_bSavedSecondaryStructure == true then
		save.LoadSecondaryStructure()
	end

	-- Reset the Selected Segments back to the way they were before we started this program...
	selection.DeselectAll()
	if g_OrigSelectedSegmentRanges ~= nil then
		-- g_OrigSelectedSegmentRanges is populated before we call Rebuild1PuzzleForManyRuns()...
		CleanUpSelectedSegmentRanges(g_OrigSelectedSegmentRanges)
	end
	if l_ErrorMessage ~= nil then
		print(l_ErrorMessage)
	end
    
  DisplayEndOfScriptStatistics()
    
end -- function CleanUp(l_ErrorMessage)
function CleanUpSelectedSegmentRanges(l_SegmentRangesTable) -- was SetSelection()
  -- Called from CleanUp() above
  -- Reset the Selected Segments back to the way they were before we started this program...

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

end -- function CleanUpSelectedSegmentRanges(l_SegmentRangesTable)
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
	1. This is a long run rebuilder script. The goal of this script is to rebuild selected and/or lowest scoring segments and segment ranges several times to find better scoring poses (aka: positions / conformations / shapes / structures / solutions). If working on a design puzzle, this script will also look for better scoring amino acids for each (mutable / changeable) segment.
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
	"Fuse best score part pose:" is a strategy employed by many recipes in Foldit. A fuse attempts to consolidate changes in the protein by using shake and wiggle while varying clashing importance. Learn more here: https://foldit.fandom.com/wiki/Fuse
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
	3. After rebuild finishes, script tries to stabilize each different saved score part pose.
	4. Because some score part pose are better in more than one way, sometimes there is only one best score part pose to stabilize. Could this be written more clearly?
	5. On the best score part pose a fuse is run if it looks promising enough.

	Features (most have user selectable parameters):
	1. Can be used in design puzzles, has mutate options for that.
	2. For each selected segment range, the script will only "recompute the next" (attempt another?) rebuild if there has been enough gain. Is this true? What exactly does this mean?
	3. It will not atttempt to rebuild the exact same selected segments a second time. Really?
	4. It will not try a FuseBestScorePartPose if the loss is too great depending on the size of the rebuild.
	5. It will not attempt to rebuild frozen or locked segments.
	6. User can specify what segments of the protein to work on.
	7. User can select to keep intact or ignore disulfide bonds (thanks Brow42).
	8. If the starting score is negative, default is no wiggles will be done to avoid exploding the protein.
	9. If stopped, this script will reset original Clash Importance, best score and secondary structures.
	10. User can skip X number of worst scoring segment ranges (handy after a crash).
	11. It breaks off rebuild attempts if no chance of success.
	12. It works on puzzles even if the score is < -1000000 (but will be slower).
	13. FuseBestScorePartPose and StabilizePosesOfSelectedScoreParts can be suppressed (this is the default, if the score is negative from the start)
	14. User can specify to disable bands when rebuilding and enable them afterwards.
	NEW in version 2
	15. User can choose which ScoreParts will be stabilized.
	16. User can choose which ScoreParts count for finding worst scoring segments.
	17. It will recognize puzzle properties and set defaults for them.
	18. Instead of skipping cycles user can specify number of worst segment ranges to skip (variable name "g_UserSelected_NumberOfSegmentRangesToSkip"). Uh oh. How is this different from number 10 above?
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
	2.5.0 Added g_bUserSelected_DuringStabilizeAndFuse_ShakeAndWiggleSelectedAndNearbySegments option. Thanks Susume.
	2.5.1 Added finding wins during StabilizePosesOfSelectedScoreParts wiggle.
	2.6.0 Changed defaults and user interface.
	2.7.0 Added option to disable slow filters on design puzzles.
	2.8.0 Added more general way to disable slow filters on design puzzles.
	2.8.1 Fixed filter problem when high bonus.
	2.8.2 Add call to CleanUp after Rebuild1PuzzleForManyRuns stops normally.
	3.0.0 Made a Remix version in the same source.  Really? A search in this file for "remix" turns up nada.
	3.0.1 Fixed density weight computation if filters are active.

	]]--
  
end -- function ScriptDocumentation()
-- ...end of Clean Up functions.

xpcall(Rebuild1PuzzleForManyRuns, CleanUp) -- run in protected mode, so we can fail gracefully, by calling CleanUp()...
--Rebuild1PuzzleForManyRuns() -- Call Rebuild1PuzzleForManyRuns() directly when debugging to more
--                                  easily find the program line that caused an exception / program abort.
--                                  It makes it more obvious where the error occured.
--CleanUp()