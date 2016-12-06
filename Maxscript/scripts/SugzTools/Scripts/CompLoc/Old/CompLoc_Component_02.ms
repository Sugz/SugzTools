/*##############################################################################
CompLoc Component
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library
SugzTools Selection Library

# Script infos:

# Sources:

# To do list:
write as struct variables the excel colums

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


global _comp
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
try(destroyDialog _comp.View) catch()


struct CompLocComponentStc
(
	-- the excel columns number
	graphistColumn = 10,
	atasColumn = 7,
	namesColumn = 16,
	hotspotColumn = 18,
	transparentColumn = 19,
	hiddenColumn = 20,
	animatedColumn = 21,
	
	compLocCA = undefined,				-- The comploc custom attribute
	components = #(),							-- Nodes having the comploc custom attribute
	View = undefined,							-- The rollout
	excelFile = undefined,						-- The location of the excel file	
	atas = #(),										-- The ATA for current user
	excel = undefined,							-- The OLE Object for excel
	
	
	/*  ############################################################################################*/
	fn CreateCA =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		compLocCA = attributes compLoc attribID: #(0x5887f429, 0x3990ace3)
		(
			parameters params rollout:view
			(
				hotspot type:#node
				transparent type:#nodeTab tabSize:0 tabSizeVariable:on
				hidden type:#nodeTab tabSize:0 tabSizeVariable:on
				animated type:#nodeTab tabSize:0 tabSizeVariable:on
			)
			 
			rollout view "CompLoc Component"
			(
				button hotspotBtn "Set Hotspot" width:150 align:#center
				dropdownlist relativesObjectsDdl items:#("Transparent", "Hidden", "Animated") width:150 align:#center
				listbox relatedObjectsList width:150 align:#center offset:[0,-5]
				pickbutton addObjectsBtn "Add" width:70 align:#left offset:[-7,-3] across:2 
				button removeObjectsBtn "Remove" width:70 align:#right offset:[7,-3] 
				
				
				fn UpdateList = 
				(
					relatedObjectsList.items = 
					(
						case relativesObjectsDdl.selection of
						(
							1: for obj in this.transparent collect obj.name
							2: for obj in this.hidden collect obj.name
							3: for obj in this.animated collect obj.name
						)
					)
					
				)
				
				on view open do 
				(
					if this.hotspot != undefined then this.view.hotspotBtn.text = _sgz._extMxs.CutString this.hotspot.name 130
					UpdateList()
				)
				
				on hotspotBtn pressed do
				(
					-- Select the camera if the hotspot is already defined, create it otherwise
					if this.hotspot != undefined then select this.hotspot
					else
					(
						-- Get the object and define the hotspot name
						thisObj = (refs.dependents (custAttributes.getOwner this))[1]
						hotspotName = thisObj.name + "_Hotspot"
							
						-- Create a camera, nameit and define it as the hotspot
						macros.run "Lights and Cameras" "PhysicalCamera_CreateFromView"
						$.name = hotspotName
						this.hotspot = $
						
						-- Reselect the component and change the hotspot button text
						select thisObj
						this.view.hotspotBtn.text = _sgz._extMxs.CutString hotspotName 130
					)
				)
				
				on hotspotBtn rightclick do
				(
					if this.hotspot != undefined then
					(
						delete this.hotspot
						this.hotspot = undefined 
						this.view.hotspotBtn.text = "Set Hotspot"
					)
				)
				
				on relativesObjectsDdl selected item do UpdateList()
				
				on addObjectsBtn picked obj do
				(
					case relativesObjectsDdl.selection of
					(
						1: append this.transparent obj
						2: append this.hidden obj
						3: append this.animated obj
					)
					UpdateList()
				)
				
				on removeObjectsBtn pressed do
				(
					case relativesObjectsDdl.selection of
					(
						1: deleteItem this.transparent (relatedObjectsList.selection)
						2: deleteItem this.hidden (relatedObjectsList.selection)
						3: deleteItem this.animated (relatedObjectsList.selection)
					)
					UpdateList()
				)
				
			)
		)
	
	),


	
	/* Add or Update the comploc custom attribute on selection  ############################################################################################*/
	fn AddCA =
	(
		if not _sgz._sel.IsSelectionEmpty() then (custAttributes.add selection compLocCA BaseObject:true)
	),
	
	
	
	/* Remove the comploc custom attribute on a node ############################################################################################*/
	fn RemoveCA _node =
	(
		/*<Function>
		Arguments:
			<Node> _node: the node to remove the attribute
		</Function>*/
		
		_custAttr.RemoveCA #compLoc nodeList:(_sgz._extMxs.AsArray _node)
	
	),
	
	
	
	/* Get scene objects that have the comploc custom attribute  ############################################################################################*/
	fn GetSceneComponents =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		components = for obj in (_custAttr.GetObjsWithCA #compLoc) collect obj
	
	),
	
	
	
	/* Create a temporary excel file and open it as OLE Object ############################################################################################*/
	fn GetExcelOLE =
	(
		if excel == undefined then
		(
			tempFile = (getFilenamePath (_comp.excelFile)) + "\\temp.xlsx"
			copyFile (_comp.excelFile) tempFile
			excel = CreateOLEObject "Excel.Application"
			excel.application.Workbooks.Open(tempFile)
				
			-- set the activesheet
			(excel.Worksheets "Complete-Unity-CPC").Activate 
		)
	),
	
	
	
	/* Delete the temporary excel file and release the OLE Object ############################################################################################*/
	fn DestroyTempXlsx =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		-- exit excel, release ole object and delete the temp excel file
		excel.application.ActiveWorkbook.Close
		excel.quit()
		releaseAllOLEObjects()
		excel = undefined
		deleteFile ((getFilenamePath (_comp.excelFile)) + "\\temp.xlsx")
		
	),
	
	
	
	/* Get Info from the Excel File ############################################################################################*/
	fn GetDataFromXlsx columnToGet arr columnFilter:undefined valueFilter:undefined =
	(
		/*<Function>
		Arguments:
			<Integer> columnFilter : the number of the column to filter the search
			<Generic> valueFilter: the filter 
			<Integer> columnToGet: the column to get data
			<Array <Generic>> arr: the stored datas
		Return:
			<Array <Generic>> arr: the stored datas
		</Function>*/
		
		if excel != undefined then
		(
			-- Get data
			for i = 1 to excel.ActiveSheet.UsedRange.Rows.Count do 
			(
				try 
				(
					if columnFilter != undefined then 
					(
						if  (excel.ActiveSheet.Cells i columnFilter).value == valueFilter then 
						(
							val = (excel.ActiveSheet.Cells i columnToGet).value
							if val != undefined then appendIfUnique arr val
						)
					)
					else 
					(
						val = (excel.ActiveSheet.Cells i columnToGet).value
						if val != undefined then appendIfUnique arr val
					)
					
				) catch()
			)
		)
		
		arr
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout View "CompLoc Components"
		(
			label requiredComponentsLbl "Required Components :" align:#left offset:[-5,0]
			dropdownlist usersDdl width:60 align:#left offset:[114,-21]
			dropdownlist atasDdl width:60 align:#left offset:[174,-27]
			listbox requiredComponentsList  width:240 height:27 align:#left offset:[-7,-5]
			
			groupbox requiredSeparatorGrp width:230 height:7 align:#left offset:[-2,-6]
			
			label requiredHotspotBtn "Hotspot: " width:240 height:20 align:#left offset:[-7,4]
			dropdownlist requiredObjectsTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#left offset:[-7,-3]
			listbox requiredRelatedObjectsList width:240 height:8 align:#left offset:[-7,-5]
			
			edittext excelFileTxt width:185 align:#left offset:[-10,-1] 
			button setExcelFilePathBtn "..." width:25 align:#center offset:[-45,-24] tooltip:"set the excel file path"
			button loadExcelFileBtn "L" width:25 align:#center offset:[-17,-26] tooltip:"Load the Excel file" enabled:false
			
			label sceneComponentsLbl "Scene Components :" align:#left offset:[245,-574]
			listbox sceneComponentsList  width:240 height:25 align:#right offset:[7,0]
			button addComponentBtn "Add" width:76  align:#right offset:[-157,-3] 
			button removeComponentBtn "Remove" width:77  align:#right offset:[-75,-26] 
			button reloadComponentsBtn "Reload" width:77  align:#right offset:[7,-26] 

			groupbox sceneSeparatorGrp width:230 height:7 align:#right offset:[2,-3]
			
			button sceneHotspotBtn "Set Hotspot" width:240 height:20 align:#right offset:[7,1]
			dropdownlist sceneRelatedTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#right offset:[7,0]
			listbox sceneRelatedObjectsList width:240 height:8 align:#right offset:[7,-5]
			button sceneAddRelatedBtn "Add Objects" width:115 align:#center offset:[60,-3] 
			button sceneRemoveRelatedBtn "Remove Object" width:115 align:#right offset:[7,-26] 
			
			
			/* Set the excel file path edittext ***************************************************************************************************************************************************************/
			fn SetExcelFilePathEdittext= 
			(
				excelFileTxt.text = if _comp.excelFile == undefined then  "Set the excel file path" else (_comp.excelFile as string)
				if _comp.excelFile != undefined then loadExcelFileBtn.enabled = true
			)
			
			
			
			/* Get objects from a listbox ***************************************************************************************************************************************************************/
			fn GetComponent list = 
			(
				-- get all nodes named like the required components listbox selected item and only count them if they are placed in the corresponding ata optim component layer
				nodes = getNodeByName list.selected all:true
				layerName = "ATA" + _comp.atas[atasDdl.selection] as string+  "_Optim_Components"
				return (for n in nodes where n.layer.name == layerName and IsValidNode n collect n)
			)
			
			
			
			/* Set the scene component label ***************************************************************************************************************************************************************/
			fn UpdateSceneComponentLabel = 
			(
				-- Get the count of required and scene components that match required ones
				requiredCount = requiredComponentsList.items.count
				if requiredCount != 0 then 
				(
					sceneCount = 0
					for sceneComponent in sceneComponentsList.items do 
					(
						for requiredComponent in requiredComponentsList.items do 
						(
							if sceneComponent == requiredComponent then sceneCount += 1
						)
					)
					
					-- Get the count of found required objects in the scene
					findCount = 0
					for i = 1 to requiredCount do 
					(
						-- get all nodes named like the required components listbox selected item and only count them if they are placed in the corresponding ata optim component layer
						nodes = getNodeByName requiredComponentsList.items[i] all:true
						layerName = "ATA" + _comp.atas[atasDdl.selection] as string+  "_Optim_Components"
						nodes = for n in nodes where n.layer.name == layerName and IsValidNode n collect n
						if nodes.count != 0 then findCount += 1
					)
					
					-- Update the scene component label
					sceneComponentsLbl.text = "Scene Components : " + sceneCount as string  + " / " + requiredCount  as string + " (" + findCount as string + " found)"
				)
				else sceneComponentsLbl.text = "Scene Components : "
				
			)
			
			
			
			/* Set the required components listbox ***************************************************************************************************************************************************************/
			fn FillRequiredComponentsList = 
			(
				-- Create the excel OLE object if necessary
				_comp.GetExcelOLE()
				
				-- Get the components for a given ata
				ataComponents = #()
				_comp.GetDataFromXlsx 16 ataComponents columnFilter:7 valueFilter:_comp.atas[atasDdl.selection]
				requiredComponentsList.items = ataComponents
				
				-- Destroy the excel OLE object
				_comp.DestroyTempXlsx()
				
				UpdateSceneComponentLabel()
			)
			
			
			
			/* Set the ATAs dropdownlist ***************************************************************************************************************************************************************/
			fn FillAtasList = 
			(
				-- Create the excel OLE object if necessary
				_comp.GetExcelOLE()
				
				-- Fill the atas array and convert their value to integer and fill the dropdownlist
				_comp.atas = #()
				_comp.GetDataFromXlsx 7 _comp.atas columnFilter:10 valueFilter:usersDdl.selected
				_comp.atas = for ata in _comp.atas collect (ata as integer)
				atasDdl.items = for ata in _comp.atas collect ("ATA " + ata as string)
				
				FillRequiredComponentsList()
			)
			
			
			
			/* Get all scene components and set the scene component listbox ***************************************************************************************************************************************************************/
			fn FillSceneComponentsList = 
			(
				_comp.GetSceneComponents()
				sceneComponentsList.items = for obj in _comp.components collect obj.name
					
				UpdateSceneComponentLabel()
			)
			
			
			
			/* Set scene related objects listbox and hotspot button ***************************************************************************************************************************************************************/
			fn SetSceneRelatedObjects =
			(
				if sceneComponentsList.items.count != 0 then 
				(
					component = GetComponent sceneComponentsList
					sceneRelatedObjectsList.items = 
					(
						case sceneRelatedTypeDdl.selection of
						(
							1: for obj in component.transparent collect obj.name
							2: for obj in component.hidden collect obj.name
							3: for obj in component.animated collect obj.name
						)
					)
					
					sceneHotspotBtn.text = if component.hotspot != undefined then (_sgz._extMxs.CutString component.hotspot.name 220) else "Set Hotspot"
				)
				
			)
			
			
			
			/* Set the UI on opening ***************************************************************************************************************************************************************/
			on View open do 
			(
				SetExcelFilePathEdittext()
				FillSceneComponentsList()
				SetSceneRelatedObjects()
			)
			
			
			
			/* Set the excel file path ***************************************************************************************************************************************************************/
			on setExcelFilePathBtn pressed do 
			(
				filename = getOpenFileName caption:"Open the Excel synthesis file" types:"Excel(*.xlsx)"
				if filename != undefined then 
				(
					_comp.excelFile = excelFileTxt.text = filename
					loadExcelFileBtn.enabled = true
				)
			)
			
			
			
			/* Load the excel file ***************************************************************************************************************************************************************/
			on loadExcelFileBtn pressed do
			(
				-- Create the excel OLE object if necessary
				_comp.GetExcelOLE()
				
				-- Get the users
				users = #()
				_comp.GetDataFromXlsx 10 users 
				usersDdl.items = for user in users where user != "Graphist" collect user
				
				FillAtasList()
			)
			
			
			on usersDdl selected item do FillAtasList()
			
			on atasDdl selected item do FillRequiredComponentsList()

			on requiredComponentsList doubleClicked item do
			(
				obj = (GetComponent requiredComponentsList)
				if obj != undefined then select obj
			)
				
			
			on sceneComponentsList selected item do SetSceneRelatedObjects()
			on sceneComponentsList doubleClicked item do
			(
				obj = (GetComponent sceneComponentsList)
				if obj != undefined then select obj
			)

			
			/* Add the comploc custom attribute  ***************************************************************************************************************************************************************/
			on addComponentBtn pressed do
			(
				_comp.AddCA()
				FillSceneComponentsList()
			)
			
			
			/* Remove the comploc custom attribute  ***************************************************************************************************************************************************************/
			on removeComponentBtn pressed do
			(
				item = getNodeByName sceneComponentsList.selected
				if item != undefined and IsValidNode item then 
				(
					_comp.RemoveCA item
					FillSceneComponentsList()
				)
				
			)
			
			/* Reload the scene components and related listbox ***************************************************************************************************************************************************************/
			on reloadComponentsBtn pressed do 
			(
				FillSceneComponentsList()
				SetSceneRelatedObjects()
			)
			
			
			/* Set or select the camera used for the hotspot ***************************************************************************************************************************************************************/
			on sceneHotspotBtn pressed do
			(
				component = GetComponent sceneComponentsList
				if component.hotspot != undefined then select component.hotspot
				else
				(
					sel = getCurrentSelection()
					
					-- Define the hotspot name
					hotspotName = component.name + "_Hotspot"
						
					-- Create a camera, nameit and define it as the hotspot
					macros.run "Lights and Cameras" "PhysicalCamera_CreateFromView"
					$.name = hotspotName
					component.hotspot = $
					
					-- Change the hotspot button text
					SetSceneRelatedObjects()
					
					select sel
				)
			)
			
			
			/* Remove the component hotspot ***************************************************************************************************************************************************************/
			on sceneHotspotBtn rightclick do
			(
				component = GetComponent sceneComponentsList
				if component.hotspot != undefined then
				(
					delete component.hotspot
					component.hotspot = undefined 
					SetSceneRelatedObjects()
				)
			)
			
			
			on sceneRelatedTypeDdl selected item do SetSceneRelatedObjects()

			
			/* Add selection as related objects to the scene composant listbox selected item ***************************************************************************************************************************************************************/
			on sceneAddRelatedBtn pressed do
			(
				component = GetComponent sceneComponentsList
				case sceneRelatedTypeDdl.selection of
				(
					1: for obj in selection do append component.transparent obj
					2: for obj in selection do append component.hidden obj
					3: for obj in selection do append component.animated obj
				)
				
				SetSceneRelatedObjects()
			)
			
			/* Remove the scene related objects listbox selected item as a related objects of the scene composant listbox selected item ***************************************************************************************************************************************************************/
			on sceneRemoveRelatedBtn pressed do
			(
				component = GetComponent sceneComponentsList
				case sceneRelatedTypeDdl.selection of
				(
					1: deleteItem component.transparent (sceneRelatedObjectsList.selection)
					2: deleteItem component.hidden (sceneRelatedObjectsList.selection)
					3: deleteItem component.animated (sceneRelatedObjectsList.selection)
				)
				
				SetSceneRelatedObjects()
			)

			
		)
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		try(destroyDialog _comp.View) catch()
		GetView()
		createDialog _comp.view 500 580 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Execute  ############################################################################################*/
	fn Run = 
	(
		CreateCA()
		CreateView()
	)
	
	
)

_comp = CompLocComponentStc()
_comp.Run()
clearListener()

