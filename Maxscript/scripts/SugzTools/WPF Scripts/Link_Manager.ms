global _link, Wpf
struct LinkManagerStc
(
	-- Controls 
	_parentDdl, _addBtn, _removeBtn, _linkBtn,


	-- Locals 
	parentObjs = #(),


	fn SetParentList = 
	(
		if parentObjs.count != 0 then 
		(
			_link._parentDdl.SetItems (for obj in parentObjs collect obj.name)
			_link._removeBtn.IsEnabled = _link._linkBtn.IsEnabled = true
		)
		else 
		(
			_link._parentDdl.SetItems #("-- Add a Parent")
			_link._removeBtn.IsEnabled = _link._linkBtn.IsEnabled = false
		)
	),


	fn AddParent = 
	(
		if not _sgz._sel.IsSelectionEmpty() then
		(
			for obj in getCurrentSelection() do appendIfUnique _link.parentObjs obj
			_link.SetParentList()
			_link._parentDdl.SelectedIndex += 1
		)
	),


	fn RemoveParent = 
	(
		deleteItem _link.parentObjs (_link._parentDdl.selectedIndex + 1)
		_link.SetParentList()
		_link._parentDdl.selectedIndex = 0
	),


	fn Link = 
	(
		if not _sgz._sel.IsSelectionEmpty() and _link.parentObjs.count != 0 then 
		(
			parentObj = _link.parentObjs[_link._parentDdl.selectedIndex + 1]
			selection.parent = parentObj
			if parentObj.isHiddenInVpt then selection.IsHidden = true
		)
	),


	fn GetUI isExpanded:true = 
	(
		dock = Wpf.DockPanel margin:#(5,5,5,0)
		dock.Add(_linkBtn = Wpf.Button content:"Link" width:30 margin:#(5,0,0,0) enabled:false click:Link dock:#right)
		dock.Add(_removeBtn = Wpf.Button content:"-" width:21 enabled:false click:RemoveParent dock:#right)
		dock.Add(_addBtn = Wpf.Button content:"+" width:21 click:AddParent dock:#right)
		dock.Add(_parentDdl = Wpf.ComboBox items:#("-- Add a Parent"))
		border = Wpf.Border background:#MaxRollout cornerRadius:2 child:dock
	),

	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = Wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		if _form != undefined then _form.Close()
		_form = Wpf.Window content:panel title:"Link Manager" width:217 height:500 location:#centerParent borderstyele:#sizableToolWindow
		_form.ShowInFrame()
	),
	
	
	fn Run = 
	(
		if doesFileExist (file = "$userScripts\\SugzTools\\Libs\\WPF\\Wpf_Lib.ms") then 
		(
			fileIn file
			SetUI()
		)
	)

)

_link = LinkManagerStc()
_link.CreateForm()
LinkInfo = LinkInfoStc()
LinkInfo.Run()
LinkInfo.CreateForm()