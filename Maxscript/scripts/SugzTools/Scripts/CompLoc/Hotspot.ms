/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


global _hotspot
struct HotspotStc
(
	masterObjs = #(),
	View = undefined,
	
	/*  ############################################################################################*/
	fn SetProp index type =
	(
		/*<Function>
		Arguments:
			<Integer> index: the index of the component in _hotspot.masterObjs
			<Name> type: the type of property (hotspot, transparent, hidden, animated)
		Return:
		Further Infos:
		</Function>*/
		
		
		key = case type of 
		(
			#hotspot:"hotspot"
			#transparent: "transparent"
			#hidden: "hidden"
			#animated: "animated"
		)
		
		prop = if type == #hotspot then $.pos else (for obj in selection collect obj.name)
		
		setUserProp _hotspot.masterObjs[index] key prop
		
	),
	
	
	/*  ############################################################################################*/
	fn UpdateComponentsList = 
	(
		if View != undefined and _hotspot.View.open then 
		(
			View.componentsList.items = for obj in masterObjs collect obj.name
		)
		
	),
	
	
	/*  ############################################################################################*/
	fn CollectComponents = 
	(
		masterObjs = for obj in objects where (getUserProp obj "IsMasterObject" == true) collect obj
		UpdateComponentsList()
	),
	
	
	/*  ############################################################################################*/
	fn SetObjectsAsComponent = 
	(
		if not _sgz._sel.IsSelectionEmpty() then
		(
			for obj in selection do 
			(
				appendIfUnique masterObjs obj
				UpdateComponentsList()
				
				setUserProp obj "IsMasterObject" true
			)
		)
	),
	
	
	
	/*  ############################################################################################*/
	fn RemoveObjectFromComponentList =
	(
		-- Remove the user property IsMasterObject from selected object in the list or from selection is the view doesn't exist
		if _hotspot.View != undefined and _hotspot.View.open then
		(
			index = View.componentsList.selection
			_sgz._extMxs.DeleteUserProp masterObjs[index] "IsMasterObject"
			deleteItem masterObjs index
		)
		else 
		(
			for obj in selection where (getUserProp obj "IsMasterObject" == true) do 
			(
				_sgz._extMxs.DeleteUserProp obj "IsMasterObject"
				deleteItem masterObjs (findItem masterObjs obj)
			)
		)
		
		UpdateComponentsList()
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout View "Hotspot Maker"
		(
			listbox componentsList "Required Components :" height:25
			button addComponentBtn "Add Component" width:135 align:#left offset:[0,-3] across:2 
			button removeComponentBtn "Remove Component" width:135 align:#right offset:[0,-3] 

			dropdownlist objectsTypeDdl items:#("Hotspot", "Transparent", "Hidden", "Animated") offset:[0,10]
			listbox relatedObjectsList offset:[0,-5]
			button addObjectsBtn "Add Objects" width:135 align:#left offset:[0,-3] across:2 
			button removeObjectsBtn "Remove Objects" width:135 align:#right offset:[0,-3] 
			
		
			on View open do _hotspot.CollectComponents()
			on addComponentBtn pressed do _hotspot.SetObjectsAsComponent()
			on removeComponentBtn pressed do _hotspot.RemoveObjectFromComponentList()

		)
	),
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog _hotspot.View) catch()
		createDialog _hotspot.view 300 580 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
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
		macroScript MACRONAME
			category:"SugzTools"
			toolTip:""
			Icon:#("SugzTools",1)
		(
			global _sgz
			on execute do 
			(
				if _sgz == undefined then fileIn "$userScriptsStartupSugzTools_Startup.ms"
				_sgz._Stc.Run()
			)
			
		)
		*/
	)
	
)

-- _hotspot = HotspotStc()
if _hotspot  != HotspotStc() then _hotspot = HotspotStc()
_hotspot.Run()
