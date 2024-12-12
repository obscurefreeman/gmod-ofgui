local PANEL = {}

function PANEL:Init()
	self:SetFont("ofgui_medium")
	self:SetText("")

	self:SetTooltipPanelOverride("XPTooltip")

	self:SizeToContents()
	self:SetSize(self:GetWide() + 10, 36)

	self:DockMargin(3, 2, 3, 2)

	self:SetDoubleClickingEnabled(false)
	self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

	self.ColorA = OFGUI.ButtonColor.a
	self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
end

function PANEL:OnDepressed()
	OFGUI.PlaySound(OFGUI.ButtonClickSound)
end

function PANEL:OnCursorEntered()
	if self:GetDisabled() then
		return
	end

	OFGUI.PlaySound(OFGUI.ButtonHoverSound)
end

function PANEL:Paint(w, h)
	if self:IsHovered() then
		self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA + 15)
	else
		self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA)
	end

	if self:IsDown() then
		self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA + 25)
	end

	draw.RoundedBox(6, 0, 0, w, h, self.Color)
end

function PANEL:SetAccentColor(clr)
	self.ColorA = 90
	self.Color = clr
end

function PANEL:UpdateColours()
	if self:GetDisabled() then
		return self:SetTextStyleColor(OFGUI.ButtonDisabledTextColor)
	else
		return self:SetTextStyleColor(OFGUI.ButtonTextColor)
	end
end

derma.DefineControl("XPButton", "", PANEL, "DButton")