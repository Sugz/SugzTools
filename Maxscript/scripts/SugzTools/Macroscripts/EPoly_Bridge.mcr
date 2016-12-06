/*##############################################################################
EPoly Bridge
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
The bridge as macroscript, compatible Editable_Poly object and Edit_Poly modifer

# Required Components:

# Sources:
Loosely based on Ruramuq code: http://polycount.com/discussion/85968/3ds-max-quad-bridge-quick-question

# ToDo:

# History:
1.0:
	- Initial release

*Use / Modify this script at your own risk !*
###############################################################################*/



/*
MacroScript EPoly_Bridge
	EnabledIn:#("max", "viz")
	ButtonText:"Bridge"
	Category:"Editable Polygon Object" 
	InternalCategory:"Editable Polygon Object" 
	Tooltip:"Bridge (Poly) - SugzTools" 
(
    -- Active in Edge, Border, Face levels:
    On IsEnabled Return Filters.Is_EPolySpecifyLevel #{3..5}
    On IsVisible Return Filters.Is_EPolySpecifyLevel #{3..5}
	
	
	On Execute Do 
	(
        try
		(
			obj = Filters.GetModOrObj()
			case subobjectLevel of 
			(
				2: obj.ButtonOp #BridgeEdge
				3: obj.ButtonOp #BridgeBorder
				4: obj.ButtonOp #BridgePolygon
			)
--             if classOf $ == Editable_Poly then $.bridge()
-- 			if classOf $.Modifiers[1] == Edit_Poly then 
-- 			(
-- 				obj = Filters.GetModOrObj()
-- 				case subobjectLevel of 
-- 				(
-- 					2: obj.ButtonOp #BridgeEdge
-- 					3: obj.ButtonOp #BridgeBorder
-- 					4: obj.ButtonOp #BridgePolygon
-- 				)
-- 			)
        )
        catch(MessageBox "Operation Failed" Title:"Poly Editing")
    )
	
	
	 On AltExecute type do 
	(
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
       catch()
	)
)