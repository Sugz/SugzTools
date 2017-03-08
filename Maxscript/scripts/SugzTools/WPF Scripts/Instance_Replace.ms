global Wpf, InstanceReplacer
struct InstanceReplacerStc
(
	Form, Expander, Expanders, MasterObjBtn, ReplaceSelBtn,
	masterObj,


	fn SetMaster = 
	(
		pickedObj = pickObject()
		if pickedObj != undefined then 
		(
			InstanceReplacer.masterObj = pickedObj
			InstanceReplacer.MasterObjBtn.Content = pickedObj.name
			InstanceReplacer.ReplaceSelBtn.IsEnabled = true
		)
		
	),
	
	
	fn ReplaceSelection = 
	(
		undo "Instance Replace" on 
		(
			for obj in selection do 
			(
				tr = obj.transform
				instanceReplace obj (InstanceReplacer.masterObj)
				obj.transform = tr
			)
			
		)
	),

	
	fn SetUI = 
	(
		panel = Wpf.Stackpanel margin:5 spacingVertical:7
		panel.Add(MasterObjBtn = Wpf.Button content:"Pick Master" click:SetMaster)
		panel.Add(ReplaceSelBtn = Wpf.Button content:"Replace Selection" isenabled:false click:ReplaceSelection )
		Expander = Wpf.Expander header:"Instance Replace" content:panel
	),
	

	fn CreateForm = 
	(
		if Expander != undefined then
		(
			Expanders = Wpf.ExpandersControl margin:2
			Expanders.Add Expander
			Form = Wpf.Window title:"Instance Replace" content:Expanders location:#centerParent
			Form.ShowModeless()
			dotNet.setLifetimeControl Form #dotnet
		)
	),
	

	fn Run = 
	(
		if doesFileExist (file = "$userScripts\\SugzTools\\Libs\\WPF\\Wpf_Lib.ms") then 
		(
			fileIn file
			SetUI()
		)
	)
	
)
InstanceReplacer = InstanceReplacerStc()
InstanceReplacer.Run()
InstanceReplacer.CreateForm()
