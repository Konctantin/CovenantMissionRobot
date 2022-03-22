local _, T = ...;

local IsDebug = T.IsDebug == true;

local EffectHandlers = {
    [1]  = "HANDLE_DAMAGE",
    [2]  = "HANDLE_HEAL",
    [3]  = "HANDLE_DAMAGE",
    [4]  = "HANDLE_HEAL",
    [7]  = "HANDLE_DOT",
    [8]  = "HANDLE_HOT",
    [9]  = "HANDLE_TAUNT",
    [10] = "HANDLE_NOTARGET",
    [12] = "HANDLE_DDM",
    [14] = "HANDLE_DTM",
    [15] = "HANDLE_REFLECT",
    [16] = "HANDLE_REFLECT",
    [18] = "HANDLE_MAXHP",
    [19] = "HANDLE_ADD",
    [20] = "HANDLE_ADT",
}

local EffectTypes = {
    [00] = "Does'nt work, just remove it",
    [01] = "Damage",
    [02] = "Heal",
    [03] = "Damage",
    [04] = "Heal",
    [07] = "DoT",
    [08] = "HoT",
    [09] = "Taunt",
    [10] = "Untargetable",
    --[11] = "Damage dealt multiplier",
    [12] = "Damage dealt multiplier",
    [13] = "Damage taken multiplier",
    [14] = "Damage taken multiplier",
    [15] = "Reflect",
    [16] = "Reflect",
    [17] = "Test ability ???",
    [18] = "Maximum HP multiplier",
    [19] = "Additional damage dealt",
    [20] = "Additional receive damage",
};

local TargetTypes = {
    [01] = "Self",
    [02] = "Adjacent ally",
    [03] = "Closest enemy",
    [05] = "Ranged enemy",
    [06] = "All allies",
    [07] = "All enemies",
    [08] = "All adjacent allies",
    [09] = "All adjacent enemies",
    [10] = "Closest ally cone",
    [11] = "Closest enemy cone",
    [13] = "Closest enemy line",
    [14] = "Front line allies",
    [15] = "Front line enemies",
    [16] = "Back line allies",
    [17] = "Back line enemies",
    [19] = "Random all",
    [20] = "Random enemy",
    [21] = "Random ally",
    [22] = "All allies without self",
    [23] = "Env all enemies",
    [24] = "Env all allies",
};

local function ThisIsAutoTroops(spells)
    for _, s in ipairs(spells) do
        local is = T.GARR_AUTO_TROOP_SPELLS[s.autoCombatSpellID] == 1;
        if is then
            return true;
        end
    end
    return false;
end

local function GetAutoAttackSpellId(role, missionId, boardIndex, firstSpell)
    -- Default: meele or tank
    local attackSpellId = (role == 1 or role == 5) and 11 or 15;

    if (boardIndex or 0) > 4 and missionId then
        local missions = T.ENEMIES_AUTO_ATTACK[boardIndex];
        local autoAttackSpellId = missions and missions[missionId];
        attackSpellId = autoAttackSpellId or attackSpellId;
    elseif firstSpell then
        local autoAttackSpellId = T.FOLLOWERS_AUTO_ATTACK[firstSpell];
        attackSpellId = autoAttackSpellId or attackSpellId;
    end

    return attackSpellId;
end

local function MakeSomePresetupFilds()
    for s, spell in pairs(T.GARR_AUTO_SPELL) do
        spell.IsAutoAttack = T.AUTO_ATTACK_SPELLS[s] == 1;
        if T.PASSIVE_SPELLS[s] == 1 then
            spell.IsPassive = true;
            spell.Duration = 1000;
        else
            spell.IsPassive = false;
        end

        for _, effect in ipairs(spell.Effects) do
            local ef = effect.Effect;
            local tt = effect.TargetType;

            effect.HandlerName = EffectHandlers[ef];

            -- Random effects
            if tt == 19 or tt == 20 or tt == 21 then
                spell.HasRandomEffect = true;
            end

            -- From autogenerated table
            effect.IsPassive = T.PASSIVE_SPELLS[s] == 1;

            -- Effect type properties
            effect.IsAura           = ef >= 7;
            effect.IsDamage         = ef == 1 or ef == 3;
            effect.IsHeal           = ef == 2 or ef == 4;
            effect.IsDot            = ef == 7;
            effect.IsHot            = ef == 8;
            effect.IsDotOrHot       = ef == 7 or ef == 8;
            effect.IsTaunt          = ef == 9;
            effect.IsUntargetable   = ef == 10;
            effect.IsReflect        = ef == 15 or ef == 16;
            effect.IsMaxHPMultilier = ef == 18;
            effect.UsePoints        = ef == 12 -- DamageDealtMultiplier
                                   or ef == 14 -- DamageTakenMultiplier
                                   or ef == 15 -- Reflect
                                   or ef == 16;-- Reflect_2

            -- Flags properties
            effect.FirstTick = bit.band(effect.Flags, 2) > 0;
            effect.UseAttackForPoint = bit.band(effect.Flags, 1) > 0;

            if IsDebug then
                effect.EffectName = EffectTypes[ef] or "<unk>";
                effect.TargetTypeName = TargetTypes[tt] or "<unk>";
            end
        end
    end
end

local function ApplySpellFixes()

    -- Auto Attack: Deal damage to an enemy at range.
    T.GARR_AUTO_SPELL[015].Effects[1].Points = 1; -- old 0.5

    -- Gravedirt Special: Dug tosses a shovelful of Grave Dirt at all enemies, dealing $s1 Frost damage and healing himself for $s2.
    T.GARR_AUTO_SPELL[017].Effects[2].Points = 1; -- old 100
    T.GARR_AUTO_SPELL[017].Effects[3] = nil; -- just remove

    -- Revitalizing Vines: Heals the closest ally for $s1.
    T.GARR_AUTO_SPELL[071].Effects[1].Points = 1; -- old 0.3

    -- Podtender: Heal an adjacent ally for $s1, but reduce their damage by 10% for the next round.
    T.GARR_AUTO_SPELL[104].Effects[1].Points = 1; -- old 0.9

    -- Serrated Shoulder Blades: Enemies attacking Heirmir take $s1 Physical damage.
    T.GARR_AUTO_SPELL[109].Effects = { }; -- does'nt work

    -- Humorous Flame: Chaos and fire! This attack deals $s1 Fire damage over three turns to a random enemy.
    T.GARR_AUTO_SPELL[122].Effects = { }; -- does'nt work mission 2186 (Хихикающий трикстер)

    -- Polished Ice Barrier: A frozen reflective shield forms which deals $s1 Frost damage to anyone attacking it for three turns.
    T.GARR_AUTO_SPELL[174].Effects[1].Points = 0.3; -- old 0.4

    -- Toxic Dispersal: Deals $s1 Nature damage each round to all enemies and heals all allies for $s2.
    T.GARR_AUTO_SPELL[191].Effects[1].Points = 1; -- old 0.2
    T.GARR_AUTO_SPELL[191].Effects[2].Points = 1; -- old 0.1

    -- Intimidating Roar: Roars out a spine chilling challenge to a random enemy, focusing their attention on itself.
    T.GARR_AUTO_SPELL[208].Effects[1].TargetType = 0; -- does'nt work

    -- Heal the Flock: The ancient creature emits waves of beneficial spores, healing in a cone from the closest ally for $s1.
    T.GARR_AUTO_SPELL[213].Effects[1].TargetType = 2; -- old 10

    -- Mace Smash: Makes a powerful swing with their mace, striking all enemies in melee for $s1 damage.
    T.GARR_AUTO_SPELL[372].Effects[1].Points = 0.4; -- old 0.8

    -- Cannon Barrage: Deals $s1 Fire damage to all enemies. Does not cast immediately.
    -- T.GARR_AUTO_SPELL[339] = nil; -- mission 2307 (Корсар-канонир)

    -- Some presetups
    MakeSomePresetupFilds();
end

T.ThisIsAutoTroops = ThisIsAutoTroops;
T.GetAutoAttackSpellId = GetAutoAttackSpellId;
T.ApplySpellFixes = ApplySpellFixes;
