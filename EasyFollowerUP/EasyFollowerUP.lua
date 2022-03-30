local addonName, T = ...;
_G[addonName] = T; -- make it public

local UP_ITEMS = {
    188655, -- Crystalline Memory Repository
    188656, -- Fractal Thoughtbinder
    188657, -- Mind-Expanding Prism
    186472  -- Wisps of Memory
};

local Events = { };
local frame = CreateFrame("Frame");

local function CreateUPButton(place, itemID, xpos, frameName)
    local followerID = place.followerID;
    if not followerID then
        return;
    end

    local buttonName = "UpButton_"..tostring(itemID);
    local itemName, itemLink = GetItemInfo(itemID);
    if not itemName then
        if place[buttonName] then
            place[buttonName]:SetEnabled(false);
        end
        return;
    end

    if not place[buttonName] then
        local macrotext = "/use "..itemName.."\n/run C_Garrison.CastSpellOnFollower("..frameName..".FollowerTab.followerID)";

        local button = CreateFrame("Button", buttonName, place, "SecureActionButtonTemplate,ActionButtonTemplate");
        button:SetSize(48, 48);
        button:SetPoint("BOTTOMRIGHT", xpos, 40);

        local icon = button:CreateTexture(nil, "ARTWORK");
        icon:SetAllPoints();
        icon:SetTexture(GetItemIcon(itemID));
        button.Icon = icon;

        button:HookScript("OnEnter", function()
            GameTooltip:SetOwner(button, "ANCHOR_TOP");
            GameTooltip:SetHyperlink(itemLink);
            GameTooltip:Show();
        end);

        button:HookScript("OnLeave", function()
            GameTooltip:Hide();
        end)

        button:SetAttribute("type", "macro");
        button:SetAttribute("macrotext", macrotext);
        button:RegisterForClicks("LeftButtonUp");
        place[buttonName] = button;
    end

    local count = GetItemCount(itemID);

    local level = 60;
    local missionCompleteInfo = C_Garrison.GetFollowerMissionCompleteInfo(followerID);
    if missionCompleteInfo then
        level = missionCompleteInfo.level;
    end

    local enabled = count > 0 or level < 60;

    place[buttonName].Count:SetText(count);
    place[buttonName]:SetEnabled(enabled);
end

local function UpdateAllButtons(place, frameName)
    if place then
        local x = -30;
        for _, itemID in ipairs(UP_ITEMS) do
            CreateUPButton(place, itemID, x, frameName);
            x = x - 60;
        end
    end
end

local function Setup(place, frameName)
    if not place then
        return;
    end

    if not place:GetParent() or place:GetParent().garrTypeID ~= 111 then
        return;
    end

    if not place.CounterFrame then
        local frame = CreateFrame("Frame");
        frame:RegisterEvent("BAG_UPDATE");
        frame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
        frame:RegisterEvent("GARRISON_FOLLOWER_XP_CHANGED");
        --frame:RegisterEvent("GARRISON_FOLLOWER_LEVEL_UP");
        frame:SetScript("OnEvent", function() UpdateAllButtons(place, frameName) end);
        frame:Show();
        place.CounterFrame = frame;
    end

    UpdateAllButtons(place, frameName);
end

local function ShowMissionFollowerTabHook(self, ...)
    Setup(self, "CovenantMissionFrame");
end

local function ShowLandingFollowerTabHook(self, ...)
    Setup(self, "GarrisonLandingPage");
end

local function HideFollowerTabHook(self, ...)
    if self.CounterFrame then
        self.CounterFrame:UnregisterAllEvents();
        self.CounterFrame = nil;
    end
end

function Events.ADDON_LOADED(addon)
    if addon == "Blizzard_GarrisonUI" then
        if not frame.IsLoaded then
            hooksecurefunc(CovenantMissionFrame.FollowerTab, "ShowFollower", ShowMissionFollowerTabHook);
            hooksecurefunc(CovenantMissionFrame.FollowerTab, "Hide", HideFollowerTabHook);
            hooksecurefunc(GarrisonLandingPage.FollowerTab, "ShowFollower", ShowLandingFollowerTabHook);
            hooksecurefunc(GarrisonLandingPage.FollowerTab, "Hide", HideFollowerTabHook);
            frame.IsLoaded = true;
        end
    end
end

for event in pairs(Events) do
    frame:RegisterEvent(event);
end

frame:SetScript("OnEvent",
    function(_, event, ...)
        local handler = Events[event];
        if handler then
            handler(...);
        end
    end);
frame:Show();

T.MainFrame = frame;
