struct WpfStruct
(
	-- Classes
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_color = dotNetClass "System.Windows.Media.Color",
	
	
	
	-- Colors
	maxBackcolor = _color.FromArgb 255 68 68 68,
	
	fn ColorPresetsFn clr = 
	(
		brush = dotNetObject "System.Windows.Media.SolidColorBrush"
		
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
	fn WindowFn width:300 height:300 title:"WPF Window" backcolor:maxBackcolor style:#toolWindow location:#centerScreen =
	(
		-- Define the window
		wnd = dotNetObject "System.Windows.Window"
		wnd.background = dotNetObject "System.Windows.Media.SolidColorBrush" backcolor
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
	fn DockPanelFn width:undefined height:undefined backcolor:undefined children:undefined LastChildFill:true= 
	(
		dockPnl = dotNetObject "System.Windows.Controls.DockPanel"
		if width != undefined then dockPnl.width = width
		if height  != undefined then dockPnl.height = height
		if backcolor != undefined then dockPnl.background = dotNetObject "System.Windows.Media.SolidColorBrush" backcolor
		dockPnl.LastChildFill = LastChildFill
		if children != undefined then for child in children do 
		(
			dockPnl.Children.Add(child)
		)
		
		dockPnl
	),
	
	-- StackPanel
	fn StackPanelFn width:undefined height:undefined backcolor:undefined children:undefined = 
	(
		stackPnl = dotNetObject "System.Windows.Controls.StackPanel"
		if width != undefined then stackPnl.width = width
		if height  != undefined then stackPnl.height = height
		if backcolor != undefined then stackPnl.background = dotNetObject "System.Windows.Media.SolidColorBrush" backcolor
		if children != undefined then for child in children do 
		(
			stackPnl.Children.Add(child)
		)
		
		stackPnl
	)
	
	
	
	
	
	
)

global wpf = WpfStruct()