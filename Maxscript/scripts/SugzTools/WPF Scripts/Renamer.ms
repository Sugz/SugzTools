/*
Ajouter Replace: match case
Ajouter underscore checkbox
*/

global sgzRenamer, Wpf
struct renamerStc
(
	file = getThisScriptFilename(),
	
	-- WPF Controls ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_nameTxt, _prefixTxt, _suffixTxt,
	trimGrp, _firstSpn, _lastSpn,
	_removeGrp,  indexSpn, lengthSpn,
	replaceGrp, oldStrTxt, newStrTxt, firstBtn, allBtn, matchCaseBtn,
	replaceAtGrp, replaceAtIndexSpn, replaceAtLengthSpn, replaceAtStrTxt, 
	insertGrp, insertSpn, insertTxt,
	_indexGrp, _startSpn, _paddingSpn,
	_renameBtn, renamePopup, _renamePanel, Form,
	

	renameClass = dotNetObject "SugzTools.Src.Rename",


	fn Rename obj index = 
	(
		sgzRenamer.renameClass.Name = obj.name

		-- Standard naming
		if sgzRenamer._nameTxt.Text.Count != 0 then sgzRenamer.renameClass.Name = sgzRenamer._nameTxt.Text
		if sgzRenamer._prefixTxt.Text.Count != 0 then sgzRenamer.renameClass.AddPrefix sgzRenamer._prefixTxt.Text
		if sgzRenamer._suffixTxt.Text.Count != 0 then sgzRenamer.renameClass.AddSuffix sgzRenamer._suffixTxt.Text
		
		-- Trim
		if sgzRenamer.trimGrp.IsExpanded then 
		(
			first = sgzRenamer._firstSpn.Value
			last = sgzRenamer._lastSpn.Value

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
		if sgzRenamer._removeGrp.IsExpanded then sgzRenamer.renameClass.Remove (sgzRenamer.indexSpn.Value - 1) (sgzRenamer.lengthSpn.Value)
		
		-- Replace
		if sgzRenamer.replaceGrp.IsExpanded then sgzRenamer.renameClass.Replace (sgzRenamer.oldStrTxt.Text) (sgzRenamer.newStrTxt.Text) (sgzRenamer.allBtn.IsChecked)
		
		-- Replace at 
		if sgzRenamer.replaceAtGrp.IsExpanded then sgzRenamer.renameClass.ReplaceAt (sgzRenamer.replaceAtIndexSpn.Value - 1) (sgzRenamer.replaceAtLengthSpn.Value) (sgzRenamer.replaceAtStrTxt.Text)

		-- Insert 
		if sgzRenamer.insertGrp.IsExpanded then sgzRenamer.renameClass.Insert (sgzRenamer.insertSpn.Value - 1) (sgzRenamer.insertTxt.Text)
		
		-- Index
		if sgzRenamer._indexGrp.IsExpanded then sgzRenamer.renameClass.AddIndex index

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

		panel = Wpf.StackPanel margin:10 spacingVertical:5
		index = 0
		for obj in getCurrentSelection() do
		(
			panel.Add (Wpf.Textblock text:(obj.name + " => " + (sgzRenamer.Rename obj index)))
			index += 1
		)

		border = Wpf.Border background:#maxRollout borderbrush:#maxRolloutBorder borderThickness:1 cornerRadius:5 child:panel 
-- 		sgzRenamer.renamePopup = dotNetObject "System.Windows.Controls.Primitives.Popup"
		sgzRenamer.renamePopup = dotNetObject "SugzTools.Controls.SgzPopup"
		sgzRenamer.renamePopup.PlacementTarget = sgzRenamer._renameBtn
		sgzRenamer.renamePopup.Child = border
		sgzRenamer.renamePopup.IsOpen = true 
		sgzRenamer.renamePopup.StaysOpen = false
		sgzRenamer.renamePopup.Placement = Wpf.Enums.PlacementMode #Right
	),
	
	
	
	fn SetUI = 
	(


		_renamePanel = Wpf.StackPanel margin:5 spacingVertical:7 vAlign:#top 

		nameGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer._nameTxt.Text = $.name)
		nameCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer._nameTxt.Text = "")
		_renamePanel.Add (_nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:nameGetIcon uiElement2:nameCloseIcon)
			
		prefixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer._prefixTxt.Text = $.name)
		prefixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer._prefixTxt.Text = "")
		_renamePanel.Add (_prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:prefixGetIcon uiElement2:prefixCloseIcon)
			
		suffixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then sgzRenamer._suffixTxt.Text = $.name)
		suffixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = sgzRenamer._suffixTxt.Text = "")
		_renamePanel.Add (_suffixTxt = Wpf.Textbox watermark:"Enter a suffix..." uiElement0:suffixGetIcon uiElement2:suffixCloseIcon)
			
		panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2
		panel.Add (_firstSpn = Wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (_lastSpn = Wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		_renamePanel.Add (trimGrp = Wpf.Expander header:"Trim" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))	
		
		panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2
		panel.Add (indexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (lengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch)
		_renamePanel.Add (_removeGrp = Wpf.Expander header:"Remove" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
			
		panel = Wpf.StackPanel margin:5 spacingVertical:7
		panel.Add (oldStrTxt = Wpf.Textbox watermark:"Old String")
		panel.Add (newStrTxt = Wpf.Textbox watermark:"New String")
		panel.Add (grid = Wpf.UniformGrid columns:3)
		grid.Add (firstBtn = Wpf.RadioButton content:"First" isChecked:true hAlign:#left margin:#(2,0,5,0))
		grid.Add (allBtn = Wpf.RadioButton content:"All" hAlign:#left margin:#(5,0,0,0))
		grid.Add (matchCaseBtn = Wpf.Checkbox content:"Match case" hAlign:#stretch margin:#(5,0,0,0))
		_renamePanel.Add (replaceGrp = Wpf.Expander header:"Replace" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
			
		panel = Wpf.StackPanel margin:5 spacingVertical:7
		panel.Add (grid = Wpf.UniformGrid columns:2)
		grid.Add (replaceAtIndexSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:60 height:18 hAlign:#stretch margin:#(2,0,5,0))
		grid.Add (replaceAtLengthSpn = Wpf.Spinner content:"Length:" type:#integer range:#(0,1000,1) fieldWidth:60 height:18 hAlign:#stretch margin:#(5,0,0,0))
		panel.Add (replaceAtStrTxt = Wpf.Textbox watermark:"New String")
		_renamePanel.Add (replaceAtGrp = Wpf.Expander header:"Replace At" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))

		panel = Wpf.StackPanel margin:5 spacingVertical:7
		panel.Add (insertSpn = Wpf.Spinner content:"Index:" type:#integer range:#(1,1000,1) fieldWidth:60 height:18 margin:#(2,0,0,0))
		panel.Add (insertTxt = Wpf.Textbox watermark:"New String")
		_renamePanel.Add (insertGrp = Wpf.Expander header:"Insert At" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
			
		panel = Wpf.UniformGrid spacingAll:#(7,5,5,5) columns:2
		panel.Add (_startSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,10000000,1) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Index = sgzRenamer._startSpn.Value))
		panel.Add (_paddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,1000000,2) fieldWidth:60 height:18 hAlign:#stretch valueChanged:(fn x = sgzRenamer.renameClass.Padding = sgzRenamer._paddingSpn.Value))
		_renamePanel.Add (_indexGrp = Wpf.Expander header:"Index" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
			
		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center isEnabled:false)
		_renamePanel.Add (_renameBtn = Wpf.Button content:btnPanel height:25 margin:#(0,2,0,0) click:RenameSelection mouseRightButtonDown:PreviewRename)

		#(_renamePanel, nameGetIcon, nameCloseIcon, _nameTxt, prefixGetIcon, prefixCloseIcon, _prefixTxt, suffixGetIcon, suffixCloseIcon, _suffixTxt, _renameBtn)
	),

	
	
	fn CreateForm = 
	(
		border = Wpf.Border background:#maxRollout child:_renamePanel
		dotNet.addEventHandler _renamePanel "SizeChanged" (fn x = sgzRenamer.Form.Height = sgzRenamer._renamePanel.ActualHeight + 50)

		Form = Wpf.Window title:"Renamer" content:border width:275 location:#centerParent closed:(fn x = (sgzRenamer.Form = undefined; updateToolbarButtons()))
		Form.ShowModeless()
		dotNet.setLifetimeControl Form #dotnet
	),



	fn Run = 
	(
		if doesFileExist (file = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then 
		(
			fileIn file
			for ctrl in SetUI() do dotNet.setLifetimeControl ctrl #dotnet
		)
	)
	
)


sgzRenamer = renamerStc()
sgzRenamer.Run()