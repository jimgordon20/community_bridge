---@diagnostic disable: duplicate-set-field
if GetResourceState('core_inventory') == 'missing' then return end
local core = exports.core_inventory

Inventory = Inventory or {}

---This will get the name of the in use resource.
---@return string
Inventory.GetResourceName = function()
    return "core_inventory"
end

local cachedItemList = nil
--- Return the item info in oxs format, {name, label, stack, weight, description, image}
--- https://docs.c8re.store/core-inventory/exports#client-exports-%E2%80%94-inventory-ui
--- @param item string
--- @return table
Inventory.GetItemInfo = function(item)
    local itemList = Inventory.Items()
    return itemList[item] or {}
end

---This will return the entire items table from the inventory in the ox format.
---@return table 
Inventory.Items = function()
    if cachedItemList then return cachedItemList end
    local allItems = core:getItemsList()
    if not allItems then return {} end
    local dataRepack = {}
    for itemName, itemData in pairs(allItems) do
        if itemData and itemData.name then
            dataRepack[itemName] = {
                image = Inventory.GetImagePath(itemData.name),
                stack = itemData.unique or false
            }
        end
    end
    cachedItemList = dataRepack
    return dataRepack
end

---Will return boolean if the player has the item.
---@param item string
---@return boolean
Inventory.HasItem = function(item)
    return core:hasItem(item, 1)
end

---@description Will return boolean if the player has the item.
---@param item string
---@param requiredCount number (optional)
---@return boolean
Inventory.HasItem = function(item, requiredCount)
    return core:getItemCount(item) >= (requiredCount or 1)
end

---This will get the image path for this item, if not found will return placeholder.
---@param item string
---@return string
Inventory.GetImagePath = function(item)
    item = Inventory.StripPNG(item)
    local file = LoadResourceFile("core_inventory", string.format("html/img/%s.png", item))
    local imagePath = file and string.format("nui://core_inventory/html/img/%s.png", item)
    return imagePath or "https://avatars.githubusercontent.com/u/47620135"
end

---This will return the players inventory in the format of {name, label, count, slot, metadata}
---@return table
Inventory.GetPlayerInventory = function()
    local playerItems = core:getInventory()
    local repackedTable = {}
    for _, v in pairs(playerItems) do
        table.insert(repackedTable, {
            name = v.name,
            count = v.count or v.amount,
            metadata = v.metadata or v.info,
            slot = v.id or v.slot,
        })
    end
    return repackedTable
end

return Inventory