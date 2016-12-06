/*##############################################################################
SugzTools WPF Wrapper Library
Version 2.01
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

struct WpfStruct
(
	-- Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_color = dotNetClass "System.Windows.Media.Color",
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_windowStyle = dotNetClass "System.Windows.WindowStyle",
	_windowStartupLocation = dotNetClass "System.Windows.WindowStartupLocation",
	_horizontalAlignment = dotNetClass "System.Windows.HorizontalAlignment",
	_orientation = dotNetClass "System.Windows.Controls.Orientation",
	_radioButtonTypes = dotNetClass "SugzTools.Src.RadioButtonTypes",
	_gridUnitType = dotNetClass "System.Windows.GridUnitType",
	
	
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
		
		if (classOf arg != dotNetObject) then arg = _wpf.Color arg
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
		if (not isKindOf arg array ) or (arg.count == 1) then thickness = #(arg, arg, arg, arg)
		else if arg.count == 2 then thickness =#(arg[1], arg[2], arg[1], arg[2])
		else thickness = arg
		
		return (dotnetObject "System.Windows.Thickness" thickness[1] thickness[2] thickness[3] thickness[4])
	),
	
	
	
	-- Return a System.Windows.WindowStyle ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn WindowStyle arg = 
	(
		/*<Function>
		Description:
			Enum to return the window style
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#none: return _windowStyle.none
			#toolWindow: return _windowStyle.toolWindow
			#singleBorderWindow: return _windowStyle.SingleBorderWindow
			#threeDBorderWindow: return _windowStyle.ThreeDBorderWindow
		)
	),
	
	
	
	-- Return a System.Windows.WindowStartupLocation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn WindowLocation arg = 
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
			#centerOwner: return _windowStartupLocation.CenterOwner
			#centerScreen: return _windowStartupLocation.CenterScreen
			#manual: return _windowStartupLocation.Manual
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
	
	
	
	-- Return a SugzTools.Src.LabelPlacement
	fn LabelPlacement arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_side = dotNetClass "SugzTools.Src.LabelPlacement"
		case arg of 
		(
			#left: return _side.Left
			#right: return _side.Right
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
	
	
	
	-- Return a System.Windows.Window ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Window 
		width: 200
		height: 300 
		title: undefined 
		background: undefined
		windowStyle: undefined 
		location: undefined
		content: undefined 
		show: undefined =
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
-- 		if background != undefined then _wnd.Background = SolidColorBrush background
-- 		if title != undefined then _wnd.Title = title
-- 		if windowStyle != undefined then _wnd.WindowStyle = WindowStyle windowStyle
-- 		if location != undefined then _wnd.WindowStartupLocation =  WindowLocation location
		if content != undefined then _wnd.Content = content
		
		
		
		_wnd
	),
	
	
	
	-- Return a SugzTools.Controls.SgzGrid ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Grid 
		width: undefined 
		height: undefined 
		background: undefined 
		margin: undefined =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzGrid"
		if width != undefined then _panel.Width = width
		if height  != undefined then _panel.Height = height
		if background != undefined then _panel.background = SolidColorBrush background
		if margin != undefined then _panel.Margin = Thickness margin
		
		_panel
	),
	
	
	
	-- Return a System.Windows.Controls.DockPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn DockPanel 
		width: undefined 
		height: undefined 
		background: undefined 
		margin: undefined 
		lastChildFill: true = 
	(
		/*<Function>
		Description:
			Return a DockPanel 
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzDockPanel"
		if width != undefined then _panel.Width = width
		if height  != undefined then _panel.Height = height
		if background != undefined then _panel.background = SolidColorBrush background
		if margin != undefined then _panel.Margin = Thickness margin
		_panel.LastChildFill = LastChildFill
		
		_panel
	),
	
	
	
	-- Return a SugzTools.Controls.SgzStackPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn StackPanel 
		width: undefined 
		height: undefined 
		background: undefined 
		margin: undefined 
		innerMargin: undefined
		orientation: undefined = 
	(
		/*<Function>
		Description:
			Return a StackPanel
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_panel = dotNetObject "SugzTools.Controls.SgzStackPanel"
		if width != undefined then _panel.width = width
		if height  != undefined then _panel.height = height
		if background != undefined then _panel.background = SolidColorBrush background
		if margin != undefined then _panel.Margin = Thickness margin
		if innerMargin != undefined then _panel.InnerMargin = Thickness innerMargin
		if orientation != undefined then _panel.Orientation = GetOrientation orientation
		
		_panel
	),
	
	
	
	-- Return a System.Windows.Controls.TextBlock ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn TextBlock 
		text:undefined
		width: undefined 
		height: undefined 
		background: undefined
		foreground: #MaxText
		align:undefined
		margin: undefined =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "System.Windows.Controls.TextBlock"
		if text != undefined then _control.Text = text
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if background != undefined then _control.Background = SolidColorBrush background
		_control.Foreground = SolidColorBrush foreground
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
			
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Expander
		header: undefined
		width: undefined
		height: undefined
		isExpanded: true
		background: undefined
		foreground: undefined
		headerBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined 
		cornerRadius: undefined
		margin: undefined 
		content: undefined = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzExpander"
		if header != undefined then _control.Header = header
		if width != undefined then _control.Width = width
		if height != undefined then _control.HeaderHeight = height
		_control.IsExpanded = isExpanded
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if headerBrush != undefined then _control.HeaderBrush = SolidColorBrush headerBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius	
		if margin != undefined then _control.Margin = Thickness margin
		if content != undefined then _control.Content = content
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Button 
		text: undefined
		width: undefined
		height: undefined
		transparent: undefined
		background: undefined 
		foreground: undefined
		mouseOverBrush: undefined
		mouseDownBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined 
		cornerRadius: undefined
		align:undefined
		margin: undefined 
		clickEvent: undefined = 
	(
		/*<Function>
		Description:
			Return a Button
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzButton"
		if text != undefined then _control.Content = text
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if transparent != undefined then _control.IsTransparent = transparent
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _control "Click" clickEvent
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzCheckButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckButton 
		text: undefined
		checked: undefined
		width: undefined
		height: undefined
		transparent: undefined
		background: undefined 
		foreground: undefined
		mouseOverBrush: undefined
		mouseDownBrush: undefined
		checkBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined 
		cornerRadius: undefined
		align:undefined
		margin: undefined 
		clickEvent: undefined
		checkedEvent: undefined 
		uncheckedEvent: undefined = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzCheckButton"
		if text != undefined then _control.Content = text
		if checked != undefined then _control.IsChecked = dotNetObject "System.Boolean" checked
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if transparent != undefined then _control.IsTransparent = transparent
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != undefined then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius	
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _control "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _control "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _control "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	-- Return a SugzTools.Controls.SgzCheckBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CheckBox 
		text: undefined
		checked: undefined
		width: undefined
		height: undefined
		textSide: undefined
		align:undefined
		background: undefined 
		foreground: undefined
		mouseOverBrush: undefined
		checkBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined
		cornerRadius: undefined
		margin: undefined 
		clickEvent: undefined
		checkedEvent: undefined 
		uncheckedEvent: undefined = 
	(
		_control = dotNetObject "SugzTools.Controls.SgzCheckBox"
		if text != undefined then _control.Content = text
		if checked != undefined then _control.IsChecked = dotNetObject "System.Boolean" checked
		if textSide != undefined then _control.LabelPlacement = LabelPlacement textSide
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if checkBrush != undefined then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
		
		if clickEvent != undefined then dotNet.addEventHandler _control "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _control "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _control "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzRadioButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButton 
		text: undefined
		checked: undefined
		group: undefined
		width: undefined 
		height: undefined
		type: undefined
		textSide: undefined
		transparent: false
		background: undefined 
		foreground: undefined
		mouseOverBrush: undefined
		mouseDownBrush: undefined
		checkBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined 
		cornerRadius: undefined
		align: undefined
		margin: undefined 
		clickEvent: undefined
		checkedEvent: undefined 
		uncheckedEvent: undefined = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzRadioButton"
		if text != undefined then _control.Content = text
		if checked != undefined then _control.IsChecked = dotNetObject "System.Boolean" checked
		if group != undefined then _control.GroupName = group
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if type != undefined then _control.RadioButtonType = RadioButtonTypes type
		if textSide != undefined then _control.LabelPlacement = LabelPlacement textSide
		if transparent != undefined then _control.IsTransparent = transparent
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _control.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _control.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != undefined then _control.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius	
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _control "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _control "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _control "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _control #dotnet
		
		_control
	),
	
	
	
	-- Return a SugzTools.Controls.SgzTextBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn TextBox 
		text: undefined
		width: undefined 
		height: undefined
		background: undefined 
		foreground: undefined
		caretbrush: undefined
		selectionBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined
		cornerRadius: undefined
		align: undefined
		margin: undefined 
		textChangedEvent: undefined =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_control = dotNetObject "SugzTools.Controls.SgzTextBox"
		if text != undefined then _control.Text = text
		if width != undefined then _control.Width = width
		if height  != undefined then _control.Height = height
		if background != undefined then _control.Background = SolidColorBrush background
		if foreground != undefined then _control.Foreground = SolidColorBrush foreground
		if caretbrush != undefined then _control.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != undefined then _control.SelectionBrush = SolidColorBrush selectionBrush
		if borderBrush != undefined then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _control.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _control.CornerRadius = cornerRadius
		if align != undefined then _control.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _control.Margin = Thickness margin
			
		if textChangedEvent != undefined then dotNet.addEventHandler _control "TextChanged" textChangedEvent
		dotNet.setLifetimeControl _control #dotnet
	
		_control
	)
	
	
	-- Return a SugzTools.Controls.SgzComboBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	-- Return a SugzTools.Controls.SgzNumericUpDown ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
)

global _wpf = WpfStruct()