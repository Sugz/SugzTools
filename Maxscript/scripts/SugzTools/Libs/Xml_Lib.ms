
DotNet.LoadAssembly "System.Xml"

global Xml
struct xmlStc 
(
	doc = dotNetObject "system.xml.xmlDocument",
	file,
	root,



	-- Save the xml file ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Save = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		if file != undefined then doc.save file
	),


	-- Load the xml file ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Load = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		if file != undefined then doc.load file
	),


	-- Create the xml root node ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn SetRoot _name = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		root = this.SetNode _name
		this.AppendNode doc root
	),


	-- Get the xml root node ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GetRoot = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		element = doc.documentElement
		if (element != undefined) then
			root = element
	),



	fn SetNode _name = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		doc.createElement _name
	), 


	fn SetAttribute _node _attribute _value = 
	(
		_node.SetAttribute _attribute _value
	),


	fn AppendNode _parent _node =
	(
		/*<Function>
		Description:
			Create a new xml element as child of a given xml element
		Arguments:
			<xml Element> parent : the xml element to add the new xml element to
			<String> type : the type of  the new xml element
		Return:
			<xml Element> newElem : the new xml element
		</Function>*/

		_parent.AppendChild _node
	)

)
Xml = xmlStc()