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


fn SetAllChkState = 
(
	if newSceneChk.state and resetChk.state and exitMaxChk.state and saveAsChk.state and openFileChk.state 
		then allChk.state = true 
		else allChk.state = false
)


on GfxCMRoll open do 
(
	newSceneChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "newScene")
	resetChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "reset")
	exitMaxChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "exitMax")
	saveAsChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "save")
	openFileChk.state = execute (getIniSetting _sgz._ini "GfxConflictManager" "open")
	
	SetAllChkState()
	
)


on showListBtn pressed do _sgz._gfxCm.UI()


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

on newSceneChk changed state do 
(
	if state 
		then _sgz._gfxCm.RegisterCb _new:true
		else _sgz._gfxCm.RemoveCb _new:true
	setIniSetting _sgz._ini "GfxConflictManager" "newScene" (state as string)
	SetAllChkState()
)

on resetChk changed state do 
(
	if state 
		then _sgz._gfxCm.RegisterCb _reset:true
		else _sgz._gfxCm.RemoveCb _reset:true
	setIniSetting _sgz._ini "GfxConflictManager" "reset" (state as string)
	SetAllChkState()
)

on exitMaxChk changed state do 
(
	if state 
		then _sgz._gfxCm.RegisterCb _exitMax:true
		else _sgz._gfxCm.RemoveCb _exitMax:true
	setIniSetting _sgz._ini "GfxConflictManager" "exitMax" (state as string)
	SetAllChkState()
)

on saveAsChk changed state do 
(
	if state 
		then _sgz._gfxCm.RegisterCb _save:true
		else _sgz._gfxCm.RemoveCb _save:true
	setIniSetting _sgz._ini "GfxConflictManager" "save" (state as string)
	SetAllChkState()
)

on openFileChk changed state do 
(
	if state 
		then _sgz._gfxCm.RegisterCb _open:true
		else _sgz._gfxCm.RemoveCb _open:true
	setIniSetting _sgz._ini "GfxConflictManager" "open" (state as string)
	SetAllChkState()
)