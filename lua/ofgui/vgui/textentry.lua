local PANEL = {}

function PANEL:Init()
	self:SetDrawBorder(false)
	self:SetDrawBackground(false)
	self:SetTextColor(OFGUI.TextEntryTextColor)
	self:SetFont("ofgui_tiny")
	self:SetCursorColor(OFGUI.TextEntryCursorColor)
	self:SetHighlightColor(OFGUI.TextEntryHighlightColor)

	self.IndicatorColor = Color(255, 255, 255)

	self:SetTooltipPanelOverride("OFTooltip")
	self:SetTooltip(false)
end

function PANEL:IndicatorLayout()
	if self:HasFocus() then
		self.IndicatorColor = LerpColor(5 * FrameTime(), self.IndicatorColor, OFGUI.TextEntryIndicatorFocusedColor)
	else
		self.IndicatorColor = LerpColor(5 * FrameTime(), self.IndicatorColor, OFGUI.TextEntryIndicatorColor)
	end
end

function PANEL:Paint(w,h)
	self:IndicatorLayout()

	draw.NoTexture()
	draw.RoundedBox(6 * OFGUI.ScreenScale, 0, 0, w, h, OFGUI.TextEntryBGColor)

	derma.SkinHook("Paint", "TextEntry", self, w, h)
end

derma.DefineControl("OFTextEntry", "", PANEL, "DTextEntry")