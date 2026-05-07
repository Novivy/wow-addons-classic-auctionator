AuctionatorScanButtonMixin = {}

function AuctionatorScanButtonMixin:OnLoad()
  Auctionator.EventBus:Register(self, {
    Auctionator.FullScan.Events.ScanStart,
    Auctionator.FullScan.Events.ScanComplete,
    Auctionator.FullScan.Events.ScanFailed,
  })
  -- Cache the original label so we can restore it after a scan ends.
  self.startLabel = self:GetText()
end

function AuctionatorScanButtonMixin:OnClick()
  local ref = Auctionator.State.FullScanFrameRef
  if ref.inProgress then
    ref:AbortScan()
  else
    ref:InitiateScan()
  end
end

function AuctionatorScanButtonMixin:ReceiveEvent(event)
  if event == Auctionator.FullScan.Events.ScanStart then
    self:SetText("Stop Scan")
  else
    self:SetText(self.startLabel)
  end
end
