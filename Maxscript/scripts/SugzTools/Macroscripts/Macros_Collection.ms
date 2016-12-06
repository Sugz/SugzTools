/*##############################################################################
SugzTools MacroScripts Collection
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
A collection of macrocripts

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library
HaywoodTools

# Sources:
HaywoodTools

# ToDo:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/



struct MacrosCollectionStc
(
	
	/*  Toggle selection outline ############################################################################################*/
	ToggleSelectionOutlineMacro =
	(
		MacroScript ToggleSelectionOutline
			Category:"SugzTools"
			ToolTip:"Toggle Selection Outline"
			Icon:#("SugzTools",2)
		
		(
			global _sgz
			
			-- Execute the Selection Outline ActionMan 
			on execute do actionMan.executeAction 0 "63565"
			
			-- Get the current Selection Outline state
			on isChecked return (if _sgz != undefined then _sgz._extMxs.GetActionManState "Main UI" 63565 else false)
			
		)
	),
	
	
	
	/* Set Unique Smoothing Group (HaywoodTools)  ############################################################################################*/
	SetUniqueSmoothingGroupMacro =
	(
		MacroScript SetUniqueSmoothingGroup
			ButtonText:"Set Unique Smoothing Group"
			Category:"SugzTools"
			ToolTip:"Set Unique Smoothing Group - HaywoodTools"
		
		(
			On IsEnabled Return Filters.Is_EPolySpecifyLevel #{5,6}
			On IsVisible Return Filters.Is_EPolySpecifyLevel #{5,6}
			
			on execute do if doesFileExist (file = "$scripts\HaywoodTools\setUniqueSmoothingGroup.ms") then fileIn file
		)
		
	),
	
	
	
	/* Make Planar on X ############################################################################################*/
	MakePlanarXMacro = 
	(
		MacroScript EPoly_Make_Planar_X
			ButtonText:"Make Planar X"
			Category:"Editable Polygon Object" 
			internalCategory:"Editable Polygon Object" 
			Tooltip:"Make Planar X (Poly)  - SugzTools"
		
		-- Needs Icon
		(
			On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object
			On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object

			On Execute Do (
				If SubObjectLevel == undefined then Max Modify Mode
				Try 
				(
					local A = Filters.GetModOrObj()
					A.buttonOp #MakePlanarInX
				)
				Catch(MessageBox "Operation Failed" Title:"Poly Editing")
			)
		)
		
	),
	
	
	
	/* Make Planar on X ############################################################################################*/
	MakePlanarYMacro = 
	(
		MacroScript EPoly_Make_Planar_Y
			ButtonText:"Make Planar Y"
			Category:"Editable Polygon Object" 
			internalCategory:"Editable Polygon Object" 
			Tooltip:"Make Planar Y (Poly)  - SugzTools"
		
		-- Needs Icon
		(
			On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object
			On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object

			On Execute Do (
				If SubObjectLevel == undefined then Max Modify Mode
				Try 
				(
					local A = Filters.GetModOrObj()
					A.buttonOp #MakePlanarInY
				)
				Catch(MessageBox "Operation Failed" Title:"Poly Editing")
			)
		)
		
	),
	
	
	
	/* Make Planar on X ############################################################################################*/
	MakePlanarZMacro = 
	(
		MacroScript EPoly_Make_Planar_Z
			ButtonText:"Make Planar Z"
			Category:"Editable Polygon Object" 
			internalCategory:"Editable Polygon Object" 
			Tooltip:"Make Planar Z (Poly)  - SugzTools"
		
		-- Needs Icon
		(
			On IsEnabled Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object
			On IsVisible Return Filters.Is_EPolySpecifyLevel #{2..6}	-- anything but object

			On Execute Do (
				If SubObjectLevel == undefined then Max Modify Mode
				Try 
				(
					local A = Filters.GetModOrObj()
					A.buttonOp #MakePlanarInZ
				)
				Catch(MessageBox "Operation Failed" Title:"Poly Editing")
			)
		)
		
	),
	
	
	
	/* Bridge ############################################################################################*/
	BridgeMacro = 
	(
		MacroScript EPoly_Bridge
			ButtonText:"Bridge"
			Category:"Editable Polygon Object" 
			InternalCategory:"Editable Polygon Object" 
			Tooltip:"Bridge (Poly) - SugzTools" 
			-- Needs Icon
		
		(
			 -- Active in Edge, Border, Face levels:
			On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..5}
			On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..5}
			
			
			On Execute Do 
			(
				If SubObjectLevel == undefined then Max Modify Mode
				try
				(
					obj = Filters.GetModOrObj()
					case subobjectLevel of 
					(
						2: obj.ButtonOp #BridgeEdge
						3: obj.ButtonOp #BridgeBorder
						4: obj.ButtonOp #BridgePolygon
					)
				)
				catch(MessageBox "Operation Failed" Title:"Poly Editing")
			)
			
			
			 On AltExecute type do 
			(
				If SubObjectLevel == undefined then Max Modify Mode
				try 
				(
					obj = Filters.GetModOrObj()
					case subobjectLevel of 
					(
						2: obj.PopupDialog #BridgeEdge
						3: obj.PopupDialog #BridgeBorder
						4: obj.PopupDialog #BridgePolygon
					)
				)
				catch(MessageBox "Operation Failed" Title:"Poly Editing")
			)
			
		) -- End macro
		
	)

)

MacrosCollectionStc()
