try(destroyDialog testRoll) catch()
Rollout testRoll "Sugz"
(
	checkbox backfaceCullChb "Backface Cull"
	
	fn bfCullFn = 
	(
		-- define the checkbox state
		chbState = 0
		
		-- check if one object have backface Cull, then 
		for obj in selection while chbState != 1 do if obj.backfaceCull then chbState = 1
		if chbState == 1 then for obj in selection do if not obj.backfaceCull then chbState = 2
		
		backfaceCullChb.triState = chbState
	)

	on testRoll open do 
	(
		callbacks.addScript #selectionSetChanged "testRoll.bfCullFn()" id:#BackfaceCullCB
		callbacks.addScript #postNodeGeneralPropChanged "testRoll.bfCullFn()" id:#BackfaceCullCB
	)
	
	on testRoll close do 
	(
		callbacks.removeScripts #selectionSetChanged id:#BackfaceCullCB
		callbacks.removeScripts #postNodeGeneralPropChanged id:#BackfaceCullCB
	)
	
	
	on backfaceCullChb changed state do 
	(
		for obj in selection do obj.backfaceCull = state
	)
	
)
createDialog testRoll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)

