struct WpfStruct
(
	-- Classes
	dock = dotNetClass "System.Windows.Controls.Dock",
	dColor = dotNetClass "System.Windows.Media.Color",
	
	-- Object
	solidColorBrush = dotNetClass "System.Windows.Media.SolidColorBrush",
	
	-- Colors
	maxBackcolor = dColor.FromArgb 255 68 68 68,
	
	-- Window 
	fn WindowFn width:300 height:300 title:"WPF Window" backcolor:maxBackcolor = --style:toolWindow location:CenterScreen
	(
		wnd = dotNetObject "System.Windows.Window"
		wnd.background =  (solidColorBrush) backcolor
		wnd.width = width
		wnd.height = height
		wnd.title = title
-- 		wnd.windowStyle = installWnd.windowStyle.style
-- 		wnd.WindowStartupLocation = wnd.WindowStartupLocation.location
		
		wnd
	)
	
	
)

global wpf = WpfStruct()