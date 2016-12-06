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
	
	
	-- Return a System.Windows.Media.Color ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GetColor clr = 
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
		if classOf clr == Color then return _color.FromArgb (clr.a) (clr.r) (clr.g) (clr.b)
				
		-- Return a .NET argb color from a preset
		else 
		(
			case clr of 
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
	fn SolidColorBrush clr = 
	(
		/*<Function>
		Description:
			Return a SolidColorBrush
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		if (classOf clr != dotNetObject) then clr = GetColor clr
		return (dotNetObject "System.Windows.Media.SolidColorBrush" clr)
	),
	
	
	
	-- Return a System.Windows.Thickness ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Thickness input = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		local thickness = #()
		if not isKindOf input array then thickness = #(input, input, input, input)
		else if input.count == 2 then thickness =#(input[1], input[2], input[1], input[2])
		else thickness = input
		
		return (dotnetObject "System.Windows.Thickness" thickness[1] thickness[2] thickness[3] thickness[4])
	),
	
	
	
	-- Return a System.Windows.WindowStyle ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn WindowStyle style = 
	(
		/*<Function>
		Description:
			Enum to return the window style
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_style = dotNetClass "System.Windows.WindowStyle"
		case style of 
		(
			#none: return _style.none
			#toolWindow: return _style.toolWindow
			#singleBorderWindow: return _style.SingleBorderWindow
			#threeDBorderWindow: return _style.ThreeDBorderWindow
		)
	),
	
	
	
	-- Return a System.Windows.WindowStartupLocation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn WindowLocation location = 
	(
		/*<Function>
		Description:
			Enum to return the window location
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_location = dotNetClass "System.Windows.WindowStartupLocation"
		case location of
		(
			#centerOwner: return _location.CenterOwner
			#centerScreen: return _location.CenterScreen
			#manual: return _location.Manual
		)
	),
	
	
	
	-- Return a System.Windows.HorizontalAlignment ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn HorizontalAlignment align =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_align = dotNetClass "System.Windows.HorizontalAlignment"
		case align of
		(
			#left: return _align.Left
			#center: return _align.Center
			#right: return _align.Right
			#stretch: return _align.Stretch
		)
	),
	
	
	
	-- Return a System.Windows.Controls.Orientation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GetOrientation orientation =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_orientation = dotNetClass "System.Windows.Controls.Orientation"
		case orientation of
		(
			#horizontal: return _orientation.Horizontal
			#vertical: return _orientation.Vertical
		)
	),
	
	
	
	-- Return a SugzTools.Src.LabelPlacement
	fn LabelPlacement side =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_side = dotNetClass "SugzTools.Src.LabelPlacement"
		case side of 
		(
			#left: return _side.Left
			#right: return _side.Right
		)
	),
	
	
	
	-- Return a SugzTools.Src.RadioButtonTypes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButtonTypes type =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_type = dotNetClass "SugzTools.Src.RadioButtonTypes"
		case type of 
		(
			#standard: return _type.Standard
			#checkButton: return _type.CheckButton
		)
	),
	
	
	
	-- Return a System.Windows.GridUnitType  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GridUnitType type =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_gridUnitType = dotNetClass "System.Windows.GridUnitType"
		case type of 
		(
			#auto: return _gridUnitType.Auto
			#pixel: return _gridUnitType.Pixel
			#star: return _gridUnitType.Star
		)
	),
	
	
	
	-- Return a System.Windows.Controls.Dock ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Dock side =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case side of 
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
		show: false =
	(
		/*<Function>
		Description:
			Return a Window
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		-- Define the window
		_wnd = dotNetObject "SugzTools.Controls.SgzWindow"
		_wnd.Width = width + 16
		_wnd.Height = height
		_wnd.SetForMax()
		if background != undefined then _wnd.Background = SolidColorBrush background
		if title != undefined then _wnd.Title = title
		if windowStyle != undefined then _wnd.WindowStyle = WindowStyle windowStyle
		if location != undefined then _wnd.WindowStartupLocation =  WindowLocation location
		if content != undefined then _wnd.Content = content
		if show then _wnd.Show()
		
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
		
		_pnl = dotNetObject "SugzTools.Controls.SgzGrid"
		if width != undefined then _pnl.width = width
		if height  != undefined then _pnl.height = height
		if background != undefined then _pnl.background = GetSolidColorBrush background
		if margin != undefined then _pnl.Margin = Thickness margin
		
		_pnl
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
		
		_pnl = dotNetObject "SugzTools.Controls.SgzDockPanel"
		if width != undefined then _pnl.width = width
		if height  != undefined then _pnl.height = height
		if background != undefined then _pnl.background = GetSolidColorBrush background
		if margin != undefined then _pnl.Margin = Thickness margin
		_pnl.LastChildFill = LastChildFill
		
		_pnl
	),
	
	
	
	-- Return a SugzTools.Controls.SgzStackPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn StackPanel 
		width: undefined 
		height: undefined 
		background: undefined 
		margin: undefined 
		orientation: undefined = 
	(
		/*<Function>
		Description:
			Return a StackPanel
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_pnl = dotNetObject "SugzTools.Controls.SgzStackPanel"
		if width != undefined then _pnl.width = width
		if height  != undefined then _pnl.height = height
		if background != undefined then _pnl.background = GetSolidColorBrush background
		if margin != undefined then _pnl.Margin = Thickness margin
		if orientation != undefined then _pnl.Orientation = GetOrientation orientation
		
		_pnl
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
		
		_txt = dotNetObject "System.Windows.Controls.TextBlock"
		if text != undefined then _txt.Text = text
		if width != undefined then _txt.Width = width
		if height  != undefined then _txt.Height = height
		if background != undefined then _txt.Background = SolidColorBrush background
		_txt.Foreground = SolidColorBrush foreground
		if align != undefined then _txt.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _txt.Margin = Thickness margin
			
		_txt
	),
	
	
	
	-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Expander
		header: undefined
		width: undefined
		height: undefined
		isExpanded: false
		background: undefined
		foreground: undefined
		headerBrush: undefined
		borderBrush: undefined 
		borderThickness: undefined 
		cornerRadius: undefined
		margin: undefined 
		content: undefined = 
	(
		_exp = dotNetObject "SugzTools.Controls.SgzExpander"
		if header != undefined then _exp.Header = header
		if width != undefined then _exp.Width = width
		if height != undefined then _exp.HeaderHeight = height
		_exp.IsExpanded = isExpanded
		if background != undefined then _exp.Background = SolidColorBrush background
		if foreground != undefined then _exp.Foreground = SolidColorBrush foreground
		if headerBrush != undefined then _exp.HeaderBrush = SolidColorBrush headerBrush
		if borderBrush != undefined then _exp.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _exp.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _exp.CornerRadius = cornerRadius	
		if margin != undefined then _exp.Margin = Thickness margin
		if content != undefined then _exp.Content = content
		
		_exp
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
		
		_btn = dotNetObject "SugzTools.Controls.SgzButton"
		if text != undefined then _btn.Content = text
		if width != undefined then _btn.Width = width
		if height  != undefined then _btn.Height = height
		if transparent != undefined then _btn.IsTransparent = transparent
		if background != undefined then _btn.Background = SolidColorBrush background
		if foreground != undefined then _btn.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _btn.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _btn.MouseDownBrush = SolidColorBrush mouseDownBrush
		if borderBrush != undefined then _btn.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _btn.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _btn.CornerRadius = cornerRadius
		if align != undefined then _btn.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _btn.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _btn "Click" clickEvent
		dotNet.setLifetimeControl _btn #dotnet
		
		_btn
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
		
		_btn = dotNetObject "SugzTools.Controls.SgzCheckButton"
		if text != undefined then _btn.Content = text
		if checked != undefined then _btn.IsChecked = dotNetObject "System.Boolean" checked
		if width != undefined then _btn.Width = width
		if height  != undefined then _btn.Height = height
		if transparent != undefined then _btn.IsTransparent = transparent
		if background != undefined then _btn.Background = SolidColorBrush background
		if foreground != undefined then _btn.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _btn.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _btn.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != undefined then _btn.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _btn.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _btn.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _btn.CornerRadius = cornerRadius	
		if align != undefined then _btn.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _btn.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _btn "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _btn "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _btn "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _btn #dotnet
		
		_btn
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
		_chb = dotNetObject "SugzTools.Controls.SgzCheckBox"
		if text != undefined then _chb.Content = text
		if checked != undefined then _chb.IsChecked = dotNetObject "System.Boolean" checked
		if textSide != undefined then _chb.LabelPlacement = LabelPlacement textSide
		if width != undefined then _chb.Width = width
		if height  != undefined then _chb.Height = height
		if background != undefined then _chb.Background = SolidColorBrush background
		if foreground != undefined then _chb.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _chb.MouseOverBrush = SolidColorBrush mouseOverBrush
		if checkBrush != undefined then _chb.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _chb.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _chb.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _chb.CornerRadius = cornerRadius
		if align != undefined then _chb.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _chb.Margin = Thickness margin
		
		if clickEvent != undefined then dotNet.addEventHandler _chb "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _chb "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _chb "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _chb #dotnet
		
		_chb
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
		
		_rdb = dotNetObject "SugzTools.Controls.SgzRadioButton"
		if text != undefined then _rdb.Content = text
		if checked != undefined then _rdb.IsChecked = dotNetObject "System.Boolean" checked
		if group != undefined then _rdb.GroupName = group
		if width != undefined then _rdb.Width = width
		if height  != undefined then _rdb.Height = height
		if type != undefined then _rdb.RadioButtonType = RadioButtonTypes type
		if textSide != undefined then _rdb.LabelPlacement = LabelPlacement textSide
		if transparent != undefined then _rdb.IsTransparent = transparent
		if background != undefined then _rdb.Background = SolidColorBrush background
		if foreground != undefined then _rdb.Foreground = SolidColorBrush foreground
		if mouseOverBrush != undefined then _rdb.MouseOverBrush = SolidColorBrush mouseOverBrush
		if mouseDownBrush != undefined then _rdb.MouseDownBrush = SolidColorBrush mouseDownBrush
		if checkBrush != undefined then _rdb.CheckedBrush = SolidColorBrush checkBrush
		if borderBrush != undefined then _rdb.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _rdb.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _rdb.CornerRadius = cornerRadius	
		if align != undefined then _rdb.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _rdb.Margin = Thickness margin
			
		if clickEvent != undefined then dotNet.addEventHandler _rdb "Click" clickEvent
		if checkedEvent != undefined then dotNet.addEventHandler _rdb "Checked" checkedEvent
		if uncheckedEvent != undefined then dotNet.addEventHandler _rdb "Unchecked" uncheckedEvent
		dotNet.setLifetimeControl _rdb #dotnet
		
		_rdb
	),
	
	
	
	
	-- Return a SugzTools.Controls.SgzComboBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
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
		
		_txt = dotNetObject "SugzTools.Controls.SgzTextBox"
		if text != undefined then _txt.Text = text
		if width != undefined then _txt.Width = width
		if height  != undefined then _txt.Height = height
		if background != undefined then _txt.Background = SolidColorBrush background
		if foreground != undefined then _txt.Foreground = SolidColorBrush foreground
		if caretbrush != undefined then _txt.CaretBrush = SolidColorBrush caretbrush
		if selectionBrush != undefined then _txt.SelectionBrush = SolidColorBrush selectionBrush
		if borderBrush != undefined then _txt.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != undefined then _txt.BorderThickness = Thickness borderThickness
		if cornerRadius != undefined then _txt.CornerRadius = cornerRadius
		if align != undefined then _txt.HorizontalAlignment = HorizontalAlignment align
		if margin != undefined then _txt.Margin = Thickness margin
			
		if textChangedEvent != undefined then dotNet.addEventHandler _txt "TextChanged" textChangedEvent
		dotNet.setLifetimeControl _txt #dotnet
	
		_txt
	),
	
	
	
	-- Return a SugzTools.Controls.SgzNumericUpDown ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
	
	
	-- Return a SugzTools.Controls.SgzToolbar----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Toolbar =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		_dialog = (dotNetClass "SugzTools.Max.Cui.Cui").GetToolBar()
	 
		_dialog
	)
	
)

global _wpf = WpfStruct()