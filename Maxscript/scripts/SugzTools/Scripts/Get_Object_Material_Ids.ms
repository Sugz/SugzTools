try(destroyDialog MaterialIDsRoll) catch()
Rollout MaterialIDsRoll "Material IDs"
(
	
	local matIdObj
	
	button getmatIdsBtn "Get Mat IDs" width:85 align:#left offset:[-7,0] tooltip:"Fill the dropdownlist with selected object material ids"
	dropdownlist matIdsDdl width:85 align:#right offset:[7,-26]
	button selByMatIdsBtn "Select ID" width:55 align:#left offset:[-7,0] tooltip:"Select object's face that have selected Mat Id"
	button addMatIdsToSelBtn "Add ID" width:55 align:#center offset:[0,-26] tooltip:"Add faces with selected Mat Id to the object's selected faces "
	button subMatIdsToSelBtn "Sub ID" width:55 align:#right offset:[7,-26] tooltip:"Substract faces with selected Mat Id to the object's selected faces "
	

	on getmatIdsBtn pressed do 
	(
		if _sgz._sel.GetSelectionCountFn() then 
		(
			-- Define the selection as the object use in the script and get its face Ids
			matIdObj = $	
			matIdsDdl.items = for _int in (_sgz._mod.GetAndSortMatIds matIdObj) collect (_int as string)
		)
	)

	on selByMatIdsBtn pressed do _sgz._mod.SelectFacesByMatId matIdObj (matIdsDdl.selected as integer)
	on addMatIdsToSelBtn pressed do _sgz._mod.SelectFacesByMatId matIdObj (matIdsDdl.selected as integer) addToSel:true
	on subMatIdsToSelBtn pressed do _sgz._mod.SelectFacesByMatId matIdObj (matIdsDdl.selected as integer) subToSel:true
	
	
)
createDialog MaterialIDsRoll 200 60 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)