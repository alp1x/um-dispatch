local Config = require 'shared.config'

local TrackJobs = {}

local watchedJobs = {}
for i = 1, #Config.Jobs do
    watchedJobs[Config.Jobs[i]] = true
end

-- jobIndex[jobType] = { [source] = onduty }
local jobIndex = {}
-- trackedTypeBySource[source] = jobType
local trackedTypeBySource = {}
local initialized = false

local function untrackPlayer(source)
    local jobType = trackedTypeBySource[source]
    if not jobType then return end

    local list = jobIndex[jobType]
    if list then list[source] = nil end
    trackedTypeBySource[source] = nil
end

-- Tracks a player under their job type, or untracks if not watched.
-- Skips work when only duty changed (handled by setDutyOnly).
local function setTrackedJob(source, job)
    local newType = job and job.type
    if newType and not watchedJobs[newType] then newType = nil end

    local oldType = trackedTypeBySource[source]

    -- Fast path: civilians/non-watched jobs that aren't already tracked.
    if not newType and not oldType then return end

    if not newType then
        untrackPlayer(source)
        return
    end

    local onduty = (job and job.onduty) and true or false

    if oldType == newType then
        jobIndex[newType][source] = onduty
        return
    end

    if oldType then
        local oldList = jobIndex[oldType]
        if oldList then oldList[source] = nil end
    end

    local list = jobIndex[newType]
    if not list then
        list = {}
        jobIndex[newType] = list
    end
    list[source] = onduty
    trackedTypeBySource[source] = newType
end

local function setDutyOnly(source, onduty)
    local jobType = trackedTypeBySource[source]
    if not jobType then return end

    local list = jobIndex[jobType]
    if list then list[source] = onduty and true or false end
end

local function trackPlayer(source, job)
    if job then
        setTrackedJob(source, job)
        return
    end

    setTrackedJob(source, Bridge.GetPlayerJob(source))
end

function TrackJobs.Initialize()
    if initialized then return end
    initialized = true

    Bridge.OnPlayerLoaded(trackPlayer)
    Bridge.OnPlayerUnload(untrackPlayer)
    Bridge.OnJobUpdate(trackPlayer)
    if Bridge.OnDutyChange then
        Bridge.OnDutyChange(setDutyOnly)
    end

    CreateThread(function()
        local players = GetPlayers()
        for i = 1, #players do
            trackPlayer(tonumber(players[i]))
        end
    end)
end

function TrackJobs.GetTargetPlayers(jobs)
    local targets = {}
    local onDutyOnly = Config.OnDutyOnly

    for i = 1, #jobs do
        local list = jobIndex[jobs[i]]
        if list then
            for src, onduty in pairs(list) do
                if not onDutyOnly or onduty then
                    targets[#targets + 1] = src
                end
            end
        end
    end

    return targets
end

return TrackJobs
