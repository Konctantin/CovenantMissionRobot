
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name

_G.bit = loadfile('libs/bit.lua')();

-- Init like wow addons
print('Start loading simulator...');

loadfile('CovenantMissionRobot/VM/TargetManager.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.g.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoSpell.fix.lua')(T.Name, T);
loadfile('CovenantMissionRobot/VM/GarrAutoBoard.lua')(T.Name, T);

loadfile('VenturePlan/vs-spells.lua')(T.Name, T);
loadfile('VenturePlan/vs.lua')(T.Name, T);

loadfile("Logs/VenturePlan_000.lua")(T.Name, T);

print('Simulator has bin loaded!');

T.ApplySpellFixes();

local generateCheckpoints do
	local hex = {}
	for i = 0, 12 do
        hex[i] = ("%x"):format(i)
    end

	local function checkpointBoard(b)
		local r = ""
		for i = 0, 12 do
			local lh = b[i] or 0
			if lh > 0 then
				r = (r ~= "" and r .. "_" or "") .. hex[i] .. ":" .. lh
			end
		end
		return r
	end

	function generateCheckpoints(cr)
		local eei = cr.environment
		local envs = eei and eei.autoCombatSpellInfo
		local checkpoints, b = {}, {[-1] = envs and true or nil}
		for i = 1, #cr.encounters do
			local e = cr.encounters[i]
			b[e.boardIndex] = e.health
		end

		for _, v in pairs(cr.followers) do
			b[v.boardIndex] = v.health
		end

		checkpoints[0] = checkpointBoard(b);
		for t = 1, #cr.log do
			local e = cr.log[t].events
			for i = 1, #e do
				local ti = e[i].targetInfo
				local cidx = e[i].casterBoardIndex
				if not b[cidx] then
					return false
				end
				for i = 1, ti and #ti or 0 do
					local tii = ti[i]
					local tidx = tii.boardIndex
					if not b[tidx] then
						return false
					elseif tii.newHealth then
						b[tidx] = tii.newHealth
					end
				end
			end
			checkpoints[t] = checkpointBoard(b)
		end

		if checkpoints[#checkpoints] == checkpoints[#checkpoints-1] then
			checkpoints[#checkpoints] = nil
		end

		return true, checkpoints
	end
end

local function PrepareCMR(missionLog)
    local env = nil
    if missionLog.environment and missionLog.environment.autoCombatSpellInfo then
        env = {
            SpellID = missionLog.environment.autoCombatSpellInfo.autoCombatSpellID,
            SpellName = missionLog.environment.autoCombatSpellInfo.name,
            EnvironmentName = missionLog.environment.name
        };
    end

    local units = { };
    for e, follower in pairs(missionLog.followers) do
        follower.followerGUID = e;
        follower.autoCombatSpells = follower.spells;
        table.insert(units, follower);
    end

    for _, encounter in ipairs(missionLog.encounters) do
        table.insert(units, encounter);
    end

    local board = T.GarrAutoBoard:New(missionLog, units, env);
    board.LogEnabled = true;
    return board;
end

local function PrepareVP(missionLog)
    local envSpell = missionLog.environment
        and missionLog.environment.autoCombatSpellInfo;

    local sim = T.VSim:New(
        missionLog.followers,
        missionLog.encounters,
        envSpell,
        missionLog.missionID,
        missionLog.missionScalar,
        0);

    sim:AddFightLogOracles(missionLog.log);
    return sim;
end

for i, missionLog in ipairs(VP_MissionReports) do
    if i < 400 then
    --if missionLog.id == '16424213240007' then
        print("");
        print("LogID: "..missionLog.id);

        local _, baseCheckpoints = generateCheckpoints(missionLog);

        local cmr = PrepareCMR(missionLog);
        local vp = PrepareVP(missionLog);

        print("HasRandom: "..(cmr.HasRandom and "YES" or "NO"));

        cmr:Run();
        vp:Run();


        for r = 1, math.max(#cmr.Checkpoints, #vp.checkpoints, #baseCheckpoints) do
            local l1 = cmr.Checkpoints[r];
            local l2 = vp.checkpoints[r];
            local l3 = baseCheckpoints[r];

            if l1 == l2 and l1 == l3 then
                print(r, l1)
            else
                print(r, l1, l2, l3);
            end
        end
    end
end

print('Done!')