(
	
-- 	fn GetModifierStackCurrentIndex = 
-- 	(
-- 		curObj = modPanel.getCurrentObject()
-- 		if curObj != $.baseObject 
-- 			then modPanel.getModifierIndex $ curObj - 1
-- 			else $.modifiers.count
-- 	)
	
	
	fn GetModifierStackCurrentIndex obj = 
	(
		if obj != $.baseObject 
			then modPanel.getModifierIndex $ obj - 1
			else $.modifiers.count
	)
	
	fn getSsAsMesh index =
	(
		_copy = copy $
		 for i = 1 to index do deleteModifier _copy _copy.modifiers[1]
		ss = snapshotAsMesh _copy
		delete _copy
		ss
	)


	fn getSsAsPoly index =
	(
		_copy = copy $
		 for i = 1 to index do deleteModifier _copy _copy.modifiers[1]
		ep = convertToPoly (snapshot _copy)
		delete _copy
		ep
	)


	fn GetSubObjCenter obj  =
	(
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
		center / verts.numberSet
	)
	
	
	fn GetFacesNormal obj = 
	(
		faces = case subObjectLevel of
		(
			2: polySwitch.getFacesUsingEdge obj (polySwitch.getEdgeSelection obj)
			3: polySwitch.getFacesUsingEdge obj (polySwitch.getEdgeSelection obj)
			4: polySwitch.getFaceSelection obj
			5: polySwitch.getFaceSelection obj
		)
		
		facesDir = [0,0,0]
		for face in faces do facesDir += polySwitch.getFaceNormal obj face
		
		facesDir
	)
	
	
	fn SetWorkingPivot matrix = 
	(
		WorkingPivot.UseMode = false
		WorkingPivot.setTM (orthogonalize matrix)
		WorkingPivot.UseMode = true
	)
	
	
	fn SetCurrentObject index obj lvl = 
	(
		modPanel.setCurrentObject (if index != obj.modifiers.count then obj.modifiers[index + 1] else obj.baseObject) node:obj
		subobjectlevel = lvl
	)
		

	fn SetWorkingPivotFromEdge obj =
	(
		dirUp = pos = [0, 0, 0]
		edge = getEdgeSelection obj

		vertsPos = for i in (meshop.getVertsUsingEdge obj edge) collect (getVert obj i)
		dir = normalize (vertsPos[1] - vertsPos[2])

		for face in (meshop.getFacesUsingEdge obj edge) do dirUp += (getFaceNormal obj face)
		dirUp = ((dot dir dirUp) * -dir + dirUp)
		
		for v in vertsPos do pos += v

		SetWorkingPivot (matrix3 dir (cross dir -dirUp) -dirUp (pos / vertsPos.count)) 

		format "edge: %\n" edge
	)



	fn SetWorkingPivotFromFaces obj =
	(
		dirUp = pos = [0, 0, 0]

		faces = getFaceSelection obj
		edges = meshop.getEdgesUsingFace obj faces

		vertsPos = for i in (meshop.getVertsUsingEdge obj edges) collect (getVert obj i)
		dir = normalize (vertsPos[1] - vertsPos[2])

		for face in faces do dirUp += (getFaceNormal obj face)

		for v in vertsPos do pos += v

		SetWorkingPivot (matrix3 (cross dir dirUp) dir dirUp (pos / vertsPos.count)) 
	)


	
	
	fn SetWorkingPivotFrom =
	(
		obj = $
		index = GetModifierStackCurrentIndex (modPanel.getCurrentObject())
		case subobjectlevel of
		(
-- 			0:
-- 			1:
			2: (SetWorkingPivotFromEdge (getSsAsMesh index); SetCurrentObject index obj 2)
			3: (SetWorkingPivotFromEdge (getSsAsMesh index); SetCurrentObject index obj 3)
			4: (SetWorkingPivotFromFaces (getSsAsMesh index); SetCurrentObject index obj 4)
-- 			5:
		)			
	)



	SetWorkingPivotFrom()

)



-- getEdgeVerts