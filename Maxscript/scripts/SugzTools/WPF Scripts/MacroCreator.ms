global Wpf, MacroCreator
struct MacroCreatorStc
(
	_Form, _MainPanel,
	_nameTxt, _categoryTxt, _tooltipTxt,
	_iconGrp, _24iBtn, _24aBtn, _16iBtn, _16aBtn,
	_icon24i, _icon24a, _icon16i, _icon16a,
	_WindowTypeDdl, _WindowBorderStyleDdl,


	fn GetIconName = 
	(
		substituteString (filenameFromPath _icon24i) "_24i.bmp" ""
	),

	fn CreateMacro = 
	(
		macroStr = "MacroScript " + MacroCreator._nameTxt.text
		macroStr += "\n\tcategory:" + MacroCreator._categoryTxt.text
		macroStr += "\n\ttoolTip:" + MacroCreator._tooltipTxt.text
		macroStr += "\n\ticon:#(" + MacroCreator.GetIconName() + ",1)"
		macroStr += "\n\t("
		macroStr += "\n\t"
		macroStr += "\n\t)"

		format "%\n" macroStr
	),


	fn WindowBorderStyleDdlVisibility = 
	(
		if MacroCreator._WindowTypeDdl.SelectedIndex == 2 
			then MacroCreator._WindowBorderStyleDdl.Visibility = Wpf.Enums.Visibility #Collapsed
			else MacroCreator._WindowBorderStyleDdl.Visibility = Wpf.Enums.Visibility #Visible
	),


	fn GetIcon s e =
	(
		path = getOpenFileName caption:"Select an icon:" filename:"$userIcons"
		if path != undefined then 
		(
			img = Wpf.Image uri:path
			if s == MacroCreator._24iBtn AND matchPattern path pattern:"*_24i.bmp" then (s.Content = img; MacroCreator._icon24i = path)
			if s == MacroCreator._24aBtn AND matchPattern path pattern:"*_24a.bmp" then (s.Content = img; MacroCreator._icon24a = path)
			if s == MacroCreator._16iBtn AND matchPattern path pattern:"*_16i.bmp" then (s.Content = img; MacroCreator._icon16i = path)
			if s == MacroCreator._16aBtn AND matchPattern path pattern:"*_16a.bmp" then (s.Content = img; MacroCreator._icon16a = path)
		)
	),

	
	fn SetUI = 
	(
		_MainPanel = Wpf.Stackpanel margin:5 spacingVertical:7

		panel = Wpf.StackPanel margin:5 spacingVertical:7
		panel.Add (_nameTxt = Wpf.Textbox watermark:"Macro name")
		panel.Add (_categoryTxt = Wpf.Textbox watermark:"Macro category")
		panel.Add (_tooltipTxt = Wpf.Textbox watermark:"Macro tooltip")
		
		grid = Wpf.UniformGrid spacingAll:#(5,5,5,0)
		grid.Add (dockpanel = Wpf.DockPanel())
		dockpanel.Add (_24iBtn = Wpf.Button content:"..." width:24 height:24 dock:#right cornerRadius:0 borderThickness:0 click:GetIcon)
		dockpanel.Add (Wpf.TextBlock text:"24i:" vAlign:#center)
		grid.Add (dockpanel = Wpf.DockPanel())
		dockpanel.Add (_24aBtn = Wpf.Button content:"..." width:24 height:24 dock:#right cornerRadius:0 borderThickness:0 click:GetIcon)
		dockpanel.Add (Wpf.TextBlock text:"24a:" vAlign:#center)
		grid.Add (dockpanel = Wpf.DockPanel())
		dockpanel.Add (_16iBtn = Wpf.Button content:"..." width:16 height:16 dock:#right cornerRadius:0 borderThickness:0 click:GetIcon)
		dockpanel.Add (Wpf.TextBlock text:"16i:" vAlign:#center)
		grid.Add (dockpanel = Wpf.DockPanel())
		dockpanel.Add (_16aBtn = Wpf.Button content:"..." width:16 height:16 dock:#right cornerRadius:0 borderThickness:0 click:GetIcon)
		dockpanel.Add (Wpf.TextBlock text:"16a:" vAlign:#center)
		panel.Add (_iconGrp = Wpf.Expander header:"Icons" isGroupBox:true content:grid)

		_MainPanel.Add (windowGrp = Wpf.GroupBox header:"Macro infos" content:panel)

		panel = Wpf.Stackpanel margin:5 spacingVertical:7
		panel.Add (_WindowTypeDdl = Wpf.ComboBox title:"Type:" items:#("Standard", "Modal", "Dockable (left / right)") selectionChanged:WindowBorderStyleDdlVisibility)
		panel.Add (_WindowBorderStyleDdl = Wpf.ComboBox title:"Border Style:" items:#("Fixed3D", "FixedDialog", "FixedSingle", "FixedToolWindow", "None", "Sizable", "SizableToolWindow"))

		_MainPanel.Add (windowGrp = Wpf.GroupBox header:"Window" content:panel)


		_MainPanel.Add (Wpf.Button content:"Create MacroScript" click:CreateMacro)
		

	),
	

	fn CreateForm = 
	(
		if _MainPanel != undefined then
		(
			_Form = Wpf.Window title:"Macro Creator" content:_MainPanel location:#centerParent
			_Form.ShowModeless()
			dotNet.setLifetimeControl _Form #dotnet
		)
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
MacroCreator = MacroCreatorStc()
MacroCreator.Run()
MacroCreator.CreateForm()
