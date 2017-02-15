global Wpf, test
struct testStc
(
	_testForm, _testExpander, _testExpanders,

	
	fn SetUI = 
	(
		testPanel = Wpf.Stackpanel margin:5 spacingVertical:7
		testPanel.Add(Wpf.Button content:"Button 01")
		_testExpander = Wpf.Expander header:"Expander 01" content:testPanel
	),
	

	fn CreateForm = 
	(
		if _testExpander != undefined then
		(
			_testExpanders = Wpf.ExpandersControl margin:2
			_testExpanders.Add #(_testExpander, _testExpander02)
			_testForm = Wpf.Window title:"Sugz" content:_testExpanders location:#centerParent
			_testForm.ShowModeless()
			dotNet.setLifetimeControl _testForm #dotnet
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
test = testStc()
test.Run()
test.CreateForm()
