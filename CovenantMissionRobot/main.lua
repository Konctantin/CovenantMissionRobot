local addonName, T = ...;
_G[addonName] = T; -- make it public

local Events = { };
local frame = CreateFrame("Frame");

T.L = function(text)
    return T.Translate and T.Translate[text] or text;
end

local function HookShowMission(...)
    T.ShowInfoFrame();
    return ...;
end

local function HookShowFollower(...)
    T.InitFollowerHelper();
    return ...;
end

local function HookCloseMission(...)
    collectgarbage("collect");
    return ...;
end

local function RegisterHooks()
    hooksecurefunc(CovenantMissionFrame, "InitiateMissionCompletion", HookShowMission);
    hooksecurefunc(CovenantMissionFrame, "UpdateAllyPower", HookShowMission);
    hooksecurefunc(CovenantMissionFrame.FollowerTab, "ShowFollower", HookShowFollower);
    --hooksecurefunc(C_Garrison, "AddFollowerToMission", HookShowMission);

    hooksecurefunc(CovenantMissionFrame, "CloseMission", HookCloseMission);
    hooksecurefunc(CovenantMissionFrame, "CloseMissionComplete", HookCloseMission);
    hooksecurefunc(CovenantMissionFrame, "Hide", HookCloseMission);
end

function Events.ADDON_LOADED(addon)
    if addon == "Blizzard_GarrisonUI" then
        if not frame.IsLoaded then
            T.ApplySpellFixes();
            RegisterHooks();
            frame.IsLoaded = true;
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

end

function Events.GARRISON_MISSION_LIST_UPDATE(garrFollowerTypeID)

end

function Events.GARRISON_MISSION_NPC_CLOSED()
    -- stop calculation
end

function Events.GARRISON_MISSION_NPC_OPENED(followerTypeID)
    if followerTypeID == 123 then
        -- some presetups for table
    end
end

function Events.GARRISON_FOLLOWER_ADDED(...)

end

local function ProcessEvents(_, event, ...)
    local handler = Events[event];
    if handler then
        handler(...);
    end
end

for event in pairs(Events) do
    frame:RegisterEvent(event);
end

frame:SetScript("OnEvent", ProcessEvents);
frame:Show();

T.MainFrame = frame;
