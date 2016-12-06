/* UI ############################################################################################*/
edittext nameTxt "Name :" width:150 offset:[-5,0] 
checkButton uniqueNameChb "U" width:20 height:18 align:#right offset:[7,-22] tooltip:"The name will be unique if another object in the scene have the same name"
checkButton toElementChb "To Element" width:85 align:#left offset:[-7,0] tooltip:"Detach to current object\nIf an object is picked, then the detach faces will be attach to the picked object"
checkButton asCloneChb "As Clone" width:85 align:#right offset:[7,-26] tooltip:"Don't delete selected faces"
checkButton asParentChb "As Parent" width:85 align:#left offset:[-7,0] tooltip:"The new object will become the parent of the original object or the picked object"
checkButton asChildrenChb "As Children" width:85 align:#right offset:[7,-26] tooltip:"The new object will become a child of the original object or the picked object"
pickButton otherObjectPbn "Pick an object" width:155 align:#left offset:[-7,0] tooltip:"Pick an object that will be use either to be attach on when detaching to element or as parent or children of the new object"
button currentParentBtn " CP" width:20 align:#right offset:[7,-26] tooltip:"Get the current parent"

button detachBtn "Detach" width:115 align:#left offset:[-7,0] 
checkButton selectChb "S" width:20 align:#right offset:[-33,-26] checked:true tooltip:"The selection will go to the new object or element"
checkButton flipChb "F"  width:20 align:#right offset:[-13,-26] tooltip:"Flip the faces normal"
checkButton pivotChb "P" width:20 align:#right offset:[7,-26] tooltip:"Center the pivot of the new object"


/* FUNCTIONS ############################################################################################*/

-- Set the enabled state of the UI
fn SetUiFn bool = 
(
	nameTxt.enabled = uniqueNameChb.enabled = asParentChb.enabled =  asChildrenChb.enabled = pivotChb.enabled = bool
)


-- Check the subobject level
fn SubObjectLevelFn obj verts edges borders faces elements = 
(
	isSubjObjectLevelOk = false
	if obj == 1 then if SubObjectLevel == 0 then isSubjObjectLevelOk = true
	if verts == 1 then if SubObjectLevel == 1 then isSubjObjectLevelOk = true
	if edges == 1 then if SubObjectLevel == 2 then isSubjObjectLevelOk = true
	if borders == 1 then if SubObjectLevel == 3 then isSubjObjectLevelOk = true
	if faces == 1 then if SubObjectLevel == 4 then isSubjObjectLevelOk = true
	if elements == 1 then if SubObjectLevel == 5 then isSubjObjectLevelOk = true
		
	isSubjObjectLevelOk
)


/* UI EVENTS ############################################################################################*/
	


-- Desactive unneeded buttons if toElementChb is active
on toElementChb changed arg do
(
	if arg then SetUiFn false else SetUiFn true			
)	

-- Set the asParentChb, asChildrenChb and otherObjectPbn enable state
on asParentChb changed arg do
(
	if arg then asChildrenChb.state = false
)

-- Set the asParentChb, asChildrenChb and otherObjectPbn enable state
on asChildrenChb changed arg do
(
	if arg then asParentChb.state = false
)

-- Modify the text of otherObjectPbn when an object is picked
on otherObjectPbn picked obj do
(
	if classOf obj != Editable_Poly 
			then messageBox "You can't use an object that is not an editable poly"
			else if obj != undefined then otherObjectPbn.caption = otherObjectPbn.tooltip = obj.name
)

on otherObjectPbn rightClick do
(
	otherObjectPbn.object = undefined
	otherObjectPbn.caption = "Pick an object"
	otherObjectPbn.tooltip = "Pick an object that will be use either to be attach on when detaching to element or as parent or children of the new object"
)

on currentParentBtn pressed do 
(
	if selection.count != 1
		then messageBox "Please select only one object"
		else
		(
			obj = $.parent
			if classOf obj != Editable_Poly 
				then messageBox "You can't use an object that is not an editable poly"
				else if obj != undefined then 
				(
					otherObjectPbn.object = obj
					otherObjectPbn.caption = otherObjectPbn.tooltip = obj.name
				)
		)
)


on detachBtn pressed do
(
	-- Define the selected objects and faces
	sel = $
	faceList = polyOp.getFaceSelection sel
	pickObj = otherObjectPbn.object
	if faceList.numberSet == 0 or not (SubObjectLevelFn 0 0 0 0 1 1)
		then messageBox "Please select some faces"
		else 
		(
			-- Detach as new object
			if toElementChb.state and otherObjectPbn.object != undefined or not toElementChb.state then
			(
				-- Detach or clone faces in a new object
				objName = uniqueName "Object"
				if not asCloneChb.state 
					then polyOp.detachFaces sel faceList delete:true asNode:true name:objName
					else polyOp.detachFaces sel faceList delete:false asNode:true name:objName
				
				-- Get the new object
				newObj = getNodeByName objName
				
				-- Flip faces if needed
				if flipChb.state then 
				(
					addModifier newObj (Normalmodifier flip:true)
					convertToPoly newObj
				)
				
				-- Attach the new object to the picked object
				if toElementChb.state then
				(
					-- Get the picked oject face number to be able to select only new faces and attach the new object
					pickObjFacesCount = polyOp.getNumFaces pickObj
					polyOp.attach pickObj newObj
					
					-- Select picked object and new faces
					if selectChb.state then 
					(
						select pickObj		
						faceList = for i = (pickObjFacesCount + 1) to (polyOp.getNumFaces pickObj) collect i
						subObjectLevel = 4 
						polyOp.setFaceSelection pickObj faceList
					)
				)
				
				else 
				(
					-- Set the name correctly
					if nameTxt.text != "" then 
					(
						if not uniqueNameChb.state
							then newObj.name = nameTxt.text
							else 
							(
								-- find all object that have the same name to avoid the uniquename function if possible
								objWithSameName = execute ("$objects/" + nameTxt.text + "*")
								if objWithSameName.count >= 1
									then newObj.name = uniquename nameTxt.text
									else newObj.name = nameTxt.text
							)
					)
					
					-- Set the hierarchy
					if asChildrenChb.state or asParentChb.state then
					(
						-- Define if the object to set hierarchy on is the selection or the picked obj
						local hierarchyObj
						if pickObj != undefined  then hierarchyObj = pickObj else hierarchyObj = sel
							
						-- Set either as chidren or as parent
						if asChildrenChb.state then newObj.parent = hierarchyObj
						else if asParentChb.state then 
						(
							if hierarchyObj.parent != undefined then newObj.parent = hierarchyObj.parent
							hierarchyObj.parent = newObj
						)
					)
					
					if selectChb.state then select newObj					-- Select new object
					if pivotChb.state then centerPivot newObj			-- Center the pivot of the new object
					
				)
			)
			
			-- Detach to element case
			else if toElementChb.state then 
			(
				-- Define the new faces
				local newFaceList 			
				
				-- Detach or clone to element
				if not asCloneChb.state 
					then polyOp.detachFaces sel faceList delete:true asNode:false
					else polyOp.detachFaces sel faceList delete:false asNode:false
					
				-- Store all faces and delete the old ones if the asClone is active
				newFaceList = polyOp.getFaceSelection sel
				if asCloneChb.state then for i = 1 to faceList.count do deleteItem newFaceList (findItem faceList i)
				
				-- Select faces
				if selectChb.state and asCloneChb.state 
					then polyOp.setFaceSelection sel newFaceList
					else polyOp.setFaceSelection sel faceList
				
				-- Flip the normals
				if flipChb.state then polyOp.flipNormals sel newFaceList
			
			)
			
			redrawViews() 
		)
)