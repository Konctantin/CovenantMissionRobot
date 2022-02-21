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
        IsPassive    = spellInfo.IsPassive or false,
        IsAutoAttack = spellInfo.IsAutoAttack or false,
        Name         = spellInfo.Name,
        Effects      = spellInfo.Effects,
        CurCD        = spellInfo.Flags == 1 and spellInfo.Cooldown or 0,
        HasRandom    = spellInfo.HasRandomEffect or false,
        WasCasted    = false,
    };

    self.__index = self;
    setmetatable(obj, self);

    return obj;
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

-- GarrAutoBuff --

GarrAutoBuff = {
    ID            = 0,
    SpellID       = 0,
    Effect        = 0,
    TargetType    = 0,
    Flags         = 0,
    Points        = 0,
    Period        = 0,
    CurrentPeriod = 0,
    BaseValue     = 0,
    SourceIndex   = 0,
    Duration      = 0,
    Name          = ""
};

function GarrAutoBuff:New(effect, effectBaseValue, sourceIndex, duration, name)
    local obj = {
        ID         = effect.ID,
        Effect     = effect.Effect,
        SpellID    = effect.SpellID,
        TargetType = effect.TargetType,
        Flags      = effect.Flags,
        Period     = effect.Period,
        Points     = effect.Points,
        BaseValue  = effectBaseValue;
        SourceIndex= sourceIndex;
        Duration   = duration or 0;
        Name       = name;
    };

    obj.Period        = math.max(obj.Period - 1, 0);
    obj.CurrentPeriod = math.max(obj.Period, 0);

    self.__index = self;
    return setmetatable(obj, self);
end

function GarrAutoBuff:DecRestTime()
    self.Duration = math.max(self.Duration - 1, 0);
    self.CurrentPeriod = self.CurrentPeriod == 0 and self.Period or math.max(self.CurrentPeriod - 1, 0);
    return self.Duration;
end

T.GarrAutoSpell = GarrAutoSpell;
T.GarrAutoBuff  = GarrAutoBuff;
