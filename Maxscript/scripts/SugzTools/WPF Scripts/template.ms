global Wpf, test
struct testStc
(
	_testForm, _testPanel,

	
	fn SetUI = 
	(
		_testPanel = Wpf.Stackpanel()
	),
	

	fn CreateForm = 
	(
		if _testPanel != undefined then
		(
			_testForm = Wpf.Window title:"Sugz" content:_testPanel location:#centerParent
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
