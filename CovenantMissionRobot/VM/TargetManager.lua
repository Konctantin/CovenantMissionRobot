local _, T = ...;

-- !BoardIndexes!
--
-- Environment: -1
--
--    Enemies
--  9  10  11  12
--  5   6   7   8
--
--   Followers
--    2   3   4
--      0   1

local PriorityTable = {
    [1] = { -- Self
        [00] = { 00 },
        [01] = { 01 },
        [02] = { 02 },
        [03] = { 03 },
        [04] = { 04 },
        [05] = { 05 },
        [06] = { 06 },
        [07] = { 07 },
        [08] = { 08 },
        [09] = { 09 },
        [10] = { 10 },
        [11] = { 11 },
        [12] = { 12 }
    },
    [2] = { -- Adjacent ally
        [00] = { 2, 3, 1, 0, 4 },
        [01] = { 0, 3, 4, 2, 1 },
        [02] = { 0, 3, 2, 1, 4 },
        [03] = { 2, 0, 1, 4, 3 },
        [04] = { 3, 1, 2, 0, 4 },
        [05] = { 5, 6, 10, 7, 9, 11, 8, 12 },
        [06] = { 5, 10, 7, 11, 6, 9, 12, 8 },
        [07] = { 6, 11, 10, 12, 8, 7, 5, 9 },
        [08] = { 7, 6, 8, 11, 12, 9, 5, 10 },
        [09] = { 5, 10, 6, 9, 7, 8, 11, 12 },
        [10] = { 9, 6, 11, 5, 7, 10, 8, 12 },
        [11] = { 10, 7, 8, 12, 6, 9, 11, 5 },
        [12] = { 5, 6, 10, 7, 9, 11, 8, 12 }
    },
    [3] =  { -- Closest enemy
        [00] = { 5, 6, 10, 7, 9, 11, 8, 12 },
        [01] = { 6, 7, 11, 8, 10, 12, 5, 9 },
        [02] = { 5, 6, 9, 10, 7, 11, 8, 12 },
        [03] = { 6, 7, 5, 10, 9, 11, 8, 12 },
        [04] = { 7, 8, 6, 11, 10, 12, 5, 9 },
        [05] = { 2, 0, 3, 1, 4 },
        [06] = { 2, 3, 0, 1, 4 },
        [07] = { 3, 4, 2, 0, 1 },
        [08] = { 4, 3, 1, 2, 0 },
        [09] = { 2, 3, 0, 1, 4 },
        [10] = { 2, 3, 4, 0, 1 },
        [11] = { 2, 3, 4, 0, 1 },
        [12] = { 3, 4, 2, 0, 1 }
    },
    [5] = { -- Ranged enemy
        [00] = { 12, 8, 9, 11, 10, 5, 7, 6 },
        [01] = { 9, 5, 10, 12, 11, 6, 8, 7 },
        [02] = { 12, 8, 11, 7, 9, 10, 5, 6 },
        [03] = { 9, 12, 5, 8, 10, 11, 6, 7 },
        [04] = { 9, 5, 10, 6, 11, 12, 7, 8 },
        [05] = { 4, 1, 3, 0, 2 },
        [06] = { 4, 1, 0, 2, 3 },
        [07] = { 2, 0, 1, 3, 4 },
        [08] = { 2, 0, 3, 1, 4 },
        [09] = { 4, 1, 0, 3, 2 },
        [10] = { 1, 0, 4, 2, 3 },
        [11] = { 0, 1, 2, 3, 4 },
        [12] = { 2, 0, 1, 3, 4 }
    }
};

local AdjacentEnemies = {
    [0] = {
        Alone   = { 8, 12 },
        Blocker = { 5, 6 },
        Alive   = { { 5, 6 } },
        Dead    = { { 5, 7, 9, 10, 11 } },
    },
    [1] = {
        Alone   = { 5, 9 },
        Blocker = { 7 },
        Alive   = { { 6, 7 } },
        Dead    = { { 6, 8, 10, 11, 12 } },
    },
    [2] = {
        Alone   = { 8, 12 },
        Blocker = { 5, 6 },
        Alive   = { { 5, 6 } },
        Dead    = { { 7, 9, 10, 11 } },
    },
    [3] = {
        Alone   = { 8, 12 },
        Blocker = { 6, 7 },
        Alive   = { { 6, 7 } },
        Dead    = { { 5, 7, 9, 10, 11 } },
    },
    [4] = {
        Alone   = { 5, 9 },
        Blocker = { 7, 8 },
        Alive   = { {7 , 8 } },
        Dead    = { { 6, 10, 11, 12 } },
    },
    [5] = {
        Alone   = { },
        Blocker = { 2 },
        Alive   = { { 2 } },
        Dead    = { { 0, 3 }, { 1, 4 } },
    },
    [6] = {
        Alone   = { },
        Blocker = { 2, 3 },
        Alive   = { { 2, 3 } }, -- proved
        Dead    = { { 0, 1, 2 } },
    },
    [7] = {
        Alone   = { },
        Blocker = { 3, 4 },
        Alive   = { { 3, 4 } }, -- proved
        Dead    = { { 0, 1, 2 } },
    },
    [8] = {
        Alone   = { },
        Blocker = { 4 },
        Alive   = { { 4 } },
        Dead    = { { 1, 3 }, { 0, 2 } },
    },
    [9] = {
        Alone   = { },
        Blocker = { 2 },
        Alive   = { { 2 } },
        Dead    = { { 0, 3 }, { 1, 4 } },
    },
    [10] = {
        Alone   = { },
        Blocker = { 2, 3 },
        Alive   = { { 2, 3 } },
        Dead    = { { 0, 1, 2 } },
    },
    [11] = {
        Alone   = { },
        Blocker = { 3, 4 },
        Alive   = { { 3, 4 } },
        Dead    = { { 0, 1, 2 } },
    },
    [12] = {
        Alone   = { },
        Blocker = { 4 },
        Alive   = { { 4 } },
        Dead    = { { 1, 3 }, { 0, 2 } },
    }
};

-- adjacent allies indexes
local AdjacentAllies = {
    [0]  = { 2, 3, 1 },
    [1]  = { 0, 3, 4 },
    [2]  = { 0, 3 },
    [3]  = { 0, 1, 2, 4 },
    [4]  = { 1, 3 },

    [5]  = { 6, 9, 10 },
    [6]  = { 5, 9, 10, 11, 7 },
    [7]  = { 6, 10, 11, 12, 8 },
    [8]  = { 7, 11, 12 },
    [9]  = { 5, 6, 10 },
    [10] = { 5, 6, 7, 9, 11 },
    [11] = { 6, 7, 8, 10, 12 },
    [12] = { 7, 8, 11 }
};

--TODO: test it
-- garrMission.ID = 2224
local ConeAllies = {
    [0]  = { 0  },
    [1]  = { 1  },
    [2]  = { 2  },
    [3]  = { 3  },
    [4]  = { 4  },
    [5]  = { 5  },
    [6]  = { 6  },
    [7]  = { 7  },
    [8]  = { 8  },
    [9]  = { 9  },
    [10] = { 10 },
    [11] = { 11 },
    [12] = { 12 }
};

-- key = main target, value = all targets
local ConeEnemies = {
    [0]  = { 0 },
    [1]  = { 1 },
    [2]  = { 2, 0 },
    [3]  = { 3, 0, 1 },
    [4]  = { 4, 1 },

    [5]  = { 5, 9, 10 },
    [6]  = { 6, 9, 10, 11 },
    [7]  = { 7, 10, 11, 12 },
    [8]  = { 8, 11, 12 },
    [9]  = { 9 },
    [10] = { 10 },
    [11] = { 11 },
    [12] = { 12 }
};

-- key = main target, value = all targets
local LineEnemies = {
    [0]  = { 0 },
    [1]  = { 1 },
    [2]  = { 2 },
    [3]  = { 3 },
    [4]  = { 4 },
    [5]  = { 5, 9 },
    [6]  = { 6, 10 },
    [7]  = { 7, 11 },
    [8]  = { 8, 12 },
    [9]  = { 9 },
    [10] = { 10 },
    [11] = { 11 },
    [12] = { 12 }
};

local function GetTargetPriority(sourceIndex, targetType, mainTarget)
    local targets = PriorityTable[targetType][sourceIndex];
    if mainTarget then
        table.insert(targets, 1, mainTarget);
    end

    return targets;
end

local function GetMainTarget(priority, boardUnits)
    for _, unitIndex in pairs(priority) do
        if boardUnits[unitIndex] then
            return unitIndex;
        end
    end
end

local function GetSelfTarget(sourceIndex, targetType, boardUnits)
    return { sourceIndex };
end

local function GetSimpleTarget(sourceIndex, targetType, boardUnits, mainTarget)
    -- adjacent ally, closest enemy (3), furthest enemy (5)
    if mainTarget and (targetType == 3 or targetType == 5) then
        return { mainTarget };
    end

    local priority = GetTargetPriority(sourceIndex, targetType);
    mainTarget = GetMainTarget(priority, boardUnits);

    return { mainTarget };
end

local function GetAllAllies(sourceIndex, targetType, boardUnits)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 0, 4 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
    else
        for i = 5, 12 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
    end

    return targets;
end

local function GetAllEnemies(sourceIndex, targetType, boardUnits)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 5, 12 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
    else
        for i = 0, 4 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
    end

    return targets;
end

local function GetAllAdjacentAllies(sourceIndex, targetType, boardUnits)
    local targets = { };

    local adjacentTargets = AdjacentAllies[sourceIndex];
    for _, target in ipairs(adjacentTargets) do
        if boardUnits[target] then
            table.insert(targets, target);
        end
    end

    return targets;
end

local function GetAllAdjacentEnemies(sourceIndex, targetType, boardUnits, mainTarget)
    -- TODO: if taunt?
    local targets = { };
    local targetInfo = AdjacentEnemies[sourceIndex];
    local aliveBlockerUnit = GetMainTarget(targetInfo.Blocker, boardUnits);

    local variants = aliveBlockerUnit and targetInfo.Alive or targetInfo.Dead;
    for _, group in ipairs(variants) do
        for _, boardIndex in ipairs(group) do
            if boardUnits[boardIndex] then
                table.insert(targets, boardIndex);
            end
        end
    end

    if #targets == 0 then
        local singleTarget = GetMainTarget(targetInfo.Alone, boardUnits);
        if singleTarget then
            table.insert(targets, singleTarget);
        end
    end

    return targets;
end

local function GetClosestAllyCone(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    -- closestEnemy (3)
    mainTarget = GetSimpleTarget(sourceIndex, 3, boardUnits, mainTarget)[1];
    if mainTarget == nil then
        return { };
    end

    local coneTargets = ConeAllies[mainTarget];
    for _, target in ipairs(coneTargets) do
        if boardUnits[target] then
            table.insert(targets, target);
        end
    end

    return targets;
end

local function GetClosestEnemyCone(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    -- ClosestEnemy (3)
    mainTarget = GetSimpleTarget(sourceIndex, 3, boardUnits, mainTarget)[1];
    if mainTarget == nil then
        return { };
    end

    local coneTargets = ConeEnemies[mainTarget];
    for _, target in ipairs(coneTargets) do
        if boardUnits[target] then
            table.insert(targets, target);
        end
    end

    return targets;
end

local function GetClosestEnemyLine(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    -- closestEnemy (3)
    mainTarget = GetSimpleTarget(sourceIndex, 3, boardUnits, mainTarget)[1];
    if mainTarget == nil then
        return { };
    end

    local lineTargets = LineEnemies[mainTarget];
    for _, target in ipairs(lineTargets) do
        if boardUnits[target] then
            table.insert(targets, target);
        end
    end

    return targets;
end

local function GetAllMeleeAllies(sourceIndex, targetType, boardUnits)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 2, 4 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 0, 1 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    else
        for i = 5, 8 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 9, 12 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    end

    return targets;
end

local function GetAllMeleeEnemies(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 5, 8 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 9, 12 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    else
        for i = 2, 4 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 0, 1 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    end

    if mainTarget then
        table.insert(targets, 1, mainTarget);
    end

    return targets;
end

local function GetAllRangedAllies(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 0, 1 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 2, 4 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    else
        for i = 9, 12 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 5, 8 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    end

    return targets;
end

local function GetAllRangedEnemies(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 9, 12 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 5, 8 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    else
        for i = 0, 1 do
            if boardUnits[i] then
                table.insert(targets, i);
            end
        end
        if #targets == 0 then
            for i = 2, 4 do
                if boardUnits[i] then
                    table.insert(targets, i);
                end
            end
        end
    end

    if mainTarget then
        table.insert(targets, 1, mainTarget);
    end

    return targets;
end

local function NotImplemented(sourceIndex, targetType, boardUnits, mainTarget)
    return { sourceIndex };
end

local function GetRandomEnemy(sourceIndex, targetType, boardUnits, mainTarget)
    if mainTarget then
        return { mainTarget };
    end

    local targets = { };
    for i, v in pairs(boardUnits) do
        if (sourceIndex == -1 and i <= 4 and v)
        or (sourceIndex  > 4  and i <= 4 and v)
        or (sourceIndex <= 4  and sourceIndex >= 0 and i  > 4 and v)
        then
            table.insert(targets, i);
        end
    end

    if #targets == 0 then
        return { };
    end

    local index = math.random(#targets);
    local target = targets[index];
    return { target };
end

local function GetRandomAlly(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    for i, v in pairs(boardUnits) do
        if (sourceIndex == -1 and i  > 4 and v)
        or (sourceIndex > 4   and i  > 4 and v)
        or (sourceIndex <= 4  and sourceIndex >= 0 and i <= 4 and v)
        then
            table.insert(targets, i);
        end
    end

    if #targets == 0 then
        return { };
    end

    local index = math.random(#targets);
    local target = targets[index];
    return { target };
end

local function GetEnvAllAllies(sourceIndex, targetType, boardUnits, mainTarget)
    return { 0, 1, 2, 3, 4 };
end

local function GetEnvAllEnemies(sourceIndex, targetType, boardUnits, mainTarget)
    return { 5, 6, 7, 8, 9, 10, 11, 12 };
end

local function GetAlliesExpectSelf(sourceIndex, targetType, boardUnits, mainTarget)
    local targets = { };

    if sourceIndex >= 0 and sourceIndex <= 4 then
        for i = 0, 4 do
            if boardUnits[i] and i ~= sourceIndex then
                table.insert(targets, i);
            end
        end
    else
        for i = 5, 12 do
            if boardUnits[i] and i ~= sourceIndex then
                table.insert(targets, i);
            end
        end
    end

    return targets;
end

local FunctionTable = {
    [0]  = NotImplemented,
    [1]  = GetSelfTarget,
    [2]  = GetSimpleTarget,
    [3]  = GetSimpleTarget,
    [5]  = GetSimpleTarget,
    [6]  = GetAllAllies,
    [7]  = GetAllEnemies,
    [8]  = GetAllAdjacentAllies,
    [9]  = GetAllAdjacentEnemies,
    [10] = GetClosestAllyCone,
    [11] = GetClosestEnemyCone,
    [13] = GetClosestEnemyLine,
    [14] = GetAllMeleeAllies,
    [15] = GetAllMeleeEnemies,
    [16] = GetAllRangedAllies,
    [17] = GetAllRangedEnemies,
    [19] = GetRandomEnemy,
    [20] = GetRandomEnemy,
    [21] = GetRandomAlly,
    [22] = GetAlliesExpectSelf,
    [23] = GetEnvAllAllies,
    [24] = GetEnvAllEnemies
}

TargetManager = { };

function TargetManager:GetTargetIndexes(sourceIndex, targetType, boardUnits, mainTarget)
    local func = FunctionTable[targetType];
    local indexes = func(sourceIndex, targetType, boardUnits, mainTarget);
    return indexes;
end

T.TargetManager = TargetManager;