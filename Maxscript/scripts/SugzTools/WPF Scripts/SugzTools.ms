global Sgz, Wpf
struct sugzToolsStc
(
	_rols,
	
	fn GetUI = 
	(
-- 		_rols = dotNetObject "SugzTools.Controls.SgzExpandersControl"
-- 		_rols.Margin = Wpf.Thickness 3

		panel = Wpf.StackPanel margin:5 innerMargin:#(0,0,0,5)
		panel.Children.Add (Wpf.SgzButton content:"My Awesome Button 01")
		panel.Children.Add (Wpf.SgzButton content:"My Awesome Button 02")
		panel.Children.Add (Wpf.SgzButton content:"My Awesome Button 03")

-- 		panel02 = _wpf.StackPanel margin:5 height:75
-- 		panel03 = _wpf.StackPanel margin:5 height:75
-- 		panel04 = _wpf.StackPanel margin:5 height:75
-- 		panel05 = _wpf.StackPanel margin:5 height:75
		
		_rols = Wpf.SgzExpandersControl margin:3
		_rols.Items.Add (Wpf.SgzExpander header:"Expander 01" content:panel)
-- 		_rols.Items.Add (_wpf.Expander header:"Expander 02" content:panel02)
-- 		_rols.Items.Add (_wpf.Expander header:"Expander 03" content:panel03)
-- 		_rols.Items.Add (_wpf.Expander header:"Expander 04" content:panel04)
-- 		_rols.Items.Add (_wpf.Expander header:"Expander 05" content:panel05)
		
		_rols
	),
	
	fn CreateForm = 
	(
		if doesFileExist (file = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then fileIn file
		_form = Wpf.Window title:"SugzTools" content:(GetUI()) width:217 location:#centerParent
		_form.ShowModeless()
	),
	
	fn Run = 
	(
		CreateForm()
	)
	
)
Sgz = sugzToolsStc()
Sgz.Run()