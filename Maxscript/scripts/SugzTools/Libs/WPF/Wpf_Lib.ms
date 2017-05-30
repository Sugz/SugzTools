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
	- Add dock property to every constructor

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
	_canvas = dotNetClass "System.Windows.Controls.Canvas",
	_cornerRadius = dotNetClass "System.Windows.CornerRadius",
	_cursor = dotNetClass "System.Windows.Input.Cursor",
	_dock = dotNetClass "System.Windows.Controls.DockPanel",
	_fontFamily = dotNetClass "System.Windows.Media.FontFamily",
	_solidColorBrush = dotNetClass "System.Windows.Media.SolidColorBrush",
	_thickness = dotNetClass "System.Windows.Thickness",


	-- SugzTools Class ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_spacing = dotNetClass "SugzTools.Behaviors.Spacing",
	_helper = dotNetClass "SugzTools.Max.Helper",


	-- Max Objects ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_node = dotNetClass "SugzTools.Max.Node",
	Scene = dotNetObject "SugzTools.Max.Scene",
	Objects = Scene.Objects,
	Selection = Scene.Selection,



	fn AsArray arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		return _helper.AsArray arg
	),




	fn Node arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		return Scene.GetNodeByHandle arg.handle
	),



	fn Nodes arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		handles = for obj in arg collect obj.handle
		return Scene.GetNodesByHandle handles
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
				#Grey: return _color.FromArgb 255 128 128 128
				#Transparent: return _color.FromArgb 0 255 255 255
				
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

		-- Return a .NET argb color from an array 
		else if iskindof arg array then
		(
			if arg.count == 3 then return _color.FromArgb 255 arg[1] arg[2] arg[3]
			if arg.count == 4 then return _color.FromArgb arg[1] arg[2] arg[3] arg[4]
		)
	),



	fn GetType arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		
		return (dotNetObject arg).GetType()
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
		width: 217
		height: 300 
		minimumSize:
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
		if minimumSize != unsupplied AND isKindOF minimumSize Array then _wnd.MinimumSize = dotnetobject (dotNetClass "System.Drawing.Size") minimumSize[1] minimumSize[2]
		if title != unsupplied then _wnd.Text = title
		if borderStyle != unsupplied then _wnd.FormBorderStyle = Enums.FormBorderStyle borderStyle
		if location != unsupplied then _wnd.StartPosition  = Enums.FormStartPosition location
		if content != unsupplied then _wnd.Content = content
		
		if load != unsupplied then dotNet.addEventHandler _wnd "Load" load
		if closed != unsupplied then dotNet.addEventHandler _wnd "FormClosed" closed
		dotNet.setLifetimeControl _wnd #dotnet
		
		_wnd
	),



	include "$userScripts\SugzTools\Libs\WPF\BaseClass.ms",
	include "$userScripts\SugzTools\Libs\WPF\ItemsControl.ms",
	include "$userScripts\SugzTools\Libs\WPF\Panels.ms",
	include "$userScripts\SugzTools\Libs\WPF\Expander.ms",
	include "$userScripts\SugzTools\Libs\WPF\Buttons.ms",
	include "$userScripts\SugzTools\Libs\WPF\TextBox.ms",
	include "$userScripts\SugzTools\Libs\WPF\NumericUpDown.ms",
	include "$userScripts\SugzTools\Libs\WPF\Divers.ms",



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