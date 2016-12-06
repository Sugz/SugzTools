/*##############################################################################
Toggle Selection Outline
Version 0.03
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

#Required Components:
SugzTools Manager Struct
SugzTools Extend 3ds Max Struct

#Script infos:
Simple button to toggle on and off the selection outline

*Use / Modify this script at your own risk !*
###############################################################################*/

struct ToggleSelOutlineStruct
(
	fn GetState = 
	(
		if _sgz != undefined 
			then _sgz._extMxs.GetActionManState "Main UI" 63565 
			else false
	),
	
	
	fn Run = actionMan.executeAction 0 "63565",
		
	
	Macro = 
	(
		macroScript ToggleSelOutline
			category:"SugzTools"
			toolTip:"Toggle Selection Outline"
			Icon:#("SugzTools",2)
		(
			global ToggleSelOutline
			on execute do ToggleSelOutline.Run()
			on isChecked return ToggleSelOutline.GetState()
		)
	)
	
)

ToggleSelOutline = ToggleSelOutlineStruct()
