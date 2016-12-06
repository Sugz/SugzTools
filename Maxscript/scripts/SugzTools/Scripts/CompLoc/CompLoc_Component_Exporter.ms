/*##############################################################################
CompLoc Excel Exporter
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !
###############################################################################*/


global _cplcExport
struct CompLocExcelExporterStc
(
	/*  ############################################################################################*/
	fn GetHotspot cam = 
	(
		hasTarget = false
		if cam.targeted then 
		(
			hasTarget = true 
			cam.targeted = false
		)
		
		ss = StringStream ""
		format "%, %, %" (-cam.pos[1] / 10) (cam.pos[3] / 10) (-cam.pos[2] / 10) to:ss
		
		if hasTarget then cam.targeted = true
			
		ss
	),
	
	
	
	/*  ############################################################################################*/
	fn GetTransparent transparents =
	(
		
	),
	
	
	
	/*  ############################################################################################*/
	fn GetAnimated animateds =
	(
		
	),
	
	
	
	/*  ############################################################################################*/
	fn GetHidden hiddens =
	(
		
	),
	
	
	
	
	
	/* Macroscript declaration ############################################################################################*/
	macro =
	(
		macroScript CompLocExcelExporter
			category:"SugzTools"
			toolTip:"CompLoc Excel Exporter"
			Icon:#("SugzTools",9)
		
		(
			global _cplc
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc_Component.ms"
					_cplc.CreateView()
				)
			)
		)
	)
	
	
	
)
