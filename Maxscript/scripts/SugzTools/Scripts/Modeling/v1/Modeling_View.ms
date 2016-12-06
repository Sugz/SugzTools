/*##############################################################################
SugzTools Modeling View
Version 1.00
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/



global _modView

struct ModelingViewStc
(
	
	ModelingViewRoll = undefined,
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout ModelingViewRoll "Sugz"
		(
			/*UI ####################################################################################################################*/
			checkButton btnView "View" width:55 align:#left offset:[-7,0] tooltip:"Set to View mode"
			checkButton btnLocal "Local" width:55 align:#center offset:[0,-26] tooltip:"Set to Local mode"
			checkButton btnParent "Parent" width:55 align:#right offset:[7,-26] tooltip:"Set to Parent mode"

			button btnEditPoly "Advance Edit Poly"  width:175  tooltip: "Convert selection to Editable Poly while keeping instances"
			checkbutton editPivotBtn "Edit Pivot" width:85 align:#left offset:[-7,0] tooltip:"Siwtch to \"Affect Pivot Only\" mode"
			checkbutton btnPivot "Quick Pivot" width:85 align:#right offset:[7,-26] tooltip: "Quick Pivot Tool"

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


			/*UI EVENTS ####################################################################################################################*/
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
					_sgz._mod.ConvertToEditPolyFn()
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
					_sgz._mod.QuickPivotToolFn()
					if not WorkingPivot.UseMode then btnPivot.state = false
				)
				if not arg and WorkingPivot.UseMode then WorkingPivot.UseMode = false
			)
			
			
			
			
		)
	),
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetView()
		try(destroyDialog _modView.ModelingViewRoll) catch()
		createDialog _modView.ModelingViewRoll 188 200 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	/* Initialize AutoMaterial ############################################################################################*/
	fn Run = 
	(
		CreateView()
	),
	
	
	/* Macroscript declaration ############################################################################################*/
	macro =
	(
		/*
		macroScript MACRONAME
			category:"SugzTools"
			toolTip:""
			Icon:#("SugzTools",1)
		(
			global _sgz
			on execute do 
			(
				if _sgz == undefined then fileIn "$userScriptsStartupSugzTools_Startup.ms"
				_sgz._Stc.Run()
			)
			
		)
		*/
	)
	
	
)

_modView = ModelingViewStc()
_modView.Run()
