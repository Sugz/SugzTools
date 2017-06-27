(
	fn SetWorkingPivot dir dirUp = 
	(
		pos = ep.getSubObjCenter $
		WorkingPivot.setTM  (orthogonalize (matrix3 (cross dirUp dir) dirUp dir pos))
	)


	fn SetWorkingPivotFromEdges = 
	(
		vertsPos = for i in (ep.GetVertsUsingEdge $ (ep.getEdgeSelection $)) collect (ep.GetVert $ i)
		dir = normalize (vertsPos[2] - vertsPos[1])
			
		faces = ep.GetFacesUsingEdge $ (ep.GetEdgeSelection $)	
		facesDir = [0,0,0]
		for face in faces do facesDir += ep.GetFacesNormal $ face
		SetWorkingPivot dir facesDir
	)



	WorkingPivot.UseMode = false
	SetWorkingPivotFromEdges()
	WorkingPivot.UseMode = true

)