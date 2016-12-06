/*##############################################################################
SugzTools Modeling Library
Version 1.10
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Collection of functions to speed up the modeling workflow

# Required Components:
SugzTools Manager
SugzTools Selection Library
SugzTools Extend 3ds Max Library

# Sources:
HaywoodTools by James Haywood

# To do list:
Add support for Edit_Poly

# History:
1.10:
	- Add GetEdgeSelection()
	- Add GetVertsUsingEdge()
	- Add GetVerts()


*Use / Modify this script at your own risk !*
###############################################################################*/



struct ModelingLibraryStc
(
	
	/* Convert selection to editable poly without breaking instances ############################################################################################*/
	fn ConvertToEditPolyFn = 
	(
		/*<Function>
		Description:
			Convert selection to editable poly without breaking instances
		</Function>*/


		-- add editpoly modifier to the first instances of each object in the selection and collapse it
		for obj in (_sgz._sel.DeleteInstanceFromSelection()) do 
		(
			addModifier obj (Edit_Poly())
			maxOps.CollapseNodeTo obj 1 off
		)
	),
	
	
	
	/* Create a box that fit a boundingbox ############################################################################################*/
	fn CreateBbBoxFn obj segs:1 =
	(
		/*<Function>
		Description:
			Create a box that fit a boundingbox
		Arguments:
			<Object> obj: The object from which the boundingbox Box have to be created
			<Optional> <Integer> segs: define the number of segment of the box
		Return:
			<Object> bbBox: the boundingbox Box
		</Function>*/
		
		boundingBox = nodeGetBoundingBox obj obj.transform
		bbSize = boundingBox[2] - boundingBox[1]
		bbBox = box width:bbSize[1] length:bbSize[2] height:bbSize[3] widthsegs:segs lengthsegs:segs heightsegs:segs
		centerPivot bbBox
		bbBox.transform = obj.transform
		
		bbBox
	),
	
	
	
	/* Get a single snapshot ############################################################################################*/
	fn SingleSnapShotFn objs = 
	(
		/*<Function>
		Description:
			Get a single snapshot
		Arguments:
			<Array> objs: Objects to make a snapshot of
		Return:
			<Object> ss: The snapshot 
		</Function>*/
		
		local ss 									
		
		-- Snapshot for one object
		if objs.count == 1 then			
		(
			ss = snapshot objs[1]
			resetPivot ss
			centerPivot ss
		)
		
		-- Create a snapshot for each object then merge them into one mesh
		else 										
		(
			snapShotArray = for obj in objs collect (SingleSnapShotFn #(obj))
			ss = Editable_Mesh()
			for i = 1 to snapShotArray.Count do 
			(
				if canConvertTo snapShotArray[i] Mesh then 
					meshop.attach ss snapShotArray[i]
				else
				(
					meshop.attach ss (CreateBbBoxFn snapShotArray[i])
					delete snapShotArray[i]
				)
				
			)
			centerPivot ss
		)
		
		ss
	),
	
	
	
	/* Return the size of a bouding box ############################################################################################*/
	fn WorldBBoxMinMaxFn nodes =
	(
		/*<Function>
		Description:
			Return the size of a bouding box
		Arguments:
			<Object> nodes: The nodes to get the bouding box
			<Optional> <Bool> includeChildren : define if the bouding have to get children hierarchy
		Return:
			<Point3> size: Minimum and maximum of the bounding box
		Further Infos:
			function by Denis Trofimov aka DenisT
		</Function>*/
		
		bMin = [1e100, 1e100, 1e100]
		bMax = [-1e100, -1e100, -1e100]
		
		for n in nodes do 
		(
			nMin = n.min
			nMax = n.max
		
			bMin.x = amin bMin.x nMin.x
			bMin.y = amin bMin.y nMin.y
			bMin.z = amin bMin.z nMin.z

			bMax.x = amax bMax.x nMax.x
			bMax.y = amax bMax.y nMax.y
			bMax.z = amax bMax.z nMax.z
		)

-- 		modPanel.addModToSelection (XForm ()) ui:on
-- 		center = ((nodes[1].modifiers[1]).gizmo).position
-- 		bMin = (getModContextBBoxMin nodes[1] (nodes[1].modifiers[1]) + center )
-- 		bMax = (getModContextBBoxMax nodes[1] (nodes[1].modifiers[1]) + center )
-- 		for n in nodes do deleteModifier n 1
		
		 #(bMin, bMax)
	),
	


	/* Quickly change the pivot of selection ############################################################################################*/
	fn QuickPivotToolFn = 
	(
		/*<Function>
		Description:
			Quickly change the pivot of selection
		</Function>*/

		-- Get the snapshot to create the selection boundingbox Box
		ss = SingleSnapShotFn (getCurrentSelection())
		bbBox = convertToPoly(CreateBbBoxFn ss segs:2)
		
		-- Create an empty array to store all points and splines
		pivotHelperArray = #() 	
		
		-- Create a point for each vertex							
		for i = 1 to polyop.getNumVerts bbBox do 
		(
			pos = polyop.getVert bbBox i
			thePoint = Point pos:pos cross:off box:on constantscreensize:on drawontop:on size:5 
			thePoint.wirecolor = color 0 255 0
			append pivotHelperArray thePoint
		)
		
		-- Create a line for each edge
		for i = 1 to polyop.getNumEdges bbBox do 
		(
			polyop.createShape bbBox i name: (uniqueName "PivotLine")
			$PivotLine*.wirecolor = color 0 0 255
			append pivotHelperArray $PivotLine*
		)
		
		-- Delete the box and snapshot
		delete bbBox
		delete ss
		
		-- Let the user pick a point to define the new pivot position
		function pointFilter pt = (ClassOf pt == Point)
		thePoint = pickObject prompt:"Pick a point" filter:pointFilter 
		
		-- Add the possibility to cancel with escape
		if not keyboard.escPressed then 
		(
			
			if selection.count == 1 then			-- Set the object pivot to the selected point
				$.Pivot = thePoint.position
			else 												-- Turn on the working pivot and set its position to selected point
			(
				workingPivot.setTM thePoint.transform
				WorkingPivot.UseMode = true
			)
		)

		-- Delete all points and lines 
		for obj in pivotHelperArray do delete obj
	),
	
	
	
	/* Flatten a spline or a line on given axis ############################################################################################*/
	fn FlattenSpline axis  =
	(
		/*<Function>
		Description:
			Flatten a spline or a line on given axis
		Arguments:
			<Name> axis : the axis use to flatten the spline
		</Function>*/
		
		for spline in (_sgz._sel.Filter selection #(line, SplineShape)) do 
		(
			for s = 1 to (numSplines spline) do
			(
				for k = 1 to (numKnots spline s) do
				(
					knt = getKnotPoint spline s k
					in_vec = getInVec spline s k
					out_vec = getOutVec spline s k
					
					case axis of
					(
						#x: knt.x = in_vec.x = out_vec.x = spline.pos.x
						#y: knt.y = in_vec.y = out_vec.y = spline.pos.y
						#z: knt.z = in_vec.z = out_vec.z = spline.pos.z
					)
					
					setInVec spline s k in_vec
					setOutVec spline s k out_vec
					setKnotPoint spline s k knt
				)--end k loop
			)--end s loop
			
			updateshape spline
		)
	),
	
	
	
	/* Get an object material ids and sort them ############################################################################################*/
	fn GetAndSortMatIds obj =
	(
		/*<Function>
		Description:
			Get an object material ids and sort them
		Arguments:
			<Node> obj : the object to get material ids
		Return:
			<Array <Integer>> idsList : the sorted list of material ids
		Further Infos:
			Limited to one object
		</Function>*/
		
		idsList = #()
		for i = 1 to polyop.getNumFaces obj do appendIfUnique idsList (polyop.getFaceMatID obj i)
		
		return _sgz._extMxs.SortIntegers idsList
	),
	
	
	
	/* Select an object faces which have a given material id ############################################################################################*/
	fn SelectFacesByMatId obj ids addToSel:false subToSel:false =
	(
		/*<Function>
		Description:
			Select an object faces which have a given material id
		Arguments:
			<Node> obj : the object to select faces from material ids
			<Array <Integer>> ids : the list of id (don't need to be an array)
			<Optional <Bool>> addToSel : define if the faces should be add to the current selected faces
		</Function>*/
		
		-- Get the current selected faces if addToSel or subToSel
		faceList = if addToSel or subToSel then faceList = (polyop.getFaceSelection obj) as array else #()
		
		-- add each face that have one a the material id
		for id in (_sgz._extMxs.AsArray ids) do 
		(
			for faceIndex = 1 to polyop.getNumFaces obj do 
			(
				if polyop.getFaceMatID obj faceIndex == id then 
				(
					-- If subToSel, delete the face from facelist, otherwise add it
					if subToSel then
					(
						index = findItem faceList faceIndex
						if index != 0 then deleteItem faceList index
					)
					else appendIfUnique faceList faceIndex
					
				)
			)
		)
		
		
		if selection.count == 0 then select obj
		max modify mode
		subObjectLevel = 4
		polyop.setFaceSelection obj faceList
		
		redrawViews()
	
	),
	
	
	
	/* Get the selected edges ############################################################################################*/
	fn GetEdgeSelection obj = 
	(
		/*<Function>
		Description:
			Get the selected edges for all editable poly objects
		Arguments:
			<Node> obj: the object to get the selected edges
		Return:
			BitArray edges: the selected edges index
		Further Infos: 
			Modified code from Haywood Tools by James Haywood (website would be nice)
		</Function>*/
		
		try 
		(
			edges = #{}
			
			if classOf obj == Editable_Poly then edges = polyop.getEdgeSelection $
			if classOf obj.Modifiers[1] == Edit_Poly then edges = obj.Modifiers[1].getSelection #edge
				
			edges
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetEdgeSel()")
		
	),
	
	
	
	/* Get verts index from selected edges ############################################################################################*/
	fn GetVertsUsingEdge obj arr = 
	(
		/*<Function>
		Description:
			Get verts index from selected edges
		Arguments:
			<Node> obj: the object to work on
			BitArray / <Integer> : arr: the index of the edges 
		Return:
			BitArray verts: the verts index
		Further Infos:
			Modified code from Haywood Tools by James Haywood (website would be nice)
		</Function>*/
		
		try
		(
			verts = #{}

			if classOf arr != bitArray and classOf arr == integer do 
			(
				arr = #{arr}
			)
			
			if classOf obj == Editable_Poly then
			(
				verts = polyOp.getVertsUsingEdge obj arr
			)
	
			if classOf obj.Modifiers[1] == Edit_Poly then 
			(
				local func = obj.Modifiers[1].getEdgeVertex
				for n in arr do 
				(
					for i = 1 to 2 do 
					(
						append verts (func n i)
					)
				)
			)
			
			verts
		)
		catch(_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetVertsUsingEdge()")
	),
	
	
	
	/* Get a vertex position ############################################################################################*/
	fn GetVerts obj vert = 
	(
		/*<Function>
		Description:
			Get a vertex position
		Arguments:
			<Node> obj: the object to work on
			<Integer> vert: the index of the vertex
		Return:
			<Point3> vertPos: the position of the vertex
		Further Infos:
			Modified code from Haywood Tools by James Haywood (website would be nice)
		</Function>*/
		
		try
		(
			local vertPos = #{}
			
			if classOf obj == Editable_Poly then vertPos = polyOp.getVert obj vert
			if classOf obj.Modifiers[1] == Edit_Poly then vertPos = obj.Modifiers[1].getVertex vert
			
			vertPos
		)
		catch (_sgz._extMxs.Prompt "Issue occurs in Modeling Library: GetVerts()\n")
	),
	
	
	
	
	
	
	
	
	/* Add Unwrap_UVW modifier, open the editor, set to face selection and freeform mode ############################################################################################*/
	fn UnwrapUVWModFn = 
	(
		/*<Function>
		Description:
			Add Unwrap_UVW modifier, open the editor, set to face selection and freeform mode
		</Function>*/

		if not _sgz._sel.IsSelectionEmpty() then 
		(
			-- check selection count
-- 			if selection.count == 1 
-- 				then setUVWModifier $
-- 				else setUVWModifier $[1]
		)
	)
	

	
	
)

