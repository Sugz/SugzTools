global ep
struct EditablePolyStc
(
	-- Source: DenisT: http://forums.cgsociety.org/archive/index.php?t-1033451.html
	fn firstBit arg = 
	(
		local b
		for n in arg while (b = n; off) do ()
		b
	),


	fn SetCurrentObject obj = 
	(
		setCommandPanelTaskMode #modify
		select obj
		curObj = modpanel.getCurrentObject()
		if not (isKindOf curObj Edit_Poly or isKindOf curObj Editable_Poly) then 
		(
			for _mod in obj.modifiers do 
			(
				if isKindOf _mod Edit_Poly 
					then modPanel.setCurrentObject _mod 
					else modPanel.setCurrentObject obj.baseobject
			)
			curObj = modpanel.getCurrentObject()
		)

		curObj
	),


	fn GetSnapShot obj = 
	(
		obj = copy obj
		modPanel.setCurrentObject obj
		for _mod in obj.modifiers do 
			if not isKindOf _mod Edit_Poly then deleteModifier obj _mod
				
		collapseStack obj
		ss = snapshotAsMesh obj
		delete obj
		ss
	),


	/* Vertex #########################################################################################################################################################################*/
	fn GetVert obj arg = 
	(
		-- curobject is in local space so polyOp.getVert need to be set back to world space: (polyOp.getVert curObj arg) * $.transform 
		try 
		(
			curObj = SetCurrentObject obj

			if (isKindOf arg Array AND arg.count > 1) OR (isKindOf arg BitArray AND arg.numberSet > 1) then 
			(
				case (classOf curObj) of 
				(
					Edit_Poly: for i in arg collect (curObj.GetVertex i)
					Editable_Poly: for i in arg collect (polyOp.getVert curObj i) * obj.transform
				)
			)
			else 
			(
				if (isKindOf arg Array) then arg = arg[1]
				if (isKindOf arg BitArray) then arg = firstBit arg
				case (classOf curObj) of 
				(
					Edit_Poly: curObj.GetVertex arg
					Editable_Poly: (polyOp.getVert curObj arg) * obj.transform 
				)
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in EditablePoly Library: GetVert()")
	),


	fn GetVertCount obj = 
	(
		try 
		(
			curObj = SetCurrentObject obj
			case (classOf curObj) of 
			(
				Edit_Poly: curObj.GetNumVertices()
				Editable_Poly: polyOp.getNumVerts curObj
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in EditablePoly Library: GetVertCount()")
	),


	fn GetVertSel obj = 
	(
		try 
		(
			curObj = SetCurrentObject obj
			case (classOf curObj) of 
			(
				Edit_Poly: curObj.GetSelection #vertex
				Editable_Poly: polyOp.GetVertSelection curObj
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in EditablePoly Library: GetVertSel()")
	),


	fn SetVertSel obj arg = 
	(
		
		try 
		(
			curObj = SetCurrentObject obj
			case (classOf curObj) of 
			(
				Edit_Poly: 
				(
					curObj.SetSelection #Vertex #{}
					curObj.Select #Vertex (_sgz._extMxs.AsBitArray arg)
				)
				Editable_Poly: polyOp.SetVertSelection curObj (_sgz._extMxs.AsBitArray arg)
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in EditablePoly Library: SetVertSel()")
	),


	fn GetVertsUsingEdge obj arg =
	(
		try
		(
			verts = #{}
			if (isKindOf arg Integer) then arg = #{arg}
			if (isKindOf arg Array) then arg = arg as BitArray

			curObj = SetCurrentObject obj
			verts = case (classOf curObj) of 
			(
				Edit_Poly: 
				(
					curObj.convertSelection #Edge #Vertex
					GetVertSel curObj
				)
				Editable_Poly: polyOp.getVertsUsingEdge curObj arg
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetVertsUsingEdge()")
	),


	fn GetVertsUsingFace obj arg =
	(
		try
		(
			verts = #{}
			if (isKindOf arg Integer) then arg = #{arg}
			if (isKindOf arg Array) then arg = arg as BitArray

			curObj = SetCurrentObject obj
			verts = case (classOf curObj) of 
			(
				Edit_Poly: 
				(
					curObj.convertSelection #Face #Vertex
					GetVertSel curObj
				)
				Editable_Poly: polyOp.getVertsUsingFace curObj arg
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetVertsUsingEdge()")
	),



	/* Edge #########################################################################################################################################################################*/
	fn GetEdgeSelection obj = 
	(
		try 
		(
			curObj = SetCurrentObject obj
			case (classOf curObj) of 
			(
				Edit_Poly: curObj.GetSelection #Edge
				Editable_Poly: polyOp.getEdgeSelection curObj
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetEdgeSel()")
	),


	




	/* Face #########################################################################################################################################################################*/
	fn GetFaceSelection obj = 
	(
		try 
		(
			curObj = SetCurrentObject obj
			case (classOf curObj) of 
			(
				Edit_Poly: curObj.GetSelection #Face
				Editable_Poly: polyOp.getFaceSelection curObj
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetFaceSelection()")
	),


	fn GetFacesUsingEdge obj arg = 
	(
		try
		(
			faces = #{}
			if (isKindOf arg Integer) then arg = #{arg}
			if (isKindOf arg Array) then arg = arg as BitArray

			curObj = SetCurrentObject obj
			faces = case (classOf curObj) of 
			(
				Edit_Poly: 
				(
					curObj.convertSelection #Edge #Face
					GetFaceSelection curObj
				)
				Editable_Poly: polyOp.getFacesUsingEdge curObj arg
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetVertsUsingEdge()")
	),


	fn GetFacesNormal obj arg = 
	(
		try 
		(
			curObj = SetCurrentObject obj
			if (isKindOf arg Array AND arg.count > 1) OR (isKindOf arg BitArray AND arg.numberSet > 1) then 
			(
				case (classOf curObj) of 
				(
					Edit_Poly:
					(
						ss = GetSnapShot obj
						for i in arg collect (GetFaceNormal ss i)
					)
					Editable_Poly: for i in arg collect polyOp.getFaceNormal curObj i
				)
			)
			else 
			(
				if (isKindOf arg Array) then arg = arg[1]
				if (isKindOf arg BitArray) then arg = firstBit arg
				case (classOf curObj) of 
				(
					Edit_Poly: GetFaceNormal (GetSnapShot obj) arg
					Editable_Poly: fNormal = polyOp.getFaceNormal curObj arg
				)
			)
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in EditablePoly Library: GetVert()")
	),






	/* General #########################################################################################################################################################################*/
	fn GetSubObjCenter obj  =
	(
		center = [0, 0, 0]
		verts = case subobjectlevel of
		(
			1: this.GetVertSel obj
			2: this.GetVertsUsingEdge obj (this.GetEdgeSelection obj)
			3: this.GetVertsUsingEdge obj (this.GetEdgeSelection obj)
			4: this.GetVertsUsingFace obj (this.GetFaceSelection obj)
			5: this.GetVertsUsingFace obj (this.GetFaceSelection obj)
			
		)
		for vert in verts do center += GetVert obj vert
		center / verts.numberSet
	)



)
ep = EditablePolyStc()