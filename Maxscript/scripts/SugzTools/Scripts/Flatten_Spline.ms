try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	label flattenSplineLbl "Flatten Spline :" align:#left offset:[-5,0]
	button xFlattenBtn "X" width:25 height:20 align:#right offset:[-47,-22]
	button yFlattenBtn "Y" width:25 height:20 align:#right offset:[-20,-25]
	button zFlattenBtn "Z" width:25 height:20 align:#right offset:[7,-25]
	
	
	on xFlattenBtn pressed do with undo label:"Flatten Spline on X" on (_sgz._mod.FlattenSpline #x)
	on yFlattenBtn pressed do with undo label:"Flatten Spline on Y" on (_sgz._mod.FlattenSpline #y)
	on zFlattenBtn pressed do with undo label:"Flatten Spline on Z" on (_sgz._mod.FlattenSpline #z)
	
)
createDialog testRoll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)


