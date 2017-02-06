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
	innerMargin:
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
	if innerMargin != unsupplied then _innerMargin.SetValue _panel (Thickness innerMargin)
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




