local T = { Name = "VenturePlan" };

_G.bit = loadfile('libs/bit.lua')();

loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);

loadfile("Logs/VenturePlan_001.lua")(T.Name, T);

assert(VP_MissionReports, "Is there a log?");

for _, ml in ipairs(VP_MissionReports) do
    if ml.id == '16424213240007' then
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

		for i, v in ipairs(sim.checkpoints) do
			print(i, v);
		end
    end
end
