try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	local mergeVertsValue = 0.0001
	
	button xLeftBtn "<X" width:22 height:20 align:#left offset:[-7,0]
	button xRightBtn "X>" width:22 height:20  align:#left offset:[20,-25] 
	button yLeftBtn "<Y" width:22 height:20 align:#center offset:[-14,-25] 
	button yRightBtn "Y>" width:22 height:20  align:#center offset:[14,-25]
	button zLeftBtn "<Z" width:22 height:20 align:#right offset:[-20,-25]
	button zRightBtn "Z>" width:22 height:20  align:#right offset:[7,-25]
	
	button mergeVertsBtn "Merge Verts" width:85 height:20 align:#left offset:[-7,0]
	spinner mergeVertsSpn width:85 align:#right offset:[7,-23] type:#worldunits  range:[0.0001, 100, mergeVertsValue] 
	button getNewVertsCount "Get new verts count"  width:175 height:20
	
	
	on xLeftBtn pressed do with undo label:"-90 X Rotation" on (on coordsys local selection.rotation.x_rotation = -90)
	on xRightBtn pressed do with undo label:"90 X Rotation" on (on coordsys local selection.rotation.x_rotation = 90)
	on yLeftBtn pressed do with undo label:"-90 Y Rotation" on (on coordsys local selection.rotation.y_rotation = -90)
	on yRightBtn pressed do with undo label:"90 Y Rotation" on (on coordsys local selection.rotation.y_rotation = 90)
	on zLeftBtn pressed do with undo label:"-90 Z Rotation" on (on coordsys local selection.rotation.z_rotation = -90)
	on zRightBtn pressed do with undo label:"90 Z Rotation" on (on coordsys local selection.rotation.z_rotation = 90)
	
	
	fn GetVertsCountAfterWeld obj = 
	(
		_copy = convertToPoly(snapshot obj)
		counts = #(polyop.getNumVerts _copy, 0)
		_copy.weldThreshold = mergeVertsSpn.value
		polyop.weldVertsByThreshold _copy _copy.verts
		counts[2] = polyop.getNumVerts _copy
		delete _copy
		
		return counts
	)
	
	on getNewVertsCount pressed do 
	(
		counts = GetVertsCountAfterWeld $
		getNewVertsCount.text = "Before: " + counts[1] as string + " \\ After: "  + counts[2] as string
	)
	
	on mergeVertsSpn buttonup  do 
	(
		if mergeVertsValue < mergeVertsSpn.value then 
		(
			case mergeVertsValue of 
			(
				0.0001: mergeVertsValue = mergeVertsSpn.value = 0.001
				0.001: mergeVertsValue = mergeVertsSpn.value = 0.01
				0.01: mergeVertsValue = mergeVertsSpn.value = 0.1
				0.1: mergeVertsValue = mergeVertsSpn.value = 1.0
				1.0: mergeVertsValue = mergeVertsSpn.value = 10.0
				10.0: mergeVertsValue = mergeVertsSpn.value = 100.0
			)
		)
		else 
		(
			case mergeVertsValue of 
			(
				0.001: mergeVertsValue = mergeVertsSpn.value = 0.0001
				0.01: mergeVertsValue = mergeVertsSpn.value = 0.001
				0.1: mergeVertsValue = mergeVertsSpn.value = 0.01
				1.0: mergeVertsValue = mergeVertsSpn.value = 0.1
				10.0: mergeVertsValue = mergeVertsSpn.value = 1.0
				100.0: mergeVertsValue = mergeVertsSpn.value = 10.0
			)
		)
	)
	
	
)
createDialog testRoll 188 75 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)175/3