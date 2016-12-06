try(destroyDialog ::InsatRoll) catch()
Rollout InsatRoll "Insat3D"
(
	button backupBtn "Create Backup" width:170 height:21 align:#center
	button optimizeBtn "Optimize" width:170 height:21 align:#center
	button replaceGeoBtn "Replace Geo" width:170 height:21 align:#center
	button doneBtn "Set as Done" width:170 height:21 align:#center
	button collapseBtn "Collapse" width:170 height:21 align:#center
	button hideGroupBtn "Hide Groups Dummy" width:170 height:21 align:#center
	button IsolateSameName "Isolate by Name" width:170 height:21 align:#center
	
	
	
	on InsatRoll open do 
	(
		if _sgz._autoMtl.GetMtl() == undefined then _sgz._autoMtl.SetMtl()
	)
	
	
	on backupBtn pressed do
	(
		for obj in selection do 
		(
			maxOps.CloneNodes obj newNodes:&newNodes											-- Clone selection
			newNodes[1].name = (obj.name + "_old")															-- Add _old to its name
			(LayerManager.getLayerFromName "Old").addNode newNodes[1]					-- Set it to the old layer	
		)
	)
	
	
	on replaceGeoBtn pressed do
	(
		if _sgz._sel.IsSelectionOne() then 
		(
			$.material = _sgz._autoMtl.GetMtl()											-- Apply AutoMaterial		
			_sgz._mod.ConvertToEditPolyFn()											-- Convert it to editable poly
			polyop.deleteFaces $ #all 															-- Delete faces
			newObj = pickObject()																-- Pick the replacement object
			$.attach newObj $																		-- Attach the picked object 
		)
		
	)
	
	
	on doneBtn pressed do
	(
		selectMore (_sgz._sel.GetInstances selection getHidden:true)
		for obj in selection do 
		(
			(LayerManager.getLayerFromName "Done").addNode obj			-- Set to done layer
			obj.material = _sgz._autoMtl.GetMtl()												-- Apply AutoMaterial		
			obj.wirecolor = _sgz._autoMtl.GetClr()
		)
		
	)
	
	
	on optimizeBtn pressed do
	(
		-- Weld vertices
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subObjectLevel  = 1
		actionMan.executeAction 0 "40021"  -- Selection: Select All
		$.modifiers[#Edit_Poly].weldVertexThreshold = 0.001
		$.modifiers[#Edit_Poly].ButtonOp #WeldVertex
		$.modifiers[#Edit_Poly].Commit ()
		subObjectLevel  = 0
			
		-- Clean edges
		modPanel.addModToSelection (optimize ()) ui:on
		$.modifiers[#Optimize].autoEdge = on
			
		-- Retriangulate
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subObjectLevel  = 5
		actionMan.executeAction 0 "40021"  -- Selection: Select All
		macros.run "Editable Polygon Object" "EPoly_Retriangulate"
		subObjectLevel  = 0
			
		-- Delete Mid-Edge vertices
		modPanel.addModToSelection (Turn_to_Poly ()) ui:on
		$.modifiers[#Turn_to_Poly].removeMidEdgeVertices = on
			
		-- Retriangulate
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subObjectLevel  = 5
		actionMan.executeAction 0 "40021"  -- Selection: Select All
		macros.run "Editable Polygon Object" "EPoly_Retriangulate"
		subObjectLevel  = 0
			
		-- Pro optimizer
		modPanel.addModToSelection (ProOptimizer ()) ui:on
		$.modifiers[#ProOptimizer].VertexPercent = 35
		$.modifiers[#ProOptimizer].Calculate = on
			
		-- Smooth
		modPanel.addModToSelection (Edit_Poly ()) ui:on
		subobjectLevel = 5
		actionMan.executeAction 0 "40021"
		$.modifiers[#Edit_Poly].autoSmoothThreshold = 35
		$.modifiers[#Edit_Poly].ButtonOp #Autosmooth
		subObjectLevel  = 0
	)
	
	
	
	on collapseBtn pressed do
	(
		for obj in selection do 
		(
			try 
			(
				obj.modifiers[#ProOptimizer].Calculate = on
				obj.modifiers[1]
				_sgz._mod.ConvertToEditPolyFn()
			)catch()
			
			for o in (join #(obj) (_sgz._sel.GetInstances obj getHidden:true)) do (LayerManager.getLayerFromName "Done").addNode o
		)
	)
	
	
	
	on hideGroupBtn pressed do
	(
		SetSelectFilter 6
		max select all 
		hide selection
		max select none
		SetSelectFilter 1
	)
	
	
	on IsolateSameName pressed do
	(
		for obj in selection do selectMore (getNodeByName obj.name all:true)
		selectMore (_sgz._sel.GetInstances selection getHidden:true)
		IsolateSelection.EnterIsolateSelectionMode()
	)
	
	
	
)
createDialog InsatRoll 188 185 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)