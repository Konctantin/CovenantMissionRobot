local _, T = ...;

local UP_ITEMS = {
    188655, -- Crystalline Memory Repository
    188656, -- Fractal Thoughtbinder
    188657, -- Mind-Expanding Prism
    186472  -- Wisps of Memory
};

local function CreateUPButton(place, itemID, xpos)
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
        local macrotext = "/use "..itemName.."\n/run C_Garrison.CastSpellOnFollower(CovenantMissionFrame.FollowerTab.followerID)";

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

local function UpdateAllButtons(place)
    if place then
        local x = -30;
        for _, itemID in ipairs(UP_ITEMS) do
            CreateUPButton(place, itemID, x);
            x = x - 60;
        end
    end
end

local function Init()
    if not CovenantMissionFrame then
        return;
    end

    if not CovenantMissionFrame.FollowerTab then
        return;
    end

    local place = CovenantMissionFrame.FollowerTab;
    if not place.CounterFrame then
        local frame = CreateFrame("Frame");
        frame:RegisterEvent("BAG_UPDATE");
        frame:RegisterEvent("BAG_NEW_ITEMS_UPDATED");
        frame:SetScript("OnEvent", function() UpdateAllButtons(place) end);
        frame:Show();
        place.CounterFrame = frame;
    end

    UpdateAllButtons(place);
end

T.InitFollowerHelper = Init;
