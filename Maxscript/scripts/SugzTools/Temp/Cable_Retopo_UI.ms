try(destroyDialog ::CylinderToSplineRoll) catch()
Rollout CylinderToSplineRoll "Cylinder To Spline"
(
	pickbutton pickBtn "Pick Reference" width:180 align:#center 
	button generateBtn "Generate Spline" width:180 align:#center offset:[0,-3] enabled:false
	label sidesLbl "Sides" align:#left offset:[-7,0] across:2
	spinner sidesSpn width:80 align:#right offset:[8,0] type:#integer range:[3, 12, 5]
	label distanceThresholdLbl "Distance Threshold" align:#left offset:[-7,0] across:2
	spinner distanceThresholdSpn width:80 align:#right offset:[8,0]  range:[0, 1000, 0.1]
	label angleThresholdLbl "Angle Threshold" align:#left offset:[-7,0] across:2
	spinner angleThresholdSpn width:80 align:#right offset:[8,0]  range:[0, 5, 2]
	
	local refObj
	local myShape
	
	fn getSubObjCenter verts =
	(
		center = [0, 0, 0]
		for vert in verts do center += polyOp.getVert refObj vert node:refObj
		center / verts.numberSet
	)


	fn GetFirstBit arg = 
	(
		local b
		for n in arg while (b = n; off) do ()
		b
	)


	fn SetRadius =
	(
		verts = polyop.getVertSelection refObj
		center = getSubObjCenter verts
		firstVert = GetFirstBit verts
		myShape.render_thickness = (distance (polyop.getVert refObj firstVert) center) * 2
	)
	
	
	fn GetKnotAngle spl index =
	(
		numK = numknots spl 1
		if not index > numK then
		(
			inxP = index - 1
			inxN = index + 1

			if inxP < 1 then inxP = numK
			if inxN > numK then inxN = 1

			pP = getknotpoint spl 1 inxP
			pC = getknotpoint spl 1 index
			pN = getknotpoint spl 1 inxN

			acos (dot (normalize (pP - pC)) (normalize (pN - pC)))
		)
		else 0
	)
	
	
	fn WeldKnots = 
	(
		if myShape != undefined and isValidObj myShape then
		(
			subobjectlevel = 1
			for i = 1 to numKnots myShape do setKnotSelection myShape 1 #(i) keep:true
			weldSpline myShape distanceThresholdSpn.value
			updateshape myShape
		)
	)
	
	
	fn DeleteKnotsByAngle = 
	(
		if myShape != undefined and isValidObj myShape then
		(
			for i = 1 to (numKnots myShape) do 
			(
				if (GetKnotAngle myShape i) + angleThresholdSpn.value >= 180 then deleteKnot myShape 1 i 
				i -= 1
			)
				
			updateshape myShape
		)
	)
	
	
	
	on pickBtn picked obj do
	(
		if IsValidObj obj then 
		(
			refObj = converttopoly obj
			pickBtn.caption = obj.name
			generateBtn.enabled = true
			
			max modify mode
			select refObj
			subobjectlevel = 1
		)
	)
	
	on generateBtn pressed do
	(
		max modify mode
		
		if not (polyop.getVertSelection refObj).numberSet >= 3 
			then MessageBox "Need to select at least 3 vertices"
		else 
		(
			oldVerts = #{}
			refObjVertsCount = polyop.getNumVerts refObj

			myShape = splineShape()
			addNewSpline myShape
			myShape.render_renderable = true
			myShape.render_displayRenderMesh = true
			myShape.render_mapcoords = true
			myShape.render_threshold = 89

			myShape.render_sides = sidesSpn.value
			SetRadius()

			-- Create the knot 
			while oldVerts.numberSet != refObjVertsCount do 
			(
				curVerts = polyop.getVertSelection refObj
				addKnot myShape 1 #corner #line (getSubObjCenter curVerts)
				oldVerts += curVerts
				refObj.growSelection()
				polyop.setVertSelection refObj ((polyop.getVertSelection refObj) - oldVerts)
			)
			
			updateshape myShape
			
			WeldKnots()
			DeleteKnotsByAngle()
			
			select myShape
			CenterPivot myShape
		)
	)


	on sidesSpn changed value do 
	(
		if myShape != undefined and isValidObj myShape then myShape.render_sides = value
	)
	
	
	on distanceThresholdSpn changed value do WeldKnots()

	on angleThresholdSpn changed value do DeleteKnotsByAngle()

	
	
)
createDialog CylinderToSplineRoll 188 115 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)