global Wpf, sgzRenamer
struct renamerStc
(
	mainGrid, leftPanel, previewList, gridSplitter, listBtn,
	nameGrp, nameTxt, prefixTxt, suffixTxt,
	trimGrp, trimFirstSpn, trimLastSpn,
	removeGrp, removeIndexSpn, removeLengthSpn,
	replaceGrp, replaceOldStrTxt, replaceNewStrTxt, replaceFirstBtn, replaceAllBtn, replaceMatchCaseBtn,
	replaceAtGrp, replaceAtIndexSpn, replaceAtLengthSpn, replaceAtStrTxt, 
	insertGrp, insertSpn, insertTxt,
	indexGrp, indexStartSpn, indexPaddingSpn,
	renamerExpanders, renamerBtn, renamerPanel, renamerForm,

	renameClass = dotNetObject "SugzTools.Src.Rename",
	previewListWidth,



	
	fn SetUI = 
	(
		mainGrid = Wpf.Grid margin:5
		mainGrid.AddColumn 250 150
		mainGrid.AddColumn()
		mainGrid.AddColumn (Wpf.Enums.GridUnitType #star)

		maingrid.Add(leftPanel = Wpf.StackPanel Background:red) 0 0

		maingrid.Add (gridSplitter = dotNetObject "System.Windows.Controls.GridSplitter") 1 0
		gridSplitter.Width = 5
		gridSplitter.Margin = Wpf.Thickness #(5,0)
		gridSplitter.background = Wpf.SolidColorBrush #MaxRolloutBorder
		gridSplitter.HorizontalAlignment = gridSplitter.HorizontalAlignment.Center

		maingrid.Add(Wpf.StackPanel Background:blue) 2 0

	),
	

	fn CreateForm = 
	(
		if mainGrid != undefined then
		(
			renamerForm = Wpf.Window title:"Sugz" content:mainGrid location:#centerParent width:750
			renamerForm.ShowModeless()
			dotNet.setLifetimeControl renamerForm #dotnet

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
sgzRenamer = renamerStc()
sgzRenamer.Run()
sgzRenamer.CreateForm()
