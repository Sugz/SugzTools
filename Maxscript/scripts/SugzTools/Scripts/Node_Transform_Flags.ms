/*##############################################################################
Node Transform Flags
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager
SugzTools Node Properties Library

# Script infos:
Script design to quickly get and toggle nodes transform locks and inherit flags

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


struct NodeTmFlagsStc
(
	
	NodeTmFlagsRoll = undefined,
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout NodeTmFlagsRoll "Link Info"  rolledUp:true
		(
			groupbox locksGrp "Locks" width:175 height:35 align:#center offset:[0,-5]
				checkbox moveLocksChk "Move" align:#left offset:[0,-25]
				checkbox rotateLocksChk "Rotate" align:#center offset:[0,-20]
				checkbox scaleLocksChk "Scale" align:#right offset:[0,-20]
			
			groupbox inheritGrp "Inherit" width:175 height:35 align:#center offset:[0,5]
				checkbox moveInheritChk "Move" align:#left offset:[0,-25]
				checkbox rotateInheritChk "Rotate" align:#center offset:[0,-20]
				checkbox scaleInheritChk "Scale" align:#right offset:[0,-20]
			
			
			fn SetNodeTmFlagsUI = 
			(
				locksChk = #(moveLocksChk, rotateLocksChk, scaleLocksChk)
				inheritChk = #(moveInheritChk, rotateInheritChk, scaleInheritChk)
				
				if selection.count != 0 then 
				(
					locksFlags = _sgz._prop.GetFlags selection #locks
					for i = 1 to 3 do (locksChk[i].enabled = true; locksChk[i].tristate = locksFlags[i])
						
					inheritFlags = _sgz._prop.GetFlags selection #inherit
					for i = 1 to 3 do (inheritChk[i].enabled = true; inheritChk[i].tristate = inheritFlags[i])
				)
				
				else for chk in (join locksChk inheritChk) do chk.state = chk.enabled = false
				
			)
			
			
			on NodeTmFlagsRoll open do 
			(
				SetNodeTmFlagsUI()
				callbacks.addScript #selectionSetChanged "_sgz._tmFlags.NodeTmFlagsRoll.SetNodeTmFlagsUI()" id:#SetNodeTmFlagsCb
			)
			
			on NodeTmFlagsRoll close do 
			(
				callbacks.removeScripts #selectionSetChanged id:#SetNodeTmFlagsCb
			)
			
			
			on moveLocksChk changed state do _sgz._prop.SetFlags selection state #move #locks
			on rotateLocksChk changed state do _sgz._prop.SetFlags selection state #rotate #locks
			on scaleLocksChk changed state do _sgz._prop.SetFlags selection state #scale #locks
				
			on moveInheritChk changed state do _sgz._prop.SetFlags selection state #move #inherit
			on rotateInheritChk changed state do _sgz._prop.SetFlags selection state #rotate #inherit
			on scaleInheritChk changed state do _sgz._prop.SetFlags selection state #scale #inherit
			
		)
	),
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog _sgz._tmFlags.NodeTmFlagsRoll) catch()
		createDialog _sgz._tmFlags.NodeTmFlagsRoll 188 45 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	/* Initialize AutoMaterial ############################################################################################*/
	fn Run = 
	(
		CreateView()
	),
	
	
	/* Macroscript declaration ############################################################################################*/
	macro =
	(
		/*
		macroScript AutoMaterial
			category:"SugzTools"
			toolTip:"Open the AutoMaterial Dialog"
			Icon:#("SugzTools",7)
		(
			global _sgz
			on execute do 
			(
				if _sgz != undefined then _sgz._autoMtl.Run()
				else 
				(
					fileIn "$userScripts\Startup\SugzTools_Startup.ms"
					_sgz._autoMtl.Run()
				)
			)
			
		)
		*/
	)
	
	
)

