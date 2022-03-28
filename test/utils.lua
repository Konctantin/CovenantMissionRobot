local _, T = ...;

local blzEventType = {
    [0] = "DMG",
    [1] = "DMG",
    [2] = "DMG",
    [3] = "DMG",
    [4] = "HEL",
    [5] = "DOT",
    [6] = "HOT",
    [7] = "APL",
    [8] = "REM",
    [9] = "Die",
};

local lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str);
end

local rpad = function(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str;
end

local function CompareTypes(t1,t2)
    return (t1==t2) or (t1 >=0 and t1 <= 3) and (t2 >= 0 and t2 <= 3);
end

local function PrintComparedLogs(sim, log)
    for r = 1, math.min(#sim, #log) do
        print(string.format("Round: %i", r))
        local events1 = sim[r] and sim[r].events or {};
        local events2 = log[r] and log[r].events or {};

        for e = 1, math.max(#events1, #events2) do
            local event1 = events1[e] or {};
            local event2 = events2[e] or {};

            local targetInfo1 = event1.targetInfo or {};
            local targetInfo2 = event2.targetInfo or {};
            local cnt = math.max(#targetInfo1, #targetInfo2);

            local casterOk = event1.casterBoardIndex == event2.casterBoardIndex
                and event1.spellID == event2.spellID
                and event2.effectIndex == event2.effectIndex
                and CompareTypes(event1.type, event2.type);

            local casterInf = string.format(
                "%03i %02i Caster: %02i/%02i Spell: %03i/%03i Effect: %i/%i Type: %s/%s",
                r, e,
                event1.casterBoardIndex or -2,
                event2.casterBoardIndex or -2,
                event1.spellID or 0,
                event2.spellID or 0,
                event1.effectIndex or -1,
                event2.effectIndex or -1,
                blzEventType[event1.type] or "   ",
                blzEventType[event2.type] or "   "
                );

            if cnt == 0 then
                print(casterInf, (casterOk and "" or ">>> FAIL!"));
            end

            for t = 1, math.max(#targetInfo1, #targetInfo2) do
                local target1 = targetInfo1[t] or {};
                local target2 = targetInfo2[t] or {};

                local targetOk = target1.BoardIndex == target2.boardIndex
                    and target1.OldHP == target2.oldHealth
                    and target1.NewHP == target2.newHealth
                    and (target1.Points or 0) == (target2.points or 0);

                local targetInf = string.format(" -> Target: %02i/%02i, Old: %s/%s, New: %s/%s, Points: %s/%s",
                    target1.BoardIndex or -2,
                    target2.boardIndex or -2,
                    rpad(tostring(target1.OldHP or 0), 5),
                    rpad(tostring(target2.oldHealth or 0), 5),
                    rpad(tostring(target1.NewHP or 0), 5),
                    rpad(tostring(target2.newHealth or 0), 5),
                    rpad(tostring(target1.Points or 0), 4),
                    rpad(tostring(target2.points or 0), 4)
                );

                print(casterInf..targetInf, ((casterOk and targetOk) and "" or ">>> FAIL!"))
            end
        end
    end
end

T.PrintComparedLogs = PrintComparedLogs;
