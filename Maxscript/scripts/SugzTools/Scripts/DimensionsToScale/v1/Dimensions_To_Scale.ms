/*##############################################################################
Dimensions To Scale
Version 0.04
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

#Required Components:
None

#Script infos:
Change the scale of an object with it's dimensions

*Use / Modify this script at your own risk !*
###############################################################################*/



try(destroyDialog DimensionToScaleRoll) catch()
Rollout DimensionToScaleRoll "Dimensions to scale"
(
	
	/* Variables ############################################################################################*/
	-- Store object size to calculate the delta size
	local xSize = 0
	local ySize = 0
	local zSize = 0
	
	-- Store the spinners values to get their delat when changing their values
	local xDimensionSpnOld = 0
	local yDimensionSpnOld = 0
	local zDimensionSpnOld = 0
	
	/* UI ############################################################################################*/
	label objectNameLbl align:#left offset:[-5,0]
	
	label xScaleLbl "X : " align:#left offset:[-5,0]
	spinner xDimensionSpn ""  type:#worldunits width: 90 height:15 align:#right offset:[-15,-18]
	label yScaleLbl "Y : " align:#left offset:[-5,0]
	spinner yDimensionSpn ""  type:#worldunits width: 90 height:15 align:#right offset:[-15,-18]
	label zScaleLbl "Z : " align:#left offset:[-5,0]
	spinner zDimensionSpn ""  type:#worldunits width:  90 height:15 align:#right offset:[-15,-18]
	checkbutton lockBtn "L" width: 20 height:56 align:#right offset:[7,-60]
	
	button resetScaleBtn "Reset Scale" width: 100 align:#left offset:[-7,0]
	button applyBtn "Apply" width: 100 align:#right offset:[7,-26]
	
	/* Functions ############################################################################################*/
	
	-- Set the scale labels accordingly to the selection count (bool is true when selection count is 1)
	fn SetScaleLabelsFn bool = 
	(
		if bool then 
		(
			xScaleLbl.text = "X (" + ($.scale.x * 100) as string + " %) : "
			yScaleLbl.text = "Y (" + ($.scale.y * 100) as string + " %) : "
			zScaleLbl.text = "Z (" + ($.scale.z * 100) as string + " %) : "
		)
		else
		(
			xScaleLbl.text = "X : "
			yScaleLbl.text = "Y : "
			zScaleLbl.text = "Z : "
		)
		
	)
	
	-- Set the UI accordingly to the selection count (bool is true when selection count is 1)
	fn SetUIFn bool = 
	(
		SetScaleLabelsFn bool
		
		xDimensionSpn.indeterminate = yDimensionSpn.indeterminate = zDimensionSpn.indeterminate = not bool
		xDimensionSpn.enabled = yDimensionSpn.enabled = zDimensionSpn.enabled = bool
		lockBtn.enabled = resetScaleBtn.enabled = applyBtn.enabled = bool
		
		objectNameLbl.text = if bool then ($.name + " :") else "Select one object..."
	)
	
	-- Get the selected object dimensions and set the UI accordingly
	fn GetDimensionsFn = 
	(
		-- active UI only if user selected one object
		if selection.count == 1 then 
		(
			SetUIFn true
			
			bb = nodeGetBoundingBox $ $.transform
			dim = bb[2] - bb[1]
			
			xSize = xDimensionSpnOld = xDimensionSpn.value = dim[1] * $.scale.x
			ySize = yDimensionSpnOld = yDimensionSpn.value = dim[2] * $.scale.y
			zSize = zDimensionSpnOld = zDimensionSpn.value = dim[3] * $.scale.z
		)
		
		-- deactivate UI if user selected 0 or more than 1 object
		else SetUIFn false
		
	)
	
	
	-- Set the stored spinners values
	fn StoreNewValuesFn = 
	(
		xDimensionSpnOld = xDimensionSpn.value
		yDimensionSpnOld = yDimensionSpn.value
		zDimensionSpnOld = zDimensionSpn.value
	)
	
	
	/* Events ############################################################################################*/
	
	-- Add the spinners callback and set the ui accordingly
	on DimensionToScaleRoll open do 
	(
		GetDimensionsFn()
		callbacks.addScript #selectionSetChanged "DimensionToScaleRoll.GetDimensionsFn()" id:#GetDimensionsCB
	)

	-- Remove the spinners callback
	on DimensionToScaleRoll close do 
	(
		callbacks.removeScripts #selectionSetChanged id:#GetDimensionsCB
	)
	
	-- Set the values of spinner when lock button is on
	fn SetSpinnerValuesFn val axis = 
	(
		-- Get the delta between the old and the new value of the changed spinner
		-- Set the other spinners using the delta relatif to the changed spinner and the others
		case axis of
		(
			#x: 
			(
				delta = val - xDimensionSpnOld
				yDimensionSpn.value += delta * (yDimensionSpn.value / xDimensionSpnOld)
				zDimensionSpn.value += delta * (zDimensionSpn.value / xDimensionSpnOld)
			)

			#y: 
			(
				delta = val - yDimensionSpnOld
				xDimensionSpn.value += delta * (xDimensionSpn.value / yDimensionSpnOld)
				zDimensionSpn.value += delta * (zDimensionSpn.value / yDimensionSpnOld)
			)
			
			#z: 
			(
				delta = val - zDimensionSpnOld
				xDimensionSpn.value += delta * (xDimensionSpn.value / zDimensionSpnOld)
				yDimensionSpn.value += delta * (yDimensionSpn.value / zDimensionSpnOld)
			)
		)
		
		StoreNewValuesFn()
		
	)
	
	
	-- Set spinners values if lock button is checked
	on xDimensionSpn changed val do
	(
		if lockBtn.state then SetSpinnerValuesFn val #x
	)
	
	on yDimensionSpn changed val do
	(
		if lockBtn.state then SetSpinnerValuesFn val #y
	)
	
	on zDimensionSpn changed val do
	(
		if lockBtn.state then SetSpinnerValuesFn val #z
	)
	
	
	-- Set the new object dimensions
	on applyBtn pressed do
	(
		$.scale.x *= xDimensionSpn.value / xSize
		$.scale.y *= yDimensionSpn.value / ySize
		$.scale.z *= zDimensionSpn.value / zSize
		
		GetDimensionsFn()
	)
	
	on resetScaleBtn pressed do
	(
		ResetScale $
		GetDimensionsFn()
	)
	
)
createDialog DimensionToScaleRoll 215 110 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
