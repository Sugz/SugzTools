global Wpf, Test
struct TestStc
(
	dg, TestForm,
	
	
	fn SetUI = 
	(
		dg = Wpf.Datagrid headerBackground:#maxRolloutBorder headerHorizontalAlignment:#center margin:5 headerForeground:#maxtext
		dg.AddUsing "SugzTools.Max" @"D:\Travail\GitHub\SugzTools\CSharp\SugzTools\bin\Debug\SugzTools.dll"
		
		txt = Wpf.TextBlock()
		unit = Wpf.Enums.DataGridLengthUnitType #Star
		type = Wpf.GetType Wpf._node isNetClass:true
		props = #(txt.TextProperty)
		
		dg.AddColumn txt "Name" unit 0
		dg.AddProperty type "Node" false
		dg.AddBindings props  "Node.Name"  0
		
-- 		node1 = Wpf.Node $Box001
-- 		node2 = Wpf.Node $Box002
-- 		node3 = Wpf.Node $Box003
		
		for obj in selection do dg.AddRow #(Wpf.Node obj)
		
		
	),
	
	
	fn CreateForm = 
	(
		if dg != undefined then
		(
			TestForm = Wpf.Window title:"EV Chart" content:dg location:#centerParent width:400 height:325
			TestForm.ShowModeless()
			dotNet.setLifetimeControl TestForm #dotnet
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
Test = TestStc()
Test.Run()
Test.CreateForm()

