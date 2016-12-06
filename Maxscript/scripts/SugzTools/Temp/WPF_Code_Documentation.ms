global CodeDocView

(
	
	/* Initialise the look of the window ***************************************************************************************************************************************************************/
	fn SetWindow wnd = 
	(
		wnd = dotNetObject "System.Windows.Window"
		wnd.title = "SugzTools Code Documentation"
		wnd.WindowStartupLocation = wnd.WindowStartupLocation.CenterScreen
		wnd.width = 640 
		wnd.height = 350
		
		ptr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
		hwnd = (dotNetObject "System.Windows.Forms.NativeWindow").FromHandle ptr
		wnd.Owner = hwnd
			
			
		wnd.show()
	)
	
	
	fn Run =
	(
		SetWindow CodeDocView
	)
	
	
	Run()
	
)