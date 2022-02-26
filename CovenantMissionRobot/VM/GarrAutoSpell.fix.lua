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
        T.GARR_AUTO_SPELL[s].IsAutoAttack = T.AUTO_ATTACK_SPELLS[s] == 1;
        T.GARR_AUTO_SPELL[s].IsPassive = T.PASSIVE_SPELLS[s] == 1;

        for _, effect in ipairs(spell.Effects) do
            local tt = effect.TargetType;
            if tt == 19 or tt == 20 or tt == 21 then
                spell.HasRandomEffect = true;
            end

            effect.IsPassive = T.PASSIVE_SPELLS[s] == 1;

            effect.IsAura   = effect.Effect >= 7;
            effect.IsDamage = effect.Effect == 1 or effect.Effect == 3;
            effect.IsHeal   = effect.Effect == 2 or effect.Effect == 4;
        end
    end
end

T.GetAutoAttackSpellId = GetAutoAttackSpellId;