/*##############################################################################
SugzTools Code Documentation 
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Script design to get all the documentation from sugztools code

# Required Components:

# Sources:

# To do list:

# History:
1.0:
 - Initial support for the libraries

*Use / Modify this script at your own risk !
###############################################################################*/

(
	global _doc
	struct CodeDocStc
	(
		
		CodeDocView = undefined,
		
		scripts = undefined ,
		dnColor = dotNetClass "System.Drawing.Color", -- dotNetClass to define colors
		
		
		
		/* Parse a script to retreive the name, infos and functions ############################################################################################*/
		fn ParseScript script = 
		(
			/*<Function>
			Description:
				Parse a script to retreive the name, infos and functions
			Arguments:
				<File> script: the script to parse
			Return:
				<Array <String>>  #(_name, infos, functions), the script name, infos and the functions it contain
			</Function>*/
			
			
			ms = openFile script
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
		),
		
		
		
		/* Parse a given function from a script ############################################################################################*/
		fn ParseFunction script _fn = 
		(
			/*<Function>
			Description:
				Parse a given function from a script
			Arguments:
				<File> script: the script to parse
				<String> _fn: the function to parse
			Return:
				<String> infos: the function infos (function declaration, description, arguments, return and further infos)
			</Function>*/
			
			infos = ""
			ms = openFile script
			
			descriptifFound = descriptifEnd = false
			
			-- Avoid to pick the one in "# History"
			skipToString ms ("fn " + _fn)
			
			-- Get the full function name and arguments
			index = filePos ms
			seek ms (index - _fn.count + 1)
			infos = trimRight (readLine ms) " = " + "\r\n\r\n"
			
			-- Go after the begining of the description
			while not eof ms do print (trimLeft (readline ms))
-- 			while not descriptifFound do 
-- 			(
-- 				if trimLeft (readline ms) == "/*<Function>" then descriptifFound = true
-- 			)

			
			-- Read every line of the descritpion, add new line for new description categories (arguments, return, further infos) and stop when find the end of description
-- 			while not descriptifEnd do 
-- 			(
-- 				_line = trimLeft (readline ms)
-- 				if _line == "</Function>*/" then descriptifEnd = true
-- 				else 
-- 				(
-- 					if _line == "Arguments:" or _line == "Return:" or _line == "Further Infos:" then infos += "\r\n"
-- 					infos += _line + "\r\n"
-- 				)
-- 			)
			
			flush ms 
			close ms 
			free ms
			
			infos
		),
		
		
		
		/* View ############################################################################################*/
		fn GetView = 
		(
			Rollout CodeDocView "SugzTools Code Documentation"
			(
				
				dotNetControl fnExplorerTV "treeView" width:190 height:340 align:#left offset:[-7,0]
				dotNetControl argumentsTxt "textBox" width:425 height:340 align:#right offset:[7,-345]
				
				
				/* Functions ############################################################################################*/
				/* Set the treeview and textbox look ***************************************************************************************************************************************************************/
				fn SetControlsLook = 
				(
					fnExplorerTV.BackColor = dnColor.FromArgb 255 86 86 86
					argumentsTxt.BackColor = dnColor.FromArgb 255 68 68 68
					
					fnExplorerTV.ForeColor = dnColor.FromArgb 255 225 225 225
					argumentsTxt.ForeColor = dnColor.FromArgb 255 225 225 225
					
					fnExplorerTV.BorderStyle = argumentsTxt.BorderStyle.None;
					argumentsTxt.BorderStyle = argumentsTxt.BorderStyle.None;
					
					argumentsTxt.Multiline = true
					argumentsTxt.ReadOnly = true
				)
				
				
				
				/* Add a treeNode ***************************************************************************************************************************************************************/
				fn GetTreeNode name tag = 
				(
					treeNode = dotNetObject "TreeNode" name
					treeNode.tag = tag
					
					treeNode
				)
				
				
				
				/* Add a script as tree node and its functions as subtree node ***************************************************************************************************************************************************************/
				fn AddScriptTreeNode script parent = 
				(
					/*<Function>
					Description:
						Add a script as tree node and its functions as subtree node
					Arguments:
						<File> script: the script to parse
					</Function>*/
					
					
					parsedFile = ParseScript script
					
					scriptNode = dotNetObject "TreeNode" parsedFile[1]
					scriptNode.tag = "script"
					
					for functionName in parsedFile[3] do scriptNode.nodes.add (GetTreeNode functionName "function")
					
					parent.nodes.add scriptNode
					
				)
				
				
				/* Get the libraries ***************************************************************************************************************************************************************/
				fn GetScripts parent = 
				(
					/*<Function>
					Description:
						Get the libraries
					</Function>*/
					
					scripts = getFiles ("$userscripts\SugzTools\\" + parent.text + "\*.ms")
					for script in scripts do 
					(
						try(AddScriptTreeNode script parent) catch()
					)
				)
				
				
				
				/* Set the rootnodes (libraries, manager, scripts) ***************************************************************************************************************************************************************/
				fn SetTreeView = 
				(
-- 					roots = #("Libs", "Managers", "Scripts")
					roots = #("Libs")
					for root in roots do 
					(
						treeNode = GetTreeNode root "root"
						GetScripts treeNode
						fnExplorerTV.nodes.add treeNode
					)
				)
				
				
				/* Check if the textbox need scrollbar ***************************************************************************************************************************************************************/
				fn CheckForScrollbar =
				(
					/*<Function>
					Description:
						Check if the textbox need scrollbar 
					Arguments:
					Return:
					Further Infos:
					</Function>*/
					
					-- Get the rendered size of the text and check if its size is superior to the size of the textbox
					textBoxRect = (dotNetClass "TextRenderer").MeasureText argumentsTxt.text argumentsTxt.font
					
					Hsb = argumentsTxt.ClientSize.Height < textBoxRect.Height + argumentsTxt.Font.Size;  
					
					argumentsTxt.ScrollBars = if Hsb then argumentsTxt.ScrollBars.Vertical else argumentsTxt.ScrollBars.None
				
				)
				
				
				
				/* Events ############################################################################################*/
				on CodeDocView open do 
				(
					SetControlsLook()
					SetTreeView()
				)
				
				
				
				on CodeDocView resized size do
				(
					argumentsTxt.width = size[1] - 190
					fnExplorerTV.height = argumentsTxt.height = size[2] - 10
					CheckForScrollbar()
				)
				
				
				
				/* Set the textbox text  with the treenode infos (script or function) ***************************************************************************************************************************************************************/
				on fnExplorerTV AfterSelect s e do 
				(
					treeNode = s.SelectedNode
					if treeNode != undefined then 
					(
						case treeNode.tag of
						(
							("script"):
							(
								infos = _doc.ParseScript _doc.scripts[treeNode.Index + 1]
								argumentsTxt.text = infos[1] + ":\r\n" + infos[2]
							)
							
							("function"): argumentsTxt.text  = _doc.ParseFunction _doc.scripts[treeNode.parent.Index + 1] treeNode.text
							default:()
						)
					)
				)
				
				
				/* Check if the textbox need scrollbar ***************************************************************************************************************************************************************/
				on argumentsTxt TextChanged s e do CheckForScrollbar()
				
			)
		),
		
		
		/* Create a dialog and add the view inside ############################################################################################*/
		fn CreateView = 
		(
			GetView()
			try(destroyDialog CodeDocView) catch()
			createDialog CodeDocView 640 350 style:#(#style_titlebar, #style_sysmenu, #style_resizing)
		),
		
		
		/* Initialize CodeDoc ############################################################################################*/
		fn Run = 
		(
			CreateView()
		),
		
		
		/* Macroscript declaration ############################################################################################*/
		macro =
		(
			macroScript CodeDoc
				category:"SugzTools"
				toolTip:"Code Documentation "
				Icon:#("SugzTools",8)
			(
				global _doc
				on execute do 
				(
					if _doc == undefined then fileIn "$userScripts\SugzTools\Scripts\Code_Documentation.ms"
					_doc.Run()
				)
				
			)
		)
		
	)

	_doc = CodeDocStc()
)