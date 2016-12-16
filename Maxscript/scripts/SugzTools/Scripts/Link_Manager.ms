global _link, _wpf
struct LinkManagerStc
(

	--Controls 
	_parentDdl, _addBtn, _removeBtn, _linkBtn,

	fn GetUI isExpanded:true = 
	(
		dock = _wpf.DockPanel()
		dock.Add(_addBtn = _wpf.Button text:"+" width:21)
		dock.Add(_removeBtn = _wpf.Button text:"-" width:21)
		dock.Add(_linkBtn = _wpf.Button text:"Link" width:30) (_wpf.Dock #right)
		dock.Add(_parentDdl = _wpf.ComboBox items:#("item1","item2", "item3") selectedItem:2)
		border = _wpf.Border background:#MaxRollout cornerRadius:2 child:dock
	),

	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		if _form != undefined then _form.Close()
		_form = _wpf.Window content:panel title:"Link Manager" width:217 height:500 location:#centerParent borderstyele:#sizableToolWindow
		_form.ShowInFrame()
			
	)
)

_link = LinkManagerStc()
_link.CreateForm()