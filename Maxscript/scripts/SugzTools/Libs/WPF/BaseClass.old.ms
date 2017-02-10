-- Set properties and event handlers for a System.Windows.UIElement ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn UIElement 
	_control
	clipToBounds:
	dock:
	focusable:
	isEnabled:
	visibility: =
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
	if visibility != unsupplied then _control.Visibility = Enums.Visibility visibility

	dotNet.setLifetimeControl _control #dotnet

	_control
),


-- Set properties and event handlers for a System.Windows.FrameworkElement ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn FrameworkElement 
	_control
	cursor:
	hAlign:
	height:
	margin:
	name:
	tag:
	tooltip:
	vAlign:
	width:
	loaded:
	clipToBounds:
	dock:
	focusable:
	isEnabled:
	visibility: =
(
	/*<Function>
	Description:
	Arguments:
	Return:
	Infos:
	</Function>*/

	if cursor != unsupplied then _control.Cursor = this.Cursor cursor
	if hAlign != unsupplied then _control.HorizontalAlignment = Enums.HorizontalAlignment hAlign
	if height != unsupplied then _control.Height = height
	if margin != unsupplied then _control.Margin = Thickness margin
	if name != unsupplied then _control.Name = name
	if tag != unsupplied then _control.Tag = tag
	if tooltip != unsupplied then _control.Tooltip = tooltip
	if vAlign != unsupplied then _control.VerticalAlignment = Enums.VerticalAlignment vAlign
	if width != unsupplied then _control.Width = width
	if loaded != unsupplied then dotNet.addEventHandler _control "Loaded" loaded

	UIElement _control clipToBounds:clipToBounds dock:dock focusable:focusable isEnabled:isEnabled visibility:visibility
),


-- Set properties and event handlers for a System.Windows.Controls.Control ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Control 
	_control 
	background:
	borderBrush:
	borderThickness:
	foreground:
	hContentAlign:
	isTabStop:
	padding:
	tabIndex:
	vContentAlign:
	clipToBounds:
	cursor:
	dock:
	focusable:
	hAlign:
	height:
	isEnabled:
	margin:
	name:
	tag:
	tooltip:
	vAlign:
	visibility:
	width:
	loaded: =
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
	if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
	if hContentAlign != unsupplied then _control.HorizontalContentAlignment = Enums.HorizontalAlignment hContentAlign
	if isTabStop != unsupplied then _control.isTabStop = isTabStop
	if padding != unsupplied then _control.Padding = Thickness padding
	if tabIndex != unsupplied then _control.TabIndex = tabIndex
	if vContentAlign != unsupplied then _control.VerticalContentAlignment = Enums.VerticalAlignment vContentAlign

	FrameworkElement _control clipToBounds:clipToBounds cursor:cursor dock:dock focusable:focusable hAlign:hAlign height:height isEnabled:isEnabled margin:margin name:name tag:tag tooltip:tooltip vAlign:vAlign visibility:visibility width:width loaded:loaded
),


-- Set properties and event handlers for a System.Windows.Controls.ContentControl ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn ContentControl 
	_control 
	content:
	cornerRadius:
	background:
	borderBrush:
	borderThickness:
	clipToBounds:
	cursor:
	dock:
	focusable:
	foreground:
	hAlign:
	hContentAlign:
	height:
	isEnabled:
	isTabStop:
	margin:
	name:
	padding:
	tabIndex:
	tag:
	tooltip:
	vAlign:
	vContentAlign:
	visibility:
	width:
	loaded: =
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
	background: background \
	borderBrush: borderBrush \
	borderThickness: borderThickness \
	clipToBounds: clipToBounds \
	cursor: cursor \
	dock: dock \
	focusable: focusable \
	foreground: foreground \
	hAlign: hAlign \
	hContentAlign: hContentAlign \
	height: height \
	isEnabled: isEnabled \
	isTabStop: isTabStop \
	margin: margin \
	name: name \
	padding: padding \
	tabIndex: tabIndex \
	tag: tag \
	tooltip: tooltip \
	vAlign: vAlign \
	vContentAlign: vContentAlign \
	visibility: visibility \
	width: width \
	loaded: loaded 
)