/*
Ajouter Replace: match case
Ajouter underscore checkbox
Replacer Index expander par Option expander avec la possibilité d'enlever les double underscores
Verifier la method Remove (length supérieur a la taille du mot, en fonction de index...)
*/

global sgzRenamer, Wpf
struct renamerStc
(
	nameGrp, nameTxt, prefixTxt, suffixTxt,
	trimGrp, trimFirstSpn, trimLastSpn,
	removeGrp, removeIndexSpn, removeLengthSpn,
	replaceGrp, replaceOldStrTxt, replaceNewStrTxt, replaceFirstBtn, replaceAllBtn, replaceMatchCaseBtn,
	replaceAtGrp, replaceAtIndexSpn, replaceAtLengthSpn, replaceAtStrTxt, 
	insertGrp, insertSpn, insertTxt,
	indexGrp, indexStartSpn, indexPaddingSpn,
	previewPopup, previewList, listBtn,
	renamerExpanders, renamerBtn, renamerPanel, renamerForm,

	renameClass = dotNetObject "SugzTools.Src.Rename",


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
			if _expanders[i] == sgzRenamer.replaceGrp AND sgzRenamer.replaceGrp.IsExpanded then sgzRenamer.renameClass.Replace (sgzRenamer.replaceOldStrTxt.Text) (sgzRenamer.replaceNewStrTxt.Text) (sgzRenamer.replaceAllBtn.IsChecked)
			
			-- Replace at 
			if _expanders[i] == sgzRenamer.replaceAtGrp AND sgzRenamer.replaceAtGrp.IsExpanded then sgzRenamer.renameClass.ReplaceAt (sgzRenamer.replaceAtIndexSpn.Value - 1) (sgzRenamer.replaceAtLengthSpn.Value) (sgzRenamer.replaceAtStrTxt.Text)

			-- Insert 
			if _expanders[i] == sgzRenamer.insertGrp AND sgzRenamer.insertGrp.IsExpanded then sgzRenamer.renameClass.Insert (sgzRenamer.insertSpn.Value - 1) (sgzRenamer.insertTxt.Text)
			
		)

		-- Index
		if sgzRenamer.indexGrp.IsExpanded then sgzRenamer.renameClass.AddIndex index

		-- Return the name
		sgzRenamer.renameClass.Name
	),
	

	fn RenameSelection = 
	(
		index = 0
		undo "Rename" on
		for obj in getCurrentSelection() do
		(
			obj.name = sgzRenamer.Rename obj index
			index += 1
		)
	),


	fn PreviewRename = 
	(

-- 		panel = Wpf.StackPanel margin:10 spacingVertical:5
-- 		index = 0
-- 		for obj in getCurrentSelection() do
-- 		(
-- 			panel.Add (Wpf.Textblock text:(obj.name + " => " + (sgzRenamer.Rename obj index)))
-- 			index += 1
-- 		)
		
-- 		previewList = Wpf.Datagrid headerBackground:#MaxBackground isSelectable:false margin:5 hAlign:#left columnHeaderHeight:20 rowHeight:20 
-- 		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "OldName" "Old Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 1
-- 		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "NewName" "New Name" false (Wpf.Enums.DataGridLengthUnitType #Star) 1

		index = 0
		for obj in getCurrentSelection() do
		(
			previewList.AddRow #((obj.name), (sgzRenamer.Rename obj index))
			index += 1
		)
		

		border = Wpf.Border background:#maxRollout borderbrush:#maxRolloutBorder borderThickness:1 cornerRadius:5 child:previewList
-- 		sgzRenamer.previewPopup = Wpf.Popup placementTarget:(sgzRenamer.renamerBtn) width:500 staysOpen:false placement:#Right isOpen:true child:border

-- 		sgzRenamer.previewPopup = dotNetObject "SugzTools.Controls.SgzPopup"
-- 		sgzRenamer.previewPopup.Width = 500
-- 		sgzRenamer.previewPopup.PlacementTarget = sgzRenamer.renamerBtn
-- 		sgzRenamer.previewPopup.Child = border
-- 		sgzRenamer.previewPopup.IsOpen = true 
-- 		sgzRenamer.previewPopup.StaysOpen = false
-- 		sgzRenamer.previewPopup.Placement = Wpf.Enums.PlacementMode #Right
	),


	fn ResizeWindow =
	(
		sgzRenamer.renamerForm.Height = sgzRenamer.renamerPanel.ActualHeight + 50
		sgzRenamer.renamerForm.Width = sgzRenamer.renamerPanel.ActualWidth + 30
	),


	fn SetUI = 
	(
		renamerPanel = Wpf.DockPanel margin:5 vAlign:#top
		dotNet.addEventHandler renamerPanel "SizeChanged" ResizeWindow


		-- previewList ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerPanel.Add (previewList = Wpf.Datagrid headerBackground:#MaxBackground isSelectable:false margin:#(5,0,5,0) hAlign:#left columnHeaderHeight:20 rowHeight:20 dock:#right )--visibility:#collapsed )
		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "OldName" "Old Name" false (Wpf.Enums.DataGridLengthUnitType #Auto) 0
		previewList.AddColumn (Wpf.Enums.PropertyUI #Textblock) "NewName" "New Name" false (Wpf.Enums.DataGridLengthUnitType #Auto) 0


		renamerPanel.Add(leftPanel = Wpf.StackPanel spacingVertical:7 vAlign:#top)

		leftPanel.Add(renamerExpanders = Wpf.ExpandersControl spacing:5)

		-- nameGrp ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		renamerExpanders.Add(nameGrp = Wpf.Expander header:"Base Name" isExpanded:false hasPopup:false content:(panel = Wpf.StackPanel margin:5 spacingVertical:7))

		nameGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.nameTxt.Text = $.name)
		nameCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.nameTxt.Text = "")
		panel.Add (nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:nameGetIcon uiElement2:nameCloseIcon)
			
		prefixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer.prefixTxt.Text = $.name)
		prefixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer.prefixTxt.Text = "")
		panel.Add (prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:prefixGetIcon uiElement2:prefixCloseIcon)
			
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
		panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2
		panel.Add (indexStartSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,10000000,1) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Index = sgzRenamer.indexStartSpn.Value))
		panel.Add (indexPaddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,1000000,2) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Padding = sgzRenamer.indexPaddingSpn.Value))
		leftPanel.Add (indexGrp = Wpf.Expander header:"Index" content:panel canDragDrop:false isExpanded:false hasPopup:false)

			

		-- btnPanel ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
		leftPanel.Add(panel = Wpf.Dockpanel())
		panel.Add (listBtn = Wpf.CheckButton width:20 height:25 margin:#(0,2,0,0) dock:#right checked:(fn x = sgzRenamer.previewList.Visibility = Wpf.Enums.Visibility #Visible) unchecked:(fn x = sgzRenamer.previewList.Visibility = Wpf.Enums.Visibility #collapsed))
		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center isEnabled:false)
		panel.Add (renamerBtn = Wpf.Button content:btnPanel height:25 margin:#(0,2,0,0) click:RenameSelection mouseRightButtonDown:PreviewRename)

		
		

	),
	

	fn CreateForm = 
	(
		if renamerPanel != undefined then
		(
			renamerForm = Wpf.Window title:"Renamer" content:renamerPanel width:275 location:#centerParent closed:(fn x = (sgzRenamer.renamerForm = undefined; updateToolbarButtons()))
			renamerForm.ShowModeless()
			dotNet.setLifetimeControl renamerForm #dotnet
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

sgzRenamer = renamerStc()
sgzRenamer.Run()
