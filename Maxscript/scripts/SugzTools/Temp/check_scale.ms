/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library

# Sources:

# To do list:
obj.scale.x < 0.999 or obj.scale.x > 1.001
=> if abs(1 - obj.scale.x) > epsilone

# History:

*Use / Modify this script at your own risk !
###############################################################################*/



try(destroyDialog ::ScaledObjectsRoll) catch()
Rollout ScaledObjectsRoll "Scaled Objects"
(
	local objs
	
	listbox objsListLbx width:305 height:30 offset:[0,-7] align:#center
	
	fn GetScaledObjects = 
	(
		objs = #()
		for obj in objects do 
		(
			if obj.scale.x < 0.999 or obj.scale.x > 1.001 or 
				obj.scale.y < 0.999 or obj.scale.y > 1.001 or 
				obj.scale.z < 0.999 or obj.scale.z > 1.001 then append objs obj
		)
		
		_sgz._extMxs.SortObjects objs
	)
	
	on ScaledObjectsRoll open do 
	(
		GetScaledObjects()
		objsListLbx.items = for obj in objs collect obj.name
	)
	
	on objsListLbx selected item do select objs[item]
	
)
createDialog ScaledObjectsRoll 300 391 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)