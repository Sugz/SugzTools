
global FunctionExplorerView				-- The form

(

	/* Initialise the look of the form ***************************************************************************************************************************************************************/
	fn InitForm form = 
	(
		form = dotNetObject "maxCustomControls.maxForm"      
		form.StartPosition  = form.StartPosition.CenterScreen
		form.size = dotNetObject "System.Drawing.Size" 420 350
-- 		form.FormBorderStyle = FunctionExplorerView.FormBorderStyle.SizableToolWindow
		form.text = "Function Explorer"

		ptr = DotNetObject "System.IntPtr" (windows.getMAXHWND())
		hwnd = (dotNetObject "System.Windows.Forms.NativeWindow").FromHandle ptr
		form.Show(hwnd)
	)
		
		
	fn Run =
	(
		InitForm FunctionExplorerView
	)
	
	Run()
)

 