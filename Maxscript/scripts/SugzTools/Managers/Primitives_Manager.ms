/*##############################################################################
SugzTools Primitives Manager
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager

# Script infos:
Script to manage the parameters when creating primitives

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/



struct PrimitivesManagerStc
(
	
	pManCallback, -- The node event callback
	
	/* Plane parameters ############################################################################################*/
	fn SetPlane = 
	(
		$.lengthsegs = 1
		$.widthsegs = 1
	),
	
	
	/* Cylinder parameters ############################################################################################*/
	fn SetCylinder = 
	(
		$.heightsegs = 1
		$.sides = 12
	),
	
	
	/* Set NGon parameters ############################################################################################*/
	fn SetNgon = 
	(
		$.nsides = 12
	),
	
	
	/* Get the object created and call the function to set its parameters ############################################################################################*/
	fn SetPrimitive ev nd = 
	(
		if isCreatingObject() then 
		(
			case of 
			(
				(isCreatingObject Plane): _sgz._pMan.SetPlane()
				(isCreatingObject Cylinder): _sgz._pMan.SetCylinder()
				(isCreatingObject NGon): _sgz._pMan.SetNgon()
			)
			
			-- avoid the line to goes back to origin
			if not isCreatingObject Line then max modify mode
		)
	),
	
	
	/* Register the node event callback (added) ############################################################################################*/
	fn RegisterCallbacks =
	(
		pManCallback = NodeEventCallback mouseUp:true added:SetPrimitive 
	),
	
	
	/* Remove the node event callback  ############################################################################################*/
	fn RemoveCallbacks =
	(
		pManCallback = undefined
		gc light:true
	)
	
)

-- _sgz._pMan.RegisterCallbacks()
-- _sgz._pMan.RemoveCallbacks()