try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	button setWpBtn "Set WP" across:2
	checkbutton wpBtn "Use WP"
	
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
	
	
	fn SetWorkingPivotPos ev nd = 
	(
		updateWP = false
		case subObjectLevel of
		(
			0: updateWP = false
			1: if ((polyOp.GetVertSelection $) as array).count != 0 then updateWP = true
			2: if ((polyOp.GetEdgeSelection $) as array).count != 0 then updateWP = true
			3: if ((polyOp.GetEdgeSelection $) as array).count != 0 then updateWP = true
			4: if ((polyOp.GetFaceSelection $) as array).count != 0 then updateWP = true
			5: if ((polyOp.GetFaceSelection $) as array).count != 0 then updateWP = true
		)
		
		if updateWP then 
		(
			WorkingPivot.UseMode = false
			matrix = WorkingPivot.getTM()
			matrix.translation = getSubObjCenter $
			WorkingPivot.setTM matrix
			WorkingPivot.UseMode = true
		)
		
	)
	
	
	on setWpBtn pressed do
	(
		WorkingPivot.UseMode = false
			
		case subObjectLevel of
		(
			0: WorkingPivot.resetTMToNode $
			1: SetWorkingPivotFromVerts()
			2: SetWorkingPivotFromEdges()
			3: SetWorkingPivotFromEdges()
			4: SetWorkingPivotFromFaces()
			5: SetWorkingPivotFromFaces()
		)
		
		
		wpBtn.state = WorkingPivot.UseMode = true
-- 		SetWorkingPivotPosCB = NodeEventCallback mouseUp:true subobjectSelectionChanged:SetWorkingPivotPos
	)
	
	
	on wpBtn changed state do 
	(
		WorkingPivot.UseMode = state
		
		if state then()
-- 			then SetWorkingPivotPosCB = NodeEventCallback mouseUp:true subobjectSelectionChanged:SetWorkingPivotPos --geometryChanged:ResetWorkingPivotPos
		else 
		(
			SetWorkingPivotPosCB = undefined
			gc light:true
		)
	)
		
	
	
	
)
createDialog Roll 188 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)