local PANEL = {}

function PANEL:Init()

    self:SetExpensiveShadow(1, ColorAlpha(color_black, 140))

    self.Icon = vgui.Create("DImage", self)
    self.IconPadding = 10 * OFGUI.ScreenScale  -- 设置图标的内边距

    self.TitleLabel = vgui.Create("DLabel", self)
    self.DescriptionLabel = vgui.Create("DLabel", self)

    self.TitleLabel:SetFont("ofgui_medium")
    self.TitleLabel:SetText("")
    self.TitleLabel:SetContentAlignment(5)  -- 居中对齐

    self.DescriptionLabel:SetFont("ofgui_tiny")
    self.DescriptionLabel:SetText("")
    self.DescriptionLabel:SetWrap(true)  -- 允许换行
    self.DescriptionLabel:SetContentAlignment(5)  -- 居中对齐
    self.DescriptionLabel:SetAutoStretchVertical(true)  -- 添加此行以允许竖直方向自适应

    -- 设置默认属性
    self.Title = ""
    self.Description = ""
    self.Color = Color(OFGUI.ButtonColor.r, OFGUI.ButtonColor.g, OFGUI.ButtonColor.b, OFGUI.ButtonColor.a)
    self.InnerGlowAlpha = 0  -- 内阴影透明度
    self.CornerRadius = 6  -- 添加统一的圆角半径
    
    -- 默认大小
    self:SetSize(300, 64)

    self.TitleLabel:SetTextColor(Color(255, 255, 255, 255))  -- 设置标题颜色为白色
    self.DescriptionLabel:SetTextColor(Color(255, 255, 255, 255))  -- 设置描述颜色为白色
end

function PANEL:SetIcon(material)
    if type(material) == "string" then
        material = Material(material)
    end
    self.Icon:SetMaterial(material)
end

function PANEL:SetTitle(text)
    self.TitleLabel:SetText(text)
end

function PANEL:SetDescription(text)
    self.DescriptionLabel:SetText(text)
end

function PANEL:PerformLayout(w, h)
    -- 设置图标的位置和大小
    local iconSize = w - self.IconPadding * 2
    self.Icon:SetPos(self.IconPadding, self.IconPadding)  -- 图标左对齐并保持内边距
    self.Icon:SetSize(iconSize, iconSize)

    -- 设置标题和描述的位置和大小
    local titleHeight = draw.GetFontHeight("ofgui_medium")
    local descHeight = draw.GetFontHeight("ofgui_tiny")
    local startY = self.IconPadding + iconSize + self.IconPadding  -- 图标下方的起始Y坐标

    self.TitleLabel:SetSize(w, titleHeight)
    self.TitleLabel:SetPos(0, startY)  -- 标题位置

    -- 修改描述的宽度和位置以添加左右间距
    local padding = 10 * OFGUI.ScreenScale  -- 设置左右间距
    self.DescriptionLabel:SetSize(w - padding * 2, h - startY - self.IconPadding)  -- 移除此行以不限制描述的高度
    self.DescriptionLabel:SetPos(padding, startY + titleHeight + 5)  -- 描述位置
end

function PANEL:Paint(w, h)
    draw.RoundedBox(self.CornerRadius, 0, 0, w, h, self.Color)
    
    -- 绘制标题和描述
    self.TitleLabel:PaintManual()  -- 手动绘制标题
    self.DescriptionLabel:PaintManual()  -- 手动绘制描述
end

function PANEL:SetCornerRadius(radius)
    self.CornerRadius = radius
end

derma.DefineControl("OFCard", "A transparent panel with border and icon for skills", PANEL, "DPanel") 
