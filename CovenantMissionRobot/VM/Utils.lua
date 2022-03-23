local _, T = ...;

local function CreateCheckPoints(report)
    local checkpoints = { [0] = {} };

    if report.environmentEffect then
        checkpoints[0][-1] = 1;
    end

    for _, u in ipairs(report.enemies) do
        checkpoints[0][u.boardIndex] = u.health;
    end

    for _, u in ipairs(report.followers) do
        checkpoints[0][u.boardIndex] = u.health;
    end

    for i, r in ipairs(report.log) do
        checkpoints[i] = {};

        for k, v in pairs(checkpoints[i-1]) do
            checkpoints[i][k] = v;
        end

        for _, e in ipairs(r.events) do
            if not checkpoints[i][e.casterBoardIndex] then
                return false, nil;
            end

            for _, t in ipairs(e.targetInfo) do
                if not checkpoints[i][t.boardIndex] then
                    return false, nil;
                else
                    checkpoints[i][t.boardIndex] = t.newHealth;
                end
            end
        end
    end

    return true, checkpoints;
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

    local mdi = C_Garrison.GetMissionDeploymentInfo(missionPage.missionInfo.missionID);

    local info = {
        missionID = missionPage.missionInfo.missionID,
        name = missionPage.missionInfo.name,
        level = missionPage.missionInfo.level,
        environmentEffect = missionPage.missionInfo.environmentEffect,
        enemies = mdi.enemies,
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

T.CreateCheckPoints = CreateCheckPoints;
T.GetAutoFollowerInfo = GetAutoFollowerInfo;
T.GetMissionBoardInfo = GetMissionBoardInfo;
