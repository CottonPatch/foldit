g_ProgramName = "Deep Rebuild "
g_ProgramVersion = "2020"

-- Called from 1 place in DefineGlobalVariables()...
function SetupLocalDebugFuntions()
-- another Change

	-- All of the following built-in FoldIt Lua functions are described here:
	-- https://foldit.fandom.com/wiki/Foldit_Lua_Functions
	
	math.randomseed (os.time ()) -- this must be done or our random numbers will never change...
	function RandomCharOfString(s)
		local r = math.random(#s) -- e.g.; math.random (5)  --> an integer number from 1 to 5
		return s:sub(r, r) -- e.g.; string.sub ("ABCDEF", 2, 2)  --> "B"
	end
	
	function RandomFloat(n1, n2) -- e.g.; RandomFloat(3, 9) --> 4.30195013275552
		l_RandomFloat = math.random() * (n2 - n1) + n1
		--l_RandomFloat = math.random(n1, (n2 - 1)) + math.random() 
		return l_RandomFloat
		-- e.g.; RandomFloat(3, 9)
		-- return math.random() * (n2 - n1) + n1
		--     (0.0 <= x < 1.0) * (9 - 3) + 3
		--     (0.0 <= x < 1.0) * 6 + 3
		--     0 * 6 + 3 = 3 ok , .999 * 6 + 3 = 5.94 + 3 = 8.94 ok
		-- Less efficient, but also works: return math.random(n1, (n2 - 1)) + math.random() 
	end

	-- Some "help" functions this script does not yet use...
	--   help

	-- Some "absolutebest" functions this script does not yet use...
	--   absolutebest.GetEnergyScore
	--   absolutebest.GetSegmentEnergyScore
	--   absolutebest.GetSegmentEnergySubscore
	--   absolutebest.Restore -- could be helpful

	band = {}
	band.DisableAll = function() end
	band.EnableAll = function() end
	band.GetCount = function()
		l_BandCount = math.random(20) --> an integer number from 1 to 20
		return l_BandCount
	end
	-- Some "band" functions this script does not yet use...
	--   band.GetLength=function() 
	--    return math.random() * math.random(-5, 5) --> -5 <= x < 5
	--   end
	--   band.Add, band.Delete, band.DeleteAll
	--   band.AddBetweenSegments, band.AddToBandEndpoint
	--   band.Enable, band.IsEnabled, band.Disable,
	--   band.SetGoalLength, band.GetGoalLength,
	--   band.SetStrength, band.GetStrength

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
	-- Some "behavior" functions this script does not yet use...
	--   behavior.GetFiltersDisabled
	--   behavior.SetWigglePower, behavior.GetWigglePower
	--   behavior.HighPowerAllowed

	-- Some "contactmap" functions this script does not yet use...
	--   contactmap.GetHeat = function(l_Segment1, l_Segment2) return l_HeatOfTwoSegments end
	--   contactmap.IsContact = function(l_Segment1, l_Segment2) return b_TwoSegmentsAreInContact end

	-- Some "creditbest" functions this script does not yet use...
	--   creditbest.AreConditionsMet
	--   creditbest.GetEnergyScore
	--   creditbest.GetSegmentEnergyScore
	--   creditbest.GetSegmentEnergySubscore
	--   creditbest.Restore -- maybe helpful

	g_Debug_CurrentEnergyScore = -999999 -- provides some control over current score during debug.
  g_Debug_ScriptBestEnergyScore = g_Debug_CurrentEnergyScore
  g_Debug_QuickSaveEnergyScore = 0
	g_Debug_bAllowNewRandomScoreOnNextCallToGetEnergyScore = true
  -- ...set to false in various key debug places.
  g_Debug_RecentBestEnergyScore = 0  
	
	current = {}
  current.UpdateEnergyScore = function()
    
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
		-- Returns the overall score for the current pose of the protein
		-- Depends on whether conditions are enabled, like behavior.GetFiltersDisabled
		
			return g_Debug_CurrentEnergyScore      
	end
  
	current.GetSegmentEnergyScore = function(l_SegmentIndex)    
		local l_SegmentEnergyScore
		l_SegmentEnergyScore = RandomFloat(-10, 10) -- was (-200, 200)
		return l_SegmentEnergyScore
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
	-- Some "current" functions, which this script does not yet use:
	--   current.AreConditionsMet -- should we use this?

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

	-- Some "filter" functions this script does not yet use...
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
	-- Some "freeze" functions this script does not yet use...
	--   freeze.Freeze, freeze.FreezeAll, freeze.FreezeSelected, freeze.Unfreeze, freeze.UnfreezeAll
	--   freeze.GetCount = fuction() return(l_NumSegmentsWithFrozenBackbone,
	--                                      l_NumSegmentsWithFrozenSidechain) end

	pose = {} -- same structure as "current" above
	pose.GetEnergyScore = function()
		return g_Debug_CurrentEnergyScore
	end
	pose.GetSegmentEnergyScore = function(l_SegmentIndex)
		local l_SegmentEnergyScore
		l_SegmentEnergyScore = RandomFloat(-10, 10) -- was (-200, 200)
		return l_SegmentEnergyScore
	end

	pose.GetSegmentEnergySubscore = function(l_SegmentIndex, l_ScorePart)
		local l_SegmentEnergySubscore
			
		l_ScorePart = string.lower(l_ScorePart)
		if l_ScorePart == "disulfides" then
			l_SegmentEnergySubscore = "-0"
		elseif l_ScorePart == "reference" then
			l_SegmentEnergySubscore = "0.1"
		else
			l_SegmentEnergySubscore = RandomFloat(-1, 1) -- was (-50, 50) prior to 2020/02/01
		end
		return l_SegmentEnergySubscore

	end

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
	-- Some "puzzle" functions this script does not yet use:
	--   puzzle.GetExpirationTime,
	--   puzzle.GetStructureName
	--   puzzle.StartOver

	recentbest = {}
	recentbest.Restore = function()
		-- Keep the current pose if it's better; otherwise, restore the recentbest pose.    
    if g_Debug_RecentBestEnergyScore > g_Debug_CurrentEnergyScore then
      g_Debug_CurrentEnergyScore = g_Debug_RecentBestEnergyScore
    end
	end
	recentbest.Save = function()
		 -- Save the current pose as the recentbest pose.
     g_Debug_RecentBestEnergyScore = g_Debug_CurrentEnergyScore
	end
	-- Some "recentbest" functions this script does not yet use...
	--   recentbest.AreConditionsMet
  recentbest.GetEnergyScore = function()
    return g_Debug_RecentBestEnergyScore
  end
	--   recentbest.GetSegmentEnergyScore = function(l_SegmentIndex)
	--     local l_SegmentEnergyScore
	--     l_SegmentEnergyScore = RandomFloat(-200, 200)
	--     return l_SegmentEnergyScore
	--   end
	--   recentbest.GetSegmentEnergySubscore

	-- Some "recipe" functions this script does not yet use...
	--   recipe.CompareNumbers
	--   recipe.GetRandomSeed -- does not work properly on Windows OS
	--   recipe.ReportStatus -- Could be helpful, but does not allow capturing the results, only prints it
	--   recipe.SectionEnd
	--   recipe.SectionStart -- Count be helpful, but...
	--   rotamer.GetCount
	--   rotamer.SetRotamer

	save = {}
	save.Quickload = function(l_IntegerSlot)
    g_Debug_CurrentEnergyScore = g_Debug_QuickSaveEnergyScore
    --if g_Debug_ScriptBestEnergyScore > g_Debug_CurrentEnergyScore then
    --  g_Debug_CurrentEnergyScore = g_Debug_ScriptBestEnergyScore
    --elseif g_Debug_CurrentEnergyScore > g_Debug_ScriptBestEnergyScore then
    --  g_Debug_ScriptBestEnergyScore = g_Debug_CurrentEnergyScore
    --end
    return
  end -- Called from 11 places in this script!
	save.Quicksave = function(l_IntegerSlot)
    g_Debug_QuickSaveEnergyScore = g_Debug_CurrentEnergyScore
    --if g_Debug_CurrentEnergyScore > g_Debug_ScriptBestEnergyScore then
    --  g_Debug_ScriptBestEnergyScore = g_Debug_CurrentEnergyScore
    --end
    return
  end -- Called from 13 places in this script!
	save.LoadSecondaryStructure = function() return end -- Called from 2 places
	save.SaveSecondaryStructure = function() return end -- Called from 1 place
	-- Some "save" functions, which this script does not yet use...
	--   save.GetSolutions - could be useful.
	--   save.LoadSolution
	--   save.LoadSolutionByName
	--   save.QuicksaveEmpty
	--   save.SaveSolution

	-- Some "scoreboard" functions this script does not yet use...
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
	-- Some "selection" functions this script does not yet use...
	--   selection.Deselect
	--   selection.GetCount
	
	structure = {}
	structure.GetAminoAcid = function(l_SegmentIndex)
		l_AminoAcids = 'wifpylvmkchardentsqg'  
		l_RandomAminoAcid = RandomCharOfString(l_AminoAcids)
		if 1 == 1 then
			return l_RandomAminoAcid
		end
		
		-- The old method...
		if
			l_SegmentIndex ==   3 or l_SegmentIndex ==  34 or l_SegmentIndex ==  83 or l_SegmentIndex ==  85 or
			l_SegmentIndex ==  88 or l_SegmentIndex ==  97 or l_SegmentIndex ==  125
			then
			return "a"
		elseif
			l_SegmentIndex ==   4 or l_SegmentIndex ==  12 or l_SegmentIndex ==  49 or l_SegmentIndex ==  58 or
			l_SegmentIndex ==  65 or l_SegmentIndex ==  76 or l_SegmentIndex ==  80 or l_SegmentIndex ==  87 or
			l_SegmentIndex == 104 or l_SegmentIndex == 117 or l_SegmentIndex == 124 or l_SegmentIndex == 129 or
			l_SegmentIndex == 131 or l_SegmentIndex == 132
			then
			return "c"
		elseif
			l_SegmentIndex ==  29 or l_SegmentIndex ==  32 or l_SegmentIndex ==  52 or l_SegmentIndex ==  68 or
			l_SegmentIndex == 100 or l_SegmentIndex == 105 or l_SegmentIndex == 114 or l_SegmentIndex == 119
			then
			return "d"
		elseif
			l_SegmentIndex ==   1 or l_SegmentIndex ==   6 or l_SegmentIndex ==  18 or l_SegmentIndex ==  33 or
			l_SegmentIndex ==  37 or l_SegmentIndex ==  46 or l_SegmentIndex ==  67 or l_SegmentIndex ==  81 or
			l_SegmentIndex == 109 or l_SegmentIndex == 121
			then
			return "e"
		elseif
			l_SegmentIndex ==  26 or l_SegmentIndex ==  41 or l_SegmentIndex ==  55 or l_SegmentIndex ==  56 or
			l_SegmentIndex ==  96
			then
			return "f"
		elseif
			l_SegmentIndex ==  14 or l_SegmentIndex ==  16 or l_SegmentIndex ==  35 or l_SegmentIndex ==  86 or
			l_SegmentIndex ==  95 or l_SegmentIndex == 111
			then
			return "g"
		elseif
			l_SegmentIndex ==  28 or l_SegmentIndex ==  39
			then
			return "h"
		elseif
			l_SegmentIndex ==   7 or l_SegmentIndex ==  15 or l_SegmentIndex ==  47 or l_SegmentIndex ==  64 or
			l_SegmentIndex == 126 or l_SegmentIndex == 127
			then
			return "i"
		elseif
			l_SegmentIndex ==  13 or l_SegmentIndex ==  54 or l_SegmentIndex ==  70 or l_SegmentIndex ==  71 or
			l_SegmentIndex ==  84
			then
			return "k"
		elseif
			l_SegmentIndex ==   2 or l_SegmentIndex ==  11 or l_SegmentIndex ==  36 or l_SegmentIndex ==  44 or
			l_SegmentIndex ==  53 or l_SegmentIndex ==  57 or l_SegmentIndex ==  66 or l_SegmentIndex ==  73 or
			l_SegmentIndex ==  90 or l_SegmentIndex == 107 or l_SegmentIndex == 116
			then
			return "l"
		elseif
			l_SegmentIndex ==  22 or l_SegmentIndex ==  60 or l_SegmentIndex ==  91 or l_SegmentIndex == 102 or
			l_SegmentIndex == 118 or l_SegmentIndex == 130 or l_SegmentIndex == 135
			then
			return "m"
		elseif
			l_SegmentIndex ==  24 or l_SegmentIndex ==  27 or l_SegmentIndex == 112
			then
			return "n"
		elseif
			l_SegmentIndex ==  10 or l_SegmentIndex ==  23 or l_SegmentIndex ==  43 or l_SegmentIndex ==  51 or
			l_SegmentIndex ==  63 or l_SegmentIndex ==  72 or l_SegmentIndex ==  74 or l_SegmentIndex ==  75 or
			l_SegmentIndex ==  89 or l_SegmentIndex ==  99 or l_SegmentIndex == 108 or l_SegmentIndex == 113 or
			l_SegmentIndex == 123
			then
			return "p"
		elseif
			l_SegmentIndex ==   5 or l_SegmentIndex ==  25 or l_SegmentIndex ==  31 or l_SegmentIndex ==  40 or
			l_SegmentIndex ==  48 or l_SegmentIndex ==  93 or l_SegmentIndex == 110
			then
			return "q"
		elseif
			l_SegmentIndex ==  77 or l_SegmentIndex ==  82 or l_SegmentIndex ==  92 or l_SegmentIndex == 101 or
			l_SegmentIndex == 103 or l_SegmentIndex == 106 or l_SegmentIndex == 122
			then
			return "r"
		elseif
			l_SegmentIndex ==  50 or l_SegmentIndex ==  59 or l_SegmentIndex ==  78
			then
			return "s"
		elseif
			l_SegmentIndex ==   8 or l_SegmentIndex ==  20 or l_SegmentIndex ==  30 or l_SegmentIndex ==  62 or
			l_SegmentIndex == 115
			then
			return "t"
		elseif
			l_SegmentIndex ==   9 or l_SegmentIndex ==  38 or l_SegmentIndex ==  45 or l_SegmentIndex ==  79 or
			l_SegmentIndex == 128 or l_SegmentIndex == 133 or l_SegmentIndex == 134
			then
			return "v"
		elseif
			l_SegmentIndex ==  42 or l_SegmentIndex ==  98
			then
			return "w"
		elseif
			l_SegmentIndex ==  17 or l_SegmentIndex ==  19 or l_SegmentIndex ==  21 or l_SegmentIndex ==  61 or
			l_SegmentIndex ==  69 or l_SegmentIndex ==  94 or l_SegmentIndex == 120
			then
			return "y"
		end
		return "-"
	end
	structure.GetCount = function()
		 l_RandomCount = math.random(80, 180)
		 return l_RandomCount
		-- old method... return 135
	end
	structure.GetDistance = function(x,i)
		l_Distance = math.random(80) -- in angstroms
		return l_Distance
	end
	
	structure.GetSecondaryStructure = function(l_SegmentIndex)
		
		--l_SecondaryStructures = 'HEL' -- H=Helix, E=Sheet, L=Loop, M=Ligand
		l_SecondaryStructures = 'HELM' -- H=Helix, E=Sheet, L=Loop, M=Ligand
		l_RandomSecondaryStructure = RandomCharOfString(l_SecondaryStructures)
		if 1 == 1 then
			return l_RandomSecondaryStructure
		end
		
		-- The old method...
		if
			l_SegmentIndex >= 10 and l_SegmentIndex <= 12 or
			l_SegmentIndex >= 31 and l_SegmentIndex <= 47 or
			l_SegmentIndex >= 53 and l_SegmentIndex <= 61 or
			l_SegmentIndex >= 77 and l_SegmentIndex <= 94 or
			l_SegmentIndex >= 100 and l_SegmentIndex <= 102 or
			l_SegmentIndex >= 124 and l_SegmentIndex <= 134
			 then
			return "H"
		elseif
			 l_SegmentIndex >= 5 and l_SegmentIndex <= 6 or
			 l_SegmentIndex >= 19 and l_SegmentIndex <= 20 or
			 l_SegmentIndex >= 75 and l_SegmentIndex <= 75 or
			 l_SegmentIndex >= 118 and l_SegmentIndex <= 118
			 then
			return "E"
		end
		return "L"
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
		
		-- The old method...
		if l_SegmentIndex >= 123 and l_SegmentIndex <= 135 then
			return true
		end
		return false
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
	-- Additional "structure" functions, which this script does not yet use...
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
	--   structure.MutateSidechainsAll = function(l_Iterations)
	--   structure.RemixSelected = function(integer l_StartQuicksave, l_NumResult)
	--   structure.SetAminoAcid = function(l_SegmentIndex, l_AminoAcid)
	--   structure.SetAminoAcidSelected = function(l_AminoAcid)
	--   structure.SetNote = function(l_SegmentIndex, l_Note)
	--   structure.SetSecondaryStructure = function(l_SegmentIndex, l_SecondaryStructure)

	-- Some additional functions this script does not yet use...
	--   ui.AlignGuide = function(l_SegmentIndex)
	--   ui.CenterViewport = function()
	--   ui.GetPlatform = function()
	--   ui.GetTrackName = function()
	--   undo.SetUndo = function(l_bEnable)

	user = {}
	user.GetPlayerName = function() return "ProteinProgrammingLanguage" end
	-- Some "user" functions this script does not yet use...
	--   user.GetGroupID = function()
	--   user.GetGroupName = function()
	--   user.GetPlayerID = function()
  
  -- Well, we gotta start somewhere, right...
  current.UpdateEnergyScore()

end

-- Called from 1 place in main()...
function DefineGlobalVariables()

	g_bDebugMode = false
	if _G ~= nil then
		g_bDebugMode = true
		SetupLocalDebugFuntions()
	end
	--
	-- *** Start of Table Declarations...***
	--
  
  -- Used in PopulateGlobalActiveScorePartsTable() and
  --         PopulateGlobalScorePartsTable()..
  g_ActiveScorePartsTable = {}
  --g_ActiveScorePartsTable = {ScorePart_Name}
  
	--  Used in CountDisulfideBonds(),
  --          PopulateGlobalCysteinesTable(), and
  --          DisplayPuzzleProperties()
	g_CysteineSegmentsTable = {}
	--g_CysteineSegmentsTable={SegmentIndex}

	--  Used in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges(), DefineGlobalVariables(),
	--          Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--          Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(), 
  --          DisplaySegmentRanges(), DisplaySelectedOptions(), AskUserToSelectSegmentsToRebuild(),
  --          bAskUserToSelectRebuildOptions(), RebuildSelectedSegments(), 
  --          RebuildManySegmentRanges(), PrepareToRebuildSegmentRanges() and main()
	g_SegmentRangesToRebuildTable = {}
	-- g_SegmentRangesToRebuildTable={StartSegment, EndSegment}
		srtrt_StartSegment = 1
		srtrt_EndSegment = 2
	-- g_SegmentRangesToRebuildTable initially includes all the segments in the main protein (ie; no ligands)

	-- g_bSegmentsToRebuildBooleanTable:
	--  Used in PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts(),
	--          bSegmentIsAllowedToBeRebuilt() and
  --          main()
	g_bSegmentsToRebuildBooleanTable = {}
	-- g_bSegmentsToRebuildBooleanTable={true/false}

	--  Used in SetSegmentsAlreadyRebuilt(),
  --          bSegmentIsAllowedToBeRebuilt(),
  --          CheckIfAlreadyRebuiltSegmentsMustBeIncluded() and
	--          ResetSegmentsAlreadyRebuiltTable()
	g_SegmentsAlreadyRebuiltTable = {}
	-- g_SegmentsAlreadyRebuiltTable={true/false}
	-- g_SegmentsAlreadyRebuiltTable keeps track of which segments have already been processed...

	--  Used in PopulateGlobalScorePartScoresTable(),
	--          Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(),
	--          Update_ScorePartScoresTable_ToDo_And_ScorePartsList_Fields() and
  --          RebuildManySegmentRanges()
  
	--  Used in GetScorePart_Score() and
  --          PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts()
	g_SegmentScoresTable = {}
	-- g_SegmentScoresTable={SegmentScore}
	-- g_SegmentScoresTable is optimized for quickly searching for 
	-- the worst scoring segments, so we can work on those first.

	g_ScorePartScoresTable = {}
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
		spst_ScorePart_Number = 1
		spst_ScorePart_Score = 2
		spst_PoseTotalScore = 3
		spst_ScorePartsList = 4 -- examples: "4", "5=7=12", "6=9", "8=11=13"
		spst_bToDo = 5 -- 'true' means first score part with a unque PoseTotalScore, 
                  -- 'false' means all duplicate PoseTotalScore score parts

	--  Used in PopulateGlobalScorePartsTable(), PopulateGlobalScorePartScoresTable(),
	--          Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(),
	--          AskUserToSelectScorePartsToStabilize(),
  --          AskUserToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments(),
	--          bAskUserToSelectRebuildOptions() and RebuildManySegmentRanges()
	g_ScorePartsTable = {}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
		spt_ScorePart_Number = 1
		spt_ScorePart_Name = 2 -- could have been called "SlotName", but since most of the "slots" are ScoreParts...
		spt_bScorePartIsActive = 3
		spt_LongName = 4

	--  Used by PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts(), and
	--          AskUserToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments()
	g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table = {}
	--g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table={ScorePart_Name}
	--
	-- ***...end of Table Declarations.***
  
  	--  Used in SaveBest() and RebuildManySegmentRanges()
	g_BestScore = GetPoseTotalScore()
	
	--  Used in DefineGlobalVariables(), InvertSegmentRangesTable(),
	--          ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(), FindSelectedSegments(),
	--          CalculateSegmentRangeScore(), GetScorePart_Score(), PopulateGlobalActiveScorePartsTable(),
	--          DisplayPuzzleProperties() and AskUserToSelectSegmentsToRebuild()
	g_SegmentCountWithLigands = structure.GetCount()
	-- g_SegmentCountWithLigands = The number of segments (amino acids) in the
	-- protein plus number of segments in ligand
	-- print("structure.GetCount()=[" .. structure.GetCount() .. "]")

	--  Used in 24 functions...
	g_SegmentCountWithoutLigands = g_SegmentCountWithLigands -- minus ligand segments (see below)
	-- g_SegmentCountWithLigands = The number of segments (amino acids) in the protein plus the
  --                             segments in any ligand
	-- g_SegmentCountWithoutLigands = The number of segments without structure type="M" (ligands)
  
	-- Now, subtract the ligand segments...
	local l_SegmentIndex
	for l_SegmentIndex = g_SegmentCountWithLigands, 1, -1 do
		l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)
		-- The function GetSecondaryStructure() returns a segment's secondary
		-- structure type, as a single letter...
		-- "E" = Sheet, "H" = Helix, "L" = Loop, "M" = Ligand (M for molecule)
		-- print("structure.GetSecondaryStructure(" .. l_SegmentIndex .. ")=[" ..
		--  l_GetSecondaryStructureType .. "]")
		if l_GetSecondaryStructureType == "M" then
		-- Don't include Ligands in g_SegmentCountWithoutLigands...
			g_SegmentCountWithoutLigands = g_SegmentCountWithoutLigands - 1
		end
	end
	-- print("g_SegmentCountWithoutLigands=[" .. g_SegmentCountWithoutLigands .. "]")
	g_SegmentRangesToRebuildTable = {{1, g_SegmentCountWithoutLigands}} 
  -- ...Ligand segment numbers are always after the protein segment numbers.

	--  Used in AskMoreOptions() and main()
	g_AdditionalNumberOfSegmentRangesToProcessPerRunCycle = 1
	
		--  Used in TemporarilyDisableConditionChecking() and ReenableNormalConditionChecking()...
	g_bBetterRecentBest = false
	
	--  Used in DisplaySelectedOptions(), bAskUserToSelectRebuildOptions() and 
	--          RebuildManySegmentRanges
	g_bConvertAllSegmentsToLoops = true -- Why is the default true?
	
	g_SketchBookPuzzleMinimumGainForSave = 0
	g_bFoundAHighGain = true
	
	--  Used in DisplayPuzzleProperties() -- for informational display to user only.
	g_bFreeDesignPuzzle = false
	
	--  Used in CheckForLowStartingScore(), DisplaySelectedOptions(), AskMoreOptions() and
	--          RebuildManySegmentRanges()
	g_bFuseBestPosition = true
	
	--  Used in CheckForLowStartingScore() and DisplayPuzzleProperties()
	g_bHasDensity = false
	
	--  Used in PopulateGlobalScorePartsTable(), 
	g_bHasLigand = (g_SegmentCountWithoutLigands < g_SegmentCountWithLigands)
	
	--  Used in SetClashImportance() and ShakeAndOrWiggle()
	g_bMaxClashImportance = true
	
	--  Used in DefineGlobalVariables(), AskUserForMutateOptions(), bAskUserToSelectRebuildOptions() and
	--          RebuildManySegmentRanges()
	g_bMutateAfterFuseBestPosition = false

	--  Used in DefineGlobalVariables(), AskUserForMutateOptions(), bAskUserToSelectRebuildOptions() and
	--          RebuildManySegmentRanges()
	g_bMutateAfterNormalStabilization = false

	--  Used in AskUserForMutateOptions(), bAskUserToSelectRebuildOptions(),
	--          RebuildOneSegmentRangeManyTimes()
	g_bMutateAfterRebuild = false

	g_bMutateBeforeFuseBestPosition = false
	g_bMutateDuringNormalStabilization = false
	g_bMutateOnlySelectedSegments = false
	g_bMutateSelectedAndNearbySegments = false
	g_bOnlyRebuildLoops = true -- only rebuild loop segments

	--  Used in 7 functions...
	g_bAlwaysAllowRebuildingAlreadyRebuiltSegments = true
  -- ...User can change this on the Select Rebuild Options page.
  if g_bDebugMode == true then
    g_bAlwaysAllowRebuildingAlreadyRebuiltSegments = false
  end

	g_bPerformExtraStabilization = false
	g_bPerformNormalStabilization = true
	g_bProbableSymmetryPuzzle = false
	g_bRebuildHelicesAndLoops = true -- rebuild helix segments + surrounding loop segments
	g_bRebuildSheetsAndLoops = false -- rebuild sheet segments + surrounding loop segments
	g_bSavedSecondaryStructure = false
	g_bSelectAllScorePartsToStabilize = true
	g_bSelectMain4ScorePartsToStabilize = false
	g_bShake_And_Wiggle_OnlySelectedSegments = true -- false = include nearby segments
	g_bShake_And_Wiggle_WithSelectedSegments = true -- (after each rebuild) not too slow
	g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments = false -- true = very slow

	--  Used in bOneOrMoreDisulfideBondsHaveBroken(), RememberSolutionWithDisulfideBondsIntact(),
	--          CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact(), DisplayPuzzleProperties(),
	--          bAskUserToSelectRebuildOptions(), RebuildSelectedSegments(),
	--          RebuildOneSegmentRangeManyTimes() and RebuildManySegmentRanges()
	g_bUserWantsToKeepDisulfideBondsIntact = false

	--  Used in bSegmentIsAllowedToBeRebuilt() and
	--          RebuildManySegmentRanges()
	g_CurrentRebuildPointsGained = 0

	--  Used in CleanUp()
	g_StartingScore = GetPoseTotalScore()

	--  Used in PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts(),
	--          CheckForLowStartingScore() and DisplayPuzzleProperties()
	g_DensityWeight = 0

	g_FirstRebuildSegment = 0
	g_LastRebuildSegment = 0
	g_LastSegmentScore = 0

	--  Used in MutateOneSegmentRange() and AskUserForMutateOptions()
	g_MutateClashImportance = 0.9

	--  Used in MutateOneSegmentRange(), AskUserForMutateOptions() and AskUserToSelectRebuildOptions()
	g_MutateSphereRadius = 8 -- Angstroms

	--  Used in PopulateGlobalCysteinesTable(), bOneOrMoreDisulfideBondsHaveBroken(), 
	--          PopulateGlobalActiveScorePartsTable(), DisplayPuzzleProperties() and
	--          AskUserToSelectRebuildOptions()
	g_OriginalNumberOfDisulfideBonds = 0

	--  Used in AskMoreOptions(), RebuildSelectedSegments() and RebuildOneSegmentRangeManyTimes()
	g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle = 10 -- set to at least 10
  if g_bDebugMode == true then
    g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle = 10 -- 5 is high enough for debug mode
  end

	--  Used in bAskUserToSelectRebuildOptions(), RebuildSelectedSegments(),
	--          PrepareToRebuildSegmentRanges() and main()
	g_NumberOfRunCycles = 40 -- Set it very high if you want to run forever
  if g_bDebugMode == true then
    g_NumberOfRunCycles = 5 -- 5 is high enough for debug mode
  end

	--  Used in DisplaySelectedOptions(), bAskUserToSelectRebuildOptions() and main()
	g_NumberOfSegmentsSkipping = 0

	--  Used in RebuildOneSegmentRangeManyTimes()
	g_RebuildClashImportance = 0 -- clash importance while rebuild

	g_RunCycle = 0
	g_SegmentRangeIndex = 0
	g_ShakeClashImportance = 0.31 -- clash imortance while shaking
	g_QuickSaveStackPosition = 60 -- Uses slot 60 and higher...
	g_WiggleFactor = 1

	-- Increase g_MaxNumberOfSegmentRangesToProcessThisRunCycle by
	--  g_AdditionalNumberOfSegmentRangesToProcessPerRunCycle, after every run cycle...
	-- This allows the worst scoring segments to get more rebuild time...
	-- g_StartingNumberOfSegmentRangesToProcessPerRunCycle:
	--  Used in DefineGlobalVariables(), AskMoreOptions(), PrepareToRebuildSegmentRanges() and main()
	g_StartingNumberOfSegmentRangesToProcessPerRunCycle = 4
	g_MaxNumberOfSegmentRangesToProcessThisRunCycle = g_StartingNumberOfSegmentRangesToProcessPerRunCycle

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
	--  Because g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4, this will be the final
	--  segment range configuration, and will look like this: {{1-4},{2-5},{3-6},{4-7} ... {132-135}}
	-- g_StartProcessingWithThisManyConsecutiveSegments:
	--  Used in DefineGlobalVariables(), Add_Loop_SegmentRange_To_SegmentRangesTable(),
	--          Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(),
	--          bAskUserToSelectRebuildOptions() and PrepareToRebuildSegmentRanges()
	g_StartProcessingWithThisManyConsecutiveSegments = 2 -- user has option to change this

	--  Used in bAskUserToSelectRebuildOptions(), RebuildSelectedSegments() and 
	--          PrepareToRebuildSegmentRanges()
	g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 3 -- user has option to change this
  -- ...any more than 4 consecutive segments does not appear to be fruitful;
  -- Actually, 4 consecutive segments is not great.
  -- And, 3 consecutive segments is barely better then 4.
  -- Really, most of the gains are with just 2 consecutive segments!
  
	--  Used in bAskUserToSelectRebuildOptions(), RebuildSelectedSegments() and
	--          PrepareToRebuildSegmentRanges()
	g_RequiredNumberOfConsecutiveSegments = g_StartProcessingWithThisManyConsecutiveSegments

	--  Used in DefineGlobalVariables(), AskMoreOptions() and RebuildManySegmentRanges()
	g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan =
		(g_SegmentCountWithoutLigands - (g_SegmentCountWithoutLigands % 4)) / 4
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCountWithoutLigands = 135
	--   g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan < 40 then
		g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan = 40
	end
  if g_bDebugMode == true then
    g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan = 200
  end

	g_bSketchBookPuzzle = false
  local l_PuzzleName = puzzle.GetName()
  if string.find(l_PuzzleName, "Sketchbook") then
		print("Note: This is a Sketchbook Puzzle.")
		g_bSketchBookPuzzle = true
  end
	
	-- Default to one point per segment? Seems pretty arbitrary to me...
	-- Used in DefineGlobalVariables(),
  --         bSegmentIsAllowedToBeRebuilt() and 
  --         DisplaySelectedOptions()
	g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 
    g_SegmentCountWithLigands
  
	-- "To Allow" or "To Force"?
	-- Example:
	-- g_SegmentCountWithoutLigands = 135
	-- g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 135
  -- ...Pretty simple formula
	if g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan > 500 then
		g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 500
	end

	if g_bSketchBookPuzzle == true then
	   g_bFuseBestPosition = false
	   g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 500
	   g_bConvertAllSegmentsToLoops = false
	end

  if g_bDebugMode == true then
    g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan = 900
  end  

	-- g_bProteinHasMutableSegments:
	-- Used in DefineGlobalVariables(), MutateOneSegmentRange(), DisplayPuzzleProperties() and 
	--         bAskUserToSelectRebuildOptions()
	g_bProteinHasMutableSegments = false
	local l_NumberOfMutableSegments
	l_NumberOfMutableSegments = GetNumberOfMutableSegments()
	if l_NumberOfMutableSegments > 0 then
		g_bProteinHasMutableSegments = true
	end

	if g_bProteinHasMutableSegments == true then
		g_bMutateAfterFuseBestPosition = true
		g_bMutateAfterNormalStabilization = true
		g_bMutateSelectedAndNearbySegments = true
	end

	local l_NumberOfBands = band.GetCount()

	-- Used in bAskUserToSelectRebuildOptions() and RebuildSelectedSegments()
	g_bDisableBandsDuringRebuild = l_NumberOfBands > 0 -- set default to true if there are any bands.

	--  Used in DefineGlobalVariables(), AskMoreOptions() and RebuildManySegmentRanges()
	g_SkipFusingBestPositionIfLossIsGreaterThan = 
		(g_SegmentCountWithoutLigands - (g_SegmentCountWithoutLigands % 4)) / 4
	-- Could someone please explain how this formula was determined?
	-- Example:
	--   g_SegmentCountWithoutLigands = 135
	--   g_SkipFusingBestPositionIfLossIsGreaterThan =
	--    (135 - (135 % 4)) /4 = (135 - 3) / 4 = 135 / 4 = 33.75
	if g_SkipFusingBestPositionIfLossIsGreaterThan < 30 then
		g_SkipFusingBestPositionIfLossIsGreaterThan = 30
	end

	-- Set Clash Importance Factor...
	-- note: we don't actually have a g_ClashImportance variable,
	--       we only have a g_ClashImportanceFactor variable.
	--       we do, however, have an l_ClashImportance variable in function SetClashImportance() above.
	--  Used in DefineGlobalVariables(), SetClashImportance() and CheckClashImportance()
	g_ClashImportanceFactor = behavior.GetClashImportance()
	-- print("behavior.GetClashImportance()=[" .. g_ClashImportanceFactor .. "].")
	if g_ClashImportanceFactor < 0.99 then
		CheckClashImportance()
	end

	-- Start of Temporarily Disable Condition Checking module...
	-- Temporarily disable condition checking...
	if g_bSketchBookPuzzle == false then 
		behavior.SetFiltersDisabled(true) -- enables faster CPU processing, but scores are not counted...
	end

	local l_ScoreWithConditionCheckingTemporarilyDisabled = GetPoseTotalScore()
    
  -- debugging...
  --l_ScoreWithConditionCheckingTemporarilyDisabled = l_ScoreWithConditionCheckingTemporarilyDisabled + 500
	  
	-- Re-enable normal condition checking...
	if g_bSketchBookPuzzle == false then 
		behavior.SetFiltersDisabled(false)
    -- ...Disables faster CPU processing, so your score will be counted as normal...
	end
	
	local l_ScoreWithNormalConditionCheckingEnabled = GetPoseTotalScore()
		
	-- Compute the maximum potential bonus points (not available in beginner puzzles)...
	--  Used in DefineGlobalVariables() and DisplayPuzzleProperties()...
	g_ComputedMaximumPotentialBonusPoints = 
    l_ScoreWithConditionCheckingTemporarilyDisabled - l_ScoreWithNormalConditionCheckingEnabled 

  -- g_MaximumPotentialBonusPoints can be changed in AskTemporarilyDisableConditionCheckingOptions()...
  --  Used in AskTemporarilyDisableConditionCheckingOptions() and SaveBest()...
  g_MaximumPotentialBonusPoints = g_ComputedMaximumPotentialBonusPoints
	
	-- TemporarilyDisableConditionChecking (enables faster CPU processing, but
  -- your score improvements will not be counted in foldit's Undo history)...
	--  Used in DefineGlobalVariables(), CleanUp(), AskTemporarilyDisableConditionCheckingOptions() and SaveBest()
	g_bTemporarilyDisableConditionChecking = false -- false means "Enable Normal Condition Checking"
  
  if math.abs(g_MaximumPotentialBonusPoints) > 0.1 then
    
		print("\nl_ScoreWithConditionCheckingTemporarilyDisabled: " ..
          PrettyNumber(l_ScoreWithConditionCheckingTemporarilyDisabled) ..
          "\nl_ScoreWithNormalConditionCheckingEnabled: " ..
          PrettyNumber(l_ScoreWithNormalConditionCheckingEnabled) ..
          "\ng_MaximumPotentialBonusPoints: " .. g_MaximumPotentialBonusPoints)
		
		g_bTemporarilyDisableConditionChecking = true
    
		-- Ask user for their desired maximum bonus...
		AskTemporarilyDisableConditionCheckingOptions()
	end
  
	if g_bTemporarilyDisableConditionChecking == true then
		TemporarilyDisableConditionChecking()
	end
	-- ...end of Temporarily Disable Condition Checking module.

end -- DefineGlobalVariables()

-- Called from 0 places. Just stuck it in a fuction so I could fold it (hide it in the editor)...
function ScriptDocumentation()
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
	10. User can skip a number of worst scoring segments (handy after a crash).
	11. It breaks off rebuild attempts if no chance of success.
	12. It works on puzzles even if the score is < -1000000 (but will be slower).
	13. FuseBestPosition and NormalStabilization can be suppressed (this is the default, if the score is negative from the start)
	14. User can specify to disable bands when rebuilding and enable them afterwards.
	NEW in version 2
	15. User can choose which ScoreParts will be stabilized.
	16. User can choose which ScoreParts count for finding worst scoring segments.
	17. It will recognize puzzle properties and set defaults for them.
	18. Instead of skipping cycles you can specify number of worst segments to skip (variable name "g_NumberOfSegmentsSkipping"?).
	Should probably split the variable g_NumberOfSegmentsSkipping into two
	different variables g_NumberOfSegmentsSkipping and g_NumberOfSegmentsToSkip. And maybe into a third variable g_NumberOfSegmentsSkipped.
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
	2.5.0 Added g_bShake_And_Wiggle_OnlySelectedSegments option. Thanks Susume.
	2.5.1 Added finding wins during NormalStabilization wiggle.
	2.6.0 Changed defaults and user interface.
	2.7.0 Added option to disable slow filters on design puzzles.
	2.8.0 Added more general way to disable slow filters on design puzzles.
	2.8.1 Fixed filter problem when high bonus.
	2.8.2 Add call to CleanUp after main stops normally.
	3.0.0 Made a Remix version in the same source.  Really? A search in this file for "remix" turns up nada.
	3.0.1 Fixed density weight computation if filters are active.

	]]--
end

-- Start of Misc Utils  module...
-- Called from 1 place  in FuseBestPositionEnd(),
--             2 places in FuseBestPosition1(),
--             3 place  in FuseBestPosition2(),
--             5 places in PerformNormalStabilizationOnSegmentRange(),
--             1 place  in CleanUp(),
--             2 places in MutateOneSegmentRange(),
--             4 places in RebuildOneSegmentRangeManyTimes(), and
--             1 place  in RebuildManySegmentRanges()...
function SetClashImportance(l_ClashImportance)
	if l_ClashImportance > 0.99 then
		g_bMaxClashImportance = true
	else
		g_bMaxClashImportance = false
	end
	behavior.SetClashImportance(l_ClashImportance * g_ClashImportanceFactor)
end

--- Called from 1 place in DefineGlobalVariables()...
function CheckClashImportance()

	local l_Ask = dialog.CreateDialog("Warning: Clash Importance is not 1")
	l_Ask.l2 = dialog.AddLabel("Clash Importance is currently: [" .. tostring(g_ClashImportanceFactor) .. "]")
	l_Ask.l2 = dialog.AddLabel("Clash Importance will always be multiplied by")
	l_Ask.l3 = dialog.AddLabel("ClashImportanceFactor which is currently: [" .. g_ClashImportanceFactor .. "].")
	l_Ask.l4 = dialog.AddLabel("If you want to change the ClashImportanceFactor,")
	l_Ask.l5 = dialog.AddLabel("stop this script, and set the Clash Importance")
	l_Ask.l6 = dialog.AddLabel("in the FoldIt program (which will become this")
	l_Ask.l7 = dialog.AddLabel("script's ClashImportanceFactor), then restart")
	l_Ask.l8 = dialog.AddLabel("this script.")
	l_Ask.continue = dialog.AddButton("Continue", 1)
	dialog.Show(l_Ask)
end

-- Called from 1 place in DefineGlobalVariables(), 1 place in DisplayPuzzleProperties(),
-- 1 place in RebuildSelectedSegments(), and 2 places in RebuildManySegmentRanges()...
function RoundToThirdDecimal_ReturnFloat(l_DirtyFloat) -- remove anything after the 3rd decimal place
  local l_MaybeDirtyFloat = RoundTo(l_DirtyFloat, 1000)
  -- Rarely l_MaybeDirtyFloat looks like this 123.456000000000001, but 
  -- usually it looks like this 123.456. 
  -- The  extra .000000000000001 sometimes, randomly, gets introduced in
  -- any division operation. This happens in many programming languages.
  -- If you want a cleaner number for display purposes then use the
  -- below function PrettyNumber...
  return l_MaybeDirtyFloat
end

function PrettyNumber(l_DirtyFloat)
  -- Previously called RoundToThirdDecimal()
  local l_MaybeDirtyFloat = RoundTo(l_DirtyFloat, 1000)  
  local l_PrettyString = string.format("%.3f", l_MaybeDirtyFloat)  
  return l_PrettyString
end

function RoundTo(l_DirtyFloat, l_RoundTo)
  local x = .5
  if l_DirtyFloat * l_RoundTo < 0 then
    x = -.5 
  end
  Integer, Decimal = math.modf(l_DirtyFloat * l_RoundTo + x)
  l_MaybeDirtyFloat = Integer / l_RoundTo -- any division can accidentally introduce 0.000000000000001
  
  return l_MaybeDirtyFloat
end

-- Called from 1 place in main() and
--             1 place in xpcall()...
function CleanUp(l_ErrorMessage)
	
	print("\nRestoring Clash Importance, initial selection, best result and structures")
	SetClashImportance(1)
	save.Quickload(3) -- Load

	if g_bTemporarilyDisableConditionChecking == true then
		ReenableNormalConditionChecking()
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
	
	print("\nStarting Score: " .. PrettyNumber(g_StartingScore) ..
        "\nPoints Gained: " .. PrettyNumber(g_BestScore - g_StartingScore) ..
        "\nFinal Score: " .. PrettyNumber(g_BestScore) ..
        "\n")
end
-- ...end of Misc Utils  module.

-- Start of Temporarily Disable Condition Checking module...
-- Called from 1 place in DefineGlobalVariables()...
function AskTemporarilyDisableConditionCheckingOptions()
  
	local l_Ask = dialog.CreateDialog("Temporary Fast CPU Processing")
	l_Ask.bTemporarilyDisableConditionChecking =
		dialog.AddCheckbox("Temporarily disable condition checking", g_bTemporarilyDisableConditionChecking)
	l_Ask.l1 = dialog.AddLabel("Computed maximum potential bonus points: " .. g_MaximumPotentialBonusPoints)
	l_Ask.l2 = dialog.AddLabel("If this is not the correct maximum potential bonus,")
  l_Ask.l3 = dialog.AddLabel("enter the correct value here:")
	if g_MaximumPotentialBonusPoints < 0 then
		g_MaximumPotentialBonusPoints = 0
	end
	l_Ask.maxbonus = dialog.AddTextbox("Set Max Bonus:", g_MaximumPotentialBonusPoints)
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
  l_Ask.l23 = dialog.AddLabel("value is greater than the last saved real best score")
  l_Ask.l24 = dialog.AddLabel("(g_BestScore), we will re-enable condition checking")
  l_Ask.l25 = dialog.AddLabel("and hopefully we will realize the loss of penalties")
  l_Ask.l26 = dialog.AddLabel("points and gain of bonus points. We only update")
  l_Ask.l27 = dialog.AddLabel("g_BestScore when condition checking is enabled.")  
  
	l_Ask.continue = dialog.AddButton("Continue", 1)
	dialog.Show(l_Ask)
	g_MaximumPotentialBonusPoints = l_Ask.maxbonus.value
	if g_MaximumPotentialBonusPoints == "" then
		g_MaximumPotentialBonusPoints = 0
	end
	g_bTemporarilyDisableConditionChecking = l_Ask.bTemporarilyDisableConditionChecking.value
end

-- Called from SaveBest() and DefineGlobalVariables()...
function TemporarilyDisableConditionChecking()
	-- Enables faster CPU processing, but your scores will not be counted...

	behavior.SetFiltersDisabled(true)
  
	if g_bBetterRecentBest == true then -- set in ReenableNormalConditionChecking() below...
		save.Quicksave(99) -- Save
		save.Quickload(98) -- Load
		recentbest.Save() -- Save the current pose as the recentbest pose.  
		save.Quickload(99) -- Load
    
    -- shouldn't we reset g_bBetterRecentBest to false here?
    g_bBetterRecentBest = false -- well, I'm doing it.
	end
  
end

-- Called from SaveBest() and CleanUp()...
function ReenableNormalConditionChecking()
	-- Disables faster CPU processing, so your scores will be counted...

	local l_RecentBestPoseTotalScore = GetPoseTotalScore(recentbest) -- class "recentbest"
  
	if l_RecentBestPoseTotalScore > g_BestScore then    
    g_bBetterRecentBest = true -- read in TemporarilyDisableConditionChecking() above...
    g_BestScore = l_RecentBestPoseTotalScore
		save.Quicksave(99) -- Save
		recentbest.Restore() -- Keep the current pose if it's better; otherwise, restore the recentbest pose.
		save.Quicksave(98) -- Save
		save.Quickload(99) -- Load
	end
  
	behavior.SetFiltersDisabled(false)
end
-- ...end of Temporarily Disable Condition Checking module.

-- Start of Segments and Segment Ranges manipulation module...
-- Notice that most functions assume that the segment
-- ranges are well formed (i.e., sorted and no overlaps)
-- Called from 1 place in CleanUpSegmentRangesTable(),
---            1 place in GetCommonSegmentRangesInBothTables(),
--             1 place in FindFrozenSegmentRanges(),
--             1 place in FindLockedSegmentRanges(),
--             1 place in FindLockedSegmentRanges(),
--             1 place in FindSelectedSegmentRanges(), and 
--             1 place in FindSegmentRangesWithSecondaryStructureType()...
function ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)
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
end

-- Called from 1 place in CleanUpSegmentRangesTable() and
--             2 places in GetCommonSegmentRangesInBothTables()...
function ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
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
end

-- Called from 1 place in AskUserToSelectSegmentsToRebuild()...
function CleanUpSegmentRangesTable(l_SegmentRangesTable)
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_SegmentsTable={SegmentIndex} e.g., {1,2,3,9,10,11,134,135}

	-- This makes it well formed...
	local l_SegmentsTable = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable)
	local l_CleanedUpSegmentRangesTable = ConvertSegmentsTableToSegmentRangesTable(l_SegmentsTable)

	return l_CleanedUpSegmentRangesTable

end

-- Called from 1 place in SegmentRangesMinus() and 1 place in AskUserToSelectSegmentsToRebuild()...
function InvertSegmentRangesTable(l_SegmentRangesTable, l_MaxSegmentIndex)
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_InvertedSegmentRangesTable={StartSegment, EndSegment} e.g., {{4,8},{12,133}}

	-- Returns all segment ranges not in the passed in segment ranges ...
	-- l_MaxSegmentIndex is added for ligand
	local l_InvertedSegmentRangesTable = {}

	if l_MaxSegmentIndex == nil then
		-- l_MaxSegmentIndex = structure.GetCount()
		l_MaxSegmentIndex = g_SegmentCountWithLigands
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
end

-- Called from 1 place in ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable()...
function bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesTable)
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
end

-- Called from 1 place in GetCommonSegmentRangesInBothTables()...
function FindCommonSegmentsInBothTables(l_SegmentsTable1, l_SegmentsTable2)
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
end

-- Called from 1 place in SegmentRangesMinus() and 2 places in AskUserToSelectSegmentsToRebuild()...
function GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, l_SegmentRangesTable2)
	-- l_SegmentRangesTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}

	local l_SegmentsTable1 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable1)
	local l_SegmentsTable2 = ConvertSegmentRangesTableToSegmentsTable(l_SegmentRangesTable2)
	local l_SegmentsInBothTables = FindCommonSegmentsInBothTables(l_SegmentsTable1,l_SegmentsTable1)
	local l_GetCommonSegmentRangesInBothTables = 
		ConvertSegmentsTableToSegmentRangesTable(l_SegmentsInBothTables)

	return l_GetCommonSegmentRangesInBothTables
end

 -- Called from 6 places in AskUserToSelectSegmentsToRebuild() and
 --             3 places in bAskUserToSelectRebuildOptions()...
function SegmentRangesMinus(l_SegmentRangesTable1, l_SegmentRangesTable2)
	return GetCommonSegmentRangesInBothTables(l_SegmentRangesTable1, InvertSegmentRangesTable(l_SegmentRangesTable2))
end

-- Called from 1 place in DisplaySelectedOptions(), 1 place in AskUserToSelectSegmentsToRebuild(), and
--  1 place in bAskUserToSelectRebuildOptions()...
function ConvertSegmentRangesTableToListOfSegmentRanges(l_SegmentRangesTable)

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

	end

	return l_SegmentString
end

-- Called from 1 place in main()...
function ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(l_SegmentRangesToRebuildTable)
	-- l_SegmentRangesToRebuildTable={StartSegment, EndSegment} e.g., {{1,3},{9,11},{134,135}}
	-- l_bSegmentsToRebuildBooleanTable={bToWorkOn} -- e.g., {true,true,false,true, ...}

	local l_bSegmentsToRebuildBooleanTable = {}

	-- for l_SegmentIndex = 1, structure.GetCount() do
	for l_SegmentIndex = 1, g_SegmentCountWithLigands do

		l_bSegmentsToRebuildBooleanTable[l_SegmentIndex] =
			bIsSegmentIndexInSegmentRangesTable(l_SegmentIndex, l_SegmentRangesToRebuildTable)

	end

	return l_bSegmentsToRebuildBooleanTable
end
-- ...end of Segments and Segment Ranges manipulation module.
--
-- Start of Find Segments With a Specified Type module...
-- Called from 1 place in DisplayPuzzleProperties() and
--             1 place in DefineGlobalVariables() (this one breaks the rule of define first, use next)...
function GetNumberOfMutableSegments()

	local l_GetNumberOfMutableSegments = 0

	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do

		if structure.IsMutable(l_SegmentIndex) then
			l_GetNumberOfMutableSegments = l_GetNumberOfMutableSegments + 1
		end

	end
	return l_GetNumberOfMutableSegments

end

-- Called from 1 place in FindFrozenSegmentRanges()...
function FindFrozenSegments()
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
		local l_bBackboneIsFrozen = false
		local l_bSideChainIsFrozen = false
		l_bBackboneIsFrozen, l_bSideChainIsFrozen = freeze.IsFrozen(l_SegmentIndex)
		if l_bBackboneIsFrozen == true or l_bSideChainIsFrozen == true then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
			print("  Frozen Segment[" .. l_SegmentIndex .. "]")
		end
	end
	return l_SegmentsTable
end

-- Called from 1 place in AskUserToSelectSegmentsToRebuild() and
--             1 place in bAskUserToSelectRebuildOptions()...
function FindFrozenSegmentRanges()
	return ConvertSegmentsTableToSegmentRangesTable(FindFrozenSegments())
end

-- Called from 1 place in FindLockedSegmentRanges()...
function FindLockedSegments()
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
		if structure.IsLocked(l_SegmentIndex) then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
	end
	return l_SegmentsTable
end

-- Called from 1 place in AskUserToSelectSegmentsToRebuild() and
--             1 place in bAskUserToSelectRebuildOptions()...
function FindLockedSegmentRanges()
	return ConvertSegmentsTableToSegmentRangesTable(FindLockedSegments())
end

-- Called from 1 place in FindSelectedSegmentRanges()...
function FindSelectedSegments()
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCountWithLigands do
		if selection.IsSelected(l_SegmentIndex) then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
	end
	return l_SegmentsTable
end

-- Called from 1 place in SetSegmentRangeSecondaryStructureType,
--             2 places in AskUserToSelectSegmentsToRebuild(), and 1 place in main()...
function FindSelectedSegmentRanges()
	return ConvertSegmentsTableToSegmentRangesTable(FindSelectedSegments())
end

-- Called from 1 place in FindSegmentRangesWithSecondaryStructureType()...
function FindSegmentsWithSecondaryStructureType(In_SecondaryStructureType)
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
		local l_GetSecondaryStructureType = structure.GetSecondaryStructure(l_SegmentIndex)  --eg L,E,H,M
		if l_GetSecondaryStructureType == In_SecondaryStructureType then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
	end
	return l_SegmentsTable
end

-- Called from 4 places in AskUserToSelectSegmentsToRebuild() and 
--             1 place  in bAskUserToSelectRebuildOptions()...
function FindSegmentRangesWithSecondaryStructureType(l_SecondaryStructureType)
	return ConvertSegmentsTableToSegmentRangesTable(FindSegmentsWithSecondaryStructureType(l_SecondaryStructureType))
end

-- Called from 1 place in PopulateGlobalCysteinesTable()...
function FindSegmentsWithAminoAcidType(In_AminoAcidType)
	-- l_SegmentsTable={SegmentIndex} -- e.g., {1,2,3,9,10,11,134,135}
	local l_SegmentsTable = {}
	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
			local l_GetAminoAcid = structure.GetAminoAcid(l_SegmentIndex) -- e.g., "c"
		if l_GetAminoAcid == In_AminoAcidType then
			l_SegmentsTable[#l_SegmentsTable + 1] = l_SegmentIndex
		end
	end
	return l_SegmentsTable
end
-- ...end of Find Segments With a Specified Type module.

-- Start of Quick Save Stack module...
-- Called from 1 place in RememberSolutionWithDisulfideBondsIntact(),
--             1 place in PerformNormalStabilizationOnSegmentRange(),
--             1 place in MutateOneSegmentRange(), and
--             1 place in RebuildOneSegmentRangeManyTimes()...
function SaveCurrentSolutionToQuickSaveStack()
	if g_QuickSaveStackPosition >= 100 then
		print("Quicksave stack overflow, exiting script")
		exit()
	end
	save.Quicksave(g_QuickSaveStackPosition) -- Save
	g_QuickSaveStackPosition = g_QuickSaveStackPosition + 1
end

-- Called from 1 place in CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact(),
--             1 place in PerformNormalStabilizationOnSegmentRange(),
--             1 place in MutateOneSegmentRange(), and 
--             1 place in RebuildOneSegmentRangeManyTimes()...
function LoadLastSavedSolutionFromQuickSaveStack()
	if g_QuickSaveStackPosition <= 60 then
		print("Quicksave stack underflow, exiting script")
		exit()
	end
	g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	save.Quickload(g_QuickSaveStackPosition) -- Load
end

-- Called from 1 place in CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact(),
--             1 place in PerformNormalStabilizationOnSegmentRange(), and
--             1 place in MutateOneSegmentRange()...
function RemoveLastSavedSolutionFromQuickSaveStack()
	if g_QuickSaveStackPosition > 60 then
		g_QuickSaveStackPosition = g_QuickSaveStackPosition - 1
	end
end
-- ...end of Quick Save Stack module.

-- Start of Disulfide Bonds module...
-- Called from 1 place in CountDisulfideBonds()...
function bIsADisulfideBondSegment(l_SegmentIndex)
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
end

-- Called from 1 place in PopulateGlobalCysteinesTable() and
--             1 place in bOneOrMoreDisulfideBondsHaveBroken()...
function CountDisulfideBonds()
	local l_Count = 0
	for l_SegmentIndex = 1, #g_CysteineSegmentsTable do
		if bIsADisulfideBondSegment(g_CysteineSegmentsTable[l_SegmentIndex]) then
			l_Count = l_Count + 1
		end
	end
	return l_Count
end

-- Called from 1 place in DisplayPuzzleProperties()...
function PopulateGlobalCysteinesTable()
	--g_CysteineSegmentsTable={SegmentIndex}
	g_CysteineSegmentsTable = FindSegmentsWithAminoAcidType("c")
	g_OriginalNumberOfDisulfideBonds = CountDisulfideBonds()
end

-- Called from 1 place in RememberSolutionWithDisulfideBondsIntact(),
--             1 place in RebuildSelectedSegments(), and
--             1 place in RebuildManySegmentRanges()...
function bOneOrMoreDisulfideBondsHaveBroken()
	if g_bUserWantsToKeepDisulfideBondsIntact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
	-- User wants to keep disulfide bonds intact...
	local l_NumberOfDisulfideBonds = CountDisulfideBonds()
	if  l_NumberOfDisulfideBonds < g_OriginalNumberOfDisulfideBonds then
		return true
	end  
	return false
end

-- Called from 1 place in MutateOneSegmentRange(), 1 place in RebuildSelectedSegments(),
-- 1 place in RebuildOneSegmentRangeManyTimes() and 4 places in RebuildManySegmentRanges()...
function RememberSolutionWithDisulfideBondsIntact()
	if g_bUserWantsToKeepDisulfideBondsIntact == false then
		-- User does not care if disulfide bonds break, so...
		return false
	end
	-- User wants to keep disulfide bonds intact...
	-- As a precaution, let's save our current solution... If the next build
	-- breaks any disufide bonds, we can (and will) revert back to this solution...
	SaveCurrentSolutionToQuickSaveStack()
end

-- Called from 1 place in MutateOneSegmentRange(), 1 place in RebuildSelectedSegments(),
-- 1 place in RebuildOneSegmentRangeManyTimes() and 6 places in RebuildManySegmentRanges()...
function CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
	if g_bUserWantsToKeepDisulfideBondsIntact == false then
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
end
-- ...end of Disulfide Bonds module.

-- Start of FuseBestPosition module...
-- Called from 1 place in FuseBestPositionEnd(), 
--             4 times in FuseBestPosition(),
--             1 time  in Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(),
--             1 time  in RebuildOneSegmentRangeManyTimes(), and 
--             2 times in RebuildManySegmentRanges()...
function SaveBest()
  
  if g_bTemporarilyDisableConditionChecking == true then
    
   	local l_PoseTotalScoreWithConditionCheckingDisabled = GetPoseTotalScore()
  	local l_PotentialScoreIfAllConditionsAreMet = 
          l_PoseTotalScoreWithConditionCheckingDisabled + g_MaximumPotentialBonusPoints
    
    if (l_PotentialScoreIfAllConditionsAreMet <= g_BestScore) then  
      return
    end
    
    -- Do not attempt to improve g_BestScore if:
    -- 1) Normal condition checking is temporarily disabled, and
    -- 2) Reenabling normal condition checking would not likely improve our g_BestSCore.
    
    -- When normal condition checking is disabled, our scores are only potential scores; that is,
    -- if all conditions are met. We won't know if all conditions are met until we re-enable
    -- normal condition checking. We only temporarily disable normal condition checking to speed
    -- up the rebuld process, and only when there are potential bonus points to be earned.
  end
    
  if g_bTemporarilyDisableConditionChecking == true then
    -- Temporarily re-enable normal condition checking, so we
    -- can look at real scores instead of potential scores...
    ReenableNormalConditionChecking()
  end
  
  local l_RealPoseTotalScore = GetPoseTotalScore()
  local l_RealPointsGained = l_RealPoseTotalScore - g_BestScore
  local l_MinimumGainForSave = 0
  if g_bSketchBookPuzzle == true then
    l_MinimumGainForSave = g_SketchBookPuzzleMinimumGainForSave
  end
  
  if l_RealPointsGained > l_MinimumGainForSave or 
    (l_RealPointsGained > 0 and g_bFoundAHighGain == true) then
    
    g_BestScore = l_RealPoseTotalScore  -- This is what you are looking for.
    
    if g_bFuseBestPosition == false and g_BestScore > 0 then
      print("\nNow that the total score is positive, we will switch back on: " ..
            "'perform normal stabilization' and 'fuse best position'.\n")
      g_bFuseBestPosition = true
      g_bPerformNormalStabilization = true
    end
    
    save.Quicksave(3) -- Save
    g_bFoundAHighGain = true -- not exactly sure how this one works yet.
  end
  
  if g_bTemporarilyDisableConditionChecking == true then
    -- Disable condition checking again (re-enable fast CPU processing)...
    TemporarilyDisableConditionChecking()
  end

end -- SaveBest()

-- Called from 1 place  in FuseBestPositionEnd(),
--             2 places in FuseBestPositionEnd(),
--             3 places in FuseBestPosition2(),
--             4 places in PerformNormalStabilizationOnSegmentRange(),
--             4 places in RebuildOneSegmentRangeManyTimes(), and
--             2 places in RebuildManySegmentRanges()...
function ShakeAndOrWiggle(l_How, l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
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
		l_WiggleFactor = g_WiggleFactor
	end

	l_bWiggleBackbone  = true
	l_bWiggleSideChains = true

	if l_How == "ShakeAndWiggle" then
		-- Shake is not considered to do much in second or more rounds
		if l_bShake_And_Wiggle_OnlySelectedSegments == true then
			structure.ShakeSidechainsSelected(1)
		else
			structure.ShakeSidechainsAll(1)
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
		structure.WiggleSelected(l_Iterations, l_bWiggleBackbone, l_bWiggleSideChains)
	else
		structure.WiggleAll(l_Iterations, l_bWiggleBackbone, l_bWiggleSideChains)
	end

end -- ShakeAndOrWiggle(l_How, l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)

-- Called from 1 place in FuseBestPositionEnd() and
--             4 places in FuseBestPosition()...
function GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	-- Keep the current pose if it's better; otherwise, restore the recentbest pose.
	-- Picks up all gains by using recentbest...
	local l_RecentBestScore = GetRecentBestScore()
	--local l_PoseTotalScore = GetPoseTotalScore()
	if l_RecentBestScore > g_BestScore then
    
		if l_DoPreFunction ~= nil then
			l_DoPreFunction()
		end
    
		recentbest.Restore() -- Keep the current pose if it's better; otherwise, restore the recentbest pose.
    
		if l_DoPostFunction ~= nil then
			l_DoPostFunction()
		end
    
	end
  
  -- All calls to GetRecentBest() eventually call SaveBest(), so we don't need to do it here.
  
end

-- Called from 2 places in FuseBestPosition()...
function FuseBestPositionEnd(l_DoPreFunction, l_DoPostFunction)
	
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
	
	SaveBest()
end

-- Called from 3 places in FuseBestPosition()...
function FuseBestPosition1(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction,
		l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	
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
	
end

-- Called from 2 places in FuseBestPosition()...
function FuseBestPosition2(l_ClashImportanceBefore, l_ClashImportanceAfter, l_DoPreFunction,
		l_DoPostFunction)
	
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
	
end

-- Called from 5 places in FuseBestPosition()...
function reFuseBestPosition(l_Score, l_SlotNumber)
	
	local l_CheckPoseTotalScore = GetPoseTotalScore()
	
	if l_CheckPoseTotalScore < l_Score then
		-- new score is not good, so load previous position...
		save.Quickload(l_SlotNumber) -- Load previous position
	else
		-- new score is better. keep it and save the current position...
		l_Score = l_CheckPoseTotalScore
		save.Quicksave(l_SlotNumber) -- Save current position
	end
	
	return l_Score
	
end

-- Called from 2 places in RebuildManySegmentRanges()...
function FuseBestPosition(l_SlotNumber, l_DoPreFunction, l_DoPostFunction,
                          l_bShake_And_Wiggle_OnlySelectedSegments)

	local l_PoseTotalScore = GetPoseTotalScore()
	
	if l_SlotNumber == nil then
		l_SlotNumber = 4
		save.Quicksave(l_SlotNumber) -- Save
	end

	recentbest.Save() -- Save the current pose as the recentbest pose.  
	
	FuseBestPosition1(0.3, 0.6, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	FuseBestPositionEnd(l_DoPreFunction, l_DoPostFunction)
	l_PoseTotalScore = reFuseBestPosition(l_PoseTotalScore, l_SlotNumber)

	FuseBestPosition2(0.3, 1, l_DoPreFunction, l_DoPostFunction)
	-- Keep the current pose if it's better; otherwise, restore the recentbest pose...
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest()
	l_PoseTotalScore = reFuseBestPosition(l_PoseTotalScore, l_SlotNumber)

	FuseBestPosition1(0.05, 1, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest()
	l_PoseTotalScore = reFuseBestPosition(l_PoseTotalScore, l_SlotNumber)

	FuseBestPosition2(0.7, 0.5, l_DoPreFunction, l_DoPostFunction)
	FuseBestPositionEnd()
	l_PoseTotalScore = reFuseBestPosition(l_PoseTotalScore, l_SlotNumber)

	FuseBestPosition1(0.07, 1, l_DoPreFunction, l_DoPostFunction, l_bShake_And_Wiggle_OnlySelectedSegments)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest()
	
	reFuseBestPosition(l_PoseTotalScore, l_SlotNumber)
	GetRecentBest(l_DoPreFunction, l_DoPostFunction)
	SaveBest()
end
-- ...end of FuseBestPosition module.

-- Start of Segments module...
-- Called from 1 place in RebuildManySegmentRanges()...
function ConvertAllSegmentsToLoops() -- Turn entire structure into loops...

	local l_bAnyChange = false

	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do

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
end
-- ...end of Segments module.

-- Start of Segment Range Done module...
-- Called from 1 place in RebuildManySegmentRanges()...
function SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)

  -- Loop through the given segment range and set the g_SegmentsAlreadyRebuiltTable
  -- values to true for each segments in the given range...
  for l_TableIndex = l_StartSegment, l_EndSegment do

    -- Update one row in the g_SegmentsAlreadyRebuiltTable...
    g_SegmentsAlreadyRebuiltTable[l_TableIndex] = true
  end

end -- SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)

-- Called from bSegmentRangeIsAllowedToBeRebuilt()...
function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)
  
  -- Normally all worst scoring segment ranges are selected to be rebuilt.
  -- They can only be removed on the "Select Segments to Rebuild" page...
  -- g_bSegmentsToRebuildBooleanTable is populated in main()
  if g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == false then
			return false -- note how this option overrides the below options.
	end

  if g_bAlwaysAllowRebuildingAlreadyRebuiltSegments == true then
		return true
	end
  
  -- g_CurrentRebuildPointsGained is set in RebuildManySegmentRanges()...
  if g_CurrentRebuildPointsGained > 
    g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan then
    return true
  end
  
  if g_SegmentsAlreadyRebuiltTable[l_SegmentIndex] == true then
    return false
  end
  
  -- This segment has not already been rebuilt and
  -- the user did not unselect the segment range...
  return true
  
end -- function bSegmentIsAllowedToBeRebuilt(l_SegmentIndex)

function bSegmentRangeIsAllowedToBeRebuilt(l_StartSegment, l_EndSegment)
  
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

-- Called from 1 place in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()...
function CheckIfAlreadyRebuiltSegmentsMustBeIncluded()

  -- If we cannot find enough consecutive not-already-rebuilt segments available to meet
	-- the minimum, we will set all the entries in the g_SegmentsAlreadyRebuiltTable to false.
  -- This will allow all already-rebuilt segments to be treated as not-already-rebuilt segments.
	-- Then, when we are forming segment ranges to process, we be able to meet the
	-- minimun number of consecutive segments per segment range required by the user.

	local l_ConsecutiveSegmentsCounter = 0
	for l_TableIndex = 1, g_SegmentCountWithoutLigands do
    if bSegmentIsAllowedToBeRebuilt(l_TableIndex) == false then
			-- Since this segment is not allowed to be rebuilt, it cannot be
      -- counted as a consecutive segment. Start the counter over again...
			l_ConsecutiveSegmentsCounter = 0

		else
			l_ConsecutiveSegmentsCounter = l_ConsecutiveSegmentsCounter + 1
		end

		if l_ConsecutiveSegmentsCounter >= g_RequiredNumberOfConsecutiveSegments then
			-- Ah ha, there are enough consecutive Segments to meet the minimun required
			-- segments per segment range, despite having a bunch of already-rebuilt segments 
      -- in our way...
			-- No action required. We can return now...
			return
		end
	end

	-- Since there are not enough non-done segments in a row to meet
	-- the minimum, let's set all the entries in the g_SegmentsAlreadyRebuiltTable to false.
	-- This should give us plenty of segments to work with...
	print("\nNot enough consecutive not-already-rebuilt segments available to create a segment range;" ..
         " therefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
       
  ResetSegmentsAlreadyRebuiltTable()
       
end -- CheckIfAlreadyRebuiltSegmentsMustBeIncluded()

-- Called from 1 place in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()...
function ResetSegmentsAlreadyRebuiltTable()

	for l_TableIndex = 1, g_SegmentCountWithoutLigands do
		g_SegmentsAlreadyRebuiltTable[l_TableIndex] = false
	end

end -- function ResetSegmentsAlreadyRebuiltTable()

-- ...end of Segment Ranges Done module.

-- Start of ScoreParts and Scores module...
-- Called from 1 place in GetPoseTotalScore()...
function GetSegmentScore(l_pose)
	if l_pose == nil then
		l_pose = current -- the class "current"
	end
	local l_TotalSegmentScore = 8000 -- In Foldit, the overall score of the protein is the sum of the scores of each segment, plus an arbitrary 8000, plus the bonuses or penalties from any conditions defined for the puzzle. Read more about scores here: https://foldit.fandom.com/wiki/Score
	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
		local SegmentEnergyScore = l_pose.GetSegmentEnergyScore(l_SegmentIndex)
		print("l_pose.GetSegmentEnergyScore(" .. l_SegmentIndex .. ")=[" .. SegmentEnergyScore .. "].")
		l_TotalSegmentScore = l_TotalSegmentScore + SegmentEnergyScore
	end
	return l_TotalSegmentScore
end

-- Called from 42 places in 21 functions...
--  When possible use g_BestScore instead of calling this function.
--  If only recording the current score before performing an action
--  which might change the current score, then use g_BestScore.
--  If something was done that could have changed the current score, like 
--  Rebuild, Shake, Wiggle, etc, then call this function for the latest score.
--  Honestly, always calling this function in production should be fine, it 
--  really only matters in debug mode, because any call to this function 
--  might return a new random value.
function GetPoseTotalScore(l_pose)
  -- A pose is everything, including the main protein and any ligands.
	-- Keep the current pose if it's better; otherwise, restore the recentbest pose.
	if l_pose == nil then
		l_pose = current -- the class "current"
	end
	local l_Total = l_pose.GetEnergyScore()
	-- print("l_pose.GetEnergyScore()=[" .. l_pose.GetEnergyScore() .. "].")

	-- Work-around for big negatives...
	if l_Total < -999999 and l_Total > -1000001 then -- Why check the lower limit of -1000001?
		l_Total = GetSegmentScore(l_pose)
	end

	return l_Total

end

-- Called from 1 place in GetRecentBest() and 1 place in RebuildManySegmentRanges()...
function GetRecentBestScore() 
	l_RecentBestScore = GetPoseTotalScore(recentbest) -- the class "recentbest"
	return l_RecentBestScore
end

-- Called from 1 place recursively in CalculateSegmentRangeScore(),
--             2 places inDisplayPuzzleProperties(),
--             2 places in GetScorePart_Score(), 
--             1 place in PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts(), and 
--             1 place in CheckForLowStartingScore()...
function CalculateSegmentRangeScore(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment, l_pose)

	-- Note: l_ScorePart_NameOrTable is optional, if it's nil we use
	--       GetSegmentEnergyScore instead of GetSegmentEnergySubscore.

	-- Note: l_ScorePart_NameOrTable can be either a single string, or a table of strings.

	-- Note: Each Segment can have up to 20 named score parts.
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
		for l_ScorePart_NameOrTableIndex = 1, #l_ScorePart_NameOrTable do
			-- recursion...
			-- Call back with each ScorePart in the ScorePart_NameOrTable...
			l_ScorePart_Name = l_ScorePart_NameOrTable[l_ScorePart_NameOrTableIndex]
			l_ScorePart_Score = CalculateSegmentRangeScore(l_ScorePart_Name, l_StartSegment, l_EndSegment, l_pose)
			l_ScoreTotal = l_ScoreTotal + l_ScorePart_Score
		end
	else
		if l_ScorePart_NameOrTable == nil and l_StartSegment == nil and l_EndSegment == nil then            
			--local l_PoseTotalScore = GetPoseTotalScore(l_pose)
			return g_BestScore
		end
		if l_StartSegment == nil then
			l_StartSegment = 1
		end
		if l_EndSegment == nil then
			l_EndSegment = g_SegmentCountWithLigands -- include ligands
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

end -- CalculateSegmentRangeScore(l_ScorePart_NameOrTable, l_StartSegment, l_EndSegment, l_pose)

-- Called from 1 place in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()...
function SortBySegmentScore(l_Table, l_NumberOfItems)
	-- Backward bubble sorting, lowest on top, only needed l_NumberOfItems
	for x = 1, l_NumberOfItems do
		for y = x + 1, #l_Table do
			if l_Table[x][1] > l_Table[y][1] then
				l_Table[x], l_Table[y] = l_Table[y], l_Table[x]
			end
		end
	end
	return l_Table
end

-- Called from 3 places in PrepareToRebuildSegmentRanges() and 
--             1 place  recursively below...
function InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges(l_RecursionLevel)

	if l_RecursionLevel == nil then
		l_RecursionLevel = 1
	end

  print("\nSearching for the " .. g_MaxNumberOfSegmentRangesToProcessThisRunCycle .. 
         " worst scoring segment ranges (each range containing " ..
          g_RequiredNumberOfConsecutiveSegments .. " consecutive segments)...")

  CheckIfAlreadyRebuiltSegmentsMustBeIncluded()
  
	-- l_WorstScoringSegmentRangesTable={Segment Score, StartSegment}
	l_WorstScoringSegmentRangesTable = {}

	-- g_SegmentScoresTable = {SegmentScore}
	PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts()

	local l_SkipTheseSegments = ""
	local l_NumberOfSegmentsSkipping = 0
	local l_StartSegment, l_EndSegment

	local l_FirstPossibleSegmentThatCanStartARangeOfSegments = 1

	local l_LastPossibleSegmentThatCanStartARangeOfSegments =
		g_SegmentCountWithoutLigands - g_RequiredNumberOfConsecutiveSegments + 1
	-- An example:
	-- g_SegmentCountWithoutLigands = 5 -- this is the last non-ligand segment
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
        
        l_SegmentScore = GetScorePart_Score(l_StartSegment, l_EndSegment)

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
		 print("\nSkipping the following " .. l_NumberOfSegmentsSkipping ..
           " already rebuilt (or unselected) segments: [" .. l_SkipTheseSegments .. "]")
	end

	-- Note: The only reason we add the l_SegmentScore as the first field
	--       in the l_WorstScoringSegmentRangesTable, is so we can sort the table from
	--       lowest to highest Segment Score.
	-- Please Remember!! This is one row per *segment*, not one row per segment range!
	--        So, if there are 135 non-ligand segments, this table
	--        will have 135 rows, every time this function is called!
	l_WorstScoringSegmentRangesTable =
		SortBySegmentScore(l_WorstScoringSegmentRangesTable,
      g_MaxNumberOfSegmentRangesToProcessThisRunCycle)
	-- Example table entries {{50.111, 1}, {20.32, 2}, {0.234, 3}, {30.5, 6}, {10.3, 7}},
	-- would be sorted as {{0.234, 3}, {10.3, 7}, {20.32, 2}, {30.5, 6}, {50.111, 1}}

	local l_NumberOfSegmentRangesToProcessThisRunCycle = #l_WorstScoringSegmentRangesTable

	if l_NumberOfSegmentRangesToProcessThisRunCycle > 
     g_MaxNumberOfSegmentRangesToProcessThisRunCycle then
		l_NumberOfSegmentRangesToProcessThisRunCycle = g_MaxNumberOfSegmentRangesToProcessThisRunCycle
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

		-- Not exactly sure why we are doing the following, since we already
		-- called CheckIfAlreadyRebuiltSegmentsMustBeIncluded() at the beginning of this function.
    print("\nNot enough consecutive not-already-rebuilt segments available to create a segment range;" ..
           " therefore, we will set all already-rebuilt segments to not-already-rebuilt and try again...")
         
		ResetSegmentsAlreadyRebuiltTable()

		-- Recursion...
		l_RecursionLevel = l_RecursionLevel + 1
		InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges(l_RecursionLevel)

	end

end -- InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges(l_RecursionLevel)

-- Called from 1 place in Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields() and
--             1 place in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()...
function GetScorePart_Score(l_StartSegment, l_EndSegment, l_Attr)

	local l_PartScore = 0

	if l_Attr == 'total' then

		l_PartScore = GetPoseTotalScore()
    -- nope, does not work...l_PartScore = g_BestScore

	elseif l_Attr == nil then
		--is only called from InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges

		for l_SegmentIndex = l_StartSegment, l_EndSegment do

			-- g_SegmentScoresTable = {SegmentScore}
			-- This is the only place this table is read...
			l_PartScore = l_PartScore + g_SegmentScoresTable[l_SegmentIndex]
		end

	elseif l_Attr == 'loctotal' then --total segment scores

		l_PartScore = CalculateSegmentRangeScore(nil, l_StartSegment, l_EndSegment)

	elseif l_Attr == 'ligand' then --ligand score

		for l_SegmentIndex = g_SegmentCountWithoutLigands + 1, g_SegmentCountWithLigands do
			l_PartScore = l_PartScore + current.GetSegmentEnergyScore(l_SegmentIndex)
		end

	else

		l_PartScore = CalculateSegmentRangeScore(l_Attr, l_StartSegment, l_EndSegment)

	end
	return l_PartScore
end

-- Called from 1 place in InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()...
function PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts()
	
	if g_BestScore == g_LastSegmentScore then
    -- If g_BestScore has not changed since the last time we set Segment Scores,
    -- then we assume the segment scores also have not changed. So we leave them alone.
		return 
	end

	local l_SegmentScore, l_ReferencePartScore, l_DensityPartScore

	-- Fortunately this is the only function that sets and checks g_LastSegmentScore...
	g_LastSegmentScore = g_BestScore

	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do

		if g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == true then

			if #g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table == 0 then
				-- If no ScoreParts were selected by the user to work on, the default segment score is
				-- SegmentEnergyScore - ReferencePartScore + weighted DensityPartScore
				l_SegmentScore = current.GetSegmentEnergyScore(l_SegmentIndex)
					-- If this segment is not a Mutable, then
					-- subtract back out (of the SegmentScore) the ReferencePartScore...
				local l_bThisSegmentIsMutable = structure.IsMutable(l_SegmentIndex)
				if l_bThisSegmentIsMutable == false then
					l_ReferencePartScore = current.GetSegmentEnergySubscore(l_SegmentIndex, 'Reference')
					l_SegmentScore = l_SegmentScore - l_ReferencePartScore
				end
				-- If a Density component exists, add extra points to the SegmentScore...
				if math.abs(g_DensityWeight) > 0 then --the Density component has extra weighted points
					l_DensityPartScore = current.GetSegmentEnergySubscore(l_SegmentIndex, 'Density')
					l_SegmentScore = l_SegmentScore + g_DensityWeight * l_DensityPartScore
				end
			else
				l_SegmentScore = 
          CalculateSegmentRangeScore(g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table,
                                     l_SegmentIndex, l_SegmentIndex)
			end

			-- Add (and/or update?) one row in the g_SegmentScoresTable...
			-- g_SegmentScoresTable = {SegmentScore}
			-- This is the only place this table is populated...
			g_SegmentScoresTable[l_SegmentIndex] = l_SegmentScore

		end -- If g_bSegmentsToRebuildBooleanTable[l_SegmentIndex] == true then

	end -- for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do

end -- PopulateGlobalSegmentScoresTableBasedOnUserSelectedScoreParts()

-- Called from 1 place in PopulateGlobalScorePartsTable()...
function PopulateGlobalActiveScorePartsTable()

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
	local l_ScorePart_Name
  -- Score from only one ScorePart in only one of the protein's segments...
	local l_OneScorePart_ScoreFromOneSegment = 0
   -- Total score from only one ScorePart, but for all of the protein's segments...
	local l_TotalOf_OneScorePart_ScoresFromAllSegments = 0
  local l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments = 0
 
 local l_TotalOfAll_ScorePart_Scores = 0
  
	print("\nActivating Score Parts based on ScorePart Score activity greater than 10 points...\n")

	-- Loop through all possible ScoreParts according to the foldit game...
	for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do

		l_ScorePart_Name = l_ScorePart_NamesTable[l_ScorePart_NamesTableIndex]
		l_TotalOf_OneScorePart_ScoresFromAllSegments = 0
    
    l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments = 0

		-- Look at every Segment to see if it has a score for the current ScorePart...
		for l_SegmentIndex = 1, g_SegmentCountWithLigands do

      l_OneScorePart_ScoreFromOneSegment = 
        current.GetSegmentEnergySubscore(l_SegmentIndex, l_ScorePart_Name)

      l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments = 
        l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments +
        math.abs(l_OneScorePart_ScoreFromOneSegment)

      -- This is just for display purposes...
      l_TotalOf_OneScorePart_ScoresFromAllSegments = 
        l_TotalOf_OneScorePart_ScoresFromAllSegments +
        l_OneScorePart_ScoreFromOneSegment
        
		end
    l_TotalOfAll_ScorePart_Scores = l_TotalOfAll_ScorePart_Scores + l_OneScorePart_ScoreFromOneSegment

    -- I know it seems confusing to use the sum of absolute values, but what we are looking for here is
    -- a magnitude of activity, both positive and negative. If we didn't use the absolute value, then
    -- we could end up adding a +100 and -100 points = 0 total, which would look like no activity, but
    -- there really is activity. Lots of activity, in both positive and negative ways...
		if l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments > 10 then
      
			g_ActiveScorePartsTable[#g_ActiveScorePartsTable + 1] = l_ScorePart_Name

			print("  Active Score Part: " .. l_ScorePart_Name .. "," ..
            " activity: " .. 
            PrettyNumber(l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments) .. "," .. 
            " Score: " .. PrettyNumber(l_TotalOf_OneScorePart_ScoresFromAllSegments) .. "")
    
		else

			if l_ScorePart_Name == 'Disulfides' then
          if g_OriginalNumberOfDisulfideBonds > 0 then
            print("  Active Score Part: [Disulfides]")
          else
            -- don't display anything
          end
			else
        -- commenting this out because it is basically just noise in the log file...
        --print("  Inactive Score Part: " .. l_ScorePart_Name .. "," ..
        --      " activity: " ..
        --       PrettyNumber(l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments) .. "," .. 
        --      " Score: " .. PrettyNumber(l_TotalOf_OneScorePart_ScoresFromAllSegments) .. "")
			end
      
		end -- if l_TotalOf_OneScorePart_AbsoluteValueOfEachScoreFromAllSegments > 10 then

	end -- for l_ScorePart_NamesTableIndex = 1, #l_ScorePart_NamesTable do

	print("\nTotal of All Score Parts: " .. PrettyNumber(l_TotalOfAll_ScorePart_Scores) .. "")

end -- PopulateGlobalActiveScorePartsTable()

-- Called from 1 place in main()...
function PopulateGlobalScorePartsTable()

	-- Quick fix for failing first rebuild...
	for l_ScorePart_Number = 3, 12 do
		save.Quicksave(l_ScorePart_Number) -- Save
	end

	-- What's in ScoreParts (Slots) 1 and 2, I wonder?
	-- ScorePart (Slot) 3 always stores the best score

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
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

		g_ScorePartsTable[#g_ScorePartsTable + 1] = {l_ScorePart_Number, l_ScorePart_Name, l_bIsActive, l_LongName}

		print("\n  Note: Ligand scoring is active in ScorePart (slot) 6.")

		l_ScorePart_Number = l_ScorePart_Number + 1 -- now it's 7.
	end

	PopulateGlobalActiveScorePartsTable()
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
			l_LongName = l_ScorePart_Number .. " (" .. g_ActiveScorePartsTable[l_ActiveScorePartsTableIndex] .. ")"

			-- Finally, add the new g_ScorePartsTable record...
			g_ScorePartsTable[#g_ScorePartsTable + 1] = {l_ScorePart_Number, l_ScorePart_Name, l_bIsActive, l_LongName}

			l_ScorePart_Number = l_ScorePart_Number + 1
		end
	end

end -- PopulateGlobalScorePartsTable()

-- Called from 1 place in RebuildOneSegmentRangeManyTimes()...
function PopulateGlobalScorePartScoresTable()

	g_ScorePartScoresTable = {} -- reset it

	local l_ScorePart_Number
	local l_ScorePart_Score = -9999999
	local l_PoseTotalScore = -9999999
	local l_ScorePartsList = ''
	local l_bToDo = false
	local l_SegmentRangeRebuildAttempt = -1

	local l_bScorePartIsActive

	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_bScorePartIsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]

		if l_bScorePartIsActive == true then
			g_ScorePartScoresTable[#g_ScorePartScoresTable + 1] =
				{l_ScorePart_Number, l_ScorePart_Score, l_PoseTotalScore, l_ScorePartsList, l_bToDo}
		end
	end

end -- PopulateGlobalScorePartScoresTable()

-- Called from 1 place in RebuildOneSegmentRangeManyTimes() and 
--             1 place in RebuildManySegmentRanges()...
function Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment, l_EndSegment)
  
  -- Check for ScorePart improvements for this particular segment range rebuild attempt.
  -- For each ScorePart that improves, associate the current pose of the protein to 
  -- that ScorePart. After all the rebuild attempts (with their local shakes, wiggles
  -- and mutates) for this segment range have completed, we will step through each of
  -- the saved best ScorePart poses and regionally shake and wiggle them to see if we
  -- can further improve our score...
  
  -- Example g_ScorePartsTable entries...
  -- g_ScorePartsTable={
  -- ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4
  -- }
	-- {{4, "total", true, "4 (total)"},         {5, "loctotal", true, "5 (loctotal)"},
  --  {6, "ligand", true, "6 (ligand)"},       {7, "Clashing", true, "7 (Clashing)"},
  --  {8, "Pairwise", true, "8 (Pairwise)"},   {9, "Packing", true, "9 (Packing)"},
  --  {10, "Hiding", true, "10 (Hiding)"},     {11, "Bonding", true, "11 (Bonding)"},
  --  {12, "Ideality", true, "12 (Ideality)"}, {13, "Backbone", true, "13 (Backbone)"},
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
  
  -- Example g_ScorePartScoresTable entries...
  -- g_ScorePartScoresTable={
  -- ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5
 --{{4,-2070.4815006125305,-2070.4815006125305,"",false},{5,4.2974272030802663,-8544.6292812514057,"",false},
 -- {6,41.990611234103064,-5500.1149833617283,"",false},{7,0.45661696445231925,-4424.6808476751285,"",false},
 -- {8,1.3090043250227277,-5500.1149833617283,"",false},{9,0.39072751016342933,-8544.6292812514057,"",false},
 -- {10,1.3220077059699959,-4424.6808476751285,"",false},{11,0.38540636762751435,-4424.6808476751285,"",false},
 -- {12,1.3755310009280133,-5500.1149833617283,"",false},{13,1.2065804745244151,-4424.6808476751285,"",false},
 -- {14,0.20953376817391112,-5500.1149833617283,"",false}}
  
	-- Create a new list of active ScoreParts, then call
	-- GetScorePart_Score() to get each ScorePart's scores...
	local l_ActiveScorePartsScoreTable = {}  -- {1=ScorePart_Number, 2=ScorePart_Score}
	local l_ScorePart_Number, l_ScoreType, l_bScorePartIsActive, l_ScorePart_Score
  
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
	for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
		l_ScorePart_Name = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
		l_bScorePartIsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]

		if l_bScorePartIsActive == true then

			-- Here is where we are getting the actual score to save...
			l_ScorePart_Score = GetScorePart_Score(l_StartSegment, l_EndSegment, l_ScorePart_Name)
			l_ActiveScorePartsScoreTable[#l_ActiveScorePartsScoreTable + 1] = {l_ScorePart_Number, l_ScorePart_Score}
		end

	end

	local l_NewScorePart_Score, l_OldScorePart_Score
  
	local l_PoseTotalScore = GetPoseTotalScore()
  -- note 1: Several g_ScorePartScoresTable rows will have the same l_PoseTotalScore.

  -- Let's keep track of any ScorePart improvements. If there are improvements for
  -- a particular ScorePart, save the protein's pose for later regional shaking and wiggling...
	-- Update the global ScorePartScoresTable with each new ScorePart Score...
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
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
			g_ScorePartScoresTable[l_TableIndex][spst_PoseTotalScore] = l_PoseTotalScore
			save.Quicksave(l_ScorePart_Number) -- Save
		end
	end
  local debug = 1

end -- Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields()

-- Called from 1 place in RebuildManySegmentRanges()...
function Update_ScorePartScoresTable_ToDo_And_ScorePartsList_Fields()
	-- Create a list of all ScoreParts, grouped by matching PoseTotalScore values...
	-- For each ScorePartScoresTable row (or the first of a group of rows with matching 
  -- PoseTotalScore values),  set the bToDo flag to true...

	-- Create a list of all ScorePart_Numbers, grouped by matching PoseTotalScore values...
	-- It will look something like this 1=5=7 2=3=9 4 6=8...
	local l_OrganizedListOfAllScorePart_Numbers = ""

	-- Create a table with one row per g_ScorePartScoresTable row, and set each row's
	-- Done status to false. This way, when we look ahead in the g_ScorePartScoresTable for
	-- ScoreParts with a matching PoseTotalScore value, we can set those rows to Done, so we can
	-- skip them (because we will have already added them to the l_OrganizedListOfAllScorePart_Numbers)...
	local l_ScorePartScoresDoneStatusTable = {}
	for l_TableIndex = 1, #g_ScorePartScoresTable do
		l_ScorePartScoresDoneStatusTable[l_TableIndex] = false
	end

	-- Go through every row in the g_ScorePartScoresTable and look for other row's
	-- with a matching PoseTotalScore value...

	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
	for l_TableIndex = 1, #g_ScorePartScoresTable do

		-- Skip the ScoreParts which have already been accounted for in the inner loop below...
		if l_ScorePartScoresDoneStatusTable[l_TableIndex] == false then

			local l_CurrentScorePart_Number = g_ScorePartScoresTable[l_TableIndex][spst_ScorePart_Number]
			local l_CurrentPoseTotalScore = g_ScorePartScoresTable[l_TableIndex][spst_PoseTotalScore]

			-- Start creating a List of ScorePart_Numbers with matching PoseTotalScore values...
			-- Note: The l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue could end up with just a single
			-- ScorePart_Number if no other rows have a matching PoseTotalScore value. And this is okay...
			local l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue = l_CurrentScorePart_Number
      -- ...add first ScorePart_Number.

			-- For each ScorePartScoresTable row (or the first of a group of
			-- matching ScorePartScores rows), set the bToDo flag to true...
			g_ScorePartScoresTable[l_TableIndex][spst_bToDo] = true -- checked in RebuildManySegmentRanges()

			-- Now, for each row in g_ScorePartScoresTable, loop through the table
			-- a second time, (starting at the first row we have not yet look at),
			-- to find other rows with a matching PoseTotalScore value...
			for l_PotentialMatchIndex = l_TableIndex + 1, #g_ScorePartScoresTable do

				local l_PoseTotalScore = g_ScorePartScoresTable[l_PotentialMatchIndex][spst_PoseTotalScore]
				local l_ScorePart_Number = g_ScorePartScoresTable[l_PotentialMatchIndex][spst_ScorePart_Number]

				if l_PoseTotalScore == l_CurrentPoseTotalScore then
					-- Ah ha, we found another ScorePartScoresTable row with a matching PoseTotalScore value...

					-- Let's add this l_ScorePart_Number to the l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue...
					l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue =
						l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue .. "=" .. l_ScorePart_Number

					-- Since we will be adding this ScorePart_Number to the organized list of all
					-- ScorePart_Numbers below, will need to skip this ScorePart_Number in the outter loop;
					-- otherwise, we would end up with duplicates in our organized list...
					l_ScorePartScoresDoneStatusTable[l_PotentialMatchIndex] = true

				end
			end

			-- ScorePartsList examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
			g_ScorePartScoresTable[l_TableIndex][spst_ScorePartsList] =
        l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue

			l_OrganizedListOfAllScorePart_Numbers = l_OrganizedListOfAllScorePart_Numbers ..
				"\n  PoseTotalScore value: [" .. PrettyNumber(l_CurrentPoseTotalScore) .. "]" ..
				" ScorePart_Numbers: [" .. l_ListOfScorePart_NumbersWithMatchingPoseTotalScoreValue .."]"
		end

	end

	print("\n  List of all ScoreParts (grouped by matching PoseTotalScore value):\n" ..
		l_OrganizedListOfAllScorePart_Numbers)

end -- Update_ScorePartScoresTable_ToDo_And_ScorePartsList_Fields()

-- Called from 1 place in main()...
function CheckForLowStartingScore()
  -- Change defaults if the starting score is low (or negative)...
  local l_LowScore = 0 -- This was 4000, but why? Perhaps 4000 was a good low limit for ED puzzles.

	if g_BestScore >= l_LowScore then
		return -- score is high enough for now...
	end

	if g_bHasDensity == true then

		local l_DensitySubScore = CalculateSegmentRangeScore("density")
		local l_WeightedDensitySubScore = l_DensitySubScore  * (g_DensityWeight + 1)
		local l_ScoreWithoutElectronDensity = g_BestScore - l_WeightedDensitySubScore

		if l_ScoreWithoutElectronDensity > 4000 then
			print("\nThis is an electron density puzzle: Since the starting score of " ..
              PrettyNumber(l_ScoreWithoutElectronDensity) .. " is already greater than 4000 points" ..
             " (high enough without including Electron Density), we will keep the defaults" ..
             " options of: 'perform normal stabilization' and 'fuse best position'.")
			return
		end
	end

	print("\nSince the starting score of " .. PrettyNumber(g_BestScore) ..
         " is less than " .. l_LowScore .. " points, to speed things up, we will" ..
         " temporarily suspend normal stabilization and fusing best position, until" ..
         " the score increases above " .. l_LowScore .. " points.")
       -- The More Options page only provides a way to set these variables to false,
       -- which would do nothing in this case. So the following statement is not true...
       -- " However, these defaults can be changed on the More options page.")
	g_bFuseBestPosition = false
	g_bPerformNormalStabilization = false

end
-- ...end of ScoreParts and Scores module.

-- Start of Segment Ranges module...
-- Called from 1 place, at the end of CleanUp()...
function SelectSegmentRanges(l_SegmentRangesTable)

	-- This function is only used at the end of CleanUp()...
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

-- Called from 2 places in RebuildOneSegmentRangeManyTimes,
--             1 place in MutateOneSegmentRange, and
--             1 place in RebuildManySegmentRanges
function SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_Radius)

	selection.DeselectAll()

	for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do
		for l_InnerLoopSegmentIndex = l_StartSegment, l_EndSegment do
			if structure.GetDistance(l_InnerLoopSegmentIndex, l_SegmentIndex) < l_Radius then
				selection.Select(l_SegmentIndex)
				break
			end
		end
	end
end -- function SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_Radius)

-- Called from 1 place in RebuildManySegmentRanges()...
function PerformNormalStabilizationOnSegmentRange(l_StartSegment, l_EndSegment)

	-- Do not accept Stabilization losses...
	local l_FunctionStartPoseTotalScore = GetPoseTotalScore()
	
	-- As a precaution, let's save our current solution... If the next build
	-- decreases our score, then we will revert back to this solution...
	SaveCurrentSolutionToQuickSaveStack()
	
	SetClashImportance(0.1)
	local l_Iterations = 1
	local l_bShake_And_Wiggle_OnlySelectedSegments = true -- note, this is true this time...
	ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	
	if g_bMutateDuringNormalStabilization == true then
		SetClashImportance(1)
		MutateOneSegmentRange(l_StartSegment, l_EndSegment)
	end
	
	if g_bPerformExtraStabilization == true then -- default is false
		SetClashImportance(0.4)
		l_bShake_And_Wiggle_OnlySelectedSegments = false -- and it's false this time...
		ShakeAndOrWiggle("WiggleAll", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
		SetClashImportance(1)
		-- Note the third parameter uses the global value instead of the local value here...
		ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, g_bShake_And_Wiggle_OnlySelectedSegments)
	end
	
	SetClashImportance(1)
	
	recentbest.Save() -- Save the current pose as the recentbest pose.  
	l_Iterations = 3
	l_bShake_And_Wiggle_OnlySelectedSegments = false -- and it's false this time, too...
	ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
	recentbest.Restore()-- Keep the current pose if it's better; otherwise, restore the recentbest pose.
	
	local l_CheckPoseTotalScore = GetPoseTotalScore()
	if l_CheckPoseTotalScore < l_FunctionStartPoseTotalScore then
		-- This build was a failure, so load the last saved solution from the Quicksave stack...
		LoadLastSavedSolutionFromQuickSaveStack()
	else
		-- Keep the current solution and remove the last saved solution from the Quicksave stack...
		RemoveLastSavedSolutionFromQuickSaveStack()
	end
	
end -- function PerformNormalStabilizationOnSegmentRange(l_StartSegment, l_EndSegment)

-- Called from 1 place in Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()...
function Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)

	-- Add mulitple loop segments in a SegmentRange to the g_SegmentRangesToRebuildTable...

	local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)
	local l_EndSegment = l_StartSegment
	for l_SegmentIndex = l_StartSegment + 1, g_SegmentCountWithoutLigands do
		local l_SecondaryStructureTypeNext = structure.GetSecondaryStructure(l_SegmentIndex)
		if l_SecondaryStructureTypeNext == l_SecondaryStructureTypeStart then
			l_EndSegment = l_SegmentIndex
		else
			break
		end
	end

	-- Script defaults:
	-- g_StartProcessingWithThisManyConsecutiveSegments = 2
	-- g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4
	local l_RequiredNumberOfConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Add one row to the g_SegmentRangesToRebuildTable...
	if l_RequiredNumberOfConsecutiveSegments >= g_StartProcessingWithThisManyConsecutiveSegments then

		if g_bRebuildLoopsOnly == true then
			-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
			g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
		end
	end
	return l_EndSegment

end -- Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)

-- Called from 1 place in Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()...
function Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)

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
	if l_EndSegment < g_SegmentCountWithoutLigands - 1 then

		local l_bChange = false -- Start off assuming we are still looking at the same segment types...

		repeat
			-- Search forward for the last segment with the same segment type as the passed in segment...
			l_EndSegment = l_EndSegment + 1
			if l_EndSegment == g_SegmentCountWithoutLigands then
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
		if l_EndSegment < g_SegmentCountWithoutLigands then
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
	-- g_StartProcessingWithThisManyConsecutiveSegments = 2
	-- g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4
	local l_NumberofConsecutiveSegments = l_EndSegment - l_StartSegment + 1

	-- Make sure this segment range contains the minimum number of consecutive segments
	-- as require by the user. If not, we will just skip processing this segment range,
	-- and continue to look for segment ranges with enough segments as required...
	-- If we allowed segment ranges with less than the required minimum, we might end up
	-- rebuilding segment ranges of a single segment, which and that would not be efficient or practical...
	if l_NumberofConsecutiveSegments >= g_StartProcessingWithThisManyConsecutiveSegments then
		-- Not sure why we are using g_StartProcessingWithThisManyConsecutiveSegments here
		-- instead of g_RequiredNumberOfConsecutiveSegments. Things that make you go hmmm.
		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}

		-- Add one row to the g_SegmentRangesToRebuildTable...
		g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
	end
	return l_EndSegment

end -- Add_Loop_Plus_One_Other_Type_SegmentRange_To_SegmentRangesTable(l_StartSegment)

-- Called from 1 place in PrepareToRebuildSegmentRanges() when l_How = 'segments'
function Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()

	if g_bRebuildLoopsOnly then
		local l_bDone = false
		local l_StartSegment = 0
		repeat -- loop segments
			l_StartSegment = l_StartSegment + 1
			local l_SecondaryStructureTypeStart = structure.GetSecondaryStructure(l_StartSegment)
			if l_SecondaryStructureTypeStart == "L" then -- only loop segments here, see below for other
				l_StartSegment = Add_Loop_SegmentRange_To_SegmentRangesTable(l_StartSegment)
			end
			if l_StartSegment == g_SegmentCountWithoutLigands then
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
			if l_StartSegment == g_SegmentCountWithoutLigands then
				-- We hit the end of the non-ligand segments, time to bail out...
				l_bDone = true
			end
		until l_bDone == true
	end

end -- Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()

-- Called from 3 places in RebuildManySegmentRanges(),
--             1 place in RebuildOneSegmentRangeManyTimes() and
--             1 place in PerformNormalStabilization()...
function MutateOneSegmentRange(l_StartSegment, l_EndSegment)

	if g_bProteinHasMutableSegments == false then
		return
	end

	-- Do not accept loss if mutating...
	local l_FunctionStartPoseTotalScore = g_BestScore
	-- Save the current solution. If our score goes down after mutating
	-- this segment, then we will restore to this solution...
	SaveCurrentSolutionToQuickSaveStack()
	
	SetClashImportance(g_MutateClashImportance)
	RememberSolutionWithDisulfideBondsIntact()

	local l_MaxIterations = 2

	-- Rebuild (mutate) what user selected to do...
	if g_bMutateOnlySelectedSegments == true then

		selection.DeselectAll()
		selection.SelectRange(l_StartSegment, l_EndSegment)
		structure.MutateSidechainsSelected(l_MaxIterations)

	elseif g_bMutateSelectedAndNearbySegments == true then

		SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, g_MutateSphereRadius)
		structure.MutateSidechainsSelected(l_MaxIterations)

	else

		selection.SelectAll()
		structure.MutateSidechainsSelected(l_MaxIterations)

	end

	CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
	local l_CheckPoseTotalScore = GetPoseTotalScore()
	if l_CheckPoseTotalScore < l_FunctionStartPoseTotalScore then   
		
		LoadLastSavedSolutionFromQuickSaveStack()
	else
		RemoveLastSavedSolutionFromQuickSaveStack()
	end

end -- MutateOneSegmentRange()

-- ...end of Segment Ranges module.

-- Start of Ask and Display Options module...
-- Called from 1 place in main()...
function DisplaySelectedOptions()

	print("\nSelected Options:\n")

	-- Script defaults:
	-- g_StartProcessingWithThisManyConsecutiveSegments = 2
	-- g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4

	--print("  Start Processing With This Many Consecutive Segments: [" ..
	--	g_StartProcessingWithThisManyConsecutiveSegments .. "]")
	--print("  Stop After Processing With This Many Consecutive Segments: [" ..
	--	g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments .. "]")

	print("  Segments to work on: [" ..
		ConvertSegmentRangesTableToListOfSegmentRanges(g_SegmentRangesToRebuildTable) .. "]")

	--print("  Number of rebuild-one-segment-range attempts per run cycle: [" ..
	--	g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle .. "]")

	if g_WiggleFactor > 1 then
		print("  Wiggle factor: " .. g_WiggleFactor .. "")
	end

	if g_bConvertAllSegmentsToLoops == true then
		print("  Converting all segments to loops...")
	end

	if g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments == true then
		print("  Shake and Wiggle (with SideChains and Backbone)" ..
           " with selected and nearby segments after each rebuild" ..
          " (with clash importance = 1.0)")
	elseif g_bShake_And_Wiggle_WithSelectedSegments == true then
		print("  Shake and Wiggle selected segments after each rebuild" ..
          " (with clash importance: " .. g_ShakeClashImportance .. ")")
	end

	if g_bPerformNormalStabilization == false then
    print("  Skip normal stabilization. Instead, perform local shake.")
	end
	if g_bFuseBestPosition == true then
		print("  Fuse best position of each segment range is Enabled.")
	end

	-- print("  Number of full run cycles: " .. g_NumberOfRunCycles .. "")

	if g_NumberOfSegmentsSkipping > 0 then
		print("  Skip " .. g_NumberOfSegmentsSkipping .. " worst segment parts.")
	end

	if g_bAlwaysAllowRebuildingAlreadyRebuiltSegments == true then
		print("  We will always allow rebuilding already rebuilt segments")
	else
		print("  We will only allow rebuilding already rebuilt segments" ..
					 " if current rebuild points gained is more than: " ..
             g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan .. "")
	end

end -- DisplaySelectedOptions()

-- Called from 1 place in main()...
function DisplayPuzzleProperties()

	print("\nPuzzle properties...\n")

	print("  Puzzle name: " .. puzzle.GetName() .. "")
	print("  Puzzle ID: " .. puzzle.GetPuzzleID() .. "")
	-- print("  Puzzle description: [" .. puzzle.GetDescription() .. "]")

	print("  Protein has " .. g_SegmentCountWithoutLigands .. " segments.")
	
	-- Find out if the puzzle has mutables
	local l_MutablesList
	local l_NumberOfMutableSegments
	l_NumberOfMutableSegments = GetNumberOfMutableSegments()

	if g_bProteinHasMutableSegments == true then
  print("  Protein has " .. l_NumberOfMutableSegments .. " mutable segments.")
	end

	local l_HalfOfTheProteinSegments
	l_HalfOfTheProteinSegments = g_SegmentCountWithoutLigands / 2
	if l_NumberOfMutableSegments > l_HalfOfTheProteinSegments then
		g_bFreeDesignPuzzle = true
		print("  Since more than half of the protein's segments are mutable, " ..
             l_NumberOfMutableSegments .." of " .. g_SegmentCountWithoutLigands ..
          ", this is considered a design puzzle.")
	end

	-- Find out if the puzzle has any disulfide bonds...
	PopulateGlobalCysteinesTable()
	if #g_CysteineSegmentsTable > 1 then
		print("  Puzzle has " .. #g_CysteineSegmentsTable .. " cysteine segments.")
		if g_OriginalNumberOfDisulfideBonds > 0 then
			print("  Puzzle has " .. g_OriginalNumberOfDisulfideBonds .. " disulfide bonds.")
			g_bUserWantsToKeepDisulfideBondsIntact = true -- so much for the user deciding...
		end
	end

	local l_SegmentTotal = CalculateSegmentRangeScore(nil, 1, g_SegmentCountWithLigands)
	-- print("l_SegmentTotal=[" .. l_SegmentTotal .. "]")

	-- Find out if the puzzle has Density scores and their weight if any...
	local l_DensityTotal = CalculateSegmentRangeScore("density")
	-- print("l_DensityTotal=[" .. l_DensityTotal .. "]")

	g_bHasDensity = math.abs(l_DensityTotal) > 0.0001
	-- print("g_bHasDensity=[" .. tostring(g_bHasDensity) .. "]")

	if g_bHasDensity == true then
    -- How was this formula derived? What if g_BestScore is negative?
    if g_BestScore > 0 then
      g_DensityWeight = 
        (g_BestScore - g_ComputedMaximumPotentialBonusPoints - l_SegmentTotal - 8000) / l_DensityTotal
    end
		print("  Puzzle has Density scores. The density weight = " .. PrettyNumber(g_DensityWeight) .. " points")
	end

	-- Check if this is likely a symmetry puzzle...
	if g_bHasDensity == false then		
		local l_ComputedScore = math.abs(g_BestScore - l_SegmentTotal - 8000) -- why?
		-- print("PoseTotalScore: " .. PrettyNumber(g_BestScore) .. 
    --      " ComputedScore: " .. PrettyNumber(l_ComputedScore) .. "")
		g_bProbableSymmetryPuzzle = l_ComputedScore > 2
		if g_bProbableSymmetryPuzzle == true then
			print("  Puzzle is a symmetry puzzle or has bonuses")
		end
	end

  print("  Starting score: " .. PrettyNumber(g_BestScore))

end -- DisplayPuzzleProperties()

-- called from 1 place in bAskUserToSelectRebuildOptions()...
function AskMoreOptions()

	local l_Ask = dialog.CreateDialog("More Options")

	l_Ask.l_0 = dialog.AddLabel("Perform Extra Stabilization (shake and wiggle more)")
	l_Ask.bPerformExtraStabilization =
		dialog.AddCheckbox("Extra", g_bPerformExtraStabilization) -- default is false

	l_Ask.l_1 = dialog.AddLabel("Move on to more consecutive segments per")
	l_Ask.l_2 = dialog.AddLabel("range if current rebuild gains more than:")
	l_Ask.MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan =
		dialog.AddSlider("  Points:",
			g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan, 0, 500, 0) -- default is 40 or less

	l_Ask.l_3 = dialog.AddLabel("Skip fusing best position if current rebuild loss is")
	l_Ask.l_4 = dialog.AddLabel("greater than (Points * # of segments per range / 3):")
	l_Ask.SkipFusingBestPositionIfLossIsGreaterThan = 
		dialog.AddSlider("  Points:", g_SkipFusingBestPositionIfLossIsGreaterThan, -5, 200, 0)

	l_Ask.l_7 = dialog.AddLabel("Only allow rebuilding already rebuilt segments")
	l_Ask.l_9 = dialog.AddLabel("if current rebuild points gained is more than:")
	l_Ask.OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan =
		dialog.AddSlider("  Points:",
			g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan, 0, 500, 0) 
      -- ...default depends on number of segments

	l_Ask.l_10 = dialog.AddLabel("Number of times to rebuild a single segment range")
	l_Ask.l_11 = dialog.AddLabel("per run cycle:") -- default is 15 (or 10)
	l_Ask.NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle =
		dialog.AddSlider("  Rebuilds:", g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle, 1, 100, 0)

	l_Ask.l_12 = dialog.AddLabel("Starting number of segment ranges to rebuild per")
	l_Ask.l_13 = dialog.AddLabel("run cycle:")
	l_Ask.StartingNumberOfSegmentRangesToProcessPerRunCycle =
		dialog.AddSlider("  Ranges / cycle:",
			g_StartingNumberOfSegmentRangesToProcessPerRunCycle, 1, g_SegmentCountWithoutLigands, 0)

	l_Ask.l_14 = dialog.AddLabel("Additional number of segment ranges to rebuild per")
	l_Ask.l_15 = dialog.AddLabel("run cycle to add after each run cycle completes:")
	l_Ask.AdditionalNumberOfSegmentRangesToProcessPerRunCycle =
		dialog.AddSlider("  Add ranges:",
			g_AdditionalNumberOfSegmentRangesToProcessPerRunCycle, 0, 4, 0)

	l_Ask.l_16 = dialog.AddLabel("Shake and Wiggle (with SideChains and Backbone)")
	l_Ask.l_17 = dialog.AddLabel("with selected and nearby segments after each rebuild")
	l_Ask.l_18 = dialog.AddLabel("(with clash importance: 1)")
	l_Ask.Shake_And_WiggleWithSideChainsAndBackbone_WithSelectedAndNearbySegments =
		dialog.AddCheckbox("Very SLOW!",
			g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments)
		
	l_Ask.l_19 = dialog.AddLabel("Shake and Wiggle with selected segments after")
	l_Ask.l_20 = dialog.AddLabel("each rebuild.")
	l_Ask.Shake_And_Wiggle_WithSelectedSegments = 
		dialog.AddCheckbox("Not too slow", g_bShake_And_Wiggle_WithSelectedSegments)

	l_Ask.l_21 = dialog.AddLabel("... with clash importance:")
	l_Ask.shakeClashImportance = dialog.AddSlider(" CI:", g_ShakeClashImportance, 0, 1, 2)
	
	l_Ask.l_22 = dialog.AddLabel("Perform normal stabilization instead of local shake")
	l_Ask.l_23 = dialog.AddLabel("only:")
	l_Ask.bPerformNormalStabilization =	dialog.AddCheckbox("Normal", g_bPerformNormalStabilization)
	l_Ask.bFuseBestPosition = dialog.AddCheckbox("Fuse best position", g_bFuseBestPosition)
	
	l_Ask.OK = dialog.AddButton("OK", 1)
	dialog.Show(l_Ask)

	g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan =
		l_Ask.MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan.value -- default is 40 or less
	g_OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan =
    l_Ask.OnlyAllowRebuildingAlreadyRebuiltSegmentsIfCurrentRebuildPointsGainedIsMoreThan.value

	g_bPerformExtraStabilization = l_Ask.bPerformExtraStabilization.value -- default is false
	g_SkipFusingBestPositionIfLossIsGreaterThan = l_Ask.SkipFusingBestPositionIfLossIsGreaterThan.value

	g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle =
		l_Ask.NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle.value

	g_StartingNumberOfSegmentRangesToProcessPerRunCycle =
		l_Ask.StartingNumberOfSegmentRangesToProcessPerRunCycle.value
	g_AdditionalNumberOfSegmentRangesToProcessPerRunCycle =
		l_Ask.AdditionalNumberOfSegmentRangesToProcessPerRunCycle.value
	
	g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments =
		l_Ask.Shake_And_WiggleWithSideChainsAndBackbone_WithSelectedAndNearbySegments.value
	g_bShake_And_Wiggle_WithSelectedSegments = l_Ask.Shake_And_Wiggle_WithSelectedSegments.value
	
	g_ShakeClashImportance = l_Ask.shakeClashImportance.value
	g_bPerformNormalStabilization = l_Ask.bPerformNormalStabilization.value
  
	g_bFuseBestPosition = l_Ask.bFuseBestPosition.value

end -- AskMoreOptions()

-- Called from 1 place in bAskUserToSelectRebuildOptions()...
function AskUserForMutateOptions()

	local l_Ask = dialog.CreateDialog("Mutate Options")
	
	l_Ask.l1 = dialog.AddLabel("Mutate after rebuild:")
	l_Ask.bMutateAfterRebuild = dialog.AddCheckbox("After rebuild", g_bMutateAfterRebuild)
	
	l_Ask.l2 = dialog.AddLabel("Mutate during normal stabilization:")
	l_Ask.bMutateDuringNormalStabilization =
		dialog.AddCheckbox("During stabilization", g_bMutateDuringNormalStabilization)
		
	l_Ask.l3 = dialog.AddLabel("Mutate after normal stabilization:")
	l_Ask.bMutateAfterNormalStabilization =
		dialog.AddCheckbox("After stabilization", g_bMutateAfterNormalStabilization)
		
	l_Ask.l4 = dialog.AddLabel("Mutate before fuse best position:")
	l_Ask.bMutateBeforeFuseBestPosition = dialog.AddCheckbox("Before fuse", g_bMutateBeforeFuseBestPosition)
	
	l_Ask.l5 = dialog.AddLabel("Mutate after fuse best position:")
	l_Ask.bMutateAfterFuseBestPosition = dialog.AddCheckbox("After fuse", g_bMutateAfterFuseBestPosition)

	l_Ask.l6 = dialog.AddLabel("What to rebuild. Second option overrides first. ")
	l_Ask.l6b = dialog.AddLabel("If neither option is checked then rebuild all segments.")
	l_Ask.bMutateOnlySelectedSegments =
		dialog.AddCheckbox("Only the selected segments", g_bMutateOnlySelectedSegments)
	l_Ask.bMutateSelectedAndNearbySegments =
		dialog.AddCheckbox("The selected and nearby segments", g_bMutateSelectedAndNearbySegments)
	l_Ask.l7 =
		dialog.AddLabel("Mutate sphere radius, Angstroms, for nearby segments")
	l_Ask.MutateSphereSize =
		dialog.AddSlider("  Sphere Radius:", g_MutateSphereRadius, 3, 15, 0) -- default is 8 Angstroms
	l_Ask.MutateClashImportance =
		dialog.AddSlider("  Clash Importance:", g_MutateClashImportance, 0.1, 1, 2)

	l_Ask.OK = dialog.AddButton("OK", 1) l_Ask.Cancel = dialog.AddButton("Cancel", 0)
	if dialog.Show(l_Ask) > 0 then
		g_bMutateAfterRebuild = l_Ask.bMutateAfterRebuild.value
		g_bMutateDuringNormalStabilization = l_Ask.bMutateDuringNormalStabilization.value
		g_bMutateAfterNormalStabilization = l_Ask.bMutateAfterNormalStabilization.value
		g_bMutateBeforeFuseBestPosition = l_Ask.bMutateBeforeFuseBestPosition.value
		g_bMutateAfterFuseBestPosition = l_Ask.bMutateAfterFuseBestPosition.value
		g_bMutateOnlySelectedSegments = l_Ask.bMutateOnlySelectedSegments.value
		g_bMutateSelectedAndNearbySegments = l_Ask.bMutateSelectedAndNearbySegments.value
		if g_bMutateSelectedAndNearbySegments == true then
			-- The MutateSelectedAndNearbySegments option overrides the bMutateOnlySelectedSegments option...
			g_bMutateOnlySelectedSegments = false
		end
		g_MutateSphereRadius = l_Ask.MutateSphereSize.value
		g_MutateClashImportance = l_Ask.MutateClashImportance.value

	end

end -- AskUserForMutateOptions()

-- Called from 1 place in bAskUserToSelectRebuildOptions()...
function AskUserToSelectScorePartsToStabilize()

	local l_title = "Select ScoreParts to Stabilize"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("After rebuilding each segment range several times,")
  l_Ask.l2 = dialog.AddLabel("select the best scoring poses of each of the below")
  l_Ask.l3 = dialog.AddLabel("selected ScoreParts to Stabilize (shake and wiggle")
  l_Ask.l4 = dialog.AddLabel("regionally) to look for more score gains:")
	local l_ScorePart_Number, l_ScorePart_Name, l_bScorePartIsActive

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
	for l_TableIndex = 1, #g_ScorePartsTable do
		l_ScorePart_Number = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Number]
		l_ScorePart_Name = g_ScorePartsTable[l_TableIndex][spt_ScorePart_Name]
		l_bScorePartIsActive = g_ScorePartsTable[l_TableIndex][spt_bScorePartIsActive]
    
    if l_ScorePart_Name == "loctotal" or
       l_ScorePart_Name == 'Backbone' or
       l_ScorePart_Name == 'Hiding' or
       l_ScorePart_Name == 'Packing' then
       l_ScorePart_Name = l_ScorePart_Name .. "*"
    end    
   
		l_Ask[l_ScorePart_Name] =
			dialog.AddCheckbox(l_ScorePart_Number .. " " .. l_ScorePart_Name, l_bScorePartIsActive)
    
	end
	l_Ask.l5 = dialog.AddLabel("* astericks indicates one of the top 4 scoring parts")

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

end -- AskUserToSelectScorePartsToStabilize()

-- Called from 1 place in bAskUserToSelectRebuildOptions()...
function AskUserToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments()

  local l_title = "Calculating worst scoring segments"

	local l_Ask = dialog.CreateDialog(l_title)
	l_Ask.l1 = dialog.AddLabel("Select ScoreParts to include when calculating worst")
	l_Ask.l2 = dialog.AddLabel("scoring segments:")
	local l_ScorePart_Name

	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
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
	l_Ask.l3 = dialog.AddLabel("* astericks indicates one of the top 4 scoring parts")

	l_Ask.OK = dialog.AddButton("OK", 1)
	l_Ask.Cancel = dialog.AddButton("Cancel", 0)
	g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table = {}

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
        local l_TableCount = #g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table
				g_UserSelectedScorePartsToIncludeWhenCalculatingWorseScoringSegments_Table[l_TableCount + 1] =
					string.gsub(l_ScorePart_Name, "*", "")
          
          print("l_ScorePart_Name without asterisk:" .. l_ScorePart_Name)
			end

		end

	end

end -- AskUserToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments()

-- Called from 1 place in bAskUserToSelectRebuildOptions()...
function AskUserToSelectSegmentsToRebuild()

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
							l_SegmentsTable[l_SegmentIndex] > g_SegmentCountWithLigands then
							--l_SegmentsTable[l_SegmentIndex] > structure.GetCount() then
							print("Segment number " .. l_SegmentsTable[l_SegmentIndex] ..
								" is not a valid segment number")
							return false
						end
					end

					return true
				end

				local function ConvertListOfSegmentRangesToSegmentRangesTable(l_ListOfSegmentRanges)

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
					ConvertListOfSegmentRangesToSegmentRangesTable(l_ListOfSegmentRanges)

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

end -- AskUserToSelectSegmentsToRebuild()

-- Called from 1 place in main()...
function bAskUserToSelectRebuildOptions()

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
		l_Ask.MinimunWorstSegmentOffset =
			dialog.AddSlider("  Starting with:",
				g_StartProcessingWithThisManyConsecutiveSegments, 1, 10, 0)
		l_Ask.MaximunWorstSegmentOffset =
			dialog.AddSlider("  Continue thru:",
				g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments, 1, 10, 0)

		if g_bSketchBookPuzzle == true then
			l_Ask.L2 = dialog.AddLabel("For a sketch book puzzle:")
			l_Ask.L3 = dialog.AddLabel("Save the current position if the")
			l_Ask.L4 = dialog.AddLabel("current rebuild gain is more than:")
			l_Ask.SketchBookPuzzleMinimumGainForSave =
				dialog.AddSlider("  Points:",
					g_SketchBookPuzzleMinimumGainForSave, 0, 100, 0)
		end

		l_Ask.L5 = dialog.AddLabel("Wiggle more when Clash Importance is maximum:")
		l_Ask.g_WiggleFactor = dialog.AddSlider("  WiggleFactor:", g_WiggleFactor, 1, 5, 0)

		l_Ask.L6 = dialog.AddLabel("Select ScoreParts to stabilize, last choice overrides:")
		l_Ask.bSelectAllScorePartsToStabilize =
      dialog.AddCheckbox("Select all ScoreParts", g_bSelectAllScorePartsToStabilize)
		l_Ask.bSelectMain4ScorePartsToStabilize =
			dialog.AddCheckbox("Select the top 4 scoring ScoreParts (faster)", g_bSelectMain4ScorePartsToStabilize)
		l_Ask.bSelectScorePartsToStabilize =
      dialog.AddCheckbox("Manully select ScoreParts from a list...", false)

		l_Ask.L7 = dialog.AddLabel("Maximum number of full cycles to run:")
		l_Ask.NumberOfRunCycles = dialog.AddSlider("  Run cycles:", g_NumberOfRunCycles, 1, 40, 0)

		l_Ask.L8 = dialog.AddLabel("Skip the first X number of segments (crash resume)")
		l_Ask.NumberOfSegmentsToSkip = dialog.AddSlider("  X segments:",
				g_NumberOfSegmentsSkipping, 0, g_SegmentCountWithoutLigands, 0)

		l_Ask.bUserWantsToSelectSegmentsToRebuild =
			dialog.AddCheckbox("Select Segments to Rebuild...", l_bUserWantsToSelectSegmentsToRebuild)

		if g_bProteinHasMutableSegments == true then
			l_Ask.bUserWantsToSelectMutateOptions =
				dialog.AddCheckbox("Select Mutate Options...", l_bUserWantsToSelectMutateOptions)
		end

		l_Ask.bShake_And_Wiggle_OnlySelectedSegments =
			dialog.AddCheckbox("Shake and Wiggle only selected segments",
			g_bShake_And_Wiggle_OnlySelectedSegments)

		l_Ask.L81 = dialog.AddLabel("Select ScoreParts to include when calculating worst")
		l_Ask.L82 = dialog.AddLabel("scoring segments:")
		l_Ask.bUserWantsToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments =
			dialog.AddCheckbox("Select worst scoring ScoreParts...", false)
      
		if g_OriginalNumberOfDisulfideBonds > 1 then
			l_Ask.bUserWantsToKeepDisulfideBondsIntact = 
				dialog.AddCheckbox("Keep sulfide bonds intact", g_bUserWantsToKeepDisulfideBondsIntact)
		end

		l_Ask.bConvertAllSegmentsToLoops =
			dialog.AddCheckbox("Convert all segments to loops", g_bConvertAllSegmentsToLoops)

		l_Ask.L9 = dialog.AddLabel("Always allow rebuilding already rebuilt segments:")
		l_Ask.bAlwaysAllowRebuildingAlreadyRebuiltSegments = dialog.AddCheckbox("Always allow",
			g_bAlwaysAllowRebuildingAlreadyRebuiltSegments)

		l_Ask.bDisableBandsDuringRebuild =
			dialog.AddCheckbox("Disable bands during rebuild", g_bDisableBandsDuringRebuild)

		l_Ask.AskResult1 = dialog.AddButton("OK", 1)
		l_Ask.AskResult0 = dialog.AddButton("Cancel", 0)
		l_Ask.AskResult2 = dialog.AddButton("More options", 2)

		l_AskResult = dialog.Show(l_Ask)
		if l_AskResult > 0 then -- 0 = Cancel

			g_StartProcessingWithThisManyConsecutiveSegments = l_Ask.MinimunWorstSegmentOffset.value
			g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = l_Ask.MaximunWorstSegmentOffset.value

			g_NumberOfRunCycles = l_Ask.NumberOfRunCycles.value

			g_NumberOfSegmentsSkipping = l_Ask.NumberOfSegmentsToSkip.value
			g_bDisableBandsDuringRebuild = l_Ask.bDisableBandsDuringRebuild.value
			g_bAlwaysAllowRebuildingAlreadyRebuiltSegments =
        l_Ask.bAlwaysAllowRebuildingAlreadyRebuiltSegments.value

			g_bConvertAllSegmentsToLoops = l_Ask.bConvertAllSegmentsToLoops.value

			if g_bSketchBookPuzzle == true then
				g_SketchBookPuzzleMinimumGainForSave = 
					ask.SketchBookPuzzleMinimumGainForSave.value
			end

			g_WiggleFactor = l_Ask.g_WiggleFactor.value

			local spt_bScorePartIsActive = 3

			-- Check for changes to included/selected (activated) ScoreParts (slots)...
			local l_bIncluded_WorstScoreParts_HasChanged = false

			if g_bSelectAllScorePartsToStabilize ~= l_Ask.bSelectAllScorePartsToStabilize.value then

				g_bSelectAllScorePartsToStabilize = l_Ask.bSelectAllScorePartsToStabilize.value

				l_bIncluded_WorstScoreParts_HasChanged = true

				if g_bSelectAllScorePartsToStabilize == true then
					-- User chose to include all ScoreParts (slots)...

					-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
					for l_ScorePartsTableIndex=1, #g_ScorePartsTable do
						-- Update the g_ScorePartsTable...
						g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive] = true
					end
				end
			end

			if g_bSelectMain4ScorePartsToStabilize ~= l_Ask.bSelectMain4ScorePartsToStabilize.value then

				g_bSelectMain4ScorePartsToStabilize = l_Ask.bSelectMain4ScorePartsToStabilize.value

				l_bIncluded_WorstScoreParts_HasChanged = true

				if g_bSelectMain4ScorePartsToStabilize == true then

					-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
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
				AskUserToSelectScorePartsToStabilize() -- perhaps return l_bIncluded_WorstScoreParts_HasChanged
				l_bIncluded_WorstScoreParts_HasChanged = true
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
			end

			if l_Ask.bUserWantsToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments.value == true then
        
				AskUserToSelectScorePartsToIncludeWhenCalculatingWorseScoringSegments()
        -- ...perhaps should return l_bIncluded_WorstScoreParts_HasChanged.
				l_bIncluded_WorstScoreParts_HasChanged = true
				if l_AskResult == 1 then -- 1 = OK
					l_AskResult = 4 -- 4 = Go back to top menu
				end
			end

			if l_bIncluded_WorstScoreParts_HasChanged == true then

				print("\nUser has selected the following ScoreParts to include when calculating worse scoring segments:")

				local l_bScorePartIsActive, l_ScorePart_Number, l_ScorePart_Name

				-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
				for l_ScorePartsTableIndex = 1, #g_ScorePartsTable do
					l_ScorePart_Number = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Number]
					l_ScorePart_Name = g_ScorePartsTable[l_ScorePartsTableIndex][spt_ScorePart_Name]
					l_bScorePartIsActive = g_ScorePartsTable[l_ScorePartsTableIndex][spt_bScorePartIsActive]
					if l_bScorePartIsActive == true then
						print("  Active ScorePart ".. l_ScorePart_Number .." (".. l_ScorePart_Name .. ")")
					end
				end

			end

			l_bUserWantsToSelectSegmentsToRebuild = l_Ask.bUserWantsToSelectSegmentsToRebuild.value

			if l_bUserWantsToSelectSegmentsToRebuild == true then

				g_bSelectMain4ScorePartsToStabilize = false
				g_bSelectAllScorePartsToStabilize = false

				-- l_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
				local l_SegmentRangesToRebuildTable = {}
				l_SegmentRangesToRebuildTable = AskUserToSelectSegmentsToRebuild()
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

				if l_Ask.bUserWantsToSelectMutateOptions.value == true then
					AskUserForMutateOptions()

				print("\nSelected Mutate Options:\n")

					local l_Message = "  When to Mutate:"
					if g_bMutateAfterRebuild == true then l_Message = l_Message .. " [after each rebuild]" end
					if g_bMutateDuringNormalStabilization == true then
						l_Message = l_Message .. " [during normal stabilization]" end
					if g_bMutateAfterNormalStabilization == true then
						l_Message = l_Message .. " [after normal stabilization]" end
					if g_bMutateBeforeFuseBestPosition == true then
						l_Message = l_Message .. " [before fusing best position]" end
					if g_bMutateAfterFuseBestPosition == true then
						l_Message = l_Message .. " [after fusing best position]" end
					print(l_Message)

					l_Message = "  Mutate area: "
					if g_bMutateOnlySelectedSegments == true then
						l_Message = l_Message .. "Only the selected segments."
					elseif g_bMutateSelectedAndNearbySegments == true then
						l_Message = l_Message .. "The selected and near by segments within a radius of [" ..
							g_MutateSphereRadius .. "] Angstroms."
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

			g_bShake_And_Wiggle_OnlySelectedSegments = l_Ask.bShake_And_Wiggle_OnlySelectedSegments.value

			if g_OriginalNumberOfDisulfideBonds > 1 then
				g_bUserWantsToKeepDisulfideBondsIntact = l_Ask.bUserWantsToKeepDisulfideBondsIntact.value
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

end -- bAskUserToSelectRebuildOptions()
-- ...end of Ask and Display Options module.

-- Start of Core Rebuild Functions module...

-- Called from 1 place in RebuildManySegmentRanges()...
function DisplaySegmentRanges()

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

		--if l_SegmentIndex ~= l_MaxNumberOfSegmentRangesToDisplay then
		--	-- If we are not at the end of the table, add a space...
		--	l_ListOfSegmentRanges = l_ListOfSegmentRanges .. " "
		--end

	end

	print("\nRebuilding the following " .. #g_SegmentRangesToRebuildTable .. " worst scoring segment ranges:" ..
		" [" .. l_ListOfSegmentRanges .. "]")

end -- DisplaySegmentRanges()


-- Called from 1 place in RebuildOneSegmentRangeManyTimes()...
function RebuildSelectedSegments()

	local l_MaxIterations = 3

  local l_BestScoreBeforeRebuild = 0
  local l_PointsGainedFromRebuild = 0
  
  local l_NumberOfTimesBondsHaveBroken = 0
  local l_bBrokenBond = false
  
	if g_bDisableBandsDuringRebuild == true then
		band.DisableAll() -- will re-enable after rebuild.
	end

	RememberSolutionWithDisulfideBondsIntact()

  for l_CurrentIteration = 1, l_MaxIterations do
   
    l_BestScoreBeforeRebuild = g_BestScore
   
		-- This is what you are looking for...
		-- This is what you are looking for...
    
		structure.RebuildSelected(l_CurrentIteration)
    
		-- This is what you are looking for...
		-- This is what you are looking for...
	 
    l_PointsGainedFromRebuild = GetPoseTotalScore() - l_BestScoreBeforeRebuild
   
    if l_PointsGainedFromRebuild > -20 then -- not sure what value to place here yet, if any.
      
      l_bBrokenBond = bOneOrMoreDisulfideBondsHaveBroken()
      
			if l_bBrokenBond == true then
        
        -- We never check the value of l_NumberOfTimesBondsHaveBroken, so the next
        -- line just provides a good place to set a breakpoint in the debuugger...
				l_NumberOfTimesBondsHaveBroken = l_NumberOfTimesBondsHaveBroken + 1 
				-- Try up to 3 times to succeed without breaking disulfide bonds...
				--if l_NumberOfTimesBondsHaveBroken >= 3 then
        --  break <-- this is already accounted for with the for loop.
        --end
			else
				-- Yay, our score changed. I hope it increased instead of decreased.
        -- Even if the score decreased a little, there still might be a 
        -- net gain after a shake and a wiggle...
				break -- for l_CurrentIteration = 1, l_MaxIterations do
        
			end -- if bOneOrMoreDisulfideBondsHaveBroken() == true then
      
		end -- if l_PointsGainedFromRebuild > -20 then 
    
  end -- for l_CurrentIteration = 1, l_MaxIterations do

	CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()

	if g_bDisableBandsDuringRebuild == true then
		band.EnableAll()
	end
  
	return

end -- RebuildSelectedSegments()

-- Called from 1 place in RebuildManySegmentRanges()..
function RebuildOneSegmentRangeManyTimes(l_StartSegment, l_EndSegment)

	PopulateGlobalScorePartScoresTable()

	if l_StartSegment > l_EndSegment then
		l_StartSegment, l_EndSegment = l_EndSegment, l_StartSegment
	end --switch around if needed

  local l_BestScoreBeforeRebuild = 0
  local l_PointsGainedFromRebuild = 0
  local l_PointsGainedFromOneRebuildAttempt = 0
  local l_TotalPointsGainedFromAllRebuildAttempts = 0
  local l_MaxStrikesInARow = 3
  local l_StrikesInARow = 0
	
	local l_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle = 
		g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle
    
  print(" ") -- add a blank line

	for l_SegmentRangeRebuildAttempt = 1, l_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle do
		-- Default g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle = 10
   
    l_PointsGainedFromOneRebuildAttempt = 0
   
		if g_bSketchBookPuzzle == true then 
			save.Quickload(3)
		end       
   
		selection.DeselectAll()
		SetClashImportance(g_RebuildClashImportance)
		selection.SelectRange(l_StartSegment, l_EndSegment)
		
		print("  Run " .. g_RunCycle .. " of " .. g_NumberOfRunCycles .. "," ..
			" consecutive segments " .. g_RequiredNumberOfConsecutiveSegments .. " of " .. 
			g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments .. "," ..
			" segment range " .. g_SegmentRangeIndex .. " of " .. #g_SegmentRangesToRebuildTable .. "" ..
			" (" .. l_StartSegment .. "-" .. l_EndSegment .. ")," ..
			" rebuild " .. l_SegmentRangeRebuildAttempt .. " of" .. 
			" " .. g_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle .. "," ..
			" Score: " .. PrettyNumber(g_BestScore) .. "")
    
    l_BestScoreBeforeRebuild = g_BestScore
    
		-- Here's what you are looking for...
		-- Here's what you are looking for...
    
		RebuildSelectedSegments()
    
		-- Here's what you are looking for...
		-- Here's what you are looking for...
    
		SaveBest() -- updates g_BestScore if the score improved.
		
    l_PointsGainedFromRebuild = g_BestScore - l_BestScoreBeforeRebuild
    
    if l_PointsGainedFromRebuild > -20 and  -- not sure what value to place here yet, if any.
       l_PointsGainedFromRebuild ~= 0 then  -- if l_PointsGainedFromRebuild == 0 then we assume nothing changed.
      
			RememberSolutionWithDisulfideBondsIntact()
			
      local l_BestScoreBeforeLocalShakeWiggleAndMutate = 0
      local l_PointsGainedFromLocalShakeWiggleAndMutate = 0
			local l_Iterations = 1
			local l_bShake_And_Wiggle_OnlySelectedSegments = true
      
      l_BestScoreBeforeLocalShakeWiggleAndMutate = g_BestScore
     
			if g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments == true then
				-- Very slow...
       
				local l_SphereRadius = 9 -- Angstroms
				SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
				
				SetClashImportance(1)
				
				l_Iterations = 1
				ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
				l_Iterations = 2
				ShakeAndOrWiggle("WiggleSideChains", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
				selection.DeselectAll()
				selection.SelectRange(l_StartSegment, l_EndSegment)
				l_Iterations = 4
				ShakeAndOrWiggle("WiggleBackbone", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
				
				SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
       
			elseif g_bShake_And_Wiggle_WithSelectedSegments == true then
				-- Not too slow...
        
				SetClashImportance(g_ShakeClashImportance)
				
				l_Iterations = 1
				ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations, l_bShake_And_Wiggle_OnlySelectedSegments)
				
			end -- if g_bShake_And_Wiggle_WithSideChainsAndBackbone_WithSelectedAndNearbySegments == true then
     
			CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
     
			if g_bMutateAfterRebuild == true then
				-- Temporarily save the current solution, so we can see if a mutate will improve
				-- our ScorePart scores...
				SaveCurrentSolutionToQuickSaveStack()
				MutateOneSegmentRange(l_StartSegment, l_EndSegment)
			end
     
   		SaveBest() -- updates g_BestScore if the score improved.
     
      -- Next, check for ScorePart improvements for this particular rebuild attempt.
      -- For each ScorePart that improves, associate the current pose of the protein to 
      -- that ScorePart. After all the rebuild attempts (with their local shakes, wiggles
      -- and mutates) for this segment range, we will step through each of the saved best
      -- ScorePart poses and regionally shake and wiggle them to see if we can further 
      -- improve our score...
			Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment, l_EndSegment)
     
			if g_bMutateAfterRebuild == true then
				-- Return to the last saved solution before peforming the mutate. 
        -- Why? Why not keep the mutate changes? Shouldn't we at least check
        -- if the score improved, before reverting the change? I'm so confused...
				LoadLastSavedSolutionFromQuickSaveStack()
			end
      
      l_PointsGainedFromLocalShakeWiggleAndMutate = g_BestScore - l_BestScoreBeforeLocalShakeWiggleAndMutate
      
      l_PointsGainedFromOneRebuildAttempt = l_PointsGainedFromRebuild +
        l_PointsGainedFromLocalShakeWiggleAndMutate
      
      if l_PointsGainedFromOneRebuildAttempt > 0 then
        l_TotalPointsGainedFromAllRebuildAttempts = l_TotalPointsGainedFromAllRebuildAttempts +
          l_PointsGainedFromOneRebuildAttempt
   			l_StrikesInARow = 0 -- reset the StrikesInARow counter.
      else
        l_StrikesInARow = l_StrikesInARow + 1
      end      
      
    else      
      -- This rebuild did not gain us any more points. The rebuild either did not change 
      -- our score or the rebuild lost more than 20 points. If the loss were less than 20 
      -- points, then we could possibly regain those points with a shake and wiggle. But, 
      -- a loss of more than 20 points would be difficult, if not impossible, to recover
      -- from. If we fail to gain enough points 3 times in a row, we will stop trying with
      -- this segment range, and move on to the next segment range...
      l_StrikesInARow = l_StrikesInARow + 1
     
    end -- if l_PointsGainedFromRebuild > -20 then 
    
    -- If we fail to gain enough points 3 times in a row, we will stop trying with this 
    -- segment range, and move on to the next segment range...
    if l_StrikesInARow >= l_MaxStrikesInARow then -- 3
      print("\n  This segment range has failed to gain points after " .. l_MaxStrikesInARow .. 
               " rebuilds in a row; therefore," ..
            "\n  we will skip the following " .. 
              l_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle - l_SegmentRangeRebuildAttempt ..
              " rebuilds for this segment range and move on to the next segment range...")        
      break
    end   
   
	end -- for l_SegmentRangeRebuildAttempt = 1, l_NumberOf_RebuildOneSegmentRange_AttemptsPerRunCycle do
	
	SetClashImportance(1)

	return l_TotalPointsGainedFromAllRebuildAttempts

end -- RebuildOneSegmentRangeManyTimes()

-- Called from 5 places in PrepareToRebuildSegmentRanges()...
function RebuildManySegmentRanges()

	DisplaySegmentRanges()

	local l_CheckPoseTotalScore = 0
	local l_DeepRebuildGain = 0
	local l_StartSegmentRangePoseTotalScore = 0
	local l_StartSegment = 0
	local l_EndSegment = 0
	local l_CurrentHighScorePart_Number = 0
	local l_DisplayGainFromThis = "" -- to report where gains came from
	local l_CurrentHighScore = 0
	local l_PointsGainedFrom_RebuildOneSegmentRangeManyTimes = 0
	local l_RecentBestScore = 0

	if g_bConvertAllSegmentsToLoops == true then
		ConvertAllSegmentsToLoops()  -- why?
	end

	save.Quicksave(3) -- Save
	recentbest.Save() -- Save the current pose as the recentbest pose.  

	-- This is the real meat of this script...
	-- After laboriously determining which segment ranges to work on, we now finally work on them...

	-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
	-- g_ScorePartsTable={ScorePart_Number=1, ScorePart_Name=2, bIsActive=3, LongName=4}
	-- g_ScorePartScoresTable={ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
	for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do

		g_SegmentRangeIndex = l_SegmentRangeIndex

		--l_StartSegmentRangePoseTotalScore = GetPoseTotalScore()
    l_StartSegmentRangePoseTotalScore = g_BestScore

		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		l_StartSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_StartSegment]
		l_EndSegment = g_SegmentRangesToRebuildTable[l_SegmentRangeIndex][srtrt_EndSegment]
		l_CurrentHighScorePart_Number = 0
		l_DisplayGainFromThis = "" -- to report where gains came from
		l_CurrentHighScore = -99999999
		
		g_FirstRebuildSegment = l_StartSegment
		g_LastRebuildSegment = l_EndSegment
		
		RememberSolutionWithDisulfideBondsIntact()

		if g_RunCycle > 0 then -- g_RunCycle 0 is to skip worst parts

			--print("\nRun " .. g_RunCycle .. " of " .. g_NumberOfRunCycles .. "," ..
			--  " " .. g_RequiredNumberOfConsecutiveSegments .. " of " .. 
			--  g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments .. " consecutive segments," ..
			--	" " .. l_SegmentRangeIndex .. " of " .. #g_SegmentRangesToRebuildTable .. " segment ranges, " ..
			--	" " .. l_StartSegment .. "-" .. l_EndSegment .. " segments, " ..
			--	" Current score: " .. PrettyNumber(l_StartSegmentRangePoseTotalScore) .. "")

			if g_bSketchBookPuzzle == true then
				g_bFoundAHighGain = false
			end

			-- Here's what you are looking for!!!
			-- Here's what you are looking for!!!
			l_PointsGainedFrom_RebuildOneSegmentRangeManyTimes =
				RebuildOneSegmentRangeManyTimes(l_StartSegment, l_EndSegment)
			-- Here's what you are looking for!!!
			-- Here's what you are looking for!!!

			if l_PointsGainedFrom_RebuildOneSegmentRangeManyTimes >= 0 then
			
				if g_bSketchBookPuzzle == false then

					-- We just performed several rebuilds. Each of those rebuilt solutions was saved to 
					-- foldit's undo history. We now need to restore the best of those recent solutions
					-- as the current solution...
					-- Note: g_BestScore is updated in SaveBest(), which is called from many functions
					--       in the rebuild process. If SaveBest() detects the current solution has
					--       a better score than g_BestScore, it calls save.Quicksave to store the 
					--       current solution to foldit's undo history. Then SaveBest() updates 
					--       g_BestScore with the better score. It does not check for broken disulfide
					--       bonds. Here we will make sure no disulfide bonds get broken...
					l_RecentBestScore = GetRecentBestScore()
					if l_RecentBestScore > g_BestScore then 
						
						-- Save the current solution just in case we break any disufide
						-- bonds while restoring the recentbest solution...
						RememberSolutionWithDisulfideBondsIntact()
						
						-- Restore the recentbest solution, from foldit's undo history...
						recentbest.Restore()          
						
						-- Make sure the restored solution didn't break any disulfide bonds.
						-- If it did, then undo the restore...
						CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()          
		
						-- Get the updated Pose Total Score from the restored solution...
						-- Or, if a disulfide bond was broken by the restore, then we get
						-- the score of the solution as it was just before the restore.
						-- I guess ideally, if the recentbest solution did break any bonds, we would 
						-- continue looking for the "next best" recent solution and check it for 
						-- broken bonds, and so on until we found one that didn't break bonds.
						-- Then again, I'm not sure how many times we allow broken bond solutions
						-- to end up in the undo history. I should look into that.
						l_CheckPoseTotalScore = GetPoseTotalScore()
						if l_CheckPoseTotalScore > g_BestScore + 0.00001 then
							-- Note the difference between the following:
							--  g_BestScore <-- Updated in SaveBest(), which is called from many functions
							--                  in the rebuild process. 
							--  GetRecentBestScore() <-- This is from the recent best 
              --                           solution in foldit's undo history
							--  GetPoseTotalScore() <-- The score of the current pose, which
              --                          is now the one just restored
							
               -- Found a gain by restoring foldit's recent best solution?
							print("\n  Found a missed gain by restoring foldit's recent best solution! Why?" ..
                       " Old Best Score: " .. PrettyNumber(g_BestScore) .. "," ..
                       " gain: " .. PrettyNumber(l_CheckPoseTotalScore - g_BestScore) .. "," ..
                       " new best score: " .. PrettyNumber(l_CheckPoseTotalScore))
                     
							SaveBest() -- updates g_BestScore if the score improved.
							Update_ScorePartScoresTable_ScorePart_Score_And_PoseTotalScore_Fields(l_StartSegment,
                l_EndSegment, 0)
							
						end -- if l_CheckPoseTotalScore > g_BestScore + 0.00001 then
					end -- if l_RecentBestScore > g_BestScore then 
				end -- if g_bSketchBookPuzzle == false then
        
				Update_ScorePartScoresTable_ToDo_And_ScorePartsList_Fields()
        
        print(" ") -- add blank line
        
        -- Let's see if we can gain more points by 
        -- Shaking and Wiggling nearby segments...
				local l_SphereRadius = 12
				SelectSegmentsNearSegmentRange(l_StartSegment, l_EndSegment, l_SphereRadius)
        
        -- For each of the above rebuild attempts that successfully gained points, we 
        -- saved the protein's pose (stucture) just after gaining the points. Now, we 
        -- will step through each one of those poses for this segment range and see if 
        -- regional shaking and wiggling will futher improve their score...
        -- Process each row in the g_ScorePartScoresTable...
        
				--g_ScorePartScoresTable=
        --  {ScorePart_Number=1, ScorePart_Score=2, PoseTotalScore=3, ScorePartsList=4, bToDo=5}
				for l_ScorePartScoresTableIndex = 1, #g_ScorePartScoresTable do
          
					if g_ScorePartScoresTable[l_ScorePartScoresTableIndex][spst_bToDo] == true then
            
						local l_ScorePart_Number = g_ScorePartScoresTable[l_ScorePartScoresTableIndex][spst_ScorePart_Number]
            
            -- Reload the saved protein pose (protein shape)...
						save.Quickload(l_ScorePart_Number) 
            
						RememberSolutionWithDisulfideBondsIntact()
            
						if g_bPerformNormalStabilization == true then
							
							PerformNormalStabilizationOnSegmentRange(l_StartSegment, l_EndSegment)
							
						else
							
							local l_Iterations = 1
							local l_bShake_And_Wiggle_OnlySelectedSegments = true
							
							SetClashImportance(1)
							ShakeAndOrWiggle("ShakeAndWiggle", l_Iterations,
                l_bShake_And_Wiggle_OnlySelectedSegments)
							ShakeAndOrWiggle("WiggleSideChains", l_Iterations,
                l_bShake_And_Wiggle_OnlySelectedSegments)
							
						end
						
						CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
            
						if g_bMutateAfterNormalStabilization == true then
							MutateOneSegmentRange(l_StartSegment, l_EndSegment)
						end
            
						save.Quicksave(l_ScorePart_Number) -- Save
            
						l_CheckPoseTotalScore = GetPoseTotalScore()
						if l_CheckPoseTotalScore > l_CurrentHighScore then
              
              -- The current ScorePart gained us some points...
              -- Let's keep track of which ScoreParts these score improvements came from...
							l_CurrentHighScorePart_Number = l_ScorePart_Number
							
							-- ScorePartsList examples: "4", "5=7=12", "[6=9]", "[8=11=13]"
							local l_ScorePartsList = g_ScorePartScoresTable[l_ScorePartScoresTableIndex][spst_ScorePartsList]
							
              if l_DisplayGainFromThis ~= "" then
                l_DisplayGainFromThis = l_DisplayGainFromThis .. ", " 
              end
							l_DisplayGainFromThis = l_DisplayGainFromThis .. l_ScorePartsList
								
							l_CurrentHighScore = l_CheckPoseTotalScore
              
						end
						SaveBest()
            
						-- g_ScorePartsTable  {1=ScorePart_Number, 2=ScorePart_Name, 3=bIsActive, 4=LongName}
						print("  Stabilized score: [" .. PrettyNumber(l_CheckPoseTotalScore) .. "]" ..
                  " from ScorePart " .. g_ScorePartsTable[l_ScorePart_Number - 3][spt_LongName])
              
					end -- if g_ScorePartScoresTable[l_ScorePartScoresTableIndex][spst_bToDo] == true then
          
				end -- for l_ScorePartScoresTableIndex = 1, #g_ScorePartScoresTable do
        
				save.Quickload(l_CurrentHighScorePart_Number) -- Load
        
				local l_PotentialPointsLoss = l_StartSegmentRangePoseTotalScore - l_CheckPoseTotalScore
				local l_MaxLossAllowed = g_SkipFusingBestPositionIfLossIsGreaterThan * 
																(l_EndSegment - l_StartSegment + 1) / 3
				if g_bFuseBestPosition == true and 
				   l_PotentialPointsLoss < l_MaxLossAllowed then
          
					print("\n  Fusing the best position of segment range (" .. 
            l_StartSegment .. "-" .. l_EndSegment .. ") after gaining " ..
            PrettyNumber(l_PointsGainedFrom_RebuildOneSegmentRangeManyTimes) .. 
            " points from just the rebuild step...")
					
					-- This checks for g_bMutateAfterNormalStabilization == false because if it were true, 
					-- then we would have already performed the mutate above, after the stabilization. duh
					if g_bMutateBeforeFuseBestPosition == true and
						 g_bMutateAfterNormalStabilization == false then               
							 
						MutateOneSegmentRange(l_StartSegment, l_EndSegment)
						
					end
          
					save.Quicksave(4) -- Save
					
					if g_bUserWantsToKeepDisulfideBondsIntact == true then
						
						-- note: using the global value for 4th parameter here...
						FuseBestPosition(4, RememberSolutionWithDisulfideBondsIntact,
							CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact,
							g_bShake_And_Wiggle_OnlySelectedSegments)
						
					else
						
						FuseBestPosition(4, nil, nil, g_bShake_And_Wiggle_OnlySelectedSegments)
						
					end
					
					if g_bMutateAfterFuseBestPosition == true then
						MutateOneSegmentRange(l_StartSegment, l_EndSegment)
					end
          
				end -- if g_bFuseBestPosition == true and 
        
				SaveBest()
				save.Quickload(3) -- Load
        
			else
        
				-- l_bFoundOne is false at this point...
				-- We did not find an improvement, so let's restore the last known good position...
				save.Quickload(3) -- Load
				
			end -- if l_PointsGainedFrom_RebuildOneSegmentRangeManyTimes > 0 then
      
		end -- if g_RunCycle > 0 then
    
		if g_bUserWantsToKeepDisulfideBondsIntact == true then
			if bOneOrMoreDisulfideBondsHaveBroken() == true then
				print("\nOne or more disulfide bonds have broken. This should never happen." ..
              "\nPlease report this to someone (who? Foldit? or the maker of this script?)." ..
              "\nDiscarding score gains and restoring last known vaild protein pose.\n")
				CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
				save.Quicksave(3) -- Quicksave? Shouldn't this be Quickload?
        
				l_CheckPoseTotalScore = GetPoseTotalScore()
        if l_CheckPoseTotalScore > g_BestScore then
          g_BestScore = l_CheckPoseTotalScore
        end
			else
				CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
			end
		else
			CheckIfWeNeedToRestoreSolutionWithDisulfideBondsIntact()
		end
    
		SetSegmentsAlreadyRebuilt(l_StartSegment, l_EndSegment)
    
		local l_DeepRebuildGain = 0
		l_DeepRebuildGain = g_BestScore - l_StartSegmentRangePoseTotalScore
    
		-- if l_CheckPoseTotalScore > l_StartSegmentRangePoseTotalScore + 0.00001 then
		if l_DeepRebuildGain > 0 then
			print("\n  Points gained from ScoreParts: [" .. l_DisplayGainFromThis .. "]," ..
               " Old Best Score: " .. PrettyNumber(l_StartSegmentRangePoseTotalScore) .. "," ..
               " Gain: " .. PrettyNumber(l_DeepRebuildGain) .. "," .. 
               " New Best Score: " .. PrettyNumber(g_BestScore))
			-- print("  Rebuilding this segment range gained us: [" .. l_DeepRebuildGain .. "] points")
			--l_PoseTotalScore = l_CheckPoseTotalScore
		end
    
    g_CurrentRebuildPointsGained = l_DeepRebuildGain -- this will be checked in bSegmentIsAllowedToBeRebuilt
    
		-- The default for g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan is 40 or less.
		-- If we just gained more than g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan, 
		-- then we figure, that's good enough for now. It is now time to move on to more consecutive
		-- segments per segment range...But why such a low number?
		if l_DeepRebuildGain > g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan then
      l_RemainingSegmentRanges = #g_SegmentRangesToRebuildTable - l_SegmentRangeIndex
      print("\nThe rebuild gain of " .. PrettyNumber(l_DeepRebuildGain) .. " is greater than the" ..
            " 'Move on to more consecutive segments per range if current rebuild gains more than'" ..
            " value of " .. g_MoveOnToMoreSegmentsPerRangeIfCurrentRebuildGainsMoreThan .. 
            " points (this value can be changed on the 'More Options' page);" ..
            " therefore, we will now skip the remaining " .. l_RemainingSegmentRanges .. 
            " segment ranges with " .. g_RequiredNumberOfConsecutiveSegments .. 
            " consecutive segments, and begin processing segments ranges with " ..
            (g_RequiredNumberOfConsecutiveSegments + 1) .. " consecutive segments.")
      
			break -- for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do
		end
    
	end -- for l_SegmentRangeIndex = 1, #g_SegmentRangesToRebuildTable do
  
	if g_bConvertAllSegmentsToLoops == true and g_bSavedSecondaryStructure == true then
		save.LoadSecondaryStructure()
	end

end -- RebuildManySegmentRanges()

-- Called from 6 places in main()...
function PrepareToRebuildSegmentRanges(l_How)

	if l_How == "drw" then

		-- drw means Deep Rebuild with Worst scoring segments

		-- This method starts the rebuild process with a small number of consecutive
		-- segments, then progressively processes larger numbers of consecutive segments

		-- Script defaults:
		-- g_StartProcessingWithThisManyConsecutiveSegments = 2
		-- g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4

		local l_Step = 1
		if g_StartProcessingWithThisManyConsecutiveSegments >
			 g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments then
			l_Step = -1 -- process backwards if needed
		end

		local g_MaxNumberOfSegmentRangesToProcess = g_NumberOfRunCycles + 
			g_StartingNumberOfSegmentRangesToProcessPerRunCycle

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
			g_StartProcessingWithThisManyConsecutiveSegments,
			g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments,
			l_Step do

			-- ...and that's why we have to do this...
			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments
			
			InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()
			
			--print("\nRun " .. g_RunCycle .. " of " .. g_NumberOfRunCycles .. "," ..
			--  " " .. g_RequiredNumberOfConsecutiveSegments .. " of " .. 
			--  g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments .. " consecutive segments," ..
			--	" Current score: " .. PrettyNumber(g_BestScore) .. "")

			-- Here's what you are looking for...
			-- Here's what you are looking for...
			RebuildManySegmentRanges()
			-- Here's what you are looking for...
			-- Here's what you are looking for...

		end

	elseif l_How == "fj" then

		InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()

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
		RebuildManySegmentRanges()

	elseif l_How == "all" then

		g_SegmentRangesToRebuildTable = {}

		-- Script defaults:
			g_StartProcessingWithThisManyConsecutiveSegments = 2
			g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments = 4

		for l_RequiredNumberOfConsecutiveSegments =
			g_StartProcessingWithThisManyConsecutiveSegments,
			g_ResetToStartValueAfterProcessingWithThisManyConsecutiveSegments do

			g_RequiredNumberOfConsecutiveSegments = l_RequiredNumberOfConsecutiveSegments

			for l_SegmentIndex = 1, g_SegmentCountWithoutLigands do

				local l_StartSegment = l_SegmentIndex
				local l_EndSegment = g_RequiredNumberOfConsecutiveSegments + l_SegmentIndex - 1

				if l_EndSegment <= g_SegmentCountWithoutLigands then

					-- g_SegmentRangesToRebuildTable = {StartSegment, EndSegment}
					g_SegmentRangesToRebuildTable[#g_SegmentRangesToRebuildTable + 1] = {l_StartSegment, l_EndSegment}
				end

			end
		end
		RebuildManySegmentRanges()

	elseif l_How == "simple" then

		InitGlobalSegmentRangesTableWithWorstScoringSegmentRanges()
		RebuildManySegmentRanges()

	elseif l_How=="segments" then

		-- g_SegmentRangesToRebuildTable={StartSegment=1, EndSegment=2}
		g_SegmentRangesToRebuildTable = {}
		Add_Loop_Helix_And_Sheet_Segments_To_SegmentRangesTable()
		RebuildManySegmentRanges()

	end

end -- PrepareToRebuildSegmentRanges(l_How)
-- ...end of Core Rebuild Functions module.

-- Called from 1 place in xpcall()...
function main()

	--require('mobdebug').start("192.168.1.108") unfortunately this doesn't work in the FoldIt environment
	DefineGlobalVariables()

	print("\n" .. g_ProgramName..g_ProgramVersion)
	print("\n  Hello " .. user.GetPlayerName() .. "!")

	PopulateGlobalScorePartsTable()

	DisplayPuzzleProperties()

	CheckForLowStartingScore()

	g_OrigSelectedSegmentRanges = FindSelectedSegmentRanges() -- only used in CleanUp()

	local l_bOkayToContinue
	l_bOkayToContinue = bAskUserToSelectRebuildOptions() -- Major code in here!

	-- l_bOkayToContinue = false -- to debug
	if l_bOkayToContinue == false then
		-- The user clicked the Cancel button.
		return -- exit script...
	end

	DisplaySelectedOptions()

	g_bSegmentsToRebuildBooleanTable =
		ConvertSegmentRangesTableToSegmentsToRebuildBooleanTable(g_SegmentRangesToRebuildTable)

	g_MaxNumberOfSegmentRangesToProcessThisRunCycle = g_StartingNumberOfSegmentRangesToProcessPerRunCycle

	if g_NumberOfSegmentsSkipping > 0 then

		local g_SaveThisNumberOfSegmentsToProcessPerRunCycle = g_MaxNumberOfSegmentRangesToProcessThisRunCycle
		g_MaxNumberOfSegmentRangesToProcessThisRunCycle = g_NumberOfSegmentsSkipping
		g_RunCycle = 0

		-- Here's what you are looking for...
		PrepareToRebuildSegmentRanges("drw") -- <<<----- This is what you are looking for!

		g_NumberOfSegmentsSkipping = 0
		g_MaxNumberOfSegmentRangesToProcessThisRunCycle = g_SaveThisNumberOfSegmentsToProcessPerRunCycle

	end

		for l_RunCycle = 1, g_NumberOfRunCycles do

		g_RunCycle = l_RunCycle

		--print("\nRun " .. g_RunCycle .. " of " .. g_NumberOfRunCycles .. "," ..
		 -- " rebuilding " .. g_MaxNumberOfSegmentRangesToProcessThisRunCycle .. " segment ranges...")


		-- Here's what you are looking for!!!
		-- Here's what you are looking for!!!

		PrepareToRebuildSegmentRanges("drw")
		
		-- Here's what you are looking for!!!
		-- Here's what you are looking for!!!

		
		-- Uncomment the methods you want to use...
		-- PrepareToRebuildSegmentRanges("all")
		-- PrepareToRebuildSegmentRanges("areas")
		-- PrepareToRebuildSegmentRanges("fj")
		-- PrepareToRebuildSegmentRanges("simple")

		--CheckOnlyRetryAlreadyTriedSegments_IfPointsGainedIsMoreThan()

		g_MaxNumberOfSegmentRangesToProcessThisRunCycle = g_MaxNumberOfSegmentRangesToProcessThisRunCycle +
			g_AdditionalNumberOfSegmentRangesToProcessPerRunCycle

	end

	CleanUp()

end -- main()

-- run in protected mode, so if the program crashes we can fail gracefully, by calling CleanUp()...
xpcall(main, CleanUp)
-- main() -- Call main() directly when debugging to make finding broken line easier. It makes it more obvious where the error occured.
