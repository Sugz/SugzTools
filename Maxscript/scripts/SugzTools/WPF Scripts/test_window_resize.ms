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


	fn SetPreviewListVisibility = 
	(
		if sgzRenamer.listBtn.IsChecked then
		(
			sgzRenamer.mainGrid.SetColumn 0 (sgzRenamer.mainGrid.actualWidth)
			sgzRenamer.mainGrid.SetColumn 1 (Wpf.Enums.GridUnitType #auto)
			sgzRenamer.mainGrid.SetColumn 2 (Wpf.Enums.GridUnitType #star)

			sgzRenamer.mainGrid.SetColumnSpan sgzRenamer.leftPanel 1
			sgzRenamer.gridSplitter.Visibility = sgzRenamer.previewList.Visibility = Wpf.Enums.Visibility #Visible
			sgzRenamer.renamerForm.Width = sgzRenamer.renamerForm.Width + sgzRenamer.previewListWidth + 5
		)
		else
		(
			sgzRenamer.mainGrid.SetColumn 0 (Wpf.Enums.GridUnitType #star)
			sgzRenamer.mainGrid.SetColumn 1 (0)
			sgzRenamer.mainGrid.SetColumn 2 (0)

			sgzRenamer.previewListWidth = sgzRenamer.previewList.ActualWidth
			sgzRenamer.gridSplitter.Visibility = sgzRenamer.previewList.Visibility = Wpf.Enums.Visibility #Collapsed
			sgzRenamer.renamerForm.Width = sgzRenamer.renamerForm.Width - (sgzRenamer.previewListWidth + 15)
			sgzRenamer.mainGrid.SetColumnSpan sgzRenamer.leftPanel 3
		)
	),


	fn ResizeWindow =
	(
		sgzRenamer.renamerForm.Height = sgzRenamer.leftPanel.ActualHeight + 50
	),

	
	fn SetUI = 
	(
		mainGrid = Wpf.Grid margin:5
		mainGrid.AddColumn 250
		mainGrid.AddColumn()
		mainGrid.AddColumn (Wpf.Enums.GridUnitType #star)

		maingrid.Add(leftPanel = Wpf.StackPanel vAlign:#top) 0 0
		dotNet.addEventHandler leftPanel "SizeChanged" ResizeWindow

		leftPanel.Add(renamerExpanders = Wpf.ExpandersControl spacing:5 hAlign:#Stretch)


		-- nameGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(nameGrp = Wpf.Expander header:"Base Name" isExpanded:false hasPopup:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7))

		nameGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.nameTxt.Text = $.name)
		nameCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.nameTxt.Text = "")
		panel.Add (nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:nameGetIcon uiElement2:nameCloseIcon)-- textChanged:(fn x s e = sgzRenamer.renameClass.NewName = s.text))
			
		prefixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.prefixTxt.Text = $.name)
		prefixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.prefixTxt.Text = "")
		panel.Add (prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:prefixGetIcon uiElement2:prefixCloseIcon)-- textChanged:(fn x s e = sgzRenamer.renameClass.AddPrefix s.Textblock))
			
		suffixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.suffixTxt.Text = $.name)
		suffixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.suffixTxt.Text = "")
		panel.Add (suffixTxt = Wpf.Textbox watermark:"Enter a suffix..." uiElement0:suffixGetIcon uiElement2:suffixCloseIcon)

		
		-- trimGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(trimGrp = Wpf.Expander header:"Trim" hasPopup:false isExpanded:false content:(panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2))
		panel.Add (trimFirstSpn = Wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (trimLastSpn = Wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)


		-- removeGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(removeGrp = Wpf.Expander header:"Remove" hasPopup:false isExpanded:false content:(panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2))
		panel.Add (removeIndexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (removeLengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch)


		-- replaceGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(replaceGrp = Wpf.Expander header:"Replace" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7))
		panel.Add (replaceOldStrTxt = Wpf.Textbox watermark:"Old String")
		panel.Add (replaceNewStrTxt = Wpf.Textbox watermark:"New String")
		panel.Add (grid = Wpf.UniformGrid columns:3)
		grid.Add (replaceFirstBtn = Wpf.RadioButton content:"First" isChecked:true hAlign:#left margin:#(2,0,5,0))
		grid.Add (replaceAllBtn = Wpf.RadioButton content:"All" hAlign:#left margin:#(5,0,0,0))
		grid.Add (replaceMatchCaseBtn = Wpf.Checkbox content:"Match case" hAlign:#stretch margin:#(5,0,0,0))


		-- replaceAtGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(replaceAtGrp = Wpf.Expander header:"Replace At" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7))
		panel.Add (grid = Wpf.UniformGrid columns:2)
		grid.Add (replaceAtIndexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:60 height:18 hAlign:#stretch margin:#(2,0,5,0))
		grid.Add (replaceAtLengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch margin:#(5,0,0,0))
		panel.Add (replaceAtStrTxt = Wpf.Textbox watermark:"New String")


		-- insertGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(insertGrp = Wpf.Expander header:"Insert" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7))
		panel.Add (insertSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:60 height:18 margin:#(2,0,0,0))
		panel.Add (insertTxt = Wpf.Textbox watermark:"New String")


		-- indexGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(indexGrp = Wpf.Expander header:"Index" hasPopup:false isExpanded:false content:(panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2))
		panel.Add (indexStartSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,10000000,1) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Index = sgzRenamer.indexStartSpn.Value))
		panel.Add (indexPaddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,1000000,2) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Padding = sgzRenamer.indexPaddingSpn.Value))


		-- renamerBtn ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		leftPanel.Add(panel = Wpf.Dockpanel margin:0)
		panel.Add (listBtn = Wpf.CheckButton width:25 height:25 isChecked:true dock:#right content:(Wpf.Icon icon:"MdiEyeOutline" margin:3 isEnabled:false) click:SetPreviewListVisibility)
		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center isEnabled:false)
		panel.Add (renamerBtn = Wpf.Button height:25 content:btnPanel)--click:RenameSelection)


		-- previewList ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		maingrid.Add (previewList = Wpf.Datagrid headerBackground:#MaxBackground isSelectable:false columnHeaderHeight:20 rowHeight:20 ) 2 0--visibility:#collapsed )
		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "OldName" "Old Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 0
		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "NewName" "New Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 0



		maingrid.Add (gridSplitter = dotNetObject "System.Windows.Controls.GridSplitter") 1 0
		gridSplitter.Width = 5
		gridSplitter.Margin = Wpf.Thickness #(5,0)
		gridSplitter.background = Wpf.SolidColorBrush #MaxRolloutBorder
		gridSplitter.HorizontalAlignment = gridSplitter.HorizontalAlignment.Center

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
