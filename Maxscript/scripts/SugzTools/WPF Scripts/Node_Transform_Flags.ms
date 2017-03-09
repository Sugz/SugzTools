global Wpf, LinkInfo
struct LinkInfoStc
(
	_LinkInfoForm, Expander,
	_moveLocksChk, _rotateLocksChk, _scaleLocksChk,
	_moveInheritChk, _rotateInheritChk, _scaleInheritChk,

	
	fn SetUI = 
	(
		linkInfoPanel = Wpf.Stackpanel margin:5 spacingVertical:5

		grid = Wpf.UniformGrid columns:3 spacingAll:#(5,2,5,3)
		grid.Add (_moveLocksChk = Wpf.Checkbox content:"Move" hContentAlign:#Right spacing:4)
		grid.Add (_rotateLocksChk = Wpf.Checkbox content:"Rotate" hContentAlign:#Right spacing:4)
		grid.Add (_scaleLocksChk = Wpf.Checkbox content:"Scale" hContentAlign:#Right spacing:4)
		LinkInfoPanel.Add (lockGrp = Wpf.GroupBox header:"Locks" content:grid)

		grid = Wpf.UniformGrid columns:3 spacingAll:#(5,2,5,3)
		grid.Add (_moveInheritChk = Wpf.Checkbox content:"Move" hContentAlign:#Right spacing:4)
		grid.Add (_rotateInheritChk = Wpf.Checkbox content:"Rotate" hContentAlign:#Right spacing:4)
		grid.Add (_scaleInheritChk = Wpf.Checkbox content:"Scale" hContentAlign:#Right spacing:4)
		LinkInfoPanel.Add (inheritGrp = Wpf.GroupBox header:"Inherit" content:grid)

		Expander = Wpf.Expander header:"Link Info" content:linkInfoPanel var:"LinkInfo.Expander" file:(getThisScriptFilename()) 
	),
	

	fn CreateForm = 
	(
		if Expander != undefined then
		(
			Expanders = Wpf.ExpandersControl margin:2
			Expanders.Add Expander
			_LinkInfoForm = Wpf.Window title:"Link Info" content:Expanders location:#centerParent
			_LinkInfoForm.ShowModeless()
			dotNet.setLifetimeControl _LinkInfoForm #dotnet
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
LinkInfo = LinkInfoStc()
LinkInfo.Run()
LinkInfo.CreateForm()
