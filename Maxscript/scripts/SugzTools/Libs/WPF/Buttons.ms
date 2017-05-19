-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Button
	hoverBrush:
	isTransparent:
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
	
	_control = dotNetObject "SugzTools.Controls.SgzButton"
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if isTransparent != unsupplied then _control.IsTransparent = isTransparent
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


fn Icon
	borderThickness:
	data:
	hoverBrush:
	icon:
	pressedBrush:
	stretch:
	click:
	background:
	borderBrush:
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
	
	_control = dotNetObject "SugzTools.Controls.SgzIcon"
	if borderThickness != unsupplied then _control.BorderThickness = borderThickness
	if data != unsupplied then _control.Data = data
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if icon != unsupplied then _control.Icon = Enums._enum.Parse Enums._geo icon 

	if pressedBrush != unsupplied then _control.PressedBrush = SolidColorBrush pressedBrush
	if stretch != unsupplied then _control.Stretch = Enums.Stretch stretch
	if margin != unsupplied then 
	(
		if width == unsupplied then width = _double.NaN
		if height == unsupplied then height = _double.NaN
	)
	if click != unsupplied then dotNet.addEventHandler _control "Click" click
	
	ContentControl \
	_control \
	background:background \
	borderbrush:borderbrush \
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
),



fn Checkbox 
	checkedBrush:
	hoverBrush:
	indeterminateBrush:
	isChecked:
	isThreeState:
	spacing:
	triState:
	click:
	checked:
	unchecked:

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
		Return a Button
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzCheckBox"
	if checkedBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkedBrush
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if indeterminateBrush != unsupplied then _control.IndeterminateBrush = SolidColorBrush indeterminateBrush
	if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
	if isThreeState != unsupplied then _control.IsThreeState = isThreeState
	if spacing != unsupplied then _control.Spacing = spacing
	if triState != unsupplied then _control.TriState = triState
	if click != unsupplied then dotNet.addEventHandler _control "Click" click
	if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
	if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
	
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



fn Checkbutton
	checkedBrush:
	hoverBrush:
	isTransparent:
	isChecked:
	pressedBrush:
	click:
	checked:
	unchecked:

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
		Return a Button
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzCheckButton"
	if checkedBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkedBrush
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if isTransparent != unsupplied then _control.IsTransparent = isTransparent
	if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
	if pressedBrush != unsupplied then _control.PressedBrush = SolidColorBrush pressedBrush
	if click != unsupplied then dotNet.addEventHandler _control "Click" click
	if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
	if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
	
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



fn RadioButton
	checkedBrush:
	hoverBrush:
	isTransparent:
	pressedBrush:
	group:
	isChecked:
	type:
	click:
	checked:
	unchecked:

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
		Return a Button
	Arguments:
	Return:
	Infos:
	</Function>*/
	
	_control = dotNetObject "SugzTools.Controls.SgzRadioButton"
	if checkedBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkedBrush
	if hoverBrush != unsupplied then _control.HoverBrush = SolidColorBrush hoverBrush
	if isTransparent != unsupplied then _control.IsTransparent = isTransparent
	if pressedBrush != unsupplied then _control.PressedBrush = SolidColorBrush pressedBrush
	if group != unsupplied then _control.GroupName = group
	if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
	if type != unsupplied then _control.RadioButtonType = Enums.RadioButtonTypes type

	if click != unsupplied then dotNet.addEventHandler _control "Click" click
	if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
	if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
	
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
)