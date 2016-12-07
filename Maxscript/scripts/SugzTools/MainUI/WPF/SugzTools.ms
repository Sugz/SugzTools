/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


global sgz, rename, dim, _wpf
struct SugzToolsStc
(
	SugzToolsView,
	
	
	fn GetModeling = 
	(
		_panel = _wpf.StackPanel margin:#(5,5,5,0) 

		_panel.Add(_grid = _wpf.Grid())
		_grid.Add(_wpf.RadioButton text:"View" type:#checkButton IsChecked:true) 0 0
		_grid.Add(_wpf.RadioButton text:"Local" type:#checkButton margin:#(2,0)) 1 0
		_grid.Add(_wpf.RadioButton text:"Parent" type:#checkButton) 2 0
			
		_panel.Add(_wpf.Button text:"Edit Poly")
			
		_panel.Add(_grid = _wpf.Grid())
		_grid.Add(_wpf.Button text:"Edit Pivot" margin:#(0,0,1,0) IsChecked:true) 0 0
		_grid.Add(_wpf.Button text:"Center Pivot" margin:#(1,0,0,0)) 1 0
			
		_panel.Add(_dock = _wpf.DockPanel lastChildFill:true)
		_dock.Add(_wpf.Button click:btn2Click text:"Z" width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.Button click:btn2Click text:"Y" margin:#(2,0) width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.Button click:btn2Click text:"X" width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.TextBlock text:"Align Pivot to Edge" margin:#(2,0)) (_wpf.Dock #left)
			
		_panel.Add(_dock = _wpf.DockPanel lastChildFill:true)
		_dock.Add(_wpf.Button click:btn2Click text:"Z" width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.Button click:btn2Click text:"Y" margin:#(2,0) width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.Button click:btn2Click text:"X" width:21) (_wpf.Dock #right)
		_dock.Add(_wpf.TextBlock text:"Flatten Spline" margin:#(2,0)) (_wpf.Dock #left)
			
		_panel.Add(_wpf.CheckBox text:"Backface Cull" margin:#(2,0,0,0) align:#stretch)
			
		_expander =_wpf.Expander header:"Modeling" content:_panel 
	),


	fn GetRenamer =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		if doesFileExist (file = "$userscripts\SugzTools\Scripts\Renamer.ms") then 
		(
			fileIn file 
			rename.GetUi isExpanded:false
		)
	),
	
	
	fn GetDimension =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		if doesFileExist (file = "$userscripts\SugzTools\Scripts\Dimensions_To_Scale.ms") then 
		(
			fileIn file 
			dim.GetUi isExpanded:false
		)
	),
	
	
	fn GetView = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then 
		(
			fileIn file 
			
			_panel = _wpf.StackPanel margin:#(5,5,5,0)
			_panel.Add(GetModeling())
			_panel.Add(GetRenamer())
			_panel.Add(GetDimension())	
				
			if SugzToolsView != undefined then SugzToolsView.Close()
			SugzToolsView = _wpf.Window content:_panel width:217 height: 500
			SugzToolsView.ShowInFrame()
		)
		
	),
	
	
	fn Run = 
	(
		GetView()
		dim.Run()
	)
	
)


sgz = SugzToolsStc()
sgz.Run()
