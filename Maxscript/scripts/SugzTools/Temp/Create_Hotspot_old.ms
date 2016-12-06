try(destroyDialog ::HotspotMakerView) catch()
Rollout HotspotMakerView "Hotspot"
(
	local heights = #(1.0, 10.0, 18.0, 35.0)
	local insidePos = #([28.5, 3.89101, 19.5], [28.5, -3.92987, 19.5], [32.5, 0, 19], [46.5, 0, 18.25])
	
	button createHotspotBtn "Create Hotspot" width:148 align:#center
	label hotspotHeightLbl "Outside:" align:#left offset:[-7,3]
	dropdownlist hotspotHeightDdl items:#("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (3,5 m)") width:100 align:#right offset:[7,-22]
	label hotspotCabinLbl "Inside:" align:#left offset:[-7,3]
	dropdownlist hotspotCabinDdl items:#("Pilot", "Copilot", "Cabin FWD", "Cabin AFT") width:100 align:#right offset:[7,-22]
	
	button checkCamHeightbtn "Check Cameras Height" width:148 align:#center enabled:false
	
	groupbox separatorGrp width:150 height:7 align:#center
	
	button exportBtn "Export" width:150 align:#center offset:[0,5] enabled:false
	
	
	
	fn GetCamPos cam = 
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
	)
	

	
	on createHotspotBtn pressed do
	(
		if selection.count == 1 then 
		(
			refObj = selection[1]
			
			tm = Inverse(viewport.getTM())
		
			cam = Physical_Camera wirecolor:blue transform:tm name:(refObj.name + "_Hotspot")
			cam.targeted = true
			cam.target.pos = refObj.center
			cam.pos = tm.translationpart
				
			cam.parent = cam.target.parent = refObj
			
			setTransformLockFlags cam.target #{1..9}

			viewport.setCamera cam
			select cam
		)
		
		else if selection.count > 1 then 
		(
			local refObj
			if selection[1].parent != undefined then refObj = selection[1].parent
-- 			refObj = selection[1]
			
			tm = Inverse(viewport.getTM())
		
			cam = Physical_Camera wirecolor:blue transform:tm name:(refObj.name + "_Hotspot")
			cam.targeted = true
			cam.target.pos = selection.center -- refObj.center
			cam.pos = tm.translationpart
				
			cam.parent = cam.target.parent = refObj
			
			setTransformLockFlags cam.target #{1..9}

			viewport.setCamera cam
			select cam
		)
		
	)
	

	on hotspotHeightDdl selected val do 
	(
		if selection.count != 0 and superClassOf $ == camera then $.pos.z = heights[val]
	)
	
	
	on hotspotCabinDdl selected val do 
	(
		if selection.count != 0 and superClassOf $ == camera then $.pos = insidePos[val]
	)
	
	
	
	on checkCamHeightbtn pressed do
	(
		
		
	)
	
		
	
	
	on exportBtn pressed do
	(
		file = getOpenFileName title:"Select the synthesis file"
		excel = CreateOLEObject "Excel.Application"
		
		-- Open the correct activesheet
		excel.application.Workbooks.Open(file)
		
		try ((excel.Worksheets "FromMax").Activate) 
		catch 
		(
			excel.ActiveWorkbook.Sheets.Add
			excel.ActiveSheet.Name = "FromMax"
		)
		
		-- Define Columns name
		col = #("A", "B", "C", "D", "E", "F")
		colName = #("Element name in 3D", "Visible at start-up", "Hotspot location", "Transparent Container", "Panel to hide", "Animation")
		for i = 1 to col.count do (excel.application.Range(col[i] + 1 as string)).value = colName[i]
		
		-- Write values
		i = 2
		for cam in cameras where not isKindOf cam Targetobject do 
		(
			(excel.application.Range("A" + i as string)).value = cam.parent.name
			(excel.application.Range("C" + i as string)).value = (GetCamPos cam as string)
			i += 1
		)
		
		-- Save and close excel
		excel.application.ActiveWorkbook.SaveAs(file)
		excel.application.ActiveWorkbook.Close
		excel.quit()
		releaseAllOLEObjects()
	)

	
	
	
)
createDialog HotspotMakerView 160 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)