
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name

_G.bit = loadfile('libs/bit.lua')();

-- Init like wow addons
print('Start loading simulator...');

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

print('Simulator has bin loaded!');

T.ApplySpellFixes();

--[[
    Problems:
    1) Aura 91 Dazzledust (attack:205*points:-0.6=-123) need -124 ??? but global result is ok (log: 16423565370004)
]]

for i, report in ipairs(VP_MissionReports) do
    --if i < 10 then
    if report.id == '16423566050001' then
        print("");
        print(string.format("LogID: %s Mission: %d", report.id, report.missionID));

        local isOK, baseCheckpoints = T.GenerateCheckpoints(report);

        local cmr = T.PrepareCMR(report);
        --local vp = T.PrepareVP(missionLog);

        print("HasRandom: "..(cmr.HasRandomSpells and "YES" or "NO"));
        print("Log: "..(isOK and "OK" or "Broken!"))

        for i=0,12 do
            local u = cmr.Board[i];
            if u then
                print(string.format("[%i] %s", i, u.Name));
                for _, s in ipairs(u.Spells) do
                    print(string.format("  [%03i] %s", s.SpellID, s.Name));
                end
            end
        end

        cmr:Run();

        T.PrintComparedLogs(cmr.Log, report.log, false);
        print("");
        --vp:Run();

        local isOk = true;
        for r = 0, math.max(#cmr.CheckPoints, #baseCheckpoints) do
            local l1 = cmr.CheckPoints[r];
            --local l2 = vp.checkpoints[r];
            local l3 = baseCheckpoints[r];

            if l1 == l3 then
                --print(r, l1, "==> OK!");
            else
                print(r, l1, l3);
                isOk = false;
            end
        end
        print("Simulation: "..tostring(isOk))
    end
end

print('Done!')
