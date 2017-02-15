-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Expander
	file:
	var:
	hasPopup:
	header:
	headerBrush:
	headerHeight:
	isGroupBox:
	isExpanded:
	popupSide:
	popupWidth:
	collapsed:
	expanded:
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	contextMenu:
	cursor:
	content:
	cornerRadius:
	dock:
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
		Return a SgzExpander
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzExpander"
	if file != unsupplied then _control.File = file
	if var != unsupplied then _control.Var = var
	if hasPopup != unsupplied then _control.HasPopup = hasPopup
	if header != unsupplied then _control.Header = header
	if headerBrush != unsupplied then _control.HeaderBrush = SolidColorBrush headerBrush
	if headerHeight != unsupplied then _control.HeaderHeight = headerHeight
	if isGroupBox != unsupplied then _control.IsGroupBox = isGroupBox
	if isExpanded != unsupplied then _control.IsExpanded = isExpanded
	if popupSide != unsupplied then _control.PopupSide = _enum.Side popupSide
	if popupWidth != unsupplied then _control.PopupWidth = popupWidth
	if collapsed != unsupplied then dotNet.addEventHandler _control "Collapsed" collapsed
	if expanded != unsupplied then dotNet.addEventHandler _control "Expanded" expanded
	
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
	dock:dock \
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
),



fn GroupBox
	header: 
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	contextMenu:
	cursor:
	content:
	cornerRadius:
	dock:
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
		Return a SgzGroupBox
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzGroupBox"
	if header != unsupplied then _control.Header = header
	
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
	dock:dock \
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
),


-- Return a SugzTools.Controls.SgzExpandersControl ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn ExpandersControl
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	contextMenu:
	cursor:
	dock:
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
	
	ContentControl \
	(dotNetObject "SugzTools.Controls.SgzExpandersControl") \
	background:background \
	borderbrush:borderbrush \
	borderthickness:borderthickness \
	clipToBounds:clipToBounds \
	contextMenu:contextMenu \
	cursor:cursor \
	dock:dock \
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




