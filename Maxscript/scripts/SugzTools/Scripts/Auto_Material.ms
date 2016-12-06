/*##############################################################################
Auto Material
Version 1.1
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

#Required Components:
SugzTools Manager
SugzTools INI Manager
SugzTools Material Library

# Script infos:
Script design to automaticaly set a material and wirecolor when an object is created

# Sources:

# To do list:
switch to node event callback (check primitive manager) or at least isCreatingObject to avoid applying material / wirecolor when cloning or importin, etc

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/





struct AutoMaterialStc
(
	autoMtl = undefined,
	wireColor = undefined,
	AutoMaterialRoll = undefined,
	useLayerColor = false,
	
	/* Set if exist or create autoMtl ############################################################################################*/
	fn SetMtl = 
	(
		mtlName = getIniSetting _sgz._ini "AutoMaterial" "name"
		mtls = _sgz._mtl.GetByName mtlName
		autoMtl = if mtls.count != 0 then mtls[1] else standard name:mtlName
			
	),
	
	
	/* Get autoMtl ############################################################################################*/
	fn GetMtl = 
	(
		if autoMtl == undefined then SetMtl()
		autoMtl
	),
	
	
	/* Set the wireColor ############################################################################################*/
	fn SetClr =
	(
		wireColor = execute (getIniSetting _sgz._ini "AutoMaterial" "color")
	),
	
	
	/* Get wireColor ############################################################################################*/
	fn GetClr =
	(
		if wireColor == undefined then SetClr()
		returnColor = if useLayerColor then (LayerManager.current).wireColor else wireColor
		
		returnColor
	),
	
	
	
	/* Function that apply autoMtl to an object ############################################################################################*/
	fn MaterialOnNew = 
	(
		obj = callbacks.notificationParam()
		if not isDeleted obj and  isProperty obj "mat" then obj.mat = GetMtl()
	),
	
	
	/* Function that apply a wireColor to an object ############################################################################################*/
	fn ColorOnNew = 
	(
		obj = callbacks.notificationParam()
		if not isDeleted obj then obj.wirecolor = GetClr()
	),
	
	
	/* Set the material and wirecolor when nodes are duplicate ############################################################################################*/
	fn MaterialOnCopy = 
	(
		arr = callbacks.notificationParam()
		
		for i = 1 to arr[1].count do 
		(
			objSource = if not isDeleted (arr[1][i]) then arr[1][i]
			objClone = if not isDeleted (arr[2][i]) then arr[2][i]
			
			if isProperty objSource "mat" and isProperty objClone "mat" then objClone.mat = objSource.mat
		)
	),
	
	
	/* Set the wirecolor when nodes are duplicate ############################################################################################*/
	fn ColorOnCopy = 
	(
		arr = callbacks.notificationParam()
		
		for i = 1 to arr[1].count do 
		(
			objSource = if not isDeleted (arr[1][i]) then arr[1][i]
			objClone = if not isDeleted (arr[2][i]) then arr[2][i]

			objClone.wirecolor = objSource.wirecolor
		)
	),
	
	
	/* Register the callbacks ############################################################################################*/
	fn RegisterCallbacks _material:false _color:false _layer:false =
	(
		if _material then 
		(
			callbacks.addScript #sceneNodeAdded "_sgz._autoMtl.MaterialOnNew()" id:#SgzMaterialOnNewCb
			callbacks.addScript #postNodesCloned "_sgz._autoMtl.MaterialOnCopy()"  id:#SgzMaterialOnCopyCb
		)
		
		if _color then 
		(
			callbacks.addScript #sceneNodeAdded ("_sgz._autoMtl.ColorOnNew()") id:#SgzColorOnNewCb
			callbacks.addScript #postNodesCloned "_sgz._autoMtl.ColorOnCopy()"  id:#SgzColorOnCopyCb
		)

		if _layer then 
		(
			
		)
		
	),
	
	
	/* Remove the callbacks ############################################################################################*/
	fn RemoveCallbacks _material:false _color:false _layer:false =
	(
		if _material then 
		(
			callbacks.removeScripts #sceneNodeAdded id:#SgzMaterialOnNewCb
			callbacks.removeScripts #postNodesCloned id:#SgzMaterialOnCopyCb
		)
		
		if _color then 
		(
			callbacks.removeScripts #sceneNodeAdded id:#SgzColorOnNewCb
			callbacks.removeScripts #postNodesCloned id:#SgzColorOnCopyCb
		)
		
		if _layer then 
		(
			
		)
		
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout AutoMaterialRoll "Auto Material" rolledUp:true
		(
			timer clock interval:500
			label applyMatLbl "Apply Material" align:#left offset:[-5,0]
			checkbox applyMtlChk "" align:#right offset:[17,-18]
			label applyColorLbl "Apply Color" align:#left offset:[-5,0]
			colorPicker applyColorClr width: 30 height:16 title:"Object Default Color" align:#right offset:[-32,-18]
			checkbutton applyLayerColorBtn "L" width:20 height:16 align:#right offset:[-10,-21]
			checkbox applyColorChk "" align:#right offset:[17,-20]
			
			on AutoMaterialRoll open do 
			(
				applyMtlChk.state = execute (getIniSetting _sgz._ini "AutoMaterial" "applyMaterial")
				applyColorChk.state = execute (getIniSetting _sgz._ini "AutoMaterial" "applyColor")
				applyLayerColorBtn.state = _sgz._autoMtl.useLayerColor = execute (getIniSetting _sgz._ini "AutoMaterial" "useLayerColor")
				
				applyColorClr.color = _sgz._autoMtl.GetClr()
				
				if applyMtlChk.state then _sgz._autoMtl.RegisterCallbacks _material:true
				if applyColorChk.state then _sgz._autoMtl.RegisterCallbacks _color:true
-- 				if applyLayerColorBtn.state then () detect active layer callback
			)
			
			on clock tick do
			(
				if applyLayerColorBtn.state then applyColorClr.color = _sgz._autoMtl.GetClr()
			)
			
			on applyMtlChk changed state do 
			(
				if state
					then _sgz._autoMtl.RegisterCallbacks _material:true 
					else _sgz._autoMtl.RemoveCallbacks  _material:true 
				
				setIniSetting _sgz._ini "AutoMaterial" "applyMaterial" (state as string)
			)
			
			
			on applyColorChk changed state do 
			(
				if state
					then _sgz._autoMtl.RegisterCallbacks _color:true _layer:applyLayerColorBtn.state
					else _sgz._autoMtl.RemoveCallbacks  _color:true 
				
				setIniSetting _sgz._ini "AutoMaterial" "applyColor" (state as string)
			)
			
			
			on applyColorClr changed clr do 
			(
				if applyLayerColorBtn.state then (LayerManager.current).wireColor = clr
				else 
				(
					_sgz._autoMtl.wireColor = clr
					setIniSetting _sgz._ini "AutoMaterial" "color" (clr as string)
				)
				
			)
			
			on applyLayerColorBtn changed state do 
			(
				_sgz._autoMtl.useLayerColor = state
				applyColorClr.color = _sgz._autoMtl.GetClr()
				setIniSetting _sgz._ini "AutoMaterial" "useLayerColor" (state as string)
			)
			
		)
	),
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog _sgz._autoMtl.AutoMaterialRoll) catch()
		createDialog _sgz._autoMtl.AutoMaterialRoll 200 45 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	/* Initialize AutoMaterial ############################################################################################*/
	fn Run = 
	(
		CreateView()
	),
	
	
	/* Macroscript declaration ############################################################################################*/
	macro =
	(
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
	)
	
	
)





















