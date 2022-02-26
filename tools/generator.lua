_G.csv = loadfile('libs/csv.lua')();

local HEADER = [[-- This file was created by ./tools/generator.lua
-- !!! Do not modify this file manually !!!

local _, T = ...;

-- SpellInfo:
--  Cooldown - Cooldovn in seconds
--  Duration - Duration in rounds
--  Flags - 1-No initial cast
--  SchoolMask = 1-Physical, 2-Holly, 4-Fire, 8-Nature, 16-Frost, 32-Shadow, 64-Arcane

-- SpellEffectInfo:
--  Effect - See Effect type list
--  Points - Points or value of effect
--  TargetType - See Target type list
--  Flags - 1-Use attack for points, 2-Extra inital period
--  Period - Duration the spell effect

-- Effect type list:
--  00 - For spellID = 17 only
--  01 - Damage
--  02 - Heal
--  03 - Damage
--  04 - Heal
--  07 - DoT
--  08 - HoT
--  09 - Taunt
--  10 - Untargetable
--  11 - Damage dealt multiplier
--  12 - Damage dealt multiplier
--  13 - Damage taken multiplier
--  14 - Damage taken multiplier
--  15 - Reflect
--  16 - Reflect
--  17 - Test ability ???
--  18 - Maximum health multiplier
--  19 - Additional damage dealt
--  20 - Additional receive damage

-- Target type list:
--  00 - Last target
--  01 - Self
--  02 - Adjacent ally
--  03 - Closest enemy
--  05 - Ranged enemy
--  06 - All allies
--  07 - All enemies
--  08 - All adjacent allies
--  09 - All adjacent enemies
--  10 - Closest ally cone
--  11 - Closest enemy cone
--  13 - Closest enemy line
--  14 - Front line allies
--  15 - Front line enemies
--  16 - Back line allies
--  17 - Back line enemies
--  19 - Random enemy
--  20 - Random enemy
--  21 - Random ally
--  22 - All allies without self
--  23 - All allies
--  24 - Unknown

T.AUTO_ATTACK_SPELLS = { [11]=1, [15]=1 };

]]

local function trim (str)
    if str == '' then
      return str
    else
      local startPos = 1
      local endPos   = #str

      while (startPos < endPos and str:byte(startPos) <= 32) do
        startPos = startPos + 1
      end

      if startPos >= endPos then
        return ''
      else
        while (endPos > 0 and str:byte(endPos) <= 32) do
          endPos = endPos - 1
        end

        return str:sub(startPos, endPos)
      end
    end
end

local function loadcsv(fileName, colId)
    local result = { };
    local f = csv.open(fileName, { header = true });
    for r in f:lines() do
        local id = tonumber(r[colId]);
        result[id] = r;
    end
    return result;
end

local function sortedPairs(t, sort)
	local keys = {};
	for k in pairs(t) do
		keys[#keys+1] = k
	end
	table.sort(keys, sort)
	local i = 0
	return function()
		i = i+1
		if keys[i] then
			return keys[i], t[keys[i]]
		end
	end
end

local garrautospell = loadcsv("wow_csv/garrautospell.csv", "ID");
local garrautospelleffect = loadcsv("wow_csv/garrautospelleffect.csv", "ID");
local garrfollower = loadcsv("wow_csv/garrfollower.csv", "ID");
local garrautocombatant = loadcsv("wow_csv/garrautocombatant.csv", "ID");
local garrencounter = loadcsv("wow_csv/garrencounter.csv", "ID");
local garrmissionxencounter = loadcsv("wow_csv/garrmissionxencounter.csv", "ID");

local function GetPassiveSpells()
    -- passive spells
    local spells = {}
    for _, v in pairs(garrautocombatant) do
        local spellid = tonumber(v.PassiveSpellID);
        if spellid> 0 then
            spells[spellid] = 1
        end
    end
    local s="T.PASSIVE_SPELLS = { "
    for i, v in sortedPairs(spells) do
        s=s..string.format("[%d]=%d, ", i, v)
    end
    s=s.."};"
    return s;
end

local function GetFolloversAA()
    local spells = {}
    -- AttackSpellID,AbilitySpellID,Role
    for k, v in pairs(garrfollower) do
        local follower = garrautocombatant[tonumber(v.AutoCombatantID)];
        if follower then
            local r = tonumber(follower.Role);
            local spellid = tonumber(follower.AbilitySpellID);
            local aa = tonumber(follower.AttackSpellID);
            if aa == 11 and (r==0 or r==2 or r==3 or r==4) then
                spells[spellid] = 11;
            elseif aa == 15 and (r==1 or r==5) then
                spells[spellid] = 15;
            end
        end
    end

    local s="T.FOLLOWERS_AUTO_ATTACK = { "
    for i, v in sortedPairs(spells) do
        s=s..string.format("[%d]=%d, ", i, v)
    end
    s=s.."};"
    return s;
end

local function WriteEnemiesAA(file)
    local set = {};
    for k, gme in sortedPairs(garrmissionxencounter) do
        local b = tonumber(gme.BoardIndex);
        local m = tonumber(gme.GarrMissionID);
        local ge = garrencounter[tonumber(gme.GarrEncounterID)];
        local gac = garrautocombatant[tonumber(ge and ge.AutoCombatantID)];
        if ge and gac and b then
            local aa = tonumber(gac.AttackSpellID);
            local r = tonumber(gac.Role);
            if aa == 11 and (r==0 or r==2 or r==3 or r==4) then
                if not set[b] then set[b]={} end
                set[b][m] = 11;
            elseif aa == 15 and (r==1 or r==5) then
                if not set[b] then set[b]={} end
                set[b][m] = 15;
            end
        end
    end

    file:write("T.ENEMIES_AUTO_ATTACK = {\n");
    for b, ml in sortedPairs(set) do
        file:write(string.format("    [%02i] = { ", b))
        for m, s in sortedPairs(ml) do
            file:write(string.format("[%i]=%i, ", m, s))
        end
        file:write("},\n");
    end
    file:write("\n};");
end

local function WriteSpells(file)
    file:write("T.GARR_AUTO_SPELL = {")
    for sid, spell in sortedPairs(garrautospell) do
        file:write("\n    -- "..trim(trim(spell.Name_lang)..': '..spell.Description_lang)..'\n');
        file:write(string.format("    [%03d] = { SpellID = %03d", sid, sid));
        file:write(", Cooldown = "..tostring(spell.Cooldown));
        file:write(", Duration = "..tostring(spell.Duration));
        file:write(", Flags = "..tostring(spell.Flags));
        file:write(string.format(", SchoolMask = 0x%02x", tonumber(spell.SchoolMask)));
        file:write(", Effects = {\n");

        for _, effect in sortedPairs(garrautospelleffect) do
            if tostring(spell.ID) == tostring(effect.SpellID) then
                file:write("        ");
                file:write(string.format("{ ID = %03d", tonumber(effect.ID)));
                file:write(string.format(", SpellID = %03d", sid));
                file:write(", EffectIndex = "..tostring(effect.EffectIndex));
                file:write(string.format(", Effect =  %02d", tonumber(effect.Effect)));
                file:write(string.format(", TargetType =  %02d", tonumber(effect.TargetType)));
                file:write(string.format(", Flags = 0x%02x", tonumber(effect['Flags'])));
                file:write(", Period = "..tostring(effect.Period));
                file:write(", Points = "..tostring(effect.Points).." },\n");
            end
        end
        file:write("    } },\n")
    end
    file:write("};")
end

local file = io.open("CovenantMissionRobot/VM/Tables.g.lua", "w");

file:write(HEADER)

file:write(GetPassiveSpells())
file:write("\n\n")
file:write(GetFolloversAA())
file:write("\n\n")
WriteEnemiesAA(file);
file:write("\n\n");

WriteSpells(file);

file:close();
