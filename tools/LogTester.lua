
local T = { Name = "LogTester" };

-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[0].autoCombatSpells
-- /dump CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex[2].name


-- Init like wow addons
print('Start loading simulator...');

local VM = "CovenantMissionRobot/VM/";

loadfile(VM..'TargetManager.lua')(T.Name, T);
loadfile(VM..'GarrAutoSpell.g.lua')(T.Name, T);
loadfile(VM..'GarrAutoSpell.fix.lua')(T.Name, T);
loadfile(VM..'GarrAutoBoard.lua')(T.Name, T);

loadfile("Logs/VenturePlan_001.lua")(T.Name, T);

print('Simulator has bin loaded!');

T.ApplySpellFixes();

for i, missionLog in ipairs(VP_MissionReports) do
    local id = tostring(missionLog.id);
    --print("LogID", id);
    --if  i < 5 then
    if missionLog.id == '16424213240007' then
        print("");
        print("LogID", id);
        -- autoCombatSpellID, cooldown, duration, hasThornsEffect, name
        local env = nil
        if missionLog.environment and missionLog.environment.autoCombatSpellInfo then
            env = {
                SpellID = missionLog.environment.autoCombatSpellInfo.autoCombatSpellID,
                SpellName = missionLog.environment.autoCombatSpellInfo.name,
                EnvironmentName = missionLog.environment.name
            };
        end

        local units = { };
        for e, follower in pairs(missionLog.followers) do
            follower.followerGUID = e;
            follower.autoCombatSpells = follower.spells;
            table.insert(units, follower);
        end

        for e, encounter in ipairs(missionLog.encounters) do
            table.insert(units, encounter);
        end

        local board = T.GarrAutoBoard:New(missionLog, units, env);

        print("HasRandom: "..(board.HasRandom and "YES" or "NO"))

        local ii = 1;
        board.OnEvent = function(round, event, spell, effectType, boardIndex, targetInfo)

            --targetInfo = false
            if targetInfo then
                for ti, v in ipairs(targetInfo) do

                    local eventInfo = missionLog.log[round] and missionLog.log[round].events[event] or {};
                    local li = eventInfo and eventInfo.targetInfo and eventInfo.targetInfo[ti] or {};

                    local casterIs = eventInfo.casterBoardIndex == boardIndex;
                    local targetIs = li.boardIndex == v.BoardIndex;
                    local pointsIs = (li.points or 0) == (v.Points or 0);
                    local spellIs = eventInfo.spellId == spell.SpellID;

                    local ss = "";
                    if not casterIs then
                        ss = ss..string.format(" caster: %i/%i ", boardIndex, eventInfo.casterBoardIndex or -2);
                    end
                    if not targetIs then
                        ss = ss..string.format(" target: %i/%i ", v.BoardIndex, li.boardIndex or -2);
                    end

                    local pp = "";
                    if not pointsIs then
                        --pp = pp..string.format(" Points: %i/%i ", v.Points or 0, li.points or 0);
                    end

                    if ss ~= "" then
                        ss = "  WARN "..ss;
                    end

                    if pp ~= "" then
                        pp = "  WARN "..pp;
                    end

                    local target = board.Units[v.BoardIndex];
                    local source = board.Units[boardIndex] or board.Environment;
                    if (effectType == "Died") then
                        print(string.format("%03i Round: %02i, Event: %02i, [%i] %s ---> Died! %s", ii, round, event, v.BoardIndex,target.Name, ss));
                    elseif (effectType == "RemoveAura") then
                        print(string.format("%03i Round: %02i, Event: %02i, [%i] %s ---> RemoveAura [%i] %s from [%i] %s  %s",
                        ii, round, event,
                        boardIndex, source and source.Name or "<none>",
                        spell.SpellID, spell.Name,
                        v.BoardIndex, target and target.Name or "<none>",
                        ss));
                    else
                        print(string.format(
                            "%03i Round: %02i, Event: %02i, [%i] %s => [%i] %s ---> [%i] %s (%d = %d + %d) %s %s",
                            ii, round, event,
                            boardIndex,
                            source and source.Name or "<none>",
                            spell.SpellID,
                            spell.Name,
                            v.BoardIndex,
                            target and target.Name or "<none>",
                            v.OldHealth,
                            v.NewHealth,
                            v.Points,
                            ss, pp
                        ));
                    end
                    ii = ii +  1
                end
            end

            local roundInfo = missionLog.log[round];
            roundInfo = false
            if roundInfo then
                local eventInfo = roundInfo.events[event];
                if eventInfo then
                    local sid = spell.SpellID;
                    local c1 = board.Units[boardIndex];
                    local c2 = board.Units[eventInfo.casterBoardIndex];
                    local hl = string.format("Health: [%i]%i / [%i]%i", boardIndex, c1 and c1.CurHP or 0, eventInfo.casterBoardIndex, c2 and c2.CurHP or 0);
                    print(string.format(
                        "%03i Round: %02i, Event: %02i, Caster: %i-%i, Spell: %i-%i %s",
                        ii, round, event,
                        boardIndex, eventInfo.casterBoardIndex,
                        sid, eventInfo.spellID,
                        (boardIndex==eventInfo.casterBoardIndex and sid==eventInfo.spellID) and "" or (" ===>> warn "..hl)
                    ));
                    ii = ii + 1;
                end
            end
            -- print("Event", spellId, effectType, boardIndex, targetInfo);
            --ii = ii + 1;
        end;
        board.OnLog = function(msg, level)
            --print("Log", msg);
        end;

        board:Run();

        --board.IsWin

        for u = 0, 12 do
            local uu = board.Units[u];
            if uu then
                print(string.format("%02i %s %i/%i => %i",
                    u, uu.Name, uu.MaxHP, uu.StartHP, uu.CurHP))
            end
        end

        --break;
    end
end

print('Done!')