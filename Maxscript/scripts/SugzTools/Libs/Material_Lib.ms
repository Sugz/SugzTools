
/*##############################################################################
SugzTools Material Library
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Functions to work with materials

# Required Components:
SugzTools Manager

# Sources:
FrozenKiwi : http://stackoverflow.com/questions/22351548/how-do-i-access-materials-in-maxscript-without-material-editor

# ToDo:

# History:
 
*Use / Modify this script at your own risk !*
###############################################################################*/



struct MaterialLibraryStc
(

	/* Return all material ############################################################################################*/
	fn GetAll =
	(
		/*<Function>
		Description:
			Return all material
		Return:
			<Array <Material>> allMtls: all materials
		Further Infos:
			Snippet by FrozenKiwi : http://stackoverflow.com/questions/22351548/how-do-i-access-materials-in-maxscript-without-material-editor
		</Function>*/
		
		allMtls = #()
		for mtlClasses in material.classes do 
		(
			for mtl in (getClassInstances mtlClasses processAllAnimatables:true) do appendIfUnique allMtls mtl
		)
		
		allMtls
	),	
	
	

	/* Get all Material that have a specific name ############################################################################################*/
	fn GetByName _name =
	(
		/*<Function>
		Description:
			Get all Material that have a specific name
		Arguments:
			<String> _name: the material's name to get the material
		Return:
			<Array <Material>> a list of material that have the exact name
		</Function>*/
		
		for mtl in GetAll() where mtl.name == _name collect mtl
	
	),

	

	/* Get all material which name contain a pattern ############################################################################################*/
	fn GetByPattern _pattern ignoreCase:true =
	(
		/*<Function>
		Description:
			Get all material which name contain a pattern
		Arguments:
		Return:
		</Function>*/
		
		for mtl in GetAll() where (MatchPattern mtl.name pattern:_pattern ignoreCase:ignoreCase) collect mtl
	
	)
	
	
)

