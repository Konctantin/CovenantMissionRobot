local _, T = ...;

local MAX_ROUNDS = 100;
local RANDOM_SIMULATIONS = 100;

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

-- GarrAutoBoard --

local GarrAutoBoard = {
    MissionID        = 0,
    MissionScalar    = 0,
    MissionName      = "",
    Board            = { },
    CheckPoints      = { },
    Log              = { },
    LogEnabled       = false,
    HasRandomSpells  = false,
    IsOver           = false,
    IsWin            = false,
    Round            = 1,
    Event            = 1,
};

function GarrAutoBoard:New(mission, unitList, environment)
    local obj = {
        MissionID = mission.missionID,
        MissionName = mission.missionName,
        MissionScalar = mission.missionScalar,
        Board = { },
        CheckPoints = { },
        Log = { },
        LogEnabled = false,
        IsOver = false,
        IsWin = false,
        Round = 1,
        Event = 1
    };

    if environment then
        local envUnit = T.GarrAutoCobatant:NewEnv(environment, mission);
        self.Board[-1] = envUnit;
    end

    for _, unit in ipairs(unitList) do
        local unitObj = T.GarrAutoCobatant:New(unit, mission.missionID);
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

function GarrAutoBoard:AddEvent(spell, effect, eventType, casterBoardIndex, targetInfo)
    if self.LogEnabled then
        -- small hack
        if eventType == ET_ApplyAura then
            for _,v in ipairs(targetInfo) do
                v.Points = 0;
            end
        end
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
            table.insert(self.Log, { events = {} })
        end

        local round = self.Log[self.Round];
        table.insert(round.events, event);
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
            table.insert(sort_table, ord);
        end
    end

    table.sort(sort_table, function(a, b) return (a.Ord < b.Ord) end);

    for _, unit in pairs(sort_table) do
        table.insert(order, unit.BoardIndex);
    end

    if self.Board[-1] then
        table.insert(order, -1);
    end

    return order;
end;

function GarrAutoBoard:ManageAppliedAura(sourceUnit)
    local s = 1
    for i = 1, #sourceUnit.Spells do
        local spell = sourceUnit.Spells[i];
        if spell and not spell.IsAutoAttack then
            local removed_auras = { };

            for u = 0, 12 do
                local unit = self.Board[u];
                if unit and unit:IsAlive() then
                    local removed = self:ManageAura(unit, sourceUnit, sourceUnit.Spells[i]);
                    for _, rinfo in ipairs(removed) do
                        table.insert(removed_auras, rinfo);
                    end
                end
            end

            if #removed_auras > 0 then
                local targets = { };
                for _, v in ipairs(removed_auras) do
                    local targetInfo = {
                        BoardIndex = v.Unit.BoardIndex,
                        MaxHP = v.Unit.MaxHP,
                        OldHP = v.Unit.CurHP,
                        NewHP = v.Unit.CurHP,
                        Points = 0
                    };
                    table.insert(targets, targetInfo);
                end
                self:AddEvent(spell, nil, ET_RemoveAura, sourceUnit.BoardIndex, targets);
            end
        end
    end
end

function GarrAutoBoard:ApplyAura(sourceUnit, targetUnit, spell, effect, value)
    if effect.IsTaunt then
        targetUnit.TauntedBy = sourceUnit.BoardIndex;
    elseif effect.IsUntargetable then
        targetUnit.Untargetable = true
    elseif effect.IsReflect then
        targetUnit.Reflect = value;
    end

    local aura = GarrAutoAura:New(spell, effect, sourceUnit.BoardIndex, value);
    table.insert(targetUnit.Auras, aura);

    -- extra initial period and DoT or HoT
    if effect.IsDotOrHot and (effect.Flags == 2 or effect.Flags == 3) then
        local targetInfo = {
            BoardIndex = targetUnit.BoardIndex,
            MaxHP = targetUnit.MaxHP,
            OldHP = targetUnit.CurHP,
            NewHP = targetUnit.CurHP,
            Points = 0
        }
        self:AddEvent(aura, effect, ET_ApplyAura, sourceUnit.BoardIndex, { targetInfo });

        self:CastSpellEffect(sourceUnit, targetUnit, {}, aura, true);
    end
end

function GarrAutoBoard:ManageAura(targetUnit, sourceUnit, spell)
    local removed_auras = { };

    local i = 1;
    while i <= #targetUnit.Auras do
        local aura = targetUnit.Auras[i];
        if aura.SourceIndex == sourceUnit.BoardIndex and aura.SpellID == spell.SpellID then
            if aura.IsDotOrHot and (aura.CurrentPeriod == 0) then
                local targetInfo = self:CastSpellEffect(sourceUnit, targetUnit, {}, aura, true);
                local logEventType = T.GetLogEventType(aura);
                self:AddEvent(spell, aura, logEventType, sourceUnit.BoardIndex, {targetInfo});
                if not targetUnit:IsAlive() then
                    self:OnDie(sourceUnit, targetUnit, spell, targetInfo);
                end
            end

            aura:DecRestTime();

            -- Passive aura can be remove if source unit was died
            if aura.Duration == 0 or (aura.IsPassive and not sourceUnit:IsAlive()) then
                if aura.IsTaunt then
                    targetUnit.TauntedBy = nil;
                elseif aura.IsUntargetable then
                    targetUnit.Untargetable = false;
                elseif aura.IsReflect then
                    targetUnit.Reflect = 0;
                end

                table.insert(removed_auras, { Aura = aura, Unit = targetUnit });
                table.remove(targetUnit.Auras, i);
                i = i - 1;
            end
        end
        i = i + 1;
    end

    return removed_auras;
end

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
        if aura.Effect == 20 then
            addDamage = addDamage + aura.BaseValue;
        end
    end

    -- todo: test it
    local multiplier2 = 1;
    for _, v in pairs(auras) do
        multiplier2 = multiplier2 * (1 + v);
    end

    local multiplier = math.max(dealt * taken, 0);
    local result = multiplier * (value + addDamage);
    local result2 = multiplier2 * (value + addDamage);

    return result, result2; -- test it!
end

function GarrAutoBoard:CalculateEffectValue(sourceUnit, targetUnit, effect)
    local value = 0;

    if effect.IsReflect then
        value = sourceUnit.Reflect;
    elseif effect.IsMaxHPMultilier then
        value = math.floor(effect.Points * targetUnit.MaxHP);
    else
        value = math.floor(effect.Points * sourceUnit.Attack);
    end

    if effect.IsDamage or effect.IsDot or effect.IsReflect then
        if effect.IsDot and not sourceUnit:IsAlive() then
            return value;
        end
        value = self:GetAdditionalDamage(sourceUnit, targetUnit, value);
    end

    return math.max(math.floor(value + 0.00000000001), 0);
end

function GarrAutoBoard:GetBaseValue(effect, attack)
    if effect.UsePoints then
        return effect.Points;
    elseif effect.UseAttackForPoint then
        return math.floor(effect.Points * attack);
    else
        return effect.Points;
    end
end

function GarrAutoBoard:CastSpellEffect(sourceUnit, targetUnit, spell, effect, isAura)
    local oldTargetHP = targetUnit.CurHP;
    local value = 0;

    if effect.IsDamage or (isAura and effect.IsDot or effect.IsReflect) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math.max(0, targetUnit.CurHP - value);

    elseif effect.IsHeal or (isAura and effect.IsHot) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math.min(targetUnit.MaxHP, targetUnit.CurHP + value);

    elseif effect.Effect == 18 then -- Maximum health multiplier
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.MaxHP = targetUnit.MaxHP + value;
        targetUnit.CurHP = math.min(targetUnit.MaxHP, targetUnit.CurHP + value);

    else
        value = self:GetBaseValue(effect, sourceUnit.Attack);
        self:ApplyAura(sourceUnit, targetUnit, spell, effect, value);
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
    if effect.IsDamage and targetUnit and targetUnit.Reflect > 0 then
        local reflEffect = { EffectIndex = 0, Effect = 15, IsReflect = true };
        local reflTargetInfo = self:CastSpellEffect(targetUnit, sourceUnit, { }, reflEffect, true);
        -- can be mele or range
        self:AddEvent(spell, effect, ET_MeleeDamage, targetUnit.BoardIndex, { reflTargetInfo });
        self:OnTakeDamage(sourceUnit, spell, reflEffect, reflTargetInfo);
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
    -- update targets if skill has different effects target type
    if lastTargetType ~= targetType and targetType ~= 0 then
        local aliveUnits = unit:GetTargetableUnits(self.Board);
        return T.TargetManager:GetTargetIndexes(unit.BoardIndex, targetType, aliveUnits, unit.TauntedBy);
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
                            table.insert(targetInfo, eventTargetInfo);
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

    self:ManageAppliedAura(sourceUnit);

    if not sourceUnit:IsAlive() then
        return;
    end

    -- Decrease spell cooldown
    for _, spell in ipairs(sourceUnit.Spells) do
        spell:DecCD();
    end

    local targetIndexes, lastTargetType = nil, nil;

    local spells = sourceUnit:GetAvailableSpells();
    for _, spell in ipairs(spells) do
        if self.IsOver then
            break;
        end

        lastTargetType = -1
        for _, effect in ipairs(spell.Effects) do
            targetIndexes = self:GetTargets(sourceUnit, effect.TargetType, lastTargetType, targetIndexes);

            local needCast = self:PrepareCast(targetIndexes, spell, effect);
            if needCast then
                local targetInfo = { };
                for _, targetIndex in ipairs(targetIndexes) do
                    local targetUnit = self.Board[targetIndex];
                    local eventTargetInfo = self:CastSpellEffect(sourceUnit, targetUnit, spell, effect, false);
                    table.insert(targetInfo, eventTargetInfo);
                end

                local logEventType = T.GetLogEventType(effect);
                self:AddEvent(spell, effect, logEventType, sourceUnit.BoardIndex, targetInfo);

                for _, unitInfo in pairs(targetInfo) do
                    self:OnTakeDamage(sourceUnit, spell, effect, unitInfo);
                end

                -- set last target
                if effect.TargetType ~= 0 then
                    lastTargetType = effect.TargetType
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
            table.insert(unitsInfo, string.format("%x:%d", i, unit.CurHP));
        end
    end

    local checkpoint = table.concat(unitsInfo, "_");
    if index then
        self.CheckPoints[index] = checkpoint;
    else
        table.insert(self.CheckPoints, checkpoint);
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
