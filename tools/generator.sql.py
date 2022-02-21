import csv
import os

# https://wow.tools/dbc/api/export/?name=garrautospell&build=9.1.0.39804&useHotfixes=true
# https://wow.tools/dbc/api/export/?name=garrautospelleffect&build=9.1.0.39804&useHotfixes=true

# WOW_BUILD="9.1.0.39804"
# URL_GarrAutoSpellEffect="https://wow.tools/dbc/api/export/?name=garrautospelleffect&build="+WOW_BUILD+"&useHotfixes=true"
# URL_GarrAutoSpell="https://wow.tools/dbc/api/export/?name=garrautospell&build="+WOW_BUILD+"&useHotfixes=true"

curDir = os.path.dirname(__file__)

# ID,SpellID,EffectIndex,Effect,Points,TargetType,Flags,Period
garrautospelleffect = os.path.relpath(curDir + '\\..\\wow_csv\\garrautospelleffect.csv')

# ID,Name_lang,Description_lang,Cooldown,Duration,Flags,SchoolMask,IconFileDataID
garrautospell = os.path.relpath(curDir + '\\..\\wow_csv\\garrautospell.csv')

spellTableSql = os.path.relpath(curDir + '\\..\\wow_csv\\GarrTables.g.sql')

HEADER_STR = """-- This file was created by ./tools/generator.sql.py
-- !!! Do not modify this file manually !!!

use [wow];
GO

DROP TABLE IF EXISTS [wow].[dbo].[SpellEffectTypes];
GO

CREATE TABLE [wow].[dbo].[SpellEffectTypes] (
    [ID]   tinyint      not null primary key,
    [Name] varchar(100) not null
)
GO

INSERT INTO [wow].[dbo].[SpellEffectTypes] VALUES
(00, 'For spellID = 17 only'),
(01, 'Damage'),
(02, 'Heal'),
(03, 'Damage'),
(04, 'Heal'),
(05, 'DoT'),
(06, 'DoT'),
(07, 'DoT'),
(08, 'HoT'),
(09, 'Taunt'),
(10, 'Untargetable'),
(11, 'Damage dealt multiplier'),
(12, 'Damage dealt multiplier'),
(13, 'Damage taken multiplier'),
(14, 'Damage taken multiplier'),
(15, 'Reflect'),
(16, 'Reflect'),
(17, 'Test ability ???'),
(18, 'Maximum health multiplier'),
(19, 'Additional damage dealt'),
(20, 'Additional receive damage');
GO

DROP TABLE IF EXISTS [wow].[dbo].[TargetTypes];
GO

CREATE TABLE [wow].[dbo].[TargetTypes] (
    [ID]   tinyint      not null primary key,
    [Name] varchar(100) not null
)
GO

INSERT INTO [wow].[dbo].[TargetTypes] VALUES
(00, 'Last target'),
(01, 'Self'),
(02, 'Adjacent ally'),
(03, 'Closest enemy'),
(05, 'Ranged enemy'),
(06, 'All allies'),
(07, 'All enemies'),
(08, 'All adjacent allies'),
(09, 'All adjacent enemies'),
(10, 'Closest ally cone'),
(11, 'Closest enemy cone'),
(13, 'Closest enemy line'),
(14, 'Front line allies'),
(15, 'Front line enemies'),
(16, 'Back line allies'),
(17, 'Back line enemies'),
(19, 'Random enemy'),
(20, 'Random enemy'),
(21, 'Random ally'),
(22, 'All allies'),
(23, 'All allies'),
(24, 'Unknown');
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
	[IconFileDataID]   int not null
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
	[Period]      int not null
);
GO
"""

print("Start make the SpellTable")
with open(spellTableSql, "w", encoding='utf-8') as sql:
    sql.write(HEADER_STR)

    sql.write("\n-- GarrAutoSpell data\n")
    with open(garrautospell, encoding='utf-8') as csvfile:
        rows = csv.DictReader(csvfile)
        for row in rows:
            sql.write("INSERT INTO [wow].[dbo].[GarrAutoSpell] VALUES (")
            sql.write(row['ID'])
            sql.write(", '")
            sql.write(row['Name_lang'].strip().replace("'", "''"))
            sql.write("', '")
            sql.write(row['Description_lang'].strip().replace("'", "''"))
            sql.write("', ")
            sql.write(row['Cooldown'])
            sql.write(", ")
            sql.write(row['Duration'])
            sql.write(", ")
            sql.write(row['Flags'])
            sql.write(", ")
            sql.write(row['SchoolMask'])
            sql.write(", ")
            sql.write(row['IconFileDataID'])
            sql.write(');\n')

    sql.write("\n-- GarrAutoSpellEffect data\n")
    with open(garrautospelleffect, encoding='utf-8') as csvfile:
        rows = csv.DictReader(csvfile)
        for row in rows:
            sql.write("INSERT INTO [wow].[dbo].[GarrAutoSpellEffect] VALUES (")
            sql.write(row['ID'])
            sql.write(", ")
            sql.write(row['SpellID'])
            sql.write(", ")
            sql.write(row['EffectIndex'])
            sql.write(", ")
            sql.write(row['Effect'])
            sql.write(", ")
            sql.write(row['Points'])
            sql.write(", ")
            sql.write(row['TargetType'])
            sql.write(", ")
            sql.write(row['Flags'])
            sql.write(", ")
            sql.write(row['Period'])
            sql.write(');\n')

print("Done!")