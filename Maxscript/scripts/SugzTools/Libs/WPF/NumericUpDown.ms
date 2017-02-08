-- Return a SugzTools.Controls.SgzMaxNumericUpDown ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Spinner
	alwaysShowValue:
	caretBrush:
	decimals:
	defaultValue:
	delay:
	fieldWidth:
	hideButtons:
	indeterminate:
	interval:
	limits:
	maxValue:
	minDecimals:
	minValue:
	numericFormatSpecifier:
	range:
	scale:
	scaleAccelerator:
	selectionBrush:
	type:
	value:
	validate:
	valueChanged:
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
	
	_control = dotNetObject "SugzTools.Controls.SgzMaxNumericUpDown"
	if alwaysShowValue != unsupplied then _control.AlwaysShowValue = alwaysShowValue
	if caretbrush != unsupplied then _control.CaretBrush = SolidColorBrush caretbrush
	if decimals != unsupplied then _control.Decimals = decimals
	if defaultValue != unsupplied then _control.DefaultValue = defaultValue
	if delay != unsupplied then _control.Delay = delay
	if fieldWidth != unsupplied then _control.FieldWidth = fieldWidth
	if hidebuttons != unsupplied then _control.Hidebuttons = hidebuttons
	if indeterminate != unsupplied then _control.Indeterminate = indeterminate
	if interval != unsupplied then _control.Interval = interval
	if limits != unsupplied then _control.Limits = NumericUpDownLimits limits
	if maxValue != unsupplied then _control.MaxValue = maxValue
	if minDecimals != unsupplied then _control.MinDecimals = minDecimals
	if minValue != unsupplied then _control.MinValue = minValue
	if numericFormatSpecifier != unsupplied then _control.NumericFormatSpecifier = this.NumericFormatSpecifier numericFormatSpecifier
	if range != unsupplied then _control.Range = range
	if scale != unsupplied then _control.Scale = scale
	if scaleAccelerator != unsupplied then _control.ScaleAccelerator = scaleAccelerator
	if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
	if type != unsupplied then _control.Type = NumericUpDownType type
	if value != unsupplied then _control.Value = value
	if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
	if valueChanged != unsupplied then dotNet.addEventHandler _control "ValueChanged" valueChanged

	ContentControl \
	_control \
	background: background \
	borderBrush: borderBrush \
	borderThickness: borderThickness \
	clipToBounds: clipToBounds \
	contextMenu: contextMenu \
	cursor: cursor \
	content: content \
	cornerRadius: cornerRadius \
	focusable: focusable \
	fontFamily: fontFamily \
	fontSize: fontSize \
	fontStretch: fontStretch \
	fontStyle: fontStyle \
	fontWeight: fontWeight \
	foreground: foreground \
	height: height \
	hAlign: hAlign \
	hContentAlign: hContentAlign \
	isEnabled: isEnabled \
	isTabStop: isTabStop \
	margin: margin \
	maxHeight: maxHeight \
	maxWidth: maxWidth \
	minHeight: minHeight \
	minWidth: minWidth \
	name: name \
	opacity: opacity \
	padding: padding \
	snapsToDevicePixels: snapsToDevicePixels \
	tabIndex: tabIndex \
	tag: tag \
	tooltip: tooltip \
	uid: uid \
	useLayoutRounding: useLayoutRounding \
	vAlign: vAlign \
	vContentAlign: vContentAlign \
	visibility: visibility \
	width: width \
	initialized: initialized \
	isEnabledChanged: isEnabledChanged \
	keyDown: keyDown \
	keyUp: keyUp \
	loaded: loaded \
	mouseDoubleClick: mouseDoubleClick \
	mouseDown: mouseDown \
	mouseEnter: mouseEnter \
	mouseLeave: mouseLeave \
	mouseLeftButtonDown: mouseLeftButtonDown \
	mouseLeftButtonUp: mouseLeftButtonUp \
	mouseMove: mouseMove \
	mouseRightButtonDown: mouseRightButtonDown \
	mouseRightButtonUp: mouseRightButtonUp \
	mouseUp: mouseUp \
	mouseWheel: mouseWheel \
	sizeChanged: sizeChanged \
)