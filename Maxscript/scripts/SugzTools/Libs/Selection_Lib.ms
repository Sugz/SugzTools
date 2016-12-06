/*##############################################################################
SugzTools Selection Library
Version 1.08
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Functions to speed up the selection workflow

# Required Components:
SugzTools Manager
SugzTools Extend 3ds Max Library

# Sources:
One liner to get all children by Rotem Shiffman aka lo on CGTalk

# To do list:
change Filter to stop using baseObject to be able to use modPanel.getCurrentObject()

# History:
1.08:
 - get rid of "Fn" an the end of functions name
 - update GetInstances (doesn't return object currently selected anymore)
 - update GetHierarchy (doesn't return object currently selected anymore, add option to get only first parent / children, or all the list)
 - add GetChildren 
1.07: 
 - add IsSubObjLvl 
 - add IsSelectionOne
 - rename and modify GetSelectionCountFn to IsSelectionEmpty

*Use / Modify this script at your own risk !*
###############################################################################*/




struct SelectionLibraryStc
(
	
	
	/* Check if selection is empty ############################################################################################*/
	fn IsSelectionEmpty = 
	(
		/*<Function>
		Description:
			Check if selection is empty
		Return:
			<Bool> selectionIsEmpty: true if the selection is empty
		</Function>*/
		
		selectionIsEmpty = false
		if selection.count == 0 then 
		(
			_sgz._extMxs.Prompt  "Select at least one object"
			selectionIsEmpty = true
		)
		
		selectionIsEmpty
	),
	
	
	
	/* Check if selection contain only one object ############################################################################################*/
	fn IsSelectionOne =
	(
		/*<Function>
		Description:
			Check if selection contain only one object
		Return:
			<Bool> selectionIsOne: true if the selection only contain one object
		</Function>*/
		
		selectionIsOne = true
		if selection.count != 1 then 
		(
			_sgz._extMxs.Prompt  "Select only one object"
			selectionIsOne = false
		)
		
		selectionIsOne
	
	),

	
	
	/* Check for subObjectLevel ############################################################################################*/
	fn IsSubObjLvl _obj _vert _edge _border _face _element =
	(
		/*<Function>
		Description:
			Check for subObjectLevel
		Arguments:
			<Integer> _obj, _vert, _edge, _border, _face, _element
		Return:
			<Bool> IsCorrect: wheter the current subObjectLevel matches the request
		</Function>*/
		
		IsCorrect = false
		
		max modify mode
		
		if _obj == 1 then (if subObjectLevel == 0 then IsCorrect = true)
		if not IsCorrect then (if _vert == 1 then (if subObjectLevel == 1 then IsCorrect = true))
		if not IsCorrect then (if _edge == 1 then (if subObjectLevel == 2 then IsCorrect = true))
		if not IsCorrect then (if _border == 1 then (if subObjectLevel == 3 then IsCorrect = true))
		if not IsCorrect then (if  _face == 1 then (if subObjectLevel == 4 then IsCorrect = true))
		if not IsCorrect then (if _element == 1 then (if subObjectLevel == 5 then IsCorrect = true))
		
		if not IsCorrect then
		(
			str = ""
			if _obj == 1 then str = "You need to leave SubObject Level"
			else
			(
				str = "Please switch to "
				
				levels = #()
				if _vert == 1 then append levels "Vertex"
				if _edge == 1 then append levels "Edge"
				if _border == 1 then append levels "Border"
				if _face == 1 then append levels "Polygon"
				if _element == 1 then append levels "Element"
					
				str += levels[1]
				
				if levels.count >= 2 then for i = 2 to levels.count do str += " or " + levels[i]
			)
			
			_sgz._extMxs.Prompt str
		)
		
		IsCorrect
	),
	
	
	
	/* Return objetcs that match classes ############################################################################################*/
	fn Filter nodes classes =
	(
		/*<Function>
		Description:
			Return objetcs that match classes
		Arguments:
			<Array <Node>> nodes: the nodes to be filtered
			<Array <Class>> classes : the classes (classOf or superClassOf) that selection need to be. Don't need to be an array
		Return:
			<Array< newNodes : the filterred selection
		</Function>*/
		
		
		filteredNodes = #()
		for _class in (_sgz._extMxs.AsArray classes) do (for obj in nodes where (isKindOf obj.baseObject _class) do appendIfUnique filteredNodes obj)
		
		delta = selection.count - filteredNodes.count
		if delta != 0 then _sgz._extMxs.Prompt (delta as string + " Objects can't be process")
		
		filteredNodes
	),
	
	
	
	/* Return only visible object in the array ############################################################################################*/
	fn UnselectHiddenObjects objArray =
	(
		/*<Function>
		Description:
			Return only visible object in the array
		Arguments:
			<Array> objArray: objects that need to be check for visibility
		Return:
			<Array> return only the visible objects from the array passed in the argument
		</Function>*/
		
		return (for obj in objArray where not obj.isHiddeninVpt collect obj)
	),
		
	
	
	/* Return either all or only visible instances ############################################################################################*/
	fn GetInstances objs getHidden:true limitToSel:false = 
	(
		/*<Function>
		Description:
			Return either all or only visible instances
		Arguments:
			<Array> objs: the objects to get the instances
			<Optional> <Bool> getHidden: define if the function will return also the hidden instances <Default: true>
			<Optional> <Bool> limitToSel: define if the function will be limited only to the current selection <Default: false>
		Return:
			<Array> instancesArray: the instances
		</Function>*/
		
		-- Define empty array to store instances
		instancesArray = #()
		sel = getCurrentSelection()
		for obj in objs do 
		(
			-- get all instances
			InstanceMgr.GetInstances obj &instances
			if limitToSel then 
				join instancesArray (for _instance in instances where (findItem sel _instance != 0) collect _instance)
			else join instancesArray (for _instance in instances where (findItem sel _instance == 0) collect _instance)
		)

		if not getHidden then instancesArray = UnselectHiddenObjects instancesArray
			
		instancesArray
	),
	

	
	/* Return only the first instance from selection ############################################################################################*/
	fn DeleteInstanceFromSelection getHidden:true limitToSel:false = 
	(
		/*<Function>
		Description:
			Return only the first instance from selection
		Arguments:
			<Optional> <Bool> limitToSel: define if the function will be limited only to the current selection <Default: false>
		Return:
			<Array> firstInstanceArray: the first instance for each object in selection
		</Function>*/
	
		firstInstanceArray = #()
		for obj in selection do 
		(
			instances = GetInstances obj getHidden:getHidden limitToSel:limitToSel
			if instances.count != 0 
				then appendIfUnique firstInstanceArray instances[1]
				else append firstInstanceArray obj
		)
		
		firstInstanceArray
	),
	

	
	 /* Get the parent hierarchy ############################################################################################*/
	fn GetParent node all =
	(
		/*<Function>
		Description:
			Get the parent hierarchy
		Arguments:
			<Node> node: the node to get parents hierarchy
			<Bool>  all: if true then will select all the parent list
		Return:
			<Array <Node>> parentList: the list of parent
		</Function>*/
		
		-- Get node parent as array then loop to get the hierarchy adding parent in the array (or return empty array to avoid undefined)
		parentList = if node.parent != undefined then append #() node.parent else #()
		if all then for p in parentList where p.parent != undefined do append parentList p.parent
		
		parentList
	),
	
	

	/* Get the children hierarchy ############################################################################################*/
	fn GetChildren node all =
	(
		/*<Function>
		Description:
			Get the children hierarchy
		Arguments:
			<Node> node: the node to get children hierarchy
			<Bool>  all: if true then will select all the parent list
		Return:
			<Array <Node>> childrenList : the list of direct or all children  
		Further Infos:
			one liner to get all children by Rotem Shiffman aka lo on CGTalk
			I have no idea how works "join #() node"
		</Function>*/
		
		childrenList = if all then join #() node else node.children
		return (for obj in childrenList where obj != node collect obj)
	),
	
	

	/* Get hierarchy ############################################################################################*/
	fn GetHierarchy selArray:(getCurrentSelection()) children:false parent:false getHidden:false all:false =
	(
		/*<Function>
		Description:
			Get hierarchy
		Arguments:
			<Optional> <Array> selArray: the objects to work on (current selection by default) <Default: Current Selection>
			<Optional> <Bool> children: define if the function have to select children <Default: false>
			<Optional> <Bool> parent: define if the function have to select parent <Default: false>
			<Optional> <Bool> getHidden: define if the function will also return hidden objects <Default: false>
			<Optional> <Bool> all: true to select either all parent list or all children list <Default: false>
		Return:
			<Array> selArray: the hierachy of selected objects
		</Function>*/
		
		-- get children and parent
		returnObjs = #()
		if parent then (for obj in selArray do join returnObjs (GetParent obj all))				-- get parents
		if children then (for obj in selArray do join returnObjs (GetChildren obj all))	
			
		-- get rid of hidden object if needed
		if not getHidden then returnObjs = UnselectHiddenObjects returnObjs
		
		returnObjs
	)

)

