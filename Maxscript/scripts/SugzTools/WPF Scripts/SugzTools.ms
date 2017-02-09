clearListener()
global Sgz, Wpf
struct sugzToolsStc
(
	_nameTxt, _prefixTxt, _suffixTxt, 
	_removeGrp, _firstSpn, _lastSpn,
	_indexGrp, _startSpn, _paddingSpn,
	_rols, _panel, 

	
	fn GetUI = 
	(
		_panel = Wpf.StackPanel margin:5 spacingVertical:7

		getIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center 
		closeIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center 
		_panel.Add (_nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:getIcon uiElement2:closeIcon)
		
		getIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center 
		closeIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center 
		_panel.Add (_prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:getIcon uiElement2:closeIcon)

		getIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center 
		closeIcon = Wpf.Icon icon:"MdiWindowClose"padding:6 cursor:#Arrow vAlign:#center 
		_panel.Add (_suffixTxt = Wpf.Textbox watermark:"Enter a suffix..." uiElement0:getIcon uiElement2:closeIcon)

		panel = Wpf.StackPanel margin:#(7,5,5,5) spacingVertical:7
		panel.Children.Add(_firstSpn = Wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Children.Add(_lastSpn = Wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		_panel.Add (_removeGrp = Wpf.Expander header:"Remove Chars" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
		

		panel = Wpf.StackPanel margin:#(7,5,5,5) spacingVertical:7
		panel.Children.Add (_startSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,100000,1) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Children.Add (_paddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,10,2) fieldWidth:60 height:18 hAlign:#stretch)
		_panel.Add (_indexGrp = Wpf.Expander header:"Index" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))

		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Children.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Children.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center)
		_panel.Add (_renameBtn = Wpf.Button content:btnPanel height:25 margin:#(0,2,0,0))
		
		
		_rols = Wpf.ExpandersControl margin:3
		_rols.Items.Add (Wpf.Expander header:"Renamer" content:_panel)
		
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