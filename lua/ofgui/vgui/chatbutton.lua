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
    self.ChatText = ""
    self.Description = ""  -- 添加 Description 属性初始化
    self.Cardicon = ""
    self.ColorA = OFGUI.ButtonColor.a
    self.ColorRegular = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.HoveredColor = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.InnerGlowAlpha = 0  -- 内阴影透明度
    self.IconPadding = 8 * OFGUI.ScreenScale  -- 图标与边缘的水平间距
    self.CornerRadius = 6 * OFGUI.ScreenScale  -- 添加统一的圆角半径
    self.ShowHoverCard = true
    
    -- 默认大小
    self:SetSize(300, 64)

    -- 创建悬浮卡片
    self.HoverCard = vgui.Create("OFCard")  -- 使用 OFCard 作为悬浮卡片
    self.HoverCard:SetVisible( false )  -- 初始隐藏
    self.HoverCard:SetDrawOnTop( true )
end

function PANEL:SetIcon(material)
    if type(material) == "string" then
        material = Material(material)
        self.Icon:SetMaterial(material)
        self.Cardicon = material
    end
end

function PANEL:SetCardIcon(material)
    if type(material) == "string" then
        material = Material(material)
        self.Cardicon = material
    end
end

function PANEL:SetTitle(text)
    self.Title = text
end

function PANEL:SetChatText(text)
    self.ChatText = text
end

function PANEL:SetCardDescription(text)
    self.CardDescription = text
end

function PANEL:SetHoveredColor(color)
    self.HoveredColor = color
end

function PANEL:SetShowHoverCard(show)
    self.ShowHoverCard = show
end

function PANEL:PerformLayout(w, h)
    -- 设置图标的位置和大小
    local iconSize = draw.GetFontHeight("ofgui_medium") * 1.25
    self.Icon:SetPos(self.IconPadding, (h - iconSize) / 2)
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
    local ChatTextHeight = draw.GetFontHeight("ofgui_medium")
    
    -- 计算文本位置
    local startY = (h - ChatTextHeight) / 2
    local ChatTextX = self.IconPadding * 2 + self.Icon:GetWide()
    
    -- 绘制标题和描述
    draw.SimpleText(self.ChatText, "ofgui_medium", ChatTextX, startY, OFGUI.ButtonTextColor)
end

-- 继承原有按钮的声音效果
function PANEL:OnDepressed()
    OFGUI.PlaySound(OFGUI.ButtonClickSound)
end

function PANEL:OnCursorEntered()
    if self:GetDisabled() then return end
    OFGUI.PlaySound(OFGUI.ButtonHoverSound)

    if self.ShowHoverCard ~= false then
        self.HoverCard:SetVisible(true)
        self.HoverCard:SetTitle(self.Title)
        self.HoverCard:SetDescription(self.CardDescription or self.ChatText)
        self.HoverCard:SetIcon(self.Cardicon)
        self.HoverCard:SetSize(213 * OFGUI.ScreenScale, 296 * OFGUI.ScreenScale)
    end
end

function PANEL:OnCursorExited()
    -- 隐藏悬浮卡片
    self.HoverCard:SetVisible(false)
end

function PANEL:Think()
    -- 更新悬浮卡片的位置
    if self.HoverCard:IsVisible() then

        local x, y = input.GetCursorPos()
        local w, h = self.HoverCard:GetSize()
    
        local lx, ly = self:LocalToScreen( 0, 0 )
    
        y = y - 8 * OFGUI.ScreenScale
    
        y = math.min( y, ly - h - 8 * OFGUI.ScreenScale )
        if ( y < 2 ) then y = 2 end
    
        -- Fixes being able to be drawn off screen
        self.HoverCard:SetPos( math.Clamp( x - w * 0.5, 0, ScrW() - self.HoverCard:GetWide() ), math.Clamp( y, 0, ScrH() - self.HoverCard:GetTall() ) )
    end
end

-- 添加设置圆角半径的方法
function PANEL:SetCornerRadius(radius)
    self.CornerRadius = radius
end

function PANEL:OnRemove()
    -- 移除悬浮卡片
    if IsValid(self.HoverCard) then
        self.HoverCard:Remove()
    end
end

derma.DefineControl("OFChatButton", "A transparent button with border and icon for chat", PANEL, "DButton") 