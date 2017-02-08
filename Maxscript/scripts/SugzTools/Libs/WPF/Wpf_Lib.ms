/*##############################################################################
SugzTools WPF Wrapper Library
Version 2.1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Maxscript wrapper for WPF, aim to easily design WPF UI inside maxscript

# Required Components:

# Sources:

# ToDo:
	- Cursor: check if it's a string, valid path to a .cur file then use it...

# History:
2.1:
	- Mxs: Rewrite the struct, splitting each class into different files and adding tones of property
	- C#: Change the InnerMargin to an AttachedProperty to avoid derived classes
2.0:
	- Rewrite the C# assembly from the ground up and update the MXS wrapper
1.0:
	- Initial C# assembly and the Mxs wrapper 

*Use / Modify this script at your own risk !*
###############################################################################*/


global Wpf
struct WpfStruct
(
	-- The struct containing the enums ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	Enums,

	-- NET Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_double = dotNetClass "System.Double",
	_color = dotNetClass "System.Windows.Media.Color",

	
	-- WinForm Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_maxForm = dotNetClass "SugzTools.Controls.SgzMaxForm",


	-- WPF Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_cornerRadius = dotNetClass "System.Windows.CornerRadius",
	_cursor = dotNetClass "System.Windows.Input.Cursor",
	_fontFamily = dotNetClass "System.Windows.Media.FontFamily",
	_solidColorBrush = dotNetClass "System.Windows.Media.SolidColorBrush",
	_thickness = dotNetClass "System.Windows.Thickness",


	-- SugzTools Class ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_spacing = dotNetClass "SugzTools.Behaviors.Spacing",




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
		
		return (dotnetObject _cornerRadius cornerRadius[1] cornerRadius[2] cornerRadius[3] cornerRadius[4])
	),


	-- Return a System.Windows.Input.Cursor ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Cursor arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		if isKindOf arg Name then return (Enums.Cursors arg)
	),


	-- Return a System.Windows.Media.FontFamily ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FontFamily arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		return (dotNetObject _fontFamily arg)
	),


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
		if iskindof arg color then return _color.FromArgb (arg.a) (arg.r) (arg.g) (arg.b)
				
		-- Return a .NET argb color from a preset
		else if iskindof arg Name then 
		(
			case arg of 
			(
				#grey: return _color.FromArgb 255 128 128 128
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

		-- Return a .NET argb color from an array 
		else if iskindof arg array then
		(
			if arg.count == 3 then return _color.FromArgb 255 arg[1] arg[2] arg[3]
			if arg.count == 4 then return _color.FromArgb arg[1] arg[2] arg[3] arg[4]
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
		return (dotNetObject _solidColorBrush arg)
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



	-- Return a SugzTools.Controls.SgzMaxForm (Inherit from MaxForm) ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
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
		_wnd = dotNetObject _maxForm
		_wnd.Width = width
		_wnd.Height = height 		
		if title != unsupplied then _wnd.Text = title
		if borderStyle != unsupplied then _wnd.FormBorderStyle = Enums.FormBorderStyle borderStyle
		if location != unsupplied then _wnd.StartPosition  = Enums.FormStartPosition location
		if content != unsupplied then _wnd.Content = content
		
		if load != unsupplied then dotNet.addEventHandler _wnd "Load" load
		if closed != unsupplied then dotNet.addEventHandler _wnd "FormClosed" closed
		dotNet.setLifetimeControl _wnd #dotnet
		
		_wnd
	),



	-- Set most of the properties and event handlers for a System.Windows.Controls.ContentControl ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn ContentControl 
		_control
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

		if background != unsupplied then _control.background = SolidColorBrush background
		if borderBrush != unsupplied then _control.BorderBrush = SolidColorBrush borderBrush
		if borderThickness != unsupplied then _control.BorderThickness = Thickness borderThickness
		if clipToBounds != unsupplied then _control.ClipToBounds = clipToBounds
		if contextMenu != unsupplied then _control.ContextMenu = contextMenu
		if cursor != unsupplied then _control.Cursor = this.Cursor cursor
		if content != unsupplied then _control.Content = content
		if cornerRadius != unsupplied then _control.CornerRadius =
		(
			if (isKindOf (getProperty _control "CornerRadius") Integer) 
				then cornerRadius
				else CornerRadius cornerRadius
		)
		if focusable != unsupplied then _control.Focusable = focusable
		if fontFamily != unsupplied then _control.FontFamily = this.FontFamily fontFamily
		if fontSize != unsupplied then _control.FontSize = fontSize
		if fontStretch != unsupplied then _control.FontStretch = Enums.FontStretches fontStretch
		if fontStyle != unsupplied then _control.FontStyle = Enums.FontStyles fontStyle
		if fontWeight != unsupplied then _control.FontWeight = Enums.FontWeights fontWeight
		if foreground != unsupplied then _control.Foreground = SolidColorBrush foreground
		if height != unsupplied then _control.Height = height
		if hAlign != unsupplied then _control.HorizontalAlignment = Enums.HorizontalAlignment hAlign
		if hContentAlign != unsupplied then _control.HorizontalContentAlignment = Enums.HorizontalAlignment hContentAlign
		if isEnabled != unsupplied then _control.IsEnabled = isEnabled
		if isTabStop != unsupplied then _control.isTabStop = isTabStop
		if margin != unsupplied then _control.Margin = Thickness margin
		if maxHeight != unsupplied then _control.MaxHeight = maxHeight
		if maxWidth != unsupplied then _control.MaxWidth = maxWidth
		if minHeight != unsupplied then _control.MinHeight = minHeight
		if minWidth != unsupplied then _control.MinWidth = minWidth
		if name != unsupplied then _control.Name = name
		if opacity != unsupplied then _control.Opacity = opacity
		if padding != unsupplied then _control.Padding = Thickness padding
		if snapsToDevicePixels != unsupplied then _control.SnapsToDevicePixels = snapsToDevicePixels
		if tabIndex != unsupplied then _control.TabIndex = tabIndex
		if tag != unsupplied then _control.Tag = tag
		if tooltip != unsupplied then _control.Tooltip = tooltip
		if uid != unsupplied then _control.Uid = uid
		if useLayoutRounding != unsupplied then _control.UseLayoutRounding = useLayoutRounding
		if vAlign != unsupplied then _control.VerticalAlignment = Enums.VerticalAlignment vAlign
		if vContentAlign != unsupplied then _control.VerticalContentAlignment = Enums.VerticalAlignment vContentAlign
		if visibility != unsupplied then _control.Visibility = Enums.Visibility visibility
		if width != unsupplied then _control.Width = width

		if initialized != unsupplied then dotNet.addEventHandler _control "Initialized" initialized
		if isEnabledChanged != unsupplied then dotNet.addEventHandler _control "IsEnabledChanged" isEnabledChanged
		if keyDown != unsupplied then dotNet.addEventHandler _control "KeyDown" keyDown
		if keyUp != unsupplied then dotNet.addEventHandler _control "keyUp" keyUp
		if loaded != unsupplied then dotNet.addEventHandler _control "Loaded" loaded
		if mouseDoubleClick != unsupplied then dotNet.addEventHandler _control "MouseDoubleClick" mouseDoubleClick
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
		if sizeChanged != unsupplied then dotNet.addEventHandler _control "SizeChanged" sizeChanged

		dotNet.setLifetimeControl _control #dotnet

		_control
	),



	-- Return a SugzTools.Controls.SgzExpandersControl ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	include "$userScripts\SugzTools\Libs\WPF\Panels.ms",

	-- Return a SugzTools.Controls.SgzExpander ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	include "$userScripts\SugzTools\Libs\WPF\Expander.ms",

	-- Return a SugzTools.Controls.SgzButton ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	include "$userScripts\SugzTools\Libs\WPF\Buttons.ms",

	-- Return a SugzTools.Controls.SgzTextBox ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	include "$userScripts\SugzTools\Libs\WPF\TextBox.ms",

	-- Return a SugzTools.Controls.SgzMaxNumericUpDown ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	include "$userScripts\SugzTools\Libs\WPF\NumericUpDown.ms",



	fn Run = 
	(
		-- Get the wpf Enum
		if doesFileExist "$userScripts\SugzTools\Libs\WPF\WpfEnums_Lib.ms" then 
		(
			include "$userScripts\SugzTools\Libs\WPF\WpfEnums_Lib.ms"
			Enums = WpfEnumStruct()
		)
		else format "Cannot locate WpfEnums_Lib.ms\n"
	)

)
Wpf = WpfStruct()
Wpf.Run()