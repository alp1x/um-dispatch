local Bridge = {}

local qbx = exports.qbx_core

if IsDuplicityVersion() then
    -- ============== SERVER ==============

    function Bridge.GetPlayer(source)
        return qbx:GetPlayer(source)
    end

    ---@param source number
    ---@return { type: string, name: string, onduty: boolean }?
    function Bridge.GetPlayerJob(source)
        local player = qbx:GetPlayer(source)
        return player and player.PlayerData.job or nil
    end

    function Bridge.OnPlayerLoaded(handler)
        RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
            local src = source
            if type(src) ~= 'number' or src <= 0 then return end
            handler(src, Bridge.GetPlayerJob(src))
        end)
    end

    function Bridge.OnPlayerUnload(handler)
        AddEventHandler('QBCore:Server:OnPlayerUnload', function(src)
            if not src or src <= 0 then return end
            handler(src)
        end)
    end

    function Bridge.OnJobUpdate(handler)
        AddEventHandler('QBCore:Server:OnJobUpdate', function(src, job)
            if not src or src <= 0 then return end
            handler(src, job)
        end)
    end

    function Bridge.OnDutyChange(handler)
        AddEventHandler('QBCore:Server:SetDuty', function(src, onDuty)
            if not src or src <= 0 then return end
            handler(src, onDuty == true)
        end)
    end
else
    -- ============== CLIENT ==============

    function Bridge.GetPlayerData()
        return qbx:GetPlayerData()
    end

    function Bridge.HasItem(item)
        return true
    end

    function Bridge.Notify(message, type, duration)
        lib.notify({ description = message, type = type, duration = duration })
    end

    function Bridge.OnPlayerLoaded(handler)
        AddEventHandler('QBCore:Client:OnPlayerLoaded', handler)
    end

    function Bridge.OnJobUpdate(handler)
        RegisterNetEvent('QBCore:Client:OnJobUpdate', handler)
    end

    function Bridge.OnDutyChange(handler)
        RegisterNetEvent('QBCore:Client:SetDuty', handler)
    end
end

return Bridge
