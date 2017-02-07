-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Textbox
	caretBrush:
	selectionBrush:
	text:
	uiElement0:
	uiElement1:
	uiElement2:
	watermark:
	watermarkFontStyle:
	watermarkForeground:
	validate:
	textChanged:
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	contextMenu:
	cursor:
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
	
	_control = dotNetObject "SugzTools.Controls.SgzMaxTextbox"
	if caretBrush != unsupplied then _control.CaretBrush = SolidColorBrush caretBrush
	if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
	if text != unsupplied then _control.Text = text
	if uiElement0 != unsupplied then _control.UIElement0 = uiElement0
	if uiElement1 != unsupplied then _control.UIElement1 = uiElement1
	if uiElement2 != unsupplied then _control.UIElement2 = uiElement2
	if watermark != unsupplied then _control.Watermark = watermark
	if watermarkFontStyle != unsupplied then _control.WatermarkFontStyle = Enums.FontStyles WatermarkFontStyle
	if watermarkForeground != unsupplied then _control.WatermarkForeground = SolidColorBrush watermarkForeground

	if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
	if textChanged != unsupplied then dotNet.addEventHandler _control "TextChanged" textChanged
	
	ContentControl \
	_control \
	background:background \
	borderbrush:borderbrush \
	borderthickness:borderthickness \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
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

