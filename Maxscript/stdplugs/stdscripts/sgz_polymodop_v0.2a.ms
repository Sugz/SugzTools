/*##############################################################################
Modifications from original:
 - getFirstItem(): Source: DenisT: http://forums.cgsociety.org/archive/index.php?t-1033451.html
 - getSsAsMesh()
 - polyModOp.setCurrentObject()

###############################################################################*/


global polyModOp
(
	local version = "0.2a"

	struct vertInfo (id, dist)

	fn cotg a b c =
	(
		local ba = a - b
		local bc = c - b
		(dot bc ba) / length (cross bc ba)
	)

	fn getOffsetVal arr pos offset =
		arr[mod (pos + offset - 1) arr.count + 1]


	fn getFirstItem bitArr =
	(
		local b
		for n in bitArr while (b = n; off) do ()
		b
	)
	

	fn getCountFn level = case level of
	(
		#Vertex: polyModOp.getNumVerts
		#Edge: polyModOp.getNumEdges
		#Face: polyModOp.getNumFaces
	)

	fn getSelFn level = case level of
	(
		#Vertex: polyModOp.getVertSelection
		#Edge: polyModOp.getEdgeSelection
		#Face: polyModOp.getFaceSelection
	)

	fn getListData obj list level keep:off = case classOf list of
	(
		BitArray : list
		Integer : #{list}
		Array : if keep then list else list as bitArray
		Name : case list of
		(
			#all : #{1 .. (getCountFn level) obj}
			#selection : (getSelFn level) obj
			default : #{}
		)
		default: #{}
	)

	fn executeGlobal expr =
	(
		local prevShow = showEndResult
		if prevShow do enableShowEndRes off
		local value = execute expr
		enableShowEndRes prevShow
		value
	)

	fn setSelection obj list level switchBack:on =
	(
		local prevSO = obj.getEPolySelLevel()
		obj.setEPolySelLevel level
		list = getListData obj list level

		obj.setEPolySelLevel level
		obj.setSelection level #{}
		obj.select level list node:undefined

		if switchBack do obj.SetEPolySelLevel prevSO
	)

	fn applyInParent obj func param =
	(
		local prevCoordsys = getRefCoordSys()

		setRefCoordsys #parent
		local returnVal = if isKindOf param DataPair then func param.v1 (param.v2 * obj.GetNodeTM())
		                  else func param * inverse (obj.GetNodeTM())
		setRefCoordsys prevCoordsys

		returnVal
	)

	fn applyOperation obj list level operation params:#() =
	(
		local prevSO = obj.getEPolySelLevel()
		local prevSel = obj.getSelection level

		setSelection obj list level switchBack:off

		obj.SetOperation operation
		for param in params do setProperty obj param.v1 param.v2
		obj.Commit()

		setSelection obj prevSel level switchBack:off
		obj.SetEPolySelLevel prevSO
		OK
	)

	fn applyFunction obj list level func params:#() revertSel:on =
	(
		local prevSO = obj.getEPolySelLevel()
		local prevSel = obj.getSelection level

		setSelection obj list level switchBack:off

		local returnVal = case params.count of
		(
			1: func params[1]
			2: func params[1] params[2]
			3: func params[1] params[2] params[3]
		)
		obj.Commit()

		if revertSel do setSelection obj prevSel level switchBack:off
		obj.SetEPolySelLevel prevSO
		returnVal
	)

	mapped fn moveVertHelper vert offset obj: node: =
		polyModOp.setVert obj vert (polyModOp.getVert obj vert + offset) node:node

	-- Generalized Barycentric Coordinates on Irregular Polygons
	-- Meyer, M., Barr, A., Lee, H. and Desbrun, M. [2002], J. Graphics Tools, 7 (1):
	fn getBaryCoords obj face pos node:undefined =
	(
		local verts = polyModOp.getFaceVerts obj face node:node
		local vertPos = for vert in verts collect polyModOp.getVert obj vert node:node
		local degree = verts.count
		local weightSum = 0
		local weights = for i = 1 to degree collect
		(
			local curr = vertPos[i]
			local prev = getOffsetVal vertPos i (degree - 1)
			local next = getOffsetVal vertPos i 1
			local weight = (cotg pos curr prev + cotg pos curr next) / (length (pos - curr))^2
			weightSum += weight
			weight
		)
		for weight in weights collect weight/weightSum
	)

	fn getFaceOutline obj faceList =
	(
		faceList = getListData obj faceList 3
		local edges = polyModOp.getEdgesUsingFace obj faceList
		(for edge in edges where (polyModOp.getFacesUsingEdge obj edge * faceList).numberSet == 1 collect edge) as bitArray
	)

	fn cut obj level item start destination projDir node:undefined =
	(
		if node != undefined do
		(
			start *= inverse (obj.GetNodeTM node:node)
			destination *= inverse (obj.GetNodeTM node:node)
			projDir *= inverse (obj.GetNodeTM node:node)
		)

		obj.StartCut level item start projDir
		obj.SetCutEnd destination
		obj.Commit()
		obj.GetLastCutEnd()
	)

	fn cap obj edgeList =
	(
		while NOT edgeList.isEmpty do
		(
			local edge = getFirstItem edgeList
			local edgesDone = #{edge}
			local verts = polyModOp.getEdgeVerts obj edge

			while verts[verts.count] != verts[1] do
			(
				local nextEdge = getFirstItem (polyModOp.getEdgesUsingVert obj verts[verts.count] * edgeList - edgesDone)
				append edgesDone nextEdge
				append verts (obj.getEdgeVertex nextEdge 2 node:undefined)
			)

			edgeList -= edgesDone

			if polyModOp.createPolygon obj verts == undefined do
				polyModOp.createPolygon obj (for i = verts.count to 1 by -1 collect verts[i])
		)
		obj.commit()
		true -- it presumably didn't fail creating polygons when we got to call this fn
	)

	fn getBordersFromEdges obj edgeList borders:#{} =
	(
		-- TODO: doesn't handle MN_DEAD edges (unlike polyop which returns undefined)
		-- is it worth the 'where' condition here? Do dead edges appear in EPoly mod?

		for edge in edgeList do edgeList -= (borders += polyModOp.getBorderFromEdge obj edge)
		borders
	)


	

	struct polyModOp
	(

		fn setCurrentObject obj = 
		(
			setCommandPanelTaskMode #modify
			curObj = obj
			if not (isKindOf curObj Edit_Poly or isKindOf curObj Editable_Poly) then 
			(
				for _mod in obj.modifiers while curObj == obj do 
				(
					if isKindOf _mod Edit_Poly 
						then modPanel.setCurrentObject (curObj = _mod)
						else modPanel.setCurrentObject (curObj = obj.baseobject)
				)
			)
			curObj
		),


		fn getSsAsMesh obj = 
		(
			_copy = copy obj
			for _mod in _copy.modifiers do 
				if not isKindOf _mod Edit_Poly then deleteModifier _copy _mod
			
			collapseStack _copy
			ss = snapshotAsMesh _copy
			delete _copy
				
			ss
		),


		fn getNumVerts obj =
			obj.getNumVertices(),

		fn getNumEdges obj =
			obj.getNumEdges(),

		fn getNumFaces obj =
			obj.getNumFaces(),

		fn getVertsUsingEdge obj edgeList node:undefined vertList:#{} =
		(
			edgeList = getListData obj edgeList 2
			obj.getVertsUsingEdge &vertList &edgeList node:node
			vertList
		),

		fn getVertsUsingFace obj faceList node:undefined vertList:#{} =
		(
			faceList = getListData obj faceList 3
			obj.getVertsUsingFace &vertList &faceList node:node
			vertList
		),

		fn getEdgesUsingVert obj vertList node:undefined edgeList:#{} =
		(
			vertList = getListData obj vertList 1
			obj.getEdgesUsingVert &edgeList &vertList node:node
			edgeList
		),

		fn getEdgesUsingFace obj faceList =
		(
			local edges = #{}
			edges.count = polyModOp.getNumEdges obj
			faceList = getListData obj faceList 3

			for face in faceList do join edges (polyModOp.getFaceEdges obj face as bitarray)
			edges
		),

		fn getFacesUsingVert obj vertList node:undefined faceList:#{} =
		(
			vertList = getListData obj vertList 1
			obj.getFacesUsingVert &faceList &vertList node:node
			faceList
		),

		fn getFacesUsingEdge obj edgeList node:undefined faceList:#{} =
		(
			edgeList = getListData obj edgeList 2
			obj.getFacesUsingEdge &faceList &edgeList node:node
			faceList
		),

		fn getElementsUsingFace obj faceList node:undefined fence:#{} elementList:#{} =
		(
			faceList = getListData obj faceList 3
			obj.getElementsUsingFace &elementList &faceList &fence node:node
			elementList
		),

		fn getEdgeVerts obj edge =
		(
			#(obj.getEdgeVertex edge 1,
			  obj.getEdgeVertex edge 2 node:undefined)
		),

		fn getEdgeFaces obj edge =
			for i = 1 to 2 where (local face = obj.getEdgeFace edge i node:undefined) > 0 collect face,

		fn getFaceVerts obj face =
		(
			local vertCount = polyModOp.getFaceDeg obj face
			for i = 1 to vertCount collect obj.getFaceVertex face i node:undefined
		),

		fn getFaceEdges obj face =
		(
			local vertCount = polyModOp.getFaceDeg obj face
			for i = 1 to vertCount collect obj.getFaceEdge face i node:undefined
		),

		fn getBorderFromEdge obj edge =
		(
			local borders = polyModOp.getOpenEdges obj
			if borders[edge] then
			(
				local prevCount, count = 1
				local border = #{edge}
				local verts = #{}

				do
				(
					prevCount = count
					verts = polyModOp.getVertsUsingEdge obj border - verts
					join border (borders * (polyModOp.getEdgesUsingVert obj verts))
					count = border.numberSet
				)
				while count > prevCount

				border
			)
			else #{}
		),

		fn getVertsUsedOnlyByFaces obj faceList =
		(
			faceList = getListData obj faceList 3
			polyModOp.getVertsUsingFace obj faceList - \
			polyModOp.getVertsUsingEdge obj (polyModOp.getFaceOutline obj faceList)
		),

		fn getFaceNormal obj face =
			obj.getFaceNormal face,

		fn getFaceCenter obj face =
			obj.getFaceCenter face,

		fn getFaceArea obj face =
			obj.getFaceArea face,

		fn getFaceDeg obj face =
			obj.getFaceDegree face,

		fn getOpenEdges obj =
			obj.getOpenEdges(),

		fn getVertSelection obj =
			obj.getSelection #Vertex,

		fn getEdgeSelection obj =
			obj.getSelection #Edge,

		fn getFaceSelection obj =
			obj.getSelection #Face,

		fn setVertSelection obj vertList =
			setSelection obj vertList #Vertex,

		fn setEdgeSelection obj edgeList =
			setSelection obj edgeList #Edge,

		fn setFaceSelection obj faceList =
			setSelection obj faceList #Face,

		fn getVertFlags obj vert =
			obj.getVertexFlags vert,

		fn getEdgeFlags obj edge =
			obj.getEdgeFlags edge,

		fn getFaceFlags obj face =
			obj.getFaceFlags face,

		fn getVertsByFlag obj flag mask:0 vertList:#{} =
		(
			obj.getVerticesByFlag &vertList flag flagMask:mask node:undefined
			vertList
		),

		fn getEdgesByFlag obj flag mask:0 edgeList:#{} =
		(
			obj.getEdgesByFlag &edgeList flag flagMask:mask node:undefined
			edgeList
		),

		fn getFacesByFlag obj flag mask:0 faceList:#{} =
		(
			obj.getFacesByFlag &faceList flag flagMask:mask node:undefined
			faceList
		),

		fn setVertFlags obj vertList flag mask:0 undoable:off =
		(
			vertList = getListData obj vertList 1
			obj.setVertexFlags &vertList flag flagMask:mask generateUndoRecord:undoable node:undefined
		),

		fn setEdgeFlags obj edgeList flag mask:0 undoable:off =
		(
			edgeList = getListData obj edgeList 2
			obj.setEdgeFlags &edgeList flag flagMask:mask generateUndoRecord:undoable node:undefined
		),

		fn setFaceFlags obj faceList flag mask:0 undoable:off =
		(
			faceList = getListData obj faceList 3
			obj.setFaceFlags &faceList flag flagMask:mask generateUndoRecord:undoable node:undefined
		),

		fn getVert obj vert node:undefined =
			if node == undefined then applyInParent obj obj.getVertex vert
			else obj.getVertex vert node:node,

		fn setVert obj vertList vertPos node:undefined instantCommit:on =
		(
			vertList = getListData obj vertList 1 keep:(isKindOf vertPos Array)

			case classOf vertPos of
			(
				Point3 : if node == undefined then applyInParent obj obj.setVert (dataPair vertList vertPos)
				         else obj.setVert &vertList &vertPos node:node
				Array : if vertList.numberSet == vertPos.count do
				(
					local counter = 0
					if node == undefined then for vert in vertList do applyInParent obj obj.setVert (dataPair #{vert} vertPos[counter += 1])
					else for vert in vertList do obj.setVert #{vert} vertPos[counter += 1] node:node
				)
			)
			if instantCommit do obj.Commit()
		),

		fn moveVert obj vertList vertOffset node:undefined useSoftSel:off instantCommit:on =
		(
			vertList = getListData obj vertList 1 keep:(isKindOf vertOffset array)

			-- TODO: useSoftSel --> if useSoftSel then vertOffset * softSelVal[vert] else vertOffset

			case classOf vertOffset of
			(
				Point3 : moveVertHelper (vertList as array) vertOffset obj:obj node:node
				Array : if vertList.numberSet == vertOffset.count do
				(	
					local counter = 0
					for vert in vertList do moveVertHelper vert vertOffset[counter += 1] obj:obj node:node
				)
			)
			if instantCommit do obj.Commit()
		),

		fn createVert obj pos node:undefined =
		(
			local index = obj.createVertex (if node == undefined then pos else pos * inverse (obj.getNodeTM node:node)) node:node
			obj.Commit()
			index
		),

		fn createEdge obj vert1 vert2 =
		(
			local index = obj.createEdge vert1 vert2 node:undefined
			obj.commit()
			index
		),

		fn createPolygon obj verts =
		(
			local index = obj.createFace verts node:undefined
			obj.commit()
			index
		),

		fn capHolesByVert obj vertList =
		(
			local candidates = polyModOp.getOpenEdges obj * polyModOp.getEdgesUsingVert obj (getListData obj vertList 1)
			if candidates.numberSet > 0 then
				cap obj (getBordersFromEdges obj candidates)
			else false
		),

		fn capHolesByEdge obj edgeList =
		(
			local candidates = polyModOp.getOpenEdges obj * getListData obj edgeList 2
			if candidates.numberSet > 0 then
				cap obj (getBordersFromEdges obj candidates)
			else false
		),

		fn capHolesByFace obj faceList =
		(
			local candidates = polyModOp.getOpenEdges obj * polyModOp.getEdgesUsingFace obj (getListData obj faceList 3)
			if candidates.numberSet > 0 then
				cap obj (getBordersFromEdges obj candidates)
			else false
		),

		fn breakVerts obj vertList =
			applyOperation obj vertList #Vertex #BreakVertex,

		fn splitEdges obj edgeList =
			applyOperation obj edgeList #Edge #SplitEdges,

		fn divideEdge obj edge fraction node:undefined =
		(
			applyFunction obj edge #Edge obj.divideEdge params:#(edge, fraction) revertSel:off
			obj.getNumVertices()
		),

		fn divideFace obj face pos node:undefined =
		(
			applyFunction obj edge #Face obj.divideFace params:#(face, polyModOp.getBaryCoords obj face pos node:node) revertSel:off
			obj.getNumFaces()
		),

		fn weldVerts obj vert1 vert2 pos node:undefined =
		(
			-- TODO: check if 'only vertices connected by an edge can be welded' applies here

			polyModOp.setVert obj vert2 pos node:node
			applyFunction obj edge #Face obj.weldVertices params:#(face, vert2) revertSel:off
		),

		fn setDiagonal obj face vert1 vert2 =
		(
			obj.setDiagonal vert1 vert2
			obj.commit()
		),

		fn getFaceMatID obj face =
			obj.getFaceMaterial face,

		fn setFaceMatID obj faceList matID =
			applyOperation obj faceList #Face #SetMaterial params:#(
				dataPair #MaterialIDtoSet (matID - 1)),

		fn getFaceSmoothGroup obj face =
			obj.getFaceSmoothingGroups face,

		fn setFaceSmoothGroup obj faceList smoothGroups add:off =
			applyOperation obj faceList #Face #SetSmooth params:#(
				dataPair #SmoothingGroupsToSet smoothGroups,
				dataPair #SmoothingGroupsToClear (if add then 0 else -1)),

		fn getMapVert obj mapChannel vert =
			obj.getMapVertex mapChannel vert,

		fn isVertDead obj vert =
			bit.get (polyModOp.getVertFlags obj vert) 2,

		fn isEdgeDead obj edge =
			bit.get (polyModOp.getEdgeFlags obj edge) 2,

		fn isFaceDead obj face =
			bit.get (polyModOp.getFaceFlags obj face) 2,

		fn getDeadVerts obj =
			polyModOp.getVertsByFlag obj 2L,

		fn getDeadEdges obj =
			polyModOp.getEdgesByFlag obj 2L,

		fn getDeadFaces obj =
			polyModOp.getFacesByFlag obj 2L,

		fn getHasDeadStructs obj =
		(
			local res = 0
			bit.set res 1 ((polyModOp.getDeadVerts obj).numberSet > 0)
			bit.set res 2 ((polyModOp.getDeadEdges obj).numberSet > 0)
			bit.set res 3 ((polyModOp.getDeadFaces obj).numberSet > 0)
			res
		),

		fn getHiddenVerts obj =
			polyModOp.getVertsByFlag obj 16L,

		fn getHiddenFaces obj =
			polyModOp.getFacesByFlag obj 16L,

		fn getNumMaps obj =
			obj.getNumMapChannels,

		fn getNumMapVerts obj mapChannel =
			obj.getNumMapVertices mapChannel,

		fn getEdgeVis obj edge =
			bit.get (polyModOp.getEdgeFlags obj edge) 9,

		fn setEdgeVis obj edgeList bool =
		(
			local edges = getListData obj edgeList 2
			local flag = if bool then 256 else 0

			for edge in edges do polyModOp.setEdgeFlags obj edge flag mask:256
			notifyDependents partIDmsg:#display

			return OK
		),

		fn getSafeFaceCenter obj face node:undefined =
			executeGlobal "polyOp.getSafeFaceCenter $ face node:node",

		fn isMeshFilledIn obj =
			executeGlobal "polyOp.isMeshFilledIn $",
		
		fn getMapSupport obj mapChannel =
			executeGlobal "polyOp.getMapSupport $ mapChannel",

		fn getNumMapFaces obj mapChannel =
			executeGlobal "polyOp.getNumMapFaces $ mapChannel",

		fn getMapFace obj mapChannel index =
			for corner = 1 to (polyModOp.getFaceDeg obj index) collect
				obj.getMapFaceVert mapChannel index corner node:undefined,

		fn flipNormals obj faceList =
			applyOperation obj faceList #Face #FlipFace,

		fn weldEdges obj edge1 edge2 =
			obj.weldEdges edge1 edge2,

		fn weldVertsByThreshold obj vertList =
			applyOperation obj vertList #Vertex #WeldVertex,

		fn weldEdgesByThreshold obj edgeList =
			applyOperation obj edgeList #Edge #WeldEdge,

		fn collapseVerts obj vertList =
			applyOperation obj vertList #Vertex #CollapseVertex,

		fn collapseEdges obj edgeList =
			applyOperation obj edgeList #Edge #CollapseEdge,

		fn collapseFaces obj faceList =
			applyOperation obj faceList #Face #CollapseFace,

		fn deleteIsoVerts obj =
			applyOperation obj #{} #Vertex #RemoveIsoVerts,

		fn deleteVerts obj vertList =
			applyOperation obj vertList #Vertex #DeleteVertex,

		fn deleteFaces obj faceList delIsoVerts:on =
			applyOperation obj faceList #Face #DeleteFace params:#(
				dataPair #DeleteIsolatedVerts delIsoVerts),

		fn deleteEdges obj edgeList delIsoVerts:on =
			applyOperation obj edgeList #Edge #DeleteEdge params:#(
				dataPair #DeleteIsolatedVerts delIsoVerts),

		fn retriangulate obj faceList =
			applyOperation obj faceList #Face #Retriangulate,

		fn setHiddenVerts obj vertList =
			applyOperation obj vertList #Vertex #HideVertex,

		fn setHiddenFaces obj faceList =
			applyOperation obj faceList #Face #HideFace,

		fn unHideAllVerts obj =
			applyOperation obj #{} #Vertex #UnhideAllVertex,

		fn unHideAllFaces obj =
			applyOperation obj #{} #Face #UnhideAllFace,

		fn autoSmooth obj =
			applyOperation obj #selection #Face #AutoSmooth,

		fn extrudeFaces obj faceList amount =
			applyOperation obj faceList #Face #ExtrudeFace params:#(
				dataPair #ExtrudeFaceHeight amount),

		fn bevelFaces obj faceList height outline =
			applyOperation obj faceList #Face #Bevel params:#(
				dataPair #BevelHeight height,
				dataPair #BevelOutline outline),

		fn chamferVerts obj vertList amount =
			applyOperation obj vertList #Vertex #ChamferVertex params:#(
				dataPair #ChamferVertexAmount amount),

		fn chamferEdges obj edgeList amount =
			applyOperation obj edgeList #Edge #ChamferEdge params:#(
				dataPair #chamferEdgeAmount amount),

		fn makeVertsPlanar obj vertlist =
			applyOperation obj vertList #Vertex #MakePlanar,

		fn makeEdgesPlanar obj edgelist =
			applyOperation obj edgeList #Edge #MakePlanar,

		fn makeFacesPlanar obj faceList =
			applyOperation obj faceList #Face #MakePlanar,

		fn moveVertsToPlane obj vertList planeNormal planeOffset node:undefined =
			applyOperation obj vertList #Vertex #Align params:#(
				dataPair #AlignPlaneNormal planeNormal,
				dataPair #AlignPlaneOffset planeOffset),

		fn moveEdgesToPlane obj edgeList planeNormal planeOffset node:undefined =
			applyOperation obj edgeList #Edge #Align params:#(
				dataPair #AlignPlaneNormal planeNormal,
				dataPair #AlignPlaneOffset planeOffset),

		fn moveFacesToPlane obj faceList planeNormal planeOffset node:undefined =
			applyOperation obj faceList #Face #Align params:#(
				dataPair #AlignPlaneNormal planeNormal,
				dataPair #AlignPlaneOffset planeOffset),

		fn attach obj source targetNode:undefined sourceNode:undefined =
		(
			-- TODO: targetNode/sourceNode transform
			-- If <source> or <poly> is not a node value, the corresponding targetNode: or sourceNode: must be specified. 

			obj.attach source editPolyNode:sourceNode
			obj.commit()
		),

		fn detachFaces obj faceList delete:true asNode:false name:"Object01" node:undefined =
		(
			-- TODO: how to access and change .asnode? -- duplicating would be possible but there should be a way
			-- TODO: how to access and change .delete? -- dtto

			applyFunction obj faceList #Face obj.detachToObject params:#(name) revertSel:off
		),

		fn createShape obj edgeList smooth:off name:(uniqueName "Shape") node:undefined =
		(
			-- TODO: how to access and change .smooth?

			applyFunction obj edgeList #Edge obj.createShape params:#(name) revertSel:off
		),

		fn meshSmoothByVert obj vertList =
			applyOperation obj vertList #Vertex #MeshSmooth,

		fn meshSmoothByEdge obj edgeList =
			applyOperation obj edgeList #Edge #MeshSmooth,

		fn meshSmoothByFace obj faceList =
			applyOperation obj faceList #Face #MeshSmooth,

		fn tessellateByVert obj vertList =
			applyOperation obj vertList #Vertex #Tessellate,

		fn tessellateByEdge obj edgeList =
			applyOperation obj edgeList #Edge #Tessellate,

		fn tessellateByFace obj faceList =
			applyOperation obj faceList #Face #Tessellate,

		fn getSlicePlane obj &size: =
		(
			-- TODO: what's the size parameter? obj.GetSlicePlaneTM.scale?

			obj.getSlicePlane &planeNormal &planeCenter
			ray planeCenter planeNormal
		),

		fn setSlicePlane obj planeRay size = -- TODO: dtto - size?
			setSlicePlane &planeRay.dir &planeRay.pos,

		fn slice obj faceList planeRay =
		(
			polyModOp.setSlicePlane obj planeRay size
			applyOperation obj faceList #Face #SliceSelectedFaces
		),

		fn inSlicePlaneMode obj =
			obj.inSlicePlaneMode(),

		fn resetSlicePlane obj =
			obj.resetSlicePlane(),

		fn cutVert obj startVert destination projDir node:undefined =
			cut obj #Vertex startVert [0,0,0] destination projDir node:node,

		fn cutFace obj face start destination projDir node:undefined =
			cut obj #Face face start destination projDir node:node
	)

	format "PolyModOp v% initialized.\n" version
)