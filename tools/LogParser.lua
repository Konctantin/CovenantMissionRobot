
local function writeSchema(file)
file:write([[IF DB_ID('wow') IS NULL
    CREATE DATABASE [wow];
GO

USE [wow]
GO

]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLog]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLog] (
    [ID]            bigint       not null primary key,
    [MissionId]     int          not null,
    [MissionName]   varchar(200) not null,
    [MissionScalar] tinyint      not null,
    [Winner]        tinyint      not null,
    [FileName]      varchar(200)     null
)
]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLogEnvironment]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLogEnvironment] (
    [MissionId]     int          not null primary key,
    [SpellId]       int          not null,
    [Cooldown]      tinyint      not null,
    [Duration]      tinyint      not null,
    [ThornsEffect]  tinyint      not null,
    [Name]          varchar(200) not null,
    [Description]   varchar(2000)not null
)
]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLogUnit]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLogUnit] (
    [ID]          bigint       not null,
    [MissionId]   int          not null,
    [BoardIndex]  tinyint      not null, -- [0-4]-slaves, [5-12]-enemies
    [Attack]      smallint     not null,
    [Health]      smallint     not null,
    [MaxHP]   smallint     not null, -- only slaves
    [IsElite]     tinyint      not null, -- only enemies
    [Level]       tinyint      not null, -- only slaves
    [Role]        tinyint      not null,
    [Name]        varchar(200) not null,
    CONSTRAINT PK_MissionLogUnit PRIMARY KEY NONCLUSTERED ([ID], [BoardIndex])
)
]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLogUnitSpell]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLogUnitSpell] (
    [ID]            bigint       not null,
    [MissionId]     int          not null,
    [BoardIndex]    tinyint      not null, -- [0-4]-slaves, [5-12]-enemies
    [Index]         tinyint      not null, -- 0-AutoAttack
    [SpellId]       int          not null,
    [Cooldown]      tinyint      not null,
    [Duration]      tinyint      not null,
    [ThornsEffect]  tinyint      not null,
    [PreviewMask]   int          not null,
    [SchoolMask]    int          not null,
    [TutorialFlag]  int          not null,
    [Name]          varchar(200) not null,
    [Description]   varchar(2000)not null,
    CONSTRAINT PK_MissionLogUnitSpell PRIMARY KEY NONCLUSTERED ([ID], [BoardIndex], [Index])
)
]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLogEvent]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLogEvent] (
    [ID]               bigint   not null,
    [MissionId]        int      not null,
    [Round]            smallint not null, -- round index
    [Event]            smallint not null, -- event index
    [EventType]        tinyint  not null,
    [AuraType]         tinyint  not null,
    [CasterBoardIndex] int      not null, -- [0-4]-slaves, [5-12]-enemies, -1 = environment [wow].[dbo].[MissionLogEnvironment]
    [SpellId]          int      not null,
    [EffectIndex]      tinyint  not null,
    [SchoolMask]       int      not null,
    [TargetCount]      tinyint  not null,
    CONSTRAINT PK_MissionLogEvent PRIMARY KEY NONCLUSTERED ([ID], [Round], [Event])
)
]]);

file:write([[IF OBJECT_ID('[wow].[dbo].[MissionLogEventTarget]', 'U') IS NULL
CREATE TABLE [wow].[dbo].[MissionLogEventTarget] (
    [ID]         bigint   not null,
    [MissionId]  int      not null,
    [Round]      smallint not null, -- round index
    [Event]      smallint not null, -- event index
    [Index]      tinyint  not null, -- for checking and sorting
    [BoardIndex] tinyint  not null, -- [0-4]-slaves, [5-12]-enemies
    [MaxHP]  smallint not null,
    [NewHealth]  smallint not null,
    [OldHealth]  smallint not null,
    [Points]     smallint not null,
    CONSTRAINT PK_MissionLogEventTarget PRIMARY KEY NONCLUSTERED ([ID], [Round], [Event], [BoardIndex])
)
]]);
end

local function quoteStr(str) return string.gsub(str, "\'", "''") end

local function parseLog(file, fileName)
    assert(type(VP_MissionReports)=="table", "Could not retrieve table 'VP_MissionReports'!");
    for i, missionLog in ipairs(VP_MissionReports) do
        local id = tostring(missionLog.id);
        local mid = missionLog.missionID;

        print(id, mid, missionLog.missionName, missionLog.missionScalar, missionLog.winner);

        -- header
        file:write(string.format("DELETE FROM [wow].[dbo].[MissionLog] WHERE ID = %s;\n", id));
        file:write(string.format("DELETE FROM [wow].[dbo].[MissionLogUnit] WHERE ID = %s;\n", id));
        file:write(string.format("DELETE FROM [wow].[dbo].[MissionLogUnitSpell] WHERE ID = %s;\n", id));
        file:write(string.format("DELETE FROM [wow].[dbo].[MissionLogEvent] WHERE ID = %s;\n", id));
        file:write(string.format("DELETE FROM [wow].[dbo].[MissionLogEventTarget] WHERE ID = %s;\n", id));

        file:write(string.format("INSERT INTO [wow].[dbo].[MissionLog] VALUES (%s, %i, \'%s\', %d, %i, \'%s\');\n",
            id, mid, quoteStr(missionLog.missionName), missionLog.missionScalar, missionLog.winner and 1 or 0, fileName));

        -- environment
        if missionLog.environment and missionLog.environment.autoCombatSpellInfo then
            local env = missionLog.environment.autoCombatSpellInfo;
            file:write(string.format("DELETE FROM [wow].[dbo].[MissionLogEnvironment] WHERE MissionId = %i;", mid));
            file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogEnvironment] VALUES (%i, %i, %i, %i, %i, \'%s\', \'%s\');\n",
                mid, env.autoCombatSpellID, env.cooldown, env.duration, env.hasThornsEffect and 1 or 0,
                quoteStr(missionLog.environment.name), quoteStr(env.description)));
        end

        -- enemies
        for e, encounter in ipairs(missionLog.encounters) do
            file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogUnit] VALUES (%s, %i, %i, %d, %i, %i, %i, %i, %i, \'%s\');\n",
            id, mid, encounter.boardIndex, encounter.attack, encounter.health, encounter.health,
            encounter.isElite and 1 or 0, 0, encounter.role, quoteStr(encounter.name)));

            local a = encounter.autoCombatAutoAttack;
            file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogUnitSpell] VALUES (%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, \'%s\', \'%s\');\n",
                id, mid, encounter.boardIndex, 0, a.autoCombatSpellID, a.cooldown, a.duration, a.hasThornsEffect and 1 or 0,
                a.previewMask, a.schoolMask, a.spellTutorialFlag, quoteStr(a.name), quoteStr(a.description)));

            for es, spell in ipairs(encounter.autoCombatSpells) do
                file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogUnitSpell] VALUES (%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, \'%s\', \'%s\');\n",
                    id, mid, encounter.boardIndex, es, spell.autoCombatSpellID, spell.cooldown, spell.duration,
                    spell.hasThornsEffect and 1 or 0, 0, 0, 0, quoteStr(spell.name), quoteStr(spell.description)));
            end
        end

        -- followers
        for e, follower in pairs(missionLog.followers) do
            file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogUnit] VALUES (%s, %i, %i, %d, %i, %i, %i, %i, %i, \'%s\');\n",
                id, mid, follower.boardIndex, follower.attack, follower.health, follower.maxHealth, 0, follower.level, follower.role,
                quoteStr(follower.name)));
            for es, spell in ipairs(follower.spells) do
                file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogUnitSpell] VALUES (%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i, \'%s\', \'%s\');\n",
                    id, mid, follower.boardIndex, es, spell.autoCombatSpellID, spell.cooldown, spell.duration,
                    spell.hasThornsEffect and 1 or 0, 0, 0, 0, quoteStr(spell.name), quoteStr(spell.description)));
            end
        end

        -- log events
        for l, log in ipairs(missionLog.log) do
            for e, event in ipairs(log.events) do
                file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogEvent] VALUES (%s, %i, %i, %i, %i, %i, %i, %i, %i, %i, %i);\n",
                    id, mid, l, e, event.type, event.auraType, event.casterBoardIndex, event.spellID, event.effectIndex,
                    event.schoolMask, #event.targetInfo));

                for t, tinfo in ipairs(event.targetInfo) do
                    file:write(string.format("INSERT INTO [wow].[dbo].[MissionLogEventTarget] VALUES (%s, %i, %i, %i, %i, %i, %i, %i, %i, %d);\n",
                    id, mid, l, e, t, tinfo.boardIndex, tinfo.maxHealth, tinfo.newHealth, tinfo.oldHealth, tinfo.points or 0));
                end
            end
        end

        file:write("\n");
        file:flush();
    end
end

local function fileExists(name)
    local f = io.open(name, "r");
    if f then io.close(f) end
    return f ~= nil;
end

for i = 1, 20 do
    local v = string.format("%03i", i);
    local fname = "Logs/VenturePlan_"..v..".lua";
    if fileExists(fname) then

        -- load log
        loadfile(fname)();

        local file = io.open("Logs/MissionLogs_"..v..".sql", "w");
        writeSchema(file);
        file:write("\n");
        parseLog(file, fname);

        file:flush();
        file:close();
    else
        print("File not exists", fname);
    end
end

print("Done!");