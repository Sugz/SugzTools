-- Set properties and event handlers for a System.Windows.Controls.Primitives.Selector ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn Selector 
	_control
	itemsSource:
	selectedIndex:
	selectionChanged:
	background:
	borderBrush:
	borderThickness:
	cornerRadius:
	dock:
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

	if itemsSource != unsupplied then _control.ItemsSource = itemsSource
	if selectedIndex != unsupplied then _control.SelectedIndex = selectedIndex
	if selectionChanged != unsupplied then dotNet.addEventHandler _control "SelectionChanged" selectionChanged

	ContentControl \
	_control \
	background:background \
	borderBrush:borderBrush \
	borderThickness:borderThickness \
	cornerRadius:cornerRadius \
	dock:dock \
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



-- Set properties and event handlers for a SugzTools.Controls.SgzComboBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn ComboBox 
	fieldHeight:
	items:
	itemsSource:
	selectedIndex: 0
	title:
	titleSide:
	selectionChanged:
	background:
	borderBrush:
	borderThickness:
	cornerRadius:
	dock:
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

	_control = dotNetObject "SugzTools.Controls.SgzComboBox"
	if fieldHeight != unsupplied then _control.FieldHeight = fieldHeight
	if items != unsupplied then _control.SetItems items
	if title != unsupplied then _control.title = title
	if titleSide != unsupplied then _control.TitleSide = Enums.Dock titleSide

	Selector \
	_control \
	itemsSource:itemsSource \
	selectedIndex:selectedIndex \
	selectionChanged:selectionChanged \
	background:background \
	borderBrush:borderBrush \
	borderThickness:borderThickness \
	cornerRadius: cornerRadius \
	dock:dock \
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




-- Set properties and event for a SugzTools.Controls.SgzListView ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
fn DataGrid
	alternatingRowBackground:
	canSelectMultipleItems:
	canUserReorderColumns:
	canUserResizeColumns:
	canUserResizeRows:
	canUserSortColumns:
	columnHeaderHeight:
	gridLinesVisibility:
	headerBackground:
	headerForeground:
	headerHorizontalAlignment:
	headersVisibility:
	horizontalGridLinesBrush:
	isReadOnly:
	isSelectable:
	maxColumnWidth:
	minColumnWidth:
	minRowHeight:
	rowBackground:#Transparent
	rowHeaderWidth:
	rowHeight:
	selectionMode:
	selectionUnit:

	itemsSource:
	selectedIndex:
	selectionChanged:
	background:
	borderBrush:
	borderThickness:
	cornerRadius:
	dock:
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
	
	_control = dotNetObject "SugzTools.Controls.SgzDataGrid"
	if alternatingRowBackground != unsupplied then _control.AlternatingRowBackground = SolidColorBrush alternatingRowBackground
	if canSelectMultipleItems != unsupplied then _control.CanSelectMultipleItems = canSelectMultipleItems
	if canUserReorderColumns != unsupplied then _control.CanUserReorderColumns = canUserReorderColumns
	if canUserResizeColumns != unsupplied then _control.CanUserResizeColumns = canUserResizeColumns
	if canUserResizeRows != unsupplied then _control.CanUserResizeRows = canUserResizeRows
	if canUserSortColumns != unsupplied then _control.CanUserSortColumns = canUserSortColumns
	if columnHeaderHeight != unsupplied then _control.ColumnHeaderHeight = columnHeaderHeight
	if gridLinesVisibility != unsupplied then _control.GridLinesVisibility = gridLinesVisibility
	if headerBackground != unsupplied then _control.HeaderBackground = SolidColorBrush headerBackground
	if headerForeground != unsupplied then _control.HeaderForeground = SolidColorBrush headerForeground
	if headerHorizontalAlignment != unsupplied then _control.HeaderHorizontalAlignment = headerHorizontalAlignment
	if headersVisibility != unsupplied then _control.HeadersVisibility = headersVisibility
	if horizontalGridLinesBrush != unsupplied then _control.HorizontalGridLinesBrush = SolidColorBrush horizontalGridLinesBrush
	if isReadOnly != unsupplied then _control.IsReadOnly = isReadOnly
	if isSelectable != unsupplied then _control.IsSelectable = isSelectable
	if maxColumnWidth != unsupplied then _control.MaxColumnWidth = maxColumnWidth
	if minColumnWidth != unsupplied then _control.MinColumnWidth = minColumnWidth
	if minRowHeight != unsupplied then _control.MinRowHeight = minRowHeight
	_control.RowBackground = SolidColorBrush rowBackground
	if rowHeaderWidth != unsupplied then _control.RowHeaderWidth = rowHeaderWidth
	if rowHeight != unsupplied then _control.RowHeight = rowHeight
-- 	if selectionMode != unsupplied then _control.SelectionMode = selectionMode
-- 	if selectionUnit != unsupplied then _control.SelectionUnit = selectionUnit
	
	Selector \
	_control \
	itemsSource:itemsSource \
	selectedIndex:selectedIndex \
	selectionChanged:selectionChanged \
	background:background \
	borderBrush:borderBrush \
	borderThickness:borderThickness \
	cornerRadius: cornerRadius \
	dock:dock \
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

