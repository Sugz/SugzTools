
DotNet.LoadAssembly "System.Xml"

global Xml
struct xmlStc 
(
	file,
	doc = dotNetObject "system.xml.xmlDocument",
	root,


	-- Create the xml root node ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn CreateRoot name = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		root = this.CreateNode name
		this.AddNode doc root
	),


	-- Save the xml file ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Save = 
	(
		if file != undefined then doc.save file
	),



	fn CreateNode name = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/

		node = doc.createElement name
		node
	), 


	fn AddAttribute node attribute value = 
	(
		node.SetAttribute attribute value
	),


	fn AddNode parent node =
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

		-- Create a new element and add it to its parent

		parent.AppendChild node
	)

)
Xml = xmlStc()