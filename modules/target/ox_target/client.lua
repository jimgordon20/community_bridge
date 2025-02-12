if GetResourceState('ox_target') ~= 'started' then return end

local targetDebug = false
local function detectDebugEnabled()
    if BridgeClientConfig.DebugLevel == 2 then
        targetDebug = true
    end
end

detectDebugEnabled()

local ox_target = exports.ox_target
local targetZones = {}

Target = {}

Target.AddGlobalPlayer = function(options)
    for k, v in pairs(options) do
        options[k].onSelect = v.onSelect or v.action
    end
    ox_target:addGlobalPlayer(options)
end

Target.AddGlobalVehicle = function(options)
    for k, v in pairs(options) do
        options[k].onSelect = v.onSelect or v.action
    end
    ox_target:addGlobalVehicle(options)
end

Target.AddLocalEntity = function(entities, options)
    for k, v in pairs(options) do
        options[k].onSelect = v.onSelect or v.action
    end
    ox_target:addLocalEntity(entities, options)
end

Target.AddModel = function(models, options)
    for k, v in pairs(options) do
        options[k].onSelect = v.onSelect or v.action
    end
    ox_target:addModel(models, options)
end

Target.AddBoxZone = function(name, coords, size, heading, options)
    for k, v in pairs(options) do
        options[k].onSelect = v.onSelect or v.action
    end
    local target = ox_target:addBoxZone({
        coords = coords,
        size = size,
        rotation = heading,
        debug = targetDebug,
        options = options,
    })
    table.insert(targetZones, { name = name, id = target, creator = GetInvokingResource() })
    return target
end

Target.RemoveGlobalPlayer = function()
    ox_target:removeGlobalPlayer()
end

Target.RemoveLocalEntity = function(entity)
    ox_target:removeLocalEntity(entity)
end

Target.RemoveModel = function(model)
    ox_target:removeModel(model)
end

Target.RemoveZone = function(name)
    for _, data in pairs(targetZones) do
        if data.name == name then
            ox_target:removeZone(data.id)
            table.remove(targetZones, _)
            break
        end
    end
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for _, target in pairs(targetZones) do
            if target.creator == resource then
                ox_target:removeZone(target.id)
            end
        end
        targetZones = {}
    end
end)
