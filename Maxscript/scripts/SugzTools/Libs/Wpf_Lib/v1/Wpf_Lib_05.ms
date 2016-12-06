struct WpfStruct
(
	-- Classes
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_color = dotNetClass "System.Windows.Media.Color",
	
	
	
	-- Colors	
	fn ColorPresetsFn clr = 
	(
-- 		local theColor
		case clr of 
		(
-- 			#red: theColor = _color.FromArgb 255 255 0 0
-- 			#green: theColor = _color.FromArgb 255 0 255 0
-- 			#blue: theColor = _color.FromArgb 255 0 0 255
-- 			#maxBackground: theColor = _color.FromArgb 255 68 68 68
			#red: return _color.FromArgb 255 255 0 0
			#green: return  _color.FromArgb 255 0 255 0
			#blue: return  _color.FromArgb 255 0 0 255
			#maxBackground: return  _color.FromArgb 255 68 68 68
		)
		
-- 		return (dotNetObject "System.Windows.Media.SolidColorBrush" theColor)
	),
	
	
	fn SolidColorBrushFn clr = 
	(
		return (dotNetObject "System.Windows.Media.SolidColorBrush" (ColorPresetsFn clr))
		
	),
	
	
	-- Enum to retreive the window style
	fn WindowStyleFn style = 
	(
		_style = dotNetClass "System.Windows.WindowStyle"
		case style of 
		(
			#none: return _style.none
			#toolWindow: return _style.toolWindow
			#singleBorderWindow: return _style.SingleBorderWindow
			#threeDBorderWindow: return _style.ThreeDBorderWindow
		)
	),
	
	
	fn WindowLocationFn location = 
	(
		_location = dotNetClass "System.Windows.WindowStartupLocation"
		case location of
		(
			#centerOwner: return _location.CenterOwner
			#centerScreen: return _location.CenterScreen
			#manual: return _location.Manual
		)
	),
	
	
	-- Window 
	fn WindowFn width:300 height:300 title:"WPF Window" background:#maxBackground style:#toolWindow location:#centerScreen =
	(
		-- Define the window
		wnd = dotNetObject "System.Windows.Window"
		wnd.background = SolidColorBrushFn background
		wnd.width = width
		wnd.height = height
		wnd.title = title
		wnd.windowStyle = WindowStyleFn style
		wnd.WindowStartupLocation =  WindowLocationFn location
		
		-- Set 3ds max to be the owner of the window of show it
		windowHandle = dotNetObject "System.Windows.Interop.WindowInteropHelper" wnd
		windowHandle.Owner = DotNetObject "System.IntPtr" (Windows.GetMaxHWND())
		
		wnd
	),
	
	-- DockPanel
	fn DockPanelFn width:undefined height:undefined background:undefined children:undefined LastChildFill:true= 
	(
		dockPnl = dotNetObject "System.Windows.Controls.DockPanel"
		if width != undefined then dockPnl.width = width
		if height  != undefined then dockPnl.height = height
		if background != undefined then dockPnl.background = SolidColorBrushFn background
		dockPnl.LastChildFill = LastChildFill
		if children != undefined then for child in children do 
		(
			dockPnl.Children.Add(child)
		)
		
		dockPnl
	),
	
	-- StackPanel
	fn StackPanelFn width:undefined height:undefined background:undefined children:undefined = 
	(
		stackPnl = dotNetObject "System.Windows.Controls.StackPanel"
		if width != undefined then stackPnl.width = width
		if height  != undefined then stackPnl.height = height
		if background != undefined then stackPnl.background = SolidColorBrushFn background
		if children != undefined then for child in children do 
		(
			stackPnl.Children.Add(child)
		)
		
		stackPnl
	)
	
	
	
	
	
	
)

global wpf = WpfStruct()