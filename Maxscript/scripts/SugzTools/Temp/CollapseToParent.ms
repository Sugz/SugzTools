try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	button collapseBtn "Collapse to parent"
	
	
	fn CollapseToParent = 
	(
		
	)
	
	
	on collapseBtn pressed do CollapseToParent()
	
)
createDialog Roll 188 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)