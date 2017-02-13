global Renamer, Wpf
struct renamerStc
(
	-- WPF Controls ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_nameTxt, _prefixTxt, _suffixTxt, 
	_removeGrp, _firstSpn, _lastSpn,
	_indexGrp, _startSpn, _paddingSpn,
	_renameBtn, _renamePanel, _form,


	fn Rename = 
	(
		index = 0
		for obj in getCurrentSelection() do
		(
			nodeName = obj.name

			-- Standard naming
			if Renamer._nameTxt.Text.Count != 0 then nodeName = Renamer._nameTxt.Text
			if Renamer._prefixTxt.Text.Count != 0 then nodeName = Renamer._prefixTxt.Text + nodeName
			if Renamer._suffixTxt.Text.Count != 0 then nodeName += Renamer._suffixTxt.Text

			-- Remove chars 
			if Renamer._removeGrp.IsExpanded then 
			(
				first = Renamer._firstSpn.Value
				last = Renamer._lastSpn.Value

				-- just erase the name if one of spinner's value is over name count
				if ((first >= nodeName.count) OR (last >= nodeName.count) OR (first + last >= nodeName.count)) then
					nodeName = ""
				else 
				(
					if first != 0 then nodeName = substring nodeName (first + 1) -1
					if last != 0 then nodeName = substring nodeName 1 (nodeName.count - last)
				)
			)

			-- Index incrementation
			if Renamer._indexGrp.IsExpanded then 
			(
				increment = (Renamer._startSpn.Value + index) as string
				while increment.count < Renamer._paddingSpn.value do 
					increment = "0" + increment

				nodeName += increment
			)

			obj.name = nodeName
			index += 1
		)
	),
	
	
	
	fn SetUI = 
	(
		_renamePanel = Wpf.StackPanel margin:5 spacingVertical:7 vAlign:#top 

		nameGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._nameTxt.Text = $.name)
		nameCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = Renamer._nameTxt.Text = "")
		_renamePanel.Add (_nameTxt = Wpf.Textbox watermark:"Enter a name..." uiElement0:nameGetIcon uiElement2:nameCloseIcon)
			
		prefixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._prefixTxt.Text = $.name)
		prefixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = Renamer._prefixTxt.Text = "")
		_renamePanel.Add (_prefixTxt = Wpf.Textbox watermark:"Enter a prefix..." uiElement0:prefixGetIcon uiElement2:prefixCloseIcon)
			
		suffixGetIcon = Wpf.Icon icon:"MdiStepForward" padding:#(6,7,6,6) cursor:#Arrow vAlign:#center click:(fn x = if _sgz._sel.IsSelectionOne() then Renamer._suffixTxt.Text = $.name)
		suffixCloseIcon = Wpf.Icon icon:"MdiWindowClose" padding:6 cursor:#Arrow vAlign:#center click:(fn x = Renamer._suffixTxt.Text = "")
		_renamePanel.Add (_suffixTxt = Wpf.Textbox watermark:"Enter a suffix..." uiElement0:suffixGetIcon uiElement2:suffixCloseIcon)
			
		panel = Wpf.StackPanel margin:#(7,5,5,5) spacingVertical:7
		panel.Add (_firstSpn = Wpf.Spinner content:"First:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (_lastSpn = Wpf.Spinner content:"Last:" type:#integer range:#(0,1000,0) fieldWidth:60 height:18 hAlign:#stretch)
		_renamePanel.Add (_removeGrp = Wpf.Expander header:"Remove Chars" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
		
		panel = Wpf.StackPanel margin:#(7,5,5,5) spacingVertical:7
		panel.Add (_startSpn = Wpf.Spinner content:"Start:" type:#integer range:#(0,100000,1) fieldWidth:60 height:18 hAlign:#stretch)
		panel.Add (_paddingSpn = Wpf.Spinner content:"Padding:" type:#integer range:#(0,10,2) fieldWidth:60 height:18 hAlign:#stretch)
		_renamePanel.Add (_indexGrp = Wpf.Expander header:"Index" content:panel isGroupBox:true isExpanded:false margin:#(0,2,0,0))
			
		btnPanel = Wpf.StackPanel orientation:#horizontal
		btnPanel.Add (Wpf.Textblock text:"Rename" vAlign:#center)
		btnPanel.Add (Wpf.Icon icon:"MdiBike" margin:#(10,4,0,4) vAlign:#center)
		_renamePanel.Add (_renameBtn = Wpf.Button content:btnPanel height:25 margin:#(0,2,0,0) click:Rename)

		#(_renamePanel, nameGetIcon, nameCloseIcon, _nameTxt, prefixGetIcon, prefixCloseIcon, _prefixTxt, suffixGetIcon, suffixCloseIcon, _suffixTxt, _renameBtn)
	),

	
	
	fn CreateForm = 
	(
		border = Wpf.Border background:#maxRollout child:_renamePanel
		dotNet.addEventHandler _renamePanel "SizeChanged" (fn x = Renamer._form.Height = Renamer._renamePanel.ActualHeight + 50)

		_form = Wpf.Window title:"Renamer" content:border width:217 location:#centerParent closed:(fn x = (Renamer._form = undefined; updateToolbarButtons()))
		_form.ShowModeless()
		dotNet.setLifetimeControl _form #dotnet
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


Renamer = renamerStc()
Renamer.Run()




