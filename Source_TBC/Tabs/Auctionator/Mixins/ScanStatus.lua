AuctionatorFullScanStatusMixin = {}

function AuctionatorFullScanStatusMixin:OnLoad()
  Auctionator.EventBus:Register(self, {
    Auctionator.FullScan.Events.ScanStart,
    Auctionator.FullScan.Events.ScanProgress,
    Auctionator.FullScan.Events.ScanComplete,
    Auctionator.FullScan.Events.ScanFailed,
  })
end

function AuctionatorFullScanStatusMixin:OnShow()
  self.Text:SetText("")
end

function AuctionatorFullScanStatusMixin:ReceiveEvent(event, eventData)
  if event == Auctionator.FullScan.Events.ScanStart or
     event == Auctionator.FullScan.Events.ScanProgress then
    self.Text:SetText("Scan in progress...")
  else
    self.Text:SetText("")
  end
end
