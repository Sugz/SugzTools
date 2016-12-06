/*##############################################################################
AutoSave 
Version 1.4
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

Script infos:
This script is design to fully replace the AutoSave feature

Use this script at your own risk !

Scripts notes:
###############################################################################*/


local autoBackVersion = 1
local nextSave = 0
local pbValue = 0.0
local percent = 0.0


timer autoSaveClock interval:1000 active:false
checkbutton enableTimer "" width:10 across:6 align:#left offset:[-6,0] tooltip:"Enable Timer"
checkbutton autoSaveChb "AS" width:25 offset:[-22,0] tooltip:"Auto Save" enabled:false
button saveBtn "Save" width:83 offset:[-19,0] tooltip:"Click to save\nRight Click to reset timer"
button incrementalSaveBtn "+" width:21 offset:[28,0] tooltip:"Incremental save"
button saveAsBtn "As" width:21 offset:[25,0] tooltip:"Save As...\nRight Click: Save Selected As..."
button optionBtn "O" width:21 offset:[16,0] tooltip:"Options"
progressBar autoSavePb "" width:175 height:10 offset:[-6, -2] enabled:true value:0 color:(color 30 10 190)


-- Reset timer interval, nextSave, percent and pbValue
fn ResetFn = 
(
	autoSaveClock.interval = 1000
	nextSave = execute (getIniSetting _sgz._ini "AutoSave" "interval") * 60
	percent = 100.0 / nextSave
	pbValue = 0.0
)

-- Set the timer on the save button and the progress bar
fn SetTimerFn = 
(
	-- Set the timer
	sec = (mod nextSave 60) as integer
	min = nextSave as integer / 60
	
	if nextSave == 0 then saveBtn.text = "Save"
	else if min > 60 then 
	(
		hour = min / 60
		min = (mod min 60) as integer
		saveBtn.text = hour as string + "h " + min as string + "m " + sec  as string + "s"
	)
	else saveBtn.text = min as string + "m " + sec  as string + "s"
	
	
	-- Set the progress bar
	autoSavePb.value = pbValue - (mod pbValue 1) as integer
	

	-- End color
	if autoSavePb.value >= execute (getIniSetting _sgz._ini "AutoSave" "endColorVal") then
	(
		-- Blink
		if execute (getIniSetting _sgz._ini "AutoSave" "blink") then 
		(
			if autoSavePb.color == color 68 68 68 then
				autoSavePb.color = execute (getIniSetting _sgz._ini "AutoSave" "endColor")
			else autoSavePb.color = color 68 68 68
		)
		else autoSavePb.color = execute (getIniSetting _sgz._ini "AutoSave" "endColor")
		
	)
	
	-- Normal color
	else autoSavePb.color = execute (getIniSetting _sgz._ini "AutoSave" "normalColor")
)

-- Display saving message
fn DisplaySavingTextFn filePath = 
(
	_sgz._extMxs.Prompt ("Saving " + filePath)
)


on AutoSaveRoll open do 
(
	-- Initialize Auto Backup folder on first use
	if getIniSetting _sgz._ini "AutoSave" "folder" == "" then setIniSetting _sgz._ini "AutoSave" "folder" (symbolicPaths.getPathValue "$autoback")
			
	-- Initialize UI and deactivate the standart autosave
	if execute (getIniSetting _sgz._ini "AutoSave" "timer") then 
	(
		enableTimer.checked = autoSaveChb.enabled = autoSaveClock.active = true
		autoSaveChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "enabled")
		ResetFn()
		SetTimerFn()
	)
	
	autosave.Enable = false
)

on enableTimer changed state do 
(
	setIniSetting _sgz._ini "AutoSave" "timer" (state as string)
	
	if state then 
	(
		autoSaveChb.enabled = autoSaveClock.active = true
		autoSaveChb.checked = execute (getIniSetting _sgz._ini "AutoSave" "enabled")
		ResetFn()
		SetTimerFn()
	)
	else 
	(
		autoSaveChb.checked = autoSaveChb.enabled = autoSaveClock.active = false
		ResetFn()
		SetTimerFn()
		saveBtn.text = "Save"
	)
)

on autoSaveChb changed state do 
(
	setIniSetting _sgz._ini "AutoSave" "enabled" (state as string)
)


on saveBtn pressed do 
(
	max file save
	DisplaySavingTextFn (maxFilePath + maxFileName)
)
on incrementalSaveBtn pressed do
(
	max saveplus
	DisplaySavingTextFn (maxFilePath + maxFileName)
)
on saveAsBtn pressed do 
(
	max file saveas
	DisplaySavingTextFn (maxFilePath + maxFileName)
)


on saveBtn rightclick do
(
	if enableTimer.checked then 
	(
		ResetFn()
		SetTimerFn()
	)
)


on saveAsBtn rightclick do
(
	if selection.count >= 1 then 
	(
		max file save selected
	)
)


on autoSaveClock tick do 
(
	-- If scene need to be save then decrease timer
	if getSaveRequired() and nextSave > 0 then 
	(
		nextSave -= 1
		pbValue = pbValue + percent
	)
	
	-- If timer is at zero and scene need to be save, auto save or wait for manual save
	else if getSaveRequired() then 
	(
		-- Deal with autosave
		if autoSaveChb.checked then 
		(
			-- Save over file
			if execute (getIniSetting _sgz._ini "AutoSave" "overfile") then 
			(
				if execute (getIniSetting _sgz._ini "AutoSave" "incremental") then
				(
					-- Save incremental
					max saveplus		
					DisplaySavingTextFn (maxFilePath + maxFileName)
				)
				else 
				(
					-- Overwrite current file
					max file save				
					DisplaySavingTextFn (maxFilePath + maxFileName)
				)
			)
			
			-- Save as Autoback
			else 
			(
				-- Define the autoback number
				autoBackVersionStr = autoBackVersion as string
				maxNumberStr = getIniSetting _sgz._ini "AutoSave" "number"
				zeroStr = ""
				for i = 1 to maxNumberStr.count - autoBackVersionStr.count do zeroStr += "0"
				if autoBackVersionStr.count == 1 and zeroStr.count == 0 then zeroStr = "0"
				
				
				-- Define the autoback filename 
				autoBackFileName = ""
				if execute (getIniSetting _sgz._ini "AutoSave" "fileLinked") then
					autoBackFileName = trimright maxFileName ".max" + "_"
				autoBackFileName += getIniSetting _sgz._ini "AutoSave" "fileName" + zeroStr + autoBackVersionStr
				
				
				-- Define the autoback path
				local autoBackPath
				if execute (getIniSetting _sgz._ini "AutoSave" "sameFolder") then 
					autoBackPath = maxFilePath 
				else autoBackPath = getIniSetting _sgz._ini "AutoSave" "folder" + "\\"
				
				
				-- Make the autoback and set the autoback counter
				saveMaxFile (autoBackPath + autoBackFileName) useNewFile:false
				DisplaySavingTextFn (autoBackPath + autoBackFileName)
				if autoBackVersion < execute (getIniSetting _sgz._ini "AutoSave" "number") then 
					autoBackVersion += 1
				else autoBackVersion = 1
			)
			
		)
		
		-- Deal with blink 
		else if execute (getIniSetting _sgz._ini "AutoSave" "blink") then 
		(
			autoSaveClock.interval = 1000 / execute (getIniSetting _sgz._ini "AutoSave" "blinkSpeed")
		)
	)
	
	-- If timer is at zero and scene doesn't need to be save, reset timer 
	else ResetFn()

	
	-- Set UI
	SetTimerFn()
)


on optionBtn pressed do 
(
	fileIn "$sugzTools\AutoSave\AutoSave_Options.ms"
)
	