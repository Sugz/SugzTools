-- Assemblies
dotnet.loadAssembly ("D:\Travail\Maxscripts\SugzTools\Assemblies\SugzControls.dll")

struct WpfStruct
(
	-- Classes
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_color = dotNetClass "System.Windows.Media.Color",
	
	-- Colors	
	fn ColorPresetsFn clr = 
	(
		case clr of 
		(
			#red: return _color.FromArgb 255 255 0 0
			#green: return  _color.FromArgb 255 0 255 0
			#blue: return  _color.FromArgb 255 0 0 255
			#black: return _color.FromArgb 255 0 0 0
			#maxBackground: return  _color.FromArgb 255 68 68 68
		)
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
	
	fn ThicknessFn thickness = 
	(
		return (dotnetObject "System.Windows.Thickness" thickness[1] thickness[2] thickness[3] thickness[4])
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
	),
	
	
	fn ButtonFn text:"SugzButton" width:undefined height:undefined cornerRadius:0 borderbrush:undefined borderThickness:undefined= 
	(
		btn = dotNetObject "SugzControls.SugzButton"
		if width != undefined then btn.width = width
		if height  != undefined then btn.height = height
		btn.cornerRadius = cornerRadius	
		if borderbrush != undefined then btn.borderBrush = SolidColorBrushFn borderbrush
		if borderThickness != undefined then btn.borderThickness = ThicknessFn borderThickness
		btn.Content = text
		btn
	)
	
	
	
)

global wpf = WpfStruct()