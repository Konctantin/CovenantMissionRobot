local _, T = ...;

local GarrAutoCobatant = {
    Auras         = { },
    Spells        = { },
    MissionID     = 0,
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
    IsAutoTroop   = false,
    Name          = ""
};

function GarrAutoCobatant:New(unitInfo, missionId)
    local obj = {
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
        IsAutoTroop  = unitInfo.IsAutoTroop, -- we need define this field manually from T.GARR_AUTO_TROOP_SPELLS
        DeathSeq     = 0,
        Spells       = { },
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:SetupSpells(unitInfo.autoCombatSpells);

    return obj;
end

function GarrAutoCobatant:NewEnv(environment, missionId)
    local obj = {
        Name         = environment.EnvironmentName,
        Level        = 0,
        MaxHP        = 1e5,
        CurHP        = 1e5,
        StartHP      = 1e5,
        Attack       = 1,
        BoardIndex   = -1,
        Role         = 0,
        MissionID    = missionId,
        TauntedBy    = nil,
        Untargetable = true,
        IsAutoTroop  = false,
        Reflect      = 0,
        DeathSeq     = 0,
        Spells       = { },
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    local autoCombatSpells = {
        {
            autoCombatSpellID = environment.SpellID,
            name = environment.SpellName
        }
    };

    obj:SetupSpells(autoCombatSpells);

    return obj;
end

function GarrAutoCobatant:Reset()
    self.CurHP = self.StartHP;
    self.TauntedBy = nil;
    self.Untargetable = false;
    self.Reflect = 0;
    self.DeathSeq = 0;
    self.Auras = {};
    for _, spell in ipairs(self.Spells) do
        spell:Reset();
    end
end

function GarrAutoCobatant:SetupSpells(autoCombatSpells)
    -- Auto attack can be 11 (meele) or 15 (range)
    if self.BoardIndex > -1 then
        local firstSpellId = #autoCombatSpells > 0 and autoCombatSpells[1].autoCombatSpellID;
        local autoAttackSpellId = T.GetAutoAttackSpellId(self.Role, self.MissionID, self.BoardIndex, firstSpellId);
        local autoAttackSpellInfo = T.GARR_AUTO_SPELL[autoAttackSpellId];
        autoAttackSpellInfo.Name = 'Auto Attack';
        local autoAttackSpell = T.GarrAutoSpell:New(autoAttackSpellInfo);
        table.insert(self.Spells, autoAttackSpell);
    end

    -- Regular spells
    for _, spell in ipairs(autoCombatSpells) do
        local spellInfo = T.GARR_AUTO_SPELL[spell.autoCombatSpellID];
        if spellInfo then
            spellInfo.Name = spell.name;
            local spellObj = T.GarrAutoSpell:New(spellInfo);
            table.insert(self.Spells, spellObj);
        else
            -- todo: assert?
        end
    end
end

function GarrAutoCobatant:IsAlive()
    return self.CurHP > 0;
end

function GarrAutoCobatant:GetAvailableSpells()
    local result = { };

    for _, spell in ipairs(self.Spells) do
        if not spell.IsPassive and spell.CurCD == 0 then
            table.insert(result, spell);
        end
    end

    return result;
end

function GarrAutoCobatant:HasRandomSpells()
    for _, spell in ipairs(self.Spells) do
        if spell.HasRandom then
            return true;
        end
    end
    return false;
end

function GarrAutoCobatant:IsFriendly(targetIndex)
    local sourceIndex = self.BoardIndex;
    return (sourceIndex >= 0 and sourceIndex <= 4 and targetIndex < 5)
        or (sourceIndex > 4 and targetIndex > 4)
        or (sourceIndex == -1 and targetIndex > 4);
end

function GarrAutoCobatant:GetTargetableUnits(board)
    local result = { };

    for i, u in pairs(board) do
        local tagetable = u:IsAlive() and (not u.Untargetable or self:IsFriendly(i));
        result[i] = tagetable;
    end

    return result;
end

T.GarrAutoCobatant = GarrAutoCobatant;
