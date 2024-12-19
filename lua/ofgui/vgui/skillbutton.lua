local PANEL = {}

function PANEL:Init()
    -- 继承基础按钮的属性
    self:SetFont("ofgui_medium")
    self:SetText("")
    self:SetTooltipPanelOverride("OFTooltip")
    self:SetDoubleClickingEnabled(false)
    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    -- 创建图标
    self.Icon = vgui.Create("DImage", self)
    
    -- 设置默认属性
    self.Title = ""
    self.Description = ""
    self.ColorA = OFGUI.ButtonColor.a
    self.ColorRegular = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.HoveredColor = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.InnerGlowAlpha = 0  -- 内阴影透明度
    self.IconPadding = 8  -- 图标与边缘的间距
    self.CornerRadius = 6  -- 添加统一的圆角半径
    
    -- 默认大小
    self:SetSize(300, 64)
end

function PANEL:SetIcon(material)
    if type(material) == "string" then
        material = Material(material)
    end
    self.Icon:SetMaterial(material)
end

function PANEL:SetTitle(text)
    self.Title = text
end

function PANEL:SetDescription(text)
    self.Description = text
end

function PANEL:SetHoveredColor(color)
    self.HoveredColor = color
end

function PANEL:PerformLayout(w, h)
    -- 设置图标的位置和大小
    local iconSize = h - (self.IconPadding * 2)
    self.Icon:SetPos(self.IconPadding, self.IconPadding)
    self.Icon:SetSize(iconSize, iconSize)
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
        local targetColor = self.ColorRegular
        self.Color.r = Lerp(7.5 * FrameTime(), self.Color.r, targetColor.r)
        self.Color.g = Lerp(7.5 * FrameTime(), self.Color.g, targetColor.g)
        self.Color.b = Lerp(7.5 * FrameTime(), self.Color.b, targetColor.b)
        self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA)
    end

    if self:IsDown() then
        self.Color.a = Lerp(7.5 * FrameTime(), self.Color.a, self.ColorA + 25)
    end

    -- 绘制背景
    draw.RoundedBox(self.CornerRadius, 0, 0, w, h, self.Color)
    
    -- 计算文本高度
    local titleHeight = draw.GetFontHeight("ofgui_medium")
    local descHeight = draw.GetFontHeight("ofgui_tiny")
    local totalTextHeight = titleHeight + descHeight + 5
    
    -- 计算文本位置
    local startY = (h - totalTextHeight) / 2
    local titleX = h + 10
    
    -- 绘制标题和描述
    draw.SimpleText(self.Title, "ofgui_medium", titleX, startY, OFGUI.ButtonTextColor)
    draw.SimpleText(self.Description, "ofgui_tiny", titleX, startY + titleHeight + 5, OFGUI.ButtonTextColor)
end

-- 继承原有按钮的声音效果
function PANEL:OnDepressed()
    OFGUI.PlaySound(OFGUI.ButtonClickSound)
end

function PANEL:OnCursorEntered()
    if self:GetDisabled() then return end
    OFGUI.PlaySound(OFGUI.ButtonHoverSound)
end

-- 添加设置圆角半径的方法
function PANEL:SetCornerRadius(radius)
    self.CornerRadius = radius
end

derma.DefineControl("OFSkillButton", "A transparent button with border and icon for skills", PANEL, "DButton") 