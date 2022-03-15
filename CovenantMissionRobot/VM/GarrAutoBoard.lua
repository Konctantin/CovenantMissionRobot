local _, T = ...;

local pairs        = _G.pairs;
local ipairs       = _G.ipairs;
local math_frexp   = _G.math.frexp;
local math_floor   = _G.math.floor;
local math_min     = _G.math.min;
local math_max     = _G.math.max;
local table_insert = _G.table.insert;
local table_sort   = _G.table.sort;
local table_remove = _G.table.remove;
local table_concat = _G.table.concat;

local UseSimpleRounding = T.UseSimpleRounding;
local PREDEFINED_POINTS = T.PREDEFINED_POINTS;
local GarrAutoCobatant  = T.GarrAutoCobatant;
local TargetManager     = T.TargetManager;

local MAX_ROUNDS = 100;

local ET_MeleeDamage = 0;
local ET_RangeDamage = 1;
local ET_SpellMeleeDamage = 2;
local ET_SpellRangeDamage = 3;
local ET_Heal = 4;
local ET_PeriodicDamage = 5;
local ET_PeriodicHeal = 6;
local ET_ApplyAura = 7;
local ET_RemoveAura = 8;
local ET_Died = 9;

local function GetLogEventType(effect)
    if effect.SpellID == 11 then
        return ET_MeleeDamage;
    elseif effect.SpellID == 15 then
        return ET_RangeDamage;
    elseif effect.IsDamage and (effect.TargetType == 5 or effect.TargetType == 17) then
        return ET_SpellRangeDamage;
    elseif effect.IsDamage then
        return ET_SpellMeleeDamage;
    elseif effect.Effect == 7 then
        return ET_PeriodicDamage;
    elseif effect.IsHeal then
        return ET_Heal;
    elseif effect.Effect == 8 then
        return ET_PeriodicHeal;
    elseif effect.IsAura then
        return ET_ApplyAura;
    end
end

local function Extend(value)
    local neg = value < 0;
    local m, e = math_frexp(value);
    m = neg and -m or m;

    local lo = m % 2^-24;
    local a = lo >= 2^-25 and (lo > 2^-25 or m % 2^-23 >= 2^-24) and 2^-24 or 0;
    local rv = (m - lo + a) * 2^e;
    local result = neg and -rv or rv;

    return result;
end

local function RoundAttack(points, attack)
    local up = PREDEFINED_POINTS[points] or Extend(points);
    local val = attack * up;
    local val2 = Extend(val);
    local result = val2 - val2 % 1;
    return result;
end

local function Round(points, attack)
    if UseSimpleRounding then
        local value = points * attack;
        return math_floor(value);
    else
        return RoundAttack(points, attack);
    end
end

-- GarrAutoBoard --

local GarrAutoBoard = {
    MissionID       = 0,
    MissionScalar   = 0,
    MissionName     = "",
    Board           = { },
    CheckPoints     = { },
    Log             = { },
    BlizzardLog     = nil,
    LogEnabled      = false,
    HasRandomSpells = false,
    IsOver          = false,
    IsWin           = false,
    Round           = 1,
    Event           = 1,
    MinHP = { }, -- MinHP[boardIndex] = CurHP
    MaxHP = { }, -- MaxHP[boardIndex] = CurHP
};

function GarrAutoBoard:New(mission, unitList, environment)
    local obj = {
        MissionID = mission.missionID,
        MissionName = mission.missionName,
        MissionScalar = mission.missionScalar,
        Board = { },
        CheckPoints = { },
        Log = { },
        BlizzardLog = nil,
        LogEnabled = false,
        IsOver = false,
        IsWin = false,
        Round = 1,
        Event = 1,
        MinHP = { }, -- MinHP[boardIndex] = CurHP
        MaxHP = { }, -- MaxHP[boardIndex] = CurHP
    };

    if environment then
        local envUnit = GarrAutoCobatant:NewEnv(environment, mission);
        self.Board[-1] = envUnit;
    end

    for _, unit in ipairs(unitList) do
        local unitObj = GarrAutoCobatant:New(unit, mission.missionID);
        obj.Board[unitObj.BoardIndex] = unitObj;
    end

    for _, unit in pairs(obj.Board) do
        if unit and unit:HasRandomSpells() then
            obj.HasRandomSpells = true;
            break;
        end
    end

    self.__index = self;
    setmetatable(obj, self);

    return obj;
end

function GarrAutoBoard:SetupFollowers(folowers)
    for i = 0, 4 do
        self.Board[i] = nil;
    end

    for _, unit in ipairs(folowers) do
        local unitObj = GarrAutoCobatant:New(unit);
        self.Board[unitObj.BoardIndex] = unitObj;
    end
end

function GarrAutoBoard:SetupBlizzardLog(log)
    self.BlizzardLog = log;
end

function GarrAutoBoard:AddEvent(spell, effect, eventType, casterBoardIndex, targetInfo)
    if self.LogEnabled then
        local event = {
            spellID = spell.SpellID,
            casterBoardIndex = casterBoardIndex,
            type = eventType,
            schoolMask = spell.SchoolMask,
            effectIndex = effect and effect.EffectIndex or 0,
            auraType = 0, -- ???
            targetInfo = targetInfo,
        };

        if not self.Log[self.Round] then
            table_insert(self.Log, { events = {} })
        end

        local round = self.Log[self.Round];
        table_insert(round.events, event);
    end

    self.Event = self.Event + 1;
end

function GarrAutoBoard:CheckMissionOver()
    local folowers, enemies = 0, 0;
    for i, u in pairs(self.Board) do
        local isAlive = u and u.CurHP > 0;
        if i <= 4 and isAlive then
            folowers = folowers + 1;
        elseif i > 4 and isAlive then
            enemies = enemies + 1;
        end
    end
    self.IsWin = folowers > 0 and enemies == 0;
    self.IsOver = folowers == 0 or enemies == 0;
end

function GarrAutoBoard:GetTurnOrder()
    local order = { };
    local sort_table = { };

    for i = 0, 12 do
        local unit = self.Board[i];
        if unit then
            local ord = { BoardIndex = unit.BoardIndex,
                Ord = (i < 5 and 1e9 or 2e9) - unit.CurHP * 1e3 + i + 20 * (unit.DeathSeq or 0)
            };
            table_insert(sort_table, ord);
        end
    end

    table_sort(sort_table, function(a, b) return (a.Ord < b.Ord) end);

    for _, unit in pairs(sort_table) do
        table_insert(order, unit.BoardIndex);
    end

    if self.Board[-1] then
        table_insert(order, -1);
    end

    return order;
end;

function GarrAutoBoard:GetAdditionalDamage(sourceUnit, targetUnit, value)
    local auras = { };
    local dealt, taken = 1, 1;

    -- delat damage multiplier
    for _, aura in ipairs(sourceUnit.Auras) do
        if aura.Effect == 11 or aura.Effect == 12 then
            dealt = dealt + aura.BaseValue;
            auras[aura.SpellID] = aura.BaseValue + (auras[aura.SpellID] or 0);
        end
    end

    -- taken damage multiplier
    for _, aura in ipairs(targetUnit.Auras) do
        if aura.Effect == 13 or aura.Effect == 14 then
            taken = taken + aura.BaseValue;
            auras[aura.SpellID] = aura.BaseValue + (auras[aura.SpellID] or 0);
        end
    end

    local addDamage = 0;
    for _, aura in ipairs(sourceUnit.Auras) do
        -- AdditionalDamageDealt
        if aura.Effect == 19 then
            addDamage = addDamage + aura.BaseValue;
        end
    end

    for _, aura in ipairs(targetUnit.Auras) do
        -- AdditionalTakenDamage
        if (aura.Effect == 20) then
            addDamage = addDamage + aura.BaseValue;
        end
    end

    -- todo: test it
    local multiplier2 = 1;
    for _, v in pairs(auras) do
        multiplier2 = multiplier2 * (1 + v);
    end

    local multiplier = math_max(dealt * taken, 0);
    local result = multiplier * (value + addDamage);
    local result2 = multiplier2 * (value + addDamage);

    return result, result2; -- test it!
end

function GarrAutoBoard:CalculateEffectValue(sourceUnit, targetUnit, effect)
    local value = 0;

    if effect.IsReflect then
        value = Round(effect.Points, targetUnit.Attack);
    elseif effect.IsMaxHPMultilier then
        value = Round(effect.Points, targetUnit.MaxHP);
    else
        value = Round(effect.Points, sourceUnit.Attack);
    end

    if effect.IsDamage or effect.IsDot or effect.IsReflect then
        if effect.IsDot and not sourceUnit:IsAlive() then
            return value;
        end
        value = self:GetAdditionalDamage(sourceUnit, targetUnit, value);
    end

    local result = math_max(math_floor(value + 0.00000000001), 0);
    return result;
end

function GarrAutoBoard:GetBaseValue(effect, attack)
    if effect.UsePoints then
        return effect.Points;
    elseif effect.UseAttackForPoint then
        local result = Round(effect.Points, attack);
        return result;
    else
        return effect.Points;
    end
end

function GarrAutoBoard:ApplyAura(sourceUnit, targetUnit, spell, effect, value)
    local aura = GarrAutoAura:New(spell, effect, sourceUnit.BoardIndex, value);
    table_insert(targetUnit.Auras, aura);
    local result = 0
    if effect.IsDotOrHot and effect.ExtraInitialPeriod then
        local targetInfo = {
            BoardIndex = targetUnit.BoardIndex,
            MaxHP = targetUnit.MaxHP,
            OldHP = targetUnit.CurHP,
            NewHP = targetUnit.CurHP,
            Points = 0
        }
        self:AddEvent(aura, effect, ET_ApplyAura, sourceUnit.BoardIndex, { targetInfo });
        local info = self:CastSpellEffect(sourceUnit, targetUnit, {}, aura, true);
        result = info.Points;
    end

    if effect.IsTaunt then
        targetUnit.TauntedBy = sourceUnit.BoardIndex;
    elseif effect.IsUntargetable then
        targetUnit.Untargetable = true
    elseif effect.IsReflect then
        targetUnit.ReflectAura = aura;
    elseif effect.IsMaxHPMultilier then
        targetUnit.MaxHP = targetUnit.MaxHP + value;
        targetUnit.CurHP = math_min(targetUnit.MaxHP, targetUnit.CurHP + value);
    end
    return result;
end

function GarrAutoBoard:ManageAuras(targetUnit, sourceUnit, spell, effect)
    local i = 1;
    local removed = { };
    while i <= #targetUnit.Auras do
        local aura = targetUnit.Auras[i];
        if aura.SourceIndex == sourceUnit.BoardIndex and aura.ID == effect.ID then
            if aura.IsDotOrHot and (aura.CurrentPeriod == 0) then
                local targetInfo = self:CastSpellEffect(sourceUnit, targetUnit, {}, aura, true);
                local logEventType = GetLogEventType(aura);
                self:AddEvent(spell, aura, logEventType, sourceUnit.BoardIndex, {targetInfo});
                if not targetUnit:IsAlive() then
                    self:OnDie(sourceUnit, targetUnit, spell, targetInfo);
                end
            end

            aura:DecRestTime();

            -- Passive aura can be remove if source unit was died
            if aura.Duration == 0 or (aura.IsPassive and not sourceUnit:IsAlive()) then
                local targetInfo = {
                    BoardIndex = targetUnit.BoardIndex,
                    MaxHP = targetUnit.MaxHP,
                    OldHP = targetUnit.CurHP,
                    NewHP = targetUnit.CurHP,
                    Points = 0
                };
                table_remove(targetUnit.Auras, i);
                table_insert(removed, targetInfo);

                i = i - 1;

                if aura.IsTaunt then
                    targetUnit.TauntedBy = nil;
                elseif aura.IsUntargetable then
                    targetUnit.Untargetable = false;
                elseif aura.IsReflect then
                    targetUnit.ReflectAura = nil;
                elseif aura.IsMaxHPMultilier then
                    local value = aura.BaseValue; -- todo: fix it
                    targetUnit.CurHP = math_min(targetUnit.CurHP, targetUnit.MaxHP); -- if CurHP = 0 then die??
                    targetUnit.MaxHP = targetUnit.MaxHP - value;
                end
            end
        end
        i = i + 1;
    end
    return removed;
end

function GarrAutoBoard:ManageAurasForUnit(sourceUnit)
    for _, spell in ipairs(sourceUnit.Spells) do
        if not spell.IsAutoAttack then
            for _, effect in ipairs(spell.Effects) do
                local removed = { };
                for u = 0, 12 do
                    local targetUnit = self.Board[u];
                    if targetUnit then
                        local removedTargetInfo = self:ManageAuras(targetUnit, sourceUnit, spell, effect);
                        for _, ti in ipairs(removedTargetInfo) do
                            table_insert(removed, ti);
                        end
                    end
                end
                if #removed > 0 then
                    self:AddEvent(spell, effect, ET_RemoveAura, sourceUnit.BoardIndex, removed);
                end
            end
        end
    end
end

function GarrAutoBoard:CastSpellEffect(sourceUnit, targetUnit, spell, effect, isAura)
    local oldTargetHP = targetUnit.CurHP;
    local value = 0;

    if effect.IsDamage or (isAura and (effect.IsDot or effect.IsReflect)) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math_max(0, targetUnit.CurHP - value);

    elseif effect.IsHeal or (isAura and effect.IsHot) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math_min(targetUnit.MaxHP, targetUnit.CurHP + value);

    else
        -- TODO: this we need calculate value more correctly
        value = self:GetBaseValue(effect, sourceUnit.Attack);
        value = self:ApplyAura(sourceUnit, targetUnit, spell, effect, value);
    end

    spell.WasCasted = true;
    local targetInfo = {
        BoardIndex = targetUnit.BoardIndex,
        MaxHP = targetUnit.MaxHP,
        OldHP = oldTargetHP,
        NewHP = targetUnit.CurHP,
        Points = value
    };
    return targetInfo;
end

function GarrAutoBoard:PrepareCast(targets, spell, effect)
    local result = true;
    if #spell.Effects == 1 and (effect.IsHeal or effect.IsHot) then
        local needHeal = false;
        for _, targetIndex in ipairs(targets) do
            local unit = self.Board[targetIndex];
            if unit and unit.CurHP < unit.MaxHP then
                needHeal = true;
            end
        end
        if not needHeal then
            result = false;
        end
    end
    return result;
end

function GarrAutoBoard:OnTakeDamage(sourceUnit, spell, effect, eventTargetInfo)
    local targetUnit = self.Board[eventTargetInfo.BoardIndex];
    local reflAura = targetUnit.ReflectAura;
    if effect.IsDamage and targetUnit and reflAura then
        local reflTargetInfo = self:CastSpellEffect(targetUnit, sourceUnit, spell, reflAura, true);
        -- can be mele or range
        local logEventType = GetLogEventType(effect);
        self:AddEvent(reflAura, effect, logEventType, targetUnit.BoardIndex, { reflTargetInfo });
        self:OnTakeDamage(sourceUnit, spell, reflAura, reflTargetInfo);
    end

    -- unit died
    if eventTargetInfo.NewHP == 0 then
        self:OnDie(sourceUnit, targetUnit, spell, effect, eventTargetInfo)
        self:CheckMissionOver();
    end
end

function GarrAutoBoard:OnDie(sourceUnit, targetUnit, spell, effect, eventTargetInfo)
    -- clear taunt and calc died order
    local diedOrder = 0;
    for i = 0, 12 do
        local unit = self.Board[i];
        if unit then
            if unit.TauntedBy == sourceUnit.BoardIndex then
                unit.TauntedBy = nil;
            end
            -- max died order
            if (unit.DeathSeq or 0) > diedOrder then
                diedOrder = (unit.DeathSeq or 0);
            end
        end
    end

    targetUnit.DeathSeq = diedOrder + 1;

    self:AddEvent(spell, effect, ET_Died, sourceUnit.BoardIndex, {eventTargetInfo});
end

function GarrAutoBoard:GetTargets(unit, targetType, lastTargetType, lastTargetIndexes)
    local mainTarget = unit.TauntedBy;

    -- for check and debugging random spell effects
    if self.BlizzardLog and (targetType == 19 or targetType == 20 or targetType == 21) then
        local roundInfo = self.BlizzardLog[self.Round];
        if roundInfo and roundInfo.events and #roundInfo.events > 0 then
            local eventInfo = roundInfo.events[self.Event];
            if eventInfo and eventInfo.targetInfo and #eventInfo.targetInfo == 1 then
                mainTarget = eventInfo.targetInfo[1].boardIndex;
                if not self.Board[mainTarget] then
                    assert(nil, "Not exists on board");
                    --mainTarget = unit.TauntedBy;
                end
            end
        end
    end

    -- update targets if skill has different effects target type
    if lastTargetType ~= targetType and targetType ~= 0 then
        local aliveUnits = unit:GetTargetableUnits(self.Board);
        local targets, isRandomFork = TargetManager:GetTargetIndexes(unit.BoardIndex, targetType, aliveUnits, mainTarget);
        return targets, isRandomFork;
    else
        return lastTargetIndexes;
    end
end

function GarrAutoBoard:ApplyPassiveAura(turnOrder)
    for _, boardIndex in ipairs(turnOrder) do
        local sourceUnit = self.Board[boardIndex];
        if sourceUnit then
            for _, spell in ipairs(sourceUnit.Spells) do
                if spell.IsPassive then
                    for _, effect in ipairs(spell.Effects) do
                        local targetInfo = { };
                        local targetIndexes = self:GetTargets(sourceUnit, effect.TargetType, -1);
                        for _, targetIndex in ipairs(targetIndexes) do
                            local targetUnit = self.Board[targetIndex];
                            local eventTargetInfo = self:CastSpellEffect(sourceUnit, targetUnit, spell, effect, false);
                            table_insert(targetInfo, eventTargetInfo);
                        end
                        self:AddEvent(spell, effect, ET_ApplyAura, sourceUnit.BoardIndex, targetInfo);
                    end
                end
            end
        end
    end
end

function GarrAutoBoard:MakeAction(sourceUnit)
    if self.IsOver then
        return;
    end

    self:ManageAurasForUnit(sourceUnit);

    if not sourceUnit:IsAlive() then
        return;
    end

    local targetIndexes, isRandomFork, lastTargetType = nil, nil, nil;

    sourceUnit:DecSpellCD();
    local spells = sourceUnit:GetAvailableSpells();
    for _, spell in ipairs(spells) do
        if self.IsOver then
            break;
        end

        lastTargetType = -1
        for _, effect in ipairs(spell.Effects) do
            targetIndexes, isRandomFork = self:GetTargets(sourceUnit, effect.TargetType, lastTargetType, targetIndexes);
            -- todo:
            local needCast = self:PrepareCast(targetIndexes, spell, effect);
            if needCast then
                local targetInfo = { };
                -- hack: if spell does'nt work
                if effect.TargetType == 0 then
                    spell.WasCasted = true;
                else
                    for _, targetIndex in ipairs(targetIndexes) do
                        local targetUnit = self.Board[targetIndex];
                        local eventTargetInfo = self:CastSpellEffect(sourceUnit, targetUnit, spell, effect, false);
                        table_insert(targetInfo, eventTargetInfo);
                    end
                end

                local logEventType = GetLogEventType(effect);
                self:AddEvent(spell, effect, logEventType, sourceUnit.BoardIndex, targetInfo);

                for _, unitInfo in pairs(targetInfo) do
                    self:OnTakeDamage(sourceUnit, spell, effect, unitInfo);
                end

                -- set last target
                if effect.TargetType ~= 0 then
                    lastTargetType = effect.TargetType;
                end
            end
        end

        spell:StartCD();
    end
end

function GarrAutoBoard:Step()
    self.Event = 1;
    local turnOrder = self:GetTurnOrder();

    if self.Round == 1 then
        self:ApplyPassiveAura(turnOrder);
    end

    for _, boardIndex in ipairs(turnOrder) do
        local unit = self.Board[boardIndex];
        if unit then
            self:MakeAction(unit);
        end
    end

    self:AddCheckpoint();
end

function GarrAutoBoard:AddCheckpoint(index)
    local unitsInfo = {};
    for i = 0, 12 do
        local unit = self.Board[i];
        if unit and unit:IsAlive() then
            table_insert(unitsInfo, ("%x:%d"):format(i, unit.CurHP));
        end
    end

    local checkpoint = table_concat(unitsInfo, "_");
    if index then
        self.CheckPoints[index] = checkpoint;
    else
        table_insert(self.CheckPoints, checkpoint);
    end

    local idx = #self.CheckPoints;
    if self.CheckPoints[idx] == self.CheckPoints[idx-1] then
        self.CheckPoints[idx] = nil;
    end
end

function GarrAutoBoard:Run()
    self:Reset();
    self:AddCheckpoint(0);
    while not self.IsOver and self.Round < MAX_ROUNDS do
        self:Step();
        self:CheckMissionOver();
        self.Round = self.Round + 1;
    end
end

function GarrAutoBoard:Reset()
    self.IsOver = false;
    self.IsWin = false;
    self.Round = 1;
    self.Event = 1;
    self.CheckPoints = { };
    self.Log = { };
    for _, unit in pairs(self.Board) do
        if unit then
            unit:Reset();
        end
    end
end

T.GarrAutoBoard = GarrAutoBoard;
