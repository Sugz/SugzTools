try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	label wpTxt "Working Pivot:" across:3 offset:[0,4]
	button setWpBtn "Set" width:50 offset:[10,0]
	checkbutton wpBtn "Use" width:50 offset:[7,0]
	
	local SetWorkingPivotPosCB = undefined
	
	
	fn getSubObjCenter obj  =
	(
		center = [0, 0, 0]
		verts = case subobjectlevel of
		(
			1: polyOp.getVertSelection obj
			2: polyOp.getVertsUsingEdge obj (polyOp.getEdgeSelection obj)
			3: polyOp.getVertsUsingEdge obj (polyOp.getEdgeSelection obj)
			4: polyOp.getVertsUsingFace obj (polyOp.getFaceSelection obj)
			5: polyOp.getVertsUsingFace obj (polyOp.getFaceSelection obj)
			
		)
		
		for vert in verts do center += polyOp.getVert obj vert
		center / verts.numberSet
	)
	
	
	fn GetFacesNormal obj = 
	(
		faces = case subObjectLevel of
		(
			2: polyop.getFacesUsingEdge obj (polyop.getEdgeSelection obj)
			3: polyop.getFacesUsingEdge obj (polyop.getEdgeSelection obj)
			4: polyop.getFaceSelection obj
			5: polyop.getFaceSelection obj
		)
		
		facesDir = [0,0,0]
		for face in faces do facesDir += polyop.getFaceNormal obj face
		
		facesDir
	)
	
	
	fn SetWorkingPivot dir dirUp = 
	(
		pos = getSubObjCenter $
		WorkingPivot.setTM  (orthogonalize (matrix3 (cross dirUp dir) dirUp dir pos))
	)
	
	
	
	fn SetWorkingPivotFromVerts = 
	(
		objSnap = snapshotasmesh $
		dir = [0,0,0]
		for vert in ((getVertSelection objSnap) as array) do dir += getNormal objSnap vert

		edges = (polyOp.getEdgesUsingVert $ (polyOp.getVertSelection $) as array)[1]
		vertsPos = for i in (polyop.getVertsUsingEdge $ edges) collect (polyop.getVert $ i)
		dirUp = normalize (vertsPos[2] - vertsPos[1])

		SetWorkingPivot dir dirUp
	)
	
	
	fn SetWorkingPivotFromEdges = 
	(
		vertsPos = for i in (polyop.getVertsUsingEdge $ (polyop.getEdgeSelection $)) collect (polyop.getVert $ i)
		dir = normalize (vertsPos[2] - vertsPos[1])
			
		SetWorkingPivot dir (GetFacesNormal $)
	)
	
	
	fn SetWorkingPivotFromFaces = 
	(
		edges = (polyOp.getEdgesUsingFace $ (polyOp.getFaceSelection $) as array)[1]
		vertsPos = for i in (polyop.getVertsUsingEdge $ edges) collect (polyop.getVert $ i)
		dirUp = normalize (vertsPos[2] - vertsPos[1])
		
		dir = GetFacesNormal $
		dirUp = ((dot dir dirUp) * -dir + dirUp)
		
		SetWorkingPivot dir dirUp
	)



	
	
	fn SetWorkingPivotPos = 
	(
		local pos
		case subObjectLevel of
		(
			0: pos = $.pos
			1: if ((polyOp.GetVertSelection $) as array).count != 0 then getSubObjCenter $
			2: if ((polyOp.GetEdgeSelection $) as array).count != 0 then getSubObjCenter $
			3: if ((polyOp.GetEdgeSelection $) as array).count != 0 then getSubObjCenter $
			4: if ((polyOp.GetFaceSelection $) as array).count != 0 then getSubObjCenter $
			5: if ((polyOp.GetFaceSelection $) as array).count != 0 then getSubObjCenter $
		)
		
		if pos != undefined then 
		(
			WorkingPivot.UseMode = false
			
			matrix = WorkingPivot.getTM()
			matrix.translation = pos
			WorkingPivot.setTM matrix
			
			WorkingPivot.UseMode = true
		)
	)
	
	
	fn UpdateWpPos ev nd = SetWorkingPivotPos()


	fn AddCallback = 
	(
		SetWorkingPivotPosCB = NodeEventCallback mouseUp:true subobjectSelectionChanged:UpdateWpPos geometryChanged:UpdateWpPos controllerOtherEvent:UpdateWpPos
	)
	
	
	on setWpBtn pressed do
	(
		WorkingPivot.UseMode = false
			
		case subObjectLevel of
		(
			0: WorkingPivot.setTM ($.transform)
			1: SetWorkingPivotFromVerts()
			2: SetWorkingPivotFromEdges()
			3: SetWorkingPivotFromEdges()
			4: SetWorkingPivotFromFaces()
			5: SetWorkingPivotFromFaces()
		)
		
		
		wpBtn.state = WorkingPivot.UseMode = true
		AddCallback()
	)
	
	
	on wpBtn changed state do 
	(
		WorkingPivot.UseMode = state
		
		if state then 
		(
			SetWorkingPivotPos()
			AddCallback()
		)
		else 
		(
			SetWorkingPivotPosCB = undefined
			gc light:true
		)
	)
		
	
	
	
)
createDialog Roll 188 50 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)