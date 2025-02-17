local PANEL = {}

AccessorFunc( PANEL, "m_iSpaceX",		"SpaceX" )
AccessorFunc( PANEL, "m_iSpaceY",		"SpaceY" )
AccessorFunc( PANEL, "m_iBorder",		"Border" )
AccessorFunc( PANEL, "m_iLayoutDir",	"LayoutDir" )

AccessorFunc( PANEL, "m_bStretchW",		"StretchWidth", FORCE_BOOL )
AccessorFunc( PANEL, "m_bStretchH",		"StretchHeight", FORCE_BOOL )

function PANEL:Init()

	self:SetDropPos( "46" )

	self:SetSpaceX( 0 )
	self:SetSpaceY( 0 )
	self:SetBorder( 0 )
	self:SetLayoutDir( TOP )

	self:SetStretchWidth( false )
	self:SetStretchHeight( true )

	self.LastW = 0
	self.LastH = 0

end

function PANEL:Layout()

	self.LastW = 0
	self.LastH = 0
	self:InvalidateLayout()

end

function PANEL:LayoutIcons_TOP()

	local x = self.m_iBorder
	local y = self.m_iBorder
	local RowHeight = 0
	local MaxWidth = self:GetWide() - self.m_iBorder
	local RowStartX = x
	local RowChildren = {}
	local Rows = {} -- 存储每一行的信息

	for k, v in ipairs( self:GetChildren() ) do

		if ( !v:IsVisible() ) then continue end

		local w, h = v:GetSize()
		if ( x + w > MaxWidth || ( v.OwnLine && x > self.m_iBorder ) ) then

			-- 记录当前行的信息
			table.insert(Rows, {
				children = RowChildren,
				width = x - RowStartX - self.m_iSpaceX,
				height = RowHeight,
				startX = RowStartX,
				y = y
			})

			-- 重置行变量
			x = self.m_iBorder
			y = y + RowHeight + self.m_iSpaceY
			RowHeight = 0
			RowStartX = x
			RowChildren = {}

		end

		v:SetPos( x, y )
		v.x = x
		v.y = y
		table.insert(RowChildren, v)

		x = x + v:GetWide() + self.m_iSpaceX
		RowHeight = math.max( RowHeight, v:GetTall() )

		-- 如果该元素需要独占一行
		if ( v.OwnLine ) then
			x = MaxWidth + 1
		end

	end

	-- 记录最后一行
	if #RowChildren > 0 then
		table.insert(Rows, {
			children = RowChildren,
			width = x - RowStartX - self.m_iSpaceX,
			height = RowHeight,
			startX = RowStartX,
			y = y
		})
	end

	-- 计算所有行的最大宽度
	local maxRowWidth = 0
	for _, row in ipairs(Rows) do
		if row.width > maxRowWidth then
			maxRowWidth = row.width
		end
	end

	-- 整体居中偏移量
	local offsetX = (MaxWidth - maxRowWidth) / 2

	-- 应用整体居中偏移
	for _, row in ipairs(Rows) do
		for _, child in ipairs(row.children) do
			child:SetPos(child.x + offsetX, child.y)
		end
	end

end

function PANEL:LayoutIcons_LEFT()

	local x = self.m_iBorder
	local y = self.m_iBorder
	local RowWidth = 0
	local MaxHeight = self:GetTall() - self.m_iBorder

	for k, v in ipairs( self:GetChildren() ) do

		if ( !v:IsVisible() ) then continue end

		local w, h = v:GetSize()
		if ( y + h > MaxHeight || ( v.OwnLine && y > self.m_iBorder ) ) then

			y = self.m_iBorder
			x = x + RowWidth + self.m_iSpaceX
			RowWidth = 0

		end

		v:SetPos( x, y )

		y = y + v:GetTall() + self.m_iSpaceY
		RowWidth = math.max( RowWidth, v:GetWide() )

		-- 如果该元素需要独占一行
		if ( v.OwnLine ) then
			y = MaxHeight + 1
		end

	end

end

function PANEL:PerformLayout()

	local ShouldLayout = false

	if ( self.LastW != self:GetWide() ) then ShouldLayout = true end
	if ( self.LastH != self:GetTall() ) then ShouldLayout = true end

	self.LastW = self:GetWide()
	self.LastH = self:GetTall()

	if ( ShouldLayout ) then

		if ( self.m_iLayoutDir == LEFT ) then self:LayoutIcons_LEFT() end
		if ( self.m_iLayoutDir == TOP ) then self:LayoutIcons_TOP() end

	end

	self:SizeToChildren( self:GetStretchWidth(), self:GetStretchHeight() )

end

function PANEL:OnModified()

	-- Override me

end

function PANEL:OnChildRemoved()

	self:Layout()

end

function PANEL:OnChildAdded( child )

	local dn = self:GetDnD()
	if ( dn ) then
		child:Droppable( self:GetDnD() )
	end

	if ( self:IsSelectionCanvas() ) then
		child:SetSelectable( true )
	end

	self:Layout()

end

function PANEL:Copy()

	local copy = vgui.Create( "OFIconLayout", self:GetParent() )
	copy:CopyBase( self )
	copy:SetSortable( self:GetSortable() )
	copy:SetDnD( self:GetDnD() )
	copy:SetSpaceX( self:GetSpaceX() )
	copy:SetSpaceX( self:GetSpaceX() )
	copy:SetSpaceY( self:GetSpaceY() )
	copy:SetBorder( self:GetBorder() )
	copy:SetSelectionCanvas( self:GetSelectionCanvas() )
	copy.OnModified = self.OnModified

	copy:CopyContents( self )

	return copy

end

function PANEL:CopyContents( from )

	for k, v in ipairs( from:GetChildren() ) do

		v:Copy():SetParent( self )

	end

end

function PANEL:GenerateExample( ClassName, PropertySheet, Width, Height )

	local pnl = vgui.Create( ClassName )
	pnl:MakeDroppable( "ExampleDraggable", false )
	pnl:SetSize( 200, 200 )
	pnl:SetUseLiveDrag( true )
	pnl:SetSelectionCanvas( true )
	pnl:SetSpaceX( 4 )
	pnl:SetSpaceY( 4 )

	for i = 1, 32 do

		local btn = pnl:Add( "DButton" )
		btn:SetSize( 32, 32 )
		btn:SetText( i )

	end

	PropertySheet:AddSheet( ClassName, pnl, nil, true, true )

end

derma.DefineControl( "OFIconLayout", "", PANEL, "DDragBase" )