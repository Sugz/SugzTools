/*##############################################################################
CompLoc Component
Version 0.05
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library
SugzTools Selection Library
Sugztools Spreadsheet Parser Library
SugzTools Custom Attributes Library

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


global _cplc, _custAttr, _csv
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
_custAttr = CustomAttributesLibraryStc()
_csv = SpreadsheetParserLibraryStc()	

try(destroyDialog _cplc.View) catch()

struct CompLocComponentStc
(
	
	atasCol = "3D ATA",
	usersCol = "Graphist",
	namesCol = "Element name in 3D",
	startupVisCol = "Visible at start-up",
-- 	openable = "Openable",
	hotspotCol = "Hotspot location",
	transparentCol = "Transparent Container",
	hiddenCol = "Panel to hide",
	animatedCol = "Animation",
	
	
	compLocCA = undefined,				-- The comploc custom attribute
	View = undefined,							-- The rollout
	atas = #(),										-- The ATAs for current user
	requiredComponents = #(),			-- The required compononts for a given ata
	sceneComponents = #(),				-- The scene objects whose have the comploc custom attribute
	
	
	
	
	
	
	
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
	
	
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout View "CompLoc Components"
		(
			local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
			
			label requiredComponentsLbl "Required Components :" align:#left offset:[-5,0]
			dropdownlist usersDdl width:60 align:#left offset:[114,-21]
			dropdownlist atasDdl width:60 align:#left offset:[174,-27]
			dotNetControl requiredComponentsList "listView" width:240 height:355 align:#left offset:[-7,-3]
			
			groupbox requiredSeparatorGrp width:230 height:7 align:#left offset:[-2,-3]
			
			label requiredHotspotBtn "Hotspot: " width:240 height:20 align:#left offset:[-7,4]
			dropdownlist requiredObjectsTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#left offset:[-7,-3]
-- 			listbox requiredRelatedObjectsList width:240 height:8 align:#left offset:[-7,-5]
			dotNetControl requiredRelatedObjectsList "listView" width:240 height:110 align:#left offset:[-7,-5]
			
			edittext CSVFileTxt width:185 align:#left offset:[-10,-1] 
			button setCSVFilePathBtn "..." width:25 align:#center offset:[-45,-24] tooltip:"Set the spreadsheet path"
			button loadCSVFileBtn "L" width:25 align:#center offset:[-17,-26] tooltip:"Load the spreadsheet" enabled:false
			
			label sceneComponentsLbl "Scene Components :" align:#left offset:[245,-574]
-- 			listbox sceneComponentsList  width:240 height:25 align:#right offset:[7,0]
			dotNetControl sceneComponentsList "listView" width:240 height:330 align:#right offset:[7,1]
			button addComponentBtn "Add" width:76  align:#right offset:[-157,-1] 
			button removeComponentBtn "Remove" width:77  align:#right offset:[-75,-26] 
			button reloadComponentsBtn "Reload" width:77  align:#right offset:[7,-26] 
			
			groupbox sceneSeparatorGrp width:230 height:7 align:#right offset:[2,-3]
			
			button sceneHotspotBtn "Set Hotspot" width:240 height:20 align:#right offset:[7,1]
			dropdownlist sceneRelatedTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#right offset:[7,0]
-- 			listbox sceneRelatedObjectsList width:240 height:8 align:#right offset:[7,-5]
			dotNetControl sceneRelatedObjectsList "listView" width:240 height:110 align:#right offset:[7,-5]
			button sceneAddRelatedBtn "Add Objects" width:115 align:#center offset:[60,-3] 
			button sceneRemoveRelatedBtn "Remove Object" width:115 align:#right offset:[7,-26] 
			
			
			/* Functions ############################################################################################*/
			
			/* Initialize the look and feeel fo the listviews ***************************************************************************************************************************************************************/
			fn InitListViews = 
			(
				for lv in #(requiredComponentsList, requiredRelatedObjectsList, sceneComponentsList, sceneRelatedObjectsList) do 
				(
					--Setup the forms view
					lv.view=(dotNetClass "system.windows.forms.view").details
					lv.FullRowSelect = true
					lv.MultiSelect = false		
					lv.AllowColumnReorder = false
					lv.BackColor = dnColor.FromArgb 255 86 86 86
					lv.ForeColor = dnColor.FromArgb 255 225 225 225
					lv.HeaderStyle = lv.HeaderStyle.None
					lv.columns.add "" 235
				)
			)
			
			
			
			/* Set the spreadsheet file path edittext ***************************************************************************************************************************************************************/
			fn SetCSVFilePathEdittext= 
			(
-- 				CSVFileTxt.text = if _csv.file == undefined then  "Set the spreadsheet path" else (_csv.file as string)
-- 				if _csv.file != undefined then loadCSVFileBtn.enabled = true
					
				if _csv.file != undefined then
				(
					CSVFileTxt.text = _csv.file as string
					loadCSVFileBtn.enabled = true
				)
				else CSVFileTxt.text = "Set the spreadsheet path"
			)
			
			
			
			/* Get objects from a name ***************************************************************************************************************************************************************/
			fn GetComponent name = 
			(
				nodes = (getNodeByName name all:true)
				if atasDdl.items.count != 0 then 
				(
					layerName = "ata" + _cplc.atas[atasDdl.selection] as string+  "_optim_components"
					nodes = for n in nodes where toLower n.layer.name == layerName and IsValidNode n collect n
				)
				
				nodes
			)
			
			
			
			/* Set the scene component label ***************************************************************************************************************************************************************/
			fn UpdateSceneComponentLabel = 
			(
				-- Get the count of required and scene components that match required ones
				requiredCount = _cplc.requiredComponents.count
				if requiredCount != 0 then 
				(
					sceneCount = 0
					for requiredComponent in _cplc.requiredComponents do 
					(
						for sceneComponent in _cplc.sceneComponents do 
							if requiredComponent == sceneComponent then sceneCount += 1
					)
					
					-- Update the scene component label
					sceneComponentsLbl.text = "Scene Components : " + sceneCount as string  + " / " + requiredCount  as string
					
				)
				else sceneComponentsLbl.text = "Scene Components : "
			)
			
			
			
			/* Set the required components listbox ***************************************************************************************************************************************************************/
			fn FillRequiredComponentsList = 
			(
				-- Get the required components for a given ata
				_cplc.requiredComponents = _csv.GetColumn (_csv.GetColumnIndex _cplc.namesCol) columnFilter:(_csv.GetColumnIndex _cplc.atasCol) filter:(_cplc.atas[atasDdl.selection] as string)
				
				-- Clear the listview and add each component
				requiredComponentsList.items.Clear()
				for component in _cplc.requiredComponents do
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" component		
					listViewItem.BackColor = if (GetComponent component).count != 0 then (dnColor.FromArgb 255 30 100 30) else (dnColor.FromArgb 255 150 40 40)
					requiredComponentsList.items.add listViewItem
				)
				
				UpdateSceneComponentLabel()
			)
			
			
			
			/* Set the ATAs dropdownlist ***************************************************************************************************************************************************************/
			fn FillAtasList = 
			(
				-- Fill the atas array and convert their value to integer and fill the dropdownlist
				_cplc.atas = _csv.GetColumn (_csv.GetColumnIndex _cplc.atasCol) columnFilter:(_csv.GetColumnIndex _cplc.usersCol) filter:usersDdl.selected
				_cplc.atas = for ata in _cplc.atas collect (ata as integer)
				atasDdl.items = for ata in _cplc.atas collect ("ATA " + ata as string)
				
				FillRequiredComponentsList()
			)
			
			
			
			/* Get all scene components and set the scene component listbox ***************************************************************************************************************************************************************/
			fn FillSceneComponentsList = 
			(
				-- Get the scene components
				_cplc.sceneComponents = _cplc.GetSceneComponents()
				
				-- Clear the listview and add each component
				sceneComponentsList.items.Clear()
				for component in _cplc.sceneComponents do
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" component.name
					sceneComponentsList.items.add listViewItem
				)

				UpdateSceneComponentLabel()
			)
			
			
			
			/* Load the spreadsheet  ***************************************************************************************************************************************************************/
			fn LoadCSV =
			(
				/*<Function>
				Arguments:
				Return:
				Further Infos:
				</Function>*/
				
				-- Convert the file to CSV if it's a XLSX and fill the edittext with the csv path
				if getFilenameType _csv.file != ".csv" then _csv.ConvertXLSXToCSV "Complete-Unity"
				CSVFileTxt.text = _csv.file
				
				-- Get the user list
				users = _csv.GetColumn (_csv.GetColumnIndex _cplc.usersCol)
				usersDdl.items = for user in users collect user
					
				FillAtasList()
			
			)
			
			
			
			/* Events ############################################################################################*/
			on View open do 
			(
				InitListViews()
				SetCSVFilePathEdittext()
				FillSceneComponentsList()
			)
			
			
			/* Set the CSV file path ***************************************************************************************************************************************************************/
			on setCSVFilePathBtn pressed do 
			(
				filename = getOpenFileName caption:"Open the synthesis file" types:"Excel(*.csv)|*.csv|Excel(*.xlsx, *.xlsm)|*.xlsx;*.xlsm|All|*.*|"
				if filename != undefined then 
				(
					_csv.file = filename
					loadCSVFileBtn.enabled = true
					LoadCSV()
				)
			)
			
			
			on loadCSVFileBtn pressed do LoadCSV()
			
			on usersDdl selected item do FillAtasList()
			
			on atasDdl selected item do FillRequiredComponentsList()
			

		)
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		try(destroyDialog _cplc.View) catch()
		GetView()
		createDialog _cplc.View 500 580 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Execute  ############################################################################################*/
	fn Run = 
	(
-- 		CreateCA()
		CreateView()
	)
	
)

_cplc = CompLocComponentStc()
_cplc.Run()
clearListener()
