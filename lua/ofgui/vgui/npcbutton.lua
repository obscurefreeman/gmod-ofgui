local PANEL = {}

function PANEL:Init()
    -- 继承基础按钮的属性
    self:SetFont("ofgui_medium")
    self:SetText("")
    self:SetTooltipPanelOverride("OFTooltip")
    self:SetDoubleClickingEnabled(false)
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    -- 创建模型图标
    self.ModelIcon = vgui.Create("ModelImage", self)
    self.ModelIcon:SetMouseInputEnabled( false )
	self.ModelIcon:SetKeyboardInputEnabled( false )
    
    -- 设置默认颜色
    self.ColorA = OFGUI.ButtonColor.a
    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.HoveredColor = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)  -- 添加悬停颜色
    
    -- 默认文本
    self.Title = ""
    self.Description = ""
    
    -- 默认大小
    self:SetSize(300, 64)

    -- 创建徽章元素
    self.Badge = vgui.Create("DImage", self)
    self.Badge:SetSize(23 * OFGUI.ScreenScale, 23 * OFGUI.ScreenScale)
    self.Badge:SetVisible(false) -- 默认隐藏徽章
end

function PANEL:SetModel(mdl)
    self.ModelIcon:SetModel(mdl)
end

function PANEL:RebuildSpawnIcon()
	self.ModelIcon:RebuildSpawnIcon()
end

function PANEL:SetTitle(text)
    self.Title = text
end

function PANEL:SetDescription(text)
    self.Description = text
end

function PANEL:SetBadge(image)
    if image then
        self.Badge:SetImage(image)
        self.Badge:SetVisible(true)
    else
        self.Badge:SetVisible(false)
    end
end

function PANEL:PerformLayout(w, h)
    -- 设置模型图标的位置和大小
    self.ModelIcon:SetPos(0, 0)
    self.ModelIcon:SetSize(h, h)
end

function PANEL:Paint(w, h)
    -- 背景动画效果
    if self:IsHovered() then
        local targetColor = self.HoveredColor
        self.Color.r = Lerp(7.5 * FrameTime(), self.Color.r, targetColor.r)
        self.Color.g = Lerp(7.5 * FrameTime(), self.Color.g, targetColor.g)
        self.Color.b = Lerp(7.5 * FrameTime(), self.Color.b, targetColor.b)
        self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA + 15)
    else
        local targetColor = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
        self.Color.r = Lerp(7.5 * FrameTime(), self.Color.r, targetColor.r)
        self.Color.g = Lerp(7.5 * FrameTime(), self.Color.g, targetColor.g)
        self.Color.b = Lerp(7.5 * FrameTime(), self.Color.b, targetColor.b)
        self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA)
    end

    if self:IsDown() then
        self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA + 25)
    end

    -- 绘制背景
    draw.RoundedBox(6, 0, 0, w, h, self.Color)
    
    -- 计算文本高度
    local titleHeight = draw.GetFontHeight("ofgui_medium")
    local descHeight = draw.GetFontHeight("ofgui_tiny")
    local totalTextHeight = titleHeight + descHeight + 5 * OFGUI.ScreenScale  -- 5是标题和描述之间的间距

    if self.Badge:IsVisible() then
        self.Badge:SetPos(h + 10 * OFGUI.ScreenScale, (h - totalTextHeight) / 2)
    end
    
    -- 计算整体文本块的起始Y坐标，使其垂直居中
    local startY = (h - totalTextHeight) / 2
    
    -- 文本X坐标调整
    local titleX = (self.Badge:IsVisible() and self.Badge:GetWide() or 0) + h + 10 * OFGUI.ScreenScale
    
    -- 绘制标题和描述
    draw.SimpleText(self.Title, "ofgui_medium", titleX, startY, OFGUI.ButtonTextColor)
    draw.SimpleText(self.Description, "ofgui_tiny", h + 10 * OFGUI.ScreenScale, startY + titleHeight + 5, OFGUI.ButtonTextColor)
end

-- 继承原有按钮的声音效果
function PANEL:OnDepressed()
    OFGUI.PlaySound(OFGUI.ButtonClickSound)
end

function PANEL:OnCursorEntered()
    if self:GetDisabled() then return end
    OFGUI.PlaySound(OFGUI.ButtonHoverSound)
end

function PANEL:SetAccentColor(clr)
    self.ColorA = 90
    self.Color = clr
end

-- 添加设置悬停颜色的方法
function PANEL:SetHoveredColor(color)
    self.HoveredColor = color
end

derma.DefineControl("OFNPCButton", "A button with model icon and description", PANEL, "DButton") 