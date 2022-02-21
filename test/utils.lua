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
};

T.SchoolMask = {
    [01] = "Physical",
    [02] = "Holly",
    [04] = "Fire",
    [08] = "Nature",
    [16] = "Frost",
    [32] = "Shadow",
    [64] = "Arcane"
};

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
        local envs = cr.environment and cr.environment.autoCombatSpellInfo;
        local checkpoints = {};
        local board = {[-1] = envs and true or nil};

        for i = 1, #cr.encounters do
            local e = cr.encounters[i];
            board[e.boardIndex] = e.health;
        end

        for _, v in pairs(cr.followers) do
            board[v.boardIndex] = v.health;
        end

        checkpoints[0] = checkpointBoard(board);
        for r = 1, #cr.log do
            local events = cr.log[r].events;
            for e = 1, #events do
                local ti = events[e].targetInfo;
                local cidx = events[e].casterBoardIndex;

                if not board[cidx] then
                    return false
                end

                for i = 1, ti and #ti or 0 do
                    local tii  = ti[i];
                    local tidx = tii.boardIndex;
                    if not board[tidx] then
                        return false;
                    elseif tii.newHealth then
                        board[tidx] = tii.newHealth;
                    end
                end
            end
            checkpoints[r] = checkpointBoard(board);
        end

        if checkpoints[#checkpoints] == checkpoints[#checkpoints-1] then
            checkpoints[#checkpoints] = nil;
        end

        return true, checkpoints;
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

local function PrintComparedLogs(sim, log)
    for r = 1, math.min(#sim, #log) do
        local events1 = sim[r].events;
        local events2 = log[r].events;
        for e = 1, math.min(#events1, #events2) do
            local event1 = events1[e];
            local event2 = events2[e];

            local targetInfo1 = event1.targetInfo;
            local targetInfo2 = event2.targetInfo;
            for t = 1, math.min(#targetInfo1, #targetInfo2) do
                local target1 = targetInfo1[t];
                local target2 = targetInfo2[t];

                print(string.format(
                    "Caster: %02i/%02i Spell: %03i/%03i Effect: %i/%i Type: %i/%i -> Target: %02i/%02i, Old: %05i/%05i, New: %05i/%05i, Points: %05i/%05i",
                    event1.casterBoardIndex, event2.casterBoardIndex,
                    event1.spellID, event2.spellID,
                    event1.effectIndex or 0, event2.effectIndex,
                    event1.type or 0, event2.type,
                    target1.BoardIndex, target2.boardIndex,
                    target1.OldHP, target2.oldHealth,
                    target1.NewHP, target2.newHealth,
                    target1.Points, target2.points or 0
                    ));
            end
        end
    end
end

T.GenerateCheckpoints = generateCheckpoints;
T.PrepareCMR = PrepareCMR;
T.PrepareVP = PrepareVP;
T.PrintComparedLogs = PrintComparedLogs;