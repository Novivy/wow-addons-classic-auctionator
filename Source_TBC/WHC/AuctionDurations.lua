Auctionator.WHC = Auctionator.WHC or {}

-- Stores server-configured auction durations in minutes (0 = not yet received).
-- Populated by ::whc::auction:{short|medium|long}:{minutes} system messages.
Auctionator.WHC.Durations = {short = 0, medium = 0, long = 0, deposit = 0}

local VALUE_TO_KEY = {[12] = "short", [24] = "medium", [48] = "long"}

local function MinutesToDayLabel(minutes)
  if minutes == 0 then return nil end
  local days = math.floor(minutes / 60 / 24)
  return days == 1 and "1 Day" or (days .. " Days")
end

-- Updates label text and font size on every duration radio button in a radio group.
-- Works for both the selling tab (Duration) and the config screen (DurationGroup).
function Auctionator.WHC.ApplyDurationLabels(radioButtonGroup)
  if not radioButtonGroup or not radioButtonGroup.radioButtons then return end
  for _, btn in ipairs(radioButtonGroup.radioButtons) do
    local fontPath, _, fontFlags = btn.RadioButton.Label:GetFont()
    btn.RadioButton.Label:SetFont(fontPath, 11, fontFlags)

    local which = VALUE_TO_KEY[btn:GetValue()]
    if which then
      local label = MinutesToDayLabel(Auctionator.WHC.Durations[which] or 0)
      if label then
        btn.RadioButton.Label:SetText(label)
      end
    end
  end
end

-- Listen for ::whc::auction: system messages from the server (values in minutes).
-- Uses a plain event handler so WOW_HC's own ChatFrame filter still runs normally.
local whcListener = CreateFrame("Frame")
whcListener:RegisterEvent("CHAT_MSG_SYSTEM")
whcListener:SetScript("OnEvent", function(self, event, message)
  local lower = string.lower(message)
  if string.find(lower, "^::whc::auction:") then
    local variable, value = string.match(lower, "^::whc::auction:(%l+):([%d%.]+)")
    if variable and value and Auctionator.WHC.Durations[variable] ~= nil then
      Auctionator.WHC.Durations[variable] = tonumber(value)
    end
  end
end)
