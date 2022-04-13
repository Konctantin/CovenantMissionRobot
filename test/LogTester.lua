
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name

_G.bit = loadfile('libs/bit.lua')();

-- Init like wow addons
--print('Start loading simulator...');

loadfile('CovenantMissionRobot/VM/Settings.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/Utils.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/Tables.g.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/TargetManager.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.fix.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoCombatant.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoBoard.lua')(T.Name, T);

loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);

loadfile('test/utils.lua')(T.Name, T);

loadfile("Logs/CovenantMissionRobot.lua")(T.Name, T);

--print('Simulator has bin loaded!');

T.ApplySpellFixes();

--[[ Problems::
LogID: 16423565370004 Mission: 2233 Aura 91 Dazzledust
round 1, event 4: 205 * -0.6 = -123 (need -124) -> add aura
round 1, event 5: (1 * 146) - 123 = 23 but log has 22 wtf ???

LogID: 16423566070003 Mission: 2233
round 1, event 8:

LogID: 16423607340002 Mission: 2223
round 5 - aura bug, simulation: true
№ 18 LogID: 16424081760002 Mission: 2300 HasRandom: NO Log: OK
№ 19 LogID: 16424081770003 Mission: 2305
№ 28 LogID: 16424193640003 Mission: 2188 HasRandom: YES Log: OK
№ 42 LogID: 16424214040004 Mission: 2284 HasRandom: NO Log: OK
№ 54 LogID: 16424218890001 Mission: 2277 HasRandom: NO Log: OK
№ 64 LogID: 16424224420006 Mission: 2241 HasRandom: NO Log: OK
№ 69 LogID: 16424234510005 Mission: 2202 HasRandom: NO Log: OK
№ 92 LogID: 16424242540004 Mission: 2277 HasRandom: NO Log: OK
]]

local function PrintSim(simCp, blzCp)
    for r = 0, math.max(#simCp, #blzCp) do
        local simRound, blzRound = simCp[r] or {}, blzCp[r] or {};
        local units = {};
        local isok = true;
        for i = 0, 12 do
            if simRound[i] or blzRound[i] then
                table.insert(units, string.format("%i(%i/%i)", i, (simRound[i] or 0), (blzRound[i] or 0)));
                if (simRound[i] or -1) ~= (blzRound[i] or -1) then
                    isok = false;
                end
            end
        end
        print(r, table.concat(units, " "), (isok and "OK" or ""));
    end
    return true;
end

local start = 1
for mid, missionList in pairs(CMR_LOGS) do

    --if report.missionID == 2191 then
    --if CMR_MISSIONS and CMR_MISSIONS.ERROR and CMR_MISSIONS.ERROR[report.missionID] then
    --if i >= start and i < start+10 then
    for i, report in ipairs(missionList) do
        --if report.id == '16478833362191' then
            local isOK, baseCheckpoints = T.CreateCheckPoints(report);

            local board = T.GarrAutoBoard:New(report);
            board.LogEnabled = true;

            print("");
            print(string.format("№ %i LogID: %s Mission: %d HasRandom: %s Log: %s",
                i, report.id, report.missionID, (board.HasRandomSpells and "YES" or "NO"),
                (isOK and "OK" or "Broken!")));

            board:Simulate(10);
            local isOKSim = board:CheckSimulation(board.CheckPoints, baseCheckpoints);

            if isOKSim then
                print("Simulation: OK!")
            else
                T.PrintComparedLogs(board.Log, report.log, false);
                print("");
                PrintSim(board.CheckPoints, baseCheckpoints);
            end
            --break;
        --end
    end
end

print('Done!')
