if GetResourceState('vehicles_keys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "jaksams_VehiclesKeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(vehicle, plate)
    if not DoesEntityExist(vehicle) and not plate then return false end
    if vehicle and DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate then
            TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
            return true
        end
    elseif plate then
        TriggerServerEvent("vehicles_keys:selfGiveVehicleKeys", plate)
        return true
    end
    return false
end

VehicleKey.RemoveKeys = function(vehicle, plate)
    if not vehicle and not plate then return false end
    if vehicle and DoesEntityExist(vehicle) then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate then
            TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
            return true
        end
    elseif plate then
        TriggerServerEvent("vehicles_keys:selfRemoveKeys", plate)
        return true
    end
    return false
end