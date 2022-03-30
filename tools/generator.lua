_G.csv = loadfile('libs/csv.lua')();

local HEADER = [[-- This file was created by ./tools/generator.lua
-- !!! Do not modify this file manually !!!

local _, T = ...;

-- SpellInfo:
--  Cooldown - Cooldovn in rounds
--  Duration - Duration in rounds
--  Flags - 1-Has start CD
--  SchoolMask = 1-Physical, 2-Holly, 4-Fire, 8-Nature, 16-Frost, 32-Shadow, 64-Arcane

-- SpellEffectInfo:
--  Effect - See Effect type list
--  Points - Points or value of effect
--  TargetType - See Target type list
--  Flags - 1-Attack for points, 2-Tick after apply
--  Period - Period of effect

-- Effect type list:
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
--  18 - Maximum HP multiplier
--  19 - Additional damage dealt
--  20 - Additional receive damage

-- Target type list:
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
--  19 - Random all
--  20 - Random enemy
--  21 - Random ally
--  22 - All allies without self
--  23 - Env all enemies
--  24 - Env all allies

T.AUTO_ATTACK_SPELLS = { [11]=1, [15]=1 };

]]

local function trim(str)
    if str == '' then
        return str;
    else
        local startPos = 1;
        local endPos = #str;
        while (startPos < endPos and str:byte(startPos) <= 32) do
            startPos = startPos + 1;
        end
        if startPos >= endPos then
            return '';
        else
            while (endPos > 0 and str:byte(endPos) <= 32) do
                endPos = endPos - 1;
            end
            return str:sub(startPos, endPos);
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
		keys[#keys+1] = k;
	end
	table.sort(keys, sort);
	local i = 0;
	return function()
		i = i + 1;
		if keys[i] then
			return keys[i], t[keys[i]];
		end
	end
end

local garrautospell = loadcsv("wow_csv/garrautospell.csv", "ID");
local garrautospelleffect = loadcsv("wow_csv/garrautospelleffect.csv", "ID");
local garrautocombatant = loadcsv("wow_csv/garrautocombatant.csv", "ID");

local function WritePassiveSpells(file)
    -- passive spells
    local spells = { }
    for _, v in pairs(garrautocombatant) do
        local spellid = tonumber(v.PassiveSpellID);
        if spellid > 0 then
            spells[spellid] = 1;
        end
    end

    file:write("T.PASSIVE_SPELLS = { ")
    for i, v in sortedPairs(spells) do
        file:write(string.format("[%d]=%d, ", i, v));
    end
    file:write("};");
end

local function WriteSpells(file)
    file:write("T.GARR_AUTO_SPELL = {\n")
    for sid, spell in sortedPairs(garrautospell) do
        file:write("    -- "..trim(trim(spell.Name_lang)..': '..spell.Description_lang)..'\n');
        file:write(string.format("    [%03d] = { SpellID = %03d", sid, sid));
        file:write(string.format(", Cooldown = %s", spell.Cooldown));
        file:write(string.format(", Duration = %s", spell.Duration));
        file:write(string.format(", Flags = %s", spell.Flags));
        file:write(string.format(", SchoolMask = 0x%02x", tonumber(spell.SchoolMask)));
        file:write(", Effects = {\n");

        for _, effect in sortedPairs(garrautospelleffect) do
            if tostring(spell.ID) == tostring(effect.SpellID) then
                file:write("        ");
                file:write(string.format("{ ID = %03d", tonumber(effect.ID)));
                file:write(string.format(", SpellID = %03d", sid));
                file:write(string.format(", EffectIndex = %s", effect.EffectIndex));
                file:write(string.format(", Effect = %02d", tonumber(effect.Effect)));
                file:write(string.format(", TargetType = %02d", tonumber(effect.TargetType)));
                file:write(string.format(", Flags = 0x%02x", tonumber(effect['Flags'])));
                file:write(string.format(", Period = %s", effect.Period));
                file:write(string.format(", Points = %s", effect.Points));
                file:write(" },\n");
            end
        end
        file:write("    } },\n\n");
    end
    file:write("};")
end

local function WriteSql(sql)
    local HEADER_STR = [[-- This file was created by ./tools/generator.lua
-- !!! Do not modify this file manually !!!

use [wow];
GO

DROP TABLE IF EXISTS [wow].[dbo].[GarrAutoSpell];
GO

CREATE TABLE [wow].[dbo].[GarrAutoSpell] (
    [ID]               int primary key,
    [Name_lang]        varchar(100) null,
    [Description_lang] varchar(1000) null,
    [Cooldown]         int not null,
    [Duration]         int not null,
    [Flags]            int not null, -- 1-No initial cast
    [SchoolMask]       int not null, -- 1-Physical, 2-Holly, 4-Fire, 8-Nature, 16-Frost, 32-Shadow, 64-Arcane
    [IconFileDataID]   int not null,
    [SchoolMaskName] as (case [SchoolMask]
            when 1 then 'Physical'
            when 2 then 'Holly'
            when 4 then 'Fire'
            when 8 then 'Nature'
            when 16 then 'Frost'
            when 32 then 'Shadow'
            when 64 then 'Arcane'
        else cast(SchoolMask as varchar) end)
);
GO

DROP TABLE IF EXISTS [wow].[dbo].[GarrAutoSpellEffect];
GO

CREATE TABLE [wow].[dbo].[GarrAutoSpellEffect] (
    [ID]          int primary key,
    [SpellID]     int not null,
    [EffectIndex] int not null,
    [Effect]      int not null, -- [wow].[dbo].[SpellEffectTypes]
    [Points]      float not null,
    [TargetType]  int not null, -- [wow].[dbo].[TargetTypes]
    [Flags]       int not null, -- 1-Use attack for points, 2-Extra inital period
    [Period]      int not null,
    [EffectName] as (case [Effect]
            when 01 then 'Damage'
            when 02 then 'Heal'
            when 03 then 'Damage'
            when 04 then 'Heal'
            when 07 then 'DoT'
            when 08 then 'HoT'
            when 09 then 'Taunt'
            when 10 then 'Untargetable'
            when 11 then 'Dealt multiplier'
            when 12 then 'Dealt multiplier'
            when 13 then 'Taken multiplier'
            when 14 then 'Taken multiplier'
            when 15 then 'Reflect'
            when 16 then 'Reflect'
            when 18 then 'Max HP multiplier'
            when 19 then 'Add dmg dealt'
            when 20 then 'Add receive dmg'
        else cast([Effect] as varchar) end),
    [TargetTypeName] as (case [TargetType]
            when 01 then 'Self'
            when 02 then 'Adjacent ally'
            when 03 then 'Closest enemy'
            when 05 then 'Ranged enemy'
            when 06 then 'All allies'
            when 07 then 'All enemies'
            when 08 then 'All adjacent allies'
            when 09 then 'All adjacent enemies'
            when 10 then 'Closest ally cone'
            when 11 then 'Closest enemy cone'
            when 13 then 'Closest enemy line'
            when 14 then 'Front line allies'
            when 15 then 'Front line enemies'
            when 16 then 'Back line allies'
            when 17 then 'Back line enemies'
            when 19 then 'Random all'
            when 20 then 'Random enemy'
            when 21 then 'Random ally'
            when 22 then 'All allies without self'
            when 23 then 'Env all enemies'
            when 24 then 'Env all allies'
        else cast([TargetType] as varchar) end)
);
GO
]]

sql:write(HEADER_STR);
    for _, row in sortedPairs(garrautospell) do
        local name = string.gsub(trim(row['Name_lang']), "'", "''")
        local desc = string.gsub(trim(row['Description_lang']), "'", "''");
        sql:write(string.format("INSERT INTO [wow].[dbo].[GarrAutoSpell] VALUES (%s, '%s', '%s', %s, %s, %s, %s, %s);\n",
            row.ID, name, desc, row.Cooldown, row.Duration, row.Flags, row.SchoolMask, row.IconFileDataID));
    end

    for _, row in sortedPairs(garrautospelleffect) do
        sql:write(string.format("INSERT INTO [wow].[dbo].[GarrAutoSpellEffect] VALUES (%s, %s, %s, %s, %s, %s, %s, %s);\n",
            row.ID, row.SpellID, row.EffectIndex, row.Effect, row.Points, row.TargetType, row.Flags, row.Period));
    end
end

local file = io.open("CovenantMissionRobot/VM/Tables.g.lua", "w");

file:write(HEADER);

WritePassiveSpells(file);
file:write("\n\n");

WriteSpells(file);
file:write("\n");

file:flush();
file:close();

local sql = io.open("wow_csv/SqlTables.g.sql", "w");
WriteSql(sql);
sql:flush();
sql:close();
