-- Set properties and event handlers for a System.Windows.UIElement ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn UIElement 
	_control
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

	if clipToBounds != unsupplied then _control.ClipToBounds = clipToBounds
	if dock != unsupplied then _dock.SetDock _control (Enums.Dock dock)
	if focusable != unsupplied then _control.Focusable = focusable
	if isEnabled != unsupplied then _control.IsEnabled = isEnabled
	if opacity != unsupplied then _control.Opacity = opacity
	if snapsToDevicePixels != unsupplied then _control.SnapsToDevicePixels = snapsToDevicePixels
	if uid != unsupplied then _control.Uid = uid
	if visibility != unsupplied then _control.Visibility = Enums.Visibility visibility

	if isEnabledChanged != unsupplied then dotNet.addEventHandler _control "IsEnabledChanged" isEnabledChanged
	if keyDown != unsupplied then dotNet.addEventHandler _control "KeyDown" keyDown
	if keyUp != unsupplied then dotNet.addEventHandler _control "keyUp" keyUp
	if mouseDown != unsupplied then dotNet.addEventHandler _control "MouseDown" mouseDown
	if mouseEnter != unsupplied then dotNet.addEventHandler _control "MouseEnter" mouseEnter
	if mouseLeave != unsupplied then dotNet.addEventHandler _control "MouseLeave" mouseLeave
	if mouseLeftButtonDown != unsupplied then dotNet.addEventHandler _control "MouseLeftButtonDown" mouseLeftButtonDown
	if mouseLeftButtonUp != unsupplied then dotNet.addEventHandler _control "MouseLeftButtonUp" mouseLeftButtonUp
	if mouseMove != unsupplied then dotNet.addEventHandler _control "MouseMove" mouseMove
	if mouseRightButtonDown != unsupplied then dotNet.addEventHandler _control "MouseRightButtonDown" mouseRightButtonDown
	if mouseRightButtonUp != unsupplied then dotNet.addEventHandler _control "MouseRightButtonUp" mouseRightButtonUp
	if mouseUp != unsupplied then dotNet.addEventHandler _control "MouseUp" mouseUp
	if mouseWheel != unsupplied then dotNet.addEventHandler _control "MouseWheel" mouseWheel

	_control
),



-- Set properties and event handlers for a System.Windows.FrameworkElement ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn FrameworkElement 
	_control
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

	if contextMenu != unsupplied then _control.ContextMenu = contextMenu
	if cursor != unsupplied then _control.Cursor = this.Cursor cursor
	if height != unsupplied then _control.Height = height
	if hAlign != unsupplied then _control.HorizontalAlignment = Enums.HorizontalAlignment hAlign
	if margin != unsupplied then _control.Margin = Thickness margin
	if maxHeight != unsupplied then _control.MaxHeight = maxHeight
	if maxWidth != unsupplied then _control.MaxWidth = maxWidth
	if minHeight != unsupplied then _control.MinHeight = minHeight
	if minWidth != unsupplied then _control.MinWidth = minWidth
	if name != unsupplied then _control.Name = name
	if tag != unsupplied then _control.Tag = tag
	if tooltip != unsupplied then _control.Tooltip = tooltip
	if useLayoutRounding != unsupplied then _control.UseLayoutRounding = useLayoutRounding
	if vAlign != unsupplied then _control.VerticalAlignment = Enums.VerticalAlignment vAlign
	if width != unsupplied then _control.Width = width

	if initialized != unsupplied then dotNet.addEventHandler _control "Initialized" initialized
	if loaded != unsupplied then dotNet.addEventHandler _control "Loaded" loaded
	if sizeChanged != unsupplied then dotNet.addEventHandler _control "SizeChanged" sizeChanged

	UIElement \
	_control \
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
),



-- Set properties and event handlers for a System.Windows.Controls.Control ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Control 
	_control
	background:
	borderBrush:
	borderThickness:
	fontFamily:
	fontSize:
	fontStretch:
	fontStyle:
	fontWeight:
	foreground:
	hContentAlign:
	isTabStop:
	padding:
	tabIndex:
	vContentAlign:
	mouseDoubleClick: 
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

	if background != unsupplied then _control.background = SolidColorBrush background
	if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
	if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
	if fontFamily != unsupplied then _control.FontFamily = this.FontFamily fontFamily
	if fontSize != unsupplied then _control.FontSize = fontSize
	if fontStretch != unsupplied then _control.FontStretch = Enums.FontStretches fontStretch
	if fontStyle != unsupplied then _control.FontStyle = Enums.FontStyles fontStyle
	if fontWeight != unsupplied then _control.FontWeight = Enums.FontWeights fontWeight
	if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
	if hContentAlign != unsupplied then _control.HorizontalContentAlignment = Enums.HorizontalAlignment hContentAlign
	if isTabStop != unsupplied then _control.isTabStop = isTabStop
	if padding != unsupplied then _control.Padding = Thickness padding
	if tabIndex != unsupplied then _control.TabIndex = tabIndex
	if vContentAlign != unsupplied then _control.VerticalContentAlignment = Enums.VerticalAlignment vContentAlign

	if mouseDoubleClick != unsupplied then dotNet.addEventHandler _control "MouseDoubleClick" mouseDoubleClick

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
),



-- Set properties and event handlers for a System.Windows.Controls.ContentControl ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn ContentControl 
	_control
	content:
	cornerRadius:
	background:
	borderBrush:
	borderThickness:
	fontFamily:
	fontSize:
	fontStretch:
	fontStyle:
	fontWeight:
	foreground:
	hContentAlign:
	isTabStop:
	padding:
	tabIndex:
	vContentAlign:
	mouseDoubleClick: 
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

	if content != unsupplied then _control.Content = content
	if cornerRadius != unsupplied then _control.CornerRadius =
	(
		if (isKindOf (getProperty _control "CornerRadius") Integer) 
			then cornerRadius
			else CornerRadius cornerRadius
	)

	Control \
	_control \
	background:background \
	borderBrush:borderBrush \
	borderThickness:borderThickness \
	fontFamily:fontFamily \
	fontSize:fontSize \
	fontStretch:fontStretch \
	fontStyle:fontStyle \
	fontWeight:fontWeight \
	foreground:foreground \
	hContentAlign:hContentAlign \
	isTabStop:isTabStop \
	padding:padding \
	tabIndex:tabIndex \
	vContentAlign:vContentAlign \
	mouseDoubleClick:mouseDoubleClick \
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