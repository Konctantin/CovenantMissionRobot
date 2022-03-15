local T = { Name = "VP tester" };

_G.bit = loadfile('libs/bit.lua')();
loadfile('test/utils.lua')(T.Name, T);
loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);


loadfile("Logs/VenturePlan_001.lua")(T.Name, T);


for _, report in ipairs(VP_MissionReports) do
    if report.id == '16423566060002' then
        print("");
        print(string.format("LogID: %s Mission: %d", report.id, report.missionID));

        local isOK, baseCheckpoints = T.GenerateCheckpoints(report);
        local environmentSpell = report.environment
            and report.environment.autoCombatSpellInfo;

        local sim = T.VSim:New(
            report.followers,
            report.encounters,
            environmentSpell,
            report.missionID,
            report.missionScalar);

        --sim:AddFightLogOracles(report.log);
        sim:Run();

        for r = 0, math.max(#sim.checkpoints, #baseCheckpoints) do
            local l2 = sim.checkpoints[r];
            local l3 = baseCheckpoints[r];
            print(r, l2, l3, (l2==l3 and ' -> OK!'));
        end
    end
end
