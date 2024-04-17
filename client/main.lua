local QBCore = exports['qb-core']:GetCoreObject()

local isCooldownActive = false

CreateThread(function()
    while true do
        Wait(100)
        
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        
        if IsPlayerNearFence(playerCoords) then
            if not isCooldownActive then
                IsElectrocuted()
                StartCooldown()
            end
        end
    end
end)

function IsPlayerNearFence(coords)
    local fenceModels = {
        'prop_fnclink_09e',
        --'Prop Name',
    }
    
    for i = 1, #fenceModels do
        local fenceObject = GetClosestObjectOfType(coords.x, coords.y, coords.z, 1.0, GetHashKey(fenceModels[i]), false, false, false)
        if fenceObject ~= 0 then
            return true
        end
    end
    
    return false
end

function IsElectrocuted()
    for i = 1, 3 do
        QBCore.Functions.Notify("You Have Been Electrocuted!", 'primary', 5000)
        SetPedToRagdoll(PlayerPedId(), 4000, 4000, 0, 0, 0, 0)
        ClearPedTasks(PlayerPedId())
        StartScreenEffect('MinigameEndMichael', 5000)
        ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.3)
        ApplyBleed()
        TriggerServerEvent("InteractSound_SV:PlayWithinDistance", 2.0, "electrocution", 0.15)
        Wait(1100)
    end
end

function StartCooldown()
    isCooldownActive = true
    SetTimeout(6500, function()
        isCooldownActive = false
    end)
end

function ApplyBleed(source)
    local src = source
    TriggerEvent('hospital:client:SetPain', src)
end
