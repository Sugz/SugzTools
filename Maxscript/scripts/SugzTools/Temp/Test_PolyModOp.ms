(
	local polySwitch
	
	
	fn SetPolySwitch =
	(
		if not isKindOf polyModOp structDef then
			if doesFileExist (file = @"C:\Program Files\Autodesk\3ds Max 2016\scripts\polymodop_v0.2a.ms") then filein file
			
		obj = modPanel.getCurrentObject()
		polySwitch = if isKindOf polyModOp structDef AND isKindOf obj Edit_Poly then polyModOp else polyOp
			
		obj
	)
	
	
	fn getSubObjCenter =
	(
		obj = SetPolySwitch()
		center = [0, 0, 0]
		verts = case subobjectlevel of
		(
			1: polySwitch.getVertSelection obj
			2: polySwitch.getVertsUsingEdge obj (polySwitch.getEdgeSelection obj)
			3: polySwitch.getVertsUsingEdge obj (polySwitch.getEdgeSelection obj)
			4: polySwitch.getVertsUsingFace obj (polySwitch.getFaceSelection obj)
			5: polySwitch.getVertsUsingFace obj (polySwitch.getFaceSelection obj)
			
		)
		
		for vert in verts do center += polySwitch.getVert obj vert
		(center / verts.numberSet) * $.transform
	)
	
	
	fn GetFacesNormal = 
	(
		obj = SetPolySwitch()
		faces = case subObjectLevel of
		(
			2: polySwitch.getFacesUsingEdge obj (polySwitch.getEdgeSelection obj)
			3: polySwitch.getFacesUsingEdge obj (polySwitch.getEdgeSelection obj)
			4: polySwitch.getFaceSelection obj
			5: polySwitch.getFaceSelection obj
		)
		
		facesDir = [0,0,0]
		format "faces: %\n" faces
		for face in faces do facesDir += polySwitch.getFaceNormal obj face
		
		facesDir
	)
	
	
	fn SetWorkingPivot dir dirUp = 
	(
		format "dir: % \ndirUp: %\n" dir dirUp
		
		pos = getSubObjCenter()
		WorkingPivot.setTM  (orthogonalize (matrix3 (cross dirUp dir) dirUp dir pos))
	)
	
	
	fn SetWorkingPivotFromEdges = 
	(
		obj = SetPolySwitch()
		vertsPos = for i in (polySwitch.getVertsUsingEdge obj (polySwitch.getEdgeSelection obj)) collect (polySwitch.getVert obj i)
		dir = normalize (vertsPos[2] - vertsPos[1])

		SetWorkingPivot dir (GetFacesNormal())
	)
	
	
	WorkingPivot.UseMode = false
	SetWorkingPivotFromEdges()
	WorkingPivot.UseMode = true
	
)