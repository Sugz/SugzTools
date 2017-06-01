global Wpf, EvChart
struct EvChartStc
(
	evGrid, EvChartForm,
	
	fn SetCamera s e = 
	(
		print ("Row: " + (EvChart.evGrid.GetRowIndex s) as string + " / Column: " + (EvChart.evGrid.GetColumnIndex s) as string)
	),
	
	fn SetUI = 
	(
		evGrid = Wpf.Datagrid headerBackground:#maxRolloutBorder columnHeaderHeight:25 headerHorizontalAlignment:#center margin:5 selectionMode:#single selectionUnit:#cell headersVisibility:#all headerForeground:#maxtext
		
		btn = Wpf.Button margin:1 click:SetCamera -- height:30
		props = #(btn.ContentProperty)
		type = Wpf.GetType 1 -- Wpf.GetType ""
		unit = Wpf.Enums.DataGridLengthUnitType #Star
			
		evGrid.AddUsing "System.Windows.Media" @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll"
		evGrid.AddUsing "" @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll"
			
		columnHeaders = #(#("col1", "f/1.0"), #("col2", "f/1.4"), #("col3", "f/2.0"), #("col4", "f/2.8"), #("col5", "f/4.0"), #("col6", "f/5.6"), #("col7", "f/8.0"), #("col8", "f/11"), #("col9", "f/16"), #("col10", "f/22"))
		for columnHeader in columnHeaders do evGrid.AddColumn btn props type columnHeader[1] columnHeader[2] true unit 0
			
		rowHeaders = #("1 sec", "1/2 sec", "1/4 sec", "1/8 sec", "1/15 sec", "1/30 sec", "1/60 sec", "1/125 sec", "1/250 sec", "1/500 sec")
-- 		evGrid.AddRow rowHeaders[1] #("f/1.0\n1 sec", "f/1.4\n1 sec", "f/2.0\n1 sec", "f/2.8\n1 sec", "f/4.0\n1 sec", "f/5.6\n1 sec", "f/8.0\n1 sec", "f/11\n1 sec", "f/16\n1 sec", "f/22\n1 sec")
		evGrid.AddRow rowHeaders[1] #(0, 1, 2, 3, 4, 5, 6, 7, 8, 9)
		evGrid.AddRow rowHeaders[2] #(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
		evGrid.AddRow rowHeaders[3] #(2, 3, 4, 5, 6, 7, 8, 9, 10, 11)
		evGrid.AddRow rowHeaders[4] #(3, 4, 5, 6, 7, 8, 9, 10, 11, 12)
		evGrid.AddRow rowHeaders[5] #(4, 5, 6, 7, 8, 9, 10, 11, 12, 13)
		evGrid.AddRow rowHeaders[6] #(5, 6, 7, 8, 9, 10, 11, 12, 13, 14)
		evGrid.AddRow rowHeaders[7] #(6, 7, 8, 9, 10, 11, 12, 13, 14, 15)
		evGrid.AddRow rowHeaders[8] #(7, 8, 9, 10, 11, 12, 13, 14, 15, 16)
		evGrid.AddRow rowHeaders[9] #(8, 9, 10, 11, 12, 13, 14, 15, 16, 17)
		evGrid.AddRow rowHeaders[10] #(9, 10, 11, 12, 13, 14, 15, 16, 17, 18)
	),
	
	
	fn CreateForm = 
	(
		if evGrid != undefined then
		(
			EvChartForm = Wpf.Window title:"EV Chart" content:evGrid location:#centerParent width:400 height:325
			EvChartForm.ShowModeless()
			dotNet.setLifetimeControl EvChartForm #dotnet
		)
	),
	
	
	fn SetLifeTime = 
	(
		for btn in EvChart.evGrid.GetChildren (Wpf.GetType Wpf._button isNetClass:true) do
			dotNet.setLifetimeControl btn #dotnet
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
EvChart = EvChartStc()
EvChart.Run()
EvChart.CreateForm()
EvChart.SetLifeTime()


