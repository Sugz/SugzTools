--clearListener()
global Wpf, Xml, Sgz
struct sugzToolsStc
(
	_expanders,



	fn SaveUI s e = 
	(
		dropExpander = e.Data.GetData ((dotNetObject "SugzTools.Controls.SgzExpander").GetType())

		Xml.file = @"D:\test.xml"
		Xml.CreateRoot "SugzTools"

		_script = Xml.CreateNode "Script"
		Xml.AddAttribute _script "file" (dropExpander.tag)
		
		_expander = Xml.CreateNode "Expander"
		Xml.AddAttribute _expander "name" (dropExpander.name)
		Xml.AddNode _script _expander

		Xml.AddNode Xml.root _script
		Xml.Save()
	),


	fn GetExpander file name = 
	(
		

	)

	
	fn GetUI = 
	(
		_expanders = Wpf.ExpandersControl margin:3
		dotNet.addEventHandler _expanders "Drop" SaveUI

		Xml.file = @"D:\test.xml"
		

-- 		dotNet.setLifetimeControl _expanders #dotnet
	),
	

	fn CreateForm = 
	(
		_form = Wpf.Window title:"SugzTools" content:_expanders location:#centerParent
		_form.ShowInFrame()
	),
	

	fn Run = 
	(
		if doesFileExist (wpfLib = "$userScripts\SugzTools\Libs\WPF\Wpf_Lib.ms") then fileIn wpfLib
		if doesFileExist (xmlLib = "$userScripts\SugzTools\Libs\\Xml_Lib.ms") then fileIn xmlLib
		if (Wpf != undefined AND Xml != undefined) then 
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