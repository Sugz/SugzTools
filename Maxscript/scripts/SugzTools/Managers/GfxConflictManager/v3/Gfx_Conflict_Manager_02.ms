/*##############################################################################
GFX Conflict Manager Struct
Version 3.02
Script By Cl�ment "Sugz" Plantec
plantec.clement@gmail.com

# Description:
This script is design to avoid 3D artist to work on the same file at the same moment and thus avoid conflict. 
Works with Tortoise SVN

# Required Components:
SugzTools Manager
Tortoise Svn Manager

# Sources:

# ToDo:
check for the conflict bewteen with autosave when performing autosave, as it's not recognize as an autoback
GetIsFileUse is obsolete, use getFile => pas si evident

Nicer message box to make more sense (Yan always complain that he doesn't know what to say yes or no...)

Create a xml library

# History:
v3.0:
	- Add user name (to display instead of the sysInfo.username)
	- Merge the MainUI
v2.0:
	- Everything rewrite from the ground up 
	- Switch to xml instead of ini
v1.0:
	- Initial release

*Use / Modify this script at your own risk !*
###############################################################################*/



struct GfxConflictManagerStc
(
	
	xmlDoc = dotNetObject "system.xml.xmlDocument",
	xmlPath = "",
	currentUser = toLower (sysInfo.username),
	currentFile = "",
	isFileIsNotice = false,
	GfxCMView = undefined,
	
	
	/* Set the GfxConflictManager xml file ############################################################################################*/
	fn SetXmlPath = 
	(
		_path = undefined
		while _path == undefined do 
		(
			_path = getOpenFileName caption:"Select the Gfx Conflict Manager INI file" filename:"GfxConflictManager.xml" types:"XML (*.xml)" 
		)
		xmlPath = _path
		setIniSetting _sgz._ini "GfxConflictManager" "xmlPath" xmlPath
		
	),
	
	
	
	/* Get the GfxConflictManager INI file ############################################################################################*/
	fn GetXmlPath = 
	(
		if xmlPath == "" then 
		(
			xmlPath = getIniSetting _sgz._ini "GfxConflictManager" "xmlPath" 
			if xmlPath == "" then SetXmlPath()
		)

		xmlPath
	),
	
	
	
	/* Save the xml file ############################################################################################*/
	fn SaveXml = 
	(
		xmlDoc.save xmlPath
	),
	
	
	
	/* Create xml and the root node then save it############################################################################################*/
	fn CreateXml = 
	(
		root = xmlDoc.createElement "TheDreamTeam"
		xmlDoc.appendChild root
		SaveXml()
		
	),
	
	
	
	/* Load xml  and define the root node ############################################################################################*/
	fn LoadXml = 
	(
		try (xmlDoc.load xmlPath)
		catch 
		(
			SetXmlPath()
			xmlDoc.load xmlPath
		)
		
		if (xmlDoc.firstChild) == undefined then CreateXml()
	),
	
	
	
	/* Update Macroscript state ############################################################################################*/
	fn UpdateMacro bool = 
	(
		isFileIsNotice = bool
		updateToolbarButtons()
		
	),

	
	
	/* Create a new xml element as child of a given xml element ############################################################################################*/
	fn AddElement parent type =
	(
		/*<Function>
		Arguments:
			<xml Element> parent : the xml element to add the new xml element to
			<String> type : the type of  the new xml element
		Return:
			<xml Element> newElem : the new xml element
		</Function>*/
		
		-- Create a new element and add it to its parent
		newElem = xmlDoc.createElement type
		parent.appendChild newElem
		
		-- Save the xml document
		SaveXml()
		
		newElem
	),
	
	
	
	/* Get children list of given xml element ############################################################################################*/
	fn GetElements parent =
	(
		/*<Function>
		Arguments:
			<xml Element> parent: the xml element to get children from
		Return:
			<Array <xml Element>> the parent's children
		</Function>*/
		
		elemList = #()
		for i = 0 to parent.childNodes.count - 1 do 
		(
			appendIfUnique elemList parent.childNodes.itemOf[i]
		)
		
		elemList
	),
	
	
	
	/*  Get user xml element, create it if necessary ############################################################################################*/
	fn GetUser =
	(
		/*<Function>
		Description:
			Get user xml element, create it if necessary
		Return:
			<xml Element> user: the xml element reprensenting current user
		</Function>*/
		
		-- Get the user element with XPath. 
		user = xmlDoc.selectSingleNode ("/" + xmlDoc.firstChild.name + "/" + currentUser)
		if user == undefined then user = AddElement xmlDoc.firstChild currentUser
		
		user
	),
	
	
	
	/* Set user xml element name as attribute ############################################################################################*/
	fn SetUserName _name =
	(
		/*<Function>
		Description:
			Set user xml element name as attribute
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		(GetUser()).setAttribute "Name" _name
		SaveXml()
	
	),
	
	
	
	/* Get the current list of user ############################################################################################*/
	fn GetOtherUsers = 
	(
		/*<Function>
		Return:
			<Array <xml Element>> the users list 
		</Function>*/
		
		return for user in (GetElements xmlDoc.firstChild) where not matchPattern (user.name) pattern:currentUser collect user

	),
	
	
	
	/* Get the list of other users used files ############################################################################################*/
	fn GetOtherFiles =
	(
		/*<Function>
		Return:
			<Array <xml Element>> fileList : liste contenant tous les fichiers des autres utsers
		</Function>*/
		
		-- Get a list of other users and get all of their file in a list
		fileList = #()
		for user in GetOtherUsers() do
		(
			for file in (GetElements user) do append fileList file
		)
		
		fileList
	),
	
	
	
	/* Check if the open file isn't already use by someone else ############################################################################################*/
	fn CheckForConflict =
	(
		/*<Function>
		Return:
			<Bool> isFree
		</Function>*/
		
		isFree = true
		
		-- Loop trought every other users files and compare to the open one
		for file in GetOtherFiles() while isFree == true do 
		(
			-- Check if relatif paths are identical
			if (file.getAttribute "Path") == _sgz._tSvn.GetRelatifPath (MaxFilePath + MaxFileName) then 
			(
				-- Format a message indacting that the file is already used, along with the other used flies
				message = StringStream ""
				userName = if file.parentNode.HasAttributes then (file.parentNode.getAttribute "Name") else (file.parentNode.name)
				format "% is working on this file, please work on another one.\nFiles also used right now :\n" userName to:message
				
				-- Get all files used without the conflicted one
				for otherFile in GetOtherFiles() where otherFile != file do 
				(
					userName = if otherFile.parentNode.HasAttributes then (otherFile.parentNode.getAttribute "Name") else (otherFile.parentNode.name)
					format " - %: %\n" userName (otherFile.getAttribute "Path") to:message
				)
				
				messageBox message title: (_sgz._tSvn.GetRelatifPath MaxFilePath + MaxFileName) beep:false
				isFree = false
			)
		)
		
		isFree
	),
	
	
	
	/* Get current file xml element in the user list ############################################################################################*/
	fn GetFile =
	(
		/*<Function>
		Return:
			<xml Element> file : the xml element representing current file in the user list if it exist, undefined otherwise
		</Function>*/
		
		file = undefined
		for elem in GetElements (GetUser()) while file == undefined do 
		(
			if elem.getAttribute "Path" == currentFile then file = elem
		)
		
		file
	),
	
	
	
	/* remove a file from the user list ############################################################################################*/
	fn RemoveFileAt index  =
	(
		/*<Function>
		Arguments:
			<xml Element> the index of the element 
		</Function>*/
		
		parent = GetUser()
		parent.removeChild parent.childNodes.itemOf[index]
		SaveXml()
	
	),

	
	
	/* Check if the open file already exist in the user list ############################################################################################*/
	fn GetIsFileUse =
	(
		/*<Function>
		Return:
			<Bool> isFileUse 
		</Function>*/
		
		-- Loop through the file contain in the list and compare to the actual max file
		isFileUse = false
		for file in GetElements (GetUser()) while not isFileUse do 
		(
			if file.getAttribute "Path" == currentFile then isFileUse = true
		)
	
		isFileUse
	),
	
	
	
	/* Add current file to the user list  ############################################################################################*/
	fn NoticeFileAsUse =
	(
		-- reload XML
		LoadXml()
		
		-- Update Macroscript and set currentFile
		UpdateMacro false
		
		-- check if the open file is part of svn
		if (_sgz._tSvn.IsSvnPath MaxFilePath) then
		(
			-- Set Current file 
			currentfile = _sgz._tSvn.GetRelatifPath (MaxFilePath + MaxFileName)
			
			-- Check that user can work on the file and isn't already on his list
			if CheckForConflict() and not GetIsFileUse() and maxFileName != "" then 
			(
				-- Ask user if he want to notice he is working on the open file
				if queryBox "Do you want to notice you are working on this file ?" title: currentfile then
				(
					-- Add the file to the user list
					file = AddElement (GetUser()) "File"
					file.setAttribute "Path" currentfile
					SaveXml()
						
					-- Update Macroscript
					 UpdateMacro true
				)
			)
		)
		
		-- Update Macroscript
		if GetIsFileUse() then UpdateMacro true
		
	),
	
	
	
	/* Ask user to commit the file on svn and update his file list ############################################################################################*/
	fn NoticeFileAsUnuse =
	(
		-- reload XML
		LoadXml()
		
		-- check if current file exist in the user list
		if GetIsFileUse() and (queryBox "Do you want to notice you are not working on this file anymore?" title:currentFile) then 
		(
			-- Lunch tortoise svn for commit
			_sgz._tSvn.ManageSvn #commit (_sgz._tSvn.GetSvnPath())
				
			-- check if the max file has been commit then rewrite ini file
			if queryBox "Did you commit the max file ?" title:currentFile then 
			(
				-- Delete the file in the xml
				file = GetFile()
				file.parentNode.removeChild file
				SaveXml()
				
				-- Update Macroscript
				UpdateMacro false
				
			)
		)
	),
	
	
	
	/* Update file before loading it to avoid conflict ############################################################################################*/
	fn UpdateFile = 
	(
		-- Get the file path of the file that will be open
		file = callbacks.notificationParam()
		
		-- Check if it's a file related to the project then update it via tortoise SVN before opening it
		if _sgz._tSvn.IsSvnPath(file[2]) then 
		(
			_sgz._tSvn.ManageSvn #update (file[2])
			messageBox "\t\tPress \"OK\" when you have finish the update\t\t\t\t\t" title:(_sgz._tSvn.GetRelatifPath (getFilenamePath file[2] + filenameFromPath file[2])) beep:false
			
		)
	),
	
	
	
	/* When user save, if the filename change, ask the user if he wants to free the old file from his list and add the new one ############################################################################################*/
	fn SaveFile = 
	(
		-- Get the file path of the file that will be open
		file = callbacks.notificationParam()
		
		-- Check for user save and avoid Edit>Hold and Autoback 
		if file[1] == 1 then 
		(
			-- Check if save on a new file
			if _sgz._tSvn.GetRelatifPath(file[2]) != currentFile then
			(
				-- Since currentFile is still the old file, it's still possible to use NoticeFileAsUnuse() 
				NoticeFileAsUnuse() 
				NoticeFileAsUse()
			)
		)
		
	),
	
	
	
	/* Register callbacks ############################################################################################*/
	fn RegisterCb _update:false _open:false _postOpen:false _save:false _exitMax:false _reset:false _new:false = 
	(
		if _update then callbacks.addScript #filePreOpenProcess "_sgz._gfxCm.UpdateFile()" id:#UpdateFileOnOpenCb												--  Update file before open it to avoid conflict
		if _open then callbacks.addScript #filePreOpen "_sgz._gfxCm.NoticeFileAsUnuse()" id:#NoticeFileAsUnuseOnOpenCb									-- Ask user if he wants to remove the current file from his list before opening a new file
		if _postOpen then callbacks.addScript #filePostOpen "_sgz._gfxCm.NoticeFileAsUse()" id:#NoticeFileAsUseOnOpenCb									-- Ask user if he wants to add the newly open file to his list
		if _save then callbacks.addScript #filePreSaveProcess "_sgz._gfxCm.SaveFile()" id:#NewFileNameOnSaveCb				 								-- When saving, if the filename change, ask the user if he wants to free the old file from his list and add the new one
		if _exitMax then callbacks.addScript #preSystemShutdown "_sgz._gfxCm.NoticeFileAsUnuse()" id:#NoticeFileAsUnuseShutdownCb				-- Ask user if he wants to remove the current file from his list before quiting Max
		if _reset then callbacks.addScript #systemPreReset "_sgz._gfxCm.NoticeFileAsUnuse()" id:#NoticeFileAsUnuseResetCb								-- Ask user if he wants to remove the current file from his list before reset Max
		if _new then callbacks.addScript #systemPreNew "_sgz._gfxCm.NoticeFileAsUnuse()" id:#NoticeFileAsUnuseNewCb										-- Ask user if he wants to remove the current file from his list before doing a new scene
	),
	
	
	
	/* Remove callbacks  ############################################################################################*/
	fn RemoveCb _update:false _open:false _postOpen:false _save:false _exitMax:false _reset:false _new:false = 
	(
		if _update then callbacks.removeScripts  #filePreOpenProcess id:#UpdateFileOnOpenCb
		if _open then callbacks.removeScripts  #filePreOpen id:#NoticeFileAsUnuseOnOpenCb
		if _postOpen then callbacks.removeScripts  #filePostOpen id:#NoticeFileAsUseOnOpenCb
		if _save then callbacks.removeScripts #filePreSaveProcess id:#NewFileNameOnSaveCb		
		if _exitMax then callbacks.removeScripts  #preSystemShutdown id:#NoticeFileAsUnuseShutdownCb
		if _reset then callbacks.removeScripts  #systemPreReset id:#NoticeFileAsUnuseResetCb
		if _new then callbacks.removeScripts  #systemPreNew id:#NoticeFileAsUnuseNewCb
		
	),
	
	
	
	/* UI ############################################################################################*/
	fn OpenUsersFilesListView = 
	(
		-- reload XML
		LoadXml()
		
		-- dialog size
		width = 50
		height = 130
		
		-- Create the ui part for a user, add the open and remove button if the user is the current one.
		fn SetUserList user width height = 
		(
			-- Get either the user name attribute or it's sysinfo name
			userName = if user.HasAttributes then (user.getAttribute "Name") else (user.name)
			str = "\tgroup \"" + userName + " :\"\n\t(\n"
			
			files = GetElements user
			for i = 1 to files.count do 
			(
				-- create the file name label and get it's size
				lbl = "\t\tlabel " + user.name + i as string + "Lbl \"" + (files[i].getAttribute "Path") + "\" align:#left\n"
				if width <=  (lbl.count * 4) then width = (lbl.count * 4)
				str += lbl
				
				-- Add buton for the current user part
				if user.name == currentUser then 
				(
					-- Open button
					str += "\n\t\tbutton " + user.name + i as string + "OpenBtn \"\" width:20 height:20 align:#right offset:[-17,-21] tooltip:\"Open file\\nRight Click: show in explorer\" "
					str += "images:#((\"$sugzIcons\Folder_16i.bmp\"), (\"$sugzIcons\Folder_16a.bmp\"), 1, 1, 1, 1, 1)\n"
					str += "\t\ton "  + user.name + i as string + "OpenBtn pressed do\n\t\t(\n"
					str += "\t\t\tif checkForSave() then loadMaxFile (_sgz._tSvn.AddSvnPath \"" + (files[i].getAttribute "Path") + "\") useFileUnits:true quiet:false\n"
					str += "\t\t\t_sgz._gfxCm.OpenUsersFilesListView()\n\t\t)\n\n"
					
					str += "\t\ton "  + user.name + i as string + "OpenBtn rightclick do\n\t\t(\n"
					str += "\t\t\tshellLaunch \"explorer.exe\" (getFilenamePath (_sgz._tSvn.AddSvnPath \"" + (files[i].getAttribute "Path") + "\"))\n\t\t)\n\n"
					
					-- Remove Button
					str += "\n\t\tbutton " + user.name + i as string + "RemoveBtn \"\" width:20 height:20 align:#right offset:[5,-25] tooltip:\"Remove from list\" "
					str+= "images:#((\"$sugzIcons\Close_16i.bmp\"), (\"$sugzIcons\Close_16a.bmp\"), 1, 1, 1, 1, 1)\n"
					str += "\t\ton "  + user.name + i as string + "RemoveBtn pressed do\n\t\t(\n"
					str += "\t\t\t_sgz._gfxCm.RemoveFileAt " + (i - 1) as string + "\n"
					str += "\t\t\t_sgz._gfxCm.OpenUsersFilesListView()\n\t\t)\n\n"
					
					height += 4
				)
				
				height += 18
			)
			
			str += "\t)\n\n"
			
			#(str, width, height)
			
		) -- End SetUserList()
		
		-- dialog declaration
		uiStr = "try(destroyDialog GfxCMUiRoll) catch()\nRollout GfxCMUiRoll \"Gfx Conflict Manager\"\n(\n"
		
		-- Create the ui part for every users, and update the dialog size
		users = join #(_sgz._gfxCm.GetUser()) (_sgz._gfxCm.GetOtherUsers())
		for user in users do 
		(
			result = SetUserList user width height
			uiStr += result[1]
			width = result[2]
			height  = result[3]
		)
		
		-- dialog position
		uiStr += "\ton GfxCMUiRoll open do\n\t(\n\t\ttry(SetDialogPos GfxCMUiRoll (execute (getIniSetting _sgz._ini \"GfxConflictManager\" \"dialogPos\"))) catch()\n\t)\n\n"
		uiStr += "\ton GfxCMUiRoll moved pos do\n\t(\n\t\tsetIniSetting _sgz._ini \"GfxConflictManager\" \"dialogPos\" (pos as string)\n\t)\n\n"
		
		-- dialog creation
		execute (uiStr += ")\ncreateDialog GfxCMUiRoll " + (width + 30) as string + " " + height as string + " style:#(#style_titlebar, #style_sysmenu, #style_resizing)")
-- 		format (uiStr += ")\ncreateDialog GfxCMUiRoll " + (width + 30) as string + " " + height as string + " style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)")
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout GfxCMView "GFX Conflict Manager" rolledup:true
	(
		label userNameLbl "User Name: " width:60 align:#left offset:[-5,0] across:2
		editText userNameTxt width:110 align:#right offset:[7,-2]
		button showListBtn "Open Users File List" width:175
		groupBox commitGrp "Ask to commit on :" width:175 height:140 offset:[-7,0]
		label allLbl "All" align:#left offset:[5, -125]
		checkBox allChk "" width:15 align:#right offset:[0,-18]
		label newSceneLbl "New Scene" align:#left offset:[5, 0]
		checkBox newSceneChk "" width:15 align:#right offset:[0,-18]
		label resetLbl "Reset" align:#left offset:[5, 0]
		checkBox resetChk "" width:15 align:#right offset:[0,-18]
		label exitMaxLbl "Close 3ds Max" align:#left offset:[5, 0]
		checkBox exitMaxChk "" width:15 align:#right offset:[0,-18]
		label saveAsLbl "Save As" align:#left offset:[5, 0]
		checkBox saveAsChk "" width:15 align:#right offset:[0,-18]
		label openFileLbl "Open" align:#left offset:[5, 0]
		checkBox openFileChk "" width:15 align:#right offset:[0,-18]
		
		/* Functions ############################################################################################*/
		/* Set the main checkbox state depending on the othe one ***************************************************************************************************************************************************************/
		fn SetAllChkState = 
		(
			/*<Function>
			Description:
				Set the main checkbox state depending on the othe one
			</Function>*/
			
			if newSceneChk.state and resetChk.state and exitMaxChk.state and saveAsChk.state and openFileChk.state 
				then allChk.state = true 
				else allChk.state = false
		)
		
		/* Events ############################################################################################*/
		on GfxCMView open do 
		(
			userNameTxt.text = getIniSetting _sgz._ini "GfxConflictManager" "userName"
			newSceneChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "newScene")
			resetChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "reset")
			exitMaxChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "exitMax")
			saveAsChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "save")
			openFileChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "open")
			
			SetAllChkState()
			
		)
		
		
		/* Set the User Name ***************************************************************************************************************************************************************/
		on userNameTxt changed txt do 
		(
			if txt != "" then 
			(
				rx = dotnetobject "System.Text.RegularExpressions.Regex" "[a-z]"
				if rx.IsMatch(txt[txt.count]) then 
				(
					_sgz._gfxCm.SetUserName txt
					setIniSetting _sgz._ini "GfxConflictManager" "userName" txt
				)
				else userNameTxt.text = trimright txt txt[txt.count]
			)
			
			-- set the sysinfo name if the user set an empty string
			else 
			(
				_sgz._gfxCm.SetUserName _sgz._gfxCm.currentUser
				setIniSetting _sgz._ini "GfxConflictManager" "userName" _sgz._gfxCm.currentUser
			)
		)
		
		/* Open the Users Files List View ***************************************************************************************************************************************************************/
		on showListBtn pressed do _sgz._gfxCm.OpenUsersFilesListView()
		
		
		/* Set all  ***************************************************************************************************************************************************************/
		on allChk changed state do 
		(
			newSceneChk.state = resetChk.state = exitMaxChk.state = saveAsChk.state = openFileChk.state = state
			if state 
				then _sgz._gfxCm.RegisterCb _new:true _reset:true _exitMax:true _save:true _open:true
				else _sgz._gfxCm.RemoveCb _new:true _reset:true _exitMax:true _save:true _open:true
			setIniSetting _sgz._ini "GfxConflictManager" "newScene" (state as string)
			setIniSetting _sgz._ini "GfxConflictManager" "reset" (state as string)
			setIniSetting _sgz._ini "GfxConflictManager" "exitMax" (state as string)
			setIniSetting _sgz._ini "GfxConflictManager" "save" (state as string)
			setIniSetting _sgz._ini "GfxConflictManager" "open" (state as string)
		)
		
		
		/* Set on New Scene ***************************************************************************************************************************************************************/
		on newSceneChk changed state do 
		(
			if state 
				then _sgz._gfxCm.RegisterCb _new:true
				else _sgz._gfxCm.RemoveCb _new:true
			setIniSetting _sgz._ini "GfxConflictManager" "newScene" (state as string)
			SetAllChkState()
		)
		
		
		/* Set on Reset Scene ***************************************************************************************************************************************************************/
		on resetChk changed state do 
		(
			if state 
				then _sgz._gfxCm.RegisterCb _reset:true
				else _sgz._gfxCm.RemoveCb _reset:true
			setIniSetting _sgz._ini "GfxConflictManager" "reset" (state as string)
			SetAllChkState()
		)
		
		
		/* Set on exit 3ds Max ***************************************************************************************************************************************************************/
		on exitMaxChk changed state do 
		(
			if state 
				then _sgz._gfxCm.RegisterCb _exitMax:true
				else _sgz._gfxCm.RemoveCb _exitMax:true
			setIniSetting _sgz._ini "GfxConflictManager" "exitMax" (state as string)
			SetAllChkState()
		)
		
		
		/* Set on Save as ***************************************************************************************************************************************************************/
		on saveAsChk changed state do 
		(
			if state 
				then _sgz._gfxCm.RegisterCb _save:true
				else _sgz._gfxCm.RemoveCb _save:true
			setIniSetting _sgz._ini "GfxConflictManager" "save" (state as string)
			SetAllChkState()
		)
		
		
		/* Set on Opne file ***************************************************************************************************************************************************************/
		on openFileChk changed state do 
		(
			if state 
				then _sgz._gfxCm.RegisterCb _open:true
				else _sgz._gfxCm.RemoveCb _open:true
			setIniSetting _sgz._ini "GfxConflictManager" "open" (state as string)
			SetAllChkState()
		)
		
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog GfxCMView) catch()
		createDialog GfxCMView 188 200 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	

	
	
	/* Initialize the struct ############################################################################################*/
	fn Run =
	(
		-- Load the xml
		if doesFileExist (GetXmlPath())
			then LoadXml()
			else CreateXml()
		
		RegisterCb \
			_update: (execute (getIniSetting _sgz._ini "GfxConflictManager" "update")) \
			_open: (execute (getIniSetting _sgz._ini "GfxConflictManager" "open")) \
			_postOpen: (execute (getIniSetting _sgz._ini "GfxConflictManager" "postOpen")) \
			_save: (execute (getIniSetting _sgz._ini "GfxConflictManager" "save")) \
			_exitMax: (execute (getIniSetting _sgz._ini "GfxConflictManager" "exitMax")) \
			_reset: (execute (getIniSetting _sgz._ini "GfxConflictManager" "reset")) \
			_new:(execute (getIniSetting _sgz._ini "GfxConflictManager" "newScene"))
		
		-- Check if the open file is part of svn
		if (_sgz._tSvn.IsSvnPath MaxFilePath) then
		(
			-- Set Current file 
			currentfile = _sgz._tSvn.GetRelatifPath (MaxFilePath + MaxFileName)
		)
	),
	
	
	
	/* GfxConflictManager Macroscript ############################################################################################*/
	GfxConflictManagerMacroscript = 
	(
		macroScript GfxConflictManager
			Category: "SugzTools"
			toolTip:"Notice open file as use or unuse"
			Icon:#("SugzTools",3)
			
		(
			global _sgz
			
			on execute do 
			(
				if _sgz != undefined then
				(
					if _sgz._gfxCm.isFileIsNotice 
						then _sgz._gfxCm.NoticeFileAsUnuse()
						else _sgz._gfxCm.NoticeFileAsUse()
				)
			)
			
			on isChecked return if _sgz != undefined 
				then _sgz._gfxCm.isFileIsNotice 
				else false

		)
	)

) -- End Struct
