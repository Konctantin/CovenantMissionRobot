local _, T = ...;

local MAX_ROUNDS = 100;
local RANDOM_SIMULATIONS = 100;
local LL_INFO, LL_ERROR, LL_DEBUG  = 1, 2, 3;

local passiveSpells = { [47]=1, [82]=1, [90]=1, [105]=1, [109]=1 };

local GetAutoAttackSpellId do
    local M, R = 11, 15;
    local enemies = {
        -- [boardIndex] = {[missionId]=R (range spell id)}
        [05] = { [2172]=M,[2176]=M,[2196]=M,[2207]=M,[2209]=M,[2202]=M,[2214]=M,[2312]=M,[2304]=M },
        [06] = { [2304]=M,[2305]=M,[2311]=M,[2314]=M,[2315]=M,[2316]=M,[2317]=M,[2260]=M,[2209]=M,[2213]=M,[2176]=M,[2196]=M,[2207]=M,[2169]=M },
        [07] = { [2169]=M,[2172]=M,[2176]=M,[2196]=M,[2209]=M,[2207]=M,[2260]=M,[2305]=M,[2304]=M },
        [08] = { [2305]=M,[2304]=M,[2214]=M,[2207]=M,[2209]=M,[2196]=M,[2176]=M,[2172]=M },
        [09] = { [2204]=M,[2208]=M,[2239]=M,[2212]=M,[2252]=M,[2293]=M,[2298]=M,[2313]=M,[2259]=M,[2301]=M,[2307]=M,[2304]=M,[2303]=M },
        [10] = { [2304]=M,[2307]=M,[2303]=M,[2298]=M,[2252]=M,[2239]=M,[2243]=M,[2212]=M,[2201]=M,[2238]=M,[2241]=M,[2205]=M,[2169]=M },
        [11] = { [2169]=M,[2172]=M,[2209]=M,[2208]=M,[2205]=M,[2214]=M,[2224]=M,[2239]=M,[2259]=M,[2303]=M,[2287]=M,[2279]=M,[2252]=M,[2307]=M,[2304]=M },
        [12] = { [2304]=M,[2307]=M,[2298]=M,[2293]=M,[2303]=M,[2313]=M,[2252]=M,[2212]=M,[2239]=M,[2215]=M,[2204]=M,[2208]=M },
    };

    -- [FirstSpellID] = R (range spell id)
    local followers = { [14]=M, [45]=M, [85]=M, [194]=M, [303]=M, [306]=M, [309]=M, [314]=M, [325]=M };

    function GetAutoAttackSpellId(role, missionId, boardIndex, firstSpell)
        -- Default: meele or tank
        local attackSpellId = (role == 1 or role == 5) and M or R;

        -- Enemies
        if (boardIndex or 0) > 4 and missionId then
            attackSpellId = enemies[boardIndex] and enemies[boardIndex][missionId] or attackSpellId;
        -- Followers
        elseif firstSpell then
            attackSpellId = followers[firstSpell] or attackSpellId;
        end

        return attackSpellId;
    end
end

local function IsFriendlyUnit(sourceIndex, targetIndex)
    return (sourceIndex < 5 and targetIndex < 5)
        or (sourceIndex > 4 and targetIndex > 4)
        or (sourceIndex == -1 and targetIndex > 4);
end

local function IsDamageEffect(effect, isAppliedBuff)
    return effect.Effect == 1 --Damage
        or effect.Effect == 3 -- Damage_2
        or (
            (effect.Effect == 7  -- DoT
          or effect.Effect == 15 -- Reflect
          or effect.Effect == 16 -- Reflect_2
            ) and isAppliedBuff
           );
end

-- GarrAutoSpellEffect

local GarrAutoSpellEffect = {
    ID         = 0,
    SpellID    = 0,
    Effect     = 0,
    TargetType = 0,
    Flags      = 0,
    Period     = 0,
    Points     = 0,

    IsDamage = false,
    IsHeal   = false,
    IsAura   = false,
};

function GarrAutoSpellEffect:New(effectInfo)
    local obj = {
        ID         = effectInfo.ID,
        SpellID    = effectInfo.SpellID,
        Effect     = effectInfo.Effect,
        TargetType = effectInfo.TargetType,
        Flags      = effectInfo.Flags,
        Period     = effectInfo.Period,
        Points     = effectInfo.Points,
    };

    obj.IsAura   = obj.Effect >= 7;
    obj.IsDamage = obj.Effect == 1 or obj.Effect == 3;
    obj.IsHeal   = obj.Effect == 2 or obj.Effect == 4;

    self.__index = self;
    setmetatable(obj, self);

    return obj;
end

function GarrAutoSpellEffect:GetBaseValue(attack)
    -- isn't work in game DamageDealtMultiplier (11) ???
    if self.Effect == 11 -- DamageDealtMultiplier
    or self.Effect == 12 -- DamageDealtMultiplier_2
    or self.Effect == 13 -- DamageTakenMultiplier
    or self.Effect == 14 -- DamageTakenMultiplier_2
    or self.Effect == 15 -- Reflect
    or self.Effect == 16 -- Reflect_2
    then
        return self.Points;
    -- elseif bit.band(effect.Flags, 1) > 0 then
    elseif self.Flags == 1 or self.Flags == 3 then
        return math.floor(self.Points * attack);
    else
        return self.Points;
    end
end

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
        SpellID    = spellInfo.SpellID,
        Cooldown   = spellInfo.Cooldown,
        Duration   = spellInfo.Duration,
        Flags      = spellInfo.Flags,
        SchoolMask = spellInfo.SchoolMask,
        Name       = spellInfo.Name,
        Effects = {},
        CurCD = 0,
        IsAutoAttack = false,
        WasCasted = false,
        HasRandom = false,
    };

    for _, effectInf in ipairs(spellInfo.Effects) do
        local effect = GarrAutoSpellEffect:New(effectInf);
        table.insert(obj.Effects, effect);

        local tt = effectInf.TargetType;
        if tt == 19 or tt == 20 or tt == 21 then
            obj.HasRandom = true;
        end
    end

    -- setup start cooldown
    obj.CurCD = obj.Flags == 1 and obj.Cooldown or 0;

    -- 11-meele, 15-range
    obj.IsAutoAttack = obj.SpellID == 11 or obj.SpellID == 15;

    obj.IsPassive = passiveSpells[obj.SpellID];

    self.__index = self;
    setmetatable(obj, self);

    return obj;
end

function GarrAutoSpell:HasStartCD()
    return self.Flags == 1;
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

-- GarrAutoCobatant --

local GarrAutoCobatant = {
    FollowerGUID  = nil, -- for compare log and simulation
    Buffs         = { },
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
        Buffs        = { }
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
        local autoAttackSpell = GarrAutoSpell:New(autoAttackSpellInfo);
        table.insert(self.Spells, autoAttackSpell);
    end

    -- Regular spells
    for i, spell in pairs(autoCombatSpells) do
        local spellInfo = T.GARR_AUTO_SPELL[spell.autoCombatSpellID];
        if spellInfo then
            spellInfo.Name = spell.name;
            local spellObj = GarrAutoSpell:New(spellInfo);

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

-- Board --

local GarrAutoBoard = {
    MissionID        = 0,
    MissionScalar    = 0,
    MissionName      = "",
    Units            = { },
    Environment      = nil,
    HasRandomSpells  = false,
    IsOver           = false,
    OnEvent          = nil,
    OnLog            = nil,
    Round            = 0,
    Event            = 0,
};

function GarrAutoBoard:Log(msg, level)
    if self.OnLog then
        self.OnLog(msg, level);
    end
end

function GarrAutoBoard:AddEvent(spell, effectType, boardIndex, targetInfo)
    if self.OnEvent then
        self.OnEvent(self.Round, self.Event, spell, effectType, boardIndex, targetInfo);
    end
    self.Event = self.Event + 1;
end

function GarrAutoBoard:New(mission, unitList, environment)
    local obj = {
        MissionID = mission.missionID,
        MissionName = mission.missionName,
        MissionScalar = mission.missionScalar,
        Units = { },
        Environment = nil,
        Round = 1,
        Event = 1
    };

    if environment then
        obj.Environment = self:MakeEnv(environment, mission);
        obj.HasRandomSpells = #obj.Environment.Spells == 1 and obj.Environment.Spells[1].HasRandom;
    end

    for _, unit in ipairs(unitList) do
        local unitObj = GarrAutoCobatant:New(unit, mission.missionID);
        obj.Units[unitObj.BoardIndex] = unitObj;

        for _, spell in ipairs(unitObj.Spells) do
            if spell.HasRandom then
                obj.HasRandomSpells = true;
            end
        end
    end

    self.__index = self;
    setmetatable(obj, self);

    return obj;
end

function GarrAutoBoard:MakeEnv(environment, mission)
    local env = {
        name       = environment.EnvironmentName,
        level      = 0,
        maxHealth  = 1e8,
        health     = 1e8,
        attack     = 1,
        boardIndex = -1,
        role       = 0,
        autoCombatSpells = {
            {
                autoCombatSpellID = environment.SpellID,
                name = environment.SpellName
            }
        }
    };

    local obj = GarrAutoCobatant:New(env, mission.missionID);
    obj.Untargetable = true;

    return obj;
end

function GarrAutoBoard:IsTargetableUnit(sourceIndex, targetIndex)
    return self:IsUnitAlive(targetIndex)
        and (not self.Units[targetIndex].Untargetable or IsFriendlyUnit(sourceIndex, targetIndex));
end

function GarrAutoBoard:GetTargetableUnits(sourceIndex)
    local result = { };

    for i = 0, 12 do
        result[i] = self:IsTargetableUnit(sourceIndex, i);
    end

    return result;
end

function GarrAutoBoard:IsUnitAlive(boardIndex)
    local unit = self.Units[boardIndex];
    return unit and unit:IsAlive() or false;
end

function GarrAutoBoard:CheckMissionOver()
    local isMyTeamAlive = false;
    for i = 0, 4 do
        if self:IsUnitAlive(i) then
            isMyTeamAlive = true;
            break;
        end
    end

    local isEnemyTeamAlive = false;
    for i = 5, 12 do
        if self:IsUnitAlive(i) then
            isEnemyTeamAlive = true;
            break;
        end
    end

    return not (isMyTeamAlive and isEnemyTeamAlive);
end

function GarrAutoBoard:GetTurnOrder()
    local order = { };
    local sort_table = { };

    for i = 0, 12 do
        local unit = self.Units[i];
        if unit then
            local ord = { BoardIndex = unit.BoardIndex,
                Ord = (i < 5 and 1e9 or 2e9) - unit.CurHP * 1e3 + i + 20 * (unit.DeathSeq or 0)
            };
            --print(unit.BoardIndex, ord.Ord)
            table.insert(sort_table, ord);
        end
    end

    table.sort(sort_table, function(a, b) return (a.Ord < b.Ord) end);

    for _, unit in pairs(sort_table) do
        table.insert(order, unit.BoardIndex);
    end

    return order;
end;

function GarrAutoBoard:ManageAppliedAura(sourceUnit)
    local s = 1
    for i = 1, #sourceUnit.Spells do
        local spell = sourceUnit.Spells[i];
        if spell and not spell.IsAutoAttack then
            local removed_buffs = { };

            for u = 0, 12 do
                local unit = self.Units[u];
                if unit and unit:IsAlive() then
                    local buffs = self:ManageAura(unit, sourceUnit, sourceUnit.Spells[i]);
                    for _, buff in ipairs(buffs) do
                        table.insert(removed_buffs, { Buff = buff, Unit = unit });
                    end
                end
            end

            if #removed_buffs > 0 then
                local targets = { };
                for _, v in ipairs(removed_buffs) do
                    table.insert(targets, {
                        BoardIndex = v.Buff.targetBoardIndex,
                        OldHealth = v.Unit.CurHP,
                        NewHealth = v.Unit.CurHP,
                        Points = 0
                    });
                end
                self:AddEvent(spell, "RemoveAura", sourceUnit.BoardIndex, targets);
            end
        end
    end
end

function GarrAutoBoard:ApplyAura(sourceUnit, targetUnit, effect, effectBaseValue, duration, name)
    local buff = GarrAutoBuff:New(effect, effectBaseValue, sourceUnit.BoardIndex, duration, name);
    table.insert(targetUnit.Buffs, buff);

    -- Taunt
    if effect.Effect == 9 then
        targetUnit.TauntedBy = sourceUnit.BoardIndex;
    -- Untargetable
    elseif effect.Effect == 10 then
        targetUnit.Untargetable = true
    -- Reflect
    elseif effect.Effect == 15 or effect.Effect == 16 then
        targetUnit.Reflect = effectBaseValue;
    end

    -- extra initial period and DoT or HoT
    if  (effect.Flags == 2 or effect.Flags == 3)
    and (buff.Effect  == 7 or buff.Effect  == 8) then
        local targetInfo = self:CastSpellEffect(sourceUnit, targetUnit, {}, buff, true);
        self:AddEvent(buff, "PeriodicDamage", sourceUnit.BoardIndex, { targetInfo });
    end
end

function GarrAutoBoard:ManageAura(targetUnit, sourceUnit, spell)
    local removed_buffs = { };

    local i = 1;
    while i <= #targetUnit.Buffs do
        local buff = targetUnit.Buffs[i];
        if buff.SourceIndex == sourceUnit.BoardIndex and buff.SpellID == spell.SpellID then
            if (buff.Effect == 7 or buff.Effect == 8) and (buff.CurrentPeriod == 0) then
                local targetInfo = self:CastSpellEffect(sourceUnit, targetUnit, {}, buff, true);
                self:AddEvent(buff, "PeriodicDamage", sourceUnit.BoardIndex, {targetInfo});
                if not targetUnit:IsAlive() then
                    self:OnDie(sourceUnit, targetUnit, spell, targetInfo);
                end
            end

            buff:DecRestTime();

            local isDeadUnitPassiveSkill = sourceUnit.PassiveSpell and not sourceUnit:IsAlive() and buff.SpellID == sourceUnit.PassiveSpell.ID;
            if buff.Duration == 0 or isDeadUnitPassiveSkill then
                table.insert(removed_buffs, {
                    buff = buff,
                    targetBoardIndex = targetUnit.BoardIndex
                });

                table.remove(targetUnit.Buffs, i);
                i = i - 1;

                -- Taunt
                if buff.Effect == 9 then
                    targetUnit.TauntedBy = nil;
                -- Untargetable
                elseif buff.Effect == 10 then
                    targetUnit.Untargetable = false;
                -- Reflect
                elseif buff.Effect == 15 or buff.Effect == 16 then
                    targetUnit.Reflect = 0;
                end
            end
        end
        i = i + 1;
    end

    return removed_buffs;
end

function GarrAutoBoard:GetDamageMultiplier(sourceUnit, targetUnit)
    -- мб сначала складываются отдельно модификаторы на источнике и на цели, а потом между собой перемножаются
    local buffs = { };
    local dealt, taken = 1, 1;

    -- delat damage multiplier
    for _, buff in ipairs(sourceUnit.Buffs) do
        if buff.Effect == 11 or buff.Effect == 12 then
            dealt = dealt + buff.BaseValue;
            buffs[buff.SpellID] = buff.BaseValue + (buffs[buff.SpellID] or 0);
        end
    end

    -- taken damage multiplier
    for _, buff in ipairs(targetUnit.Buffs) do
        if buff.Effect == 13 or buff.Effect == 14 then
            taken = taken + buff.BaseValue;
            buffs[buff.SpellID] = buff.BaseValue + (buffs[buff.SpellID] or 0);
        end
    end

    local positive_multiplier = 1;
    for _, value in pairs(buffs) do
        --dealt = dealt * (1 + value);
        if value > 0 then
            positive_multiplier = positive_multiplier * (1 + value);
        end
    end

    local multiplier = dealt * taken;
    return math.max(multiplier, 0), taken;
end

function GarrAutoBoard:GetAdditionalDamage(sourceUnit, targetUnit)
    local result = 0;

    for _, buff in ipairs(sourceUnit.Buffs) do
        -- AdditionalDamageDealt
        if buff.Effect == 19 then
            result = result + buff.BaseValue;
        end
    end

    for _, buff in ipairs(targetUnit.Buffs) do
        -- AdditionalTakenDamage
        if buff.Effect == 20 then
            result = result + buff.BaseValue;
        end
    end

    return result;
end

function GarrAutoBoard:CalculateEffectValue(sourceUnit, targetUnit, effect)
    local value = 0;

    -- Reflect
    if effect.Effect == 15 or effect.Effect == 16 then
        value = sourceUnit.Reflect;
    -- Use attack for point
    elseif effect.Flags == 0 or effect.Flags == 2 then
        value = math.floor(effect.Points * targetUnit.MaxHP);
    --elseif (effect.SpellID == 11 or effect.SpellID == 15) then
    --    value = sourceUnit.Attack;
    else
        value = math.floor(effect.Points * sourceUnit.Attack);
    end

    if IsDamageEffect(effect, true) then
        -- DoT
        if effect.Effect == 7 and not sourceUnit:IsAlive() then
            return value;
        end

        local multiplier, positive_multiplier = self:GetDamageMultiplier(sourceUnit, targetUnit);
        local additionalDamage = self:GetAdditionalDamage(sourceUnit, targetUnit);
        value = multiplier * (value + additionalDamage);
        -- TODO: здесь до сих пор неправильно.
        -- Мясыш со своим бафом бьет по мобу. У моба есть рефлект и два разных уменьшения урона в %.
        -- Базовое значение рефлекта = 132, уменьшение урона = 20+30, увеличение входящего урона на мясыше = 45.
        -- По моим логам в ответ летит 88, а должно быть 111.
        -- Без бафа мясыша по нему прилетает ответ на 66. При этом 66 + 45 = 111.
        -- Возможно, сначала считается модификатор и плюс урон у источника, а потом уже у таргета.
    end

    return math.max(math.floor(value + 0.00000000001), 0);
end

function GarrAutoBoard:CastSpellEffect(sourceUnit, targetUnit, spell, effect, isAppliedBuff)
    local oldTargetHP = targetUnit.CurHP;
    local value = 0;

    -- deal damage
    if IsDamageEffect(effect, isAppliedBuff) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math.max(0, targetUnit.CurHP - value);
    -- Heal                           HoT
    elseif effect.IsHeal or (effect.Effect == 8 and isAppliedBuff) then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.CurHP = math.min(targetUnit.MaxHP, targetUnit.CurHP + value);
    -- Maximum health multiplier
    elseif effect.Effect == 18 then
        value = self:CalculateEffectValue(sourceUnit, targetUnit, effect);
        targetUnit.MaxHP = targetUnit.MaxHP + value;
        targetUnit.CurHP = math.min(targetUnit.MaxHP, targetUnit.CurHP + value);
    else
        value = effect:GetBaseValue(sourceUnit.Attack);-- GetEffectBaseValue(effect, sourceUnit.Attack);
        self:ApplyAura(sourceUnit, targetUnit, effect, value, spell.Duration, spell.Name);
    end

    spell.WasCasted = true;

    return {
        BoardIndex = targetUnit.BoardIndex,
        MaxHP  = targetUnit.MaxHP,
        OldHealth  = oldTargetHP,
        NewHealth  = targetUnit.CurHP,
        Points     = value
    };
end

function GarrAutoBoard:PrepareCast(sourceUnit, targets, spell, effect)
    local result = true;
    if #spell.Effects == 1 and effect.IsHeal then
        local needHeal = false;
        for _, targetIndex in ipairs(targets) do
            local u = self.Units[targetIndex];
            if u and u.CurHP < u.MaxHP then
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
    local targetUnit = self.Units[eventTargetInfo.BoardIndex];
    -- check reflect only damage effect
    if effect.IsDamage then
        if targetUnit and targetUnit.Reflect > 0 then
            -- 15-Reflect
            local reflEffect = { Effect = 15, ID = -1 };
            local reflTargetInfo = self:CastSpellEffect(targetUnit, sourceUnit, { }, reflEffect, true);
            self:AddEvent(spell, 15, targetUnit.BoardIndex, { reflTargetInfo });

            -- 15-Reflect
            self:OnTakeDamage(sourceUnit, spell, reflEffect, reflTargetInfo);
        end
    end

    -- unit died
    if eventTargetInfo.NewHealth == 0 then
        self:OnDie(sourceUnit, targetUnit, spell, eventTargetInfo)
        self.IsOver = self:CheckMissionOver();
    end
end

function GarrAutoBoard:OnDie(sourceUnit, targetUnit, spell, eventTargetInfo)
    -- clear taunt and calc died order
    local diedOrder = 0;
    for i = 0, 12 do
        local unit = self.Units[i];
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

    self:AddEvent(spell, "Died", sourceUnit.BoardIndex, {eventTargetInfo});
end

function GarrAutoBoard:GetTargets(unit, targetType, lastTargetType, lastTargetIndexes)
    -- update targets if skill has different effects target type
    if lastTargetType ~= targetType and targetType ~= 0 then
        local aliveUnits = self:GetTargetableUnits(unit.BoardIndex);
        return T.TargetManager:GetTargetIndexes(unit.BoardIndex, targetType, aliveUnits, unit.TauntedBy);
    else
        return lastTargetIndexes;
    end
end

function GarrAutoBoard:ApplyPassiveAura(sourceUnit)
    if sourceUnit and sourceUnit.PassiveSpell then
        for _, effect in ipairs(sourceUnit.PassiveSpell.Effects) do
            local targetInfo = { };
            local targetIndexes = self:GetTargets(sourceUnit, effect.TargetType, -1);
            for _, targetIndex in ipairs(targetIndexes) do
                local targetUnit = self.Units[targetIndex];
                local eventTargetInfo = self:CastSpellEffect(sourceUnit, targetUnit, sourceUnit.PassiveSpell, effect, false);
                table.insert(targetInfo, eventTargetInfo);
            end
            self:AddEvent(sourceUnit.PassiveSpell, 'ApplyAura', sourceUnit.BoardIndex, targetInfo);
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

    if self.Round == 1 then
        self:ApplyPassiveAura(sourceUnit);
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

        self:Log(string.format("[%i] %s (%i)", spell.SpellID, spell.Name, #spell.Effects), LL_INFO);

        lastTargetType = -1
        for _, effect in ipairs(spell.Effects) do
            targetIndexes = self:GetTargets(sourceUnit, effect.TargetType, lastTargetType, targetIndexes);
            self:Log("Effect: " .. effect.Effect .. ', TargetType: ' .. effect.TargetType, LL_DEBUG)

            local needCast = self:PrepareCast(sourceUnit, targetIndexes, spell, effect);
            if needCast then
                local targetInfo = { };
                for _, targetIndex in ipairs(targetIndexes) do
                    local targetUnit = self.Units[targetIndex];
                    local eventTargetInfo = self:CastSpellEffect(sourceUnit, targetUnit, spell, effect, false);
                    table.insert(targetInfo, eventTargetInfo);
                end

                self:AddEvent(spell, effect.Effect, sourceUnit.BoardIndex, targetInfo);

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
    print(table.concat(turnOrder, ","))

    for _, boardIndex in ipairs(turnOrder) do
        local unit = self.Units[boardIndex];
        if unit then
            self:Log(string.format("[%i] %s", unit.BoardIndex, unit.Name));
            self:MakeAction(unit);
        end
    end

    if self.Environment then
        self:MakeAction(self.Environment);
    end
end

function GarrAutoBoard:Run()
    while not self.IsOver and self.Round < MAX_ROUNDS do
        self:Log("");
        self:Log(" >>> Round: "..self.Round, LL_INFO);
        self:Step();
        self.Round = self.Round + 1;
    end
end

T.GarrAutoBoard = GarrAutoBoard;
T.GetAutoAttackSpellId = GetAutoAttackSpellId;