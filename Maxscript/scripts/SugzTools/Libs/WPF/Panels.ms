-- Set most of the properties and event handlers for a System.Windows.Controls.Panel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Panel
	_panel
	background:
	clipToBounds:
	contextMenu:
	cursor:
	focusable:
	height:
	hAlign:
	isEnabled:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	opacity:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	snapsToDevicePixels:
	tag:
	tooltip:
	uid:
	useLayoutRounding:
	vAlign:
	visibility:
	width:
	initialized:
	isEnabledChanged:
	keyDown:
	keyUp:
	loaded:
	mouseDoubleClick:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel:
	sizeChanged: =
(
   /*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	if spacingAll != unsupplied then _spacing.Setall _panel spacingAll
	if spacingHorizontal != unsupplied then _spacing.SetHorizontal _panel spacingHorizontal
	if spacingLeaveLastItem != unsupplied then _spacing.SetLeaveLastItem _panel spacingLeaveLastItem
	if spacingVertical != unsupplied then _spacing.SetVertical _panel spacingVertical

	ContentControl \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
	focusable:focusable \
	height:height \
	hAlign:hAlign \
	isEnabled:isEnabled \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	opacity:opacity \
	snapsToDevicePixels:snapsToDevicePixels \
	tag:tag \
	tooltip:tooltip \
	uid:uid \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	initialized:initialized \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	loaded:loaded \
	mouseDoubleClick:mouseDoubleClick \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel \
	sizeChanged:sizeChanged
),



fn StackPanel
	orientation:
	background:
	clipToBounds:
	contextMenu:
	cursor:
	focusable:
	height:
	hAlign:
	isEnabled:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	opacity:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	snapsToDevicePixels:
	tag:
	tooltip:
	uid:
	useLayoutRounding:
	vAlign:
	visibility:
	width:
	initialized:
	isEnabledChanged:
	keyDown:
	keyUp:
	loaded:
	mouseDoubleClick:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel:
	sizeChanged: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "System.Windows.Controls.StackPanel"
	if orientation != unsupplied then _panel.Orientation = Enums.Orientation orientation

	Panel \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
	focusable:focusable \
	height:height \
	hAlign:hAlign \
	isEnabled:isEnabled \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	opacity:opacity \
	spacingAll:spacingAll\
	spacingHorizontal:spacingHorizontal\
	spacingLeaveLastItem:spacingLeaveLastItem\
	spacingVertical:spacingVertical\
	snapsToDevicePixels:snapsToDevicePixels \
	tag:tag \
	tooltip:tooltip \
	uid:uid \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	initialized:initialized \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	loaded:loaded \
	mouseDoubleClick:mouseDoubleClick \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel \
	sizeChanged:sizeChanged
),




fn UniformGrid
	columns:
	rows:
	background:
	clipToBounds:
	contextMenu:
	cursor:
	focusable:
	height:
	hAlign:
	isEnabled:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	opacity:
	spacingAll:
	spacingHorizontal:
	spacingLeaveLastItem:
	spacingVertical:
	snapsToDevicePixels:
	tag:
	tooltip:
	uid:
	useLayoutRounding:
	vAlign:
	visibility:
	width:
	initialized:
	isEnabledChanged:
	keyDown:
	keyUp:
	loaded:
	mouseDoubleClick:
	mouseDown:
	mouseEnter:
	mouseLeave:
	mouseLeftButtonDown:
	mouseLeftButtonUp:
	mouseMove:
	mouseRightButtonDown:
	mouseRightButtonUp:
	mouseUp:
	mouseWheel:
	sizeChanged: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	_panel = dotNetObject "System.Windows.Controls.Primitives.UniformGrid"
	if rows != unsupplied then _panel.Rows = rows
	if columns != unsupplied then _panel.Columns = columns

	Panel \
	_panel \
	background:background \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
	focusable:focusable \
	height:height \
	hAlign:hAlign \
	isEnabled:isEnabled \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	opacity:opacity \
	spacingAll:spacingAll\
	spacingHorizontal:spacingHorizontal\
	spacingLeaveLastItem:spacingLeaveLastItem\
	spacingVertical:spacingVertical\
	snapsToDevicePixels:snapsToDevicePixels \
	tag:tag \
	tooltip:tooltip \
	uid:uid \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	visibility:visibility \
	width:width \
	initialized:initialized \
	isEnabledChanged:isEnabledChanged \
	keyDown:keyDown \
	keyUp:keyUp \
	loaded:loaded \
	mouseDoubleClick:mouseDoubleClick \
	mouseDown:mouseDown \
	mouseEnter:mouseEnter \
	mouseLeave:mouseLeave \
	mouseLeftButtonDown:mouseLeftButtonDown \
	mouseLeftButtonUp:mouseLeftButtonUp \
	mouseMove:mouseMove \
	mouseRightButtonDown:mouseRightButtonDown \
	mouseRightButtonUp:mouseRightButtonUp \
	mouseUp:mouseUp \
	mouseWheel:mouseWheel \
	sizeChanged:sizeChanged
)



