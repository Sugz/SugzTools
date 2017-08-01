/*CodeDoc do not include */

-- Set most of the properties and event handlers for a System.Windows.Controls.Panel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Panel
	_panel
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	if background != unsupplied then _panel.background = SolidColorBrush background
	if spacingAll != unsupplied then _spacing.SetAll _panel (Thickness spacingAll)
	if spacingHorizontal != unsupplied then _spacing.SetHorizontal _panel spacingHorizontal
	if spacingLeaveLastItem != unsupplied then _spacing.SetLeaveLastItem _panel spacingLeaveLastItem
	if spacingVertical != unsupplied then _spacing.SetVertical _panel spacingVertical

	FrameworkElement \
	_panel\
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzCanvas ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Canvas
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
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
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzDockPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn DockPanel
	lastChildFill:
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
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
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Grid
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
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
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzUniformGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn UniformGrid
	columns:
	rows:
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzUniformGrid"
	if columns != unsupplied then _panel.Columns = columns
	if rows != unsupplied then _panel.Rows = rows
	

	Panel \
	_panel \
	background:background \
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzStackPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn StackPanel
	orientation:
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "SugzTools.Controls.SgzStackPanel"
	if orientation != unsupplied then _panel.Orientation = Enums.Orientation orientation
	
	Panel \
	_panel \
	background:background \
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a SugzTools.Controls.SgzWrapPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn WrapPanel
	itemHeight:
	itemwidth:
	orientation:
	background:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
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
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	spacingAll:spacingAll \
	spacingHorizontal:spacingHorizontal \
	spacingLeaveLastItem:spacingLeaveLastItem \
	spacingVertical:spacingVertical \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),


-- Return a System.Windows.Controls.Border ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Border 
	background:
	borderBrush:
	borderThickness:
	child:
	cornerRadius:
	padding:
	contextMenu:
	cursor:
	dock:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "System.Windows.Controls.Border"
	
	if background != unsupplied then _control.background = SolidColorBrush background
	if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
	if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
	if child != unsupplied then _control.Child = child
	if cornerRadius != unsupplied then _control.CornerRadius = this.CornerRadius cornerRadius
	if padding != unsupplied then _control.Padding = Thickness padding

	FrameworkElement \
	_control\
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
),




-- Return a SugzTools.Controls.SgzPopup ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Popup
	allowsTransparency:
	background:
	borderBrush:
	borderThickness:
	child:
	content:
	cornerRadius:
	horizontalOffset:
	isOpen:
	placement:
	placementRectangle:
	placementTarget:
	popupAnimation:
	staysOpen:
	verticalOffset:

	contextMenu:
	cursor:
	height:
	hAlign:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	tag:
	tooltip:
	useLayoutRounding:
	vAlign:
	width:
	initialized:
	loaded:
	sizeChanged:
	clipToBounds:
	dock:
	focusable:
	isEnabled:
	opacity:
	snapsToDevicePixels:
	uid:
	visibility:
	isEnabledChanged:
	keyDown:
	keyUp:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzPopup"
	if allowsTransparency != unsupplied then _control.allowsTransparency = allowsTransparency
	if background != unsupplied then _control.background = SolidColorBrush background
	if borderBrush != unsupplied then _control.borderBrush = SolidColorBrush borderBrush
	if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
	if content != unsupplied then _control.content = content
	if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
	if horizontalOffset != unsupplied then _control.horizontalOffset = horizontalOffset
	if isOpen != unsupplied then _control.isOpen = isOpen
	if placement != unsupplied then _control.placement = Enums.PlacementMode placement
	if placementRectangle != unsupplied then _control.placementRectangle = placementRectangle
	if placementTarget != unsupplied then _control.placementTarget = placementTarget
-- 	if popupAnimation != unsupplied then _control.popupAnimation = popupAnimation
	if staysOpen != unsupplied then _control.staysOpen = staysOpen
	if verticalOffset != unsupplied then _control.verticalOffset = verticalOffset
	
	FrameworkElement \
	_control\
	contextMenu:contextMenu \
	cursor:cursor \
	height:height \
	hAlign:hAlign \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	tag:tag \
	tooltip:tooltip \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	width:width \
	initialized:initialized \
	loaded:loaded \
	sizeChanged:sizeChanged \
	clipToBounds:clipToBounds \
	dock:dock \
	focusable:focusable \
	isEnabled:isEnabled \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	uid:uid \
	visibility:visibility \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel
)