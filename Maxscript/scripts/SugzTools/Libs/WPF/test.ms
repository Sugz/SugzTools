(
	if doesFileExist (file = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then
	(
		fileIn file 
		_button = (Wpf.Button content:"My Awesome Button" width:150)
		_form = Wpf.Window title:"SugzTools" content:_button width:217 location:#centerParent
		_form.Show()
	)
)