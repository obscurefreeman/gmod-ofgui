local PANEL = {}

-- 绘制圆角矩形描边
local function DrawRoundedBoxEx(radius, x, y, w, h, color, tl, tr, bl, br)
    -- 设置绘制颜色
    surface.SetDrawColor(color)
    
    -- 绘制四条边
    -- 上边
    surface.DrawRect(x + radius, y, w - radius * 2, 1)
    -- 下边
    surface.DrawRect(x + radius, y + h - 1, w - radius * 2, 1)
    -- 左边
    surface.DrawRect(x, y + radius, 1, h - radius * 2)
    -- 右边
    surface.DrawRect(x + w - 1, y + radius, 1, h - radius * 2)
    
    -- 绘制四个圆角
    local function drawCorner(startang, endang, centerx, centery)
        for i = startang, endang, 2 do
            local rad = math.rad(i)
            local px = centerx + math.cos(rad) * radius
            local py = centery + math.sin(rad) * radius
            surface.DrawRect(px, py, 1, 1)
        end
    end
    
    -- 左上角
    if tl then
        drawCorner(180, 270, x + radius, y + radius)
    else
        surface.DrawRect(x, y, radius, 1)
        surface.DrawRect(x, y, 1, radius)
    end
    
    -- 右上角
    if tr then
        drawCorner(270, 360, x + w - radius, y + radius)
    else
        surface.DrawRect(x + w - radius, y, radius, 1)
        surface.DrawRect(x + w - 1, y, 1, radius)
    end
    
    -- 左下角
    if bl then
        drawCorner(90, 180, x + radius, y + h - radius)
    else
        surface.DrawRect(x, y + h - 1, radius, 1)
        surface.DrawRect(x, y + h - radius, 1, radius)
    end
    
    -- 右下角
    if br then
        drawCorner(0, 90, x + w - radius, y + h - radius)
    else
        surface.DrawRect(x + w - radius, y + h - 1, radius, 1)
        surface.DrawRect(x + w - 1, y + h - radius, 1, radius)
    end
end

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
    self.BorderColor = Color(255, 255, 255, 100)  -- 默认描边颜色
    self.InnerGlowAlpha = 0  -- 内阴影透明度
    self.IconPadding = 8  -- 图标与边缘的间距
    self.CornerRadius = 6  -- 添加统一的圆角半径
    
    -- 默认大小
    self:SetSize(300, 64)

    -- 添加动画对象
    self.GlowAnimation = EasyAnim.NewAnimation(0.3, EASE_OutQuart)
    self.GlowAnimation:SetDuration(0.3)
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

function PANEL:SetBorderColor(color)
    self.BorderColor = color
end

function PANEL:PerformLayout(w, h)
    -- 设置图标的位置和大小
    local sidePadding = 10  -- 设置两侧的间距
    local iconSize = w - sidePadding * 2
    self.Icon:SetPos(sidePadding, self.IconPadding)  -- 图标左对齐并保持间距
    self.Icon:SetSize(iconSize, iconSize)

    -- 计算标题和描述的位置
    local titleHeight = draw.GetFontHeight("ofgui_medium")
    local descHeight = draw.GetFontHeight("ofgui_tiny")
    local startY = self.IconPadding + iconSize + 5  -- 图标下方的起始Y坐标

    -- 计算标题和描述的居中位置
    self.TitleX = (w - surface.GetTextSize(self.Title, "ofgui_medium")) / 2
    self.DescX = (w - surface.GetTextSize(self.Description, "ofgui_tiny")) / 2
end

function PANEL:Paint(w, h)
    -- 使用 EasyAnim 处理内阴影动画
    if self:IsHovered() then
        self.InnerGlowAlpha = self.GlowAnimation:AnimTo(50)
    else
        self.InnerGlowAlpha = self.GlowAnimation:AnimTo(0)
    end

    -- 绘制内阴影（当鼠标悬停时）
    if self.InnerGlowAlpha > 0 then
        local glowColor = Color(
            self.BorderColor.r,
            self.BorderColor.g,
            self.BorderColor.b,
            self.InnerGlowAlpha
        )
        draw.RoundedBox(self.CornerRadius, 2, 2, w-4, h-4, glowColor)
    end
    
    -- 绘制描边
    DrawRoundedBoxEx(self.CornerRadius, 0, 0, w, h, self.BorderColor, true, true, true, true)
    
    -- 计算标题和描述的位置
    local titleWidth, titleHeight = surface.GetTextSize(self.Title, "ofgui_medium")
    local descWidth, descHeight = surface.GetTextSize(self.Description, "ofgui_tiny")
    local totalTextHeight = titleHeight + descHeight
    local titleX = (w - titleWidth) / 2  -- 标题居中
    local descX = (w - descWidth) / 2  -- 描述居中
    local startY = self.IconPadding + self.Icon:GetTall() + (h - self.IconPadding - self.Icon:GetTall() - totalTextHeight) / 2  -- 图标下方的起始Y坐标

    -- 绘制标题和描述
    draw.SimpleText(self.Title, "ofgui_medium", titleX, startY, OFGUI.ButtonTextColor)
    draw.SimpleText(self.Description, "ofgui_tiny", descX, startY + titleHeight + 5, OFGUI.ButtonTextColor)
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

derma.DefineControl("OFCard", "A transparent button with border and icon for skills", PANEL, "DButton") 