global aSave, _wpf
struct AutoSaveStc
(

	fn GetUI isExpanded:true = 
	(
		panel = _wpf.StackPanel margin:5 innerMargin:#(0,0,0,2)
		panel.Add(dock = _wpf.DockPanel innerMargin:0)
		dock.Add(_wpf.CheckButton text:"" width:10)
		dock.Add(_wpf.Button text:"AS" width:21)
		dock.Add(_wpf.Button text:"O" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"As" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"+" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"5m 0s")
		panel.Add(_wpf.ProgressBar height:8 isCylon:true cornerRadius:4)
		border = _wpf.Border background:#MaxRollout cornerRadius:2 child:panel
	),

	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		if _form != undefined then _form.Close()
		_form = _wpf.Window content:panel title:"AutoSave" width:217 height:500 location:#centerParent borderstyele:#sizableToolWindow
		_form.Show()
			
	)
)

aSave = AutoSaveStc()
aSave.CreateForm()