local _, T = ...;

local UP_ITEMS = {
    188655,
    188656,
    188657,
};

local function GetMacroText(itemID)
    local name = GetItemInfo(itemID);
    local macrotext = "/use "..name.."\n/run C_Garrison.CastSpellOnFollower(CovenantMissionFrame.FollowerTab.followerID)";
    return macrotext;
end

local function CreateUPButton(place, itemID, x)
    if not place.followerID then
        return;
    end

    local buttonName = "UpButton_"..tostring(itemID);

    if not place[buttonName] then
        local button = CreateFrame("Button", buttonName, place, "SecureActionButtonTemplate,ActionButtonTemplate");
        button:SetSize(48, 48);
        button:SetPoint("BOTTOMRIGHT", x, 40);

        local icon = button:CreateTexture(nil, "ARTWORK");
        icon:SetAllPoints();
        icon:SetTexture(GetItemIcon(itemID));
        button.Icon = icon;

        local _, itemLink  = GetItemInfo(itemID);
        button:HookScript("OnEnter", function()
            GameTooltip:SetOwner(button, "ANCHOR_TOP");
            GameTooltip:SetHyperlink(itemLink);
            GameTooltip:Show();
        end);

        button:HookScript("OnLeave", function()
            GameTooltip:Hide();
        end)

        button:SetAttribute("type", "macro");
        button:SetAttribute("macrotext", GetMacroText(itemID));
        button:RegisterForClicks("LeftButtonUp");
        place[buttonName] = button;
    end

    local count = GetItemCount(itemID);
    place[buttonName].Count:SetText(count);
    place[buttonName]:SetEnabled(count > 0);
end

local function UpdateAllButtons(place)
    local x = -30;
    for i, v in ipairs(UP_ITEMS) do
        CreateUPButton(place, v, x);
        x = x - 60;
    end
end

local function Init()
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
