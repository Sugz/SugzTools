/*##############################################################################
SugzTools Node Properties Library
Version 1.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Functions to work with node properties

# Required Components:
SugzTools Manager
SugzTools Selection Library

# Sources:

# To do list:

# History:
1.01: 
 - Add GetBackFaceCull from ModelingUI
1.0:
 - Add GetFlags and SetFlags

*Use / Modify this script at your own risk !*
###############################################################################*/


struct NodePropertiesStc
(
	
	/* Set the backfacecull checkbox depending of the current selection ############################################################################################*/
	fn GetBackFaceCull = 
	(
		/*<Function>
		Description:
			Set the backfacecull checkbox depending of the current selection
		</Function>*/

		-- define the checkbox state and current selection
		triState = 0
		
		-- check if one object have backface Cull, then check the other object to see if one doesn't
		for obj in selection while triState != 1 do if obj.backfaceCull then triState = 1
		if triState == 1 then for obj in selection while triState != 2 do if not obj.backfaceCull then triState = 2
		
		triState
	),
	
	

	/* Get transform locks or inherit flags ############################################################################################*/
	fn GetFlags nodes operation =
	(
		/*<Function>
		Description:
			Get transform locks or inherit flags
		Arguments:
			<Array <Node>> nodes: the nodes to get transform locks or inherit flags
			<Name> operation: choose between #locks or #inherit 
		Return:
			<Array <Integer>> flagsTriState: the move, rotate and scale tristate
		</Function>*/
		
		flagsTriState = #(0, 0, 0)
		andTest = #{1..9}
		orTest = #{}
		
		for obj in selection do 
		(
			objFlags = case operation of (#locks: getTransformLockFlags obj; #inherit: getInheritanceFlags obj)
			andTest *= objFlags
			orTest += objFlags
		)
		
		if andTest[1] and andTest[2] and andTest[3] then flagsTriState[1] = 1
		else if orTest[1] or orTest[2] or orTest[3] then flagsTriState[1] = 2
		
		if andTest[4] and andTest[5] and andTest[6] then flagsTriState[2] = 1
		else if orTest[4] or orTest[5] or orTest[6] then flagsTriState[2] = 2
			
		if andTest[7] and andTest[8] and andTest[9] then flagsTriState[3] = 1
		else if orTest[7] or orTest[8] or orTest[9] then flagsTriState[3] = 2
	
		flagsTriState
	),
	
	
	
	/* Set transform locks or inherit flags ############################################################################################*/
	fn SetFlags nodes state type operation = 
	(
		/*<Function>
		Description:
			Set transform locks or inherit flags
		Arguments:
			<Array <Node>> nodes: the nodes to get transform locks or inherit flags
			<Bool> state: to decide to activate or deactivate the flags
			<Name> type: to choose between the #move, #rotate and #scale flags
			<Name> operation: choose between #locks or #inherit 
		</Function>*/
		
		local bits
		case type of
		(
			#move: bits = #{1..3}
			#rotate: bits = #{4..6}
			#scale: bits = #{7..9}
		)
		
		for obj in nodes do
		(
			case operation of
			(
				#locks:
				(
					flags = getTransformLockFlags obj
					if state 
						then setTransformLockFlags obj (bits+ flags)
						else setTransformLockFlags obj (flags - bits)
				)
				#inherit:
				(
					flags = getInheritanceFlags obj
					if state 
						then setInheritanceFlags obj (bits+ flags)
						else setInheritanceFlags obj (flags - bits)
				)
			)
		)
	)

)