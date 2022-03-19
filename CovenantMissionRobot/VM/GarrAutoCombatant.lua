local _, T = ...;

local GetAutoAttackSpellId = T.GetAutoAttackSpellId;
local GARR_AUTO_SPELL = T.GARR_AUTO_SPELL;
local GarrAutoSpell = T.GarrAutoSpell;


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
    ReflectAura   = nil,
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
        RReflectAura = nil,
        IsAutoTroop  = unitInfo.IsAutoTroop, -- we need define this field manually from T.GARR_AUTO_TROOP_SPELLS
        DeathSeq     = 0,
        Spells       = { },
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:SetupSpells(unitInfo.autoCombatSpells, unitInfo.autoCombatAutoAttack);

    return obj;
end

function GarrAutoCobatant:NewEnv(missionInfo)
    local obj = {
        Name         = missionInfo.environmentEffect.name,
        Level        = 0,
        MaxHP        = 1e5,
        CurHP        = 1e5,
        StartHP      = 1e5,
        Attack       = 1,
        BoardIndex   = -1,
        Role         = 0,
        MissionID    = missionInfo.missionID,
        TauntedBy    = nil,
        Untargetable = true,
        IsAutoTroop  = false,
        ReflectAura  = nil,
        DeathSeq     = 0,
        Spells       = { },
        Auras        = { }
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:SetupSpells(missionInfo.environmentEffect.autoCombatSpellInfo);

    return obj;
end

function GarrAutoCobatant:Reset()
    self.CurHP = self.StartHP;
    self.TauntedBy = nil;
    self.Untargetable = false;
    self.ReflectAura = nil;
    self.DeathSeq = 0;
    self.Auras = {};
    for _, spell in ipairs(self.Spells) do
        spell:Reset();
    end
end

function GarrAutoCobatant:SetupSpells(autoCombatSpells, autoCombatAutoAttack)
    if self.BoardIndex > -1 and autoCombatAutoAttack then
        local autoAttackSpellInfo = GARR_AUTO_SPELL[autoCombatAutoAttack.autoCombatSpellID];
        autoAttackSpellInfo.Name = autoCombatAutoAttack.name;
        autoAttackSpellInfo.Description = autoCombatAutoAttack.description;
        local autoAttackSpell = GarrAutoSpell:New(autoAttackSpellInfo);
        table.insert(self.Spells, autoAttackSpell);
    end

    for _, spell in ipairs(autoCombatSpells) do
        local spellInfo = GARR_AUTO_SPELL[spell.autoCombatSpellID];
        if spellInfo then
            spellInfo.Name = spell.name;
            spellInfo.Description = spell.description;
            local spellObj = GarrAutoSpell:New(spellInfo);
            table.insert(self.Spells, spellObj);
        else
            -- todo: assert?
        end
    end
end

function GarrAutoCobatant:IsAlive()
    return self.CurHP > 0;
end

function GarrAutoCobatant:DecSpellCD()
    for _, spell in ipairs(self.Spells) do
        spell:DecCD();
    end
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
