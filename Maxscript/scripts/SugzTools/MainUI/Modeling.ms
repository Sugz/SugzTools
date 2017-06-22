/*##############################################################################
SugzTools Modeling UI
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/



/* VARIABLES ############################################################################################*/



/*UI ####################################################################################################################*/
timer clock interval:100

checkButton btnView "View" width:55 align:#left offset:[-7,0] tooltip:"Set to View mode"
checkButton btnLocal "Local" width:55 align:#center offset:[0,-26] tooltip:"Set to Local mode"
checkButton btnParent "Parent" width:55 align:#right offset:[7,-26] tooltip:"Set to Parent mode"

button btnEditPoly "Edit Poly"  width:175  tooltip: "Convert selection to Editable Poly\n+Ctrl: Convert selection to Editable Poly while keeping instances"
checkbutton editPivotBtn "Edit Pivot" width:85 align:#left offset:[-7,0]
checkbutton btnPivot "Center Pivot" width:85 align:#right offset:[7,-26] tooltip: "Center Pivot of selected objects\n+Ctrl: Quick Pivot Tool (only one object)"

label alignPivotLbl "Align Pivot to Edge" align:#left offset:[-5,5]
button xAxisBtn "X" width:25 height:20 align:#right offset:[-47,-22]
button yAxisBtn "Y" width:25 height:20 align:#right offset:[-20,-25]
button zAxisBtn "Z" width:25 height:20 align:#right offset:[7,-25]

label flattenSplineLbl "Flatten Spline" align:#left offset:[-5,5]
button xFlattenBtn "X" width:25 height:20 align:#right offset:[-47,-22]
button yFlattenBtn "Y" width:25 height:20 align:#right offset:[-20,-25]
button zFlattenBtn "Z" width:25 height:20 align:#right offset:[7,-25]

label backfaceCullLbl "Backface Cull" align:#left offset:[-5,0]
checkbox backfaceCullChb "" align:#right offset:[17,-18]

/*FUNCTIONS ####################################################################################################################*/
/* Get the current coord sys and set the buttons accordingly ***************************************************************************************************************************************************************/
fn SetBtnCoordSysFn = 
(
	case (getRefCoordSys()) of 
	(
		#hybrid: (btnView.state = true; btnLocal.state = btnParent.state = false)
		#local: (btnLocal.state = true; btnView.state = btnParent.state = false)
		#parent: (btnParent.state = true; btnView.state = btnLocal.state = false)
		default: btnView.state = btnLocal.state = btnParent.state = false
	)
)



/* Set the backfacecull checkbox depending of the current selection ***************************************************************************************************************************************************************/
fn BackFaceCullFn = 
(
	backfaceCullChb.triState = _sgz._prop.GetBackFaceCull()
)



/* Set the controls captions depending on the keyboard input ***************************************************************************************************************************************************************/
fn SetControlsCaptionsFn input = 
(
	case input of 
	(
		#ctrl: (btnEditPoly.caption = "Advance Edit Poly"; btnPivot.caption = "Quick Pivot")
		#none: (btnEditPoly.caption = "Edit Poly"; btnPivot.caption = "Center Pivot")
	)
)



/* Align a pivot axis to and edge ***************************************************************************************************************************************************************/
fn AlignPivotToEdge axis =
(
	/*<Function>
	Description:
		Align a pivot axis to an edge
	Arguments:
		<Name> : the axis to align 
	Return:
	Further Infos:
		Pivot direction by Miauu: http://www.scriptspot.com/3ds-max/scripts/align-pivot-to-direction
	</Function>*/
	
	if _sgz._sel.IsSelectionOne() then 
	(
		-- Check only one edge is selected
		edges = _sgz._mod.GetEdgeSelection $
		if edges.numberSet == 1 then 
		(
			-- Get the two verts and get a vector from their position
-- 				positions = #()
-- 				for i in (_sgz._mod.GetVertsUsingEdge $ edges) do 
-- 				(
-- 					append positions (_sgz._mod.GetVerts $ i)
-- 				)
			
			positions = for i in (_sgz._mod.GetVertsUsingEdge $ edges) collect (_sgz._mod.GetVerts $ i)
			
			dir = normalize (positions[2] - positions[1])
			tm = $.transform
			vec = case axis of
			(
				#x: - $.transform[1] 
				#y: - $.transform[2] 
				#z: - $.transform[3] 
			)
			
			rtm = angleaxis (acos (dot vec dir)) (normalize (cross dir vec))
			tempObjTM = translate (rotate (scalematrix tm.scale) (tm.rotation*rtm)) tm.pos
				
			worldAlignPivot $
			rotation = inverse tempObjTM.rotation
			in coordsys local $.rotation *= rotation
			$.objectoffsetrot *= rotation
			$.objectoffsetpos *= rotation
			
			subobjectlevel = 0
		)
		
		else _sgz._extMxs.Prompt "Select one edge"
	)
	
	
	
)



/*UI EVENTS ####################################################################################################################*/
on clock tick do 
(
	case of 
	(
		(keyboard.controlPressed): SetControlsCaptionsFn #ctrl
		default: SetControlsCaptionsFn #none
	)
)



/* Add the coordsys callback when the rollout open ***************************************************************************************************************************************************************/
on ModelingRoll open do 
(
	callbacks.addScript #selectionSetChanged "SgzRoll.ModelingRoll.BackFaceCullFn()" id:#BackfaceCullCB
	callbacks.addScript #postNodeGeneralPropChanged "SgzRoll.ModelingRoll.BackFaceCullFn()" id:#BackfaceCullCB
	callbacks.addscript #spacemodeChange "SgzRoll.ModelingRoll.SetBtnCoordSysFn()" id:#CoordSysCallback
	SetBtnCoordSysFn()
)



/* Remove the coordsys callback when the rollout open ***************************************************************************************************************************************************************/
on ModelingRoll close do 
(
	callbacks.removeScripts #selectionSetChanged id:#BackfaceCullCB
	callbacks.removeScripts #postNodeGeneralPropChanged id:#BackfaceCullCB
	callbacks.removeScripts #spacemodeChange id:#CoordSysCallback
)



/* Set the coordsys ***************************************************************************************************************************************************************/
on btnView changed arg do setRefCoordSys #hybrid
on btnLocal changed arg do setRefCoordSys #local
on btnParent changed arg do setRefCoordSys  #parent
	


/* Convert to Editable Poly ***************************************************************************************************************************************************************/
on btnEditPoly pressed do with undo on
(
	if not _sgz._sel.IsSelectionEmpty() then
	(
		max modify mode
		case of 
		(
			(keyboard.controlPressed): _sgz._mod.ConvertToEditPolyFn()
			default: convertToPoly $
		)
		
	)
)


/* Toggle Affect Pivot Only ***************************************************************************************************************************************************************/
on editPivotBtn changed state do
(
	if state
		then maxops.pivotmode = #pivotonly
		else maxops.pivotmode = #none
)




/* Modify pivot ***************************************************************************************************************************************************************/
on btnPivot changed arg do with undo on
(
	if not _sgz._sel.IsSelectionEmpty() and arg then
	(
		case of 
		(
			(keyboard.controlPressed): _sgz._mod.QuickPivotToolFn()
			default: centerPivot $
		)
		if not WorkingPivot.UseMode then btnPivot.state = false
	)
	if not arg and WorkingPivot.UseMode then WorkingPivot.UseMode = false
)




/* Align a pivot axis to and edge ***************************************************************************************************************************************************************/
on xAxisBtn pressed do AlignPivotToEdge #x
on yAxisBtn pressed do AlignPivotToEdge #y
on zAxisBtn pressed do AlignPivotToEdge #z



/* Flatten Spline ***************************************************************************************************************************************************************/
on xFlattenBtn pressed do with undo label:"Flatten Spline on X" on (_sgz._mod.FlattenSpline #x)
on yFlattenBtn pressed do with undo label:"Flatten Spline on Y" on (_sgz._mod.FlattenSpline #y)
on zFlattenBtn pressed do with undo label:"Flatten Spline on Z" on (_sgz._mod.FlattenSpline #z)



/* Modify backface cull ***************************************************************************************************************************************************************/
on backfaceCullChb changed state do 
(
	for obj in selection do obj.backfaceCull = state
)
