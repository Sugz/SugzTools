try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	button selectFrozenBtn "Select"
	
	checkbox isFrozenChb "frozen" 
	
	on selectFrozenBtn pressed do 
	(
		select (for o in objects where o.isFrozen collect o)
	)
	
	on isFrozenChb changed state do 
	(
		for obj in selection do obj.isFrozen = state
		
	)
	
)
createDialog testRoll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)