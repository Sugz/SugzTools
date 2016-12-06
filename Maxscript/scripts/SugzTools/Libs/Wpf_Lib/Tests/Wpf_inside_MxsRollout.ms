dotNet.loadAssembly @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\v3.0\WindowsFormsIntegration.dll"

try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	
	
	fn viewClick s e = print ("Clicked " + s.Content + " Button!")
	fn localClick s e = print "Clicked Local Button!"
	fn parentClick s e = print "Clicked Parent Button!"
	fn btn2Click s e = print "Whaaaat, this one is transparent that easily ??? OMG"
	fn chbClick s e = 
	(
		if s.IsChecked then print "IsChecked" 
			else if not s.IsChecked then print "Is not checked"
	)
		
	fn setupUI = 
	(
		_grid = _wpf.Grid margin:#(5, 4, 5, 2)
		_grid.Add (_wpf.RadioButton text:"View" type:#checkButton checkedEvent:viewClick margin:1 checked:true) 0 0
		_grid.Add (_wpf.RadioButton text:"Local" type:#checkButton checkedEvent:localClick margin:1) 1 0
		_grid.Add (_wpf.RadioButton text:"Parent" type:#checkButton checkedEvent:parentClick margin:1) 2 0
			
			
		_dock = _wpf.DockPanel lastChildFill:true margin:#(5, 2)
		_dock.Add (_wpf.Button clickEvent:btn2Click text:"Z" margin:1 width:21 height:50) (_wpf.Dock #right)
		_dock.Add (_wpf.Button clickEvent:btn2Click text:"Y" margin:1 width:21 height:50) (_wpf.Dock #right)
		_dock.Add (_wpf.Button clickEvent:btn2Click text:"X" margin:1 width:21 height:50) (_wpf.Dock #right)
		_dock.Add (_wpf.TextBox text:"Align Pivot to Edge" height:50 margin:#(1,1,0,1)) (_wpf.Dock #left)
		
		pnl1 = _wpf.StackPanel()
		pnl1.Add(_grid)
		pnl1.Add(_dock)
		pnl1.Add(_wpf.CheckButton text:"Transparent CheckButton" clickEvent:btn2Click margin:#(5,2) transparent:true checked:true)
		pnl1.Add(_wpf.CheckBox clickEvent:chbClick margin:5 width:178 checked:true)
		
		pnl2 = _wpf.StackPanel()
		pnl2.Add(_wpf.Expander margin:5 content:pnl1 isExpanded:true )
			
		pnl2
	)
	
	dotNetControl eh "Integration.ElementHost" width:202 height:300 align:#left offset:[-13,-5]

	on Roll open do 
	(
		
		eh.backColor=(dotNetClass "system.drawing.color").FromArgb 255 68 68 68
		eh.child = setupUI()
	)
	
)
createDialog Roll 210 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
cui.RegisterDialogBar Roll minSize:[210,75]		-- register the dialog