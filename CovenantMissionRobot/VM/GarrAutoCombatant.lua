local _, T = ...;

local GetAutoAttackSpellId do
    local M, R = 11, 15;
    local enemies = {
        -- [boardIndex] = {[missionId]=M (meele spell id)}
        [05] = { [2172]=M,[2176]=M,[2196]=M,[2207]=M,[2209]=M,[2202]=M,[2214]=M,[2312]=M,[2304]=M },
        [06] = { [2304]=M,[2305]=M,[2311]=M,[2314]=M,[2315]=M,[2316]=M,[2317]=M,[2260]=M,[2209]=M,[2213]=M,[2176]=M,[2196]=M,[2207]=M,[2169]=M },
        [07] = { [2169]=M,[2172]=M,[2176]=M,[2196]=M,[2209]=M,[2207]=M,[2260]=M,[2305]=M,[2304]=M },
        [08] = { [2305]=M,[2304]=M,[2214]=M,[2207]=M,[2209]=M,[2196]=M,[2176]=M,[2172]=M },
        [09] = { [2204]=M,[2208]=M,[2239]=M,[2212]=M,[2252]=M,[2293]=M,[2298]=M,[2313]=M,[2259]=M,[2301]=M,[2307]=M,[2304]=M,[2303]=M },
        [10] = { [2304]=M,[2307]=M,[2303]=M,[2298]=M,[2252]=M,[2239]=M,[2243]=M,[2212]=M,[2201]=M,[2238]=M,[2241]=M,[2205]=M,[2169]=M },
        [11] = { [2169]=M,[2172]=M,[2209]=M,[2208]=M,[2205]=M,[2214]=M,[2224]=M,[2239]=M,[2259]=M,[2303]=M,[2287]=M,[2279]=M,[2252]=M,[2307]=M,[2304]=M },
        [12] = { [2304]=M,[2307]=M,[2298]=M,[2293]=M,[2303]=M,[2313]=M,[2252]=M,[2212]=M,[2239]=M,[2215]=M,[2204]=M,[2208]=M },
    };

    -- [FirstSpellID] = M (meele spell id)
    local followers = { [14]=M, [45]=M, [85]=M, [194]=M, [303]=M, [306]=M, [309]=M, [314]=M, [325]=M };

    function GetAutoAttackSpellId(role, missionId, boardIndex, firstSpell)
        -- Default: meele or tank
        local attackSpellId = (role == 1 or role == 5) and M or R;

        if (boardIndex or 0) > 4 and missionId then
            attackSpellId = enemies[boardIndex] and enemies[boardIndex][missionId] or attackSpellId;
        elseif firstSpell then
            attackSpellId = followers[firstSpell] or attackSpellId;
        end

        return attackSpellId;
    end
end

local GarrAutoCobatant = {
    FollowerGUID  = nil, -- for compare log and simulation
    Auras         = { },
    Spells        = { },
    MissionID     = 0,
    PassiveSpell  = nil,
    Role          = 0, -- 1-Meele, 2-Ranged/Physical, 3-Ranged/Magic, 4-Heal/Support, 5-Tank
    Attack        = 0,
    MaxHP         = 0,
    StartHP       = 0,
    CurHP         = 0,
    BoardIndex    = -1,
    Level         = 0,
    DeathSeq      = 0,
    TauntedBy     = nil,
    Untargetable  = false,
    Reflect       = 0,
    Name          = ""
};

function GarrAutoCobatant:New(unitInfo, missionId)
    local obj = {
        FollowerGUID = unitInfo.followerGUID,
        Name         = unitInfo.name,
        Level        = unitInfo.level,
        MaxHP        = unitInfo.maxHealth,
        CurHP        = unitInfo.health,
        StartHP      = unitInfo.health,
        Attack       = unitInfo.attack,
        BoardIndex   = unitInfo.boardIndex,
        Role         = unitInfo.role,
        MissionID    = missionId,
        TauntedBy    = nil,
        Untargetable = false,
        Reflect      = 0,
        DeathSeq     = 0,
        Spells       = { },
        PassiveSpell = nil,
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:SetupSpells(unitInfo.autoCombatSpells);

    return obj;
end

function GarrAutoCobatant:SetupSpells(autoCombatSpells)
    -- Auto attack can be 11 (meele) or 15 (range)
    if self.BoardIndex > -1 then
        local firstSpellId = #autoCombatSpells > 0 and autoCombatSpells[1].autoCombatSpellID;
        local autoAttackSpellId = GetAutoAttackSpellId(self.Role, self.MissionID, self.BoardIndex, firstSpellId);
        local autoAttackSpellInfo = T.GARR_AUTO_SPELL[autoAttackSpellId];
        autoAttackSpellInfo.Name = 'Auto Attack';
        local autoAttackSpell = T.GarrAutoSpell:New(autoAttackSpellInfo);
        table.insert(self.Spells, autoAttackSpell);
    end

    -- Regular spells
    for i, spell in pairs(autoCombatSpells) do
        local spellInfo = T.GARR_AUTO_SPELL[spell.autoCombatSpellID];
        if spellInfo then
            spellInfo.Name = spell.name;
            local spellObj = T.GarrAutoSpell:New(spellInfo);

            if i == 2 and spellObj.IsPassive then
                spellInfo.Duration = 1000;
                self.PassiveSpell = spellObj;
            else
                table.insert(self.Spells, spellObj);
            end
        end
    end
end

function GarrAutoCobatant:IsAlive()
    return self.CurHP > 0;
end

function GarrAutoCobatant:GetAvailableSpells()
    local result = { };

    for _, spell in ipairs(self.Spells) do
        if spell.CurCD == 0 then
            table.insert(result, spell);
        end
    end

    return result;
end

T.GarrAutoCobatant = GarrAutoCobatant;
T.GetAutoAttackSpellId = GetAutoAttackSpellId;