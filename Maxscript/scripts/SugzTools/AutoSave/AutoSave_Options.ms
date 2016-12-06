/*##############################################################################
AutoSave Options
Version 1.3
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

Script infos:
Options for the AutoSave script

Use this script at your own risk !

Scripts notes:
###############################################################################*/



try(destroyDialog saveOptionsRoll) catch()
Rollout saveOptionsRoll "AutoSave Options"
(
	local icons = "$sugzIcons\Folder_16"
	
	
	label StartWithMaxLbl "Start with 3DS Max :" across: 2 align:#left offset:[-6,0]
	checkbox StartWithMaxChb "" align:#right offset:[17,0] tooltip:"Start with 3DS Max"
	label saveOverFileLbl "Save Over File :" across: 2 align:#left offset:[-6,0]
	checkbox saveOverFileLChb "" align:#right offset:[17,0] tooltip:"Replace current file or save incrementaly if Incremental Save is checked"
	label incrementSaveLbl "Incremental Save :" across: 2 align:#left offset:[-6,0]
	checkbox incrementSaveChb "" align:#right offset:[17,0] enabled:false tooltip:"Save incrementaly"
	label sameFolderLbl "Auto Backup in Current File Folder  :" across: 2 align:#left offset:[-6,0]
	checkbox sameFolderChb "" align:#right offset:[17,0] tooltip:"Save the backup in the same folder of the current file"
	label fileLinkedLbl "Auto Backup File Linked  :" across: 2 align:#left offset:[-6,0]
	checkbox fileLinkedChb "" align:#right offset:[17,0] tooltip:"Use the current file name in the backup name"
	
	label fileNumberLbl "Number of Autoback files :" across: 2 align:#left offset:[-6,0]
	spinner fileNumberSpn "" width:75 align:#right offset:[6,0] type:#integer range:[0,999999,0]
	label backupIntervalLbl "Backup Interval (minutes) :" across: 2 align:#left offset:[-6,0]
	spinner backupIntervalSpn "" width:75 align:#right offset:[6,0] range:[0.11,999999,5]
	label backupFileNamelbl "Auto Backup File Name :" across: 3 align:#left offset:[-6,1]
	editText backupFileNameTxt width:100 align:#right offset:[63,-1]
	button backupFolderBtn "" height: 17 width:18 images:#((icons + "i.bmp"), (icons + "a.bmp"), 1, 1, 1, 1, 1) align:#right offset:[8,-1] tooltip:"Right Click to open folder in Window"
	
	label progressBarColors "Progress Bar Colors :" across: 4 align:#left offset:[-6,1]
	colorPicker progressBarNormalClr align:#right offset:[35,0] width: 30 height:16 title:"Progress Bar Normal color"
	colorPicker progressBarEndClr align:#right offset:[8,0] width: 30 height:16 title:"Progress Bar End color"
	spinner progressBarEndSpn "" width:50 align:#right offset:[6,0] type:#integer range:[0,100,0] tooltip:"Percentage for switching to end color"
	
	label progressBarBlinkLbl "Progress Bar Blink (blinks/s) :" across:3 align:#left offset:[-6,1]
	spinner progressBarBlinkSpn "" width:50 type:#integer range:[1,10,1] align:#right offset:[65,0] tooltip:"Blinking frequency"
	checkbox progressBarBlinkChb "" align:#right offset:[19,0] tooltip:"Activate blink at the end"
	
	groupbox separatorGrp width:240 height:7 align:#center
	label revertToDefaultLbl "Revert to Default :" across: 2 align:#left offset:[-6,5]
	button revertToDefaultBtn "Default" width:67 height:18 align:#right offset:[6,3] 
	
	
	on saveOptionsRoll open do 
	(
		StartWithMaxChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "toolbar")
		saveOverFileLChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "overfile")
		if saveOverFileLChb.checked then incrementSaveChb.enabled = true
		incrementSaveChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "incremental")
		sameFolderChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "sameFolder")
		fileLinkedChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "fileLinked")
		fileNumberSpn.value = execute (getIniSetting _sgz._ini "AutoSave" "number")
		backupIntervalSpn.value = execute (getIniSetting _sgz._ini "AutoSave" "interval")
		backupFileNameTxt.text = getIniSetting _sgz._ini "AutoSave" "filename"
		backupFolderBtn.tooltip = (getIniSetting _sgz._ini "AutoSave" "folder") + "\nRight Click to open folder in Window"
		progressBarNormalClr.color = execute (getIniSetting _sgz._ini "AutoSave" "normalColor")
		progressBarEndClr.color = execute (getIniSetting _sgz._ini "AutoSave" "endColor")
		progressBarEndSpn.value = execute (getIniSetting _sgz._ini "AutoSave" "endColorVal")
		progressBarBlinkSpn.value = execute (getIniSetting _sgz._ini "AutoSave" "blinkSpeed")
		progressBarBlinkChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "blink")
	)
	
	
	on StartWithMaxChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "toolbar" (state as string)
	)
	
	
	on saveOverFileLChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "overFile" (state as string)
		if state then incrementSaveChb.enabled = true
		else
		(
			incrementSaveChb.checked = incrementSaveChb.enabled = false
			setIniSetting _sgz._ini "AutoSave" "incremental" "false"
		)
	)
	
	on incrementSaveChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "incremental" (state as string)
	)
	
	on sameFolderChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "sameFolder" (state as string)
	)
	
	on fileLinkedChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "fileLinked" (state as string)
	)
	
	
	
	on fileNumberSpn changed val do 
	(
		setIniSetting _sgz._ini "AutoSave" "number" (val as string)
	)
	
	on backupIntervalSpn changed val do 
	(
		setIniSetting _sgz._ini "AutoSave" "interval" (val as string)
	)
	
	on backupFileNameTxt changed val do 
	(
		setIniSetting _sgz._ini "AutoSave" "fileName" val
	)
	
	on backupFolderBtn pressed do 
	(
		folder = getSavePath caption:"Select the AutoBack folder"
		if folder != undefined then 
		(
			setIniSetting _sgz._ini "AutoSave" "folder" folder 
			backupFolderBtn.tooltip = folder + "\nRight Click to open folder in Window"
		)
		
	)
	
	on backupFolderBtn rightclick do 
	(
		shellLaunch "explorer.exe" (getIniSetting _sgz._ini "AutoSave" "folder")
	)
	

	on progressBarNormalClr changed clr do 
	(
		setIniSetting _sgz._ini "AutoSave" "normalColor" (clr as string)
	)
	
	on progressBarEndClr changed clr do 
	(
		setIniSetting _sgz._ini "AutoSave" "endColor" (clr as string)
	)
	
	on progressBarEndSpn changed val do 
	(
		setIniSetting _sgz._ini "AutoSave" "endColorVal" (val as string)
	)
	
	on progressBarBlinkSpn changed val do 
	(
		setIniSetting _sgz._ini "AutoSave" "blinkSpeed" (val as string)
	)
	
	on progressBarBlinkChb changed state do 
	(
		setIniSetting _sgz._ini "AutoSave" "blink" (state as string)
	)
	
	on revertToDefaultBtn pressed do 
	(
		_sgz._iniMan.AutoSaveFn()
		destroyDialog saveOptionsRoll
		fileIn "$sugzTools\AutoSave\AutoSave_Options.ms"
	)
	
)
createDialog saveOptionsRoll 250 250 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)