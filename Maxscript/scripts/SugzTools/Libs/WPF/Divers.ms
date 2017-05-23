-- Set most of the properties and event handlers for a System.Windows.Controls.Image ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Image
	source:
	stretch:
	stretchDirection:
	uri:
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

	_control = dotNetObject "System.Windows.Controls.Image"
	if source != unsupplied then _control.source = source
	if stretch != unsupplied then _control.stretch = Enums.Stretch stretch
	if stretchDirection != unsupplied then _control.StretchDirection = Enums.StretchDirection stretchDirection
	if uri != unsupplied then
	(
		bitmapImage = dotNetObject "System.Windows.Media.Imaging.BitmapImage"
		bitmapImage.BeginInit()
	    bitmapImage.UriSource = dotNetObject "System.Uri" uri
	    bitmapImage.EndInit()
		_control.Source = bitmapImage
	)

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


fn GridSplitter
	dragIncrement:
	keyboardIncrement:
	resizeBehavior:
	resizeDirection:
	showsPreview:
	
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
	
	_control = dotNetObject "System.Windows.Controls.GridSplitter"
	if dragIncrement != unsupplied then _control.DragIncrement = dragIncrement
	if keyboardIncrement != unsupplied then _control.KeyboardIncrement = keyboardIncrement
-- 	if resizeBehavior != unsupplied then _control.ResizeBehavior = resizeBehavior => need enum
-- 	if resizeDirection != unsupplied then _control.ResizeDirection = resizeDirection => need enum
	if showsPreview != unsupplied then _control.ShowsPreview = showsPreview
	
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

