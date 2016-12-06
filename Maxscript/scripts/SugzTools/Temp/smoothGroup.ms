/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

#Required Components:
extend Max
mod lib

#Script infos:
TO FILL

*Use / Modify this script at your own risk !*
###############################################################################*/



try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	button resetSmoothGroupBtn "Reset"
	button setSmoothGroupBtn "Set"
	button printSmoothGroupsBtn "Print"
	
	/* Get all faces index of a editable poly ***************************************************************************************************************************************************************/
	fn getPolyFaces obj =
	(
		/*<Function>
		Arguments:
			<Node> obj : the object to get its face list
		Return:
			<BitArray <Integer>> the list the poly object faces
		</Function>*/
		
		return (for i in 1 to polyop.getNumfaces obj collect i) as bitarray
	)
	
	/* Get All smoothing groups of an editable poly ***************************************************************************************************************************************************************/
	fn getSmoothingGroups obj faceList:undefined =
	(
		/*<Function>
		Arguments:
			<Node> obj : the object to get its smoothing groups
		Return:
			<Array <Integer>> the list of the object smoothing groups
		</Function>*/
		
		smoothGroups = #()
		
		if faceList == undefined then faceList = getPolyFaces obj
		-- smoothing group are multiple of 2 (0,1, 2, 4,8,...) so to get the displayed one, get the divider 
		for i in _sgz._extMxs.AsArray faceList do 
		(
			sg = polyop.getFaceSmoothGroup obj i
			i = 0
			while sg != 0 do
			(
				sg /= 2
				i += 1
			)
			appendIfUnique smoothGroups i
		)
		
		smoothGroups
	)
	
	/* Set all faces of an editable poly to smoothing group 1 ***************************************************************************************************************************************************************/
	fn resetSmoothingGroups objs =
	(
		/*<Function>
		Arguments:
			<Array <Node>> objs: the object to operate on
		Further Infos:
			Base code from Dave Black : http://forums.cgsociety.org/archive/index.php?t-525996.html
		</Function>*/
		
		for obj in (_sgz._sel.Filter objs Editable_Poly) do 
		(
			polyOp.setFaceSmoothGroup obj (getPolyFaces obj) 1 
		)
	)
	
	
	fn SetFaceSmoothGroup obj faceList smoothGroup = 
	(
		/*<Function>
		Arguments:
			
		Return:
		Further Infos:
		</Function>*/
		
		success = false
		
		try
		(
			if classOf obj == editable_poly then
			(
				polyOp.setFaceSmoothGroup obj faceList smoothGroup
			)
	
			if classOf obj == edit_poly then 
			(
				obj.setOperation #setSmooth
				obj.smoothingGroupsToClear = -1
				obj.smoothingGroupsToSet = smoothGroup
				obj.commit()
			)
			
			success = true
		)
		
		catch (_sgz._extMxs.Prompt "Modeling Library Function Error: SetFaceSmoothGroup")
		
		success
	)
	
	
	fn setUniqueSmoothingGroup obj =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		
		if (_sgz._sel.Filter obj Editable_Poly).count != 0 then 
		(
			-- get and sort the list of smoothing groups
			/*
			currentSG = _sgz._extMxs.SortIntegers (getSmoothingGroups obj)
			maxSG = currentSG[currentSG.count]

			x = 1
			while x != maxSG do 
			(
				if findItem currentSG x == 0 
					then maxSG = x
					else x += 1
				
			)
			
			polyop.setFaceSmoothGroup obj (polyop.getFaceSelection obj) (2 ^ (maxSG - 1))
			*/
			
			sg = 0 -- start with no smoothing group bits
		
			for f in (polyop.getFaceSelection obj) do 
			(

				sg = bit.or sg (getSmoothingGroups obj faceList:f)[1] -- 'or' together current smoothing group bits
				format "sg (bit.or): %\n" sg

			)

			sg = (bit.and (bit.not sg) (sg + 1))
			format "sg (bit.and): %\n" sg
				
			polyOp.setFaceSmoothGroup obj (polyop.getFaceSelection obj) sg
		)
	)
	
	
	fn printSmoothGroups obj = 
	(
		if (not _sgz._sel.IsSelectionEmpty()) and ((_sgz._sel.Filter obj Editable_Poly).count != 0) then 
		(
			faceList = (polyop.getFaceSelection obj)
			currentSG = _sgz._extMxs.SortIntegers (getSmoothingGroups obj faceList:faceList)
			format "Smoothing Groups: %\n" currentSG
		)
	)
	
	
	
	
	on resetSmoothGroupBtn pressed do
	(
		resetSmoothingGroups selection
	)
	
	on setSmoothGroupBtn pressed do
	(
		setUniqueSmoothingGroup $
	)
	
	on printSmoothGroupsBtn pressed do
	(
		printSmoothGroups $
	)
	
	
	
	
	
)
createDialog testRoll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)