global theWnd
if theWnd != undefined then theWnd.Close()

(
	fn viewClick s e = print ("Clicked " + s.Content + " Button!")
	fn localClick s e = print "Clicked Local Button!"
	fn parentClick s e = print "Clicked Parent Button!"
	fn btn2Click s e = print "Whaaaat, this one is transparent that easily ??? OMG"
	fn chbClick s e = if s.IsChecked then print "IsChecked" else if not s.IsChecked then print "Is not checked"
	
	
	_grid = _wpf.Grid margin:#(5, 4, 5, 2)
	_grid.Add (_wpf.RadioButton text:"View" type:#checkButton checked:viewClick margin:1 isChecked:true) 0 0
	_grid.Add (_wpf.RadioButton text:"Local" type:#checkButton checked:localClick margin:1) 1 0
	_grid.Add (_wpf.RadioButton text:"Parent" type:#checkButton checked:parentClick margin:1) 2 0
		
		
	_dock = _wpf.DockPanel lastChildFill:true margin:#(5, 2)
	_dock.Add (_wpf.Button click:btn2Click text:"Z" margin:1 width:21 height:50) (_wpf.Dock #right)
	_dock.Add (_wpf.Button click:btn2Click text:"Y" margin:1 width:21 height:50) (_wpf.Dock #right)
	_dock.Add (_wpf.Button click:btn2Click text:"X" margin:1 width:21 height:50) (_wpf.Dock #right)
	_dock.Add (_wpf.TextBox text:"Align Pivot to Edge" height:50 margin:#(1,1,0,1)) (_wpf.Dock #left)
	
	pnl1 = _wpf.StackPanel()
	pnl1.Add(_grid)
	pnl1.Add(_dock)
	pnl1.Add(_wpf.CheckButton text:"Transparent CheckButton" click:btn2Click margin:#(5,2) transparent:true isChecked:true)
	pnl1.Add(_wpf.CheckBox click:chbClick margin:5 width:178 isChecked:true)
	
	pnl2 = _wpf.StackPanel()
	pnl2.Add(_wpf.Expander margin:5 content:pnl1 isExpanded:true )
	
	theWnd = _wpf.Window content:pnl2
	theWnd.ShowInFrame()
)