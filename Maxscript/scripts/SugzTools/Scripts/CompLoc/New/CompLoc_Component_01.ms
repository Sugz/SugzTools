/*##############################################################################
SCRIPT NAME
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !
###############################################################################*/



global _cl, _ca, _csv
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
_ca = CustomAttributesLibraryStc()
_csv = SpreadsheetParserLibraryStc()	

try(destroyDialog _cl.CLView) catch()
-- try (destroyDialog _hotspot.HotspotListView) catch()


struct CompLocComponentStc
(
	-- the excel columns number
	namesCol = "Element name in 3D",
	hotspotCol = "Final Hotspot",
	fovCol = "FOV",
	transparentCol = "Transparent Container",
	hiddenCol = "Panel to hide",
	animatedCol = "Animation",
	
	compLocCA = undefined,				-- The comploc custom attribute
	CLView = undefined,						-- The rollout
	sceneComponents = #(),				-- The scene objects whose have the comploc custom attribute
	
	
	/* The Comploc custom attribute ############################################################################################*/
	fn SetCompLocCA =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		
-- 		compLocCA = attributes compLoc attribID: #(0x5887f429, 0x3990ace3)
-- 		(
-- 			/* Functions ############################################################################################*/
-- 			/* Get the node this custom attribute is attached to ***************************************************************************************************************************************************************/
-- 			function GetNode = (refs.dependentnodes (custattributes.getowner this) firstonly:on)
-- 			
-- 			
-- 			/* Open the comploc struct ***************************************************************************************************************************************************************/
-- 			function OpenStruct =
-- 			(
-- 				/*<Function>
-- 				Description:
-- 					Open the comploc struct
-- 				</Function>*/
-- 				
-- 				global _cl
-- 				if _cl == undefined then 
-- 					if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
-- 			)
-- 				
-- 				
-- 			parameters params rollout:view
-- 			(
-- 				hotspot type:#node
-- 				fov type:#integer
-- 				transparent type:#nodeTab tabSize:0 tabSizeVariable:on
-- 				hidden type:#nodeTab tabSize:0 tabSizeVariable:on
-- 				animated type:#nodeTab tabSize:0 tabSizeVariable:on
-- 			)
-- 			 
-- 			rollout view "CompLoc Component"
-- 			(
-- 				groupbox hotspotGrp " Hotspot: " width:150 height:95 align:#right offset:[7,0]
-- 				radiobuttons locationTypeRdb labels:#("Outside", "Inside") align:#left offset:[0,-80] offsets:#([0,0], [15,0])
-- 				dropdownlist locationDdl width:140 align:#center
-- 				button hotspotBtn "Set Hotspot" width:140 align:#center
-- 				
-- 				dropdownlist relativesObjectsDdl items:#("Transparent", "Hidden", "Animated") width:150 align:#center offset:[0,10]
-- 				listbox relatedObjectsList width:150 height:7 align:#center offset:[0,-5]
-- 				pickbutton addObjectsBtn "Add" width:70 align:#left offset:[-7,-3] across:2 
-- 				button removeObjectsBtn "Remove" width:70 align:#right offset:[7,-3] 
-- 				
-- 				
-- 				/* Functions ############################################################################################*/
-- 				/* Set the related objects listbox ***************************************************************************************************************************************************************/
-- 				function UpdateRelatedList = 
-- 				(
-- 					relatedObjectsList.items = 
-- 					(
-- 						case relativesObjectsDdl.selection of
-- 						(
-- 							1: for obj in this.transparent where obj != undefined collect obj.name
-- 							2: for obj in this.hidden where obj != undefined collect obj.name
-- 							3: for obj in this.animated where obj != undefined collect obj.name
-- 						)
-- 					)
-- 					
-- 				)
-- 				
-- 				
-- 				/* Get hotspot infos ***************************************************************************************************************************************************************/
-- 				function GetHotspotInfos = 
-- 				(
-- 					if this.hotspot != undefined then 
-- 					(
-- 						locationTypeRdb.state = this.hotspot.locationType
-- 						locationDdl.selection = this.hotspot.location
-- 						hotspotBtn.text = "Select Hotspot"
-- 					)
-- 				)
-- 				
-- 				
-- 				
-- 				/* Events ############################################################################################*/
-- 				on compView open do 
-- 				(
-- 					OpenStruct()
-- 					GetHotspotInfos()
-- 					UpdateRelatedList()
-- 					
-- 					locationDdl.items = _cplc.GetLocations locationTypeRdb.state
-- 				)
-- 				
-- 				
-- 				
-- 				/* Set the hotspot locationtype and change the UI accordingly ***************************************************************************************************************************************************************/
-- 				on locationTypeRdb changed val do 
-- 				(
-- 					locationDdl.items = _cplc.GetLocations locationTypeRdb.state
-- 					locationDdl.selection = 1
-- 					
-- 					if this.hotspot != undefined then 
-- 					(
-- 						this.hotspot.locationType = val
-- 						this.hotspot.location = 1
-- 					)
-- 				)
-- 				
-- 				
-- 				
-- 				/* Set the hotspot location ***************************************************************************************************************************************************************/
-- 				on locationDdl selected item do 
-- 				(
-- 					if this.hotspot != undefined then this.hotspot.location = item
-- 				)
-- 				
-- 				
-- 				/* Select or create the hotspot ***************************************************************************************************************************************************************/
-- 				on hotspotBtn pressed do 
-- 				(
-- 					-- Select the camera if the hotspot is already defined, create it otherwise
-- 					if this.hotspot != undefined
-- 						then select this.hotspot
-- 						else _cplc.CreateHotspot (GetNode()) locationTypeRdb.state locationDdl.selection
-- 					
-- 				)
-- 				

-- 				
-- 				/* Change the related objects listbox based on the dropdownlist selection ***************************************************************************************************************************************************************/
-- 				on relativesObjectsDdl selected item do UpdateRelatedList()
-- 				
-- 				
-- 				
-- 				/* Add picked object to one of the related objects list ***************************************************************************************************************************************************************/
-- 				on addObjectsBtn picked obj do
-- 				(
-- 					case relativesObjectsDdl.selection of
-- 					(
-- 						1: append this.transparent obj
-- 						2: append this.hidden obj
-- 						3: append this.animated obj
-- 					)
-- 					UpdateRelatedList()
-- 				)
-- 				
-- 				
-- 				
-- 				/*  Remove selected object from the listbox of the related objects list***************************************************************************************************************************************************************/
-- 				on removeObjectsBtn pressed do
-- 				(
-- 					case relativesObjectsDdl.selection of
-- 					(
-- 						1: deleteItem this.transparent (relatedObjectsList.selection)
-- 						2: deleteItem this.hidden (relatedObjectsList.selection)
-- 						3: deleteItem this.animated (relatedObjectsList.selection)
-- 					)
-- 					UpdateRelatedList()
-- 				)
-- 				
-- 			) -- End rollout
-- 			
-- 		) -- End ComplocCA
		
	),
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout CLView "CompLoc Components"
	(
		local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
		local red = dnColor.FromArgb 255 150 40 40
		local green = dnColor.FromArgb 255 30 100 30
		local orange = dnColor.FromArgb 255 158 92 12
		
		label requiredComponentsLBL "Required Components :" pos:[9,5]
		dotNetControl requiredComponentsLbx "listView" width:240 height:350 align:#left offset:[-7,0]
		label requiredHotspotLbl "This is a hotspot"  align:#left offset:[-7,2] 
		label requiredFovLbl "FOV: 60" width:50  align:#left offset:[185,-18] 
		
		edittext CSVFileTxt width:185 align:#left offset:[-11,2] 
		button setCSVFilePathBtn "..." width:25 height:17 align:#left offset:[180,-22] tooltip:"Set the spreadsheet path" 
		button loadCSVFileBtn "L" width:25 height:17 align:#left offset:[208,-22] tooltip:"Load the spreadsheet" enabled:false
		
		label sceneComponentsLbl "Scene Components :" pos:[256,5]
		listbox sceneComponentsList  width:240 height:28 align:#center offset:[0,0]
		button addComponentBtn "Add" width:76  align:#center offset:[-82,-3] 
		button removeComponentBtn "Remove" width:77  align:#center offset:[00,-26] 
		button reloadComponentsBtn "Reload" width:76  align:#center offset:[82,-26] 
		
		label hotspotLbl "Hotspot :" pos:[506,5]
		dropdownlist hotspotDdl width:170 align:#right offset:[-63,0]
		spinner fovSpn width:60 range:[10,80,40] type:#integer align:#right offset:[7,-25] 
		
		label hiddenLbl "Hidden Objects :" align:#right offset:[-151,11]
		listbox hiddenLbx width:240 height:8 align:#right offset:[7,0]
		button addHiddenBtn "Add Hidden" width:115 align:#right offset:[-118,-3] 
		button removeHiddenBtn "Remove Hidden" width:115 align:#right offset:[7,-26] 
		
		label transparentLbl "Transparent Objects :" align:#right offset:[-125,12]
		listbox transparentLbx width:240 height:3 align:#right offset:[7,0]
		button addTransparentBtn "Add Transparent" width:115 align:#right offset:[-118,-3] 
		button removeTransparentBtn "Remove Transparent" width:115 align:#right offset:[7,-26] 
		
		label animatedLbl "Animated Objects :" align:#right offset:[-139,12]
		listbox animatedLbx width:240 height:3 align:#right offset:[7,0]
		button addAnimatedBtn "Add Animated" width:115 align:#right offset:[-118,-3] 
		button removeAnimatedBtn "Remove Animated" width:115 align:#right offset:[7,-26] 
		
		
		/* Functions ############################################################################################*/
			
		/* Initialize the look and feeel fo the listviews ***************************************************************************************************************************************************************/
		fn InitListViews = 
		(
			for lv in #(requiredComponentsLbx) do 
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
				listViewItem.BackColor = if (GetComponent component).count != 0 then (dnColor.FromArgb 255 30 100 30) 
				else 
				(
					if (GetComponent component layer:"cao").count != 0 
						then (dnColor.FromArgb 255 158 92 12) 
						else (dnColor.FromArgb 255 150 40 40)
				)
				
				requiredComponentsList.items.add listViewItem
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
			
			
			if _csv.GetFile() != undefined then
			(
				-- Convert the file to CSV if it's a XLSX and fill the edittext with the csv path
				if getFilenameType _csv.file != ".csv" then _csv.ConvertXLSXToCSV "Complete-Unity"
				CSVFileTxt.text = _csv.file
				loadCSVFileBtn.enabled = true
			)
		)
		
		
		
		/* Events ############################################################################################*/
		on CLView open do 
		(
			InitListViews()
			hotspotDdl.items = for cam in cameras where not isKindOf cam Targetobject and cam.layer.name == "Hotspots" collect cam.name
		)
		
		/* Set the csv path and load the file ***************************************************************************************************************************************************************/
		on setCSVFilePathBtn pressed do LoadCSV()
		
		
	),
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		try(destroyDialog _cl.CLView) catch()
		GetView()
		createDialog _cl.CLView 750 425 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Execute  ############################################################################################*/
	fn Run = 
	(
-- 		SetCompLocCA()
		
		sceneComponents = _ca.GetObjsWithCA #compLoc
	),
	
	
	/* Open CplcView Macroscript ############################################################################################*/
	macroUI =
	(
		macroScript CompLocComponents
			category:"SugzTools"
			toolTip:"CompLoc Components"
			Icon:#("Comploc",1)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.CreateView()
				)
			)
		)
		
	),
	
	
	
	/* Check if scene components has no undefined relatives ############################################################################################*/
	macroChecker =
	(
		macroScript CompLocChecker
			category:"SugzTools"
			toolTip:"CompLoc Checker"
			Icon:#("Comploc",2)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.ComponentChecker()
				)
			)
		)
	),
	
	
	
	/* Export components informations to excel ############################################################################################*/
	macroExport =
	(
		macroScript CompLocExcelExporter
			category:"SugzTools"
			toolTip:"CompLoc Excel Exporter"
			Icon:#("Comploc",3)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.ExcelExport()
				)
			)
		)
	)
	
	
)

if heapSize < 100000000 then heapSize += 85000000
_cl = CompLocComponentStc()
_cl.Run()