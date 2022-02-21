use wow

/* drop tables
drop table [wow].[dbo].[MissionLog]
drop table [MissionLogEnvironment]
drop table [MissionLogUnit]
drop table [MissionLogUnitSpell]
drop table [MissionLogEvent]
drop table [MissionLogEventTarget]
*/

select * from [wow].[dbo].[GarrAutoSpell] where id in (11,15)
select * from [wow].[dbo].[GarrAutoSpellEffect]
select * from [wow].[dbo].[TargetTypes]
select * from [wow].[dbo].[SpellEffectTypes]
select * from [wow].[dbo].[MissionLog] where MissionId in (2253, 2260)
select * from [wow].[dbo].[MissionLogEnvironment]
select * from [wow].[dbo].[MissionLogUnit] where id = 16423565380005
select * from [wow].[dbo].[MissionLogUnitSpell] where id = 16423565380005
select * from [wow].[dbo].[GarrEncounter] where AutoCombatantID > 0 and Name_lang = 'Кроман'
select * from [wow].[dbo].[garrfollower] where AutoCombatantID > 0
select distinct spellid from [wow].[dbo].[MissionLogUnitSpell] where ThornsEffect = 1 order by BoardIndex, [Index]
select * from [wow].[dbo].[MissionLogEvent] where ID = 16423611420003
select * from [wow].[dbo].[MissionLogEventTarget] where ID = 16423611420003

select * from wow.dbo.GarrMission where GarrTypeID = 111 and AutoCombatantEnvCasterID > 0;
select * from wow.dbo.GarrAutoCombatant where id = 212;

select [FileName], count(*) as [Count] from [wow].[dbo].[MissionLog] group by [FileName] 
union all select 'Total', count(*) as [Count] from [wow].[dbo].[MissionLog]
order by [FileName];

select max(targetcount) from [wow].[dbo].[MissionLogEvent];

select EventType, count(*) as [Count] from [wow].[dbo].[MissionLogEvent] Group by EventType order by EventType;
select AuraType, count(*) as [Count] from [wow].[dbo].[MissionLogEvent] Group by AuraType order by AuraType;

select * from [wow].[dbo].[MissionLogEvent] where CasterBoardIndex = -1;

select *
from wow.dbo.GarrMissionXEncounter gme
join wow.dbo.GarrEncounter ge on ge.ID = gme.GarrEncounterID
join wow.dbo.GarrAutoCombatant gac on gac.ID = ge.AutoCombatantID

select Points, count(*) as [Count] from wow.dbo.GarrAutoSpellEffect group by Points order by Points

select *
from [wow].[dbo].MissionLogEvent mle
join [wow].[dbo].[GarrAutoSpellEffect] gase on gase.SpellID = mle.SpellId and gase.EffectIndex = mle.EffectIndex
where gase.Effect = 19

select [Round], count(*) from [wow].[dbo].[MissionLogEvent] group by [Round] order by [Round] desc

--
select * from [wow].[dbo].[MissionLogUnit] where id = 16423611420003
select top 100 * from wow.dbo.MissionLogEvent where SpellId in (109,122)
select distinct Attack from wow.dbo.MissionLogUnit order by Attack

select * from wow.dbo.MissionLogUnitSpell where SpellId in (109,122)

select top 200 * from wow.dbo.MissionLogEvent where id = 16424253600001;-- CasterBoardIndex = -1

-- Combatant Raiting
SELECT
    gac.ID
    , (gac.AttackBase + gac.AttackGainPerLevel*60) as [AutoAttack]
from wow.dbo.GarrAutoCombatant gac
--left join wow.dbo.
order by AutoAttack desc

-- Effect statistic
select Effect
    , (select top 1 Name from wow.dbo.SpellEffectTypes where id = Effect) as [EffectName]
    , count(*) as [Count]
from [wow].[dbo].[GarrAutoSpellEffect]
--where Flags in (1) and Effect in (11,12,13,14,15,16)
group by Effect
order by Effect

-- Spell Info
select 
    SpellId, EffectIndex, gase.ID as [EffectID], Period, Points, Cooldown, Duration,
    gase.Flags as [SpellFlags], case gase.Flags when 1 then 'Use attack for points' when 2 then 'Extra inital period' when 3 then 'All' end [EffectFlagsName], 
    gas.Flags as [EffectFlags], case when gas.Flags = 1 then 'yes' end [StartCooldown],
    Effect, (select top 1 [Name] from [wow].[dbo].[SpellEffectTypes] where id = Effect) as [EffectName],
    TargetType, (select top 1 [Name] from [wow].[dbo].[TargetTypes] where id = TargetType) as [TargetTypeName],
    gas.[Name_lang], gas.[Description_lang]
from [wow].[dbo].[GarrAutoSpell] gas
join [wow].[dbo].[GarrAutoSpellEffect] gase on gase.SpellID = gas.ID
--where gase.TargetType in (19,20)
where gase.Flags in (1) and gase.Effect in (2) and gase.TargetType in (2)
--where gase.Effect in (15,16)
--where SpellId in (343)
--where SpellId in(47,82,90,105,109) -- passive
--where 1=1 and Period=0 and Cooldown=0 and Duration=0 and Effect in (14,12,16)
--where Period=0 and Cooldown=0
--where gase.Effect = 16
order by SpellId, EffectIndex

-- Statistic
select ml.MissionId, ml.MissionName, count(*) as [Count]
, sum(case when ml.Winner = 1 then 1 end) as [Win]
, sum(case when ml.Winner = 0 then 1 else 0 end) as [Defeet]
, env.SpellId as [EnvSpell], (select top 1 [Name_lang] from wow.dbo.GarrAutoSpell where id = env.SpellId) as [EnvSpellName]
from [wow].[dbo].[MissionLog] ml
outer apply (
    select top 1 *
    from [wow].[dbo].[MissionLogEnvironment] where MissionId = ml.MissionId
) env
group by ml.MissionId, ml.MissionName, env.SpellId
order by [Count]

-- Combatant info
select ID
    , HealthBase, HealthGainPerLevel, HealthBase + (HealthGainPerLevel*60) as [Health60]
    , AttackBase, AttackGainPerLevel, AttackBase + (AttackGainPerLevel*60) as [Attack60]
    , AttackSpellID,   (select top 1 [Name_lang] from wow.dbo.GarrAutoSpell where ID = AttackSpellID)   as [AttackSpellName]
    , AbilitySpellID,  (select top 1 [Name_lang] from wow.dbo.GarrAutoSpell where ID = AbilitySpellID)  as [AbilitySpellName]
    , AbilitySpellID2, (select top 1 [Name_lang] from wow.dbo.GarrAutoSpell where ID = AbilitySpellID2) as [AbilitySpellName2]
    , PassiveSpellID,  (select top 1 [Name_lang] from wow.dbo.GarrAutoSpell where ID = PassiveSpellID)  as [PassiveSpellName]
    , [role], case [role]
        when 0 then 'None'
        when 1 then 'Melee'
        when 2 then 'Ranged/Physical'
        when 3 then 'Ranged/Magic'
        when 4 then 'Heal/Support'
        when 5 then 'Tank'
    end as [RoleName]
from wow.dbo.GarrAutoCombatant
where AttackSpellID in (109,122) or AbilitySpellID in (109,122) or AbilitySpellID2 in (109,122) or PassiveSpellID in (109,122)

select * from wow.dbo.MissionLogUnit where id = 16423565350002

-- Fight info
select top 1000 mle.[Round], mle.[Event]
    , mle.EffectIndex as [EI]
    , '['+cast(se.Effect as varchar)+'] '+isnull((select top 1 [Name] from wow.dbo.SpellEffectTypes where id = se.Effect), '<none>') as [Effect]
    , '['+cast(se.TargetType as varchar)+'] '+isnull((select top 1 [Name] from wow.dbo.TargetTypes where id = se.TargetType), '<none>') as [TargetType]    
    , case mle.EventType when 0 then 'MeleeDamage' when 1 then 'RangeDamage' when 2 then 'SpellMeleeDamage' when 3 then 'SpellRangeDamage' when 4 then 'Heal' when 5 then 'PeriodicDamage' when 6 then 'PeriodicHeal' when 7 then 'ApplyAura' when 8 then 'RemoveAura' when 9 then '--Died--' end as [EventType]
    , mle.AuraType
    --, mle.SchoolMask
    , '['+cast(mle.CasterBoardIndex as varchar)+'] '+isnull((select top 1 [Name] from [wow].[dbo].[MissionLogUnit] where ID = mle.ID and BoardIndex = mle.CasterBoardIndex), '<none>') as [Caster]     
    , '['+cast(mle.SpellId as varchar)+'] '+isnull((select top 1 [Name_lang] from [wow].[dbo].[GarrAutoSpell] where ID = mle.SpellId), '<none>') as [Spell]
    , '['+cast(mlet.BoardIndex as varchar)+'] '+isnull((select top 1 [Name] from [wow].[dbo].[MissionLogUnit] where ID = mle.ID and BoardIndex = mlet.BoardIndex), '<none>') as [Target]    
    , mlet.OldHealth, mlet.NewHealth, mlet.Points, mlet.MaxHealth
    , mle.ID
from [wow].[dbo].[MissionLogEvent] mle
join [wow].[dbo].[MissionLogEventTarget] mlet on mlet.ID = mle.ID and mlet.Event = mle.Event and mlet.[Round] = mle.[Round]
left join [wow].[dbo].GarrAutoSpellEffect se on se.SpellID = mle.SpellId and se.EffectIndex = mle.EffectIndex
where mle.ID = 16423565350002-- /*16423565350002 --*/16424245350005-- and CasterBoardIndex = 0
    --and mlet.BoardIndex = 4
--where CasterBoardIndex = -1
order by mle.ID, [Round], [Event], [EI], mlet.BoardIndex

-- Fight result
SELECT
    mlu.BoardIndex, mlu.Name,
    mlu.MaxHealth, mlu.Health,
    isnull(
    (select top 1 t.NewHealth from wow.dbo.MissionLogEventTarget t 
    where t.ID = mlu.id and t.BoardIndex = mlu.BoardIndex 
    order by [Round] desc, [Event] desc, [Index] desc)
    , mlu.Health) as CurrentHP
from wow.dbo.MissionLogUnit mlu
where id = 16423565370004

select * from wow.dbo.MissionLogEventTarget t where t.ID = 16423565370004 and t.BoardIndex = 4 order by [Round] desc, [Event] desc, [Index] desc

select * from wow.dbo.MissionLog where id = 16424253600001
select * from wow.dbo.MissionLogEnvironment where MissionId = 2253
select * from wow.dbo.MissionLogUnit where id = 16424253600001
select top 10 * from wow.dbo.MissionLogEvent where CasterBoardIndex = -1 

-- AutoAttack for encounters
select '['+right('0'+cast(gme.BoardIndex as varchar),2) + '] = { ' + string_agg('['+cast(gme.GarrMissionID as varchar), ']=M,')+ ']=M },'
from wow.dbo.GarrMissionXEncounter gme 
join wow.dbo.GarrEncounter ge on ge.ID = gme.GarrEncounterID
join wow.dbo.GarrAutoCombatant gac on gac.id = ge.AutoCombatantID
where gac.AttackSpellID = 11 and gac.Role in (0,2,3,4)
--where gac.AttackSpellID = 15 and gac.Role in (1,5)
group by gme.BoardIndex
order by gme.BoardIndex

-- AutoAttack for followers
select distinct gac.AbilitySpellID, '['+cast(gac.AbilitySpellID as varchar)+']=M' [El]
from wow.dbo.GarrAutoCombatant gac
join wow.dbo.garrfollower gf on gf.AutoCombatantID = gac.ID
where gac.AttackSpellID = 11 and gac.Role in (0,2,3,4)
--group by gac.AbilitySpellID
order by gac.AbilitySpellID

-- todo: try to get target priority by EffectTargetType
select distinct CasterBoardIndex, mlet.BoardIndex
from [wow].[dbo].[MissionLogEvent] mle
join [wow].[dbo].[MissionLogEventTarget] mlet on mlet.ID = mle.ID and mlet.[Event] = mle.[Event] and mlet.[Round] = mle.[Round]
join [wow].[dbo].[GarrAutoSpellEffect] gase on gase.SpellID = mle.SpellId and gase.EffectIndex = mle.EffectIndex
where gase.TargetType = 1
order by CasterBoardIndex, mlet.BoardIndex

-- Broken spells
declare @s table(id int)
insert into @s select distinct spellid from wow.dbo.MissionLogEvent 
select spellid, count(*) from wow.dbo.MissionLogUnitSpell where spellid not in (select id from @s) group by spellid order by SpellId

-- 2307
select distinct * from wow.dbo.MissionLogUnit where id = 16424213170001;-- MissionId = 2307
select distinct * from wow.dbo.MissionLogUnitSpell where SpellId = 122