global aSave, _wpf
struct AutoSaveStc
(

	fn GetUI isExpanded:true = 
	(
		dock = _wpf.DockPanel innerMargin:#(0,2)
		dock.Add(_wpf.CheckButton text:"" width:10)
		dock.Add(_wpf.Button text:"AS" width:21)
		dock.Add(_wpf.Button text:"O" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"As" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"+" width:21) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"5m 0s")

		dockHeader = _wpf.DockPanel()
		dockHeader.Add(_wpf.TextBlock text:"AutoSave")
		dockHeader.Add(_wpf.ProgressBar height:8 isCylon:true cornerRadius:4 margin:#(5,1,0,0))
		_expander =_wpf.Expander header:dockHeader content:dock isExpanded:isExpanded
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