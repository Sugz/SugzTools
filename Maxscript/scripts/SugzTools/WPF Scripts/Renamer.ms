global Renamer, _wpf
struct renamerStc
(
	-- WPF Controls ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_nameTxt, _prefixTxt, _suffixTxt, 
	_removeGrp, _firstSpn, _lastSpn,
	_indexGrp, _startSpn, _paddingSpn,
	_renameBtn, _expander, _form,


	fn Rename = 
	(
		index = 0
		for obj in getCurrentSelection() do
		(
			nodeName = obj.name

			-- Standard naming
			if Renamer._nameTxt.Text.Count != 0 then nodeName = Renamer._nameTxt.Text
			if Renamer._prefixTxt.Text.Count != 0 then nodeName = Renamer._prefixTxt.Text + nodeName
			if Renamer._suffixTxt.Text.Count != 0 then nodeName += Renamer._suffixTxt.Text

			-- Remove chars 
			if Renamer._removeGrp.IsExpanded then 
			(
				first = Renamer._firstSpn.Value
				last = Renamer._lastSpn.Value

				-- just erase the name if one of spinner's value is over name count
				if ((first >= nodeName.count) OR (last >= nodeName.count) OR (first + last >= nodeName.count)) then
					nodeName = ""
				else 
				(
					if first != 0 then nodeName = substring nodeName (first + 1) -1
					if last != 0 then nodeName = substring nodeName 1 (nodeName.count - last)
				)
			)

			-- Index incrementation
			if Renamer._indexGrp.IsExpanded then 
			(
				increment = (Renamer._startSpn.Value + index) as string
				while increment.count < Renamer._paddingSpn.value do 
					increment = "0" + increment

				nodeName += increment
			)

			obj.name = nodeName
			index += 1
		)
	),
	
	
	
	fn GetUI isExpanded:true = 
	(
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(dock = _wpf.DockPanel innerMargin:0)


		img = _wpf.Image uri:@"D:\Travail\GitHub\Icons\SugzTools\PNG\Close_16i.png" width:16 height:16
		dock.Add(_wpf.Button content:img width:20 click:(fn x s e = print s.ActualWidth)) (_wpf.Dock #right)

-- 		dock.Add(_wpf.Button content:"X" width:20 click:(fn x = Renamer._nameTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button content:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._nameTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_nameTxt = _wpf.Textbox watermark:"Enter a name...")
			
		panel.Add(dock = _wpf.DockPanel innerMargin:0)
		dock.Add(_wpf.Button content:"X" width:20 click:(fn x = Renamer._prefixTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button content:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._prefixTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_prefixTxt = _wpf.Textbox watermark:"Enter a prefix...")
			
		panel.Add(dock = _wpf.DockPanel innerMargin:0)
		dock.Add(_wpf.Button content:"X" width:20 click:(fn x = Renamer._suffixTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button content:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._suffixTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_suffixTxt = _wpf.Textbox watermark:"Enter a suffix...")
			
		grid = _wpf.UniformGrid columns:1 innerMargin:#(7,5,5,5)
		grid.Add(_firstSpn = _wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 align:#stretch)
		grid.Add(_lastSpn = _wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 align:#stretch)
		panel.Add(_removeGrp = _wpf.Expander header:"Remove Chars" content: grid cornerRadius:1 isGroupBox:true isExpanded:false)
			
		grid = _wpf.UniformGrid columns:1 innerMargin:#(7,5,5,5)
		grid.Add(_startSpn = _wpf.Spinner content:"Start:" type:#integer range:#(0,100000,1) fieldWidth:60 height:18 align:#stretch)
		grid.Add(_paddingSpn = _wpf.Spinner content:"Padding:" type:#integer range:#(0,10,2) fieldWidth:60 height:18 align:#stretch)
		panel.Add(_indexGrp = _wpf.Expander header:"Index" content: grid cornerRadius:1 isGroupBox:true isExpanded:false)
			
		panel.Add(_renameBtn = _wpf.Button content: "Rename :)" height:25 margin:#(0,2,0,0) click:Rename)

		_expander =_wpf.Expander header:"Rename" content:panel isExpanded:isExpanded
		_expander.Focus()
		dotNet.addEventHandler _expander "SizeChanged" (fn x = Renamer._form.Height = Renamer._expander.ActualHeight + 48)

		_expander
	),

	
	
	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		_form = _wpf.Window content:panel title:"Dimensions" width:217 location:#centerParent
		_form.ShowModeless()
	)
	
)

if Renamer != undefined and Renamer._form != undefined then Renamer._form.Close()
Renamer = renamerStc()
Renamer.CreateForm()



