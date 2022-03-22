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

    if not CMR_MISSIONS then CMR_MISSIONS = { OK = {}, ERROR = {} } end
    if not CMR_LOGS then CMR_LOGS = {} end

    --table.insert(CMR_LOGS, logInfo);

    local board = T.GarrAutoBoard:New(logInfo);
    board.LogEnabled = false;
    board:Simulate();

    local simOK = board:CheckSimulation(logInfo);
    if not simOK then
        CMR_MISSIONS.ERROR[missionID] = (CMR_MISSIONS.ERROR[missionID] or 0) + 1;
        while #CMR_LOGS > 300 do
            table.remove(CMR_LOGS, 1);
        end
        table.insert(CMR_LOGS, logInfo);
        if T.IsDebug then
            print(string.format("Mission %i log was stored", missionID));
        end
    else
        if T.IsDebug then
            CMR_MISSIONS.OK[missionID] = (CMR_MISSIONS.OK[missionID] or 0) + 1;
            print(string.format("|cff00ff00Mission %i simulation is succesfull!|r", missionID));
        end
    end
end

T.SaveCombatLog = SaveCombatLog;
