/*##############################################################################
SugzTools Tortoise Svn Manager
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager

# Script infos:
This script provide some functionality to use Tortoise SVN inside 3ds Max

# Sources:

# To do list:
DOSCommand "svn status -u --xml  \"D:\Travail\SVN3D\Scripts\Test\cube.max\" > \"D:/log.xml\""
need to make a modal window while checking if file need to be updated to avoid the mostly unecessary message box pressed ok when there is no update...

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/




struct TortoiseSvnManagerStc
(
	
	svnPath = "",
	
	/* Set the SVN project path ############################################################################################*/
	fn SetSvnPath = 
	(		
		folder = undefined
		while folder == undefined do 
		(
			folder = getSavePath caption:"Select the SVN root folder"
		)
		svnPath = folder
		setIniSetting _sgz._ini "GfxConflictManager" "svnFolder" svnPath
	),
	
	
	/* Get the SVN project path ############################################################################################*/
	fn GetSvnPath = 
	(
		if svnPath == "" then
		(
			svnPath = getIniSetting _sgz._ini "GfxConflictManager" "svnFolder"
			if svnPath == "" then SetSvnPath()
		)
		
		svnPath
	),
	
	
	/* Check if the path is the SVN project path ############################################################################################*/
	fn IsSvnPath _path = 
	(
		bool = false
		if matchPattern  _path pattern:(svnPath + "*") then bool = true
		
		bool
	),
	
	
	/* Get the MaxFilePath without the path of the SVN project path  ############################################################################################*/
	fn GetRelatifPath _path =
	(
		/*<Function>
		Arguments:
			<String> _path : The path to be truncated
		Return:
			<String> MaxFilePath without without the svnPath part
		</Function>*/
		
		index = (svnPath).count + 2
		return (substring _path index -1)
	
	),
	
	
	/* TO FILL ############################################################################################*/
	fn AddSvnPath _path =
	(
		/*<Function>
		Arguments:
			<String> _path : The truncated path 
		Return:
			<String> svnPath + the truncated path 
		</Function>*/
		
		return (svnPath + "\\" + _path)
	
	),
	

	/* Tortoise SVN management ############################################################################################*/
	fn ManageSvn cmd _path =
	(
		case cmd of
		(
			#add : cmd = "/command:add "
			#update : cmd = "/command:update "
			#commit : cmd = "/command:commit "
		)
		
		svn = @"C:\Program Files\TortoiseSVN\bin\TortoiseProc.exe"
		ShellLaunch svn (cmd + "/path:\"" + _path + "\"")

	),
	
	
	/* Tortoise SVN Macroscripts ############################################################################################*/
	TortoiseSvnAdd = 
	(
		macroScript TortoiseSvnAdd 
			Category:"SugzTools" 
			toolTip:"Tortoise SVN Add" 
			Icon:#("SugzTools", 4)
		(
			on execute do 
			(
				if _sgz._tSvn != undefined then 
				(
					_sgz._tSvn.GetSvnPath()
					_sgz._tSvn.ManageSvn #add _sgz._tSvn.svnPath
				)
			)
		)
	),
	
	TortoiseSvnCommit = 
	(
		macroScript TortoiseSvnCommit 
			Category:"SugzTools" 
			toolTip:"Tortoise SVN Commit" 
			Icon:#("SugzTools",5)
		(
			on execute do 
			(
				if _sgz._tSvn != undefined then 
				(
					_sgz._tSvn.GetSvnPath()
					_sgz._tSvn.ManageSvn #commit _sgz._tSvn.svnPath
				)
			)
		)
	),

	TortoiseSvnUpdate = 
	(
		macroScript TortoiseSvnUpdate 
			Category:"SugzTools" 
			toolTip:"Tortoise SVN Update" 
			Icon:#("SugzTools",6)	
		(
			on execute do 
			(
				if _sgz._tSvn != undefined then 
				(
					_sgz._tSvn.GetSvnPath()
					_sgz._tSvn.ManageSvn #update _sgz._tSvn.svnPath
				)
			)
		)
	)
	

) -- End Struct



