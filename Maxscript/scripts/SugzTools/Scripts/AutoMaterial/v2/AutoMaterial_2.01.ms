/*##############################################################################
Auto Material
Version 2.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Script design to automaticaly set a material and wirecolor when an object is created

# Required Components:
SugzTools Manager
SugzTools INI Manager
SugzTools Material Library

# Sources:

# ToDo:

# History:
2.01:
	- Rewrite everything from the ground up
	- Switch to node event callback
	- Add button to apply automaterial and wirecolor to a selection
	- Add checker map with controls to showInViewport, color1 and color2 and tiling
1.1:
	- Initial Release

*Use / Modify this script at your own risk !*
###############################################################################*/



global _autoMtl
struct AutoMaterialStc
(
	
	autoMaterialView = undefined,					-- The rollout
	autoMaterialCallBack = undefined,				-- The node event callback
	autoMaterial = undefined,							-- The material
	wireColor = undefined,								-- The wirecolor
	useMaterial = false,									-- 
	useColor = false,
	useLayerColor = false,								-- Wheter use the general or layer wirecolor
	showChecker = false,
	checkerTiling = 10.0,
	checkerDarkColor = undefined,
	checkerBrightColor = undefined,
	
	
	/* Get autoMaterial ############################################################################################*/
	fn GetMtl = 
	(
		if autoMaterial == undefined then 
		(
			mtlName = getIniSetting _sgz._ini "AutoMaterial" "name"
			mtls = _sgz._mtl.GetByName mtlName
			if mtls.count != 0 
				then autoMaterial = mtls[1] 
				else 
				(
					_checker = checker color1:checkerDarkColor color2:checkerBrightColor showInViewport:showChecker
					_checker.coords.U_Tiling = _checker.coords.V_Tiling = checkerTiling
					autoMaterial = standard name:mtlName diffuseMap:_checker
				)
		)
		
		autoMaterial
	),
	
	
	
	/* Get wireColor ############################################################################################*/
	fn GetClr =
	(
		if wireColor == undefined then wireColor = execute (getIniSetting _sgz._ini "AutoMaterial" "color")
		returnColor = if useLayerColor then (LayerManager.current).wireColor else wireColor
		
		returnColor
	),
	
	
	
	/* Get the object created and call the function to set its parameters ############################################################################################*/
	fn AddMaterial ev nd = 
	(
		if _autoMtl.useMaterial and isProperty $ "material" then $.material = _autoMtl.GetMtl()
		if _autoMtl.useColor then $.wirecolor = _autoMtl.GetClr()
-- 		if isCreatingObject() then 
-- 		(
-- 			print "it's working"
-- 			if useMaterial and isProperty $ "material" then $.material = _autoMtl.GetMtl()
-- 			if useColor then $.wirecolor = _autoMtl.GetClr()
-- 		)
	),
	
	
	
	/* Register the node event callback (added) ############################################################################################*/
	fn RegisterCallbacks =
	(
		autoMaterialCallBack = NodeEventCallback added:AddMaterial 
	),
	
	
	
	/* Remove the node event callback  ############################################################################################*/
	fn RemoveCallbacks =
	(
		autoMaterialCallBack = undefined
		gc light:true
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout autoMaterialView "Auto Material" rolledUp:true
	(
		button applyColorBtn "Apply Color    " width:80 height:20 align:#left offset:[-5,3]
		colorPicker colorClr width: 30 height:16 title:"Object Default Color" align:#right offset:[-47,-23]
		checkbutton useLayerColorBtn "L" width:26 height:16 align:#right offset:[-15,-21] tooltip:"Color by layer"
		checkbox useColorChk "" align:#right offset:[17,-20]
		
		button applyMatBtn "Apply Material" width:80 height:20 align:#left offset:[-5,0]
		checkbox useMaterialChk "" align:#right offset:[17,-22]
		
		groupbox separatorGrp width:160 height:7 align:#center offset:[0,3]
		
		label showCheckerLbl "Show Checker" align:#left offset:[-3,5]
		checkbox showCheckerChk "" align:#right offset:[17,-20]
		
		label checkerTilingLbl "Checker Tiling" align:#left offset:[-3,5]
		spinner checkerTilingSpn width:59 type:#integer align:#right offset:[6,-21]
		
		label checkerColorsLbl "Checker Colors" align:#left offset:[-3,5]
		colorPicker checkerDarkClr width: 30 height:16 title:"Checker Dark Color" align:#right offset:[-26,-19]
		colorPicker checkerBrightClr width: 30 height:16 title:"Checker Bright Color" align:#right offset:[6,-21]
		
		
		/* Initialize the UI ***************************************************************************************************************************************************************/
		on autoMaterialView open do 
		(
			colorClr.color = _autoMtl.GetClr()
			useLayerColorBtn.state = _autoMtl.useLayerColor
			useColorChk.state = _autoMtl.useColor
			
			useMaterialChk.state = _autoMtl.useMaterial
			
			showCheckerChk.state = _autoMtl.showChecker
			checkerTilingSpn.value = _autoMtl.checkerTiling
			checkerDarkClr.color = _autoMtl.checkerDarkColor
			checkerBrightClr.color = _autoMtl.checkerBrightColor
			
		)

		
		/* Apply the color on selection ***************************************************************************************************************************************************************/
		on applyColorBtn pressed do
		(
			if not _sgz._sel.IsSelectionEmpty() then for obj in selection do obj.wirecolor = _autoMtl.GetClr()
		)
		
		/* Change the wirecolor ***************************************************************************************************************************************************************/
		on colorClr changed clr do 
		(
			if applyLayerColorBtn.state then (LayerManager.current).wireColor = clr
			else 
			(
				_autoMtl.wireColor = clr
				setIniSetting _sgz._ini "AutoMaterial" "color" (clr as string)
			)
		)
		
		/* Use the layer color ***************************************************************************************************************************************************************/
		on useLayerColorBtn changed state do 
		(
			_autoMtl.useLayerColor = state
			colorClr.color = _autoMtl.GetClr()
			setIniSetting _sgz._ini "AutoMaterial" "useLayerColor" (state as string)
		)
		
		/* Use or not the wirecolor when creating new nodes ***************************************************************************************************************************************************************/
		on useColorChk changed state do 
		(
			_autoMtl.useColor = state
			setIniSetting _sgz._ini "AutoMaterial" "useColor" (state as string)
			
			-- Activate or desactivate the callback if the useColor is also disable
			if state and _autoMtl.autoMaterialCallBack == undefined then _autoMtl.RegisterCallbacks()
			if (_autoMtl.useMaterial == _autoMtl.useColor == false) then _autoMtl.RemoveCallbacks()
			
			
		)
		
		
		
		
		/* Apply the material on selection ***************************************************************************************************************************************************************/
		on applyMatBtn pressed do
		(
			if not _sgz._sel.IsSelectionEmpty() then for obj in selection where isProperty obj "mat" do obj.material = _autoMtl.GetMtl()
		)
		
		/*Use or not the material when creating new nodes ***************************************************************************************************************************************************************/
		on useMaterialChk changed state do 
		(
			_autoMtl.useMaterial = state
			setIniSetting _sgz._ini "AutoMaterial" "useMaterial" (state as string)
			
			-- Activate or desactivate the callback if the useColor is also disable
			if state and _autoMtl.autoMaterialCallBack == undefined then _autoMtl.RegisterCallbacks()
			if (_autoMtl.useMaterial == _autoMtl.useColor == false) then _autoMtl.RemoveCallbacks()
		)
		
		
		
		
		/* Show the checker in viewport ***************************************************************************************************************************************************************/
		on showCheckerChk changed state do 
		(
			if _autoMtl.autoMaterial != undefined then 
				_autoMtl.autoMaterial.showInViewport = state
			
			_autoMtl.showChecker = state
			setIniSetting _sgz._ini "AutoMaterial" "showChecker" (state as string)
		)
		
		/* set the checker tiling ***************************************************************************************************************************************************************/
		on checkerTilingSpn changed val do 
		(
			if _autoMtl.autoMaterial != undefined then 
			(
				_checker = _autoMtl.autoMaterial.diffuseMap
				_checker.coords.U_Tiling = _checker.coords.V_Tiling = val
			)
			
			_autoMtl.checkerTiling = val
			setIniSetting _sgz._ini "AutoMaterial" "checkerTiling" (val as string)
		)
		
		/* Set the checker dark color ***************************************************************************************************************************************************************/
		on checkerDarkClr changed clr do 
		(
			if _autoMtl.autoMaterial != undefined then 
				_autoMtl.autoMaterial.diffuseMap.color1 = clr
			
			_autoMtl.checkerDarkColor = val
			setIniSetting _sgz._ini "AutoMaterial" "checkerDarkColor" (clr as string)
		)
		
		/* Set the checker dark color ***************************************************************************************************************************************************************/
		on checkerBrightClr changed clr do 
		(
			if _autoMtl.autoMaterial != undefined then 
				_autoMtl.autoMaterial.diffuseMap.color2 = clr
			
			_autoMtl.checkerBrightColor = val
			setIniSetting _sgz._ini "AutoMaterial" "checkerBrightColor" (clr as string)
		)
		
		
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog autoMaterialView) catch()
		createDialog autoMaterialView 188 140 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Initialize AutoMaterial ############################################################################################*/
	fn Run = 
	(
		-- Get the user prefs
		useMaterial = execute (getIniSetting _sgz._ini "AutoMaterial" "useMaterial")
		useColor = execute (getIniSetting _sgz._ini "AutoMaterial" "useColor")
		useLayerColor = execute (getIniSetting _sgz._ini "AutoMaterial" "useLayerColor")
		showChecker = execute (getIniSetting _sgz._ini "AutoMaterial" "showChecker")
		checkerDarkColor = execute (getIniSetting _sgz._ini "AutoMaterial" "checkerDarkColor")
		checkerBrightColor = execute (getIniSetting _sgz._ini "AutoMaterial" "checkerBrightColor")
		
		GetMtl()
		GetClr()
		-- Register the callback only if it's needed
		if useMaterial or useColor then RegisterCallbacks()
		
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
				if _sgz == undefined then fileIn "$userScripts\Startup\SugzTools_Startup.ms"
				_sgz._Stc.Run()
			)
			
		)
		*/
	)
	
	
)

_autoMtl = AutoMaterialStc()
_autoMtl.Run()