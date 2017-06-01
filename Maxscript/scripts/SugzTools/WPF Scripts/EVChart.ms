global Wpf, EvChart
struct EvChartStc
(
	evGrid, EvChartForm,
	
	fn SetUI = 
	(
		evGrid = Wpf.Datagrid headerBackground:#MaxRolloutBorder columnHeaderHeight:25 rowHeight:23 headerHorizontalAlignment:#center margin:5
		
		btn = Wpf.Button()
		props = #(btn.BackgroundProperty, btn.HoverBrushProperty)
		type = Wpf.GetType (Wpf._solidColorBrush) isNetClass:true
		unit = Wpf.Enums.DataGridLengthUnitType #Star
			
		evGrid.AddUsing "System.Windows.Media" @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll"
		evGrid.AddUsing "" @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll"
			
		arr = #(#("f10", "f/1.0"), #("f14", "f/1.4"), #("f20", "f/2.0"), #("f28", "f/2.8"), #("f40", "f/4.0"), #("f56", "f/5.6"), #("f80", "f/8.0"), #("f11", "f/11"), #("f16", "f/16"), #("f22", "f/22"))
		for val in arr do evGrid.AddColumn btn props type val[1] val[2] true unit 0
			
		c0 = Wpf.SolidColorBrush #(255, 255, 205)
		c1 = Wpf.SolidColorBrush #(254, 255, 153)
		c2 = Wpf.SolidColorBrush #(254, 255, 0)
		c3 = Wpf.SolidColorBrush #(204, 255, 0)
		c4 = Wpf.SolidColorBrush #(153, 254, 0)
		c5 = Wpf.SolidColorBrush #(1, 255, 205)
		c6 = Wpf.SolidColorBrush #(101, 153, 255)
		c7 = Wpf.SolidColorBrush #(154, 204, 255)
		c8 = Wpf.SolidColorBrush #(203, 153, 204)
		c9 = Wpf.SolidColorBrush #(255, 153, 255)
		c10 = Wpf.SolidColorBrush #(254, 204, 205)
		c11 = Wpf.SolidColorBrush #(255, 203, 153)
		c12 = Wpf.SolidColorBrush #(255, 204, 0)
		c13 = Wpf.SolidColorBrush #(255, 153, 0)
		c14 = Wpf.SolidColorBrush #(255, 0, 0)
		c15 = Wpf.SolidColorBrush #(203, 51, 152)
		c16 = Wpf.SolidColorBrush #(204, 0, 255)
		c17 = Wpf.SolidColorBrush #(103, 51, 255)
		c18 = Wpf.SolidColorBrush #(153, 50, 103)
			
		evGrid.AddRow #(c0, c1, c2, c3, c4, c5, c6, c7, c8, c9)
		evGrid.AddRow #(c1, c2, c3, c4, c5, c6, c7, c8, c9, c10)
		evGrid.AddRow #(c2, c3, c4, c5, c6, c7, c8, c9, c10, c11)
		evGrid.AddRow #(c3, c4, c5, c6, c7, c8, c9, c10, c11, c12)
		evGrid.AddRow #(c4, c5, c6, c7, c8, c9, c10, c11, c12, c13)
		evGrid.AddRow #(c5, c6, c7, c8, c9, c10, c11, c12, c13, c14)
		evGrid.AddRow #(c6, c7, c8, c9, c10, c11, c12, c13, c14, c15)
		evGrid.AddRow #(c7, c8, c9, c10, c11, c12, c13, c14, c15, c16)
		evGrid.AddRow #(c8, c9, c10, c11, c12, c13, c14, c15, c16, c17)
		evGrid.AddRow #(c9, c10, c11, c12, c13, c14, c15, c16, c17, c18)
	),
	
	
	fn CreateForm = 
	(
		if evGrid != undefined then
		(
			EvChartForm = Wpf.Window title:"EV Chart" content:evGrid location:#centerParent width:350 height:350
			EvChartForm.ShowModeless()
			dotNet.setLifetimeControl EvChartForm #dotnet
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
EvChart = EvChartStc()
EvChart.Run()
EvChart.CreateForm()
