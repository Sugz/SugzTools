global rename, _wpf
struct renameStc
(
	-- WPF Controls ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_nameTxt, _prefixTxt, _suffixTxt, _firstSpn, _lastSpn,
	_indexChk, _startSpn, _paddingSpn,
	_renameBtn, _expander, _form,
	
	
	fn Rename s e = 
	(
		
	),
	
	
	fn GetUI = 
	(
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(dock = _wpf.DockPanel())
		dock.Add(_wpf.Button text:"X" width:20 click:(fn x = rename._nameTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then rename._nameTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_nameTxt = _wpf.Textbox watermark:"Enter a name...")
			
		panel.Add(dock = _wpf.DockPanel())
		dock.Add(_wpf.Button text:"X" width:20 click:(fn x = rename._prefixTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then rename._prefixTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_prefixTxt = _wpf.Textbox watermark:"Enter a prefix...")
			
		panel.Add(dock = _wpf.DockPanel())
		dock.Add(_wpf.Button text:"X" width:20 click:(fn x = rename._suffixTxt.Text = "")) (_wpf.Dock #right)
		dock.Add(_wpf.Button text:"<" width:20 click:(fn x = if _sgz._sel.IsSelectionOne() then rename._suffixTxt.Text = $.name)) (_wpf.Dock #right)
		dock.Add(_suffixTxt = _wpf.Textbox watermark:"Enter a suffix...")
			
		panel.Add(_wpf.Textblock text:"Remove chars :" margin:#(0,5,0,-2))
		panel.Add(grid = _wpf.Grid())
		grid.Add(_firstSpn = _wpf.Spinner text:"First:" type:#integer range:[0,100,0] fieldWidth:45 height:18 align:#stretch margin:#(0,0,5,0)) 0 0
		grid.Add(_lastSpn = _wpf.Spinner text:"Last:" type:#integer range:[0,100,0] fieldWidth:45 height:18 align:#stretch margin:#(5,0,0,0)) 1 0
			
		panel.Add(_indexChk = _wpf.Checkbox text:"Use index :" margin:#(0,0,0,-2) align:#stretch)
		panel.Add(grid = _wpf.Grid())
		grid.Add(_startSpn = _wpf.Spinner text:"Start:" type:#integer range:[1,1000,1] fieldWidth:45 height:18 align:#stretch margin:#(0,0,5,0)) 0 0
		grid.Add(_paddingSpn = _wpf.Spinner text:"Padding:" type:#integer range:[1,10,2] fieldWidth:45 height:18 align:#stretch margin:#(5,0,0,0)) 1 0
			
		panel.Add(_renameBtn = _wpf.Button text: "Rename :)" margin:#(0,5,0,0))

		_expander =_wpf.Expander header:"Rename" content:panel
			
		_expander
	),

	
	
	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		if _form != undefined then _form.Close()
		_form = _wpf.Window content:panel title:"Dimensions" width:217 height:500 location:#centerParent closed:RemoveCB()
		_form.ShowInFrame()
			
	)
	
)
rename = renameStc()
rename.CreateForm()




