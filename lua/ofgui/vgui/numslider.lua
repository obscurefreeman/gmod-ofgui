local PANEL = {}

function PANEL:Init()
	self:SetTall( 32 * OFGUI.ScreenScale )
	self.Label:SetFont("ofgui_small")
	self.Label:SetTextColor(color_white)
	self.TextArea:SetFont("ofgui_small")
	self.TextArea:SetWide( 45 * OFGUI.ScreenScale )
end

derma.DefineControl("OFNumSlider", "", PANEL, "DNumSlider")