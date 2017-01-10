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
global _wpf
struct WpfStruct
(
	-- WPF Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_color = dotNetClass "System.Windows.Media.Color",
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_horizontalAlignment = dotNetClass "System.Windows.HorizontalAlignment",
	_verticalAlignment = dotNetClass "System.Windows.VerticalAlignment",
	_orientation = dotNetClass "System.Windows.Controls.Orientation",
	_gridUnitType = dotNetClass "System.Windows.GridUnitType",
	_stretch = dotNetClass "System.Windows.Media.Stretch",
	
	
	-- SugzTools Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_radioButtonTypes = dotNetClass "SugzTools.Src.RadioButtonTypes",
	_inputFieldTextSide = dotNetClass "SugzTools.Src.InputFieldTextSide",
	_numericFormatSpecifier = dotNetClass "SugzTools.Src.NumericFormatSpecifier",
	_numericUpDownType = dotNetClass "SugzTools.Src.NumericUpDownType",
	_numericUpDownLimits = dotNetClass "SugzTools.Src.NumericUpDownLimits",
	
	
	-- WinForm Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_formBorderStyle = dotNetClass "FormBorderStyle",
	_formStartPosition = dotNetClass "FormStartPosition",
	


	fn ToArray items = (dotNetClass "SugzTools.Src.Helpers").ToArray items,
	
	
	-- Return a System.Windows.Media.Color ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Color arg = 
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
		if classOf arg == Color then return _color.FromArgb (arg.a) (arg.r) (arg.g) (arg.b)
				
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
				
				#MaxBackground: return  _color.FromArgb 255 68 68 68
				
				#MaxRollout: return  _color.FromArgb 255 81 81 81
				#MaxRolloutBorder: return  _color.FromArgb 255 62 62 62
				#MaxRolloutArrow: return  _color.FromArgb 255 183 183 183
				#MaxRolloutIcon: return  _color.FromArgb 255 151 151 151
				
				#MaxControl: return  _color.FromArgb 255 100 100 100
				#MaxControlBorder: return  _color.FromArgb 255 73 73 73
				#MaxControlMouseOver: return  _color.FromArgb 255 56 56 56
				
				#MaxText: return  _color.FromArgb 255 225 225 225
				#MaxCaret: return  _color.FromArgb 255 155 155 155
				#MaxFocusBorder: return  _color.FromArgb 255 208 208 208
				
				#MaxBlue: return  _color.FromArgb 255 95 138 193
				#MaxBlueMouseOver: return  _color.FromArgb 255 73 106 147
				
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
		
		if (classOf arg != dotNetObject) then arg = this.Color arg
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
		background:
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
		--if background != unsupplied then _wnd.Background = SolidColorBrush background
		if title != unsupplied then _wnd.Text = title
		if borderStyle != unsupplied then _wnd.FormBorderStyle = FormBorderStyle borderStyle
		if location != unsupplied then _wnd.StartPosition  =  FormStartPosition location
		if content != unsupplied then _wnd.Content = content
		
		if load != unsupplied then dotNet.addEventHandler _wnd "Load" load
		if closed != unsupplied then dotNet.addEventHandler _wnd "Closed" closed
		dotNet.setLifetimeControl _wnd #dotnet
		
		_wnd
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
		if name != unsupplied then _panel.Name = name
		if tag != unsupplied then _panel.Tag = tag
		if width != unsupplied then _panel.Width = width
		if height  != unsupplied then _panel.Height = height
		if background != unsupplied then _panel.background = SolidColorBrush background
		if hAlign != unsupplied then _panel.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _panel.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _panel.Margin = Thickness margin
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		
		_panel
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
		if name != unsupplied then _panel.Name = name
		if tag != unsupplied then _panel.Tag = tag
		if rows != unsupplied then _panel.Rows = rows
		if columns != unsupplied then _panel.Columns = columns
		if width != unsupplied then _panel.Width = width
		if height  != unsupplied then _panel.Height = height
		if background != unsupplied then _panel.background = SolidColorBrush background
		if hAlign != unsupplied then _panel.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _panel.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _panel.Margin = Thickness margin
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		
		_panel
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
		if name != unsupplied then _panel.Name = name
		if tag != unsupplied then _panel.Tag = tag
		if width != unsupplied then _panel.Width = width
		if height  != unsupplied then _panel.Height = height
		if background != unsupplied then _panel.background = SolidColorBrush background
		if hAlign != unsupplied then _panel.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _panel.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _panel.Margin = Thickness margin
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		if lastChildFill != unsupplied then _panel.LastChildFill = lastChildFill
		
		_panel
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
		if name != unsupplied then _panel.Name = name
		if tag != unsupplied then _panel.Tag = tag
		if width != unsupplied then _panel.width = width
		if height  != unsupplied then _panel.height = height
		if background != unsupplied then _panel.background = SolidColorBrush background
		if hAlign != unsupplied then _panel.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _panel.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _panel.Margin = Thickness margin
		if innerMargin != unsupplied then _panel.InnerMargin = Thickness innerMargin
		if orientation != unsupplied then _panel.Orientation = this.Orientation orientation
		
		_panel
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if width != unsupplied then _control.Width = width
		if height != unsupplied then _control.HeaderHeight = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = this.CornerRadius cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
		if child != unsupplied then _control.Child = child
		
		_control
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if text != unsupplied then _control.Text = text
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		_control.Foreground = SolidColorBrush foreground
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Expander
		name:
		tag:
		header:
		isGroupBox:
		isExpanded:
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
		margin: 
		content: = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzExpander"
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if header != unsupplied then _control.Header = header
		if isGroupBox != unsupplied then _control.IsGroupBox = isGroupBox
		if isExpanded != unsupplied then _control.IsExpanded = isExpanded
		if width != unsupplied then _control.Width = width
		if height != unsupplied then _control.HeaderHeight = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if headerBrush != unsupplied then _control.HeaderBrush = SolidColorBrush headerBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
		if content != unsupplied then _control.Content = content
		
		_control
	),



	-- Return a SugzTools.Controls.SgzGroupBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GroupBox
		name:
		tag:
		header:
		width:
		height:
		foreground:
		borderBrush: 
		borderThickness: 
		cornerRadius:
		hAlign:
		vAlign:
		margin: 
		content: = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzGroupBox"
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if header != unsupplied then _control.Header = header
		if width != unsupplied then _control.Width = width
		if height != unsupplied then _control.HeaderHeight = height
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
		if content != unsupplied then _control.Content = content
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Button
		name:
		tag:
		enabled:
		content:
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if enabled != unsupplied then _control.IsEnabled = enabled
		if content != unsupplied then _control.Content = content
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if transparent != unsupplied then _control.IsTransparent = transparent
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzCheckButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckButton
		name:
		tag:
		content:
		isChecked:
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if content != unsupplied then _control.Content = content
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if transparent != unsupplied then _control.IsTransparent = transparent
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius	
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	-- Return a SugzTools.Controls.SgzCheckBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckBox
		name:
		tag:
		content:
		isChecked:
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if content != unsupplied then _control.Content = content
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
		
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzRadioButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButton
		name:
		tag:
		content:
		isChecked:
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if content != unsupplied then _control.Content = content
		if isChecked != unsupplied then _control.IsChecked = dotNetObject "System.Boolean" isChecked
		if group != unsupplied then _control.GroupName = group
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if type != unsupplied then _control.RadioButtonType = RadioButtonTypes type
		if transparent != unsupplied then _control.IsTransparent = transparent
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != unsupplied then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != unsupplied then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != unsupplied then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius	
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		if click != unsupplied then dotNet.addEventHandler _control "Click" click
		if checked != unsupplied then dotNet.addEventHandler _control "Checked" checked
		if unchecked != unsupplied then dotNet.addEventHandler _control "Unchecked" unchecked
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzTextBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn TextBox
		name:
		tag:
		text:
		watermark:
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
		
		_control = dotNetObject "SugzTools.Controls.SgzMaxTextbox"
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if text != unsupplied then _control.Text = text
		if watermark != unsupplied then _control.Watermark = watermark
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if caretbrush != unsupplied then _control.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
		if textChanged != unsupplied then dotNet.addEventHandler _control "TextChanged" textChanged
		dotNet.setLifetimeControl _control #dotnet
	
		_control
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if content != unsupplied then _control.Content = content
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
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if fieldWidth != unsupplied then _control.FieldWidth = fieldWidth
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if caretbrush != unsupplied then _control.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != unsupplied then _control.SelectionBrush = SolidColorBrush selectionBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin
			
		if validate != unsupplied then dotNet.addEventHandler _control "Validate" validate
		if valueChanged != unsupplied then dotNet.addEventHandler _control "ValueChanged" valueChanged
		dotNet.setLifetimeControl _control #dotnet
	
		_control
	),



	-- Return a SugzTools.Controls.SgzProgressBar ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn ProgressBar 
		name:
		tag:
		value:
		isIndeterminate:
		indeterminateAutoReverse:
		isCylon:
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
		if name != unsupplied then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if value != unsupplied then _control.Value = value
		if isIndeterminate != unsupplied then _control.IsIndeterminate = isIndeterminate
		if indeterminateAutoReverse != unsupplied then _control.IndeterminateAutoReverse = indeterminateAutoReverse
		if isCylon != unsupplied then _control.isCylon = isCylon
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if indeterminateBrush != unsupplied then _control.IndeterminateBrush = SolidColorBrush indeterminateBrush
		if cylonBrush != unsupplied then _control.CylonBrush = SolidColorBrush cylonBrush
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin

		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzComboBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn ComboBox 
		name:
		tag:
		items:
		selectedIndex: 0
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
		if name != unsupplied  then _control.Name = name
		if tag != unsupplied then _control.Tag = tag
		if items != unsupplied then _control.SetItems items
		_control.SelectedIndex = selectedIndex
		if width != unsupplied then _control.Width = width
		if height  != unsupplied then _control.Height = height
		if background != unsupplied then _control.Background = SolidColorBrush background
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != unsupplied then _control.CornerRadius = cornerRadius
		if hAlign != unsupplied then _control.HorizontalAlignment = HorizontalAlignment hAlign
		if vAlign != unsupplied then _control.VerticalAlignment = VerticalAlignment vAlign
		if margin != unsupplied then _control.Margin = Thickness margin

		if selectionChanged != unsupplied then dotNet.addEventHandler _control "SelectionChanged" selectionChanged
		dotNet.setLifetimeControl _control #dotnet

		_control
	),



	-- Return a System.Windows.Controls.Image ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Image 
		uri:
		stretch: 
		name:
		tag:
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
	)
	
)

_wpf = WpfStruct()

