local _, T = ...;

function CreateFrame(...) end

local Robot = CreateFrame("Frame");

Robot:RegisterEvent("ADDON_LOADED");
Robot:SetScript("OnEvent",
    function (event, addon)
        if addon == "Blizzard_GarrisonUI" then
            if not Robot.isLoaded then
                if type(T.ApplyFixes) == "function" then
                    T.ApplyFixes()
                end
                Robot.isLoaded = true
            end
        end
    end);

T.Robot = Robot;