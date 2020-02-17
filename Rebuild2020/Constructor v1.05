--[[

Greetings!

It is a script that contains many other scripts and allows you to run any of them. Just choose which one to run after the start.
Also there is an Autobot script that allows you to predefine the run sequence of basic scripts with given parameters. So you can create your own Score gain algorithm.

How it works:
1. Each basic script have a code and some of them have a parameters. When you want to include a basic script to sequence, print code and print all the parameters with the underscore. After the each basic script print the dot.
For example, if you want to use BlueFuze just include "BF." in the sequence. If you want to use Band Test include "BT_15_87_97.", where 15, 87 and 97 - script parameters (see description).
2. When sequence is completed, write it to text field and start the script.
3. Script will be sequentially running your predefined scripts. When All scripts completed, it checks how much score is gained. If its exceed the limit (limit can be set to 0), then the sequence runs for one more time. If not, then the Iterations ends and the new Iteration starts (from the structure when the script was started).

The example of sequence, that I used:
Default:        "CL.FR.BT_15_87_97.BT_15_103_113.RW_2_1_10.QU_15.BF.RW_1_1_10.LW_12_2.SR."
For Mutable:    "CL.FR.BT_10_87_97.MT_3_20.BT_10_103_113.NM.RW_2_1_10.MT_3_20.QU_15.BF.RW_1_1_10.LW_12_2.SR."
For Multistart: "WS.BT_2_87_97.FR.CL.BT_10_87_97.BT_10_103_113.RW_2_1_10.QU_15.BF.RW_1_1_10.LW_12_2.SR."

Basic scripts.

1. Clashing.
Script code: CL
Script Parameters: none
Script Description: Making a sequence of wiggles and shakes with different clashing.

2. FastRelax.
Script code: FR
Script Parameters: none
Script Description: Well known FastRelax script :)

3. BlueFuze.
Script code: BF
Script Parameters: none
Script Description: BlueFuze.

4. WS or SW. 
Script code: WS
Script Parameters: none
Script Description: Tries 4 different WS/SW tactics to improve score from destabilized status.

5. Band Test.
Script code: BT
Script Parameters:
1) Number of iterations.
2) Lowest length (in % from original).
3) Highest length (in % from original).
Script Description: Creates a random band with the length in given boundaries. Wiggle structure with band enabled, then delete band and wiggle out. Repeat given number of Iterations.
Script example: "BT_15_87_97.".

6. Local Wiggle.
Script code: LW
Script Parameters:
1) Wiggle segment Length
2) Number of wiggle iterations.
Script Description: Makes local wiggle.
Script example: "LW_12_2.".

7. Local Rebuild.
Script code: LR
Script Parameters:
1) Rebuild segment Length
Script Description: Makes local rebuildes from the begin to the end of structure.
Script example: "LW_12_2.".

8. Quake.
Script code: QU
Script Parameters:
1) Distance between segments with bands.
Script Description: Makes bands with the given length between segments. Wiggle structure with band enabled, then delete band and wiggle out.
Script example: "QU_15.".

9. Sidechain Test.
Script code: ST
Script Parameters:
1) Number of segments
Script Description: Test every possible position of sidechain at given number of random segments.
Script example: "ST_10.".

10. Mutate.
Script code: MU
Script Parameters: none
Script Description: Just do mutate once.

11. Mutate and Test.
Script code: MT
Script Parameters: 
1) Function number.
2) Number of tries (affects only 3rd function).
Script Description:
 Depending on the function number it does: 
 1) Test all posible changes of AA for one segment (very long).
 2) Test all posible changes of AA for two segment (impossible long).
 3) Test random change of 2 AAs for given number of times.
Script example: "MT_3_10.".

12. New Mutate
Script code: NM
Script Parameters: none
Script Description: Sequentially mutate each segment for all possible AAs.

13. Rebuilder
Script code: RE
Script Parameters: 
1) Start segment.
2) End segment.
3) Number of tries.
Script Description: Rebuild the segment and check the structure by wiggles and shake.
Script example: "RE_10_13_5.".

14. Sidechain Flipper.
Script code: SF
Script Parameters: none
Script Description: Sequentially flips each sidechain.

15. Soft Relax
Script code: SR
Script Parameters: none
Script Description: The variation of FastRelax.

16. Rebuild Worst.
Script code: RW
Script Parameters: 
1) Length of segment to rebuild.
2) Number of tries for each segment.
3) Number of segments to rebuild.
Script Description: Rebuilds the worst scoring segments of given length.
Script example: "RW_1_1_10.".

17. MicroIdealize
Script code: MI
Script Parameters: 
1) Length of segment to Idealize.
2) Number of segments to Idealize.
Script Description: Idealizes the worst scoring segments (idealize score) of given length.
Script example: "MI_3_4.".

]]--

-- Predefined Sequences

-- Common
SequenceStrPredefined1 = "CL.FR.BT_15_87_97.BT_15_103_113.RW_2_1_10.QU_15.BF.RW_1_1_10.LW_12_2.SR.MI_3_10.ST_1." 
-- For Mutable
SequenceStrPredefined2 = "CL.FR.BT_10_87_97.MT_3_20.BT_10_103_113.NM.RW_2_1_10.MT_3_20.QU_15.BF.RW_1_1_10.LW_12_2.SR.MI_3_10.ST_1."
-- For Multistart
SequenceStrPredefined3 = "WS.BT_2_87_97.FR.CL.BT_10_87_97.BT_10_103_113.RW_2_1_10.QU_15.BF.RW_1_1_10.LW_12_2.SR.MI_3_10.ST_1."
-- For Endgame Death
SequenceStrPredefined4 = "CL.BF.MI_4_200.LW_15_2.LW_14_2.LW_13_2.LW_12_2.LW_11_2.LW_10_2.SF.CL.BF.MI_3_200.LW_9_2.LW_8_2.LW_7_2.LW_6_2.LW_5_2.SF.CL.BF.MI_2_200.LW_4_2.LW_3_2.LW_2_2.LW_1_2.QU_12."

-- Shared functions

fsl={}
fsl.aminosLetterIndex=1
fsl.aminosShortIndex=2
fsl.aminosLongIndex=3
fsl.aminosPolarityIndex=4
fsl.aminosAcidityIndex=5
fsl.aminosHydropathyIndex=6
fsl.aminos = {
   {'a','Ala','Alanine',      'nonpolar','neutral',   1.8},
-- {'b','Asx','Asparagine or Aspartic acid' }, 
   {'c','Cys','Cysteine',     'nonpolar','neutral',   2.5},
   {'d','Asp','Aspartic acid',   'polar','negative', -3.5},
   {'e','Glu','Glutamic acid',   'polar','negative', -3.5},
   {'f','Phe','Phenylalanine','nonpolar','neutral',   2.8},
   {'g','Gly','Glycine',      'nonpolar','neutral',  -0.4},
   {'h','His','Histidine',       'polar','neutral',  -3.2},
   {'i','Ile','Isoleucine',   'nonpolar','neutral',   4.5},
-- {'j','Xle','Leucine or Isoleucine' }, 
   {'k','Lys','Lysine',          'polar','positive', -3.9},
   {'l','Leu','Leucine',      'nonpolar','neutral',   3.8},
   {'m','Met','Methionine ',  'nonpolar','neutral',   1.9},
   {'n','Asn','Asparagine',      'polar','neutral',  -3.5},
-- {'o','Pyl','Pyrrolysine' }, 
   {'p','Pro','Proline',     'nonpolar','neutral',   -1.6},
   {'q','Gln','Glutamine',      'polar','neutral',   -3.5},
   {'r','Arg','Arginine',       'polar','positive',  -4.5},
   {'s','Ser','Serine',         'polar','neutral',   -0.8},
   {'t','Thr','Threonine',      'polar','neutral',   -0.7},
-- {'u','Sec','Selenocysteine' }, 
   {'v','Val','Valine',      'nonpolar','neutral',    4.2},
   {'w','Trp','Tryptophan',  'nonpolar','neutral',   -0.9},
-- {'x','Xaa','Unspecified or unknown amino acid' },
   {'y','Tyr','Tyrosine',       'polar','neutral',   -1.3},
-- {'z','Glx','Glutamine or glutamic acid' } 
}

-- Print time and score
function p_Time(startTime,ScoreGain)
  local ss = (os.time()-startTime)%60
  local mm = (((os.time()-startTime-ss)%3600)/60)
  local hh = (os.time()-startTime-mm*60-ss)/3600
  print("Time: "..hh..":"..mm..":"..ss..". ".."Score: "..current.GetEnergyScore()..", Total: +"..ScoreGain)
end


-- Freestyle Starter.
function freestyle_starter()

  local startScore = current.GetEnergyScore()
  
  local function starter_rebuild(NumRebuild)
    selection.SelectAll()
    band.EnableAll()
    structure.RebuildSelected(NumRebuild)
    band.DisableAll()
    selection.DeselectAll()
    ws_or_sw({1,1,1,1})
  end
  
  for i=1,10 do
    starter_rebuild(10)
    print("Rebuild: " .. i .. ", score: " .. current.GetEnergyScore() .. ",gain: " .. current.GetEnergyScore() - startScore)
    recentbest.Restore()
  end
  
end


-- Common mutate/shake/wiggle combination.
function StepC(Clashing,Mutates,Shakes,Wiggles)
  if Clashing >= 0 and Clashing <= 1 then behavior.SetClashImportance(Clashing) end
  if Mutates > 0 then structure.MutateSidechainsAll(Mutates) end
  if Shakes > 0 then structure.ShakeSidechainsAll(Shakes) end
  if Wiggles > 0 then structure.WiggleAll(Wiggles) end
end


-- Sphere select
function SphereSelect(start_idx,end_idx,kSphereRadius)

  local NumSegm = structure.GetCount()
  local sphere = {}
  
  for i = 1 , NumSegm do sphere[i] = false end
  for i = 1 , NumSegm do
    for j = start_idx, end_idx do
      if (structure.GetDistance(i,j) < kSphereRadius) then sphere [i] = true end
    end
  end
  selection.DeselectAll ()
  for i = 1 , NumSegm do
    if (sphere[i] == true) then selection.Select(i) end
  end

end

-- Center Segment
function GetCenterSegment()

  local NumSegm = structure.GetCount()
  local SegmentDistance
  local CenterSegmentNum = 1
  local MinSegmentDistance = 999999
  
  for i = 1, NumSegm do
    SegmentDistance = 0
    for j = 1, NumSegm do
	  SegmentDistance = SegmentDistance + structure.GetDistance(i,j)
	end
	if MinSegmentDistance > SegmentDistance then
      MinSegmentDistance = SegmentDistance
	  CenterSegmentNum = i
	end
  end
  
  return CenterSegmentNum
end


-- Modules Section.


-- BlueFuze.

function BlueFuze()
  StepC(0.05,0,1,0)
  StepC(1,0,0,8)
  StepC(0.07,0,1,0)
  StepC(1,0,0,8)
  recentbest.Restore()
  StepC(0.3,0,0,1)
  StepC(1,0,0,8)
  recentbest.Restore()
end


-- SoftRelax.

function SoftRelaxFull()

  local function SoftRelax()

    local Mutates = 2 --number of shakes
	local Shakes = 0 --number of shakes
    local Wiggles = 3 --number of wiggles
    StepC(0.55,Mutates,Shakes,Wiggles)
    StepC(0.25,Mutates,Shakes,Wiggles)
    StepC(0.05,Mutates,Shakes,Wiggles)
    StepC(0.25,Mutates,Shakes,Wiggles)
    StepC(0.55,Mutates,Shakes,Wiggles)
    StepC(1,Mutates,Shakes,Wiggles)

  end

  local startScore
  local minScoreChange = 1
  local Step = 1
  repeat
    startScore = current.GetEnergyScore()
    SoftRelax()
    recentbest.Restore()
    print(Step..". Score: "..math.max(current.GetEnergyScore(),startScore).." gain: "..math.max(current.GetEnergyScore() - startScore,0))
    Step = Step + 1
  until current.GetEnergyScore() - startScore < minScoreChange
end


-- FastRelax.

function FastRelaxFull()

  local function FastRelax()

    local Mutates = 2 --number of shakes
	local Shakes = 0 --number of shakes
    local Wiggles = 5 --number of wiggles
    StepC(0.02,Mutates,Shakes,Wiggles)
    StepC(0.25,Mutates,Shakes,Wiggles)
    StepC(0.55,Mutates,Shakes,Wiggles)
    StepC(1,Mutates,Shakes,Wiggles)
    
  end

  local startScore
  local minScoreChange = 2
  local Step = 1
  repeat
    startScore = current.GetEnergyScore()
    FastRelax()
    recentbest.Restore()
    print(Step..". Score: "..math.max(current.GetEnergyScore(),startScore).." gain: "..math.max(current.GetEnergyScore() - startScore,0))
    Step = Step + 1
  until current.GetEnergyScore()-startScore < minScoreChange
end


-- Clashing.

function clashing(Repeat)
  local i = 1
  local startScore
  while i < 10 do 
    startScore = current.GetEnergyScore()
	StepC(i/10,0,0,i)
	StepC(1,1,0,15)
	StepC(1,1,0,4)
    print("Clashing: " .. i/10 .. ", score: " .. current.GetEnergyScore() - startScore)
    if startScore < current.GetEnergyScore() and Repeat == 1 and i < 8
      then i = 1
      else i = i + 1
    end
    recentbest.Restore()
  end

end


-- Wiggle/Shake or Shake/Wiggle.

function ws_or_sw(params)

  local function ws_or_sw_1()
    structure.WiggleAll(15)
	StepC(-1,1,0,10)
	StepC(-1,1,0,5)
    print("WS score: "..current.GetEnergyScore())
  end
  local function ws_or_sw_2()
	StepC(-1,1,0,15)
	StepC(-1,1,0,10)
	StepC(-1,0,1,5)
    print("SW score: "..current.GetEnergyScore())
  end
  local function ws_or_sw_3()
	StepC(0.5,0,0,4)
	StepC(1,1,0,15)
	StepC(1,1,0,10)
	StepC(1,0,1,5)
    print("SW 0.5 score: "..current.GetEnergyScore())
  end
  local function ws_or_sw_4()
    for i = 3, 10 do
	  StepC(i/10,0,0,1)
      if i == 3 or i == 6 then structure.ShakeSidechainsAll(1) end
    end
	StepC(-1,0,1,15)
	StepC(-1,0,1,5)
    print("Step clash: "..current.GetEnergyScore())
  end
  
  save.Quicksave(100)
  if params[1] == 1 then save.Quickload(100) ws_or_sw_1() end
  if params[2] == 1 then save.Quickload(100) ws_or_sw_2() end
  if params[3] == 1 then save.Quickload(100) ws_or_sw_3() end
  if params[4] == 1 then save.Quickload(100) ws_or_sw_4() end
  recentbest.Restore()
end


-- Band Test.

function Band_tests(Start_LengthP,End_LengthP,Clashing,Iteration,TotalIteration)

  local function PullPart(Segment1,Segment2,LengthP,Strength)
    band.DeleteAll()
    band.AddBetweenSegments(Segment1,Segment2)
    band.SetStrength(1,Strength)
    band.SetGoalLength(1,structure.GetDistance(Segment1,Segment2)*LengthP)
    structure.WiggleAll(1)
    band.DeleteAll()
  end

  local startSeg = math.random(1,structure.GetCount()-9)
  while structure.IsLocked(startSeg) do startSeg = math.random(1,structure.GetCount()-9) end
  local endSeg = math.random(startSeg+8,structure.GetCount())
  local LengthP = math.random(Start_LengthP,End_LengthP)
  local startScore = current.GetEnergyScore()
  if TotalIteration == 0 then TotalIterationStr = "inf" else TotalIterationStr = TotalIteration end
  
  if LengthP>97 and LengthP<=100 then LengthP=Start_LengthP end
  if LengthP>100 and LengthP<103 then LengthP=End_LengthP end
  PullPart(startSeg,endSeg,LengthP/100,10)
  StepC(-1,1,0,15)
  StepC(-11,1,0,5)
  StepC(Clashing,0,0,5)
  StepC(1,0,0,15)
  recentbest.Restore()
  print(Iteration .."/".. TotalIterationStr .. "; " .. startSeg .. "-" .. endSeg .. ", score: " ..math.max(startScore,current.GetEnergyScore()) .. ", gain: " .. math.max(0,current.GetEnergyScore()-startScore))
end


-- Local Wiggle.

function local_wiggle(Len,Num)
  local NumSegm = structure.GetCount()
  local startScore
  local gainScore

  for i = 1, NumSegm-Len+1, 1 do
    startScore = current.GetEnergyScore()
    selection.DeselectAll()
    selection.SelectRange(i, i+Len-1)
    structure.LocalWiggleSelected(Num)
    gainScore = current.GetEnergyScore() - startScore
    if gainScore <0.0001 then gainScore = 0 end
    print(i .. "-" .. i+Len-1 .. "/" .. NumSegm .. ", score: " .. current.GetEnergyScore() .. ", gain: " .. gainScore)
    recentbest.Restore()
  end
end


-- Local Rebuild.

function local_rebuild_all(Length,Clashing)

  local function local_rebuild(Start,Len,Clsh)
    local startScore = current.GetEnergyScore()
    local newScore
    local gainScore
    selection.DeselectAll()
    selection.SelectRange(Start,Start+Len-1)
    for i=1,3 do
      if current.GetEnergyScore()-startScore<0.05 and startScore-current.GetEnergyScore()<0.05 then structure.RebuildSelected(i) end
    end
    if current.GetEnergyScore()-startScore>0.05 or startScore-current.GetEnergyScore()>0.05 then
      selection.SelectAll()
	  StepC(-1,1,0,15)
      structure.ShakeSidechainsAll(1)
      selection.DeselectAll()
      selection.SelectRange(Start,Start+Len-1)
      structure.LocalWiggleSelected(15)
      selection.SelectAll()
      structure.WiggleAll(15)
      newScore = current.GetEnergyScore()
      if Clsh < 1 then
		StepC(Clsh,0,0,4)
		StepC(1,1,0,15)
		StepC(1,0,1,10)
        if current.GetEnergyScore()>newScore then newScore = current.GetEnergyScore() end
      end
      gainScore = newScore - startScore
      if gainScore < 0.0001 then gainScore = 0 end
      print(Start .. "-" .. Start+Len-1 .. "/" .. structure.GetCount() .. ", score: " .. current.GetEnergyScore() .. ", gain: " .. gainScore)
    end
  end

  for z=1,structure.GetCount()-Length do
    recentbest.Save()
    local_rebuild(z,Length,Clashing)
    recentbest.Restore()
  end
end


-- Rebuild Worst.

function RebuildWorst(Length,RebuildsTries,Clashing,NumSegsForRebuild)

  local function Worst_Segments(Length)
  
    local function Sort(tab)
        for x=1,#tab-1 do
            for y=x+1,#tab do
                if tab[x][3]>tab[y][3] then
                    tab[x],tab[y]=tab[y],tab[x]
                end
            end
        end
        return tab
    end
  
    local segsInfo = {}
    for i=1, structure.GetCount() - Length + 1 do
      segsInfo[i] = {i,i+Length-1,current.GetSegmentEnergyScore(i)}
      for j=2, Length do
        segsInfo[i] = {segsInfo[i][1],segsInfo[i][2],segsInfo[i][3] + current.GetSegmentEnergyScore(i+j-1)}
      end
    end
    segsInfo = Sort(segsInfo)
    return segsInfo
  end

  local NumSegs = structure.GetCount()
  local WorstSegs = Worst_Segments(Length)
  local segsForRebuild = {}
  local Step = 1
  local sOutput = ""
  local startScore
  
  for i=1,math.min(#WorstSegs,NumSegsForRebuild) do
    segsForRebuild = {}
    selection.DeselectAll()
    for j = math.max(WorstSegs[i][1]-1,1), math.min(WorstSegs[i][2]+1,NumSegs) do segsForRebuild[#segsForRebuild + 1] = j end
    Step = 1
    sOutput = ""
    RebuildsTries = RebuildsTries + 0 -- Type conversion?
    while Step <= RebuildsTries do
      startScore = current.GetEnergyScore()
      for l=1, #segsForRebuild do selection.Select(segsForRebuild[l]) end
      for l=1,10 do
        if math.abs(current.GetEnergyScore()-startScore) < 0.05 then structure.RebuildSelected(i) end
      end
      if math.abs(current.GetEnergyScore()-startScore) > 0.05 then
		StepC(-1,1,0,15)
        structure.ShakeSidechainsAll(1)
        structure.WiggleSelected(10)
        structure.WiggleAll(10)
        if Clashing < 1 then
		  StepC(Clashing,0,0,4)
		  StepC(1,1,0,10)
		  StepC(1,0,1,5)
        end
      end
      sOutput = Step .." Try " .. ", " .. segsForRebuild[1] .. "-" .. segsForRebuild[#segsForRebuild] .. ", score: " .. current.GetEnergyScore()
      if current.GetEnergyScore()-startScore > 0.0001 then 
        sOutput = sOutput .. ", +" .. current.GetEnergyScore()-startScore
        Step = 0
      end
      print(sOutput)
      Step = Step + 1
      recentbest.Restore()
    end
  end
end


-- Quake.

function quake(Length,ScoreDelta,Clashing)

  function quake_one(Start,Diff,Delta,Clashing)
  
    local function set_bands(Str)
      for z=1, band.GetCount() do
        band.SetStrength(z,Str)
      end
    end
  
    local numSegments = structure.GetCount()
    local startScore = current.GetEnergyScore()
    local newScore
	local BandStrength = 0.08
  
    band.DeleteAll()
    selection.DeselectAll()
    for i=0, numSegments/Diff do
      for j=i+1, numSegments/Diff do
        if Start+i*Diff <= numSegments and Start+j*Diff <= numSegments then
          band.AddBetweenSegments(Start+i*Diff,Start+j*Diff)
        end
      end
    end
    selection.SelectAll()
    while math.abs(current.GetEnergyScore() - startScore)<=Delta do
      set_bands(BandStrength)
      structure.WiggleAll(1)
      BandStrength = BandStrength + 0.03
    end
    band.DeleteAll()
	StepC(-1,1,0,15)
	StepC(-1,0,1,5)
    newScore = current.GetEnergyScore()
    if Clashing < 1 then 
	  StepC(Clashing,0,0,1)
	  StepC(1,1,0,10)
	  StepC(1,0,1,5)
    end
    if current.GetEnergyScore()>newScore then newScore = current.GetEnergyScore() end
    print(Start .. ":" .. Diff .. ", score: " .. newScore .. ", gain: " .. newScore - startScore)
  end

  for i=1, Length-1 do
    quake_one(i,Length,ScoreDelta,Clashing)
    recentbest.Restore()
    band.DeleteAll()
    recentbest.Save()
  end
end


-- Sidechain Test.

function sidechain_shock(Seg)
  local SnapCnt = rotamer.GetCount(Seg)
  local startScore = current.GetEnergyScore()

  print("Segment: " .. Seg .. ", snaps: " .. SnapCnt .. ", start: " .. current.GetEnergyScore())
  save.Quicksave(100)
  for i=1, SnapCnt do
    save.Quickload(100)
    rotamer.SetRotamer(Seg,i)
    if SnapCnt > 2 and current.GetEnergyScore ~= startScore then
      selection.DeselectAll()
      selection.Select(Seg)
      structure.LocalWiggleSelected(20)
      structure.WiggleAll(10)
      structure.ShakeSidechainsAll(1)
      selection.DeselectAll()
      selection.Select(Seg)
      structure.LocalWiggleSelected(20)
      selection.DeselectAll()
	  StepC(-1,0,1,10)
      structure.WiggleAll(10,false,true)
    end
    print(Seg .. "/" .. structure.GetCount() .. ", " .. i .. "/" .. SnapCnt .. ", score: " ..  current.GetEnergyScore() .. ", gain: " .. current.GetEnergyScore()-startScore)
  end
end

function sidechain_test_all()
  for j=1, structure.GetCount() do
    recentbest.Save()
    if rotamer.GetCount(j) > 2 then sidechain_shock(j) end
    recentbest.Restore()
  end
end

function sidechain_test_random(numSegments)
  for j=1, numSegments do
    recentbest.Save()
	segmentNumber = math.random(1,structure.GetCount())
    if rotamer.GetCount(segmentNumber) > 2 then sidechain_shock(segmentNumber) end
    recentbest.Restore()
  end
end


-- Mutate.

function mutate(Shk, Num)
  if Shk==1 then structure.ShakeSidechainsAll(Num) end
  if Shk==2 then structure.MutateSidechainsAll(Num) end
end


-- Mutate and Test.

function Mutate_And_Test(RunFunction,NumTries)

  local function mutate_and_test_1(n,Clashing,IsAll,Num)
    local startScore = current.GetEnergyScore()
    structure.SetAminoAcid(n,fsl.aminos[Num][fsl.aminosLetterIndex])
    structure.ShakeSidechainsAll(1)
	StepC(Clashing,0,0,10)
    behavior.SetClashImportance(1)
    if math.abs(current.GetEnergyScore()-startScore) > 0.003 then
      if IsAll == 0 then 
        selection.DeselectAll()
        selection.Select(n)
        structure.MutateSidechainsSelected(1)
      else structure.MutateSidechainsAll(1)
      end
    structure.WiggleAll(10)
    end
  end

  local function full_1_step(Clashing)
    local sOutput = ""
    local startScore
    for i = 1, #mutable do
      for j = 1, 20 do
        startScore = current.GetEnergyScore()
        sOutput = ""
        mutate_and_test_1(mutable[i],Clashing,0,j)
        sOutput = mutable[i] .. "_" .. fsl.aminos[j][fsl.aminosLetterIndex] .. ": " .. current.GetEnergyScore()
        recentbest.Restore()
        if current.GetEnergyScore() > startScore + 0.0001 then 
          sOutput = sOutput .. ", +" .. current.GetEnergyScore() - startScore
        end
      print(sOutput)
      end
    end
  end

  local function full_2_step(Clashing)
    local sOutput = ""
    local sOutputAdd = ""
    local startScore
    
    for i1 = 1, #mutable-1 do
      for j1 = 1, 20 do
        sOutput = mutable[i1] .. "_" .. fsl.aminos[j1][fsl.aminosLetterIndex] .. " + "
        for i2 = i1+1, #mutable do
          for j2 = 1, 20 do
            startScore = current.GetEnergyScore()
            structure.SetAminoAcid(i1,fsl.aminos[j1][fsl.aminosLetterIndex])
            mutate_and_test_1(mutable[i2],Clashing,0,j2)
            sOutputAdd = mutable[i2] .. "_" .. fsl.aminos[j2][fsl.aminosLetterIndex] .. ": " .. current.GetEnergyScore()
            recentbest.Restore()
            if current.GetEnergyScore() > startScore + 0.0001
            then 
              sOutputAdd = sOutputAdd .. ", +" .. current.GetEnergyScore() - startScore
            end
            print(sOutput .. sOutputAdd)
          end
        end
      end
    end
  end

  function random_2_step(Clashing,NumTries)
    local sOutput = ""
    local sOutputAdd = ""
    local startScore
    local Step = 1
    
    NumTries=NumTries+0 -- Type conversion?
    
    while Step <= NumTries do
      startScore = current.GetEnergyScore()
      i1 = math.random(#mutable)
      j1 = math.random(20)
      sOutput = mutable[i1] .. "_" .. fsl.aminos[j1][fsl.aminosLetterIndex] .. " + "
      i2 = math.random(#mutable)
      j2 = math.random(20)
      structure.SetAminoAcid(i1,fsl.aminos[j1][fsl.aminosLetterIndex])
      mutate_and_test_1(mutable[i2],Clashing,Step%2,j2)
      sOutputAdd = mutable[i2] .. "_" .. fsl.aminos[j2][fsl.aminosLetterIndex] .. ": " .. current.GetEnergyScore()
      recentbest.Restore()
      if current.GetEnergyScore() > startScore + 0.0001
      then 
        sOutputAdd = sOutputAdd .. ", +" .. current.GetEnergyScore() - startScore
      end
    Step = Step + 1
    print(sOutput .. sOutputAdd)
    end
  end
  
  mutable = {}
  local Clashing = 0.9

  for i=1, structure.GetCount() do
    if structure.IsMutable(i) then mutable[#mutable+1]=i end
  end
  
  RunFunction = RunFunction + 0 -- Type conversion?
  
  if RunFunction == 1 then full_1_step(Clashing) end
  if RunFunction == 2 then full_2_step(Clashing) end
  if RunFunction == 3 then random_2_step(Clashing,NumTries) end
  
end


-- New Mutate.

function new_mutate(Num)
  structure.SetAminoAcid(Num,fsl.aminos[1][1])
  newScore = current.GetEnergyScore()
  bestAcid = fsl.aminos[1][1]
  for i=2, #fsl.aminos do
    structure.SetAminoAcid(Num,fsl.aminos[i][1])
    if current.GetEnergyScore() > newScore then
      newScore = current.GetEnergyScore()
      bestAcid = fsl.aminos[i][1]
    end
  end
structure.SetAminoAcid(Num,bestAcid)
end

function new_mutate_all()
    mutable = {}
    for i=1, structure.GetCount() do
      if structure.IsMutable(i) then mutable[#mutable+1]=i end
    end	
    for j=1, #mutable do
      new_mutate(mutable[j])
      recentbest.Restore()
      print(mutable[j].."_"..structure.GetAminoAcid(mutable[j])..", score: "..current.GetEnergyScore())
    end
end


-- Rebuilder.

function rebuilder(startSegm,endSegm,Clashing,RebuildTries)
  local Step = 1
  local sOutput = ""
  local segsForRebuild = {}
  local startScore = current.GetEnergyScore()

  for i = math.max(startSegm,1), math.min(endSegm,structure.GetCount()) do segsForRebuild[#segsForRebuild + 1] = i end
  RebuildTries = RebuildTries + 0 -- Type conversion?
  while Step <= RebuildTries do
    selection.DeselectAll()
    for i=1, #segsForRebuild do selection.Select(segsForRebuild[i]) end
    for i=1,10 do
      if math.abs(current.GetEnergyScore()-startScore) < 0.05 then structure.RebuildSelected(i) end
    end
    if math.abs(current.GetEnergyScore()-startScore) > 0.05 then
	  StepC(-1,1,0,15)
      structure.ShakeSidechainsAll(1)
      structure.WiggleSelected(15)
      structure.WiggleAll(15)
      if Clashing < 1 then
		StepC(Clashing,0,0,4)
		StepC(1,1,0,15)
		StepC(1,0,1,10)
      end
    end
    sOutput = Step .." Try " .. ", " .. segsForRebuild[1] .. "-" .. segsForRebuild[#segsForRebuild] .. ", score: " .. current.GetEnergyScore()
    if current.GetEnergyScore()-startScore > 0.0001 then sOutput = sOutput .. ", +" .. current.GetEnergyScore() - startScore end
    print(sOutput)
    Step = Step + 1
    recentbest.Restore()
    startScore = current.GetEnergyScore()
  end
end


-- Sidechain Flip.

function sidechain_flip_all()
  
  local function sidechain_flip(Seg)
    local SnapCnt = rotamer.GetCount(Seg)
    for i=1, SnapCnt do
      rotamer.SetRotamer(Seg,i)
    end
  end

  local startScore = current.GetEnergyScore()
  for j=1, structure.GetCount() do
    recentbest.Save()
    startScore = current.GetEnergyScore()
    if rotamer.GetCount(j) > 2 then sidechain_flip(j) end
    recentbest.Restore()
    print(j .. "/" .. structure.GetCount() .. " (" .. rotamer.GetCount(j) .. "), score: " ..  current.GetEnergyScore() .. ", gain: " .. current.GetEnergyScore()-startScore)
  end
end


-- MicroIdealize.

function micro_idealize(Length,Clashing,NumSegsForIdealize)

  local function Worst_Segments(Length)
  
    local function Sort(tab)
        for x=1,#tab-1 do
            for y=x+1,#tab do
                if tab[x][3]>tab[y][3] then
                    tab[x],tab[y]=tab[y],tab[x]
                end
            end
        end
        return tab
    end
  
    local segsInfo = {}
    for i=1, structure.GetCount()-Length+1 do
      segsInfo[i]={i,i+Length-1,current.GetSegmentEnergySubscore(i,"Ideality")}
      for j=2, Length do
        segsInfo[i]={segsInfo[i][1],segsInfo[i][2],segsInfo[i][3] + current.GetSegmentEnergySubscore(i+j-1,"Ideality")}
      end
    end
    segsInfo = Sort(segsInfo)
    return segsInfo
  end

  local NumSegs = structure.GetCount()
  local WorstSegs = Worst_Segments(Length)
  local segsForIdealize = {}
  local startScore = current.GetEnergyScore()

  for i=1,math.min(#WorstSegs,NumSegsForIdealize) do
    save.Quicksave(100)
    segsForIdealize = {}
    selection.DeselectAll()
    for j=math.max(WorstSegs[i][1]-1,1), math.min(WorstSegs[i][2]+1,NumSegs) do segsForIdealize[#segsForIdealize + 1] = j end
    startScore = current.GetEnergyScore()

    if segsForIdealize[1] > 1 then structure.InsertCut(segsForIdealize[1]) end
    if segsForIdealize[#segsForIdealize] < NumSegs then structure.InsertCut(segsForIdealize[#segsForIdealize]) end
    selection.DeselectAll()
    selection.SelectRange(segsForIdealize[1],segsForIdealize[#segsForIdealize])
    structure.IdealizeSelected()
    if segsForIdealize[1] > 1 then structure.DeleteCut(segsForIdealize[1]) end
    if segsForIdealize[#segsForIdealize] < NumSegs then structure.DeleteCut(segsForIdealize[#segsForIdealize]) end
    
	SphereSelect(segsForIdealize[1],segsForIdealize[#segsForIdealize],10)
	
    --structure.ShakeSidechainsAll(1)
    structure.WiggleSelected(12)
	NumSegsForIdealize = NumSegsForIdealize + 0
	
    if Clashing < 1 and NumSegsForIdealize < NumSegs/2 then
	  StepC(Clashing,0,0,4)
	  StepC(1,1,0,15)
	  StepC(1,0,1,10)
    end

    recentbest.Restore()
    -- Block to check if Recent Best score without cuts:
    local tempScore = current.GetEnergyScore()
    if segsForIdealize[1] > 1 then structure.DeleteCut(segsForIdealize[1]) end
    if segsForIdealize[#segsForIdealize] < NumSegs then structure.DeleteCut(segsForIdealize[#segsForIdealize]) end
    if tempScore == current.GetEnergyScore() then recentbest.Restore() else save.Quickload(100) recentbest.Save() end
    -- End of block

    selection.DeselectAll()
    print(i .."/".. math.min(#WorstSegs,NumSegsForIdealize) .. "; " .. segsForIdealize[1] .. "-" .. segsForIdealize[#segsForIdealize] .. ", score: " ..math.max(startScore,current.GetEnergyScore()) .. ", gain: " .. math.max(0,current.GetEnergyScore()-startScore))
  end
  
end


-- MicroRemix.

function micro_remix(Length,Clashing,NumsegsForRemix)

  local function Worst_Segments(Length)
  
    local function Sort(tab)
        for x=1,#tab-1 do
            for y=x+1,#tab do
                if tab[x][3]>tab[y][3] then
                    tab[x],tab[y]=tab[y],tab[x]
                end
            end
        end
        return tab
    end
  
    local segsInfo = {}
    for i=1, structure.GetCount() - Length + 1 do
      segsInfo[i] = {i,i+Length-1,current.GetSegmentEnergyScore(i)}
      for j=2, Length do
        segsInfo[i] = {segsInfo[i][1],segsInfo[i][2],segsInfo[i][3] + current.GetSegmentEnergyScore(i+j-1)}
      end
    end
    segsInfo = Sort(segsInfo)
    return segsInfo
  end

  local NumSegs = structure.GetCount()
  local WorstSegs = Worst_Segments(Length + 1)
  local segsForRemix = {}
  local startScore = current.GetEnergyScore()
  local ScoreBeforeRemix
  local ScoreAfterRemix

  for i=1,math.min(#WorstSegs,NumsegsForRemix) do
    save.Quicksave(100)
    segsForRemix = {}
    selection.DeselectAll()
    for j=math.max(WorstSegs[i][1]-1,1), math.min(WorstSegs[i][2]+1,NumSegs) do segsForRemix[#segsForRemix + 1] = j end
    startScore = current.GetEnergyScore()

    if segsForRemix[1] > 1 then structure.InsertCut(segsForRemix[1]) end
    if segsForRemix[#segsForRemix] < NumSegs then structure.InsertCut(segsForRemix[#segsForRemix]) end
    selection.DeselectAll()
    selection.SelectRange(segsForRemix[3],segsForRemix[#segsForRemix-1])

	ScoreBeforeRemix = current.GetEnergyScore()
	structure.RemixSelected()
	ScoreAfterRemix = current.GetEnergyScore()
	if math.abs(ScoreAfterRemix - ScoreBeforeRemix) > 0.0001 then
      if segsForRemix[1] > 1 then structure.DeleteCut(segsForRemix[1]) end
      if segsForRemix[#segsForRemix] < NumSegs then structure.DeleteCut(segsForRemix[#segsForRemix]) end
    
	  SphereSelect(segsForRemix[1],segsForRemix[#segsForRemix],10)
      structure.ShakeSidechainsAll(1)
      structure.WiggleSelected(12)
	  NumsegsForRemix = NumsegsForRemix + 0
      if Clashing < 1 and NumsegsForRemix < NumSegs/2 then
	    StepC(Clashing,0,0,4)
	    StepC(1,1,0,15)
	    StepC(1,0,1,10)
      end
    end
	
    recentbest.Restore()
    -- Block to check if Recent Best score without cuts:
    local tempScore = current.GetEnergyScore()
    if segsForRemix[1] > 1 then structure.DeleteCut(segsForRemix[1]) end
    if segsForRemix[#segsForRemix] < NumSegs then structure.DeleteCut(segsForRemix[#segsForRemix]) end
    if tempScore == current.GetEnergyScore() then recentbest.Restore() else save.Quickload(100) recentbest.Save() end
    -- End of block

    selection.DeselectAll()
    print(i .."/".. math.min(#WorstSegs,NumsegsForRemix) .. "; " .. segsForRemix[3] .. "-" .. segsForRemix[#segsForRemix-1] .. ", score: " ..math.max(startScore,current.GetEnergyScore()) .. ", gain: " .. math.max(0,current.GetEnergyScore()-startScore))
  end
  
end

---------------------------------------------------------------
---------------------      MAIN PROGRAM     -------------------
---------------------------------------------------------------


recentbest.Save()
startScore = current.GetEnergyScore()
startTime = os.time()
math.randomseed(startTime)

-- Check if puzzle is mutable.
puzzleMutable = false
for i=1, structure.GetCount() do
  if structure.IsMutable(i) then puzzleMutable = true end
end


local ask = dialog.CreateDialog("All in One.")
ask.LabelRow000 = dialog.AddLabel("Please choose the script to run:")
ask.LabelRow001 = dialog.AddLabel("1.  BlueFuze.")
ask.LabelRow002 = dialog.AddLabel("2.  Clashing.")
ask.LabelRow003 = dialog.AddLabel("3.  FastRelax.")
ask.LabelRow004 = dialog.AddLabel("4.  WS or SW.")
ask.LabelRow005 = dialog.AddLabel("5.  Band Test.")
ask.LabelRow006 = dialog.AddLabel("6.  Local Wiggle.")
ask.LabelRow007 = dialog.AddLabel("7.  Local Rebuild.")
ask.LabelRow008 = dialog.AddLabel("8.  Rebuild Worst.")
ask.LabelRow009 = dialog.AddLabel("9.  Quake.")
ask.LabelRow010 = dialog.AddLabel("10. Sidechain Test.")
ask.LabelRow011 = dialog.AddLabel("11. Mutate.")
ask.LabelRow012 = dialog.AddLabel("12. Mutate and Test.")
ask.LabelRow013 = dialog.AddLabel("13. New Mutate.")
ask.LabelRow014 = dialog.AddLabel("14. Rebuilder.")
ask.LabelRow015 = dialog.AddLabel("15. Sidechain Flipper.")
ask.LabelRow016 = dialog.AddLabel("16. SoftRelax.")
ask.LabelRow017 = dialog.AddLabel("17. MicroIdealize.")
ask.LabelRow018 = dialog.AddLabel("18. MicroRemix.")
ask.LabelRow019 = dialog.AddLabel("19. Autobot.")
ask.Script = dialog.AddSlider("Function to run:", 19, 1, 19, 0)
ask.OK = dialog.AddButton("OK", 1)
ask.Cancel = dialog.AddButton("Cancel", 0)
ask.About = dialog.AddButton("About", 2)

DialogResult = dialog.Show(ask)
ScriptNumber = ask.Script.value

if (DialogResult == 1) then

  if (ScriptNumber == 1) then
    print("Start score: "..startScore)
    recipe.SectionStart("BlueFuze")
    BlueFuze()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 2) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Clashing.")
    ScriptAsk.Repeat = dialog.AddCheckbox("Repeat when gain score", false)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)

    ScriptDialogResult = dialog.Show(ScriptAsk)
    if ScriptAsk.Repeat.value==true then Repeat=1 else Repeat=0 end

    print("Start score: "..startScore)
    recipe.SectionStart("Clashing")
    clashing(Repeat)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 3) then
    print("Start score: "..startScore)
    recipe.SectionStart("FastRelax")
    FastRelaxFull()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 4) then
    params = {
    1, -- WS
    1, -- SW
    1, -- WS_0.5
    1  -- WS Step
    }
    print("Start score: "..startScore)
    recipe.SectionStart("WS or SW")
    ws_or_sw(params)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 5) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Band Test.")
    ScriptAsk.Start_LengthP = dialog.AddSlider("Start Length (percents):", 90, 10, 300, 0)
    ScriptAsk.End_LengthP = dialog.AddSlider("Start Length (percents):", 110, 10, 300, 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.5, 0, 1, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    Start_LengthP = ScriptAsk.Start_LengthP.value
    End_LengthP = ScriptAsk.End_LengthP.value
    Clashing = ScriptAsk.Clashing.value

    print("Start score: "..startScore)

    Iteration = 1
    while Iteration>0 do
      Band_tests(Start_LengthP,End_LengthP,Clashing,Iteration,0)
      Iteration = Iteration + 1
    end

  elseif (ScriptNumber == 6) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Local Wiggle.")
    ScriptAsk.Length = dialog.AddSlider("Segment Length", 7, 1, structure.GetCount()/2, 0)
    ScriptAsk.Wig_Num = dialog.AddSlider("Number of Wiggles", 2, 1, 30, 0)
    ScriptAsk.TotalWiggle = dialog.AddCheckbox("Total wiggle", false)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    Length = ScriptAsk.Length.value
    Wig_Num = ScriptAsk.Wig_Num.value
    TotalWiggle = ScriptAsk.TotalWiggle.value

    print("Start score: "..startScore)
    recipe.SectionStart("Local Wiggle")
    if TotalWiggle then 
      Length=15
      for i=Length,1,-1 do local_wiggle(i,Wig_Num) end
      else local_wiggle(Length,Wig_Num)
    end
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 7) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Local Rebuild.")
    ScriptAsk.Length = dialog.AddSlider("Segment Length", 3, 1, structure.GetCount()/2, 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    Length = ScriptAsk.Length.value
    Clashing = ScriptAsk.Clashing.value

    print("Start score: "..startScore)
    recipe.SectionStart("Local Rebuild")
    local_rebuild_all(Length,Clashing)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 8) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Rebuild Worst.")
    ScriptAsk.Length = dialog.AddSlider("Segment Length", 1, 1, structure.GetCount()/2, 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.Rebuilds = dialog.AddSlider("Rebuild tries", 3, 1, 100, 0)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    Length = ScriptAsk.Length.value
    Clashing = ScriptAsk.Clashing.value
    RebuildsTries = ScriptAsk.Rebuilds.value

    print("Start score: "..startScore)
    recipe.SectionStart("Rebuild Worst")
    RebuildWorst(Length,RebuildsTries,Clashing,100)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 9) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Quake.")
    ScriptAsk.Length = dialog.AddSlider("Segment Length", 15, 1, structure.GetCount()/2, 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.ScoreDelta = dialog.AddSlider("ScoreDelta", 15, 0, 200, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    Length = ScriptAsk.Length.value
    Clashing = ScriptAsk.Clashing.value
    ScoreDelta = ScriptAsk.ScoreDelta.value

    print("Start score: "..startScore)
    recipe.SectionStart("Quake")
    quake(Length,ScoreDelta,Clashing)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 10) then
    print("Start score: "..startScore)
    recipe.SectionStart("Sidechain Test")
    sidechain_test_all()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 11) then
    Shake_Type = 2  -- 1: Shake, 2: Mutate
    Shake_times = 1 -- Number of shake times

    print("Start score: "..startScore)
    recipe.SectionStart("Mutate")
    mutate(Shake_Type,Shake_times)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 12) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. Mutate and Test.")
    ScriptAsk.RunFunction = dialog.AddSlider("Function to run:", 3, 1, 3, 0)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    RunFunction = ScriptAsk.RunFunction.value

    print("Start score: "..startScore)
    recipe.SectionStart("Mutate and Test")
    Mutate_And_Test(RunFunction,10000)
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 13) then
    print("Start score: "..startScore)
    recipe.SectionStart("New Mutate")
    new_mutate_all()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 14) then

    ScriptAsk = dialog.CreateDialog("Script Dialog. Rebuilder.")
    ScriptAsk.startSegm = dialog.AddSlider("Start segment", 1, 1, structure.GetCount()-1, 0)
    ScriptAsk.endSegm = dialog.AddSlider("End segment", 2, 2, structure.GetCount(), 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    startSegm = ScriptAsk.startSegm.value
    endSegm = ScriptAsk.endSegm.value
    Clashing = ScriptAsk.Clashing.value

    if startSegm>endSegm 
    then 
      print("Start segment should be no more than End segment")
    else
      print("Start score: "..startScore)
      recipe.SectionStart("Rebuilder")
      rebuilder(startSegm,endSegm,Clashing,10000)
      p_Time(startTime,recipe.SectionEnd())
    end

  elseif (ScriptNumber == 15) then
    print("Start score: "..startScore)
    recipe.SectionStart("Sidechain Flipper")
    sidechain_flip_all()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 16) then
    print("Start score: "..startScore)
    recipe.SectionStart("SoftRelax")
    SoftRelaxFull()
    p_Time(startTime,recipe.SectionEnd())

  elseif (ScriptNumber == 17) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. MicroIdealize.")
    ScriptAsk.lengthSegm = dialog.AddSlider("Segment Length", 3, 1, structure.GetCount()-1, 0)
    ScriptAsk.numSegments = dialog.AddSlider("Number of segments", 5, 1, structure.GetCount(), 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    lengthSegm = ScriptAsk.lengthSegm.value
    numSegments = ScriptAsk.numSegments.value
    Clashing = ScriptAsk.Clashing.value

    print("Start score: "..startScore)
    recipe.SectionStart("MicroIdealize")
    micro_idealize(lengthSegm,Clashing,numSegments)
    p_Time(startTime,recipe.SectionEnd())
  elseif (ScriptNumber == 18) then
    ScriptAsk = dialog.CreateDialog("Script Dialog. MicroRemix.")
    ScriptAsk.lengthSegm = dialog.AddSlider("Segment Length", 4, 4, structure.GetCount()-1, 0)
    ScriptAsk.numSegments = dialog.AddSlider("Number of segments", 5, 1, structure.GetCount(), 0)
    ScriptAsk.Clashing = dialog.AddSlider("Clashing", 0.6, 0, 1, 1)
    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    lengthSegm = ScriptAsk.lengthSegm.value
    numSegments = ScriptAsk.numSegments.value
    Clashing = ScriptAsk.Clashing.value

    print("Start score: "..startScore)
    recipe.SectionStart("MicroRemix")
    micro_remix(lengthSegm,Clashing,numSegments)
    p_Time(startTime,recipe.SectionEnd())
  elseif (ScriptNumber == 19) then

    ScriptAsk = dialog.CreateDialog("Script Dialog. Autobot.")
    ScriptAsk.RestartGain = dialog.AddSlider("Score threshold:", 2.0, 0, 100, 1)

    if puzzleMutable == true 
      then ScriptAsk.Sequence = dialog.AddTextbox("Sequence:", SequenceStrPredefined2)
      else ScriptAsk.Sequence = dialog.AddTextbox("Sequence:", SequenceStrPredefined1)
    end
    ScriptAsk.IsReset = dialog.AddCheckbox("Reset puzzle on Start", false)
    ScriptAsk.IsFreeStyle = dialog.AddCheckbox("Freestyle puzzle start", false)
    ScriptAsk.SequenceNumber = dialog.AddSlider("Sequence to run:", 1, 1, 5, 0)
    ScriptAsk.LabelRow000 = dialog.AddLabel("1. Default from TextBox.")
    ScriptAsk.LabelRow001 = dialog.AddLabel("2. Predefined (common).")
    ScriptAsk.LabelRow002 = dialog.AddLabel("3. Predefined (for mutable)")
    ScriptAsk.LabelRow003 = dialog.AddLabel("4. Predefined (for multistart)")
	ScriptAsk.LabelRow004 = dialog.AddLabel("5. Predefined (for endgame death)")

    ScriptAsk.OK = dialog.AddButton("OK", 1)
    ScriptAsk.Cancel = dialog.AddButton("Cancel", 0)
    ScriptDialogResult = dialog.Show(ScriptAsk)

    RestartGain = ScriptAsk.RestartGain.value
    SequenceNumber = ScriptAsk.SequenceNumber.value

          if SequenceNumber == 1 then SequenceStr = ScriptAsk.Sequence.value
      elseif SequenceNumber == 2 then SequenceStr = SequenceStrPredefined1
      elseif SequenceNumber == 3 then SequenceStr = SequenceStrPredefined2
      elseif SequenceNumber == 4 then SequenceStr = SequenceStrPredefined3
	  elseif SequenceNumber == 5 then SequenceStr = SequenceStrPredefined4
    end

    local Sequence = {}
    local i=0

    for Script in string.gmatch(SequenceStr, "[%w_]+%.") do
       i=i+1
       Sequence[i] = {}
       Sequence[i][1] = string.sub(Script,1,2)

       local j=1
       for ScriptParam in string.gmatch(string.sub(Script,4), "%w+[_%.]") do
         j=j+1
         Sequence[i][j] = string.sub(ScriptParam,1,string.len(ScriptParam)-1)
       end

     end

    print("The Sequence.")
    for i=1,#Sequence do
          if Sequence[i][1] == "CL" then print(i..": Clashing")
      elseif Sequence[i][1] == "FR" then print(i..": FastRelax")
      elseif Sequence[i][1] == "BF" then print(i..": BlueFuze")
      elseif Sequence[i][1] == "WS" then print(i..": WS or SW")
      elseif Sequence[i][1] == "BT" then print(i..": Band Test,"..Sequence[i][2]..","..Sequence[i][3]..","..Sequence[i][4])
      elseif Sequence[i][1] == "LW" then print(i..": Local Wiggle,"..Sequence[i][2]..","..Sequence[i][3])
      elseif Sequence[i][1] == "LR" then print(i..": Local Rebuild,"..Sequence[i][2]..","..Sequence[i][3])
      elseif Sequence[i][1] == "QU" then print(i..": Quake,"..Sequence[i][2])
      elseif Sequence[i][1] == "ST" then print(i..": Sidechain Test,"..Sequence[i][2])
      elseif Sequence[i][1] == "MU" then print(i..": Mutate")
      elseif Sequence[i][1] == "MT" then print(i..": Mutate and Test,"..Sequence[i][2]..","..Sequence[i][3])
      elseif Sequence[i][1] == "NM" then print(i..": New Mutate")
      elseif Sequence[i][1] == "RE" then print(i..": Rebuilder,"..Sequence[i][2]..","..Sequence[i][3]..","..Sequence[i][4])
      elseif Sequence[i][1] == "SF" then print(i..": Sidechain Flipper")
      elseif Sequence[i][1] == "SR" then print(i..": Soft Relax")
      elseif Sequence[i][1] == "RW" then print(i..": Rebuild Worst,"..Sequence[i][2]..","..Sequence[i][3]..","..Sequence[i][4])
      elseif Sequence[i][1] == "MI" then print(i..": MicroIdealize,"..Sequence[i][2]..","..Sequence[i][3])
	  elseif Sequence[i][1] == "MR" then print(i..": MicroRemix,"..Sequence[i][2]..","..Sequence[i][3])
      else print(i..": UNKNOWN")
      end
    end	

    print("Start score: "..startScore)
    p_Time(startTime,0)

    save.Quicksave(99)
    Iteration = 1

    while Iteration < 99 do
      print("Start of Iteration: "..Iteration)
      if (ScriptAsk.IsReset.value) 
        then
          puzzle.StartOver()
		  startScore = current.GetEnergyScore()
        else save.Quickload(99)
      end
      recentbest.Save()
      ScoreGain = RestartGain + 1
      step = 1

      if (ScriptAsk.IsFreeStyle.value) 
        then freestyle_starter()
      end

      while ScoreGain >= RestartGain do
        startScoreStep = current.GetEnergyScore()
        startTimeStep = os.time()
        for i=1,#Sequence do
              if Sequence[i][1] == "CL" 
              then 
                recipe.SectionStart("Clashing")
                clashing(0)
          elseif Sequence[i][1] == "FR"  
              then 
                recipe.SectionStart("FastRelax")
                FastRelaxFull()
          elseif Sequence[i][1] == "BF"  
              then 
                recipe.SectionStart("BlueFuze")
                BlueFuze()
          elseif Sequence[i][1] == "WS" 
              then 
                recipe.SectionStart("WS or SW")
                params = {1,1,1,1}
                ws_or_sw(params)
          elseif Sequence[i][1] == "BT" 
              then 
                recipe.SectionStart("Band Test")
                for l=1,Sequence[i][2] do
                  Band_tests(Sequence[i][3],Sequence[i][4],0.5,l,Sequence[i][2])
                end
          elseif Sequence[i][1] == "LW" 
              then 
                recipe.SectionStart("Local Wiggle")
                local_wiggle(Sequence[i][2],Sequence[i][3])
          elseif Sequence[i][1] == "LR" 
              then 
                recipe.SectionStart("Local Rebuild")
                local_rebuild_all(Sequence[i][2],0.6)
          elseif Sequence[i][1] == "QU" 
              then 
                recipe.SectionStart("Quake")
                quake(Sequence[i][2],15,1,0.6)
          elseif Sequence[i][1] == "ST" 
              then 
                recipe.SectionStart("Sidechain Test")
                sidechain_test_random(Sequence[i][2])
          elseif Sequence[i][1] == "MU" 
              then 
                recipe.SectionStart("Mutate")
                mutate(2,1)
          elseif Sequence[i][1] == "MT" 
              then 
                recipe.SectionStart("Mutate and Test")
                Mutate_And_Test(Sequence[i][2],Sequence[i][3])
          elseif Sequence[i][1] == "NM" 
              then 
                recipe.SectionStart("New Mutate")
                new_mutate_all()
          elseif Sequence[i][1] == "RE" 
              then 
                recipe.SectionStart("Rebuilder")
                rebuilder(Sequence[i][2],Sequence[i][3],0.6,Sequence[i][4])
          elseif Sequence[i][1] == "SF" 
              then 
                recipe.SectionStart("Sidechain Flipper")
                sidechain_flip_all()
          elseif Sequence[i][1] == "SR" 
              then 
                recipe.SectionStart("Soft Relax")
                SoftRelaxFull()
          elseif Sequence[i][1] == "RW" 
              then 
                recipe.SectionStart("Rebuild Worst")
                RebuildWorst(Sequence[i][2],Sequence[i][3],0.6,Sequence[i][4])
          elseif Sequence[i][1] == "MI" 
              then 
                recipe.SectionStart("MicroIdealize")
                micro_idealize(Sequence[i][2],0.6,Sequence[i][3])
          elseif Sequence[i][1] == "MR" 
              then 
                recipe.SectionStart("MicroRemix")
                micro_remix(Sequence[i][2],0.6,Sequence[i][3])
          else 
                recipe.SectionStart("UNKNOWN")
                print(i..": UNKNOWN")
          end
          
          print("Score: "..current.GetEnergyScore()..", +"..recipe.SectionEnd())
          p_Time(startTime,current.GetEnergyScore()-startScore)
        end
        
        ScoreGain = current.GetEnergyScore() - startScoreStep
        print("Iteration: " .. Iteration .. ". Step " .. step .. " ended. gain: " .. ScoreGain)
        p_Time(startTime,current.GetEnergyScore()-startScore)
        step = step + 1
      end
      
      print("End of Iteration: "..Iteration)
	  save.Quicksave(Iteration)
      Iteration = Iteration + 1
      
    end
  
  end
elseif (DialogResult == 2) then
  ScriptAsk = dialog.CreateDialog("About.")
  ScriptAsk.NewLabel = dialog.AddLabel("Made by Grom.")
  ScriptAsk.OK = dialog.AddButton("OK", 1)
  ScriptDialogResult = dialog.Show(ScriptAsk)
end

