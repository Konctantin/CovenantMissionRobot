local _, T = ...;

local C_RED   = "ffff0000";
local C_GREEN = "ff00ff00";

local HELPER_POINTS = {
    [0] = { x=-150, y=090, alignment="BOTTOM" },
    [1] = { x= 150, y=090, alignment="BOTTOM" },
    [2] = { x=-150, y=230, alignment="BOTTOM" },
    [3] = { x= 000, y=230, alignment="BOTTOM" },
    [4] = { x= 150, y=230, alignment="BOTTOM" },

    [5] = { x=-190, y=-75, alignment="TOP" },
    [6] = { x= -65, y=-75, alignment="TOP" },
    [7] = { x=  65, y=-75, alignment="TOP" },
    [8] = { x= 190, y=-75, alignment="TOP" },

    [9] = { x=-190, y= 25, alignment="TOP" },
    [10]= { x= -65, y= 25, alignment="TOP" },
    [11]= { x=  65, y= 25, alignment="TOP" },
    [12]= { x= 190, y= 25, alignment="TOP" },
};

local function CreateIconButton(parent, size, texture, tooltip)

    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 0, 0);
        GameTooltip_AddNormalLine(GameTooltip, tooltip or "");
        GameTooltip:Show();
    end

    local function OnLeave()
        GameTooltip_Hide();
    end

    local button = CreateFrame("Button", nil, parent);
    button:SetSize(size, size);
    button:SetNormalTexture(texture or "Interface/Icons/Temp");
    button:SetHighlightTexture("Interface/Buttons/ButtonHilight-Square");
    button:GetHighlightTexture():SetBlendMode("ADD");
    button:SetPushedTexture("Interface/Buttons/UI-Quickslot-Depress");
    button:GetPushedTexture():SetDrawLayer("OVERLAY");

    local icon = button:CreateTexture(nil, "ARTWORK");
    icon:SetAllPoints();
    icon:SetTexture(texture or "Interface/Icons/Temp");
    button.Icon = icon;

    --button.tooltipText = tooltip;

    button:SetScript('OnEnter', OnEnter)
    button:SetScript('OnLeave', OnLeave)

    return button;
end

local function CreateButtons(place)
    -- Clear board
    if not place.ClearButton then
        local button = CreateIconButton(place, 32, "interface/buttons/ui-minusbutton-up", "Clear board");
        button:SetPoint("LEFT", 20, -30);
        button:SetScript("OnClick", function()
            local frames = CovenantMissionFrame.MissionTab.MissionPage.Board.framesByBoardIndex;
            for i = 0, 4 do
                if frames[i].info then
                    CovenantMissionFrame:RemoveFollowerFromMission(frames[i], true);
                end
            end
        end);

        place.ClearButton = button;
    end

    -- Find best disposition
    if not place.FindBestDisposition then
        local button = CreateIconButton(place, 32, "Interface/Icons/inv_inscription_tomeoftheclearmind", "Find best disposition");
        button:SetPoint("LEFT", 20, -70);
        button:SetScript("OnClick", function()
            print("not now");
        end);
        place.FindBestDisposition = button;
    end

    -- Recalc
    if not place.RecalcButton then
        local button = CreateIconButton(place, 32, "Interface/Icons/inv_inscription_tomeoftheclearmind", "Recalc");
        button:SetPoint("LEFT", 20, -110);
        button:SetScript("OnClick", function()
            print("not now");
        end);
        place.RecalcButton = button;
    end
end

local function SetupHelpControls(place)
    local function OnEnter(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT");
        GameTooltip:SetPoint("TOPLEFT", self, "BOTTOMRIGHT", 0, 0);

        -- todo: more info and something else
        GameTooltip_AddNormalLine(GameTooltip, "Unit HP History");
        GameTooltip:AddLine(" ");
        for i, v in ipairs(self.inf) do
            local r,g,b = 0,1,0;
            if v.CurHP == 0 then
                r,g,b = 1,0,0;
            end
            local deltaStr = "";
            if i > 1 then
                local delta = self.inf[i-1].CurHP - self.inf[i].CurHP;
                if delta > 0 then
                    deltaStr = string.format("-%i", math.abs(delta));
                elseif delta < 0 then
                    deltaStr = string.format("+%i", math.abs(delta));
                end
            end

            GameTooltip:AddDoubleLine(i, string.format("%s %i / %i", deltaStr, v.CurHP, v.MaxHP), 0, 0.5, 0, r,g,b);
         end

        GameTooltip:Show();
    end

    local function OnLeave()
        GameTooltip_Hide();
    end

    for i, point in pairs(HELPER_POINTS) do
        local name = "inf"..tostring(i);
        local helpLabel = place[name];
        if not helpLabel then

            helpLabel = CreateFrame("Frame", name, place);
            helpLabel:ClearAllPoints();
            helpLabel:SetSize(160, 30);
            helpLabel:SetPoint(point.alignment, point.x, point.y);

            helpLabel.text = helpLabel:CreateFontString(name, "OVERLAY", "GameFontNormal");
            helpLabel.text:SetAllPoints();

            helpLabel:SetScript('OnEnter', OnEnter)
            helpLabel:SetScript('OnLeave', OnLeave)

            helpLabel.inf = {};
            place[name] = helpLabel;
        end
        helpLabel.text:SetText("");
        helpLabel.inf = {};
    end

    CreateButtons(place);
end

local function ShowMissionID(place, missionInf)
    if not place.MissionIdLabel then
        local label = place:CreateFontString("missionIdLabel", "OVERLAY", "GameFontNormal");
        label:ClearAllPoints();
        label:SetSize(60, 30);
        label:SetPoint("BOTTOMRIGHT", -30, -30);
        place.MissionIdLabel = label;
    end
    place.MissionIdLabel:SetText("ID: "..tostring(missionInf.missionID));
end

local function ShowRoundCount(place, rounds)
    if not place.RoundCountLabel then
        local label = place:CreateFontString("roundCountLabel", "OVERLAY", "GameFontNormal");
        label:ClearAllPoints();
        label:SetSize(70, 30);
        label:SetPoint("BOTTOMRIGHT", -30, 70);
        place.RoundCountLabel = label;
    end
    place.RoundCountLabel:SetText("Rounds: "..tostring(rounds));
end

local function Simulate(place)
    local missionInf = T.GetMissionBoardInfo();

    ShowMissionID(place, missionInf);

    if #missionInf.followers > 0 then
        local board = T.GarrAutoBoard:New(missionInf);
        board:Run();

        ShowRoundCount(place, board.Round);

        for i = 0, 12 do
            local u = board.Board[i];
            local helpLabel = place["inf"..tostring(i)];
            if u and helpLabel then
                --local cmin, cmax = board.MinHP[i], board.MaxHP[i];
                local color = u.CurHP == 0 and C_RED or C_GREEN;
                local percent = u.CurHP > 0 and string.format(" (%i%%)", (u.CurHP*100)/u.MaxHP) or "";
                helpLabel.text:SetText(string.format("|c%s%i/%i%s|r", color, u.CurHP, u.MaxHP, percent));

                helpLabel.inf = {};
                for c = 0, #board.CheckPoints do
                    local cp = board.CheckPoints[c];
                    table.insert(helpLabel.inf, { MaxHP = u.MaxHP, CurHP = cp[i] });
                end
            end
        end
    end
end

local function ShowInfoFrame()
    local missionPage = CovenantMissionFrame:GetMissionPage();
    SetupHelpControls(missionPage.Board);
    if missionPage and missionPage.missionInfo then
        Simulate(missionPage.Board);
    end
end

T.ShowInfoFrame = ShowInfoFrame;
