/*##############################################################################
SugzTools WPF Wrapper Library
Version 2.04
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Functions to easily create wpf user interface 

# Required Components:

# Sources:

# ToDo:
	Implement the method to know if an its a dotnet color

# History:
2.0:
	- Rewrite the C# assembly from the ground up and update the MXS wrapper
1.0:
	- Initial C# assembly and the Mxs wrapper 

*Use / Modify this script at your own risk !*
###############################################################################*/


-- Assemblies
dotnet.loadAssembly "$max\bin\assemblies\SugzTools.dll"
dotnet.loadAssembly "$userScripts\SugzTools\Assemblies\MaterialDesignThemes.Wpf.dll"


global _wpf
struct WpfStruct
(
	-- NET Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_enum = dotNetClass "System.Enum",

	-- WPF Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_color = dotNetClass "System.Windows.Media.Color",
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_horizontalAlignment = dotNetClass "System.Windows.HorizontalAlignment",
	_verticalAlignment = dotNetClass "System.Windows.VerticalAlignment",
	_orientation = dotNetClass "System.Windows.Controls.Orientation",
	_gridUnitType = dotNetClass "System.Windows.GridUnitType",
	_stretch = dotNetClass "System.Windows.Media.Stretch",
	_double = dotNetClass "System.Double",
	
	
	-- SugzTools Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_radioButtonTypes = dotNetClass "SugzTools.Src.RadioButtonTypes",
	_inputFieldTextSide = dotNetClass "SugzTools.Src.InputFieldTextSide",
	_numericFormatSpecifier = dotNetClass "SugzTools.Src.NumericFormatSpecifier",
	_numericUpDownType = dotNetClass "SugzTools.Src.NumericUpDownType",
	_numericUpDownLimits = dotNetClass "SugzTools.Src.NumericUpDownLimits",
	_geo = dotNetClass "SugzTools.Icons.Geo",
	
	-- WinForm Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_formBorderStyle = dotNetClass "FormBorderStyle",
	_formStartPosition = dotNetClass "FormStartPosition",
	


	fn ToArray items = (dotNetClass "SugzTools.Src.Helpers").ToArray items,

	
	-- Return a System.Windows.Media.Color ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GetColor arg = 
	(
		/*<Function>
		Description:
			Return a .NET Color
		Arguments:
			<Color> / <Name> : take either a maxscript color or a name as color preset
		Return:
			System.Windows.Media.Color
		Further Infos:
		</Function>*/

		-- Convert and return a maxscript color to a .NET argb color
		if classOf arg == color then return _color.FromArgb (arg.a) (arg.r) (arg.g) (arg.b)
				
		-- Return a .NET argb color from a preset
		else 
		(
			case arg of 
			(
				#red: return _color.FromArgb 255 255 0 0
				#green: return  _color.FromArgb 255 0 255 0
				#blue: return  _color.FromArgb 255 0 0 255
				#black: return _color.FromArgb 255 0 0 0
				#grey: return _color.FromArgb 255 128 128 128
				#white: return _color.FromArgb 255 255 255 255
				#transparent: return _color.FromArgb 0 255 255 255
				
				#maxBackground: return  _color.FromArgb 255 68 68 68
				
				#maxRollout: return  _color.FromArgb 255 81 81 81
				#maxRolloutBorder: return  _color.FromArgb 255 62 62 62
				#maxRolloutArrow: return  _color.FromArgb 255 183 183 183
				#maxRolloutIcon: return  _color.FromArgb 255 151 151 151
				
				#maxControl: return  _color.FromArgb 255 100 100 100
				#maxControlBorder: return  _color.FromArgb 255 73 73 73
				#maxControlMouseOver: return  _color.FromArgb 255 56 56 56
				
				#maxText: return  _color.FromArgb 255 225 225 225
				#maxCaret: return  _color.FromArgb 255 155 155 155
				#maxFocusBorder: return  _color.FromArgb 255 208 208 208
				
				#maxBlue: return  _color.FromArgb 255 95 138 193
				#maxBlueMouseOver: return  _color.FromArgb 255 73 106 147
				
			)
		)
		
	),
	
	
	
	-- Return a System.Windows.Media.SolidColorBrush ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------	
	fn SolidColorBrush arg = 
	(
		/*<Function>
		Description:
			Return a SolidColorBrush
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		if (classOf arg != dotNetObject) then arg = GetColor arg
		return (dotNetObject "System.Windows.Media.SolidColorBrush" arg)
	),
	
	
	
	-- Return a System.Windows.Thickness ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Thickness arg = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		local thickness = #()
		if not isKindOf arg array then thickness = #(arg, arg, arg, arg)
		else if arg.count == 1 then thickness =#(arg[1], arg[1], arg[1], arg[1])
		else if arg.count == 2 then thickness =#(arg[1], arg[2], arg[1], arg[2])
		else thickness = arg
		
		return (dotnetObject "System.Windows.Thickness" thickness[1] thickness[2] thickness[3] thickness[4])
	),



	-- Return a System.Windows.CornerRadius ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CornerRadius arg = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		local cornerRadius = #()
		if not isKindOf arg array then cornerRadius = #(arg, arg, arg, arg)
		else if arg.count == 1 then cornerRadius =#(arg[1], arg[1], arg[1], arg[1])
		else cornerRadius = arg
		
		return (dotnetObject "System.Windows.CornerRadius" cornerRadius[1] cornerRadius[2] cornerRadius[3] cornerRadius[4])
	),
	
	
	
	-- Return a System.Windows.Forms.FormBorderStyle ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FormBorderStyle arg = 
	(
		/*<Function>
		Description:
			Enum to return the FormBorderStyle
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#fixed3D: return _formBorderStyle.Fixed3D
			#fixedDialog: return _formBorderStyle.FixedDialog
			#fixedSingle: return _formBorderStyle.FixedSingle
			#fixedToolWindow: return _formBorderStyle.FixedToolWindow
			#none: return _formBorderStyle.None
			#sizable: return _formBorderStyle.Sizable
			#sizableToolWindow: return _formBorderStyle.SizableToolWindow
		)
	),
	
	
	
	-- Return a System.Windows.WindowStartupLocation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FormStartPosition arg = 
	(
		/*<Function>
		Description:
			Enum to return the window location
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of
		(
			#centerParent: return _formStartPosition.CenterParent
			#centerScreen: return _formStartPosition.CenterScreen
			#manual: return _formStartPosition.Manual
			#windowsDefaultBounds: return _formStartPosition.WindowsDefaultBounds
			#windowsDefaultLocation: return _formStartPosition.WindowsDefaultLocation
		)
	),
	
	
	
	-- Return a System.Windows.HorizontalAlignment ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn HorizontalAlignment arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of
		(
			#left: return _horizontalAlignment.Left
			#center: return _horizontalAlignment.Center
			#right: return _horizontalAlignment.Right
			#stretch: return _horizontalAlignment.Stretch
		)
	),



	-- Return a System.Windows.HorizontalAlignment ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn VerticalAlignment arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of
		(
			#top: return _verticalAlignment.Top
			#center: return _verticalAlignment.Center
			#bottom: return _verticalAlignment.Bottom
			#stretch: return _verticalAlignment.Stretch
		)
	),
	
	
	
	-- Return a System.Windows.Controls.Orientation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Orientation arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case orientation of
		(
			#horizontal: return _orientation.Horizontal
			#vertical: return _orientation.Vertical
		)
	),
	
	
	
	-- Return a System.Windows.GridUnitType  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GridUnitType arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#auto: return _gridUnitType.Auto
			#pixel: return _gridUnitType.Pixel
			#star: return _gridUnitType.Star
		)
	),
	
	
	
	-- Return a System.Windows.Controls.Dock ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Dock arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#bottom: return _dock.Bottom
			#left: return _dock.Left
			#right: return _dock.Right
			#top: return _dock.Top
		)
	),



	-- Return a System.Windows.Media.Stretch ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Stretch arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#fill: return _stretch.Fill
			#none: return _stretch.None
			#uniform: return _stretch.Uniform
			#uniformToFill: return _stretch.UniformToFill
		)
	),
	
	
	
	-- Return a SugzTools.Src.RadioButtonTypes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButtonTypes arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#standard: return _radioButtonTypes.Standard
			#checkButton: return _radioButtonTypes.CheckButton
		)
	),
	
	
	
	-- Return a SugzTools.Src.InputFieldTextSide ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn InputFieldTextSide arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#left: return _inputFieldTextSide.Left
			#right: return _inputFieldTextSide.Right
		)
	),
	
	
	
	-- SugzTools.Src.NumericFormatSpecifier ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericFormatSpecifier arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#F: return _numericFormatSpecifier.F
			#N: return _numericFormatSpecifier.N
		)
	),
	
	
	
	-- SugzTools.Src.NumericUpDownType ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericUpDownType arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#integer: return _numericUpDownType.Integer
			#float: return _numericUpDownType.Float
			#worldunits: return _numericUpDownType.WorldUnits
		)
	),
	
	
	
	-- SugzTools.Src.NumericUpDownLimits ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericUpDownLimits arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#int: return _numericUpDownLimits.Int
			#long: return _numericUpDownLimits.Long
			#float: return _numericUpDownLimits.Float
			#double: return _numericUpDownLimits.Double
		)
	),
	
	
	
	-- Return a System.Windows.Window ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Window 
		width: 200
		height: 300 
		title:
		borderStyle:
		location:
		content:
		load:
		closed: =
	(
		/*<Function>
		Description:
			Return a Window
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		-- Define the window
		_wnd = dotNetObject "SugzTools.Controls.SgzMaxForm"
		_wnd.Width = width
		_wnd.Height = height 		
		if title != unsupplied then _wnd.Text = title
		if borderStyle != unsupplied then _wnd.FormBorderStyle = FormBorderStyle borderStyle
		if location != unsupplied then _wnd.StartPosition  =  FormStartPosition location
		if content != unsupplied then _wnd.Content = content
		
		if load != unsupplied then dotNet.addEventHandler _wnd "Load" load
		if closed != unsupplied then dotNet.addEventHandler _wnd "FormClosed" closed
		dotNet.setLifetimeControl _wnd #dotnet
		
		_wnd
	),



	fn Control 
		_control
		background:
		borderbrush:
		borderthickness:
		contextMenu:
		cursor:
		content:
		cornerRadius:
		flowDirection:
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
		isHitTestVisible:
		isTabStop:
		language:
		layoutTransform:
		margin:
		maxHeight:
		maxWidth:
		minHeight:
		minWidth:
		name:
		opacity:
		padding:
		renderTransform:
		renderTransformOrigin:
		resources:
		snapsToDevicePixels:
		style:
		tabIndex:
		tag:
		template:
		tooltip:
		uid:
		useLayoutRounding:
		vAlign:
		vContentAlign:
		visibility:
		width: =
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if content != unsupplied then _control.Content = content
		if isEnabled != unsupplied then _control.IsEnabled = isEnabled
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Grid 
		name:
		tag:
		width:
		height:
		background:
		hAlign:
		vAlign:
		margin:
		innerMargin: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzGrid"
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		
		Control _panel name:name tag:tag width:width height:height background:background hAlign:hAlign vAlign:vAlign margin:margin
	),



	-- Return a SugzTools.Controls.SgzGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn UniformGrid 
		name:
		tag:
		rows:
		columns:
		width: 
		height: 
		background: 
		hAlign:
		vAlign:
		margin: 
		innerMargin: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzUniformGrid"
		if rows != unsupplied then _panel.Rows = rows
		if columns != unsupplied then _panel.Columns = columns
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		
		Control _panel name:name tag:tag width:width height:height background:background hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a System.Windows.Controls.DockPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn DockPanel
		name:
		tag:
		width: 
		height: 
		background: 
		hAlign:
		vAlign:
		margin: 
		innerMargin:
		lastChildFill: = 
	(
		/*<Function>
		Description:
			Return a DockPanel 
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzDockPanel"
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		if lastChildFill != unsupplied then _panel.LastChildFill = lastChildFill
		
		Control _panel name:name tag:tag width:width height:height background:background hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzStackPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn StackPanel
		name:
		tag:
		width: 
		height: 
		background: 
		hAlign:
		vAlign:
		margin: 
		innerMargin:
		orientation: = 
	(
		/*<Function>
		Description:
			Return a StackPanel
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzStackPanel"
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		if orientation != unsupplied then _panel.Orientation = this.Orientation orientation
		
		Control _panel name:name tag:tag width:width height:height background:background hAlign:hAlign vAlign:vAlign margin:margin
	),




	-- Return a System.Windows.Controls.Border ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Border 
		name:
		tag:
		width: 
		height: 
		background:
		borderBrush: 
		borderThickness: 
		cornerRadius:
		hAlign:
		vAlign:
		margin: 
		child: =
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "System.Windows.Controls.Border"
		if child != unsupplied then _control.Child = child
		
		Control _control name:name tag:tag width:width height:height background:background borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a System.Windows.Controls.TextBlock ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn TextBlock
		name:
		tag:
		text:
		width: 
		height: 
		background:
		foreground: #MaxText
		hAlign:
		vAlign:
		margin: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "System.Windows.Controls.TextBlock"
		if text != unsupplied then _control.Text = text
			
		Control _control name:name tag:tag width:width height:height background:background foreground:foreground hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Expander
		name:
		tag:
		content: 
		header:
		isGroupBox:
		isExpanded:
		enabled:
		width:
		height:
		background:
		foreground:
		headerBrush:
		borderBrush: 
		borderThickness: 
		cornerRadius:
		hAlign:
		vAlign:
		margin: = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzExpander"
		if header != unsupplied then _control.Header = header
		if isGroupBox != unsupplied then _control.IsGroupBox = isGroupBox
		if isExpanded != unsupplied then _control.IsExpanded = isExpanded
		if headerBrush != unsupplied then _control.HeaderBrush = SolidColorBrush headerBrush
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),



	-- Return a SugzTools.Controls.SgzGroupBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GroupBox
		name:
		tag:
		content:
		header:
		enabled:
		width:
		height:
		background: 
		foreground:
		borderBrush: 
		borderThickness: 
		cornerRadius:
		hAlign:
		vAlign:
		margin: = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzGroupBox"
		if header != unsupplied then _control.Header = header
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Button
		name:
		tag:
		content:
		enabled:
		width:
		height:
		transparent:
		background:
		foreground:
		mouseOverBrush:
		mouseDownBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		click: =
	(
		/*<Function>
		Description:
			Return a Button
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzButton"
		if transparent != unsupplied then _control.IsTransparent = transparent
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush

		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		dotNet.setLifetimeControl _control #dotnet
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzCheckButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckButton
		name:
		tag:
		content:
		isChecked:
		enabled:
		width:
		height:
		transparent:
		background:
		foreground:
		mouseOverBrush:
		mouseDownBrush:
		checkBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		click:
		checked:
		unchecked: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzCheckButton"
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if transparent != unsupplied then _control.IsTransparent = transparent
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
			
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	-- Return a SugzTools.Controls.SgzCheckBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckBox
		name:
		tag:
		content:
		isChecked:
		enabled:
		width:
		height:
		background:
		foreground:
		mouseOverBrush:
		checkBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		click:
		checked:
		unchecked: =
	(
		_control = dotNetObject "SugzTools.Controls.SgzCheckBox"
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
		
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzRadioButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButton
		name:
		tag:
		content:
		isChecked:
		enabled:
		group:
		width:
		height:
		type:
		transparent: false
		background:
		foreground:
		mouseOverBrush:
		mouseDownBrush:
		checkBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		click:
		checked:
		unchecked: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzRadioButton"
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if group != unsupplied then _control.GroupName = group
		if type != unsupplied then _control.RadioButtonType = RadioButtonTypes type
		if transparent != unsupplied then _control.IsTransparent = transparent
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
			
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzTextBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn TextBox
		name:
		tag:
		text:
		watermark:
		uiElement0:
		uiElement1:
		uiElement2:
		enabled:
		width: 
		height:
		background:
		foreground:
		caretbrush:
		selectionBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		validate:
		textChanged: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		fn AddControl1 = (_control.AddControl control1 0)
		
		_control = dotNetObject "SugzTools.Controls.SgzMaxTextbox"
		if text != unsupplied then _control.Text = text
		if watermark != unsupplied then _control.Watermark = watermark

		if uiElement0 != unsupplied then _control.UIElement0 = uiElement0
		if uiElement1 != unsupplied then _control.UIElement1 = uiElement1
		if uiElement2 != unsupplied then _control.UIElement2 = uiElement2

		if caretbrush != unsupplied then _control.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
			
		if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
		if textChanged != unsupplied then dotNet.addEventHandler _control "TextChanged" textChanged
		dotNet.setLifetimeControl _control #dotnet
	
		Control _control name:name tag:tag enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzMaxNumericUpDown ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Spinner
		name:
		tag:
		content:
		type:
		value:
		defaultValue:
		minValue:
		maxValue:
		limits:
		range:
		scale:
		scaleAccelerator:
		decimals:
		minDecimals:
		alwaysShowValue:
		indeterminate:
		format:
		delay:
		interval:
		hidebuttons:
		enabled:
		width:
		height:
		fieldWidth:
		background:
		foreground:
		caretbrush:
		selectionBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		validate:
		valueChanged: =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzMaxNumericUpDown"
		if type != unsupplied then _control.Type = NumericUpDownType type
		if value != unsupplied then _control.Value = value
		if defaultValue != unsupplied then _control.DefaultValue = defaultValue
		if minValue != unsupplied then _control.MinValue = minValue
		if maxValue != unsupplied then _control.MaxValue = maxValue
		if limits != unsupplied then _control.Limits = NumericUpDownLimits limits
		if range != unsupplied then _control.Range = range
		if scale != unsupplied then _control.Scale = scale
		if scaleAccelerator != unsupplied then _control.ScaleAccelerator = scaleAccelerator
		if decimals != unsupplied then _control.Decimals = decimals
		if minDecimals != unsupplied then _control.MinDecimals = minDecimals
		if alwaysShowValue != unsupplied then _control.AlwaysShowValue = alwaysShowValue
		if indeterminate != unsupplied then _control.Indeterminate = indeterminate
		if format != unsupplied then _control.NumericFormatSpecifier = NumericFormatSpecifier format
		if delay != unsupplied then _control.Delay = delay
		if interval != unsupplied then _control.Interval = interval
		if hidebuttons != unsupplied then _control.Hidebuttons = hidebuttons
		if fieldWidth != unsupplied then _control.FieldWidth = fieldWidth
		if caretbrush != unsupplied then _control.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
			
		if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
		if valueChanged != unsupplied then dotNet.addEventHandler _control "ValueChanged" valueChanged
		dotNet.setLifetimeControl _control #dotnet
	
		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),



	-- Return a SugzTools.Controls.SgzProgressBar ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn ProgressBar 
		name:
		tag:
		value:
		isIndeterminate:
		indeterminateAutoReverse:
		isCylon:
		enabled:
		width:
		height:
		background:
		foreground:
		indeterminateBrush:
		cylonBrush:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin: 
		valueChanged: =
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzProgressBar"
		if value != unsupplied then _control.Value = value
		if isIndeterminate != unsupplied then _control.IsIndeterminate = isIndeterminate
		if indeterminateAutoReverse != unsupplied then _control.IndeterminateAutoReverse = indeterminateAutoReverse
		if isCylon != unsupplied then _control.isCylon = isCylon
		if indeterminateBrush != unsupplied then _control.IndeterminateBrush = SolidColorBrush indeterminateBrush
		if cylonBrush != unsupplied then _control.CylonBrush = SolidColorBrush cylonBrush

		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),
	
	
	
	-- Return a SugzTools.Controls.SgzComboBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn ComboBox 
		name:
		tag:
		items:
		selectedIndex: 0
		enabled:
		width:
		height:
		background:
		foreground:
		borderBrush:
		borderThickness:
		cornerRadius:
		hAlign:
		vAlign:
		margin:
		selectionChanged: =
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzComboBox"
		if items != unsupplied then _control.SetItems items
		_control.SelectedIndex = selectedIndex

		if selectionChanged != unsupplied then dotNet.addEventHandler _control "SelectionChanged" selectionChanged
		dotNet.setLifetimeControl _control #dotnet

		Control _control name:name tag:tag content:content enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush borderThickness:borderThickness cornerRadius:cornerRadius hAlign:hAlign vAlign:vAlign margin:margin
	),



	-- Return a System.Windows.Controls.Image ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Image 
		uri:
		stretch: 
		name:
		tag:
		enabled:
		width:
		height: = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "System.Windows.Controls.Image"
		_bmp = dotNetObject "System.Windows.Media.Imaging.BitmapImage"
		_bmp
		_bmp.BeginInit()
        _bmp.UriSource = dotNetObject "System.Uri" uri
        _bmp.EndInit()
		_control.Source = _bmp
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if stretch != unsupplied then _control.Stretch = this.Stretch stretch
		_control.Focusable = false

		_control
	),



	-- Return a SugzTools.Controls.SgzIcon ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Icon 
		icon:
		name:
		tag:
		data: 
		enabled:
		width:
		height:
		background:
		foreground:
		mouseOverBrush:
		mouseDownBrush:
		borderBrush:
		borderThickness:
		hAlign:
		vAlign:
		margin: 
		click: = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzIcon"
		if icon != unsupplied then _control.Icon = _enum.Parse _geo icon 
		if data != unsupplied then _control.Data = data
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if borderThickness != unsupplied then _control.BorderThickness = borderThickness
		if margin != unsupplied then 
		(
			if width == unsupplied then width = _double.NaN
			if height == unsupplied then height = _double.NaN
			_control.Margin = Thickness margin
		)

		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		dotNet.setLifetimeControl _control #dotnet

		Control _control name:name tag:tag enabled:enabled width:width height:height background:background foreground:foreground borderBrush:borderBrush hAlign:hAlign vAlign:vAlign
	)
)

_wpf = WpfStruct()

