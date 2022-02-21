import csv
import os

# https://wow.tools/dbc/api/export/?name=garrautospell&build=9.1.0.39804&useHotfixes=true
# https://wow.tools/dbc/api/export/?name=garrautospelleffect&build=9.1.0.39804&useHotfixes=true

# WOW_BUILD="9.1.0.39804"
# URL_GarrAutoSpellEffect="https://wow.tools/dbc/api/export/?name=garrautospelleffect&build="+WOW_BUILD+"&useHotfixes=true"
# URL_GarrAutoSpell="https://wow.tools/dbc/api/export/?name=garrautospell&build="+WOW_BUILD+"&useHotfixes=true"

curDir = os.path.dirname(__file__)

# ID,SpellID,EffectIndex,Effect,Points,TargetType,Flags,Period
garrautospelleffect = curDir + '\\garrautospelleffect.csv'

# ID,Name_lang,Description_lang,Cooldown,Duration,Flags,SchoolMask,IconFileDataID
garrautospell = curDir + '\\garrautospell.csv'

spellTable = os.path.relpath(curDir + '\\..\\CovenantMissionRobot\\VM\\GarrAutoSpell.g.lua')

HEADER_STR = """-- This file was created by ./tools/generator.py
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

"""

print("Start make the SpellTable")
with open(spellTable, "w") as f:
    with open(garrautospell) as csvspell:
        with open(garrautospelleffect) as csveffect:
            f.write(HEADER_STR)

            # Main spell table
            csvspell.seek(0)
            rows_spell = csv.DictReader(csvspell)
            f.write("T.GARR_AUTO_SPELL = {")
            for spell in rows_spell:
                f.write("\n    -- " + (spell['Name_lang'].strip() + ': ' + spell['Description_lang']).strip() + '\n')
                f.write("    [" + format(int(spell['ID']), '03') + "] = ")
                #f.write(", Name = '" + spell['Name_lang'] + "'")
                f.write("{ SpellID = " + format(int(spell['ID']), '03'))
                f.write(", Cooldown = " + spell['Cooldown'])
                f.write(", Duration = " + spell['Duration'])
                f.write(", Flags = " + spell['Flags']) 
                f.write(", SchoolMask = " + "0x{:02x}".format(int(spell['SchoolMask']))) 
                #f.write(", IconFileDataID = " + spell['IconFileDataID'])
                f.write(", Effects = {\n")

                csveffect.seek(0)
                rows_effect = csv.DictReader(csveffect)
                for effect in rows_effect:
                    if spell['ID'] == effect['SpellID']:
                        f.write(" " * 8)
                        #f.write("[" + effect['EffectIndex'] + "] = ")
                        f.write("{ ID = " + format(int(effect['ID']), '03'))
                        f.write(", SpellID = " + format(int(spell['ID']), '03'))
                        f.write(", Effect = " + format(int(effect['Effect']), '02'))
                        f.write(", TargetType = " + format(int(effect['TargetType']), '02'))
                        f.write(", Flags = " + "0x{:02x}".format(int(effect['Flags']))) 
                        f.write(", Period = " + effect['Period'])
                        f.write(", Points = " + effect['Points'] + " },\n")
                # 
                f.write("    } },\n") 
            f.write("};")
print("Done!")
