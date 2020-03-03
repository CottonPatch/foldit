
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

function CheckCI()
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
SKETCHBOOKPUZZLE=false
Filterscore=Score()
name=puzzle.GetName()
if string.find(name,"Sketchbook") then
 print("SketchbookPuzzle")
 SKETCHBOOKPUZZLE=true
end
print("SKETCHBOOKPUZZLE: " .. tostring(SKETCHBOOKPUZZLE))
if SKETCHBOOKPUZZLE == false then behavior.SetFiltersDisabled(true) end
FilterOffscore=Score()
if SKETCHBOOKPUZZLE == false then behavior.SetFiltersDisabled(false) end
print("Filterscore3: " .. Filterscore)
print("FilterOffscore3: " .. FilterOffscore)
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
    behavior.SetFiltersDisabled(true)
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
    behavior.SetFiltersDisabled(false)
end
print("maxbonus: " .. maxbonus)
Filteractive=(math.abs(maxbonus) > 0.1)
print("Filteractive: " .. tostring(Filteractive))
if Filteractive then
   --Filters active, give people a choice
   --And ask what the maximum bonus is.
   Filter()
end
-- End of module Filteractive
MINGAIN=0
foundahighgain=true
bestScore=Score()
if Filteractive then FilterOff() end
function SaveBest()
  if (not Filteractive) or
     (Score()+maxbonus>bestScore) then
     if Filteractive then FilterOn() end
     local g=Score()-bestScore
     if g>MINGAIN or ( g>0 and foundahighgain) then
        if g>0.01 then print("Gained another "..round3(g).." pts.") end
        bestScore=Score()
        save.Quicksave(3)
 foundahighgain=true
     end
     if Filteractive then FilterOff() end
  end
end

WF=1 -- New WiggleFactor
function Wiggle(how, iters, minppi,onlyselected)
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

    --if iters>0 then
        --iters=iters-1
        local sp=Score()
        if onlyselected then
            if how == "s" then
                -- Shake is not considered to do much in second or more rounds
                structure.ShakeSidechainsSelected(1)
                return
            elseif how == "wb" then structure.WiggleSelected(2*wf*iters,true,false)
            elseif how == "ws" then structure.WiggleSelected(2*wf*iters,false,true)
            elseif how == "wa" then structure.WiggleSelected(2*wf*iters,true,true)
            end
        else
            if how == "s" then
                -- Shake is not considered to do much in second or more rounds
                structure.ShakeSidechainsAll(1)
                return
            elseif how == "wb" then structure.WiggleAll(2*wf*iters,true,false)
            elseif how == "ws" then structure.WiggleAll(2*wf*iters,false,true)
            elseif how == "wa" then structure.WiggleAll(2*wf*iters,true,true)
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
function GetSubscore(types,seg1,seg2,pose)
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

function FindActiveSubscores(show)
    local result={}
    local Subs=puzzle.GetPuzzleSubscoreNames()
    local Showlist ="Computing Active Subscores"
    if show then print(Showlist) end
    for i=1,#Subs do
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
function GetRB(prefun,postfun)
    if RBScore()> Score() then
        if prefun ~= nil then prefun() end
        recentbest.Restore()
        if postfun ~= nil then postfun() end
    end
end

function FuzeEnd(prefun,postfun)
    if prefun ~= nil then prefun() end
    CI(1)
-- Wiggle("wa",1)
-- Wiggle("s",1)
    Wiggle()
    GetRB(prefun,postfun)
    if postfun ~= nil then postfun() end
    SaveBest()
end

function Fuze1(ci1,ci2,prefun,postfun,globshake)
    if prefun ~=nil then prefun() end
    if globshake==nil then globshake=true end
    CI(ci1)
    Wiggle("s",1,nil,globshake)
    CI(ci2)
    Wiggle("wa",1)
    if postfun ~= nil then postfun() end
end

function Fuze2(ci1,ci2,prefun,postfun)
    if prefun ~= nil then prefun() end
    CI(ci1)
    Wiggle("wa",1)
    CI(1)
    Wiggle("wa",1)
    CI(ci2)
    Wiggle("wa",1)
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
    Fuze1(0.3,0.6,prefun,postfun,globshake) FuzeEnd(prefun,postfun)
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
function SetSelection(set)
    selection.DeselectAll()
    if set ~= nil then for i=1,#set do
        selection.SelectRange(set[i][1],set[i][2])
    end end
end

function SelectAround(ss,se,radius,nodeselect)
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
function AllLoop() --turning entire structure to loops
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

function qStab()
    -- Do not accept qstab losses
    local curscore=Score()
    PushPosition()
    CI(0.1)
    Wiggle("s",1,nil,true) --shake only selected part
    if InQstab then
        CI(1)
        doMutate()
    end
    if fastQstab==false then
        CI(0.4)
        Wiggle("wa",1)
        CI(1)
        Wiggle("s",1,nil,localshakes)
    end
    CI(1)
    recentbest.Save()
    Wiggle()
    recentbest.Restore()
    if Score() < curscore then PopPosition() else ClrTopPosition() end
end

function Cleanup(err)
    print("Restoring CI, initial selection, best result and structures")
    CI(1)
    save.Quickload(3)

    if Filteractive then FilterOn() end
    if SAVEDstructs==true then save.LoadSecondaryStructure() end
    selection.DeselectAll()
    if SAFEselection ~= nil then SetSelection(SAFEselection) end
    print(err)
end

-- Module AskSelections
function AskForSelections(title,mode)
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
function Sort(tab,items) --BACWARD bubble sorting - lowest on top, only needed items
    for x=1,items do --items do
        for y=x+1,#tab do
            if tab[x][1]>tab[y][1] then
                tab[x],tab[y]=tab[y],tab[x]
            end
        end
    end
    return tab
end

function AddDone(first,last)
    if donotrevisit then
        Donepart[first+(last-first)*segCnt2]=true
        Blocked[#Blocked+1]=first+(last-first)*segCnt2
    end
    if disjunct then
        for i=first,last do Disj[i]=true end
    end
end

function CheckDone(first,last)
    if not donotrevisit then return false end
    local result=Donepart[first+(last-first)*segCnt2]
    if disjunct then
        for i=first,last do if Disj[i] then result=true end end
    end
    return result
end

function ChkDisjunctList(n)
    if not disjunct then return end
    local maxlen=0
    for i=1,segCnt2 do
        if Disj[i] then maxlen=0 else maxlen=maxlen+1 end
        if maxlen == n then return end
    end
    -- No part is big enough so clear Disjunctlist
    print("Clearing disjunct list")
    for i=1,segCnt2 do
        Disj[i]=false
    end
end

function ClearDoneList()
    --clear donelist
    for i=1,#Blocked do Donepart[Blocked[i]]=false end
    if disjunct then
        --clear disjunctlist also
        for i=1,segCnt2 do Disj[i]=false end
    end
    Blocked={}
    curclrscore=Score()
end

function ChkDoneList()
    if not donotrevisit and not disjunt then return end
    if Score() > curclrscore+clrdonelistgain then
        if donotrevisit then ClearDoneList() end
    end
end
--end of administration part
function FindWorst(firsttime)
    print("Searching worst scoring parts of len "..len)
    ChkDisjunctList(len)
    wrst={}
    GetSegmentScores()
    local skiplist=""
    local nrskip=0
    for i=1,segCnt2-len+1 do
        if not CheckDone(i,i+len-1) and MustWorkon(i,i+len-1)
        then
            local s=getPartscore(i,i+len-1)
            wrst[#wrst+1]={s,i}
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
    wrst=Sort(wrst,reBuild)
    areas={}
    local rb=reBuild
    if rb>#wrst then rb=#wrst end
    for i=1,rb do
        local w=wrst[i]
        local ss=w[2]
        areas[#areas+1]={ss,ss+len-1}
    end
    if firsttime and #wrst == 0 then
        print("No possibilities left so clearing Done list")
        ClearDoneList()
        FindWorst(false)
    end
end

-- Rebuild section
function localRebuild(maxiters)
    if maxiters==nil then maxiters=3 end
    local s=Score()
    local i=0
    if bandflip then band.DisableAll() end
    Bridgesave()
    repeat
        i=i+1
        if i>maxiters then break end
        structure.RebuildSelected(i)
    until Score()~=s and BridgesBroken() == false
    if bandflip then band.EnableAll() end
    Bridgerestore()
    if Score()~=s then return true else return false end
end

function ReBuild(ss,se,tries)
    ClearScores() --reset score tables
    if ss>se then ss,se=se,ss end --switch if needed
    local Foundone=false
    for try=1,tries do -- perform loop for number of tries
        if SKETCHBOOKPUZZLE then save.Quickload(3) end
        selection.DeselectAll()
        CI(rebuildCI)
        selection.SelectRange(ss,se)
      -- local extra_rebuilds = 1
      -- if savebridges then extra_rebuilds=3 end --extra if bridges keep breaking
        local done
      -- repeat
            done=localRebuild(try)
      -- extra_rebuilds = extra_rebuilds -1
      -- until done or extra_rebuilds == 0
        SaveBest()
        if done==true then
            Foundone=true
            Bridgesave()
            if doSpecial==true then
                SelectAround(ss,se,9)
                CI(1)
                Wiggle("s",1,nil,true)
                Wiggle("ws",2,nil,true)
                selection.DeselectAll()
                selection.SelectRange(ss,se)
                Wiggle("wb",4,nil,true)
                SelectAround(ss,se,9)
            elseif doShake==true then
                CI(shakeCI)
                Wiggle("s",1,nil,true)
            end
            Bridgerestore()
            if AfterRB then
                PushPosition() --save the current position for next round
                doMutate()
            end
            SaveScores(ss,se,try)
            if AfterRB then PopPosition() end
        end
      -- if (try > 3 or savebridges) and Foundone==false then
          if Foundone==false then
            print("No valid rebuild found on this section")
            print("After 9 or more rebuild attempts, giving up")
            break
        end
    end
    CI(1)
    return Foundone
end
-- end rebuild section
-- section to compute segmentscore(part)s
function getPartscore(ss,se,attr)
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

function InitWORKONbool()
    WORKONbool=SegmentSetToBool(WORKON)
end

function MustWorkon(i,j)
    for k=i,j do if not WORKONbool[k] then return false end end
    return true
end

function GetSegmentScores()
    if lastSegScores~=Score() then
        lastSegScores=Score()
        for i=1,segCnt2 do
            if WORKONbool[i] then
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
Scores={} --{save_no,points,totscore,showlist,todo,rbnr}
-- Compute which scoreparts to use
ActiveSub=
FindActiveSubscores(true)
ScoreParts={ --{save_no,name,active,longname}
    {4,'total',true,'4(total)'},
    {5,'loctotal',true,'5(loctotal)'}
}
nextslot=6
if HASLIGAND then
    ScoreParts[#ScoreParts+1] = { nextslot,'ligand',true,nextslot..'(ligand)'}
    nextslot=nextslot+1
    print("Ligand slot enabled")
end

for i=1,#ActiveSub do
    if ActiveSub[i] ~='Reference' then
        ScoreParts[#ScoreParts+1] = { nextslot,ActiveSub[i],true,nextslot..'('..ActiveSub[i]..')' }
        nextslot=nextslot+1
    end
end

function ClearScores()
    Scores={}
    for i=1,#ScoreParts do
        if ScoreParts[i][3] then
            Scores[#Scores+1]={ScoreParts[i][1],-9999999,-9999999,'',false,-1}
        end
    end
    slotScr={}
end

function SaveScores(ss,se,RBnr)
    local scr={}
    for i=1,#ScoreParts do
        if ScoreParts[i][3] then
            scr[#scr+1]={ScoreParts[i][1],getPartscore(ss,se,ScoreParts[i][2])}
        end
    end
    local totscore=Score()
    for i=1,#Scores do
        local s=scr[i][2]
        if s>Scores[i][2] then
            local slot=scr[i][1]
            save.Quicksave(slot) --print("Saved slot ",slot," pts" ,s) --debug
            Scores[i][2]=s
            Scores[i][3]=totscore
            Scores[i][6]=RBnr
        end
    end
    SaveBest()
end

function ListSlots()
    --Give overview of slot occupation
    --And sets which slots to process
    local Donelist={}
    for i=1,#Scores do Donelist[i]=false end
    local Report=""
    for i=1,#Scores do if not Donelist[i] then
        local Curlist=" "..Scores[i][1]
        Scores[i][5]=true --This one we have to process
        -- Now find identical filled slots
        for j=i+1,#Scores do if Scores[j][3] == Scores[i][3] then
            Curlist=Curlist.."="..Scores[j][1]
            Donelist[j]=true
        end end
        Scores[i][4]=Curlist
        Report=Report.." "..Curlist
    end end
    print("Slotlist:"..Report)
end
-- end of administration of slots and scores
function PrintAreas()
    if #areas<19 then
        local a=""
        local x=0
        for i=1,#areas do
            x=x+1
            a=a..areas[i][1].."-"..areas[i][2].." "
            if x>6 then
                print(a)
                a=""
                x=0
            end
        end
        if x>0 then print(a) end
    else
        print("It is "..#areas.." places, not listing.")
    end
end

function AddLoop(sS)
    local ss=sS
    local ssStart=structure.GetSecondaryStructure(ss)
    local se=ss
    for i=ss+1,segCnt2 do
        if structure.GetSecondaryStructure(i)==ssStart then se=i
        else break end
    end
    if se-ss+2>minLen and loops==true then
        areas[#areas+1]={ss,se}
    end
    return se
end

function AddOther(sS)
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
        areas[#areas+1]={ss,se}
    end
    return se
end
function FindAreas()
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
function MutateSel(maxitter)
    if maxitter == nil then maxitter=2 end
    structure.MutateSidechainsSelected(maxitter)
end

function MutateAll(maxitter)
    selection.SelectAll()
    MutateSel(maxitter)
end

function doMutate()
    if not HASMUTABLE then return end
    -- Do not accept loss if mutating
    local curscore=Score()
    PushPosition()
    CI(MutateCI)
    Bridgesave()
    if MUTRB then
        selection.DeselectAll()
        selection.SelectRange(firstRBseg,lastRBseg)
        MutateSel()
    elseif MUTSur then
        SelectAround(firstRBseg,lastRBseg,MutSphere)
        MutateSel()
    else
        MutateAll()
    end
    Bridgerestore()
    if Score() < curscore then PopPosition() else ClrTopPosition() end
end

function DeepRebuild()
    local ss=Score()
    print("Deep"..action.." started at score: "..round3(ss))
    if struct==false then AllLoop() end
    save.Quicksave(3)
    recentbest.Save()

    for i=1,#areas do
        local ss1=Score()
        local s=areas[i][1]
        local e=areas[i][2]
        local CurrentHigh=0
        local CurrentAll="" -- to report where gains came from
        local CurrentHighScore= -99999999
        firstRBseg=s
        lastRBseg=e
        Bridgesave()
if Runnr > 0 then --Runnr 0 is to skip worst parts
        print("DR "..Runnr.."."..(e-s+1).."."..i.." "..s.."-"..e.." "..
             rebuilds.." times. Wait... Current score: "..round3(Score()))
if SKETCHBOOKPUZZLE then
foundahighgain=false
end

        if ReBuild(s,e,rebuilds) then

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
                        Wiggle("s",1,nil,true)
                        Wiggle("ws",1,nil,true)
                    end
                    Bridgerestore()
                    if AfterQstab then doMutate() end
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
                if not AfterQstab and BeFuze then doMutate() end
                save.Quicksave(4)
                if savebridges then Fuze(4,Bridgesave,Bridgerestore,localshakes) else Fuze(4,nil,nil,localshakes) end
                if AfterFuze then doMutate() end
            end
            SaveBest()
            save.Quickload(3)
        else save.Quickload(3) end
end --skip section
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
        else Bridgerestore() end
        if ss1+0.00001 < Score() then
            print("Gain from slots ",CurrentAll)
        end
        AddDone(s,e)
        ChkDoneList()
        if Score()-ss > minGain then break end

    end
    print("Deep"..action.." gain: "..round3(Score()-ss))
    if struct==false and SAVEDstructs then save.LoadSecondaryStructure() end
end

function DRcall(how)
    if how=="drw" then
        local stepsize=1
        if minLen>maxLen then stepsize= -1 end
        for i=minLen,maxLen,stepsize do --search from minl to maxl worst segments
            len=i
            FindWorst(true) --fill areas table. Comment it if you have set them by hand
            PrintAreas()
            DeepRebuild()

        end
    elseif how=="fj" then --DRW len cutted on pieces
        FindWorst(true) --add to areas table worst part
        areas2={}
        for a=1,#areas do
            local s=areas[a] --{ss,se}
            local ss=s[1] --start segment of worst area
            local se=s[2] --end segment of worst area
            for i=ss,se do
                for x=1,len do
                    if i+x<=se then
                        areas2[#areas2+1]={i,i+x}
                    end
                end
            end
        end
        areas=areas2
        PrintAreas()
        DeepRebuild()
    elseif how=="all" then
        areas={}
        for i=minLen,maxLen do
            for x=1,segCnt2 do
                if i+x-1<=segCnt2 then
                    areas[#areas+1]={x,x+i-1}
                end
            end
        end
        PrintAreas()
        DeepRebuild()
    elseif how=="simple" then
        FindWorst(true)
        PrintAreas()
        DeepRebuild()
    elseif how=="areas" then
        areas={}
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

function printOptions(title)
    print(title.." Based on rav4pl DRW 3.4")
    print("Length of "..action..": "..minLen.." to "..maxLen)
    print(action.." area: "..SegmentSetToString(WORKON))
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

function AskSubScores()
    local ask = dialog.CreateDialog("Slot selection "..progname..DRWVersion)
    ask.l1=dialog.AddLabel("Specify which slots based on scorepart to use")
    for i=1,#ScoreParts do
        ask[ScoreParts[i][2]]=dialog.AddCheckbox(ScoreParts[i][1].." "..ScoreParts[i][2],ScoreParts[i][3])
    end
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    if dialog.Show(ask) > 0 then
      for i=1,#ScoreParts do ScoreParts[i][3]=ask[ScoreParts[i][2]].value end
    end
end

function AskSelScores()
    local ask = dialog.CreateDialog("Set worst searching "..progname..DRWVersion)
    ask.l1=dialog.AddLabel("Specify which worst subscoretotal(s) to count")
    for i=3,#ScoreParts do
        ask[ScoreParts[i][2]]=dialog.AddCheckbox(ScoreParts[i][2],false)
    end
    ask.OK = dialog.AddButton("OK",1) ask.Cancel = dialog.AddButton("Cancel",0)
    scrPart={}
    if dialog.Show(ask) > 0 then
      for i=3,#ScoreParts do
        if ask[ScoreParts[i][2]].value then scrPart[#scrPart+1]=ScoreParts[i][2] end
      end
    end
end

function AskDRWOptions()
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
    ask.SEL= dialog.AddCheckbox("(Re)select where to work on ",false)
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
        if ask.SEL.value then
            Slot4=false
            SlotAll=false
            local SelMode={}
            SelMode.askignorefrozen=false
            SelMode.defignorefrozen=true
            SelMode.askignorelocks=false
            SelMode.defignorelocks=true
            SelMode.askligands=false
            SelMode.defligands=false
            WORKON=AskForSelections("Tvdl enhanced "..progname..DRWVersion,SelMode)
            print("Selection is now, reselect if not oke:")
            print(SegmentSetToString(WORKON))
            if askresult==1 then askresult=4 end --to force return to main menu
        end
        if ask.selSP.value then
            AskSubScores()
            if askresult==1 then askresult=4 end
        end
        for i=1,#ScoreParts do if ScoreParts[i][3] then
            print("Active slot "..ScoreParts[i][1].." is "..ScoreParts[i][2])
        end end
        if ask.worst.value then
            AskSelScores()
            if askresult==1 then askresult=4 end
        end
        -- Do not try to rebuild frozen or locked parts or ligands
        WORKON=SegmentSetMinus(WORKON,FindFrozen())
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
for i=3,12 do save.Quicksave(i) end
--[[
    USAGE
1. 'drw' - need 'minLen' and 'maxLen'; finding worst scores by len betwen that 2
2. 'fj' - need 'len'; searching len then cutting in pieces 2->len and rebuilds pieces
3. 'all' - need 'minLen' and 'maxLen'; rebuilding ENTIRE prorein (from min to max) like in WalkinRebuild script
4. 'simple' - need 'len'; find and rebuild worst scoring parts of that lenght
5. 'areas' - need secondary structure set and 'true' on at least one of structure
]]--
areas={ --start segment, end segment. use for last line call
--{1,10},
--{20,30},
--{32,35},
}
scrPart={}
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
minLen=2 --or specify minimum len
maxLen=4 --and maximim len
-- New options
maxnrofRuns=40 -- Set it very high if you want to run forever
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
WORKON={{1,segCnt2}}
-- part to administrate what has been done
Donepart={} --To find fast if to be skipped
Blocked={} --A simple list so we can clear Donepart
Disj={} --To administrate which segments have be touched
disjunct=false
donotrevisit=true
clrdonelistgain=segCnt
if clrdonelistgain > 500 then clrdonelistgain=500 end
curclrscore=Score()
WORKONbool={}
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
function DRW()
    if firstDRWcall then
        printOptions("Tvdl enhanced "..progname..DRWVersion)
        firstDRWcall=false
    end
    InitWORKONbool()
    DRWstartscore=Score()
    if nrskip > 0 then
        local sreBuild=reBuild
        reBuild=nrskip
        Runnr=0
        DRcall("drw")
        nrskip=0
        reBuild=sreBuild
    end

    for nrofRuns=1,maxnrofRuns do --uncomment method/s you want to use
         Runnr=Runnr+1
         print("Main cycle nr ",Runnr)
-- DRcall("areas")
     DRcall("drw")
-- DRcall("fj")
-- DRcall("all")
-- DRcall("simple")

        ChkDoneList()
        reBuild=reBuild+reBuildmore
    end

    Cleanup()

end

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
if AskDRWOptions() then
    xpcall(DRW,Cleanup)
    --DRW()

end

