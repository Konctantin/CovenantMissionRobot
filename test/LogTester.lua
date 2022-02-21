
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name

_G.bit = loadfile('libs/bit.lua')();

-- Init like wow addons
print('Start loading simulator...');

loadfile('CovenantMissionRobot/VM/TargetManager.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.g.lua')(T.Name, T);
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

for i, missionLog in ipairs(VP_MissionReports) do
    if i < 2 then
    --if missionLog.id == '16424213240007' then
        print("");
        print("LogID: "..missionLog.id);

        local _, baseCheckpoints = T.GenerateCheckpoints(missionLog);

        local cmr = T.PrepareCMR(missionLog);
        --local vp = T.PrepareVP(missionLog);

        print("HasRandom: "..(cmr.HasRandom and "YES" or "NO"));

        cmr:Run();

        T.PrintComparedLogs(cmr.Log, missionLog.log);
        --vp:Run();

        for r = 0, math.max(#cmr.Checkpoints, #baseCheckpoints) do
            local l1 = cmr.Checkpoints[r];
            --local l2 = vp.checkpoints[r];
            local l3 = baseCheckpoints[r];

            if l1 == l3 then
                print(r, l1, "==> OK!");
            else
                print(r, l1, l3);
            end
        end
    end
end

print('Done!')