/*##############################################################################
SugzTools Manager
Version 1.4
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools INI Manager

# Script infos:
Script to manage SugzTools

# Sources:

# To do list:
switch all UI to struct 
make a clear difference bewteen managers (mostly UI less) and scripts
check svn manager
siwtch some modeling function from library to the script

# History:
1.4:
	- Add a debug mode
1.3:
	- Add Primitive Manager

*Use / Modify this script at your own risk !*
###############################################################################*/






global _sgz
(
	struct SugzToolsManagerStc
	(
		/* INI file, libraries and managers ############################################################################################*/
		_ini,							-- Ini file
		
		_extMxs,					-- Extend Max library
		_mod,						-- Modeling library
		_sel,						-- Selection library
		_mtl,						-- Material library
		_prop,						-- Node Properties library
-- 		_layer,						-- Layer library
		
		_iniMan, 					-- Ini Manager
		_tSvn,						-- Tortoise SVN Manager
		_gfxCm,					-- Gfx Conflict Manager 
		_addSub,				-- Attach And Detach
		_autoMtl,					-- Auto Material 
		_tmFlags,				-- Node Transform Flags
		_pMan,					-- Primitives Manager


		macroIconsCount = 5,				-- Number of icons in the strip
		
		debug = false,			-- debug mode					

		/* User Paths ############################################################################################*/
		-- Create symbolic user path and directories
		fn SetUserPaths =
		(
			-- Create symbolic user path
			if not (symbolicPaths.isUserPathName "$sugzTools") then 
				symbolicPaths.addUserPath "$sugzTools" (symbolicPaths.getPathValue "$userscripts" + "\\SugzTools")

			if not (symbolicPaths.isUserPathName "$sugzIcons") then 
				symbolicPaths.addUserPath "$sugzIcons" (symbolicPaths.getPathValue "$usericons" + "\\SugzTools")
				
			-- Create directories
			if not (doesFileExist "$sugzTools") then makeDir "$sugzTools"
			if not (doesFileExist "$sugzIcons") then makeDir "$sugzIcons"
			
		),
		
		-- Remove symbolic user path and directories
		fn RemoveUserPaths directories:false = 
		(
			if directories then 
			(
				_extMxs.DeleteFolder (symbolicPaths.getUserPathValue "$sugzTools" )
				_extMxs.DeleteFolder (symbolicPaths.getUserPathValue "$sugzIcons" )
			)
			
			if (symbolicPaths.isUserPathName "$sugzTools") then symbolicPaths.removeUserPath "$sugzTools"
			if (symbolicPaths.isUserPathName "$sugzIcons") then symbolicPaths.removeUserPath "$sugzIcons"
			
		),


		/* Structs ############################################################################################*/
		fn DefineStructs = 
		(
			/* Libs ***************************************************************************************************************************************************************/
			if doesFileExist "$userscripts\SugzTools\Libs\Extend_Maxscript_Lib.ms" do include "$userscripts\SugzTools\Libs\Extend_Maxscript_Lib.ms"						-- Extend Max library
			_extMxs = ExtendMxsLibraryStc()
			if doesFileExist "$userscripts\SugzTools\Libs\Modeling_Lib.ms" do include "$userscripts\SugzTools\Libs\Modeling_Lib.ms"													-- Modeling library
			_mod = ModelingLibraryStc()
			if doesFileExist "$userscripts\SugzTools\Libs\Selection_Lib.ms" do include "$userscripts\SugzTools\Libs\Selection_Lib.ms"			 										-- Selection library
			_sel = SelectionLibraryStc()
			if doesFileExist "$userscripts\SugzTools\Libs\Material_Lib.ms" do include "$userscripts\SugzTools\Libs\Material_Lib.ms"														-- Material library
			_mtl = MaterialLibraryStc()
			if doesFileExist "$userscripts\SugzTools\Libs\Node_Properties_Lib.ms" do include "$userscripts\SugzTools\Libs\Node_Properties_Lib.ms"							-- Node Properties library
			_prop = NodePropertiesStc()
-- 			if doesFileExist "$userscripts\SugzTools\Libs\Layer_Lib.ms" do include "$userscripts\SugzTools\Libs\Layer_Lib.ms"
-- 			_layer = LayerLibraryStc()
			
			
			/* Scripts ***************************************************************************************************************************************************************/
			if doesFileExist "$userscripts\SugzTools\Managers\Ini_Manager.ms" do include "$userscripts\SugzTools\Managers\Ini_Manager.ms"												-- Ini Manager
			_iniMan = IniManagerStc()
			if doesFileExist "$userscripts\SugzTools\Managers\Tortoise_Svn_Manager.ms" do include "$userscripts\SugzTools\Managers\Tortoise_Svn_Manager.ms"			-- Tortoise SVN Manager
			_tSvn = TortoiseSvnManagerStc()
			if doesFileExist "$userscripts\SugzTools\Managers\Gfx_Conflict_Manager.ms" do include "$userscripts\SugzTools\Managers\Gfx_Conflict_Manager.ms"			-- Gfx Conflict Manager
			_gfxCm = GfxConflictManagerStc()
			if doesFileExist "$userscripts\SugzTools\Scripts\Attach_And_Detach.ms" do include "$userscripts\SugzTools\Scripts\Attach_And_Detach.ms"							-- Attach and Detach
			_addSub = AttachDetachStc()
			if doesFileExist "$userscripts\SugzTools\Scripts\AutoMaterial.ms" then include "$userscripts\SugzTools\Scripts\AutoMaterial.ms"													-- Auto Material 
			_autoMtl = AutoMaterialStc()
			if doesFileExist "$userscripts\SugzTools\Scripts\Node_Transform_Flags.ms" do include "$userscripts\SugzTools\Scripts\Node_Transform_Flags.ms"				-- Node Transform Flags
			_tmFlags = NodeTmFlagsStc()
			if doesFileExist "$userscripts\SugzTools\Managers\Primitives_Manager.ms" do include "$userscripts\SugzTools\Managers\Primitives_Manager.ms"					-- Primitives Manager
			_pMan = PrimitivesManagerStc()
			
			
		),
		
		
		/* Ini File  ############################################################################################*/
		fn SetIni =
		(
			-- get user document folder
			sysEnv = dotNetClass "System.Environment"
			speFolder = dotNetClass "System.Environment+specialFolder"
			_ini = (sysEnv.GetFolderPath speFolder.myDocuments) + @"\3dsMax\SugzTools\SugzTools.ini"
			
			-- If the ini doesn't exit, create directory and ini
			if not (doesFileExist _ini) then 
			(
				makeDir ((sysEnv.GetFolderPath speFolder.myDocuments) + @"\3dsMax\SugzTools")
				_iniMan.CreateIniFn()
			)
		),
		
		
		
		/* UI ############################################################################################*/
		fn MainView = 
		(
			if doesFileExist "$sugzTools\MainUI\Main.ms" do fileIn "$sugzTools\MainUI\Main.ms"
		),
		
		
		
		/* Macroscripts ############################################################################################*/
		fn InstallMacros = 
		(
			for macro in (getFiles "$sugzTools\Macroscripts\*") do fileIn macro
		),
		
		
		
		/* Startup  ############################################################################################*/
		fn StartupScripts =
		(
			-- AutoSave toolbar
			if execute (getIniSetting _sgz._ini "AutoSave" "toolbar") and (doesFileExist file = "$sugzTools\AutoSave\AutoSave_Toolbar.ms") do fileIn file--"$sugzTools\AutoSave\AutoSave_Toolbar.ms"
		),
		
		
		/* Load customisation files ############################################################################################*/
		fn CustomizeUI = 
		(
			/*<Function>
			Description:
			Arguments:
			Return:
			Infos:
			</Function>*/
			
			for file in (getFiles "$userscripts\SugzTools\CustomizeUI\*") do 
			(
-- 				maxOps.loadCUIFile file
				case (getFilenameType file) of
				(
					-- Load menu files
					".mnux": menuMan.loadMenuFile file
					".mnu": menuMan.loadMenuFile file
					
					-- Load color file
					".clrx": colorMan.loadColorFile file
				)
			)
			
		),
		
		
		/* Initialize and run SugzTools ############################################################################################*/
		fn Run = 
		(
			exitCode = 0
			try (SetUserPaths()) catch(exitCode = "SetUserPaths() raised an issue...")
			try (DefineStructs()) catch(exitCode = "DefineStructs() raised an issue...")
			try (SetIni()) catch(exitCode = "SetIni() raised an issue...\n")
			try (InstallMacros()) catch(exitCode = "InstallMacros() raised an issue...")
			try (StartupScripts()) catch(exitCode = "StartupScripts() raised an issue...")
			try (CustomizeUI()) catch(exitCode = "CustomizeUI() raised an issue...")
				
			if exitCode == 0 then
			(
				_tSvn.GetSvnPath()
				_gfxCm.Run()
				_autoMtl.Run()
				_pMan.RegisterCallbacks()
				if execute (getIniSetting _sgz._ini "MainUi" "startup") then MainView() 						-- Main UI
				format "SugzTools succesfully loaded :)\n"
			)
			
			else format "%\nSugzTools failed to load :(\n" exitCode
		),

		
		
		/* Macroscript ############################################################################################*/
		macro = 
		(
			macroScript SugzToolsUI 
				Category:"SugzTools" 
				toolTip:"Run SugzTools and load the MainView" 
				Icon:#("SugzTools", 1)
			(
				global _sgz
				on execute do 
				(
					if SgzRoll != undefined and SgzRoll.open then
					(
						cui.UnRegisterDialogBar SgzRoll 
						destroyDialog SgzRoll
						SgzRoll = undefined
					)
					else 
					(
						if doesFileExist "$userScripts\SugzTools\Managers\SugzTools_Manager.ms" do fileIn "$userScripts\SugzTools\Managers\SugzTools_Manager.ms"
						if _sgz != undefined then _sgz.MainView()
					)
					
				)
				
				on isChecked return if SgzRoll != undefined and SgzRoll.open 
					then true
					else false
			)
		),
		
		
		
		/* Macro to set sugztools in debug mode ############################################################################################*/
		macroDebug = 
		(
			macroScript SugzToolsDebugMode 
				Category:"SugzTools" 
				toolTip:"Toggle the SugzTools debug mode" 
				Icon:#("Maxscript", 2)
			(
				global _sgz
				on execute do 
				(
					if _sgz == undefined then fileIn "$userScripts\Startup\SugzTools_Startup.ms"
					_sgz.debug = not _sgz.debug
				)
				
				on isChecked return if _sgz != undefined then _sgz.debug
			)
		)
		
		
	)-- End Struct


	_sgz = SugzToolsManagerStc()
	_sgz.Run()

)







