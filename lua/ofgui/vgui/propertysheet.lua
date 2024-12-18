--[[
	OFTab
]]

local PANEL = {}

AccessorFunc(PANEL, "m_pPropertySheet", "PropertySheet")
AccessorFunc(PANEL, "m_pPanel", "Panel")

function PANEL:Init()
	self:SetMouseInputEnabled(true)
	self:SetContentAlignment(7)
	self:SetTextInset(0, 4 * OFGUI.ScreenScale)
	self.Color = OFGUI.PSTabInactiveColor
end

function PANEL:Setup(label, pPropertySheet, pPanel, strMaterial)
	self:SetText(label)
	self:SetFont("ofgui_tiny")

	self:SetPropertySheet(pPropertySheet)
	self:SetPanel(pPanel)

	local extraInset = 6 * OFGUI.ScreenScale
	if strMaterial then
		self.Image = vgui.Create("DImage", self)
		self.Image:SetImage(strMaterial)
		self.Image:SizeToContents()
		self:InvalidateLayout()

		extraInset = 10 * OFGUI.ScreenScale + self.Image:GetWide()
	end

	self:SetTextInset(extraInset, 4 * OFGUI.ScreenScale)
	self:SizeToContentsX(6)
	self:SetTall(18 * OFGUI.ScreenScale)
end

function PANEL:IsActive()
	return self:GetPropertySheet():GetActiveTab() == self
end

function PANEL:DoClick()
	self:GetPropertySheet():SetActiveTab(self)
end

function PANEL:UpdateColours()
	if self:GetDisabled() then
		return self:SetTextStyleColor(OFGUI.PSTabDisabledTextColor)
	else
		return self:SetTextStyleColor(OFGUI.PSTabTextColor)
	end
end

function PANEL:Paint(w,h)
	if self:IsActive() then
		self.Color = LerpColor(7.5 * FrameTime(), self.Color, OFGUI.PSTabActiveColor)
	else
		if self:IsHovered() then
			self.Color = LerpColor(7.5 * FrameTime(), self.Color, OFGUI.PSTabHoverColor)
		else
			self.Color = LerpColor(7.5 * FrameTime(), self.Color, OFGUI.PSTabInactiveColor)
		end
	end
	draw.RoundedBoxEx(8 * OFGUI.ScreenScale, 0, 0, w, h, self.Color, true, true, false, false)
end

function PANEL:PerformLayout()
	self:ApplySchemeSettings()

	if not self.Image then
		return
	end

	self.Image:SetPos(7 * OFGUI.ScreenScale, 3 * OFGUI.ScreenScale)

	if not self:IsActive() then
		self.Image:SetImageColor(ColorAlpha(color_white, 155))
	else
		self.Image:SetImageColor(color_white)
	end

end

function PANEL:GetTabHeight()
	return 24 * OFGUI.ScreenScale
end

function PANEL:DragHoverClick(hoverTime)
	self:DoClick()
end

function PANEL:DoRightClick()
	if not IsValid(self:GetPropertySheet()) then
		return
	end

	local tabs = OFGUI.Menu()
	for _, v in pairs(self:GetPropertySheet().Items) do
		if not v or not IsValid(v.Tab) or not v.Tab:IsVisible() then
			continue
		end
		local option = tabs:AddOption(v.Tab:GetText(), function()
			if not v or not IsValid(v.Tab) or not IsValid(self:GetPropertySheet()) or not IsValid(self:GetPropertySheet().tabScroller) then
				return
			end
			v.Tab:DoClick()
			self:GetPropertySheet().tabScroller:ScrollToChild(v.Tab)
		end )
		if IsValid(v.Tab.Image) then
			option:SetIcon(v.Tab.Image:GetImage())
		end
	end
	tabs:Open()
end

derma.DefineControl("OFTab", "", PANEL, "DButton")

--[[
	OFPropertySheet
]]

local PANEL = {}

AccessorFunc(PANEL, "m_pActiveTab", "ActiveTab")
AccessorFunc(PANEL, "m_iPadding", "Padding")
AccessorFunc(PANEL, "m_fFadeTime", "FadeTime")

AccessorFunc(PANEL, "m_bShowIcons", "ShowIcons")

function PANEL:Init()
	self:SetShowIcons(true)

	self.tabScroller = vgui.Create("OFHorizontalScroller", self)
	self.tabScroller:SetTall(48 * OFGUI.ScreenScale)
	self.tabScroller:SetOverlap(-2 * OFGUI.ScreenScale)
	self.tabScroller:Dock(TOP)
	self.tabScroller:DockMargin(0, 0, 0, 0)
	self:InvalidateParent()

	self.tabScroller.Paint = function(tbs, w, h)
		surface.SetDrawColor(OFGUI.PSUnderlineDefaultColor)
		surface.DrawLine(0, 24 * OFGUI.ScreenScale, w, 24 * OFGUI.ScreenScale)
		surface.DrawLine(0, 25 * OFGUI.ScreenScale, w, 25 * OFGUI.ScreenScale)

		local p_x, _, p_w, _ = self.m_pActiveTab:GetBounds()
		surface.SetDrawColor(OFGUI.PSUnderlineActiveColor)
		surface.DrawLine(p_x, 24 * OFGUI.ScreenScale, p_x + p_w-1, 24 * OFGUI.ScreenScale)
		surface.DrawLine(p_x, 25 * OFGUI.ScreenScale, p_x + p_w-1, 25 * OFGUI.ScreenScale)
	end

	self:SetFadeTime(0.1)
	self:SetPadding(0)

	self.animFade = Derma_Anim("Fade", self, self.CrossFade)

	self.Items = {}
end

function PANEL:AddSheet(label, panel, material, noStretchX, noStretchY, tooltip)
	if not IsValid(panel) then
		ErrorNoHalt( "OFPropertySheet:AddSheet tried to add invalid panel!" )
		debug.Trace()
		return
	end

	local sheet = {}
	sheet.Name = label

	sheet.Tab = vgui.Create( "OFTab", self )
	sheet.Tab:SetTooltip(tooltip)
	sheet.Tab:Setup(label, self, panel, material)

	sheet.Panel = panel
	sheet.Panel.NoStretchX = noStretchX
	sheet.Panel.NoStretchY = noStretchY
	sheet.Panel:SetPos(self:GetPadding(), 26 * OFGUI.ScreenScale + self:GetPadding())
	sheet.Panel:SetVisible(false)

	panel:SetParent(self)

	table.insert(self.Items, sheet)

	if not self:GetActiveTab() then
		self:SetActiveTab(sheet.Tab)
		sheet.Panel:SetVisible(true)
	end

	self.tabScroller:AddPanel(sheet.Tab)

	return sheet
end

function PANEL:SetActiveTab(active)
	if not IsValid(active) or self.m_pActiveTab == active then
		return
	end

	if not IsValid(self.m_pActiveTab) then
		self:OnActiveTabChanged(self.m_pActiveTab, active)
		if self:GetFadeTime() > 0 then
			self.animFade:Start(self:GetFadeTime(), {
				OldTab = self.m_pActiveTab,
				NewTab = active
			})
		else
			self.m_pActiveTab:GetPanel():SetVisible(false)
		end
	end

	self.m_pActiveTab = active
	self:InvalidateLayout()
end

function PANEL:OnActiveTabChanged(old, new) end

function PANEL:Think()
	self.animFade:Run()
end

function PANEL:GetItems()
	return self.Items
end

function PANEL:CrossFade(anim, delta, data)
	if not data or not IsValid(data.OldTab) or not IsValid(data.NewTab) then
		return
	end

	local old = data.OldTab:GetPanel()
	local new = data.NewTab:GetPanel()

	if not IsValid(old) and not IsValid(new) then
		return
	end

	if anim.Finished then
		if IsValid(old) then
			old:SetAlpha(255)
			old:SetZPos(0)
			old:SetVisible(false)
		end

		if IsValid(new) then
			new:SetAlpha(255)
			new:SetZPos(0)
			new:SetVisible(true) -- in case new == old
		end

		return
	end

	if anim.Started then
		if IsValid(old) then
			old:SetAlpha(255)
			old:SetZPos(0)
		end

		if IsValid(new) then
			new:SetAlpha(0)
			new:SetZPos(1)
		end
	end

	if IsValid(old) then
		old:SetVisible(true)
		if not IsValid(new) then
			old:SetAlpha(255 * (1 - delta))
		end
	end

	if IsValid(new) then
		new:SetVisible(true)
		new:SetAlpha(255 * delta)
	end
end

function PANEL:PerformLayout()
	local activeTab = self:GetActiveTab()
	local padding = self:GetPadding()

	if not IsValid(activeTab) then
		return
	end

	activeTab:InvalidateLayout(true)

	local activePanel = activeTab:GetPanel()

	for _, v in pairs(self.Items) do
		if v.Tab:GetPanel() == activePanel then
			if IsValid(v.Tab:GetPanel()) then
				v.Tab:GetPanel():SetVisible(true)
			end
			v.Tab:SetZPos(100 * OFGUI.ScreenScale)
		else
			if IsValid(v.Tab:GetPanel()) then
				v.Tab:GetPanel():SetVisible(false)
			end
			v.Tab:SetZPos(1 * OFGUI.ScreenScale)
		end
		v.Tab:ApplySchemeSettings()
	end

	if IsValid(activePanel) then
		if not activePanel.NoStretchX then
			activePanel:SetWide(self:GetWide() - padding * 2)
		else
			activePanel:CenterHorizontal()
		end

		if not activePanel.NoStretchY then
			local _, y = activePanel:GetPos()
			activePanel:SetTall(self:GetTall() - y - padding)
		else
			activePanel:CenterVertical()
		end

		activePanel:InvalidateLayout()
	end

	self.animFade:Run()
end

function PANEL:SizeToContentWidth()
	local wide = 0
	for _, v in pairs(self.Items) do
		if IsValid(v.Panel) then
			v.Panel:InvalidateLayout(true)
			wide = math.max(wide, v.Panel:GetWide() + self:GetPadding() * 2)
		end
	end
	self:SetWide(wide)
end

function PANEL:SwitchToName(name)
	for _, v in pairs(self.Items) do
		if v.Name == name then
			v.Tab:DoClick()
			return true
		end
	end
	return false
end

function PANEL:CloseTab(tab, bRemovePanelToo)
	for k, v in pairs(self.Items) do
		if v.Tab ~= tab then
			continue
		end
		table.remove(self.Items, k)
	end

	for k, v in pairs(self.tabScroller.Panels) do
		if v ~= tab then
			continue
		end
		table.remove(self.tabScroller.Panels, k)
	end

	self.tabScroller:InvalidateLayout(true)

	if tab == self:GetActiveTab() then
		self.m_pActiveTab = self.Items[#self.Items].Tab
	end

	local pnl = tab:GetPanel()
	if bRemovePanelToo then
		pnl:Remove()
	end

	tab:Remove()
	self:InvalidateLayout(true)

	return pnl
end

derma.DefineControl("OFPropertySheet", "", PANEL, "Panel")