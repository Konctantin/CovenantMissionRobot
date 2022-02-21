local _, T = ...;

T.LogEventTypes = {
	[0] = "MeleeDamage",
	[1] = "RangeDamage",
	[2] = "SpellMeleeDamage",
	[3] = "SpellRangeDamage",
	[4] = "Heal",
	[5] = "PeriodicDamage",
	[6] = "PeriodicHeal",
	[7] = "ApplyAura",
	[8] = "RemoveAura",
	[9] = "Died",
}

local generateCheckpoints do
	local hex = { }
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
		local checkpoints = {};
        local b = {[-1] = envs and true or nil};
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

T.GenerateCheckpoints = generateCheckpoints;
T.PrepareCMR = PrepareCMR;
T.PrepareVP = PrepareVP;