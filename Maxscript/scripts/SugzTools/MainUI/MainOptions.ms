label startupLbl "Start with 3ds Max :" align:#left offset:[-5,0]
checkBox startupChk "" width:15 align:#right offset:[5,-18]
label dockStateLbl "Dock :" align:#left offset:[-5,0]
radiobuttons dockStateRdb labels:#("Float", "Left", "Right") default:2 align:#right offset:[5,-18]
label promptDisplayTimeLbl "Prompt Display Time (s) :" across: 2 align:#left offset:[-6,0]
spinner promptDisplayTimeSpn "" width:45 align:#right offset:[6,0] type:#integer range:[0,10,0]

on OptionsRoll open do 
(
	try
	(
		startupChk.state = execute (getIniSetting _sgz._ini "MainUi" "startup")
		dockStateRdb.state = execute (getIniSetting _sgz._ini "MainUi" "dockState")
		promptDisplayTimeSpn.value = execute (getIniSetting _sgz._ini "Common" "promptTime")
	)
	catch()
	
)

on startupChk changed state do 
(
	setIniSetting _sgz._ini "MainUi" "startup" (state as string)
)

on dockStateRdb changed state do 
(
	case state of 
	(
		1: cui.FloatDialogBar SgzRoll 
		2: cui.DockDialogBar SgzRoll #cui_dock_left
		3: cui.DockDialogBar SgzRoll #cui_dock_right
	)
	setIniSetting _sgz._ini "MainUi" "dockState" (state as string)
)

on promptDisplayTimeSpn changed val do 
(
	setIniSetting _sgz._ini "Common" "promptTime" (val  as string)
)