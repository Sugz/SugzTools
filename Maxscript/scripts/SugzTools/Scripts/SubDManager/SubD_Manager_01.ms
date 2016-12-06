/*##############################################################################
SugzTools SubD Manager
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Script design to have a global function to turn SubD on / off

# Required Components:
SugzTools Manager
SugzTools INI Manager

# Sources:

# ToDo:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/

try (destroyDialog _subD.SubDView) catch()

global _subD
struct SubDStc
(
	
	
	SubDView = undefined,
-- 	showSubD = false,
-- 	showMaps = false,
	
	
	
	/* Toggle SubD ############################################################################################*/
	fn ToggleSubD level = 
	(
		/*<Function>
		Description:
			Toggle SubD
		Arguments:
			<Name> level: switch from #off, #viewport and #render
		</Function>*/
		
-- 		showSubD = not showSubD
		for obj in objects do 
		(
			for m in obj.modifiers where classof m == TurboSmooth do 
			(
				case level of
				(
					#off: m.enabled = false
					#viewport : (m.enabled = true; m.useRenderIterations = false)
					#render: (m.enabled = true; m.useRenderIterations = true)
				)
			)
		)
		
	),
	
	
	/* Toggle show textures on material  ############################################################################################*/
	fn ToggleShowMaps =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		
	
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout SubDView "SubD"
	(
		label toggleSubDLbl "Toggle SubD" align:#left offset:[-5,0] across:2
		checkbox toggleSubDChk align:#right offset:[17,0]
		label showMapsLbl "Show Maps" align:#left offset:[-5,0] across:2
		checkbox showMapsChk align:#right offset:[17,0]
		
		button addTurboSmoothBtn "TurboSmooth" width:85 align:#left offset:[-7,0] across:2
		button addOpenSubDivBtn "OpenSubdiv" width:85 align:#right offset:[7,0]
		
		
		on addTurboSmoothBtn pressed do
		(
			_turboSmooth = TurboSmooth()
			_turboSmooth.iterations = 2
			_turboSmooth.renderIterations = 3
			_turboSmooth.sepBySmGroups = true
			
			addModifier selection _turboSmooth
		)
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog SubDView) catch()
		createDialog SubDView 188 200 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Initialize AutoMaterial ############################################################################################*/
	fn Run = 
	(
-- 		CreateView()
	),
	
	
	
	/* Disable SubD ############################################################################################*/
	disableSubDMacro =
	(
		macroScript disableSubDMacro
			category:"SugzTools"
			toolTip:"Disable SubD"
			Icon:#("SugzTools",1)
		(
			global _sgz
			on execute do 
			(
-- 				if _sgz == undefined then fileIn "$userScripts\Startup\SugzTools_Startup.ms"
				_subD.ToggleSubD #off
			)
			
		)
	),
	
	
	/* Enable SubD ############################################################################################*/
	enableSubDMacro =
	(
		macroScript EnableSubDMacro
			category:"SugzTools"
			toolTip:"Enable SubD"
			Icon:#("SugzTools",1)
		(
			global _sgz
			on execute do 
			(
-- 				if _sgz == undefined then fileIn "$userScripts\Startup\SugzTools_Startup.ms"
				_subD.ToggleSubD #viewport
			)
			
		)
	),
	
	
	/* Enable SubD ############################################################################################*/
	enableRenderSubDMacro =
	(
		macroScript EnableRenderSubDMacro
			category:"SugzTools"
			toolTip:"Enable Render SubD"
			Icon:#("SugzTools",1)
		(
			global _sgz
			on execute do 
			(
-- 				if _sgz == undefined then fileIn "$userScripts\Startup\SugzTools_Startup.ms"
				_subD.ToggleSubD #render
			)
			
		)
	),
	
	
	
	/* Toggle show textures on material ############################################################################################*/
	toggleShowMapsMacro =
	(
		/*
		*/
	)
	
)

_subD = SubDStc()
_subD.Run()
