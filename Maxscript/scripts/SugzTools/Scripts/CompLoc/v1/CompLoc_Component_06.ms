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
Hotspot Manager

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/


global _cplc, _ca, _csv, _hotspot
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
if 	doesFileExist "$userscripts\SugzTools\Scripts\Create_Hotspot.ms" do include "$userscripts\SugzTools\Scripts\Create_Hotspot.ms"
_ca = CustomAttributesLibraryStc()
_csv = SpreadsheetParserLibraryStc()	
_hotspot = HotspotManagerStc()

try(destroyDialog _cplc.View) catch()
try (destroyDialog _hotspot.HotspotMakerView) catch()
try (destroyDialog _hotspot.HotspotListView) catch()

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
	
	
	/* Create the compLoc custom attribute ############################################################################################*/
	fn CreateCompLocCA =
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
				
				
				/* Set the related objects listbox ***************************************************************************************************************************************************************/
				fn UpdateRelatedList = 
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
					UpdateRelatedList()
				)
				
				
				/* Select or create the hotspot ***************************************************************************************************************************************************************/
				on hotspotBtn pressed do 
				(
					-- Select the camera if the hotspot is already defined, create it otherwise
					if this.hotspot != undefined
						then select this.hotspot
						else _hotspot.GetHotspotMakerView()
					
				)
				
				
				/* Change the related objects listbox based on the dropdownlist selection ***************************************************************************************************************************************************************/
				on relativesObjectsDdl selected item do UpdateRelatedList()
				
				
				/* Add picked object to one of the related objects list ***************************************************************************************************************************************************************/
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
				
				
				/*  remove selected object from the listbox of the related objects list***************************************************************************************************************************************************************/
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
				
			) -- End Rollout
		)
	),
	
	
	
	/* Add or Update the comploc custom attribute on selection  ############################################################################################*/
	fn AddCA custAttr =
	(
		if compLocCA == undefined then CreateCompLocCA()
		if not _sgz._sel.IsSelectionEmpty() then (custAttributes.add selection custAttr BaseObject:true)
	),
	
	
	
	/* Remove the comploc custom attribute on a node ############################################################################################*/
	fn RemoveCA _node custAttr =
	(
		/*<Function>
		Arguments:
			<Node> _node: the node to remove the attribute
		</Function>*/
		
		_ca.RemoveCA #compLoc nodeList:(_sgz._extMxs.AsArray _node)
	
	),
	
	
	
	/* Get scene objects that have the comploc custom attribute  ############################################################################################*/
	fn GetSceneComponents custAttr =
	(
		/*<Function>
		Arguments:
			<Name> custAttr: the name of the custom attribute to search for :#compLoc or #hotspotAttr
		Return:
		Further Infos:
		</Function>*/
		
		for obj in (_ca.GetObjsWithCA custAttr) collect obj
	
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
			dotNetControl requiredRelatedObjectsList "listView" width:240 height:110 align:#left offset:[-7,-5]
			
			edittext CSVFileTxt width:185 align:#left offset:[-10,-1] 
			button setCSVFilePathBtn "..." width:25 align:#center offset:[-45,-24] tooltip:"Set the spreadsheet path" enabled:false
			button loadCSVFileBtn "L" width:25 align:#center offset:[-17,-26] tooltip:"Load the spreadsheet" enabled:false
			
			label sceneComponentsLbl "Scene Components :" align:#left offset:[245,-574]
			dotNetControl sceneComponentsList "listView" width:240 height:330 align:#right offset:[7,1]
			button addComponentBtn "Add" width:76  align:#right offset:[-157,-1] 
			button removeComponentBtn "Remove" width:77  align:#right offset:[-75,-26] 
			button reloadComponentsBtn "Reload" width:77  align:#right offset:[7,-26] 
			
			groupbox sceneSeparatorGrp width:230 height:7 align:#right offset:[2,-3]			
			
			button sceneHotspotBtn "Set Hotspot" width:240 height:20 align:#right offset:[7,1]
			dropdownlist sceneRelatedTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#right offset:[7,0]
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
					lv.HideSelection = false
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
					layerName = "optim_components_ata_" + _cplc.atas[atasDdl.selection] as string
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
			
			
			
			
			/* Get all scene components and set the scene component listview ***************************************************************************************************************************************************************/
			fn FillSceneComponentsList = 
			(
				-- Get the scene components
				_cplc.sceneComponents = _cplc.GetSceneComponents #compLoc
				
				-- Clear the listview and add each component
				sceneComponentsList.items.Clear()
				for i = 1 to _cplc.sceneComponents.count  do 
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" (_cplc.sceneComponents[i]).name
					sceneComponentsList.items.add listViewItem
					
					-- select the first item
					if i == 1 then listViewItem.Selected = true
				)

				UpdateSceneComponentLabel()
			)
			
			
			
			/* Set scene related objects listview and hotspot button  ***************************************************************************************************************************************************************/
			fn SetSceneRelated =
			(
				/*<Function>
				Description:
				Arguments:
					<Node> obj: the sceneComponentsList selected component
				Return:
				Further Infos:
				</Function>*/
				
				if sceneComponentsList.items.count != 0 then 
				(
					-- Get the selected scene component
					component = (GetComponent (sceneComponentsList.SelectedItems.Item[0].text))[1]

					-- Get the related objects
					relatedObjNames = case sceneRelatedTypeDdl.selection of
					(
						1: for obj in component.transparent collect obj.name
						2: for obj in component.hidden collect obj.name
						3: for obj in component.animated collect obj.name
					)
					
					-- Fill the listview
					sceneRelatedObjectsList.items.Clear()
					for str in relatedObjNames do 
					(
						listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" str
						sceneRelatedObjectsList.items.add listViewItem
					)
					
					
					sceneHotspotBtn.text = if component.hotspot != undefined then (_sgz._extMxs.CutString component.hotspot.name 220) else "Set Hotspot"
				)
			
			)
			
			
			
			
			/* Events ############################################################################################*/
			on View open do 
			(
				InitListViews()
				SetCSVFilePathEdittext()
				FillSceneComponentsList()
				SetSceneRelated()
				
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
			
			
			
			on sceneComponentsList MouseUp s e do
			(
				hit = sceneComponentsList.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
				if hit.item != undefined then SetSceneRelated()
			)
			
			
			on sceneHotspotBtn pressed do _hotspot.GetHotspotMakerView()
			
			on sceneRelatedTypeDdl selected arg do SetSceneRelated()
			

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
		CreateCompLocCA()
		CreateView()
	)
	
)

_cplc = CompLocComponentStc()
_cplc.Run()
clearListener()
