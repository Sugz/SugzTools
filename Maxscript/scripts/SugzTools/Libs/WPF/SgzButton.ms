-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn SgzButton
	isTransparent:
	hoverBrush:
	pressedBrush:
	click:
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	contextMenu:
	cursor:
	content:
	cornerRadius:
	focusable:
	fontFamily:
	fontSize:
	fontStretch:
	fontStyle:
	fontWeight:
	foreground:
	height:
	hAlign:
	hContentAlign:
	isEnabled:
	isTabStop:
	margin:
	maxHeight:
	maxWidth:
	minHeight:
	minWidth:
	name:
	opacity:
	padding:
	snapsToDevicePixels:
	tabIndex:
	tag:
	tooltip:
	uid:
	useLayoutRounding:
	vAlign:
	vContentAlign:
	visibility:
	width:
	initialized:
	isEnabledChanged:
	loaded:
	keyDown:
	keyUp:
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
		Return a Button
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzButton"
	if isTransparent != unsupplied then _control.IsTransparent = isTransparent
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if pressedBrush != unsupplied then _control.PressedBrush = SolidColorBrush pressedBrush
	if click != unsupplied then dotNet.addEventHandler _control "Click" click
	
	ContentControl \
	_control \
	background:background \
	borderbrush:borderbrush \
	borderthickness:borderthickness \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
	content:content \
	cornerRadius:cornerRadius \
	focusable:focusable \
	fontFamily:fontFamily \
	fontSize:fontSize \
	fontStretch:fontStretch \
	fontStyle:fontStyle \
	fontWeight:fontWeight \
	foreground:foreground \
	height:height \
	hAlign:hAlign \
	hContentAlign:hContentAlign \
	isEnabled:isEnabled \
	isTabStop:isTabStop \
	margin:margin \
	maxHeight:maxHeight \
	maxWidth:maxWidth \
	minHeight:minHeight \
	minWidth:minWidth \
	name:name \
	opacity:opacity \
	padding:padding \
	snapsToDevicePixels:snapsToDevicePixels \
	tabIndex:tabIndex \
	tag:tag \
	tooltip:tooltip \
	uid:uid \
	useLayoutRounding:useLayoutRounding \
	vAlign:vAlign \
	vContentAlign:vContentAlign \
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