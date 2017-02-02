global Sgz, _wpf
struct sugzToolsStc
(
	_rols,
	
	fn GetUI = 
	(
		_rols = dotNetObject "SugzTools.Controls.SgzExpandersControl"
		_rols.Margin = _wpf.Thickness 3
		
		panel01 = _wpf.StackPanel margin:5 height:75
		panel02 = _wpf.StackPanel margin:5 height:75
		panel03 = _wpf.StackPanel margin:5 height:75
		panel04 = _wpf.StackPanel margin:5 height:75
		panel05 = _wpf.StackPanel margin:5 height:75
		
		_rols.Items.Add (_wpf.Expander header:"Expander 01" content:panel01)
		_rols.Items.Add (_wpf.Expander header:"Expander 02" content:panel02)
		_rols.Items.Add (_wpf.Expander header:"Expander 03" content:panel03)
		_rols.Items.Add (_wpf.Expander header:"Expander 04" content:panel04)
		_rols.Items.Add (_wpf.Expander header:"Expander 05" content:panel05)
		
		_rols
	),
	
	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		_form = _wpf.Window title:"SugzTools" content:(GetUI()) width:217 location:#centerParent
		_form.ShowModeless()
	),
	
	fn Run = 
	(
		CreateForm()
	)
	
)
Sgz = sugzToolsStc()
Sgz.Run()