local _, T = ...;

local Events = { };
local MainFrame = CreateFrame("Frame");

T.L = function(text)
    return T.Translate and T.Translate[text] or text;
end

local function HookShowMission(...)
    T.ShowInfoFrame();
    return ...;
end

local function HookCloseMission(...)
    collectgarbage("collect");
    return ...;
end

local function RegisterHooks()
    hooksecurefunc(CovenantMissionFrame, "InitiateMissionCompletion", HookShowMission);
    hooksecurefunc(CovenantMissionFrame, "UpdateAllyPower", HookShowMission);

    hooksecurefunc(CovenantMissionFrame, "CloseMission", HookCloseMission);
    hooksecurefunc(CovenantMissionFrame, "CloseMissionComplete", HookCloseMission);
    hooksecurefunc(CovenantMissionFrame, "Hide", HookCloseMission);
end

function Events.ADDON_LOADED(addon)
    if addon == "Blizzard_GarrisonUI" then
        if not MainFrame.IsLoaded then
            T.ApplySpellFixes();
            RegisterHooks();
            MainFrame.IsLoaded = true;
        end
    end
end

function Events.GARRISON_MISSION_COMPLETE_RESPONSE(missionID, canComplete, success, bonusRollSuccess, followerDeaths, autoCombatResult)
    if not (missionID and C_Garrison.GetFollowerTypeByMissionID(missionID) == 123) then
        return;
    end

    if not (autoCombatResult and autoCombatResult.combatLog) then
        return;
    end

    -- todo: make settings
    T.SaveCombatLog(missionID, canComplete, success, bonusRollSuccess, followerDeaths, autoCombatResult);
end

function Events.GARRISON_MISSION_FINISHED(followerTypeID, missionID)
    --
end

function Events.GARRISON_MISSION_LIST_UPDATE(garrFollowerTypeID)
    --
end

function Events.GARRISON_MISSION_NPC_CLOSED()
    --
end

function Events.GARRISON_MISSION_NPC_OPENED(followerTypeID)
    --
end

local function ProcessEvents(_, event, ...)
    if Events[event] then
        --print(event);
        Events[event](...);
    end
end

MainFrame:RegisterEvent("ADDON_LOADED");
MainFrame:RegisterEvent("GARRISON_MISSION_COMPLETE_RESPONSE");
MainFrame:RegisterEvent("GARRISON_MISSION_FINISHED");
MainFrame:RegisterEvent("GARRISON_MISSION_LIST_UPDATE");
MainFrame:RegisterEvent("GARRISON_MISSION_NPC_CLOSED");
MainFrame:RegisterEvent("GARRISON_MISSION_NPC_OPENED");
MainFrame:SetScript("OnEvent", ProcessEvents);
MainFrame:Show();

T.MainFrame = MainFrame;
