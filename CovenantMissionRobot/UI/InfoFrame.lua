local _, T = ...;

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
}

local function SetupLables(place)
    for i, point in pairs(HELPER_POINTS) do
        local name = "inf"..tostring(i);
        if not place[name] then
            place[name] = place:CreateFontString(name, "OVERLAY", "GameFontNormal");
            place[name]:SetSize(160, 30);
            place[name]:SetPoint(point.alignment, point.x, point.y);
        end
        place[name]:SetText("");
    end
end

local function Simulate(place)
    local missionInf = T.GetMissionBoardInfo();
    if #missionInf.followers > 0 then
        local board = T.GarrAutoBoard:New(missionInf);
        board:Run();

        for i = 0, 12 do
            local u = board.Board[i];
            local name = "inf"..tostring(i);
            if u and place[name] then
                local color = u.CurHP == 0 and "ffff0000" or "ff00ff00";
                place[name]:SetText(string.format("|c%s%i/%i|r", color, u.CurHP, u.MaxHP));
            end
        end
    end
end

local function ShowInfoFrame()
    local place = CovenantMissionFrame.MissionTab.MissionPage.Board;
    SetupLables(place);
    Simulate(place);
end

T.ShowInfoFrame = ShowInfoFrame;
