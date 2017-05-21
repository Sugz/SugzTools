global Wpf, test
struct testStc
(
	mainGrid, leftPanel, rightPanel, chkBtn, 
	testForm, 


	fn SetRightPanelVisibility s e = 
	(
		if s.IsChecked then
		(
			gridLength = dotnetClass "System.Windows.GridLength"
			test.mainGrid.ColumnDefinitions[0].Width =  dotnetobject gridLength (test.mainGrid.ActualWidth)
		)
		else
		(

		)
	),

	
	fn SetUI = 
	(
		mainGrid = Wpf.Grid background:red margin:5
		mainGrid.AddColumn #test
-- 		mainGrid.AddColumn()
-- 		mainGrid.AddColumn (Wpf.Enums.GridUnitType #star)

-- 		maingrid.Add(leftPanel = Wpf.StackPanel background:green) 0 0
-- 		leftPanel.Add (chkBtn = Wpf.Checkbutton click:SetRightPanelVisibility)

-- 		maingrid.Add(rightPanel = Wpf.StackPanel background:blue) 2 0

-- 		maingrid.Add (gridSplitter = dotNetObject "System.Windows.Controls.GridSplitter") 1 0
-- 		gridSplitter.Width = 5
-- 		gridSplitter.HorizontalAlignment = gridSplitter.HorizontalAlignment.Center

	),
	

	fn CreateForm = 
	(
		if mainGrid != undefined then
		(
			testForm = Wpf.Window title:"Sugz" content:mainGrid location:#centerParent width:750
			testForm.ShowModeless()
			dotNet.setLifetimeControl testForm #dotnet
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
