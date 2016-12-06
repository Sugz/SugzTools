try(destroyDialog GridRoll) catch()
Rollout GridRoll "Sugz"
(
	
	dropdownlist gridListDdl width:175 items:#("Home Grid")
	button frontBtn "Front" width:55 height:20 align:#left offset:[-7,0]
	button topBtn "Top" width:55 height:20 align:#center offset:[0,-26] 
	button leftBtn "Left" width:55 height:20 align:#right offset:[7,-26]
	button backBtn "Back" width:55 height:20 align:#left offset:[-7,0]
	button bottomBtn "Bottom" width:55 height:20 align:#center offset:[0,-26] 
	button rightBtn "Right" width:55 height:20 align:#right offset:[7,-26]
	
	fn SetView view =
	(
		if gridListDdl.selection != 1 then
		(
			case view of
			(
				#front: actionMan.executeAction 0 "40316"  -- Views: Grid Front
				#back: actionMan.executeAction 0 "40317"  -- Views: Grid Back
				#top: actionMan.executeAction 0 "40315"  -- Views: Grid Top
				#bottom: actionMan.executeAction 0 "40318"  -- Views: Grid Bottom
				#left: actionMan.executeAction 0 "40319"  -- Views: Grid Left
				#right: actionMan.executeAction 0 "40320"  -- Views: Grid Right
			)
		)
		else
		(
			case view of
			(
				#front: viewport.setType #view_front
				#back: viewport.setType #view_back
				#top: viewport.setType #view_top
				#bottom: viewport.setType #view_bottom
				#left: viewport.setType #view_left
				#right: viewport.setType #view_right
			)
		)
	
	)
	

	on GridRoll open do 
	(
		grids = for obj in helpers where classOf obj == grid collect obj.name
		gridListDdl.items = join gridListDdl.items grids
	)
	
	
	on gridListDdl selected item do 
	(
		activeGrid = getNodebyName gridListDdl.selected
	)
	
	
	on frontBtn pressed do 
	on backBtn pressed do 
	on topBtn pressed do 
	on bottomBtn pressed do 
	on leftBtn pressed do 
	on rightBtn pressed do 
	
	
	
)
createDialog GridRoll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)