--clearListener()
global Wpf, Xml, Sgz
struct sugzToolsStc
(
	_expanders,
	xmlFile = @"D:\test.xml",


	fn SaveUI s e = 
	(
		dropExpander = e.Data.GetData ((dotNetObject "SugzTools.Controls.SgzExpander").GetType())

		if doesFileExist (xmlLib = "$userScripts\SugzTools\Libs\\XMLStruct_v1.2.ms") then 
		(
			fileIn xmlLib

			xDoc = XMLDocument()	
			xDoc.file = @"D:\test.xml"
			xDoc.loaded = True
			_root = xDoc.getNewNode "SugzTools"
			xDoc.AppendNode _root
			
			_script = xDoc.getNewNode "script"
			_root.AppendNode _script
			_script.AddAttribute "file" dropExpander.File

			_expander = xDoc.getNewNode "expander"
			_script.AppendNode _expander
			_expander.AddAttribute "var" dropExpander.Var

			xDoc.PrettySaveXML()
		)
	),


	fn GetExpander file name = 
	(
		

	),

	
	fn GetUI = 
	(
		_expanders = Wpf.ExpandersControl margin:3
		dotNet.addEventHandler _expanders "Drop" SaveUI

		if doesFileExist (xmlFile = @"D:\test.xml") then 
		(
			xDoc = XMLDocument()
			xDoc.LoadXML xmlFile
			_root = xDoc.GetRootNode()
			children = _root.GetChildren()
			for _script in _root.GetChildren() do 
			(
				if doesFileExist (_path = _script.GetAttribute "file") then 
				(
					fileIn _path
					for child in _script.GetChildren() do
						_expanders.Items.Add (execute (child.GetAttribute "var"))
				)
			)
		)

	),
	

	fn CreateForm = 
	(
		_form = Wpf.Window title:"SugzTools" content:_expanders location:#centerParent
		_form.ShowInFrame()
		dotNet.setLifetimeControl _expanders #dotnet
	),
	

	fn Run = 
	(
		if doesFileExist (wpfLib = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then fileIn wpfLib
-- 		if doesFileExist (xmlLib = "$userScripts\SugzTools\Libs\\Xml_Lib.ms") then fileIn xmlLib
		if (Wpf != undefined) then 
		(
-- 			Xml.file = @"D:\test.xml"
-- 			Xml.CreateRoot "SugzTools"

-- 			_renamer = Xml.CreateNode "Script"
-- 			Xml.AddAttribute _renamer "file" "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms"

-- 			_expander = Xml.CreateNode "Expander"
-- 			Xml.AddAttribute _expander "name" "renamer"
-- 			Xml.AddNode _renamer _expander

-- 			_expander = Xml.CreateNode "Expander"
-- 			Xml.AddAttribute _expander "name" "test"
-- 			Xml.AddNode _renamer _expander

-- 			Xml.AddNode Xml.root _renamer
-- 			Xml.Save()

			GetUI()
			CreateForm()
		)
	)
	
)
Sgz = sugzToolsStc()
Sgz.Run()