local gradtex = surface.GetTextureID("gui/gradient_down")

local PANEL = {}

function PANEL:Init()
	OFGUI.Add(self)

	self.startTime = SysTime()

	self:SetSize(1280 * OFGUI.ScreenScale, 720 * OFGUI.ScreenScale)
	self:Center()

	self:MakePopup()
	self:RequestFocus()

	self:SetAlpha(0)
	self:AlphaTo(255, 0.4, 0)

	self.Rounded = 6
	self.FrameBlur = true
	self.BackgroundBlur = false

	self.CanDrag = true  -- 添加一个新的变量来控制是否可以拖拽

	-- 创建标题栏面板
	self.TopBar = vgui.Create("DPanel", self)
	self.TopBar:Dock(TOP)
	self.TopBar:SetTall(32 * OFGUI.ScreenScale)
	self.TopBar.Paint = function() end
	self.TopBar:SetCursor("sizeall")

	-- 创建控制按钮容器
	self.ControlButtons = vgui.Create("DPanel", self.TopBar)
	self.ControlButtons:Dock(RIGHT)
	self.ControlButtons:SetWide(118 * OFGUI.ScreenScale)
	self.ControlButtons.Paint = function() end

	-- 创建关闭按钮
	self.CloseButton = vgui.Create("DButton", self.ControlButtons)
	self.CloseButton:SetSize(48 * OFGUI.ScreenScale, 24 * OFGUI.ScreenScale)
	self.CloseButton:Dock(RIGHT)
	self.CloseButton:DockMargin(4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale)
	self.CloseButton:SetText("")
	self.CloseButton.Paint = function(pnl, w, h)
		local bgColor = pnl:IsHovered() and OFGUI.ClosePressColor or OFGUI.CloseColor
		draw.RoundedBox(4 * OFGUI.ScreenScale, 0, 0, w, h, bgColor)
		
		surface.SetFont("ofgui_big")
		local text = "x"
		local tw, th = surface.GetTextSize(text)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(w/2 - tw/2, h/2 - th/2)
		surface.DrawText(text)
	end

	-- 添加鼠标悬停事件
	self.CloseButton.OnCursorEntered = function()
		OFGUI.PlaySound(OFGUI.ButtonHoverSound) -- 播放悬停声音
	end

	self.CloseButton.DoClick = function()
		self:Close()
		OFGUI.PlaySound(OFGUI.ButtonClickSound)
	end

	-- 在关闭按钮之前添加最大化按钮
	self.MaximizeButton = vgui.Create("DButton", self.ControlButtons)
	self.MaximizeButton:SetSize(48 * OFGUI.ScreenScale, 24 * OFGUI.ScreenScale)
	self.MaximizeButton:Dock(RIGHT)
	self.MaximizeButton:DockMargin(4 * OFGUI.ScreenScale, 4 * OFGUI.ScreenScale, 0, 4 * OFGUI.ScreenScale)
	self.MaximizeButton:SetText("")
	self.MaximizeButton.Paint = function(pnl, w, h)
		local bgColor = pnl:IsHovered() and OFGUI.MaximizePressColor or OFGUI.MaximizeColor
		draw.RoundedBox(4 * OFGUI.ScreenScale, 0, 0, w, h, bgColor)
		
		surface.SetFont("ofgui_big")
		local text = self.Maximized and "❐" or "▭"
		local tw, th = surface.GetTextSize(text)
		surface.SetTextColor(255, 255, 255, 255)
		surface.SetTextPos(w/2 - tw/2, h/2 - th/2)
		surface.DrawText(text)
	end

	-- 添加鼠标悬停事件
	self.MaximizeButton.OnCursorEntered = function()
		OFGUI.PlaySound(OFGUI.ButtonHoverSound) -- 播放悬停声音
	end
	
	self.MaximizeButton.DoClick = function()
		self:ToggleMaximize()
		OFGUI.PlaySound(OFGUI.ButtonClickSound)
	end

	-- 存储原始尺寸和位置
	self.OriginalSize = {
		w = self:GetWide(),
		h = self:GetTall(),
		x = self:GetX(),
		y = self:GetY()
	}
	
	self.Maximized = false

	-- 修改鼠标按下事件以检查是否允许拖拽
	self.TopBar.OnMousePressed = function(_, mouseCode)
		if mouseCode == MOUSE_LEFT and self.CanDrag then
			self.Dragging = {gui.MouseX() - self:GetX(), gui.MouseY() - self:GetY()}
			self:MouseCapture(true)
		end
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

	-- 修改这里，根据最大化状态决定圆角值
	local currentRounded = self.Maximized and 0 or self.Rounded

	if not self.FirstInit or self.LastRounded != currentRounded then
		self.FirstInit = true
		self.LastRounded = currentRounded
		self.PolyMask = surface.PrecacheRoundedRect(0, 0, self:GetWide(), self:GetTall(), currentRounded, 16)
	end

	EZMASK.DrawWithMask(function()
		surface.SetDrawColor(color_white)
		surface.DrawPoly(self.PolyMask)
	end, function()
		if self.FrameBlur then
			surface.DrawPanelBlur(self, 6)
		end
		-- 使用当前圆角值
		draw.RoundedBox(currentRounded, 0, 0, w, h, OFGUI.BGColor)
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
	self.Title:DockMargin(6 * OFGUI.ScreenScale, 2 * OFGUI.ScreenScale, 6 * OFGUI.ScreenScale, 2 * OFGUI.ScreenScale)
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

function PANEL:ToggleMaximize()
	if self.Maximized then
		self:Restore()
	else
		self:Maximize()
	end
end

function PANEL:Maximize()
	-- 保存当前尺寸和位置
	self.OriginalSize = {
		w = self:GetWide(),
		h = self:GetTall(),
		x = self:GetX(),
		y = self:GetY()
	}
	
	-- 设置为全屏尺寸
	self:SetPos(0, 0)
	self:SetSize(ScrW(), ScrH())
	
	self.Maximized = true
	
	-- 重新生成圆角遮罩
	self.FirstInit = false
end

function PANEL:Think()
    if self.Dragging then
        local parent = self:GetParent()
        local mousex = gui.MouseX()
        local mousey = gui.MouseY()
        local x = math.Clamp(mousex - self.Dragging[1], 0, parent:GetWide() - self:GetWide())
        local y = math.Clamp(mousey - self.Dragging[2], 0, parent:GetTall() - self:GetTall())
        self:SetPos(x, y)
    end
end

function PANEL:OnMouseReleased()

	self.Dragging = nil
	-- self.Sizing = nil
	self:MouseCapture( false )

end

function PANEL:Restore()
	-- 恢复原始尺寸和位置
	self:SetSize(self.OriginalSize.w, self.OriginalSize.h)
	self:SetPos(self.OriginalSize.x, self.OriginalSize.y)
	
	self.Maximized = false
	
	-- 重新生成圆角遮罩
	self.FirstInit = false
end

function PANEL:ShowCloseButton(show)
	if IsValid(self.CloseButton) then
		self.CloseButton:SetVisible(show)
	end
end

function PANEL:ShowMaximizeButton(show)
	if IsValid(self.MaximizeButton) then
		self.MaximizeButton:SetVisible(show)
	end
end

-- 添加新的方法来设置是否可以拖拽
function PANEL:SetDraggable(candrag)
	self.CanDrag = candrag
	self.TopBar:SetCursor(candrag and "sizeall" or "arrow")
end

derma.DefineControl("OFFrame", "", PANEL, "EditablePanel")