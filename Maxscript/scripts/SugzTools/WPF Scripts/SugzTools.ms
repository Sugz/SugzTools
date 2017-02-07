global Sgz, Wpf
struct sugzToolsStc
(
	_panel, _nameTxt, _prefixTxt, _suffixTxt, 
	
	_rols,
	
	fn GetUI = 
	(
		_panel = Wpf.StackPanel margin:5 spacingVertical:5

		getIcon = Wpf.Icon icon:"MdiStepForward" margin:5 cursor:#Arrow click:(fn x = if _sgz._sel.IsSelectionOne() then this._nameTxt.Text = $.name)
		closeIcon = Wpf.Icon icon:"MdiWindowClose" margin:5 cursor:#Arrow click:(fn x = this._nameTxt.Text = "")
		_panel.Children.Add(_nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:getIcon uiElement2:closeIcon)

		getIcon = Wpf.Icon icon:"MdiStepForward" margin:5 cursor:#Arrow
		closeIcon = Wpf.Icon icon:"MdiWindowClose" margin:5 cursor:#Arrow
		_panel.Children.Add(_prefixTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:getIcon uiElement2:closeIcon)

		getIcon = Wpf.Icon icon:"MdiStepForward" margin:5 cursor:#Arrow 
		closeIcon = Wpf.Icon icon:"MdiWindowClose" margin:5 cursor:#Arrow
		_panel.Children.Add(_suffixTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:getIcon uiElement2:closeIcon)



		
		_rols = Wpf.ExpandersControl margin:3
		_rols.Items.Add (Wpf.Expander header:"Expander 01" content:_panel)
		
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