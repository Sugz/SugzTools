/*##############################################################################
SugzTools Custom Attributes Library
Version 1.0
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Description:
Functions to work with Custom Attributes

# Required Components:
SugzTools Manager

# Sources:

# ToDo:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/



struct CustomAttributesLibraryStc
(
	
	/* Check if an object have a custom attribute ############################################################################################*/
	fn CheckForCustAttr obj attr =
	(
		/*<Function>
		Description:
			Check if an object have a custom attribute
		Arguments:
			<Node> obj: the object to work on
			<Name> attr: the custom attributes to look for
		Return:
			Array<Bool, Integer> hasAttribute: true if the object have the seek attribute and the index, false and -1 otherwise
		</Function>*/
		
		hasAttribute = #(false, -1)
		for i = 1 to custAttributes.count obj do 
		(
			if (custAttributes.getdef obj i).name == attr then hasAttribute = #(true, i)
		)
		
		hasAttribute
	),
	
	
	
	/* Find all objects with a given custom attribute within a given node list ############################################################################################*/
	fn GetObjsWithCA attr nodeList:objects = 
	(
		/*<Function>
		Description:
			Find all objects with a given custom attribute within a given node list
		Arguments:
			<Name> attr: the attribute as name
			Array<Node> nodeList: define the array to limit the search <Optional>
		Return:
			Array<Node> the objects contain in nodelist that have the specified CA
		</Function>*/
		
		
		for obj in nodeList where (CheckForCustAttr obj attr)[1] collect obj
	),
	
	
	
	/* Find a custom attributes on a object and delete it ############################################################################################*/
	fn RemoveCA attr nodeList:objects = 
	(
		/*<Function>
		Description:
			Find a custom attributes on a object and delete it
		Arguments:
			<Name> attr: the attribute as name
			Array <Node> nodeList: define the array to limit the search <Optional>
		</Function>*/
		
		for obj in nodeList where custAttributes.count obj != 0 do 
		(
			hasAttr = CheckForCustAttr obj attr
			if hasAttr[1] then custAttributes.delete obj hasAttr[2]
		)
	
	)
	
)




