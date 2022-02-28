local _, T = ...;

function GetAutoAttackSpellId(role, missionId, boardIndex, firstSpell)
    -- Default: meele or tank
    local attackSpellId = (role == 1 or role == 5) and 11 or 15;

    if (boardIndex or 0) > 4 and missionId then
        attackSpellId = T.ENEMIES_AUTO_ATTACK[boardIndex] and T.ENEMIES_AUTO_ATTACK[boardIndex][missionId] or attackSpellId;
    elseif firstSpell then
        attackSpellId = T.FOLLOWERS_AUTO_ATTACK[firstSpell] or attackSpellId;
    end

    return attackSpellId;
end

function T.ApplySpellFixes()

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
    T.GARR_AUTO_SPELL[109] = nil;

    -- Humorous Flame: Chaos and fire! This attack deals $s1 Fire damage over three turns to a random enemy.
    T.GARR_AUTO_SPELL[122] = nil; -- mission 2186 (Хихикающий трикстер)

    -- Toxic Dispersal: Deals $s1 Nature damage each round to all enemies and heals all allies for $s2.
    T.GARR_AUTO_SPELL[191].Effects[1].Points = 1; -- old 0.2
    T.GARR_AUTO_SPELL[191].Effects[2].Points = 1; -- old 0.1

    -- Heal the Flock: The ancient creature emits waves of beneficial spores, healing in a cone from the closest ally for $s1.
    T.GARR_AUTO_SPELL[213].Effects[1].TargetType = 2; -- old 10

    -- Cannon Barrage: Deals $s1 Fire damage to all enemies. Does not cast immediately.
    -- T.GARR_AUTO_SPELL[339] = nil; -- mission 2307 (Корсар-канонир)

    -- Some presetups
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
            if tt == 19 or tt == 20 or tt == 21 then
                spell.HasRandomEffect = true;
            end

            effect.IsPassive = T.PASSIVE_SPELLS[s] == 1;

            effect.IsAura         = ef >= 7;
            effect.IsDamage       = ef == 1 or ef == 3;
            effect.IsHeal         = ef == 2 or ef == 4;
            effect.IsTaunt        = ef == 9;
            effect.IsDot          = ef == 7;
            effect.IsHot          = ef == 8;
            effect.IsDotHot       = ef == 7 or ef == 8;
            effect.IsUntargetable = ef == 10;
            effect.IsReflect      = ef == 15 or ef == 16;
            effect.UsePoints      = ef == 11 -- DamageDealtMultiplier ??? todo: check it
                                 or ef == 12 -- DamageDealtMultiplier_2
                                 or ef == 13 -- DamageTakenMultiplier
                                 or ef == 14 -- DamageTakenMultiplier_2
                                 or ef == 15 -- Reflect
                                 or ef == 16;-- Reflect_2
        end
    end
end

T.GetAutoAttackSpellId = GetAutoAttackSpellId;
