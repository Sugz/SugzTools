/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:

# Script infos:

# Sources:

# To do list:
liste des objets fichier text
doublon, espace, nom vides
faute de frappe

# History:

*Use / Modify this script at your own risk !*

MyCustomObjs = for obj in selection where (classOf obj != XRefObject) collect obj
qSort MyCustomObjs compareNames
print MyCustomObjs
###############################################################################*/



try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	/* Variables ############################################################################################*/
	-- get the list of objects that have an issue in their name
	local namesIssues = #()
	local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
	local forbidenChars = #(" ","ä","ü","ö","!","§","$","%","&","=","?","ß","´","`","*","~","'",",","<",">","|","@","~","°","^","/","\ ","}","{","[","]","ê","è","é","â","á","à","ô","ó","ò","û","ú","ù")
	
	
	/* UI ############################################################################################*/
	listbox nameIssuesLbx "Objects with name issues:" height:25
	dotNetControl renameTxt "RichTextBox" width:245 height:20 align:#left
	button renameBtn "OK" width:25 height:22 align:#right offset:[0,-26]
	groupbox separatorGrp height:7 align:#center offset:[0,5]
	button exportObjectsNamesBtn "Export Names" offset:[0,10]
	
	
	/* Functions ############################################################################################*/
	
	fn compareNames obj1 obj2 = stricmp obj1.name obj2.name
	fn compareString str1 str2 = stricmp str1 str2	
		
	
	/* Set textbox colors ***************************************************************************************************************************************************************/
	fn SetRenameTxtText str =
	(
		-- set the new text and cancel the selection backcolor
		renameTxt.Text = str
		renameTxt.SelectionStart = 0;
		renameTxt.SelectionLength = str.count;
		renameTxt.SelectionBackColor = dnColor.FromArgb 255 86 86 86
		
		-- Changed the selection backcolor of all the ilegal charaters
		for i = 1 to renameTxt.Text.Count do
		(
			for char in forbidenChars do 
			(
				if renameTxt.Text[i] == char do 
				(
					renameTxt.SelectionStart = i - 1;
					renameTxt.SelectionLength = 1;
					renameTxt.SelectionBackColor = dnColor.FromArgb 255 255 0 0
				)
			)
		)
	)
		
	
	/* Check if name doesn't have issues ***************************************************************************************************************************************************************/
	fn CheckName obj = 
	(
		-- objects with same names
		sameName = for o in objects where not obj.layer.ishidden and o.name == obj.name collect o
		if sameName.count != 1 then appendIfUnique namesIssues obj
			
		-- objects with illegal characters
		for char in forbidenChars do if matchPattern obj.name pattern:char then appendIfUnique namesIssues obj
		
			
		-- object without name
		if obj.name == "" do appendIfUnique namesIssues obj
	)
	
	
	/* Fill the listbox with objects that have a name issue ***************************************************************************************************************************************************************/
	fn GetNameIssues = 
	(
		namesIssues = #()
		
		-- Filter objects which layer is hidden
		for obj in objects where not obj.layer.ishidden do CheckName obj
		
		-- sort the objects alphabetically
		qsort namesIssues compareNames
		
		-- Fill the list with objects name
		names = #()
		for obj in namesIssues do 
		(
			-- for obj that don't have name, replace by unnamed
			_name = if obj.name == "" then "- unnamed -" else obj.name
			append names _name
		)
		nameIssuesLbx.items = names
		SetRenameTxtText (nameIssuesLbx.selected)
	)
	
	
	
	/* Events ############################################################################################*/
	on testRoll open do
	(
		GetNameIssues()
		renameTxt.backcolor = dnColor.FromArgb 255 86 86 86								-- Define the background as the standard 3ds max textbox
		renameTxt.forecolor = dnColor.FromArgb 255 225 225 225								-- Define the background as the standard 3ds max textbox
	)
	
	
	/* On selecting an item in the list, select the corresponding object and put its name in the rename textbox***************************************************************************************************************************************************************/
	on nameIssuesLbx selected item do 
	(
		select namesIssues[item]
		SetRenameTxtText (nameIssuesLbx.selected)
	)
	
	
	/* Prevent user to enter an illegal character in the rename textbox ***************************************************************************************************************************************************************/
	on renameTxt KeyPress pressedKey do 
	(
		for char in forbidenChars do 
		(
			if pressedKey.KeyChar == char then 
				pressedKey.Handled = true
			else renameTxt.SelectionBackColor = dnColor.FromArgb 255 86 86 86	
		)
	)
	
	
	/* Rename the object and refresh the list ***************************************************************************************************************************************************************/
	on renameBtn pressed do
	(
		namesIssues[nameIssuesLbx.selection].name = renameTxt.text
		GetNameIssues()
	)
	
	
	/* Export the list of exported objects' name ***************************************************************************************************************************************************************/
	on exportObjectsNamesBtn pressed do
	(
		--set the text file, delete old one if necessary
		txtName = maxFilePath + getFilenameFile maxFileName + ".txt"
		if doesFileExist txtName then deleteFile txtName
		txtFile = createfile txtName
		
		-- Create a sort list of exported objects' name and formated them in the text file
		exportObjs = for obj in objects where not obj.layer.ishidden collect obj
		qSort exportObjs compareNames
		for obj in exportObjs do format "%\n" obj.name to:txtFile
			
		close txtFile
	)
	
)
createDialog testRoll 300 440 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)