global Wpf, DefaultParams
struct DefaultParamsStc
(
	Form, Expanders, DefaultParamsExpander, PickObjBtn, PrimitivesDdl, MainPanel,
	primitives = #(),


	fn SetPropertiesUI s e = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		propPanel = Wpf.StackPanel margin:5 spacingVertical:7

		_class = execute s.SelectedItem
		for prop in getPropNames _class do 
		(
			type = classOf (getProperty _class prop)
			prop = trimLeft (prop as string) "#"
			format "Property: %, Type: %\n" prop type

			case type of 
			(
				Float: propPanel.Add (Wpf.Spinner content:prop type:#float)
				Integer: propPanel.Add (Wpf.Spinner content:prop type:#integer)
				BooleanClass: propPanel.Add (Wpf.Checkbox content:prop hAlign:#Stretch)
			)
		)
		

		DefaultParams.MainPanel.Add (propsGrp = Wpf.GroupBox header:"Properties" content:propPanel margin:#(0,7,0,0))

	),



	fn AddPrimitive = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		pickedObj = pickObject()
		append (DefaultParams.primitives) (classOf pickedObj)
		DefaultParams.PrimitivesDdl.Add ((classOf pickedObj) as string)
		DefaultParams.PrimitivesDdl.SelectedIndex += 1
	),

	
	fn SetUI = 
	(
		MainPanel = Wpf.StackPanel margin:5 spacingVertical:7
		MainPanel.Add (dock = Wpf.DockPanel())
		dock.Add (PickObjBtn = Wpf.Button content:"+" width:21 click:AddPrimitive dock:#right)
		dock.Add (PrimitivesDdl = Wpf.ComboBox selectionChanged:SetPropertiesUI)

		DefaultParamsExpander = Wpf.Expander header:"Default Params" content:MainPanel
	),
	

	fn CreateForm = 
	(
		if DefaultParamsExpander != undefined then
		(
			Expanders = Wpf.ExpandersControl margin:2
			Expanders.Add DefaultParamsExpander
			Form = Wpf.Window title:"Sugz" content:Expanders location:#centerParent
			Form.ShowModeless()
			dotNet.setLifetimeControl Form #dotnet
		)
	),
	

	fn Run = 
	(
		if doesFileExist (file = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then 
		(
			fileIn file
			SetUI()
		)
	)
	
)
DefaultParams = DefaultParamsStc()
DefaultParams.Run()
DefaultParams.CreateForm()
