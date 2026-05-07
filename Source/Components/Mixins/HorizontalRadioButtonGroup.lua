AuctionatorConfigHorizontalRadioButtonGroupMixin = CreateFromMixins(AuctionatorConfigRadioButtonGroupMixin)

function AuctionatorConfigHorizontalRadioButtonGroupMixin:SetupRadioButtons()
  local children = { self:GetChildren() }
  local size = 0

  for _, child in ipairs(children) do
    if child.isAuctionatorRadio then
      table.insert(self.radioButtons, child)

      child:ClearAllPoints()
      child:SetPoint("TOPLEFT", size, -20)
      child:SetWidth(62)
      child.RadioButton.Label:SetPoint("TOPLEFT", 19, -4)

      child.onSelectedCallback = function()
        self:RadioSelected(child)
      end

      size = size + 62
    end
  end

  -- 8 is for bottom padding
  self:SetSize(size, 48)
end