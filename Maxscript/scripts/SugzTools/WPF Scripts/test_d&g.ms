global Wpf, test
struct testStc
(
	_testForm, rols,

	
	fn SetUI = 
	(
		_testPanel = Wpf.Stackpanel margin:5
		_testPanel.Add(Wpf.Button content:"Button 01")
		
		rols = Wpf.ExpandersControl margin:3
		rols.Items.Add (Wpf.Expander header:"Expander 01" content:_testPanel )
		
	),
	

	fn CreateForm = 
	(
		if rols != undefined then
		(
			_testForm = Wpf.Window title:"Sugz" content:rols location:#centerParent
			_testForm.ShowModeless()
			dotNet.setLifetimeControl _testForm #dotnet
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
test = testStc()
test.Run()
test.CreateForm()
