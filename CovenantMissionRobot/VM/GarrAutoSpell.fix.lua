local _, T = ...;

local AUTO_ATTACK    = { [11]=1, [15]=1 };
local PASSIVE_SPELLS = { [47]=1, [82]=1, [90]=1, [105]=1, [109]=1 };

local AUTO_TROOP_SPELLS = {
    [1]=1, [2]=1, -- night fae
    [3]=1, [4]=1, --
    [5]=1, [6]=1, --
    [7]=1, [8]=1, -- necrolord
};

local M, R = 11, 15;
local enemieTable = {
    -- [boardIndex] = {[missionId]=M (meele spell id)}
    [05] = { [2172]=M,[2176]=M,[2196]=M,[2207]=M,[2209]=M,[2202]=M,[2214]=M,[2312]=M,[2304]=M },
    [06] = { [2304]=M,[2305]=M,[2311]=M,[2314]=M,[2315]=M,[2316]=M,[2317]=M,[2260]=M,[2209]=M,[2213]=M,[2176]=M,[2196]=M,[2207]=M,[2169]=M },
    [07] = { [2169]=M,[2172]=M,[2176]=M,[2196]=M,[2209]=M,[2207]=M,[2260]=M,[2305]=M,[2304]=M },
    [08] = { [2305]=M,[2304]=M,[2214]=M,[2207]=M,[2209]=M,[2196]=M,[2176]=M,[2172]=M },
    [09] = { [2204]=M,[2208]=M,[2239]=M,[2212]=M,[2252]=M,[2293]=M,[2298]=M,[2313]=M,[2259]=M,[2301]=M,[2307]=M,[2304]=M,[2303]=M },
    [10] = { [2304]=M,[2307]=M,[2303]=M,[2298]=M,[2252]=M,[2239]=M,[2243]=M,[2212]=M,[2201]=M,[2238]=M,[2241]=M,[2205]=M,[2169]=M },
    [11] = { [2169]=M,[2172]=M,[2209]=M,[2208]=M,[2205]=M,[2214]=M,[2224]=M,[2239]=M,[2259]=M,[2303]=M,[2287]=M,[2279]=M,[2252]=M,[2307]=M,[2304]=M },
    [12] = { [2304]=M,[2307]=M,[2298]=M,[2293]=M,[2303]=M,[2313]=M,[2252]=M,[2212]=M,[2239]=M,[2215]=M,[2204]=M,[2208]=M },
};

-- [FirstSpellID] = M (meele spell id)
local followerTable = { [14]=M, [45]=M, [85]=M, [194]=M, [303]=M, [306]=M, [309]=M, [314]=M, [325]=M };

function GetAutoAttackSpellId(role, missionId, boardIndex, firstSpell)
    -- Default: meele or tank
    local attackSpellId = (role == 1 or role == 5) and M or R;

    if (boardIndex or 0) > 4 and missionId then
        attackSpellId = enemieTable[boardIndex] and enemieTable[boardIndex][missionId] or attackSpellId;
    elseif firstSpell then
        attackSpellId = followerTable[firstSpell] or attackSpellId;
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
        T.GARR_AUTO_SPELL[s].IsAutoAttack = AUTO_ATTACK[s] == 1;
        T.GARR_AUTO_SPELL[s].IsPassive = PASSIVE_SPELLS[s] == 1;

        for _, effect in ipairs(spell.Effects) do
            local tt = effect.TargetType;
            if tt == 19 or tt == 20 or tt == 21 then
                spell.HasRandomEffect = true;
            end

            effect.IsPassive = PASSIVE_SPELLS[s] == 1;

            effect.IsAura   = effect.Effect >= 7;
            effect.IsDamage = effect.Effect == 1 or effect.Effect == 3;
            effect.IsHeal   = effect.Effect == 2 or effect.Effect == 4;
        end
    end
end

T.GetAutoAttackSpellId = GetAutoAttackSpellId;