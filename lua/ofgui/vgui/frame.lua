local gradtex = surface.GetTextureID("gui/gradient_down")

local PANEL = {}

function PANEL:Init()
	OFGUI.Add(self)

	self.startTime = SysTime()

	self:SetSize(ScrW() / 2, ScrH() / 2)
	self:Center()

	self:MakePopup()
	self:RequestFocus()

	self:SetAlpha(0)
	self:AlphaTo(255, 0.4, 0)

	self.Rounded = 6
	self.FrameBlur = true
	self.BackgroundBlur = false

	-- 创建标题栏面板
	self.TopBar = vgui.Create("DPanel", self)
	self.TopBar:Dock(TOP)
	self.TopBar:SetTall(32)
	self.TopBar.Paint = function() end

	-- 创建控制按钮容器
	self.ControlButtons = vgui.Create("DPanel", self.TopBar)
	self.ControlButtons:Dock(RIGHT)
	self.ControlButtons:SetWide(70)
	self.ControlButtons.Paint = function() end

	-- 创建关闭按钮
	self.CloseButton = vgui.Create("DButton", self.ControlButtons)
	self.CloseButton:SetSize(24, 24)
	self.CloseButton:Dock(RIGHT)
	self.CloseButton:DockMargin(4, 4, 4, 4)
	self.CloseButton:SetText("")
	self.CloseButton.Paint = function(pnl, w, h)
		local bgColor = pnl:IsHovered() and OFGUI.ClosePressColor or OFGUI.CloseColor
		draw.RoundedBox(4, 0, 0, w, h, bgColor)
		
		surface.SetFont("ofgui_medium")
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(w/2 - 4, h/2 - 6)
		surface.DrawText("X")
	end
	self.CloseButton.DoClick = function()
		self:Close()
	end
end

function PANEL:SetNoRounded(bool)
	self.Rounded = (bool == nil and true or bool) and 0 or 6
end

function PANEL:SetBackgroundBlur(bool)
	self.BackgroundBlur = bool == nil and true or bool
end

function PANEL:SetFrameBlur(bool)
	self.FrameBlur = bool == nil and true or bool
end

function PANEL:Paint(w, h)
	if self.BackgroundBlur then
		Derma_DrawBackgroundBlur(self, self.startTime)
	end

	if not self.FirstInit then
		self.FirstInit = true
		self.PolyMask = surface.PrecacheRoundedRect(0, 0, self:GetWide(), self:GetTall(), self.Rounded, 16)
	end

	EZMASK.DrawWithMask(function()
		surface.SetDrawColor(color_white)
		surface.DrawPoly(self.PolyMask)
	end, function()
		if self.FrameBlur then
			surface.DrawPanelBlur(self, 6)
		end
		draw.RoundedBox(self.Rounded, 0, 0, w, h, OFGUI.BGColor)

		surface.SetDrawColor(OFGUI.HeaderLineColor)
		surface.DrawLine(8, self.TopBar:GetTall() - 1, w - 8, self.TopBar:GetTall() - 1)
		surface.DrawLine(8, self.TopBar:GetTall(), w - 8, self.TopBar:GetTall())
	end)
end

function PANEL:SetTitle(text)
	self.Title = vgui.Create("DLabel", self.TopBar)
	self.Title:SetTextColor(color_white)
	self.Title:SetText(text)
	self.Title:SetExpensiveShadow(1, ColorAlpha(color_black, 120))

	self.Title:SetFont("ofgui_big")
	self.Title:SetContentAlignment(4)
	self.Title:SizeToContents()

	self.Title:Dock(TOP)
	self.Title:DockMargin(6, 2, 6, 2)
end

function PANEL:OnRemove()
	table.RemoveByValue(OFGUI.Opened, self)
end

function PANEL:OnClose()
    -- Use it instead of OnRemove
end

function PANEL:Close()
	self:AlphaTo(0, 0.3, 0, function(_, pan)
		pan:Remove()
	end)
	self:OnClose()
end

derma.DefineControl("OFFrame", "", PANEL, "EditablePanel")