clearListener()
global Sgz, Wpf
struct sugzToolsStc
(
	_rols,

	
	fn GetUI = 
	(
		_rols = Wpf.ExpandersControl margin:3

		if doesFileExist (file = "$userScripts\SugzTools\WPF Scripts\Renamer.ms") then 
		(
			fileIn file
			Renamer.Run()
			_rols.Items.Add (Wpf.Expander header:"Renamer" content:Renamer._renamePanel)
		)
	),
	

	fn CreateForm = 
	(
		_form = Wpf.Window title:"SugzTools" content:_rols width:217 location:#centerParent
		_form.ShowInFrame()
	),
	

	fn Run = 
	(
		if doesFileExist (file = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then 
		(
			fileIn file
			GetUI()
			CreateForm()
		)
	)
	
)
Sgz = sugzToolsStc()
Sgz.Run()