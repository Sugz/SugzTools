try(destroyDialog ::MissingUvsRoll) catch()
Rollout MissingUvsRoll "Missing Uvs"
(
	local missingUvs = #()
	
	listbox lst width:300 height:36 align:#center offset:[0,-5]
	button isolateBtn "Isolate" width:100 align:#left offset:[-12,-3]
	button quickFixBtn "Quick Fix" width:101 align:#center offset:[0,-26]
	button refreshBtn "Refresh" width:100 align:#right offset:[13,-26]
	
	
	fn GetObjects = 
	(
		missingUvs = #()
		for obj in objects where canConvertTo obj Editable_mesh do 
		(
			theMesh = snapshotAsMesh obj
			if not (meshop.getMapSupport theMesh 1) then appendIfUnique missingUvs obj
			delete theMesh
		)
		
		lst.items = for obj in missingUvs collect obj.name
	)
	
	fn SelectAndIsolate sel = 
	(
		select sel
		IsolateSelection.EnterIsolateSelectionMode()
	)
	
	on MissingUvsRoll open do GetObjects()
	on refreshBtn pressed do GetObjects()
	
	on lst doubleClicked item do SelectAndIsolate missingUvs[item]
	on isolateBtn pressed do SelectAndIsolate missingUvs
		
	on quickFixBtn pressed do 
	(
		select missingUvs
		modPanel.addModToSelection (Unwrap_UVW())
	)
		
)
createDialog MissingUvsRoll 300 500 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)