local T = { Name = "VenturePlan" };

_G.bit = loadfile('libs/bit.lua')();

loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);

loadfile("Logs/VenturePlan_000.lua")(T.Name, T);

assert(VP_MissionReports, "Is there a log?");

for e, ml in ipairs(VP_MissionReports) do
    local envSpell = ml.environment
        and ml.environment.autoCombatSpellInfo;

    local sim = T.VSim:New(
        ml.followers,
        ml.encounters,
        envSpell,
        ml.missionID,
        ml.missionScalar,
        0);

    sim:AddFightLogOracles(ml.log);
    sim:Run();

    print(e, "Mission: "..tostring(ml.missionID)..", win: "..tostring(ml.winner));
    for i, v in ipairs(sim.checkpoints) do
        print(i, v);
    end
end
