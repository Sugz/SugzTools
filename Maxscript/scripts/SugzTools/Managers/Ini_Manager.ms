/*##############################################################################
SugzTools INI Manager
Version 1.00
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

#Required Components:
SugzTools Manager

#Script infos:
Create or get back default settings

Use this script at your own risk !

Scripts notes:
###############################################################################*/


struct IniManagerStc
(
	/* Main UI  *********************************************************************************************************************************/
	fn MainUi = 
	(
		setIniSetting _sgz._ini "MainUi" "startup" "true"
		setIniSetting _sgz._ini "MainUi" "dockState" "1"
		setIniSetting _sgz._ini "MainUi" "dialogPos" ""
	),
	
	
	/* Common settings *********************************************************************************************************************************/
	fn Common = 
	(
		setIniSetting _sgz._ini "Common" "promptTime" "3"
	),
	
	
	/*  Auto Save *********************************************************************************************************************************/
	fn AutoSave = 
	(
		setIniSetting _sgz._ini "AutoSave" "toolbar" "false"
		setIniSetting _sgz._ini "AutoSave" "timer" "true"
		setIniSetting _sgz._ini "AutoSave" "enabled" "false"
		setIniSetting _sgz._ini "AutoSave" "overFile" "false"
		setIniSetting _sgz._ini "AutoSave" "incremental" "false"
		setIniSetting _sgz._ini "AutoSave" "sameFolder"  "false"
		setIniSetting _sgz._ini "AutoSave" "fileLinked"  "false"
		setIniSetting _sgz._ini "AutoSave" "number" "3"
		setIniSetting _sgz._ini "AutoSave" "interval" "5.0"
		setIniSetting _sgz._ini "AutoSave" "fileName" "AutoBackup"
		setIniSetting _sgz._ini "AutoSave" "folder" (symbolicPaths.getPathValue "$autoback")
		setIniSetting _sgz._ini "AutoSave" "normalColor" "(color 0 0 100)"
		setIniSetting _sgz._ini "AutoSave" "endColor" "(color 100 0 0)"
		setIniSetting _sgz._ini "AutoSave" "endColorVal" "100"
		setIniSetting _sgz._ini "AutoSave" "blinkSpeed" "2"
		setIniSetting _sgz._ini "AutoSave" "blink" "true"
	),
	
	
	/* Auto Material *********************************************************************************************************************************/
	fn AutoMaterial = 
	(
		setIniSetting _sgz._ini "AutoMaterial" "name" "AutoMaterial"
		setIniSetting _sgz._ini "AutoMaterial" "color" "color 25 25 25"
		setIniSetting _sgz._ini "AutoMaterial" "useMaterial" "true"
		setIniSetting _sgz._ini "AutoMaterial" "useColor" "true"
		setIniSetting _sgz._ini "AutoMaterial" "useLayerColor" "false"
		setIniSetting _sgz._ini "AutoMaterial" "showChecker" "false"
		setIniSetting _sgz._ini "AutoMaterial" "checkerTiling" "10"
		setIniSetting _sgz._ini "AutoMaterial" "checkerDarkColor" "color 25 25 25"
		setIniSetting _sgz._ini "AutoMaterial" "checkerBrightColor" "color 150 150 150"
	),
	
	
	/* Gfx Conflict Manager *********************************************************************************************************************************/
	fn GfxCM = 
	(
		setIniSetting _sgz._ini "GfxConflictManager" "svnFolder" ""
		setIniSetting _sgz._ini "GfxConflictManager" "xmlPath" ""
		setIniSetting _sgz._ini "GfxConflictManager" "userName" (toLower (sysInfo.username))
		setIniSetting _sgz._ini "GfxConflictManager" "dialogPos" ""
		setIniSetting _sgz._ini "GfxConflictManager" "update" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "open" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "postOpen" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "newScene" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "reset" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "exitMax" "true"
		setIniSetting _sgz._ini "GfxConflictManager" "save" "true"
	),
	
	/* Call every function to fully create the INI *********************************************************************************************************************************/
	fn CreateIniFn = 
	(
		MainUi()
		Common()
		AutoSave()
		AutoMaterial()
		GfxCM()
	)
	
)
