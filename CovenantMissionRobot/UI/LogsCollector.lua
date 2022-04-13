local _, T = ...;

local function GetCompletedMissionInfo(missionID)
	local missionList = C_Garrison.GetCompleteMissions(123);
	for _, mi in ipairs(missionList) do
		if mi.missionID == missionID then
			return mi;
		end
	end
end

local function SaveCombatLog(missionID, canComplete, success, bonusRollSuccess, followerDeaths, autoCombatResult)

    local missionInfo = GetCompletedMissionInfo(missionID);
    local logInfo = {
        missionID     = missionID,
        missionName   = missionInfo.name,
        level         = missionInfo.missionScalar,
        id            = tostring(time())..string.format("%04d", missionID),
        log           = autoCombatResult.combatLog,
        winner        = autoCombatResult.winner,
        enemies       = C_Garrison.GetMissionCompleteEncounters(missionID),
        environmentEffect = C_Garrison.GetAutoMissionEnvironmentEffect(missionID),
        followers     = { };
    };

    for i = 1, #missionInfo.followers do
        local fid  = missionInfo.followers[i];
        local followerInfo = T.GetAutoFollowerInfo(fid);
        table.insert(logInfo.followers, followerInfo);
    end

    if not CMR_LOGS then CMR_LOGS = {} end
    if not CMR_LOGS[missionID] then CMR_LOGS[missionID] = { OK = {}, ERR = {}} end

    local logs = CMR_LOGS[missionID];

    local board = T.GarrAutoBoard:New(logInfo);
    board.LogEnabled = false;
    board:Simulate();

    local simOK = board:CheckSimulation(logInfo);

    if not simOK then
        table.insert(logs.ERR, 1, logInfo);
        while #logs.ERR > 5 do
            table.remove(logs.ERR, #logs.ERR);
        end
        if T.IsDebug then
            print(string.format("Mission %i log was stored", missionID));
        end
    elseif T.IsDebug then
        if #logs.OK == 0 then
            table.insert(logs.OK, logInfo);
            print(string.format("|cff00ff00Mission %i simulation is succesfull!|r", missionID));
        end
    end
end

T.SaveCombatLog = SaveCombatLog;
