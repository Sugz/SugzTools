-- Set most of the properties and event handlers for a System.Windows.Controls.Panel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Panel
	_panel
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	if background != unsupplied then _panel.background = SolidColorBrush background
	if clipToBounds != unsupplied then _panel.ClipToBounds = clipToBounds
	if cursor != unsupplied then _panel.Cursor = this.Cursor cursor
	if dock != unsupplied then _dock.SetDock _panel (Enums.Dock dock)
	if hAlign != unsupplied then _panel.HorizontalAlignment = Enums.HorizontalAlignment hAlign
	if height != unsupplied then _panel.Height = height
	if margin != unsupplied then _panel.Margin = Thickness margin
	if name != unsupplied then _panel.Name = name
	if spacingAll != unsupplied then _spacing.Setall _panel spacingAll
	if spacingHorizontal != unsupplied then _spacing.SetHorizontal _panel spacingHorizontal
	if spacingLeaveLastItem != unsupplied then _spacing.SetLeaveLastItem _panel spacingLeaveLastItem
	if spacingVertical != unsupplied then _spacing.SetVertical _panel spacingVertical
	if tag != unsupplied then _panel.Tag = tag
	if vAlign != unsupplied then _panel.VerticalAlignment = Enums.VerticalAlignment vAlign
	if visibility != unsupplied then _panel.Visibility = Enums.Visibility visibility
	if width != unsupplied then _panel.Width = width
	if loaded != unsupplied then dotNet.addEventHandler _panel "Loaded" loaded

	dotNet.setLifetimeControl _panel #dotnet

	_panel
),


-- Return a SugzTools.Controls.SgzCanvas ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Canvas
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	Panel \
	(dotNetObject "SugzTools.Controls.SgzCanvas") \
	background:background \
	clipToBounds:clipToBounds \
	cursor:cursor \
	dock: dock \
	hAlign:hAlign \
	height:height \
	margin:margin \
	name:name \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	tag:tag \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	loaded:loaded
),


-- Return a SugzTools.Controls.SgzDockPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn DockPanel
	lastChildFill:
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzDockPanel"
	if lastChildFill != unsupplied then _panel.LastChildFill = lastChildFill

	Panel \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	cursor:cursor \
	dock: dock \
	hAlign:hAlign \
	height:height \
	margin:margin \
	name:name \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	tag:tag \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	loaded:loaded
),


-- Return a SugzTools.Controls.SgzGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Grid
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	Panel \
	(dotNetObject "SugzTools.Controls.SgzGrid") \
	background:background \
	clipToBounds:clipToBounds \
	cursor:cursor \
	dock: dock \
	hAlign:hAlign \
	height:height \
	margin:margin \
	name:name \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	tag:tag \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	loaded:loaded
),


-- Return a SugzTools.Controls.SgzUniformGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn UniformGrid
	columns:
	rows:
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzUniformGrid"
	if rows != unsupplied then _panel.Rows = rows
	if columns != unsupplied then _panel.Columns = columns

	Panel \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	cursor:cursor \
	dock: dock \
	hAlign:hAlign \
	height:height \
	margin:margin \
	name:name \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	tag:tag \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	loaded:loaded
),


-- Return a SugzTools.Controls.SgzStackPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn StackPanel
	orientation:
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzStackPanel"
	if orientation != unsupplied then _panel.Orientation = Enums.Orientation orientation
	if background != unsupplied then _panel.background = SolidColorBrush background
	if clipToBounds != unsupplied then _panel.ClipToBounds = clipToBounds
	if cursor != unsupplied then _panel.Cursor = this.Cursor cursor
	if dock != unsupplied then _dock.SetDock _panel (Enums.Dock dock)
	if hAlign != unsupplied then _panel.HorizontalAlignment = Enums.HorizontalAlignment hAlign
	if height != unsupplied then _panel.Height = height
	if margin != unsupplied then _panel.Margin = Thickness margin
	if name != unsupplied then _panel.Name = name
	if spacingAll != unsupplied then _spacing.Setall _panel spacingAll
	if spacingHorizontal != unsupplied then _spacing.SetHorizontal _panel spacingHorizontal
	if spacingLeaveLastItem != unsupplied then _spacing.SetLeaveLastItem _panel spacingLeaveLastItem
	if spacingVertical != unsupplied then _spacing.SetVertical _panel spacingVertical
	if tag != unsupplied then _panel.Tag = tag
	if vAlign != unsupplied then _panel.VerticalAlignment = Enums.VerticalAlignment vAlign
	if visibility != unsupplied then _panel.Visibility = Enums.Visibility visibility
	if width != unsupplied then _panel.Width = width
-- 	if loaded != unsupplied then dotNet.addEventHandler _panel "Loaded" loaded

	dotNet.setLifetimeControl _panel #dotnet
	
	_panel
),


-- Return a SugzTools.Controls.SgzWrapPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn WrapPanel
	itemHeight:
	itemwidth:
	orientation:
	background:
	clipToBounds:
	cursor:
	dock:
	hAlign:
	height:
	margin:
	name:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	tag:
	vAlign:
	visibility:
	width:
	loaded: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzWrapPanel"
	if itemHeight != unsupplied then _panel.ItemHeight = itemHeight
	if itemWidth != unsupplied then _panel.ItemWidth = itemWidth
	if orientation != unsupplied then _panel.Orientation = Enums.Orientation orientation

	Panel \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	cursor:cursor \
	dock: dock \
	hAlign:hAlign \
	height:height \
	margin:margin \
	name:name \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	tag:tag \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	loaded:loaded
)
