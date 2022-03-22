local _, T = ...;

T.LogEventTypes = {
    [0] = "MeleeDamage",
    [1] = "RangeDamage",
    [2] = "SpellMeleeDamage",
    [3] = "SpellRangeDamage",
    [4] = "Heal",
    [5] = "PeriodicDamage",
    [6] = "PeriodicHeal",
    [7] = "ApplyAura",
    [8] = "RemoveAura",
    [9] = "Died",
};

T.SchoolMask = {
    [01] = "Physical",
    [02] = "Holly",
    [04] = "Fire",
    [08] = "Nature",
    [16] = "Frost",
    [32] = "Shadow",
    [64] = "Arcane"
};

local function CompareTypes(t1,t2)
    return (t1==t2) or (t1 >=0 and t1 <= 3) and (t2 >= 0 and t2 <= 3);
end

local function PrintComparedLogs(sim, log, onlyFails)
    local n = 1;
    for r = 1, math.min(#sim, #log) do
        print(string.format("Round: %i", r))
        local events1 = sim[r].events;
        local events2 = log[r].events;
        for e = 1, math.min(#events1, #events2) do
            local event1 = events1[e];
            local event2 = events2[e];

            local targetInfo1 = event1.targetInfo;
            local targetInfo2 = event2.targetInfo;
            local cnt = math.min(#targetInfo1, #targetInfo2);
            if cnt == 0 then
                local c =
                (event1.casterBoardIndex == event2.casterBoardIndex) and
                (event1.spellID == event2.spellID) and
                CompareTypes(event1.type, event2.type);

                print(string.format(
                    "%03i %03i %02i Caster: %02i/%02i Spell: %03i/%03i Effect: %i/%i Type: %i/%i %s",
                    n, r, e,
                    event1.casterBoardIndex, event2.casterBoardIndex,
                    event1.spellID, event2.spellID,
                    event2.effectIndex or -1, event2.effectIndex, -- todo: fix it
                    event1.type, event2.type,
                    c and "" or " > FAIL! "..tostring(#targetInfo1).."/"..tostring(#targetInfo2)
                    ));
                n=n+1;
            else
                for t = 1, math.min(#targetInfo1, #targetInfo2) do
                    local target1 = targetInfo1[t];
                    local target2 = targetInfo2[t];

                    local c =
                    (event1.casterBoardIndex == event2.casterBoardIndex) and
                    (event1.spellID == event2.spellID) and
                    --(event2.effectIndex or -1 == event2.effectIndex) and -- todo: fix it
                    CompareTypes(event1.type, event2.type) and
                    (target1.BoardIndex == target2.boardIndex) and
                    (target1.OldHP == target2.oldHealth) and
                    (target1.NewHP == target2.newHealth) and
                    (target1.Points == target2.points or 0);

                    local pdiff = target1.Points - (target2.points or 0);

                    if not c or not onlyFails then
                        print(string.format(
                            "%03i %03i %02i Caster: %02i/%02i Spell: %03i/%03i Effect: %i/%i Type: %i/%i -> Target: %02i/%02i, Old: %05i/%05i, New: %05i/%05i, Points: %05i/%05i %s",
                            n, r, e,
                            event1.casterBoardIndex, event2.casterBoardIndex,
                            event1.spellID, event2.spellID,
                            event2.effectIndex or -1, event2.effectIndex, -- todo: fix it
                            event1.type, event2.type,
                            target1.BoardIndex, target2.boardIndex,
                            target1.OldHP, target2.oldHealth,
                            target1.NewHP, target2.newHealth,
                            target1.Points, target2.points or 0,
                            c and "" or " > FAIL! "..tostring(pdiff)
                            ));
                    end
                    n=n+1;
                end
            end
        end
    end
end

local function getSpellInfo(spellid)
    local spellInfo = T.GARR_AUTO_SPELL[spellid or 0];
    return spellid or 0, spellInfo and spellInfo.NameDef or "";
end

local function getUnitInfo(inf, idx)
    local unit = inf.Board[idx or -2];
    return idx or -2, unit and unit.Name or "";
end

local function getEventInfo(type)
    return type or -1, T.LogEventTypes[type or -1] or "";
end

local function DumpComparedLogsToCsv(simulation, log)
    local fname = string.format("test/%s.csv", simulation.MissionID);
    local file = io.open(fname, "w");

    file:write("N;Round;Event;Caster1;CasterName1;Caster2;CasterName2;Spell1;SpellName1;Spell2;SpellName2;"
        .."Eff1;Eff2;EType1;ETypeName1;EType2;ETypeName2;Target1;TargetName1;Target2;TargetName2;OldHP1;OldHP2;NewHP1;NewHP2;Points1;Points2\n");

    local fmtStr = "%i;%i;%i;%i;%s;%i;%s;%i;%s;%i;%s;"
        .."%i;%i;%i;%s;%i;%s;%i;%s;%i;%s;%i;%i;%i;%i;%i;%i\n";

    local sim = simulation.Log;

    local n = 1;
    for r = 1, math.min(#sim, #log) do
        local events1 = sim[r].events;
        local events2 = log[r].events;
        for e = 1, math.min(#events1, #events2) do
            local event1 = events1[e];
            local event2 = events2[e];

            local targetInfo1 = event1.targetInfo;
            local targetInfo2 = event2.targetInfo;
            for t = 1, math.min(#targetInfo1, #targetInfo2) do
                local target1 = targetInfo1[t];
                local target2 = targetInfo2[t];

                local cid1, sname1 = getUnitInfo(simulation, event1.casterBoardIndex);
                local cid2, sname2 = getUnitInfo(simulation, event2.casterBoardIndex);
                local spid1, spName1 = getSpellInfo(event1.spellID);
                local spid2, spName2 = getSpellInfo(event2.spellID);
                local ev1, evName1 = getEventInfo(event1.type);
                local ev2, evName2 = getEventInfo(event2.type);
                local tid1, tname1 = getUnitInfo(simulation, target1.BoardIndex);
                local tid2, tname2 = getUnitInfo(simulation, target2.boardIndex);

                file:write(string.format(fmtStr,
                    n, r, e,
                    cid1, sname1,
                    cid2, sname2,
                    spid1, spName1 ,
                    spid2, spName2,
                    event1.effectIndex or -1,
                    event2.effectIndex or -1,
                    ev1, evName1,
                    ev2, evName2,
                    tid1, tname1,
                    tid2, tname2,
                    target1.OldHP or 0, target2.oldHealth or 0,
                    target1.NewHP or 0, target2.newHealth or 0,
                    target1.Points or 0, target2.points or 0
                ));
                n=n+1;
            end
        end
    end
    file:flush();
    file:close();
end

T.PrintComparedLogs = PrintComparedLogs;
T.DumpComparedLogsToCsv = DumpComparedLogsToCsv;
