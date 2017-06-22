/*
Ajouter Replace: match case
Ajouter underscore checkbox
Replacer Index expander par Option expander avec la possibilité d'enlever les double underscores
Verifier la method Remove (length supérieur a la taille du mot, en fonction de index...)
*/

global Wpf, sgzRenamer
struct renamerStc
(
	mainGrid, leftPanel, previewList, gridSplitter, listBtn,
	nameGrp, nameGetIcon, nameCloseIcon, nameTxt, prefixGetIcon, prefixCloseIcon, prefixTxt, suffixGetIcon, suffixCloseIcon, suffixTxt,
	trimGrp, trimFirstSpn, trimLastSpn,
	removeGrp, removeIndexSpn, removeLengthSpn,
	replaceGrp, replaceOldStrTxt, replaceNewStrTxt, replaceFirstBtn, replaceAllBtn, replaceMatchCaseBtn,
	replaceAtGrp, replaceAtIndexSpn, replaceAtLengthSpn, replaceAtStrTxt, 
	insertGrp, insertSpn, insertTxt,
	indexGrp, indexChkBtn, indexStartSpn, indexPaddingSpn,
	renamerExpanders, renamerBtn, renamerPanel, renamerForm,

	renameClass = dotNetObject "SugzTools.Src.Rename",
	previewListWidth,
	selectionChangedCB,
	leftPanelMinWidth = 235,

	selectedObjects = #(),





	fn Rename obj index = 
	(
		sgzRenamer.renameClass.Name = obj.name


		_expanders = Wpf.AsArray sgzRenamer.renamerExpanders.Items
		for  i = 1 to _expanders.Count do 
		(
			-- Standard naming
			if _expanders[i] == sgzRenamer.nameGrp AND sgzRenamer.nameGrp.IsExpanded then 
			(
				if sgzRenamer.nameTxt.Text.Count != 0 then sgzRenamer.renameClass.Name = sgzRenamer.nameTxt.Text
				if sgzRenamer.prefixTxt.Text.Count != 0 then sgzRenamer.renameClass.AddPrefix sgzRenamer.prefixTxt.Text
				if sgzRenamer.suffixTxt.Text.Count != 0 then sgzRenamer.renameClass.AddSuffix sgzRenamer.suffixTxt.Text
			)
		
			-- Trim
			if _expanders[i] == sgzRenamer.trimGrp AND sgzRenamer.trimGrp.IsExpanded then 
			(
				first = sgzRenamer.trimFirstSpn.Value
				last = sgzRenamer.trimLastSpn.Value

				-- just erase the name if one of spinner's value is over name count
				if ((first >= sgzRenamer.renameClass.Name.Count) OR (last >= sgzRenamer.renameClass.Name.Count) OR (first + last >= sgzRenamer.renameClass.Name.Count)) then
					sgzRenamer.renameClass.Name = ""
				else 
				(
					if first != 0 then sgzRenamer.renameClass.RemoveFirst first
					if last != 0 then sgzRenamer.renameClass.RemoveLast last
				)
			)
			
			-- Remove 
			if _expanders[i] == sgzRenamer.removeGrp AND sgzRenamer.removeGrp.IsExpanded then sgzRenamer.renameClass.Remove (sgzRenamer.removeIndexSpn.Value - 1) (sgzRenamer.removeLengthSpn.Value)
			
			-- Replace
			if _expanders[i] == sgzRenamer.replaceGrp AND sgzRenamer.replaceGrp.IsExpanded then sgzRenamer.renameClass.Replace (sgzRenamer.replaceOldStrTxt.Text) (sgzRenamer.replaceNewStrTxt.Text) (sgzRenamer.replaceAllBtn.IsChecked) (sgzRenamer.replaceMatchCaseBtn.IsChecked)
			
			-- Replace at 
			if _expanders[i] == sgzRenamer.replaceAtGrp AND sgzRenamer.replaceAtGrp.IsExpanded then sgzRenamer.renameClass.ReplaceAt (sgzRenamer.replaceAtIndexSpn.Value - 1) (sgzRenamer.replaceAtLengthSpn.Value) (sgzRenamer.replaceAtStrTxt.Text)

			-- Insert 
			if _expanders[i] == sgzRenamer.insertGrp AND sgzRenamer.insertGrp.IsExpanded then sgzRenamer.renameClass.Insert (sgzRenamer.insertSpn.Value - 1) (sgzRenamer.insertTxt.Text)

			-- Index
			if _expanders[i] == sgzRenamer.indexGrp AND sgzRenamer.indexGrp.IsExpanded then sgzRenamer.renameClass.AddIndex (sgzRenamer.indexStartSpn.Value) (sgzRenamer.indexPaddingSpn.Value) index (sgzRenamer.indexChkBtn.ISChecked)
			
		)

		-- Return the name
		sgzRenamer.renameClass.Name
	),


	fn RenameSelection = 
	(
		index = 0
		undo "Rename" on
		for obj in sgzRenamer.selectedObjects do
		(
			obj.name = sgzRenamer.Rename obj index
			index += 1
		)
	),


	fn PreviewRename = 
	(
		sgzRenamer.previewList.ClearRows()
		index = 0
		for obj in sgzRenamer.selectedObjects do
		(
			sgzRenamer.previewList.AddRow #((obj.name), (sgzRenamer.Rename obj index))
			index += 1
		)
	),


	fn SetPreviewListVisibility = 
	(
		if sgzRenamer.listBtn.IsChecked then
		(
			sgzRenamer.mainGrid.SetColumn 0 (sgzRenamer.mainGrid.actualWidth) sgzRenamer.leftPanelMinWidth
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
		mainGrid = Wpf.Grid margin:5 minWidth:(sgzRenamer.leftPanelMinWidth)
		mainGrid.AddColumn sgzRenamer.leftPanelMinWidth sgzRenamer.leftPanelMinWidth
		mainGrid.AddColumn()
		mainGrid.AddColumn (Wpf.Enums.GridUnitType #star)

		maingrid.Add(leftPanel = Wpf.StackPanel vAlign:#top) 0 0
		dotNet.addEventHandler leftPanel "SizeChanged" ResizeWindow

		leftPanel.Add(renamerExpanders = Wpf.ExpandersControl spacing:5 hAlign:#Stretch drop:PreviewRename)


		-- nameGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(nameGrp = Wpf.Expander header:"Base Name" isExpanded:false hasPopup:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7) expandChanged:PreviewRename)

		nameGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.nameTxt.Text = $.name)
		nameCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.nameTxt.Text = "")
		panel.Add (nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:nameGetIcon uiElement2:nameCloseIcon textChanged:PreviewRename)
			
		prefixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.prefixTxt.Text = $.name)
		prefixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.prefixTxt.Text = "")
		panel.Add (prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:prefixGetIcon uiElement2:prefixCloseIcon textChanged:PreviewRename)
			
		suffixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.suffixTxt.Text = $.name)
		suffixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.suffixTxt.Text = "")
		panel.Add (suffixTxt = Wpf.Textbox watermark:"Enter a suffix..." uiElement0:suffixGetIcon uiElement2:suffixCloseIcon textChanged:PreviewRename)

		
		-- trimGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(trimGrp = Wpf.Expander header:"Trim" hasPopup:false isExpanded:false content:(panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2) expandChanged:PreviewRename)
		panel.Add (trimFirstSpn = Wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)
		panel.Add (trimLastSpn = Wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)


		-- removeGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(removeGrp = Wpf.Expander header:"Remove" hasPopup:false isExpanded:false content:(panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2) expandChanged:PreviewRename)
		panel.Add (removeIndexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(0,1000,1) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)
		panel.Add (removeLengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)


		-- replaceGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(replaceGrp = Wpf.Expander header:"Replace" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7) expandChanged:PreviewRename)
		panel.Add (replaceOldStrTxt = Wpf.Textbox watermark:"Old String" textChanged:PreviewRename)
		panel.Add (replaceNewStrTxt = Wpf.Textbox watermark:"New String" textChanged:PreviewRename)
		panel.Add (grid = Wpf.UniformGrid columns:3)
		grid.Add (replaceFirstBtn = Wpf.RadioButton content:"First" isChecked:true hAlign:#left margin:#(2,0,5,0) click:PreviewRename)
		grid.Add (replaceAllBtn = Wpf.RadioButton content:"All" hAlign:#left margin:#(5,0,0,0) click:PreviewRename)
		grid.Add (replaceMatchCaseBtn = Wpf.Checkbox content:"Match case" hAlign:#stretch margin:#(5,0,0,0) click:PreviewRename)


		-- replaceAtGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(replaceAtGrp = Wpf.Expander header:"Replace At" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7) expandChanged:PreviewRename)
		panel.Add (grid = Wpf.UniformGrid columns:2)
		grid.Add (replaceAtIndexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:45 height:18 hAlign:#stretch margin:#(2,0,5,0) valueChanged:PreviewRename)
		grid.Add (replaceAtLengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:45 height:18 hAlign:#stretch margin:#(5,0,0,0) valueChanged:PreviewRename)
		panel.Add (replaceAtStrTxt = Wpf.Textbox watermark:"New String" textChanged:PreviewRename)


		-- insertGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(insertGrp = Wpf.Expander header:"Insert" hasPopup:false isExpanded:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7) expandChanged:PreviewRename)
		panel.Add (insertSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:45 height:18 margin:#(2,0,0,0) valueChanged:PreviewRename)
		panel.Add (insertTxt = Wpf.Textbox watermark:"New String" textChanged:PreviewRename)


		-- indexGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(indexGrp = Wpf.Expander header:"Index" hasPopup:false isExpanded:false content:(panel = Wpf.DockPanel margin:5 hAlign:#Stretch) expandChanged:PreviewRename)
		panel.Add (indexChkBtn = Wpf.CheckButton content:"_" width:20 height:18 click:PreviewRename)
		panel.Add (grid = Wpf.UniformGrid spacingAll:5 columns:2 hAlign:#stretch)
		grid.Add (indexStartSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,10000000,1) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)
		grid.Add (indexPaddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,1000000,2) fieldWidth:45 height:18 hAlign:#stretch valueChanged:PreviewRename)


		-- renamerBtn ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		leftPanel.Add(panel = Wpf.Dockpanel margin:#(0,5,0,0))
		panel.Add (listBtn = Wpf.CheckButton width:25 height:25 dock:#right content:(Wpf.Icon icon:"MdiEyeOutline" margin:3 isEnabled:false) click:SetPreviewListVisibility)
		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center isEnabled:false)
		panel.Add (renamerBtn = Wpf.Button height:25 content:btnPanel click:RenameSelection)


		-- gridSplitter ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		maingrid.Add (gridSplitter = Wpf.GridSplitter width:5 margin:#(5,0) background:#MaxRolloutBorder hAlign:#center) 1 0


		-- previewList ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		maingrid.Add (previewList = Wpf.Datagrid headerBackground:#MaxRolloutBorder isSelectable:false columnHeaderHeight:20 rowHeight:20 alternatingRowBackground:#maxControl ) 2 0
		txt = Wpf.Textblock()
		props = #(txt.TextProperty)
		previewList.AddColumn txt props "" "OldName" "Old Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 0
		previewList.AddColumn txt props ""  "NewName" "New Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 0

	),


	fn OnLoad  = 
	(
		if not sgzRenamer.listBtn.IsChecked then SetPreviewListVisibility()
		sgzRenamer.selectedObjects = _sgz._extMxs.SortObjects (getCurrentSelection())
		sgzRenamer.PreviewRename()
	),
	
	
	fn OnClose  = 
	(
		sgzRenamer.selectionChangedCB = sgzRenamer.renamerForm = undefined
		updateToolbarButtons()
	),
	
	
-- 	fn SetLifeTime = 
-- 	(
-- 		for _control in #(nameGetIcon, nameCloseIcon, nameTxt, prefixGetIcon, prefixCloseIcon, prefixTxt, suffixGetIcon, suffixCloseIcon, suffixTxt, renamerBtn, renamerForm) do 
-- 			if _control != undefined then dotNet.setLifetimeControl _control #dotnet
-- 	),
	

	fn CreateForm = 
	(
		if mainGrid != undefined then
		(
			renamerForm = Wpf.Window title:"Renamer" content:mainGrid location:#centerParent width:750 minimumSize:#(261, 200) loaded:OnLoad closed:OnClose
			renamerForm.ShowModeless()

			dotNet.setLifetimeControl renamerForm #dotnet
-- 			dotNet.setLifetimeControl (nameTxt.uiElement0) #dotnet

-- 			SetLifeTime()
		)
	),


	fn SelectionChanged ev nd = 
	(
		sgzRenamer.selectedObjects = _sgz._extMxs.SortObjects (getCurrentSelection())
		sgzRenamer.PreviewRename()
	),


	fn AddCallback = 
	(
		sgzRenamer.selectionChangedCB = NodeEventCallback mouseUp:true selectionChanged:SelectionChanged
	),


	
	

	fn Run = 
	(
		if doesFileExist (file = "$userScripts\\SugzTools\\Libs\\WPF\\Wpf_Lib.ms") then 
		(
			fileIn file
			SetUI()
			AddCallback()
			
		)
	)
	
)
sgzRenamer = renamerStc()
sgzRenamer.Run()
--sgzRenamer.CreateForm()
