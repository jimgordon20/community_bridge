if GetResourceState('vehicles_keys') ~= 'started' or (BridgeSharedConfig.VehicleKey ~= "jaksams_VehiclesKeys" and BridgeSharedConfig.VehicleKey ~= "auto") then return end

VehicleKey = VehicleKey or {}

VehicleKey.GiveKeys = function(src, vehicle, plate)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate then
            return exports["vehicles_keys"]:giveVehicleKeysToPlayerId(src, plate, "temporary")
        end
    elseif plate then
        return exports["vehicles_keys"]:giveVehicleKeysToPlayerId(src, plate, "temporary")
    end
end

VehicleKey.RemoveKeys = function(src, vehicle, plate)
    if vehicle then
        local plate = GetVehicleNumberPlateText(vehicle)
        if plate then
            return exports["vehicles_keys"]:removeKeysFromPlayerId(src, plate)
        end
    elseif plate then
        return exports["vehicles_keys"]:removeKeysFromPlayerId(src, plate)
    end
end