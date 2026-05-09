-- Returns just enough information that the BagItem mixin can display the item
-- and the SaleItemMixin can post it.
function Auctionator.Utilities.ItemInfoFromLocation(location)
  local icon, itemCount, _, quality, _, _, itemLink
  local currentDurability, maxDurability

  if location:IsBagAndSlot() then
    icon, itemCount, _, quality, _, _, itemLink = GetContainerItemInfo(location:GetBagAndSlot())
    currentDurability, maxDurability = GetContainerItemDurability(location:GetBagAndSlot())
  else
    local slot = location:GetEquipmentSlot()
    icon = GetInventoryItemTexture("player", slot)
    itemCount = GetInventoryItemCount("player", slot)
    quality = GetInventoryItemQuality("player", slot)
    itemLink = GetInventoryItemLink("player", slot)
    currentDurability, maxDurability = GetInventoryItemDurability(slot)
  end

  local _, _, _, _, _, classID, _ = GetItemInfoInstant(itemLink)

  -- GetItemInfoInstant returns -1 for classId on some item types in WoW Classic.
  -- Fall back to GetItemInfo (position 12) as a second attempt.
  if classID == nil or classID == -1 then
    local _, _, _, _, _, _, _, _, _, _, _, fallbackClassId = GetItemInfo(itemLink)
    classID = fallbackClassId
  end

  -- Some private servers return -1 for herb classId even from GetItemInfo.
  -- Herbs are Trade Goods in vanilla WoW, so remap -1 to Tradegoods.
  if classID == -1 then
    classID = Enum.ItemClass.Tradegoods
  end

  -- The first time the AH is loaded sometimes when a full scan is running the
  -- quality info may not be available. This just gives a sensible fail value.
  if quality == -1 then
    Auctionator.Debug.Message("Missing quality", itemLink)
    quality = 1
  end

  return {
    itemLink = itemLink,
    count = itemCount,
    iconTexture = icon,
    location = location,
    quality = quality,
    classId = classID,
    auctionable = not C_Item.IsBound(location) and currentDurability == maxDurability,
  }
end
