struct WpfStruct
(
	-- Classes
	dock = dotNetClass "System.Windows.Controls.Dock",
	dColor = dotNetClass "System.Windows.Media.Color",
	dStyle = dotNetClass "System.Windows.WindowStyle",
	dLocation = dotNetClass "System.Windows.WindowStartupLocation",
	
	-- Colors
	maxBackcolor = dColor.FromArgb 255 68 68 68,
	
	-- Enum to retreive the window style
	fn SetWindowStyleFn style = 
	(
		case style of 
		(
			#none: return dStyle.none
			#toolWindow: return dStyle.toolWindow
			#singleBorderWindow: return dStyle.SingleBorderWindow
			#threeDBorderWindow: return dStyle.ThreeDBorderWindow
		)
	),
	
	
	fn SetWindowLocation location = 
	(
		case location of
		(
			#centerOwner: return dLocation.CenterOwner
			#centerScreen: return dLocation.CenterScreen
			#manual: return dLocation.Manual
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
		wnd.windowStyle = SetWindowStyleFn style
		wnd.WindowStartupLocation =  SetWindowLocation location
		
		-- Set 3ds max to be the owner of the window of show it
		windowHandle = dotNetObject "System.Windows.Interop.WindowInteropHelper" wnd
		windowHandle.Owner = DotNetObject "System.IntPtr" (Windows.GetMaxHWND())
		
		wnd
	),
	
	fn DockPanelFn width: height: backcolor: children: = 
	(
		dockPnl = dotNetObject "System.Windows.Controls.DockPanel"
		for child in children do 
		(
			dockPnl.Children.Add(child)
		)
		
	)
	
	
	
	
	
	
)

global wpf = WpfStruct()