
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name

_G.bit = loadfile('libs/bit.lua')();

-- Init like wow addons
--print('Start loading simulator...');

loadfile('CovenantMissionRobot/VM/Settings.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/Tables.g.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/TargetManager.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.fix.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoCombatant.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoBoard.lua')(T.Name, T);

loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);

loadfile('test/utils.lua')(T.Name, T);

loadfile("Logs/VenturePlan_001.lua")(T.Name, T);

--print('Simulator has bin loaded!');

T.ApplySpellFixes();

--[[ Problems::
LogID: 16423565370004 Mission: 2233 Aura 91 Dazzledust
round 1, event 4: 205 * -0.6 = -123 -> add aura
round 1, event 5: (1 * 146) - 123 = 23 but log has 22 wtf ???

LogID: 16423566070003 Mission: 2233
round 1, event 8:

LogID: 16423607340002 Mission: 2223
round 5 - aura bug, simulation: true

№ 19 LogID: 16424081770003 Mission: 2305
]]
local function padl(str, cnt)
    local r = string.len(str);
    for i = r, cnt do
        str=str..' ';
    end
    return str;
end
local function CheckSim(cp1, cp2)
    for r = 0, math.max(#cp1, #cp2) do
        local l1 = cp1[r];
        local l2 = cp2[r];
        if l1 ~= l2 then
            return false;
        end
    end
    return true;
end
local start = 40
for i, report in ipairs(VP_MissionReports) do
    --if 1 == 1 then
    if i >= start and i < start+10 then
    --if report.id == '16423565380005' then
    --if report.id=='16423566060002' then

        local isOK, baseCheckpoints = T.GenerateCheckpoints(report);

        local cmr = T.PrepareCMR(report);
        cmr:SetupBlizzardLog(report.log);
        local vp = T.PrepareVP(report);

        print("");
        print(string.format("№ %i LogID: %s Mission: %d HasRandom: %s Log: %s",
            i, report.id, report.missionID, (cmr.HasRandomSpells and "YES" or "NO"),
            (isOK and "OK" or "Broken!")));

        --for i=0,12 do
        --    local u = cmr.Board[i];
        --    if u then
        --        print(string.format("[%i] %s", i, u.Name));
        --        for _, s in ipairs(u.Spells) do
        --            print(string.format("  [%03i] %s", s.SpellID, s.Name));
        --        end
        --    end
        --end

        cmr:Run();

        local isOKSim = CheckSim(cmr.CheckPoints, baseCheckpoints);

        if isOKSim then
            print("Simulation: OK!")
        else
            T.PrintComparedLogs(cmr.Log, report.log, false);
            print("");
            for r = 0, math.max(math.max(#cmr.CheckPoints, #vp.checkpoints), #baseCheckpoints) do
                local l1 = cmr.CheckPoints[r];
                local l3 = baseCheckpoints[r];
                print(r, padl(l1,70), l3);
            end
        end
    end
end

print('Done!')
