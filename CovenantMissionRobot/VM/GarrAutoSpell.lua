local _, T = ...;

-- GarrAutoSpell --

local GarrAutoSpell = {
    SpellID      = 0,   -- Auto combatant spell id
    Cooldown     = 0,
    Duration     = 0,
    Flags        = 0,   -- 1-Has start cooldown
    SchoolMask   = 0,   -- 1-Physical, 2-Holly, 4-Fire, 8-Nature, 16-Frost, 32-Shadow, 64-Arcane
    Effects      = { }, -- Spell effect list
    CurCD        = 0,
    IsPassive    = false,
    IsAutoAttack = false,
    WasCasted    = false,
    HasRandom    = false,
};

function GarrAutoSpell:New(spellInfo)
    local obj = {
        SpellID      = spellInfo.SpellID,
        Cooldown     = spellInfo.Cooldown,
        Duration     = spellInfo.Duration,
        Flags        = spellInfo.Flags,
        SchoolMask   = spellInfo.SchoolMask,
        IsPassive    = spellInfo.IsPassive,
        IsAutoAttack = spellInfo.IsAutoAttack,
        Name         = spellInfo.Name,
        Effects      = spellInfo.Effects,
        HasRandom    = spellInfo.HasRandomEffect or false,
    };

    self.__index = self;
    setmetatable(obj, self);

    obj:Reset();

    return obj;
end

function GarrAutoSpell:Reset()
    self.CurCD = self.Flags == 1 and self.Cooldown or 0;
    self.WasCasted = false;
end

function GarrAutoSpell:StartCD()
    if self.WasCasted then
        self.CurCD = self.Cooldown + 1;
    end
    self.WasCasted = false;
end

function GarrAutoSpell:DecCD()
    if self.CurCD > 0 then
        self.CurCD = self.CurCD - 1;
    end
end

-- GarrAutoAura --

GarrAutoAura = {
    ID            = 0,
    SpellID       = 0,
    EffectIndex   = 0,
    Effect        = 0,
    TargetType    = 0,
    Flags         = 0,
    Points        = 0,
    Period        = 0,
    CurrentPeriod = 0,
    BaseValue     = 0,
    SourceIndex   = 0,
    Duration      = 0,
    IsPassive     = false,
    Name          = ""
};

function GarrAutoAura:New(spell, effect, sourceIndex, value)
    local obj = {
        Duration     = spell.Duration;
        Name         = spell.Name;
        IsAutoAttack = spell.IsAutoAttack,
        SourceIndex  = sourceIndex;
        BaseValue    = value;
    };

    for k, v in pairs(effect) do
        obj[k] = v;
    end

    obj.Period        = math.max(obj.Period - 1, 0);
    obj.CurrentPeriod = math.max(obj.Period, 0);

    self.__index = self;
    return setmetatable(obj, self);
end

function GarrAutoAura:DecRestTime()
    self.Duration = math.max(self.Duration - 1, 0);
    self.CurrentPeriod = self.CurrentPeriod == 0 and self.Period or math.max(self.CurrentPeriod - 1, 0);
    return self.Duration;
end

T.GarrAutoSpell = GarrAutoSpell;
T.GarrAutoAura  = GarrAutoAura;
