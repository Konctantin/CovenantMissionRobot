-- This file was created by ./tools/generator.py
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

T.GARR_AUTO_SPELL = {
    -- DNT JasonTest Envirospell:
    [001] = { SpellID = 001, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 001, SpellID = 001, EffectIndex = 0, Effect = 01, TargetType = 24, Flags = 0x01, Period = 0, Points = 350 },
    } },

    -- DNT JasonTest Ability Spell: DNT Test test  Effect 0 Attack points $s0, Effect 1 Attack points % $s1, Effect 2 Flat points $s2, Effect 3 Flat points % $s3
    [002] = { SpellID = 002, Cooldown = 4, Duration = 2, Flags = 1, SchoolMask = 0x00, Effects = {
        { ID = 002, SpellID = 002, EffectIndex = 0, Effect = 19, TargetType = 22, Flags = 0x01, Period = 2, Points = 0.2 },
        { ID = 120, SpellID = 002, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x00, Period = 0, Points = 1 },
    } },

    -- DNT Owen Test Double Effect:
    [003] = { SpellID = 003, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 003, SpellID = 003, EffectIndex = 0, Effect = 02, TargetType = 01, Flags = 0x00, Period = 0, Points = 45.2 },
        { ID = 004, SpellID = 003, EffectIndex = 1, Effect = 01, TargetType = 03, Flags = 0x00, Period = 0, Points = 90.4 },
    } },

    -- Double Strike: Nadjia strikes the closest enemy twice, dealing a $s1 and then $s2 Physical damage.
    [004] = { SpellID = 004, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 007, SpellID = 004, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.75 },
        { ID = 008, SpellID = 004, EffectIndex = 1, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Wing Sweep: Draven sweeps his wings, dealing $s1 Physical damage to all enemies.
    [005] = { SpellID = 005, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 009, SpellID = 005, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- Blood Explosion: Theotar pulses with shadow, dealing $s1 Shadow damage to all enemies at range.
    [006] = { SpellID = 006, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 010, SpellID = 006, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Skeleton Smash: Deals $s1 Physical damage to the closest enemy.
    [007] = { SpellID = 007, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 011, SpellID = 007, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- Hawk Punch: Eli strikes as swiftly as a hawk, dealing damage to the closest enemy.
    [008] = { SpellID = 008, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 012, SpellID = 008, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 10 },
    } },

    -- Healing Howl: Heal all allies for $s1% of their maximum health.
    [009] = { SpellID = 009, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 013, SpellID = 009, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x00, Period = 0, Points = 0.05 },
    } },

    -- Starbranch Crush: Smashes the closest enemy for $s1% of their maximum hit points. Each turn, heals for $s3% of maximum health and deals $s2% maximum health Frost damage to all enemies.
    [010] = { SpellID = 010, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 014, SpellID = 010, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x00, Period = 0, Points = 0.2 },
        { ID = 015, SpellID = 010, EffectIndex = 1, Effect = 07, TargetType = 07, Flags = 0x00, Period = 0, Points = 0.03 },
        { ID = 016, SpellID = 010, EffectIndex = 2, Effect = 08, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.01 },
    } },

    -- Auto Attack: Deal attack damage to the closest enemy.
    [011] = { SpellID = 011, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 017, SpellID = 011, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Bone Reconstruction: Heals all allies for $s1.
    [012] = { SpellID = 012, Cooldown = 1, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 018, SpellID = 012, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Gentle Caress:
    [013] = { SpellID = 013, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 019, SpellID = 013, EffectIndex = 0, Effect = 02, TargetType = 02, Flags = 0x00, Period = 0, Points = 10 },
    } },

    -- Spirit's Caress: Anjali heals all allies for $s1.
    [014] = { SpellID = 014, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 020, SpellID = 014, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- Auto Attack: Deal damage to an enemy at range.
    [015] = { SpellID = 015, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 021, SpellID = 015, EffectIndex = 0, Effect = 01, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Soulshatter: Thela rips a memory from the farthest enemy, dealing $s1 Shadow damage.
    [016] = { SpellID = 016, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 022, SpellID = 016, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Gravedirt Special: Dug tosses a shovelful of Grave Dirt at all enemies, dealing $s1 Frost damage and healing himself for $s2.
    [017] = { SpellID = 017, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 023, SpellID = 017, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.1 },
        { ID = 024, SpellID = 017, EffectIndex = 1, Effect = 02, TargetType = 01, Flags = 0x01, Period = 0, Points = 100 },
        { ID = 025, SpellID = 017, EffectIndex = 2, Effect = 00, TargetType = 07, Flags = 0x01, Period = 0, Points = 0 },
    } },

    -- Wings of Fury: Nerith strikes all enemies in melee range three times, each strike dealing $s1 Shadow damage.
    [018] = { SpellID = 018, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 026, SpellID = 018, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 027, SpellID = 018, EffectIndex = 1, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 028, SpellID = 018, EffectIndex = 2, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Searing Bite: Bite the closest enemy with jaws of flame, dealing $s1 Fire damage.
    [019] = { SpellID = 019, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 029, SpellID = 019, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Huck Stone: Stonehuck hurls a Sinstone which shatters and deals $s1 Physical damage to all enemies at range.
    [020] = { SpellID = 020, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 030, SpellID = 020, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.7 },
    } },

    -- Spirits of Rejuvenation: Kaletar heals all allies for $s1.
    [021] = { SpellID = 021, Cooldown = 4, Duration = 4, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 031, SpellID = 021, EffectIndex = 0, Effect = 08, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Unrelenting Hunger: Ayeleth drains the anima from all adjacent enemies, dealing $s1 Shadow damage and an additional $s2 damage each round.
    [022] = { SpellID = 022, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 032, SpellID = 022, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.9 },
        { ID = 033, SpellID = 022, EffectIndex = 1, Effect = 07, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- DNT JasonTest Taunt Spell: Taunt
    [023] = { SpellID = 023, Cooldown = 0, Duration = 2, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 034, SpellID = 023, EffectIndex = 0, Effect = 10, TargetType = 01, Flags = 0x00, Period = 0, Points = 11 },
        { ID = 092, SpellID = 023, EffectIndex = 1, Effect = 07, TargetType = 11, Flags = 0x00, Period = 0, Points = 0.1 },
    } },

    -- Shining Spear: Teliah empowers her spear, dealing $s1 Holy damage to the farthest enemy and healing the closest ally for $s2.
    [024] = { SpellID = 024, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 035, SpellID = 024, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.8 },
        { ID = 036, SpellID = 024, EffectIndex = 1, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Whirling Fists: Kythekios punches all enemies in melee in rapid succession, dealing $s1 Holy damage to them and empowering himself to deal $s2% additional damage.
    [025] = { SpellID = 025, Cooldown = 2, Duration = 3, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 037, SpellID = 025, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
        { ID = 038, SpellID = 025, EffectIndex = 1, Effect = 12, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Physiker's Potion: Telethakas pours a potion down the throat of the closest ally, healing them for $s1 and increasing their maximum health by $s2.
    [026] = { SpellID = 026, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 039, SpellID = 026, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 040, SpellID = 026, EffectIndex = 1, Effect = 18, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- XX - Test - Physical:
    [027] = { SpellID = 027, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 041, SpellID = 027, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Holy:
    [028] = { SpellID = 028, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 042, SpellID = 028, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Fire:
    [029] = { SpellID = 029, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 043, SpellID = 029, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Nature:
    [030] = { SpellID = 030, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 044, SpellID = 030, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Frost:
    [031] = { SpellID = 031, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 045, SpellID = 031, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Shadow:
    [032] = { SpellID = 032, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 046, SpellID = 032, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Melee - Arcane:
    [033] = { SpellID = 033, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 047, SpellID = 033, EffectIndex = 0, Effect = 01, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Physical:
    [034] = { SpellID = 034, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 048, SpellID = 034, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Holy:
    [035] = { SpellID = 035, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 049, SpellID = 035, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Fire:
    [036] = { SpellID = 036, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 050, SpellID = 036, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Nature:
    [037] = { SpellID = 037, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 051, SpellID = 037, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Frost:
    [038] = { SpellID = 038, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 052, SpellID = 038, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Shadow:
    [039] = { SpellID = 039, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 053, SpellID = 039, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- XX - Test - Ranged - Arcane:
    [040] = { SpellID = 040, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 054, SpellID = 040, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Bag Smash: The smuggler swipes with his bag, damaging all adjacent enemies.
    [041] = { SpellID = 041, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 055, SpellID = 041, EffectIndex = 0, Effect = 07, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- JasonTest Passive:
    [042] = { SpellID = 042, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 056, SpellID = 042, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.1 },
    } },

    -- Leech Anima: Siphons anima from the farthest enemy into yourself, dealing $s1 Shadow damage and healing for $s2.
    [043] = { SpellID = 043, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 057, SpellID = 043, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.25 },
        { ID = 058, SpellID = 043, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Double Stab: Stabs the closest enemy twice, dealing $s1 Physical damage with the first knife and and $s2 with the second.
    [044] = { SpellID = 044, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 059, SpellID = 044, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
        { ID = 060, SpellID = 044, EffectIndex = 1, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Siphon Soul: Deals $s1 Arcane damage to the farthest enemy and heals themself for $s2.
    [045] = { SpellID = 045, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 061, SpellID = 045, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
        { ID = 062, SpellID = 045, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Shield of Tomorrow: The Phalanx takes 10% reduced damage and protects all ranged allies in the same way.
    [046] = { SpellID = 046, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 063, SpellID = 046, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.1 },
        { ID = 064, SpellID = 046, EffectIndex = 1, Effect = 14, TargetType = 16, Flags = 0x00, Period = 0, Points = -0.1 },
    } },

    -- Protective Aura: Draven's wingspan shields himself and all allies, reducing all damage taken by 20%.
    [047] = { SpellID = 047, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 065, SpellID = 047, EffectIndex = 0, Effect = 14, TargetType = 06, Flags = 0x00, Period = 0, Points = -0.2 },
    } },

    -- Shadow Walk: Nadjia becomes untargetable and heals herself for $s2.
    [048] = { SpellID = 048, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 066, SpellID = 048, EffectIndex = 0, Effect = 10, TargetType = 01, Flags = 0x01, Period = 0, Points = 0 },
        { ID = 067, SpellID = 048, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Exsanguination: Theotar rips the blood from all enemies at range, increasing the damage they take by $s1%.
    [049] = { SpellID = 049, Cooldown = 4, Duration = 4, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 068, SpellID = 049, EffectIndex = 0, Effect = 14, TargetType = 17, Flags = 0x00, Period = 0, Points = 0.33 },
    } },

    -- Halberd Strike: The Halberdier slices their weapon at the farthest enemy, dealing $s1 Physical damage.
    [050] = { SpellID = 050, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 069, SpellID = 050, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Bonestorm: Whirls in place, dealing $s1 Shadow damage to all enemies in melee.
    [051] = { SpellID = 051, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 070, SpellID = 051, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Plague Song: Scream at enemies at range, inflicting $s1 Nature damage each round for 4 rounds.
    [052] = { SpellID = 052, Cooldown = 5, Duration = 4, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 071, SpellID = 052, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Bramble Trap: Winding tendrils ensnare all enemies, dealing $s1 Nature damage and reducing their damage by 20% every other round.
    [053] = { SpellID = 053, Cooldown = 6, Duration = 6, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 072, SpellID = 053, EffectIndex = 0, Effect = 07, TargetType = 07, Flags = 0x01, Period = 2, Points = 0.1 },
        { ID = 073, SpellID = 053, EffectIndex = 1, Effect = 12, TargetType = 07, Flags = 0x01, Period = 2, Points = -0.2 },
    } },

    -- Slicing Shadows: Rahel cheerfully slices the closest enemy and hurls a dagger at the farthest enemy, dealing $s1 Shadow damage to both.
    [054] = { SpellID = 054, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 074, SpellID = 054, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.9 },
        { ID = 075, SpellID = 054, EffectIndex = 1, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.9 },
    } },

    -- Polite Greeting: Stonehead smiles and politely smashes all enemies in melee for $s1 Physical damage.
    [055] = { SpellID = 055, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 076, SpellID = 055, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Mirror of Torment: Simone wields her mirror with precision, dealing $s1 Arcane damage to the farthest enemy.
    [056] = { SpellID = 056, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 077, SpellID = 056, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.25 },
    } },

    -- Etiquette Lesson: Bogdan reminds the nearest enemy of their manners, dealing $s1 Shadow damage for the next three turns.
    [057] = { SpellID = 057, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 078, SpellID = 057, EffectIndex = 0, Effect = 07, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Headcrack: Lost Sybille smashes the heads of all adjacent enemies together, dealing $s1 Physical damage.
    [058] = { SpellID = 058, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 079, SpellID = 058, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.7 },
    } },

    -- Mirrors of Regret: Vulca invokes the power of loss, dealing $s1 Arcane damage to all enemies at range.
    [059] = { SpellID = 059, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 080, SpellID = 059, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Acid Spit: Spits acid at the farthest enemy, dealing $s1 Nature damage.
    [060] = { SpellID = 060, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 081, SpellID = 060, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Mandible Smash: Smashes the closest enemy, dealing $s1 Nature damage.
    [061] = { SpellID = 061, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 082, SpellID = 061, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Gore: Stabs all enemies in melee with their antlers, dealing $s1 Nature damage.
    [062] = { SpellID = 062, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 083, SpellID = 062, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Sonic Shriek: Shrieks loudly, dealing $s1 Nature damage to all enemies and causing them to deal $s2% less damage for two rounds.
    [063] = { SpellID = 063, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 084, SpellID = 063, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 085, SpellID = 063, EffectIndex = 1, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -0.2 },
    } },

    -- Massive Rumble: Slams his carapace into the ground, dealing $s1 Nature damage to all enemies.
    [064] = { SpellID = 064, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 086, SpellID = 064, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Nagging Doubt: Gnaws at the closest enemy, dealing $s1 Shadow damage.
    [065] = { SpellID = 065, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 087, SpellID = 065, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.65 },
    } },

    -- Goliath Slam: Slams a nearby enemy, dealing $s1 Shadow damage to them and an enemy behind them.
    [066] = { SpellID = 066, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 088, SpellID = 066, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Vault Strike: Leap in the air and strike the farthest enemy with a spear of shadow, dealing $s1 Shadow damage.
    [067] = { SpellID = 067, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 089, SpellID = 067, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Glowhoof Trample: Strike all enemies in melee, dealing $s1 Holy damage and reducing their damage by $s2%.
    [068] = { SpellID = 068, Cooldown = 3, Duration = 1, Flags = 1, SchoolMask = 0x02, Effects = {
        { ID = 090, SpellID = 068, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 091, SpellID = 068, EffectIndex = 1, Effect = 12, TargetType = 15, Flags = 0x00, Period = 0, Points = -0.8 },
    } },

    -- DNT JasonTest Ability Spell2: DNT Test test  Effect 0 Attack points $s0, Effect 1 Attack points % $s1, Effect 2 Flat points $s2, Effect 3 Flat points % $s3
    [069] = { SpellID = 069, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 095, SpellID = 069, EffectIndex = 0, Effect = 01, TargetType = 01, Flags = 0x01, Period = 2, Points = 50 },
        { ID = 096, SpellID = 069, EffectIndex = 1, Effect = 03, TargetType = 01, Flags = 0x01, Period = 2, Points = 0.2 },
        { ID = 097, SpellID = 069, EffectIndex = 2, Effect = 01, TargetType = 01, Flags = 0x00, Period = 0, Points = 50 },
        { ID = 098, SpellID = 069, EffectIndex = 3, Effect = 03, TargetType = 00, Flags = 0x00, Period = 0, Points = 0.2 },
    } },

    -- DNT JasonTest Spell Tooltip: DNT test test test
    [070] = { SpellID = 070, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x00, Effects = {
    } },

    -- Revitalizing Vines: Heals the closest ally for $s1.
    [071] = { SpellID = 071, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 099, SpellID = 071, EffectIndex = 0, Effect = 02, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Resonating Strike: Hala strikes the closest enemy for $s1 Holy damage. The force of the blow generates a secondary shockwave, dealing $s2 Holy damage to all enemies at range.
    [072] = { SpellID = 072, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 100, SpellID = 072, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 101, SpellID = 072, EffectIndex = 1, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Purification Ray: Molako purifies all enemies in a line, dealing $s1 Holy damage.
    [073] = { SpellID = 073, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 102, SpellID = 073, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Reconfiguration: Defense: Ispiron reconfigures, reallocating resources to protect himself, reducing all damage taken and dealt by 40% for 3 rounds.
    [074] = { SpellID = 074, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 103, SpellID = 074, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.4 },
        { ID = 104, SpellID = 074, EffectIndex = 1, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.4 },
    } },

    -- Larion Leap: Nemea enlists a Larion friend to leap into battle, dealing $s1 Physical damage to the farthest enemy.
    [075] = { SpellID = 075, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 105, SpellID = 075, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Phalynx Flash: Pelodis enlists a Phalynx to charge into battle, dealing $s1 Holy damage to the farthest enemy.
    [076] = { SpellID = 076, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 106, SpellID = 076, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 2.25 },
    } },

    -- Potions of Penultimate Power: Sika dishes out potions to the party, increasing their Damage by $s1 Holy for 3 rounds.
    [077] = { SpellID = 077, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 107, SpellID = 077, EffectIndex = 0, Effect = 19, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Cleave: Clora cleaves all enemies in melee, dealing $s1 Holy damage.
    [078] = { SpellID = 078, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 108, SpellID = 078, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Holy Nova: Kosmas erupts in light, dealing $s1 Holy damage to all enemies and healing allies for $s2.
    [079] = { SpellID = 079, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 109, SpellID = 079, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 110, SpellID = 079, EffectIndex = 1, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Dawnshock: Apolon's light ignites the farthest enemy, dealing $s1 Fire damage and $s2 Fire damage for the next 2 rounds.
    [080] = { SpellID = 080, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 111, SpellID = 080, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
        { ID = 112, SpellID = 080, EffectIndex = 1, Effect = 07, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Reconfiguration: Reflect: Bron reconfigures, wreathing himself in bands of light that deal $s1 Holy damage to all who attack him for the next 3 rounds.
    [081] = { SpellID = 081, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 113, SpellID = 081, EffectIndex = 0, Effect = 15, TargetType = 01, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Mace to Hand: Kleia's determination (and mace) make enemies pay dearly, dealing $s1 Physical damage to any who attack her.
    [082] = { SpellID = 082, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 114, SpellID = 082, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Lead the Charge: Kleia charges into battle, dealing $s1 Physical damage to all adjacent enemies.
    [083] = { SpellID = 083, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 115, SpellID = 083, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Sparkling Driftglobe Core: Mikanikos dazzles all enemies for two rounds, reducing their damage by 100%. Does not cast at the start of battle.
    [084] = { SpellID = 084, Cooldown = 4, Duration = 2, Flags = 1, SchoolMask = 0x40, Effects = {
        { ID = 116, SpellID = 084, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -1 },
    } },

    -- Resilient Plumage: Mikanikos enhances the durability of the closest ally, reducing the damage they take by 50% for two rounds.
    [085] = { SpellID = 085, Cooldown = 3, Duration = 2, Flags = 1, SchoolMask = 0x02, Effects = {
        { ID = 117, SpellID = 085, EffectIndex = 0, Effect = 14, TargetType = 02, Flags = 0x00, Period = 0, Points = -50 },
    } },

    -- [PH]Placeholder Punch: [PH] Powerfully punches the nearest enemy for $s1 Physical damage.
    [086] = { SpellID = 086, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 118, SpellID = 086, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Doubt Defied: Pelagos faces his fears and hurls light in the face of his foes, dealing $s1 Holy damage to all enemies at range.
    [087] = { SpellID = 087, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 119, SpellID = 087, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Combat Meditation: Pelagos meditates, increasing his damage by 30% and inflicting a Sorrowful Memory on all enemies, dealing $s2 Holy damage.
    [088] = { SpellID = 088, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 121, SpellID = 088, EffectIndex = 0, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.3 },
        { ID = 123, SpellID = 088, EffectIndex = 1, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Spiked Burr Trap: Niya's Burr Trap deals $s1 Nature damage to the furthest enemy each turn for 2 turns.
    [089] = { SpellID = 089, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 124, SpellID = 089, EffectIndex = 0, Effect = 07, TargetType = 05, Flags = 0x03, Period = 1, Points = 0.4 },
    } },

    -- Invigorating Herbs: Niya invigorates adjacent allies, increasing all damage they deal by 20%.
    [090] = { SpellID = 090, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 125, SpellID = 090, EffectIndex = 0, Effect = 12, TargetType = 08, Flags = 0x00, Period = 0, Points = 0.2 },
    } },

    -- Dazzledust: Blisswing modifies the damage of the furthest enemy by $s1 for 3 rounds.
    [091] = { SpellID = 091, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 126, SpellID = 091, EffectIndex = 0, Effect = 19, TargetType = 05, Flags = 0x01, Period = 0, Points = -0.6 },
    } },

    -- Trickster's Torment: Duskleaf deals $s1 Shadow damage to all enemies at range for 2 rounds.
    [092] = { SpellID = 092, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 127, SpellID = 092, EffectIndex = 0, Effect = 07, TargetType = 17, Flags = 0x03, Period = 1, Points = 0.5 },
    } },

    -- Leeching Seed: Karynmwylyann draws strength from the closest enemy, dealing $s1 Nature damage and healing himself for $s2.
    [093] = { SpellID = 093, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 128, SpellID = 093, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 129, SpellID = 093, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Icespore Spear: Chalkyth slashes all enemies in melee with his spear and implants an Icespore, dealing $s1 Frost damage each round for 3 rounds.
    [094] = { SpellID = 094, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 130, SpellID = 094, EffectIndex = 0, Effect = 07, TargetType = 15, Flags = 0x01, Period = 1, Points = 0.3 },
    } },

    -- Starlight Strike: Lloth'wellyn calls upon the stars, dealing $s1 Arcane damage to the farthest enemy, and $s2 Arcane damage to all enemies at range.
    [095] = { SpellID = 095, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 131, SpellID = 095, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
        { ID = 132, SpellID = 095, EffectIndex = 1, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Insect Swarm: Yira'lya summons a swarm of insects to torment the farthest enemy, dealing $s1 Nature damage and reducing their damage by 30% for two rounds.
    [096] = { SpellID = 096, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 133, SpellID = 096, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 134, SpellID = 096, EffectIndex = 1, Effect = 12, TargetType = 05, Flags = 0x00, Period = 0, Points = -0.3 },
    } },

    -- Flashing Arrows: Kota unleashes a flurry of arrows, dealing $s1 Physical damage in a cone emanating from her closest enemy.
    [097] = { SpellID = 097, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 135, SpellID = 097, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.9 },
    } },

    -- Anima Bolt: Sha'lor blasts the furthest enemy with shaped Anima, dealing $s1 Arcane damage.
    [098] = { SpellID = 098, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 136, SpellID = 098, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Onslaught: Tez'an rips and tears with his teeth, dealing $s1 Nature damage to all enemies in melee.
    [099] = { SpellID = 099, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x09, Effects = {
        { ID = 137, SpellID = 099, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.4 },
    } },

    -- Heart of the Forest: Qadarin heals himself for $s1 Nature.
    [100] = { SpellID = 100, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 138, SpellID = 100, EffectIndex = 0, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Strangleheart Seed: Watcher Vesperbloom implants a seed into the nearest enemy, dealing $s1 Nature damage and increasing damage taken by 20% for three rounds.
    [101] = { SpellID = 101, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 139, SpellID = 101, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 140, SpellID = 101, EffectIndex = 1, Effect = 14, TargetType = 03, Flags = 0x00, Period = 0, Points = 0.2 },
    } },

    -- Forest's Touch: Groonoomcrooek's branches lash in the wind, dealing $s1 Nature damage to all enemies in a line.
    [102] = { SpellID = 102, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 141, SpellID = 102, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Social Butterfly: Dreamweaver doubles the damage of all allies for 2 rounds.
    [103] = { SpellID = 103, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 142, SpellID = 103, EffectIndex = 0, Effect = 12, TargetType = 22, Flags = 0x00, Period = 0, Points = 1 },
    } },

    -- Podtender: Heal an adjacent ally for $s1, but reduce their damage by 10% for the next round.
    [104] = { SpellID = 104, Cooldown = 1, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 143, SpellID = 104, EffectIndex = 0, Effect = 02, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.9 },
        { ID = 144, SpellID = 104, EffectIndex = 1, Effect = 12, TargetType = 02, Flags = 0x00, Period = 0, Points = -0.1 },
    } },

    -- Hold the Line: Korayn and allies take 10% less damage.
    [105] = { SpellID = 105, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 145, SpellID = 105, EffectIndex = 0, Effect = 14, TargetType = 06, Flags = 0x00, Period = 0, Points = -0.1 },
    } },

    -- Face Your Foes: Korayn steels her resolve and slices her opposition, dealing $s1 Physical damage to all adjacent enemies.
    [106] = { SpellID = 106, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 146, SpellID = 106, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Volatile Solvent: Marileth douses the nearest enemy, dealing $s1 Shadow damage and inflicting an additional $s2 Shadow damage when the target is struck for three rounds.
    [107] = { SpellID = 107, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 147, SpellID = 107, EffectIndex = 0, Effect = 07, TargetType = 03, Flags = 0x03, Period = 0, Points = 1.5 },
        { ID = 148, SpellID = 107, EffectIndex = 1, Effect = 20, TargetType = 03, Flags = 0x03, Period = 0, Points = 0.5 },
    } },

    -- Ooz's Frictionless Coating: Marileth heals a nearby ally for $s1 and increases their maximum health by 10%.
    [108] = { SpellID = 108, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 149, SpellID = 108, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.4 },
        { ID = 150, SpellID = 108, EffectIndex = 1, Effect = 18, TargetType = 02, Flags = 0x02, Period = 0, Points = 0.1 },
    } },

    -- Serrated Shoulder Blades: Enemies attacking Heirmir take $s1 Physical damage.
    [109] = { SpellID = 109, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 151, SpellID = 109, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Ravenous Brooch: Heirmir's brooch heals her for $s1.
    [110] = { SpellID = 110, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 152, SpellID = 110, EffectIndex = 0, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Sulfuric Emission: Emeni's fumes deal $s1 Nature damage to all enemies in melee range.
    [111] = { SpellID = 111, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 153, SpellID = 111, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Gnashing Chompers: Emeni's marvelous mastication inspires all adjacent allies, increasing their damage by $s1 Shadow.
    [112] = { SpellID = 112, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 154, SpellID = 112, EffectIndex = 0, Effect = 19, TargetType = 08, Flags = 0x03, Period = 0, Points = 0.3 },
    } },

    -- Secutor's Judgment: Mevix judges his opponent wanting, dealing $s1 Shadowfrost damage to all enemies in a cone in front of him.
    [113] = { SpellID = 113, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x30, Effects = {
        { ID = 155, SpellID = 113, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Reconstruction: Every round, Gunn heals herself for $s1.
    [114] = { SpellID = 114, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 156, SpellID = 114, EffectIndex = 0, Effect = 02, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Dynamic Fist: Rencissa lashes out, dealing $s1 Shadow damage to adjacent enemies.
    [115] = { SpellID = 115, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 157, SpellID = 115, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.7 },
    } },

    -- Dreaming Charge: The Juvenile Miredeer lowers its horns and charges, dealing $s1 Nature damage to the closest enemy.
    [116] = { SpellID = 116, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 158, SpellID = 116, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Swift Slash: Slashes at the front rank of enemies, dealing $s1 Nature damage.
    [117] = { SpellID = 117, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 159, SpellID = 117, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Mischievous Blast: Blasts the furthest foe with $s1 Nature damage.
    [118] = { SpellID = 118, Cooldown = 4, Duration = 0, Flags = 1, SchoolMask = 0x08, Effects = {
        { ID = 160, SpellID = 118, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Corrosive Thrust: Jabs out with a corrosive cone attack, dealing $s1 Nature damage in a cone emitting from the closest enemy.
    [119] = { SpellID = 119, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 161, SpellID = 119, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Goading Motivation: The Trickster goads a random ally into trying harder.
    [120] = { SpellID = 120, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 162, SpellID = 120, EffectIndex = 0, Effect = 12, TargetType = 20, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Mesmeric Dust: The Trickster blows a glittering distracting dust across all enemies.
    [121] = { SpellID = 121, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 163, SpellID = 121, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x01, Period = 0, Points = -0.5 },
    } },

    -- Humorous Flame: Chaos and fire! This attack deals $s1 Fire damage over three turns to a random enemy.
    [122] = { SpellID = 122, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 164, SpellID = 122, EffectIndex = 0, Effect = 07, TargetType = 21, Flags = 0x01, Period = 3, Points = 0.3 },
    } },

    -- Healing Winds: The Trickster heals front line allies for $s1.
    [123] = { SpellID = 123, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 165, SpellID = 123, EffectIndex = 0, Effect = 04, TargetType = 14, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Kick: Kicks all adjacent enemies in melee with their powerful hooves, dealing $s1 Nature damage.
    [124] = { SpellID = 124, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 166, SpellID = 124, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Deranged Gouge: The Scavenger lashes out at a random enemy, dealing $s1 Nature damage, and reducing the targets damage by $s2% for one turn.
    [125] = { SpellID = 125, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 167, SpellID = 125, EffectIndex = 0, Effect = 03, TargetType = 20, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 168, SpellID = 125, EffectIndex = 1, Effect = 12, TargetType = 20, Flags = 0x00, Period = 1, Points = -0.5 },
    } },

    -- Possessive Healing: The Grovetender uses their knowledge of nurturing magics, healing their front line allies for $s1.
    [126] = { SpellID = 126, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 169, SpellID = 126, EffectIndex = 0, Effect = 04, TargetType = 14, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Nibble: The Gormling gets a taste for all the enemies in melee, dealing $s1 Nature damage.
    [127] = { SpellID = 127, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 170, SpellID = 127, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Regurgitate: The Gormling regurgitates a massive stream of acidic liquid at all enemies at range, dealing $s1 Nature damage.
    [128] = { SpellID = 128, Cooldown = 5, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 171, SpellID = 128, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Queen's Command: The Queen commands her minions to do better, healing them for $s1, and buffing their damage by $s2% for one turn.
    [129] = { SpellID = 129, Cooldown = 5, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 172, SpellID = 129, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.3 },
        { ID = 173, SpellID = 129, EffectIndex = 1, Effect = 12, TargetType = 06, Flags = 0x00, Period = 1, Points = 0.5 },
    } },

    -- Carapace Thorns: The Gormling forms a protective, thorny, shield, which deals $s1 Nature damage to anyone attacking it for three turns.
    [130] = { SpellID = 130, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 174, SpellID = 130, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Arcane Antlers: Arcane bolts shoot from the Runestag's antlers, dealing $s1 Arcane damage to all enemies at range.
    [131] = { SpellID = 131, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 175, SpellID = 131, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Arbor Eruption: This attack explodes with the force of a falling tree, dealing $s1 Nature damage to all enemies in melee, and reducing their damage by $s2% for one turn.
    [132] = { SpellID = 132, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 176, SpellID = 132, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
        { ID = 177, SpellID = 132, EffectIndex = 1, Effect = 12, TargetType = 15, Flags = 0x00, Period = 1, Points = -0.25 },
    } },

    -- Hidden Power: The manifestation draws on ancient power to deal $s1 Arcane damage to all enemies at range, and heal themselves for some of the damage.
    [133] = { SpellID = 133, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 178, SpellID = 133, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 179, SpellID = 133, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Curse of the Dark Forest: Curses all enemies, increasing the damange they take by 25% for two turns.
    [134] = { SpellID = 134, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 180, SpellID = 134, EffectIndex = 0, Effect = 14, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Fires of Domination: A fiery wave of projectiles is spewed across the battlefield, dealing $s1 Fire damage to all enemies at range.
    [135] = { SpellID = 135, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 181, SpellID = 135, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Searing Jaws: Bite the closest enemy with jaws of flame, dealing $s1 Fire damage over three turns.
    [136] = { SpellID = 136, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 182, SpellID = 136, EffectIndex = 0, Effect = 07, TargetType = 03, Flags = 0x01, Period = 3, Points = 1.5 },
    } },

    -- Hearty Shout: A hearty battlecry that increases damage done by $s1% for two turns.
    [137] = { SpellID = 137, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 183, SpellID = 137, EffectIndex = 0, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.25 },
    } },

    -- Tail lash: Lashes out against all adjacent enemies in melee, dealing $s1 Arcane damage.
    [138] = { SpellID = 138, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 184, SpellID = 138, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Hunger Frenzy: Starts on Cooldown. The creature goes into a frenzy, lashing out at all enemies at range, dealing $s1 Arcane damage.
    [139] = { SpellID = 139, Cooldown = 6, Duration = 0, Flags = 1, SchoolMask = 0x40, Effects = {
        { ID = 185, SpellID = 139, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 4 },
    } },

    -- Fan of Knives: Khaliiq hurls energized daggers at all enemies at range, dealing $s1 Shadow damage and reducing their damage by 10% for 2 rounds.
    [140] = { SpellID = 140, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 186, SpellID = 140, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 187, SpellID = 140, EffectIndex = 1, Effect = 12, TargetType = 17, Flags = 0x00, Period = 0, Points = -0.1 },
    } },

    -- Herd Immunity: The creature shares some of its remaining anima to protect its herd. All allies gain $s1% damage mitigation for two turns.
    [141] = { SpellID = 141, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 188, SpellID = 141, EffectIndex = 0, Effect = 14, TargetType = 06, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Arcane Restoration: The creature pulses out waves of concentrated anima, healing in a cone from the closest ally for $s1.
    [142] = { SpellID = 142, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 189, SpellID = 142, EffectIndex = 0, Effect = 04, TargetType = 10, Flags = 0x01, Period = 0, Points = 0.7 },
    } },

    -- Arrogant Boast: The manifestation exclaims belief in their own ability, increasing damage done by $s1% for two turns.
    [143] = { SpellID = 143, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 190, SpellID = 143, EffectIndex = 0, Effect = 12, TargetType = 01, Flags = 0x00, Period = 2, Points = 0.25 },
    } },

    -- Ardent Defense: The manifestation defends their position, reducing the damage their allies take by $s1% for two turns.
    [144] = { SpellID = 144, Cooldown = 4, Duration = 2, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 191, SpellID = 144, EffectIndex = 0, Effect = 14, TargetType = 22, Flags = 0x00, Period = 0, Points = -0.75 },
    } },

    -- Shield Bash: Smashes the closest enemy, dealing $s1 Shadow damage.
    [145] = { SpellID = 145, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 192, SpellID = 145, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Dark Javelin: Hurls a javelin at the farthest enemy, dealing $s1 Shadow damage.
    [146] = { SpellID = 146, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 193, SpellID = 146, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Close Ranks: The praetor inspires the Forsworn, reducing the damage allies take by $s1% for two turns.
    [147] = { SpellID = 147, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 194, SpellID = 147, EffectIndex = 0, Effect = 14, TargetType = 22, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Divine Maintenance: Release restorative anima, healing front line allies for $s1.
    [148] = { SpellID = 148, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 195, SpellID = 148, EffectIndex = 0, Effect = 04, TargetType = 14, Flags = 0x01, Period = 0, Points = 1.25 },
    } },

    -- Phalynx Slash: Slashes at the front rank of enemies, dealing $s1 Shadow damage.
    [149] = { SpellID = 149, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 196, SpellID = 149, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Crashing Claws: A furious flurry of claws, dealing $s1 Shadow damage in a cone from the closest enemy.
    [150] = { SpellID = 150, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 197, SpellID = 150, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Dive Bomb: Swoops down on the closest enemy dealing $s1 Physical damage.
    [151] = { SpellID = 151, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 198, SpellID = 151, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Anima Wave: The Matriarch sends out a wave of pure anima, healing all allies for $s1, and buffing their damage by $s2% for one turn.
    [152] = { SpellID = 152, Cooldown = 5, Duration = 1, Flags = 1, SchoolMask = 0x08, Effects = {
        { ID = 199, SpellID = 152, EffectIndex = 0, Effect = 04, TargetType = 22, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 200, SpellID = 152, EffectIndex = 1, Effect = 12, TargetType = 22, Flags = 0x00, Period = 1, Points = 0.5 },
    } },

    -- Forbidden Research: Projects a condensed stream of anima, dealing $s1 Shadow damage in a cone from the closest enemy.
    [153] = { SpellID = 153, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 201, SpellID = 153, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Stolen Wards: Forms a reflective shield, which deals $s1 Shadow damage to anyone attacking it for three turns.
    [154] = { SpellID = 154, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 202, SpellID = 154, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Concussive Roar: A concussive roar that shakes all enemies and reduces their damage done by $s1% for one turn.
    [155] = { SpellID = 155, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 203, SpellID = 155, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -0.75 },
    } },

    -- Cursed Knowledge: Curses all enemies, increasing the damange they take by $s1% for two turns.
    [156] = { SpellID = 156, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 204, SpellID = 156, EffectIndex = 0, Effect = 14, TargetType = 07, Flags = 0x00, Period = 0, Points = 0.4 },
    } },

    -- Frantic Flap: A frantic flap of sharp wings, striking all adjacent enemies in melee, dealing $s1 damage.
    [157] = { SpellID = 157, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 205, SpellID = 157, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Explosion of Dark Knowledge: Starts on Cooldown. Blasts all enemies at range with $s1 Shadow damage.
    [158] = { SpellID = 158, Cooldown = 3, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 206, SpellID = 158, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Proclamation of Doubt: The creature makes all enemies doubt themselves, decreasing damage done by $s1% for two turns.
    [159] = { SpellID = 159, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 207, SpellID = 159, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 2, Points = -0.25 },
    } },

    -- Seismic Slam: Slams his massive fists into the ground, dealing $s1 Nature damage to all enemies.
    [160] = { SpellID = 160, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 208, SpellID = 160, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Dark Command: The Overseer marshalls his troops, healing them for $s1, and buffing their damage by $s2% for one turn.
    [161] = { SpellID = 161, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 209, SpellID = 161, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 210, SpellID = 161, EffectIndex = 1, Effect = 12, TargetType = 06, Flags = 0x00, Period = 0, Points = 0.25 },
    } },

    -- Curse of Darkness: Curses all enemies, decreasing the damange they do by $s1% for two turns.
    [162] = { SpellID = 162, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 211, SpellID = 162, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Wave of Conviction: Starts on Cooldown. Sends out a powerful wave of anima, dealing $s1 Shadow damage to all enemies.
    [163] = { SpellID = 163, Cooldown = 6, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 212, SpellID = 163, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 4 },
    } },

    -- Dark Flame: Breathes a dark flame, dealing $s1 Shadow damage over three turns in a cone emitting from the closest enemy.
    [164] = { SpellID = 164, Cooldown = 6, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 213, SpellID = 164, EffectIndex = 0, Effect = 07, TargetType = 11, Flags = 0x03, Period = 3, Points = 2 },
    } },

    -- Winged Assault: Slashes at the closest enemy, dealing $s1 Shadow damage.
    [165] = { SpellID = 165, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 214, SpellID = 165, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Leeching Bite: Bites at a random enemy, dealing $s1 Shadow damage and healing itself for $s2.
    [166] = { SpellID = 166, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 215, SpellID = 166, EffectIndex = 0, Effect = 03, TargetType = 21, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 216, SpellID = 166, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Razor Shards: Casts a series of sharp, stone, shards at all enemies at range, dealing $s1 Nature damage.
    [167] = { SpellID = 167, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 217, SpellID = 167, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Howl from Beyond: Lets loose a vicious howl that strikes fear into the nearest enemy, reducing their damage by $s1% for two turns.
    [168] = { SpellID = 168, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 218, SpellID = 168, EffectIndex = 0, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Consuming Strike: Strikes at the closest enemy, dealing $s1 Shadow damage, and causing a damage over time effect for $s2 over three turns.
    [169] = { SpellID = 169, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 219, SpellID = 169, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.65 },
        { ID = 220, SpellID = 169, EffectIndex = 1, Effect = 07, TargetType = 03, Flags = 0x03, Period = 3, Points = 0.5 },
    } },

    -- Stone Bash: Flying fists of stone deal $s1 Nature damage to all enemies in melee.
    [170] = { SpellID = 170, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 221, SpellID = 170, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Pitched Boulder: Hurls a massive boulder, dealing $s1 Nature damage to all enemies at range.
    [171] = { SpellID = 171, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 222, SpellID = 171, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Viscous Slash: Strike all enemies in melee, dealing $s1 Shadow damage and reducing their damage by $s2%.
    [172] = { SpellID = 172, Cooldown = 3, Duration = 1, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 223, SpellID = 172, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 224, SpellID = 172, EffectIndex = 1, Effect = 12, TargetType = 15, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Icy Blast: Blasts the furthest foe with $s1 Frost damage, reducing their damage by $s2%.
    [173] = { SpellID = 173, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 225, SpellID = 173, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
        { ID = 226, SpellID = 173, EffectIndex = 1, Effect = 12, TargetType = 05, Flags = 0x00, Period = 0, Points = -0.25 },
    } },

    -- Polished Ice Barrier: A frozen reflective shield forms which deals $s1 Frost damage to anyone attacking it for three turns.
    [174] = { SpellID = 174, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 227, SpellID = 174, EffectIndex = 0, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Lash Out: The party animal is lost in the moment and lashes out at a random target, dealing $s1 Shadow damage.
    [175] = { SpellID = 175, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 228, SpellID = 175, EffectIndex = 0, Effect = 03, TargetType = 19, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Arrogant Denial: The noble launches into a passionate defense of the aristocracy, distracting all enemies and increasing damage taken by $s1%.
    [176] = { SpellID = 176, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 229, SpellID = 176, EffectIndex = 0, Effect = 14, TargetType = 07, Flags = 0x00, Period = 0, Points = 0.25 },
    } },

    -- Shoulder Charge: Slams into the closest enemy, dealing $s1 damage.
    [177] = { SpellID = 177, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 230, SpellID = 177, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Draw Anima: Draws anima from the furthest enemy, dealing $s1 Shadow damage and healing itself for $s2.
    [178] = { SpellID = 178, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 231, SpellID = 178, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 232, SpellID = 178, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Medical Advice: Emits a healing mist, healing all allies for $s1, and increases their damage by $s2% for two turns.
    [179] = { SpellID = 179, Cooldown = 6, Duration = 2, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 233, SpellID = 179, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 234, SpellID = 179, EffectIndex = 1, Effect = 12, TargetType = 06, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Mental Assault: Targets a random enemy with visions of doom, dealing $s1 Shadow damage.
    [180] = { SpellID = 180, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 235, SpellID = 180, EffectIndex = 0, Effect = 03, TargetType = 20, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Anima Blast: Starts on Cooldown. Blasts all enemies at range with $s1 Shadow damage.
    [181] = { SpellID = 181, Cooldown = 6, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 236, SpellID = 181, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Deceptive Practice: Confuses all enemies with mirror reflections, decreasing the damage they do by $s1% for two turns.
    [182] = { SpellID = 182, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 237, SpellID = 182, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Shadow Swipe: Slashes at all enemies in melee with their claws, dealing $s1 Shadow damage.
    [183] = { SpellID = 183, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 238, SpellID = 183, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Anima Lash: Blasts out a cone of anima from the closest enemy, dealing $s1 Shadow damage.
    [184] = { SpellID = 184, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 239, SpellID = 184, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Temper Tantrum: Stacka lashes out with all his strength, dealing $s1 Shadow damage to all enemies.
    [185] = { SpellID = 185, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 240, SpellID = 185, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Feral Rage: Starts on Cooldown. Claws and bites wildly at all enemies in melee, dealing $s1 Shadow damage.
    [186] = { SpellID = 186, Cooldown = 5, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 241, SpellID = 186, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Toxic Miasma: Emits a wave of toxic magic across all enemies, causing a damage over time effect for $s1 over two turns.
    [187] = { SpellID = 187, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 242, SpellID = 187, EffectIndex = 0, Effect = 07, TargetType = 07, Flags = 0x03, Period = 2, Points = 0.5 },
    } },

    -- Angry Smash: Big Shiny lashes out at the closest enemy, dealing $s1 damage, and reducing the targets damage by $s2% for one turn.
    [188] = { SpellID = 188, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 243, SpellID = 188, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
        { ID = 244, SpellID = 188, EffectIndex = 1, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Angry Bash: Bashes into the closest enemy, dealing $s1 damage.
    [189] = { SpellID = 189, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 245, SpellID = 189, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Anima Wave: Blasts all enemies in melee with $s1 Shadow damage.
    [190] = { SpellID = 190, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 246, SpellID = 190, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Toxic Dispersal: Deals $s1 Nature damage each round to all enemies and heals all allies for $s2.
    [191] = { SpellID = 191, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 247, SpellID = 191, EffectIndex = 0, Effect = 01, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.2 },
        { ID = 248, SpellID = 191, EffectIndex = 1, Effect = 02, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- Shadow Bolt: Rathan blasts the furthest enemy, dealing $s1 Shadow damage.
    [192] = { SpellID = 192, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 249, SpellID = 192, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.6 },
    } },

    -- Flesh Eruption: Gorgelimb sacrifices his own flesh, dealing $s1 Physical damage to enemies in melee and $s2 damage to himself.
    [193] = { SpellID = 193, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 250, SpellID = 193, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 3 },
        { ID = 251, SpellID = 193, EffectIndex = 1, Effect = 03, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Potentiated Power: Ashraka empowers an adjacent ally at the cost of her own health, increasing their damage by $s1 Shadow and modifying incoming damage by $s2 for 2 turns.
    [194] = { SpellID = 194, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 252, SpellID = 194, EffectIndex = 0, Effect = 19, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.4 },
        { ID = 253, SpellID = 194, EffectIndex = 1, Effect = 14, TargetType = 02, Flags = 0x01, Period = 0, Points = -0.2 },
        { ID = 254, SpellID = 194, EffectIndex = 2, Effect = 03, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Creeping Chill: Talethi deals $s1 Frost damage each turn for 2 turns to enemies in a cone in front of him.
    [195] = { SpellID = 195, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 255, SpellID = 195, EffectIndex = 0, Effect = 07, TargetType = 11, Flags = 0x03, Period = 1, Points = 0.8 },
    } },

    -- Hail of Blades: Velkein strikes an adjacent enemy multiple times, dealing $s1 Physical damage, then $s2, then $s3, then $s4.
    [196] = { SpellID = 196, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 256, SpellID = 196, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.2 },
        { ID = 257, SpellID = 196, EffectIndex = 1, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.9 },
        { ID = 258, SpellID = 196, EffectIndex = 2, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 259, SpellID = 196, EffectIndex = 3, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Reassembly: Assembler Xertora reconstructs all adjacent allies, healing them for $s1.
    [197] = { SpellID = 197, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 260, SpellID = 197, EffectIndex = 0, Effect = 04, TargetType = 08, Flags = 0x01, Period = 0, Points = 0.55 },
    } },

    -- Bone Shield: Rattlebag encases himself in whirling bones, reducing damage taken by $s1 and inflicting $s2 Shadow damage to enemies that strike him.
    [198] = { SpellID = 198, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 261, SpellID = 198, EffectIndex = 0, Effect = 20, TargetType = 01, Flags = 0x03, Period = 0, Points = -0.6 },
        { ID = 262, SpellID = 198, EffectIndex = 1, Effect = 16, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Lumbering swing: A wild swing that strikes all enemies in melee, dealing $s1 damage.
    [199] = { SpellID = 199, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 263, SpellID = 199, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Stunning Swipe: Lashes out dealing $s1 Nature damage to all enemies in melee, and decreasing their damage by $s2% for one turn.
    [200] = { SpellID = 200, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 264, SpellID = 200, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 265, SpellID = 200, EffectIndex = 1, Effect = 12, TargetType = 15, Flags = 0x00, Period = 1, Points = -0.5 },
    } },

    -- Monstrous Rage: Flies into a frenzy, assaulting all enemies at range, dealing $s1 Nature damage.
    [201] = { SpellID = 201, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 266, SpellID = 201, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Whirling Wall: Attracts the attention of all enemies, focusing their attention on itself.
    [202] = { SpellID = 202, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 267, SpellID = 202, EffectIndex = 0, Effect = 09, TargetType = 07, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Bitting Winds: Deadly winds of anima infused magic tear through all enemies in melee, dealing $s1 Nature damage.
    [203] = { SpellID = 203, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 268, SpellID = 203, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Death Blast: Blasts the closest enemy with $s1 Shadow damage, reducing their damage by $s2% for two turns.
    [204] = { SpellID = 204, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 269, SpellID = 204, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.5 },
        { ID = 270, SpellID = 204, EffectIndex = 1, Effect = 12, TargetType = 03, Flags = 0x00, Period = 2, Points = -0.5 },
    } },

    -- Bone Dust: Necromantic energy pulses forth, healing front line allies for $s1.
    [205] = { SpellID = 205, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 271, SpellID = 205, EffectIndex = 0, Effect = 04, TargetType = 14, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Abominable Kick: Is it a foot? Is it a hoof? Hard to tell, but it hits hard, dealing $s1 damage to the closest enemy.
    [206] = { SpellID = 206, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 272, SpellID = 206, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Feral Lunge: Lunges into their foes with tooth and claw, dealing $s1 damage to all enemies in a line.
    [207] = { SpellID = 207, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 273, SpellID = 207, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Intimidating Roar: Roars out a spine chilling challenge to a random enemy, focusing their attention on itself.
    [208] = { SpellID = 208, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 274, SpellID = 208, EffectIndex = 0, Effect = 09, TargetType = 21, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Ritual Fervor: Inspires a random ally to greater sacrifice. Buffing their damage by $s1% for one turn.
    [209] = { SpellID = 209, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 275, SpellID = 209, EffectIndex = 0, Effect = 12, TargetType = 21, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Waves of Death: Emits a wave of death magic, dealing $s1 Shadow damage to all enemies.
    [210] = { SpellID = 210, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 276, SpellID = 210, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Acidic Ejection: Spits out a stream of toxic material, dealing $s1 Nature damage in a cone emitting from the closest enemy.
    [211] = { SpellID = 211, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 277, SpellID = 211, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Panic Attack: The paniced beast strikes out at a random target, dealing $s1 damage.
    [212] = { SpellID = 212, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 278, SpellID = 212, EffectIndex = 0, Effect = 03, TargetType = 19, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Heal the Flock: The ancient creature emits waves of beneficial spores, healing in a cone from the closest ally for $s1.
    [213] = { SpellID = 213, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 279, SpellID = 213, EffectIndex = 0, Effect = 04, TargetType = 10, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Necrotic Lash: Lashes out with necrotic energy in a cone from the closest enemy, dealing $s1 Shadow damage.
    [214] = { SpellID = 214, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 280, SpellID = 214, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Slime Fist: Strikes out with massive fists, dealing $s1 Nature damage to the closest enemy.
    [215] = { SpellID = 215, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 281, SpellID = 215, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Threatening Hiss: Hisses loudly. Stay away! Prevents itself from being a target for two turns.
    [216] = { SpellID = 216, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 282, SpellID = 216, EffectIndex = 0, Effect = 10, TargetType = 01, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Massacre: Lashes out with Necrotic energy, assaulting all enemies at range, dealing $s1 Shadow damage.
    [217] = { SpellID = 217, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 283, SpellID = 217, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Ritual of Bone: Spins a protective sheath of bone. Mitigating damage taken by $s1% for two turns.
    [218] = { SpellID = 218, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 284, SpellID = 218, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Necrotic Healing: Draws upon death to empower their necrotic energy, healing the closest ally for $s1, and decreases their damage taken by $s2% for two turns.
    [219] = { SpellID = 219, Cooldown = 6, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 285, SpellID = 219, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 286, SpellID = 219, EffectIndex = 1, Effect = 14, TargetType = 02, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Wild Slice: Deadly claws tear through all enemies in melee, dealing $s1 damage.
    [220] = { SpellID = 220, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 287, SpellID = 220, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Burrow: Digs underground, avoiding being targeted for two turns.
    [221] = { SpellID = 221, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 288, SpellID = 221, EffectIndex = 0, Effect = 10, TargetType = 01, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Poisonous Bite: Strikes with poison laden teeth, dealing $s1 Nature damage to the closest enemy, and inflicting $s2 Nature damage over two turns.
    [222] = { SpellID = 222, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 289, SpellID = 222, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
        { ID = 290, SpellID = 222, EffectIndex = 1, Effect = 07, TargetType = 03, Flags = 0x03, Period = 2, Points = 0.3 },
    } },

    -- Wave of Eternal Death: Powerful death magic rolls across the Planes of Torment, causing a stacking damage over time effect to all of your party.
    [223] = { SpellID = 223, Cooldown = 1, Duration = 10, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 291, SpellID = 223, EffectIndex = 0, Effect = 07, TargetType = 23, Flags = 0x01, Period = 1, Points = 0.1 },
    } },

    -- Maw Wrought Slash: Deadly claws tear through all enemies in melee, dealing $s1 damage.
    [224] = { SpellID = 224, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 292, SpellID = 224, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Stream of Anguish: Spews forth a cloud of screams, dealing $s1 Shadow damage in a cone emitting from the closest enemy.
    [225] = { SpellID = 225, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 293, SpellID = 225, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Thrust of the Maw: Lashes out with their spear in a cone from the closest enemy, dealing $s1 shadow damage.
    [226] = { SpellID = 226, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 294, SpellID = 226, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Bombardment of Dread: The Jailer sends a bombardment of missles across Calcis, dealing $s1% of their Health as Shadow damage to a random enemy every turn.
    [227] = { SpellID = 227, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 295, SpellID = 227, EffectIndex = 0, Effect = 03, TargetType = 20, Flags = 0x00, Period = 0, Points = 0.3 },
    } },

    -- Destruction: After ten turns a wave of absolute destruction flows through the The Tremaculum, dealing $s1 damage to your party.
    [228] = { SpellID = 228, Cooldown = 10, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 296, SpellID = 228, EffectIndex = 0, Effect = 03, TargetType = 23, Flags = 0x01, Period = 0, Points = 10 },
    } },

    -- Mawsworn Ritual: Ancient rites and runes protect a random ally, reducing their damage taken by $s1% for two turns.
    [229] = { SpellID = 229, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 297, SpellID = 229, EffectIndex = 0, Effect = 14, TargetType = 21, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Faith in Domination: The Altar of Domination provides a locus of faith for the Mawsworn, healing them for $s1.
    [230] = { SpellID = 230, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 298, SpellID = 230, EffectIndex = 0, Effect = 04, TargetType = 24, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Mawsworn Strength: Intimidates a random enemy, causing them to take $s1% more damage for two turns.
    [231] = { SpellID = 231, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 299, SpellID = 231, EffectIndex = 0, Effect = 14, TargetType = 20, Flags = 0x00, Period = 0, Points = 1 },
    } },

    -- Aura of Death: Focuses a feeling of dread upon a random enemy, reducing their damage done by $s1% for three turns.
    [232] = { SpellID = 232, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 300, SpellID = 232, EffectIndex = 0, Effect = 12, TargetType = 20, Flags = 0x00, Period = 3, Points = -0.5 },
    } },

    -- Teeth of the Maw: Fires a manifestation of pure doom at the closest enemy, dealing $s1 Shadow Damage.
    [233] = { SpellID = 233, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 301, SpellID = 233, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Power of Anguish: Inspires their allies through fear, causing them to do $s1% more damage for two turns.
    [234] = { SpellID = 234, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 302, SpellID = 234, EffectIndex = 0, Effect = 12, TargetType = 21, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Vengence of the Mawsworn: Targets enemies at range, calling down missles of pure maw anima, dealing $s1 Shadow damage.
    [235] = { SpellID = 235, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 303, SpellID = 235, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Empowered Minions: Draws upon the maw itself to empower their allies, decreases their damage taken by $s1% for two turns.
    [236] = { SpellID = 236, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 304, SpellID = 236, EffectIndex = 0, Effect = 14, TargetType = 06, Flags = 0x00, Period = 2, Points = -0.5 },
    } },

    -- Maw Swoop: Sweeps down with precision, slashing deeply at all enemies in melee, dealing $s1 Shadow Damage.
    [237] = { SpellID = 237, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 305, SpellID = 237, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Death Shield: Attracts the attention of all enemies for two turns.
    [238] = { SpellID = 238, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 306, SpellID = 238, EffectIndex = 0, Effect = 09, TargetType = 07, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Beam of Doom: Fires a manifestation of pure doom at enemies at range, dealing $s1 Shadow Damage.
    [239] = { SpellID = 239, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 307, SpellID = 239, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Spear of Dread: Surges into the enemy ranks, dealing $s1 Shadow damage to all enemies in a line.
    [240] = { SpellID = 240, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 308, SpellID = 240, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Pain Spike: A spiral of maw anima surges towards a random enemy, dealing $s1 Shadow damage and reducing their damage done by $s2% for two turns.
    [241] = { SpellID = 241, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 309, SpellID = 241, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
        { ID = 310, SpellID = 241, EffectIndex = 1, Effect = 12, TargetType = 05, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Dark Healing: Heals the closest ally for $s1, and decreases their damage taken by $s2% for two turns.
    [242] = { SpellID = 242, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 311, SpellID = 242, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.5 },
        { ID = 312, SpellID = 242, EffectIndex = 1, Effect = 14, TargetType = 02, Flags = 0x00, Period = 0, Points = 0.75 },
    } },

    -- Baleful Stare: Stares into the Abyss, taunting all enemies and reducing their damage taken by $s2% for two turns.
    [243] = { SpellID = 243, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 313, SpellID = 243, EffectIndex = 0, Effect = 09, TargetType = 07, Flags = 0x01, Period = 0, Points = 0 },
        { ID = 314, SpellID = 243, EffectIndex = 1, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Meatball Mad!: Meatball increases his damage dealt by $s1 and damage taken by $s2 for 2 rounds. Deals $s3 Physical damage to the nearest enemy. This ability does not immediately activate. Meatball MAD!
    [244] = { SpellID = 244, Cooldown = 2, Duration = 2, Flags = 1, SchoolMask = 0x01, Effects = {
        { ID = 315, SpellID = 244, EffectIndex = 0, Effect = 19, TargetType = 01, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 316, SpellID = 244, EffectIndex = 1, Effect = 20, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.3 },
        { ID = 317, SpellID = 244, EffectIndex = 2, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Crusader Strike: Croman deals $s1 Holy damage to the nearest enemy.
    [245] = { SpellID = 245, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 318, SpellID = 245, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Snarling Bite: Strikes the closest adjacent enemy, dealing $s1 Physical damage.
    [246] = { SpellID = 246, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 319, SpellID = 246, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Skymane Strike: Strikes an enemy with its horn, dealing $s1 Holy damage and healing itself for $s2.
    [247] = { SpellID = 247, Cooldown = 4, Duration = 1, Flags = 1, SchoolMask = 0x02, Effects = {
        { ID = 320, SpellID = 247, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.1 },
        { ID = 321, SpellID = 247, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Infectious Soulbite: Bites the closest enemy, dealing $s1 Shadow damage and an additional $s2 Shadow damage each round for 4 rounds.
    [248] = { SpellID = 248, Cooldown = 5, Duration = 4, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 322, SpellID = 248, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
        { ID = 323, SpellID = 248, EffectIndex = 1, Effect = 07, TargetType = 03, Flags = 0x01, Period = 1, Points = 0.15 },
    } },

    -- Shield Bash: Slams the closest enemy in melee with their shield, dealing $s1 damage and reducing their damage by $s2% for one turn.
    [249] = { SpellID = 249, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 324, SpellID = 249, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 325, SpellID = 249, EffectIndex = 1, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Thorned Slingshot: Fires a thorny projectile at the furthest foe, hitting them for $s1 Nature damage.
    [250] = { SpellID = 250, Cooldown = 4, Duration = 0, Flags = 1, SchoolMask = 0x08, Effects = {
        { ID = 326, SpellID = 250, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Doom of the Drust: Lukir uses strange Drust magic to weaken all enemies, reducing their damage done by $s1 for two turns.
    [251] = { SpellID = 251, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 327, SpellID = 251, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 0, Points = -0.2 },
    } },

    -- Viscous Sweep: Sweeps wildly with their Drust Blade, dealing $s1 Shadow damage to all adjacent enemies, and increasing their damage taken by $s2% for two turns.
    [252] = { SpellID = 252, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 328, SpellID = 252, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.6 },
        { ID = 329, SpellID = 252, EffectIndex = 1, Effect = 14, TargetType = 09, Flags = 0x00, Period = 0, Points = 0.25 },
    } },

    -- Drust Claws: Claws at the front rank of enemies, dealing $s1 Shadow damage.
    [253] = { SpellID = 253, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 330, SpellID = 253, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Drust Thorns: Starts on Cooldown. Drust magic forms a sharp edged barrier around all allies, which deals $s1 Nature damage to anyone attacking them for three turns.
    [254] = { SpellID = 254, Cooldown = 3, Duration = 3, Flags = 1, SchoolMask = 0x08, Effects = {
        { ID = 331, SpellID = 254, EffectIndex = 0, Effect = 16, TargetType = 22, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Defense of the Drust: Shields an adjacent friendly target, reducing their damage taken by $s1% for one turn.
    [255] = { SpellID = 255, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 332, SpellID = 255, EffectIndex = 0, Effect = 14, TargetType = 02, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Drust Blast: Fires Drust magic out in a cone attack, dealing $s1 Shadow damage in a cone emitting from the closest enemy.
    [256] = { SpellID = 256, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 333, SpellID = 256, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Dread Roar: The Brute emits a dread roar, chilling enemies to the bone, making them fearful to attack the brute for two turns.
    [257] = { SpellID = 257, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 334, SpellID = 257, EffectIndex = 0, Effect = 10, TargetType = 01, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Dark Gouge: Bites into the closest enemy, dealing $s1 Shadow damage, and causing the target to bleed for $s2 for three turns.
    [258] = { SpellID = 258, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 335, SpellID = 258, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 336, SpellID = 258, EffectIndex = 1, Effect = 07, TargetType = 03, Flags = 0x03, Period = 3, Points = 0.5 },
    } },

    -- Anima Flame: This attack deals $s1 Arcane damage over two turns to the closest enemy.
    [259] = { SpellID = 259, Cooldown = 2, Duration = 3, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 337, SpellID = 259, EffectIndex = 0, Effect = 07, TargetType = 03, Flags = 0x01, Period = 3, Points = 0.3 },
    } },

    -- Anima Burst: A concentrated blast of stolen anima deals $s1 Arcane damage to the furthest enemy.
    [260] = { SpellID = 260, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 338, SpellID = 260, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 3, Points = 1.5 },
    } },

    -- Surgical Advances: Infuses an adjacent ally with increased power, buffing their damage by $s1% for two turns.
    [261] = { SpellID = 261, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 339, SpellID = 261, EffectIndex = 0, Effect = 12, TargetType = 02, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Putrid Stomp: The construct stomps the ground, unleashing a wave of acid that strikes all enemies in melee, dealing $s1 Nature damage.
    [262] = { SpellID = 262, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 340, SpellID = 262, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Acidic Vomit: Spews out an acidic stream in a cone from the closest enemy, dealing $s1 Nature damage.
    [263] = { SpellID = 263, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 341, SpellID = 263, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Meat Hook: Baron Halis lashes out with his hook, damaging the furthest enemy at range with a mighy blast of $s1 damage.
    [264] = { SpellID = 264, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 342, SpellID = 264, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 3 },
    } },

    -- Toxic Claws: Toxic claws tear in a line from the closest enemy, dealing $s1 Nature damage.
    [265] = { SpellID = 265, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 343, SpellID = 265, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Colossal Strike: Genghis strikes down with both arm blades, damaging an adjacent enemy for a colossal $s1 damage.
    [266] = { SpellID = 266, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 344, SpellID = 266, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 10 },
    } },

    -- Acidic Volley: Fires an acidic bolt at the furthest enemy, dealing $s1 Nature damage.
    [267] = { SpellID = 267, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 345, SpellID = 267, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Acidic Spray: Sprays all enemies in melee with a viscous acid, reducing their damage done by $s1% for three turns.
    [268] = { SpellID = 268, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 346, SpellID = 268, EffectIndex = 0, Effect = 12, TargetType = 15, Flags = 0x00, Period = 0, Points = -0.3 },
    } },

    -- Acidic Stomp: The Feaster launches itself in the air, coming down and splashing up a wave of acid that strikes all enemies in melee, dealing $s1 Nature damage.
    [269] = { SpellID = 269, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 347, SpellID = 269, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Spidersong Webbing: Fires out a stream of spidersilk that webs the closest enemy, reducing their damage done by $s1 % for two turns.
    [270] = { SpellID = 270, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 348, SpellID = 270, EffectIndex = 0, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Ambush: Ambushes the furthest enemy at range, damaging them for $s1 Nature damage for three turns.
    [271] = { SpellID = 271, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 349, SpellID = 271, EffectIndex = 0, Effect = 07, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Soulfrost Shard: Fires an icy bolt at the furthest enemy, dealing $s1 Nature damage.
    [272] = { SpellID = 272, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 350, SpellID = 272, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Ritual Curse: Curses an adjacent enemy. Reducing their damage by $s1% for one turn.
    [273] = { SpellID = 273, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 351, SpellID = 273, EffectIndex = 0, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Stomp Flesh: Decadious slams down, sending chunks of Flesh in every direction, striking all enemies in melee, dealing $s1 Nature damage.
    [274] = { SpellID = 274, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 352, SpellID = 274, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Necromantic Infusion: Infuses an adjacent ally with increased power, buffing their damage by $s1% for two turns.
    [275] = { SpellID = 275, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 353, SpellID = 275, EffectIndex = 0, Effect = 12, TargetType = 02, Flags = 0x00, Period = 0, Points = 0.75 },
    } },

    -- Rot Volley: Fires a necromatic bolt at the furthest enemy, dealing $s1 Shadow damage instantly, and a further $s2 Shadow damage over three turns.
    [276] = { SpellID = 276, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 354, SpellID = 276, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.25 },
        { ID = 355, SpellID = 276, EffectIndex = 1, Effect = 07, TargetType = 05, Flags = 0x03, Period = 3, Points = 0.5 },
    } },

    -- Seething Rage: The Stitched Vanguard enrages, boosting their own damage by $s1% for two turns.
    [277] = { SpellID = 277, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 356, SpellID = 277, EffectIndex = 0, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = 1 },
    } },

    -- Memory Displacement: Inspires doubt in the mind of an enemy at range, increasing the damage they take by $s1% for two turns.
    [278] = { SpellID = 278, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 357, SpellID = 278, EffectIndex = 0, Effect = 14, TargetType = 05, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Painful Recollection: Creates an aura of mental anguish that deals $s1 Arcane damage to all enemies at range.
    [279] = { SpellID = 279, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 358, SpellID = 279, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Quills: Fires out a a cascade of razor sharp quills that deal $s1 damage to all enemies in Melee.
    [280] = { SpellID = 280, Cooldown = 6, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 359, SpellID = 280, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 2.5 },
    } },

    -- Anima Spit: Vyrm spits out a concentrated globule of anima, dealing $s1 Arcane damage to the furthest enemy.
    [281] = { SpellID = 281, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 360, SpellID = 281, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 3, Points = 1.5 },
    } },

    -- Charged Javelin: Starts on Cooldown. Aella charges her divine Javelin, damaging an adjacent enemy for a colossal $s1 damage.
    [282] = { SpellID = 282, Cooldown = 5, Duration = 0, Flags = 1, SchoolMask = 0x01, Effects = {
        { ID = 361, SpellID = 282, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 10 },
    } },

    -- Anima Claws: Claws laden with Anima tear in a line from the closest enemy, dealing $s1 Arcane damage.
    [283] = { SpellID = 283, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 362, SpellID = 283, EffectIndex = 0, Effect = 03, TargetType = 13, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Empyreal Reflexes: Releases an aura of anima that infuses its allies with improved reflexes, reducing damage taken by $s1% for one turn.
    [284] = { SpellID = 284, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 363, SpellID = 284, EffectIndex = 0, Effect = 14, TargetType = 22, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Forsworn's Wrath: Starts on Cooldown. Curses all their enemies, causing them to take $s1% extra damage for two turns.
    [285] = { SpellID = 285, Cooldown = 4, Duration = 2, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 364, SpellID = 285, EffectIndex = 0, Effect = 14, TargetType = 07, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- CHARGE!: Commands an adjacent ally to try harder, boosting their damage by $s1% for two turns.
    [286] = { SpellID = 286, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 365, SpellID = 286, EffectIndex = 0, Effect = 12, TargetType = 02, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Elusive Duelist: The footman takes a defensive stance, reducing the damage they take by $s1% for one turn.
    [287] = { SpellID = 287, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 366, SpellID = 287, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Stone Swipe: The Bladewing sweeps down, raking claws of stone across all enemies at range for $s1 Nature damage.
    [288] = { SpellID = 288, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 367, SpellID = 288, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Toxic Bolt: Fires a bolt laced with poison at an enemy at range, causing a damage over time effect for $s1 Shadow damage over three turns.
    [289] = { SpellID = 289, Cooldown = 2, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 368, SpellID = 289, EffectIndex = 0, Effect = 07, TargetType = 05, Flags = 0x03, Period = 3, Points = 1 },
    } },

    -- Ashen Bolt: Launches a bolt of elemental ash, dealing $s1 Arcane damage to the furthest enemy.
    [290] = { SpellID = 290, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 369, SpellID = 290, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 3, Points = 1.5 },
    } },

    -- Ashen Blast: Fires a torrent of elemental ash, dealing $s1 Arcane damage to all enemies in melee.
    [291] = { SpellID = 291, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 370, SpellID = 291, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 3, Points = 1 },
    } },

    -- Master's Surprise: Duelmaster Rowyn uses an ancient bladed technique, striking at the heart of the closest enemy, dealing $s2 damage, and exposing them to $s1% more damage for two turns.
    [292] = { SpellID = 292, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 371, SpellID = 292, EffectIndex = 0, Effect = 14, TargetType = 03, Flags = 0x00, Period = 0, Points = 0.5 },
        { ID = 372, SpellID = 292, EffectIndex = 1, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Stone Crush: The Sinstone hurls a large rock, hitting all enemies in melee for $s1 damage.
    [293] = { SpellID = 293, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 373, SpellID = 293, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Stone Bash: Bashes into the closest enemy, dealing $s1 damage.
    [294] = { SpellID = 294, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 374, SpellID = 294, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Dreadful Exhaust: The closest enemy gets caught in a torrent of released sin, exposing them to $s1% more damage for two turns.
    [295] = { SpellID = 295, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 375, SpellID = 295, EffectIndex = 0, Effect = 14, TargetType = 03, Flags = 0x00, Period = 2, Points = 0.5 },
    } },

    -- Death Bolt: Blasts all enemies at range with $s1 Shadow damage.
    [296] = { SpellID = 296, Cooldown = 3, Duration = 0, Flags = 1, SchoolMask = 0x20, Effects = {
        { ID = 376, SpellID = 296, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Anima Thirst: Draws anima from the furthest enemy, dealing $s1 Shadow damage and healing itself for $s2.
    [297] = { SpellID = 297, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 377, SpellID = 297, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 378, SpellID = 297, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Anima Leech: Bites at a random enemy, dealing $s1 Shadow damage and healing itself for some of the damage.
    [298] = { SpellID = 298, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 379, SpellID = 298, EffectIndex = 0, Effect = 03, TargetType = 21, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 380, SpellID = 298, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Plague Blast: Deals $s1 Shadow damage to the farthest enemy.
    [299] = { SpellID = 299, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 381, SpellID = 299, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Wave of Eternal Death: Powerful death magic rolls across the Planes of Torment, causing a stacking damage over time effect to all of your party.
    [300] = { SpellID = 300, Cooldown = 1, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 383, SpellID = 300, EffectIndex = 0, Effect = 07, TargetType = 23, Flags = 0x01, Period = 1, Points = 0.05 },
    } },

    -- Bombardment of Dread: The Jailer sends a bombardment of missles across Calcis, dealing $s1% of their Health as Shadow damage to a random enemy every turn.
    [301] = { SpellID = 301, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 384, SpellID = 301, EffectIndex = 0, Effect = 03, TargetType = 20, Flags = 0x00, Period = 0, Points = 0.1 },
    } },

    -- Bramble Trap: Winding tendrils ensnare all enemies, dealing $s1 Nature damage and reducing their damage by 20% for this round.
    [302] = { SpellID = 302, Cooldown = 1, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 385, SpellID = 302, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 2, Points = 0.2 },
        { ID = 386, SpellID = 302, EffectIndex = 1, Effect = 12, TargetType = 07, Flags = 0x01, Period = 0, Points = -0.2 },
    } },

    -- Plague Song: Scream at enemies at range, inflicting $s1 Nature damage each round.
    [303] = { SpellID = 303, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 387, SpellID = 303, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Roots of Submission: Roots strike all enemies at range, inflicting $s1 Nature damage.
    [305] = { SpellID = 305, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 411, SpellID = 305, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Arcane Empowerment: Increases the damage of the closest ally by $s1 Arcane and their maximum health by $s2 for 3 rounds.
    [306] = { SpellID = 306, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 412, SpellID = 306, EffectIndex = 0, Effect = 19, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.4 },
        { ID = 413, SpellID = 306, EffectIndex = 1, Effect = 18, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Fist of Nature: Smashes the ground, dealing $s1 Nature damage to enemies in a cone emitting from the closest enemy.
    [307] = { SpellID = 307, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 414, SpellID = 307, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1.6 },
    } },

    -- Spore of Doom: Every 3 rounds, deals $s1 Nature damage to the farthest enemy. This ability does not immediately activate.
    [308] = { SpellID = 308, Cooldown = 3, Duration = 0, Flags = 1, SchoolMask = 0x08, Effects = {
        { ID = 415, SpellID = 308, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 3.5 },
    } },

    -- Threads of Fate: Heals all allies for $s1 Nature and increases their damage by 30% for 1 round.
    [309] = { SpellID = 309, Cooldown = 4, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 416, SpellID = 309, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 417, SpellID = 309, EffectIndex = 1, Effect = 12, TargetType = 06, Flags = 0x00, Period = 0, Points = 0.3 },
    } },

    -- Axe of Determination: Deals $s1 Holy damage to the closest enemy and increases his damage by 20% for 1 round.
    [310] = { SpellID = 310, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 418, SpellID = 310, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1.4 },
        { ID = 419, SpellID = 310, EffectIndex = 1, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.2 },
    } },

    -- Wings of Mending: Heals the closest ally for $s1 and increases their maximum health for $s2 for 2 rounds.
    [311] = { SpellID = 311, Cooldown = 2, Duration = 2, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 420, SpellID = 311, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 1.2 },
        { ID = 421, SpellID = 311, EffectIndex = 1, Effect = 18, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Panoptic Beam: Deals $s1 Holy damage to enemies in a cone emanating from the closest enemy.
    [312] = { SpellID = 312, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 422, SpellID = 312, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1.8 },
    } },

    -- Spirit's Guidance: Heals all allies for $s1 each round.
    [313] = { SpellID = 313, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 423, SpellID = 313, EffectIndex = 0, Effect = 04, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.7 },
    } },

    -- Purifying Light: Heals the closest ally for $s1 and increases their damage by $s2 Holy for 2 rounds.
    [314] = { SpellID = 314, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x02, Effects = {
        { ID = 424, SpellID = 314, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 1.3 },
        { ID = 425, SpellID = 314, EffectIndex = 1, Effect = 19, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Resounding Message: Blasts the furthest enemy for $s1 Fire damage and reduces their damage dealt by 30% for 2 rounds.
    [315] = { SpellID = 315, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 426, SpellID = 315, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
        { ID = 427, SpellID = 315, EffectIndex = 1, Effect = 12, TargetType = 05, Flags = 0x01, Period = 0, Points = -0.3 },
    } },

    -- Self Replication: Deals $s1 Shadow damage to the closest enemy and heals for $s2.
    [316] = { SpellID = 316, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 428, SpellID = 316, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 429, SpellID = 316, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Shocking Fist: Deals $s1 Nature damage to all enemies in melee and increases the damage they take this round by $s2.
    [317] = { SpellID = 317, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 430, SpellID = 317, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 1.5 },
        { ID = 431, SpellID = 317, EffectIndex = 1, Effect = 20, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Inspiring Howl: Increases the damage all allies deal by $s1 Physical for 3 rounds.
    [318] = { SpellID = 318, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 432, SpellID = 318, EffectIndex = 0, Effect = 19, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Shattering Blows: Shatters the armor of enemies in melee range, dealing $s1 Shadow damage and an additional $s2 Shadow damage each round for 3 rounds.
    [319] = { SpellID = 319, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 433, SpellID = 319, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.8 },
        { ID = 434, SpellID = 319, EffectIndex = 1, Effect = 07, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Hailstorm: Blasts all enemies at range with $s1 Frost damage.
    [320] = { SpellID = 320, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 435, SpellID = 320, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Adjustment: Heals the closest ally for $s1.
    [321] = { SpellID = 321, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 436, SpellID = 321, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 2 },
    } },

    -- Balance In All Things: Deals $s1 Shadow damage, heals himself for $s2, and increases his maximum health by $s3 for 1 round.
    [322] = { SpellID = 322, Cooldown = 2, Duration = 1, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 437, SpellID = 322, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.8 },
        { ID = 438, SpellID = 322, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.8 },
        { ID = 439, SpellID = 322, EffectIndex = 2, Effect = 18, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Anima Shatter: Deals $s1 Shadow damage to all enemies at range and reduces the damage they deal by 10% for 2 rounds.
    [323] = { SpellID = 323, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x00, Effects = {
        { ID = 440, SpellID = 323, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.4 },
        { ID = 441, SpellID = 323, EffectIndex = 1, Effect = 12, TargetType = 17, Flags = 0x00, Period = 0, Points = -0.1 },
    } },

    -- Protective Parasol: Heals all adjacent allies for $s1.
    [324] = { SpellID = 324, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 442, SpellID = 324, EffectIndex = 0, Effect = 04, TargetType = 08, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Vision of Beauty: All adjacent allies deal an additional 60% damage for 2 rounds.
    [325] = { SpellID = 325, Cooldown = 3, Duration = 2, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 443, SpellID = 325, EffectIndex = 0, Effect = 12, TargetType = 08, Flags = 0x00, Period = 0, Points = 0.6 },
    } },

    -- Shiftless Smash: Deals $s1 Frost damage to all adjacent enemies.
    [326] = { SpellID = 326, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 453, SpellID = 326, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Inspirational Teachings: Increases the damage of all other allies by $s1 Shadow for 3 rounds.
    [327] = { SpellID = 327, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 454, SpellID = 327, EffectIndex = 0, Effect = 19, TargetType = 22, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Applied Lesson: Deals $s1 Shadow damage to the closest enemy.
    [328] = { SpellID = 328, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x21, Effects = {
        { ID = 455, SpellID = 328, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Muscle Up: Reduces all damage taken by 50% for 3 rounds.
    [329] = { SpellID = 329, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 456, SpellID = 329, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Oversight: Increases damage dealt by $s1 Fire for 2 rounds.
    [330] = { SpellID = 330, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 457, SpellID = 330, EffectIndex = 0, Effect = 19, TargetType = 06, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Supporting Fire: Allies deal an additional $s1 Fire damage.
    [331] = { SpellID = 331, Cooldown = 3, Duration = 3, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 458, SpellID = 331, EffectIndex = 0, Effect = 19, TargetType = 22, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Emptied Mug: Thunk!  Deals $s1 Shadow damage to the furthest enemy.
    [332] = { SpellID = 332, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 459, SpellID = 332, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.5 },
    } },

    -- Overload: Increases damage dealt by $s1 for 3 rounds.
    [333] = { SpellID = 333, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 460, SpellID = 333, EffectIndex = 0, Effect = 19, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Hefty Package: Deals $s1 Shadow Damage to the closest enemy. Oof, packages this heavy are Evil.
    [334] = { SpellID = 334, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 461, SpellID = 334, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.9 },
    } },

    -- Errant Package: Deals $s1 Arcane damage to all enemies at range.
    [335] = { SpellID = 335, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 462, SpellID = 335, EffectIndex = 0, Effect = 03, TargetType = 17, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Evidence of Wrongdoing: Heal an adjacent ally for $s1.
    [336] = { SpellID = 336, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 463, SpellID = 336, EffectIndex = 0, Effect = 04, TargetType = 02, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Wavebender's Tide: Deals $s1 Frost damage to the furthest enemy, and an additional $s2 Frost damage each round for 3 rounds.
    [337] = { SpellID = 337, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x10, Effects = {
        { ID = 464, SpellID = 337, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 2 },
        { ID = 481, SpellID = 337, EffectIndex = 1, Effect = 07, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Scallywag Slash: Deals $s1 Physical damage to the closest enemy.
    [338] = { SpellID = 338, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 465, SpellID = 338, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Cannon Barrage: Deals $s1 Fire damage to all enemies. Does not cast immediately.
    [339] = { SpellID = 339, Cooldown = 3, Duration = 0, Flags = 1, SchoolMask = 0x04, Effects = {
        { ID = 466, SpellID = 339, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Tainted Bite: Deals $s1 Fire damage.
    [340] = { SpellID = 340, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 467, SpellID = 340, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Tainted Bite: Deals $s1 Shadow damage to the furthest enemy and increases their damage taken by $s2 for 3 rounds.
    [341] = { SpellID = 341, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 468, SpellID = 341, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
        { ID = 478, SpellID = 341, EffectIndex = 1, Effect = 20, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Regurgitated Meal: Deals $s1 Nature damage to the closest enemy each round and reduces their damage dealt by $s2 for the next round.
    [342] = { SpellID = 342, Cooldown = 1, Duration = 1, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 469, SpellID = 342, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 477, SpellID = 342, EffectIndex = 1, Effect = 19, TargetType = 03, Flags = 0x01, Period = 0, Points = -0.7 },
    } },

    -- Sharptooth Snarl: Deals $s1 Arcane damage to enemies in melee and increases all damage dealt by 20% for 1 round.
    [343] = { SpellID = 343, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 470, SpellID = 343, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.8 },
        { ID = 476, SpellID = 343, EffectIndex = 1, Effect = 12, TargetType = 01, Flags = 0x00, Period = 0, Points = 0.2 },
    } },

    -- Razorwing Buffet: Smashes all enemies with ice, dealing $s1 Frost damage.
    [344] = { SpellID = 344, Cooldown = 1, Duration = 0, Flags = 0, SchoolMask = 0x04, Effects = {
        { ID = 471, SpellID = 344, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.3 },
    } },

    -- Protective Wings: Modifies the damage all allies take by $s1 for 3 rounds.
    [345] = { SpellID = 345, Cooldown = 4, Duration = 3, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 472, SpellID = 345, EffectIndex = 0, Effect = 20, TargetType = 06, Flags = 0x01, Period = 0, Points = -0.3 },
    } },

    -- Heel Bite: Deals $s1 Nature damage to the closest enemy and reduces their damage by $s2 for 2 rounds.
    [346] = { SpellID = 346, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 473, SpellID = 346, EffectIndex = 0, Effect = 03, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.3 },
        { ID = 475, SpellID = 346, EffectIndex = 1, Effect = 19, TargetType = 03, Flags = 0x01, Period = 0, Points = 0.01 },
    } },

    -- Darkness from Above: Deals $s1 Shadow damage to all enemies in a cone emitting from the closest enemy.
    [347] = { SpellID = 347, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 474, SpellID = 347, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Tainted Bite: Deals $s1 Shadow damage to the furthest enemy and increases their damage taken by $s2 for 3 rounds.
    [348] = { SpellID = 348, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 479, SpellID = 348, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
        { ID = 480, SpellID = 348, EffectIndex = 1, Effect = 20, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.2 },
    } },

    -- Anima Swell: Deals $s1 Arcane damage to all enemies
    [349] = { SpellID = 349, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 482, SpellID = 349, EffectIndex = 0, Effect = 03, TargetType = 07, Flags = 0x01, Period = 0, Points = 0.1 },
    } },

    -- Attack Wave: Deals $s1 Arcane damage to all adjacent enemies.
    [350] = { SpellID = 350, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 483, SpellID = 350, EffectIndex = 0, Effect = 03, TargetType = 09, Flags = 0x01, Period = 0, Points = 0.25 },
    } },

    -- Attack Pulse: Deals a powerful burst of $s1 Arcane damage to an enemy at range. This ability starts on cooldown.
    [351] = { SpellID = 351, Cooldown = 4, Duration = 0, Flags = 1, SchoolMask = 0x40, Effects = {
        { ID = 484, SpellID = 351, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Active Shielding: Activates a shield that prevents $s1% damage for two turns.
    [352] = { SpellID = 352, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 485, SpellID = 352, EffectIndex = 0, Effect = 14, TargetType = 01, Flags = 0x01, Period = 2, Points = 0.3 },
    } },

    -- Disruptive Field: Projects a disruption field that reduces damage done by an enemy at range for $s1% damage for two turns.
    [353] = { SpellID = 353, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 486, SpellID = 353, EffectIndex = 0, Effect = 12, TargetType = 05, Flags = 0x01, Period = 2, Points = 0.2 },
    } },

    -- Energy Blast: Deals a powerful burst of $s1 Arcane damage to all enemies in melee. This ability starts on cooldown.
    [354] = { SpellID = 354, Cooldown = 5, Duration = 0, Flags = 1, SchoolMask = 0x40, Effects = {
        { ID = 487, SpellID = 354, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 4 },
    } },

    -- Mitigation Aura: The Automa projects an aura that disrupts it's opponents. Reducing the damage done by the furthest enemy at range by $s1%.
    [355] = { SpellID = 355, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 488, SpellID = 355, EffectIndex = 0, Effect = 12, TargetType = 05, Flags = 0x00, Period = 0, Points = -0.25 },
    } },

    -- Bone Ambush: Hidden allies shoot bone shards at all enemies at range, dealing $s1 Physical damage.
    [356] = { SpellID = 356, Cooldown = 2, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 489, SpellID = 356, EffectIndex = 0, Effect = 01, TargetType = 05, Flags = 0x01, Period = 3, Points = 2 },
    } },

    -- Mitigation Aura: The Wordleater projects an aura that disrupts it's opponents. Reducing the damage done by the closest enemy by $s1%.
    [357] = { SpellID = 357, Cooldown = 0, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 490, SpellID = 357, EffectIndex = 0, Effect = 12, TargetType = 03, Flags = 0x00, Period = 0, Points = -0.5 },
    } },

    -- Deconstructive Slam: The Worldeater slams the ground, sending out a powerful seismic wave. Dealing $s1 damage to all enemies in melee. This ability starts on cooldown.
    [358] = { SpellID = 358, Cooldown = 5, Duration = 0, Flags = 1, SchoolMask = 0x01, Effects = {
        { ID = 491, SpellID = 358, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 4 },
    } },

    -- Pain Projection: A projection of mental pain that deals  $s1 % Shadow damage for three turns.
    [359] = { SpellID = 359, Cooldown = 5, Duration = 3, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 492, SpellID = 359, EffectIndex = 0, Effect = 07, TargetType = 05, Flags = 0x01, Period = 3, Points = 0.5 },
    } },

    -- Anima Draw: A violent attempt to draw anima directly from their foe, dealing $s1 Arcane damage to all enemies in melee.
    [360] = { SpellID = 360, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 493, SpellID = 360, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Geostorm: Whips up a viscious sandstorm that damages all enemies in melee for $s1 damage.
    [361] = { SpellID = 361, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 494, SpellID = 361, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Anima Stinger: Strikes out with their stinger, dealing $s1 Arcane damage to the furthest enemy.
    [362] = { SpellID = 362, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 495, SpellID = 362, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1.2 },
    } },

    -- Pack Instincts: Lets out a snarling howl, inspiring their pack mates, increasing their damage by $s1% for two turns.
    [363] = { SpellID = 363, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 496, SpellID = 363, EffectIndex = 0, Effect = 12, TargetType = 14, Flags = 0x00, Period = 0, Points = 0.1 },
    } },

    -- Intimidating Presence: The Orb Smasher looms ominously, forcing all enemies to target them for two turns.
    [364] = { SpellID = 364, Cooldown = 6, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 497, SpellID = 364, EffectIndex = 0, Effect = 09, TargetType = 07, Flags = 0x00, Period = 0, Points = 0 },
    } },

    -- Mawsworn Strength: Intimidates the closest enemy, causing them to take $s1% more damage for one turn.
    [365] = { SpellID = 365, Cooldown = 3, Duration = 1, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 498, SpellID = 365, EffectIndex = 0, Effect = 14, TargetType = 03, Flags = 0x00, Period = 0, Points = 0.5 },
    } },

    -- Domination Lash: Lashes out with Domination magic,striking at all enemies in melee for $s1 Shadow Damage.
    [366] = { SpellID = 366, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 499, SpellID = 366, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.5 },
    } },

    -- Domination Thrust: Lashes out with their spear in a cone from the closest enemy, dealing $s1 shadow damage.
    [367] = { SpellID = 367, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 500, SpellID = 367, EffectIndex = 0, Effect = 03, TargetType = 11, Flags = 0x01, Period = 0, Points = 0.75 },
    } },

    -- Domination Bombardment: Targets enemies at range, calling down a storm of Domination magic, dealing $s1 Shadow damage.
    [368] = { SpellID = 368, Cooldown = 3, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 501, SpellID = 368, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 0.6 },
    } },

    -- Power of Domination: Stomps on the ground causing a wave of destructive force to ripple outwards, dealing $s1 damage over two turns to all enemies.
    [369] = { SpellID = 369, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 502, SpellID = 369, EffectIndex = 0, Effect = 07, TargetType = 07, Flags = 0x02, Period = 2, Points = 1 },
    } },

    -- Dominating Presence: Strikes fear in it's opponents, causing them to do $s1% less damage for two turns.
    [370] = { SpellID = 370, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 503, SpellID = 370, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x00, Period = 2, Points = -0.5 },
    } },

    -- Acceleration Field: Releases an aura of anima that infuses its allies with improved reflexes, reducing damage taken by $s1% for two turns.
    [371] = { SpellID = 371, Cooldown = 5, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 504, SpellID = 371, EffectIndex = 0, Effect = 14, TargetType = 22, Flags = 0x00, Period = 0, Points = -0.25 },
    } },

    -- Mace Smash: Makes a powerful swing with their mace, striking all enemies in melee for $s1 damage.
    [372] = { SpellID = 372, Cooldown = 4, Duration = 0, Flags = 0, SchoolMask = 0x01, Effects = {
        { ID = 505, SpellID = 372, EffectIndex = 0, Effect = 03, TargetType = 15, Flags = 0x01, Period = 0, Points = 0.8 },
    } },

    -- Repurpose Anima Flow: Draws anima from the furthest enemy, dealing $s1 Arcane damage and healing itself for $s2.
    [373] = { SpellID = 373, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x40, Effects = {
        { ID = 506, SpellID = 373, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 507, SpellID = 373, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 1 },
    } },

    -- Anima Thirst: Draws anima from the furthest enemy, dealing $s1 Shadow damage and healing itself for $s2.
    [374] = { SpellID = 374, Cooldown = 5, Duration = 0, Flags = 0, SchoolMask = 0x20, Effects = {
        { ID = 508, SpellID = 374, EffectIndex = 0, Effect = 03, TargetType = 05, Flags = 0x01, Period = 0, Points = 1 },
        { ID = 509, SpellID = 374, EffectIndex = 1, Effect = 04, TargetType = 01, Flags = 0x01, Period = 0, Points = 0.4 },
    } },

    -- Tangling Roots: The overgrowth impedes all enemies, reducing their damage by $s1 for two turns.
    [375] = { SpellID = 375, Cooldown = 4, Duration = 2, Flags = 0, SchoolMask = 0x08, Effects = {
        { ID = 510, SpellID = 375, EffectIndex = 0, Effect = 12, TargetType = 07, Flags = 0x01, Period = 0, Points = -0.2 },
    } },
};