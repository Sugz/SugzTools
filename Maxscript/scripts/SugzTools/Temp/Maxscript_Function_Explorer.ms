/*##############################################################################
SugzTools Documentation 
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !
###############################################################################*/



try(destroyDialog ::LibraryExplorerView) catch()
Rollout LibraryExplorerView "Library Explorer"
(
	
	local files = undefined 
	local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
	
	--Create the dotNet treeView control
	dotNetControl fnExplorerTV "treeView" width:200 height:340 align:#left offset:[-7,0]
	dotNetControl argumentsTxt "textBox" width:530 height:340 align:#right offset:[7,-345]
	
	
	fn setControlsLook = 
	(
		fnExplorerTV.BackColor = dnColor.FromArgb 255 86 86 86
		argumentsTxt.BackColor = dnColor.FromArgb 255 86 86 86
		
		fnExplorerTV.ForeColor = dnColor.FromArgb 255 225 225 225
		argumentsTxt.ForeColor = dnColor.FromArgb 255 225 225 225
		
		fnExplorerTV.BorderStyle = argumentsTxt.BorderStyle.FixedSingle;
		argumentsTxt.BorderStyle = argumentsTxt.BorderStyle.FixedSingle;
		
		argumentsTxt.Multiline = true
		argumentsTxt.ReadOnly = true
	)
	

	
	fn ParseLib file = 
	(
		ms = openFile file
		readline ms
		
		_name = trimLeft (readline ms) "SugzTools"
		if isSpace _name then _name = trimLeft _name " "

		-- script infos
		_line = infos = ""
		while not (_line[1] == "*") do 
		(
			_line = readline ms
			if not (_line[1] == "*") then infos += _line + "\r\n"
		)
		
		-- functions 
		functions = #()
		while not eof ms do 
		(
			_line = trimLeft (readline ms)
			_line = filterString _line " "
			if _line[1] == "fn" then append functions _line[2]
			
		)
		
		

		flush ms 
		close ms 
		free ms
		
		#(_name, infos, functions)
	)
	
	
	fn ParseFunction file _fn = 
	(
		infos = ""
		ms = openFile file
		
		descriptifFound = descriptifEnd = false
		
		-- avoid to pick the one in "# History"
		skipToString ms ("fn " + _fn)
		
		
		
		
		index = filePos ms
		seek ms (index - _fn.count + 1)
		infos = trimRight (readLine ms) " = " + "\r\n\r\n"
		
		-- go after the begining of the description
		while not descriptifFound do 
		(
			if trimLeft (readline ms) == "/*<Function>" then descriptifFound = true
		)

		-- read every line of the descritpion, add new line for new description categories (return, further infos) and stop when find the end of description
		while not descriptifEnd do 
		(
			_line = trimLeft (readline ms)
			if _line == "</Function>*/" then descriptifEnd = true
			else 
			(
				if _line == "Arguments:" or _line == "Return:" or _line == "Further Infos:" then infos += "\r\n"
				infos += _line + "\r\n"
			)
		)
		
		
		flush ms 
		close ms 
		free ms
		
		infos
	)
	
	
	fn AddFile file = 
	(
		parsedFile = ParseLib file
		
		fileNode = dotNetObject "System.Windows.Forms.TreeNode" parsedFile[1]
		
		for functionName in parsedFile[3] do fileNode.nodes.add (dotNetObject "System.Windows.Forms.TreeNode" functionName)
		
		fnExplorerTV.nodes.add fileNode
		
	)
	
	
	fn GetLibs = 
	(
		files = getFiles "$userscripts\SugzTools\Libs\*.ms"
		for file in files do AddFile file
	)
	
	
	/* Events ############################################################################################*/
	on LibraryExplorerView open do 
	(
		setControlsLook()
		GetLibs()
	)
	
	
	on fnExplorerTV AfterSelect s e do 
	(
		_node = s.SelectedNode
		if _node != undefined then 
		(
			if _node.parent == undefined then
			(
				infos = ParseLib files[_node.Index + 1]
				argumentsTxt.text = infos[1] + ":\r\n" + infos[2]
			)
			else 
			(
				try (argumentsTxt.text  = ParseFunction files[_node.parent.Index + 1] _node.text) catch(argumentsTxt.text = "")
			)
		)
		
		
		
	)
	
	
	on argumentsTxt TextChanged s e do 
	(
		-- Get the rendered size of the text and check if its size is superior to the size of the textbox
		textBoxRect = (dotNetClass "TextRenderer").MeasureText argumentsTxt.text argumentsTxt.font
		
		Hsb = argumentsTxt.ClientSize.Height < textBoxRect.Height + argumentsTxt.Font.Size;  
		
		argumentsTxt.ScrollBars = if Hsb then argumentsTxt.ScrollBars.Vertical else argumentsTxt.ScrollBars.None
		
	)
	
	
	
	
)
createDialog LibraryExplorerView 750 350 --style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)