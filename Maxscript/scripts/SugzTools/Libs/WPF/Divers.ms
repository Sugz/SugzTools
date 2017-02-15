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
)