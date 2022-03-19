local _, T = ...;

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
        local envs = cr.environmentEffect and cr.environmentEffect.autoCombatSpellInfo;
        local checkpoints = {};
        local board = {[-1] = envs and true or nil};

        for i = 1, #cr.enemies do
            local e = cr.enemies[i];
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

-- return logOK, simOK
local function CheckSimulation(report)
    local isOK, baseCheckpoints = generateCheckpoints(report);
    if not isOK then
        return false, false;
    end

    local board = T.GarrAutoBoard:New(report);
    board.LogEnabled = false;
    board:Run();

    if #baseCheckpoints ~= #board.CheckPoints then
        return true, false;
    end

    for i = 0, math.min(#baseCheckpoints, #board.CheckPoints) do
        if baseCheckpoints[i] ~= board.CheckPoints[i] then
            return true, false;
        end
    end

    return true, true;
end

function GetAutoFollowerInfo(guid, boardIndex)
    local missionCompleteInfo = C_Garrison.GetFollowerMissionCompleteInfo(guid);
    local autoCombatStats = C_Garrison.GetFollowerAutoCombatStats(guid);
    local autoCombatSpells, autoCombatAutoAttack = C_Garrison.GetFollowerAutoCombatSpells(guid, missionCompleteInfo.level);

    local result = {
        followerGUID = guid, -- ???
        name       = missionCompleteInfo.name,
        role       = missionCompleteInfo.role,
        level      = missionCompleteInfo.level,
        isAutoTroop= missionCompleteInfo.isAutoTroop,
        boardIndex = boardIndex or missionCompleteInfo.boardIndex,
        health     = autoCombatStats.currentHealth,
        maxHealth  = autoCombatStats.maxHealth,
        attack     = autoCombatStats.attack,
        autoCombatAutoAttack = autoCombatAutoAttack,
        autoCombatSpells = autoCombatSpells,
    };

    return result;
end

-- /dump GetMissionBoardInfo()
function GetMissionBoardInfo(missionPage)
    missionPage = missionPage or CovenantMissionFrame:GetMissionPage();
    if not missionPage and not missionPage.missionInfo then
        return { };
    end

    local info = {
        missionID = missionPage.missionInfo.missionID,
        name = missionPage.missionInfo.name,
        level = missionPage.missionInfo.level,
        enemies = missionPage.missionInfo.enemies,
        environmentEffect = missionPage.missionInfo.environmentEffect,
        followers = { },
    };

    for i = 0, 4 do
        local unit = missionPage.Board.framesByBoardIndex[i];
        if unit and unit.followerGUID then
            local unitInfo = GetAutoFollowerInfo(unit.followerGUID, i);
            --unitInfo.isAutoTroop = unitInfo.info.isAutoTroop;
            table.insert(info.followers, unitInfo);
        end
    end

    return info;
end

T.CheckSimulation = CheckSimulation;
T.GenerateCheckpoints = generateCheckpoints;
T.GetAutoFollowerInfo = GetAutoFollowerInfo;
T.GetMissionBoardInfo = GetMissionBoardInfo;
