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
	requiredComponents = #(),			-- The required compononts for a given ata
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
		
		
		compLocCA = attributes compLoc attribID: #(0x5887f429, 0x3990ace3)
		(
			/* Functions ############################################################################################*/
			/* Get the node this custom attribute is attached to ***************************************************************************************************************************************************************/
			function GetNode = (refs.dependentnodes (custattributes.getowner this) firstonly:on)
			
			
			/* Open the comploc struct ***************************************************************************************************************************************************************/
			function OpenStruct =
			(
				/*<Function>
				Description:
					Open the comploc struct
				</Function>*/
				
				global _cl
				if _cl == undefined then 
					if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
			)
				
				
			parameters params rollout:view
			(
				hotspot type:#node
				fov type:#integer default:40
				transparent type:#nodeTab tabSize:0 tabSizeVariable:on
				hidden type:#nodeTab tabSize:0 tabSizeVariable:on
				animated type:#nodeTab tabSize:0 tabSizeVariable:on
					
				on hotspot set val do this.view.hotspotLbl.text = if this.hotspot != undefined then this.hotspot.name else "No hotspot"
				on fov set val do this.view.fovLbl.text = this.fov as string
			)
			 
			rollout view "CompLoc Component"
			(
				label hotspotLbl width:140 align:#left across:2
				label fovLbl align:#right
				
				on view open do 
				(
					hotspotLbl.text = if this.hotspot != undefined then this.hotspot.name else "No hotspot"
					fovLbl.text = this.fov as string
				)
				
				
			) -- End rollout
			
		) -- End ComplocCA
		
	),
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout CLView "CompLoc Components"
	(
		local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
		local red = dnColor.FromArgb 255 150 40 40
		local green = dnColor.FromArgb 255 30 100 30
		local orange = dnColor.FromArgb 255 158 92 12
		local oldCam = undefined
		
		label requiredComponentsLbl "Required Components :" width:200 pos:[9,5]
		dotNetControl requiredComponentsLbx "listView" width:240 height:338 align:#left offset:[-7,0]
		label requiredHotspotLbl "Hotspot: " align:#left offset:[-7,2]
		label requiredHotspotNameLbl width:110 height:16 style_sunkenedge:true align:#left offset:[40,-19]
		label requiredFovLbl "FOV: " align:#left offset:[180,-20] 
		label requiredFovValueLbl  width:25 height:16 style_sunkenedge:true align:#left offset:[208,-19] 
		
		groupbox separatorGrp width:230 height:7 align:#left offset:[-2,-3]
		
		edittext CSVFileTxt width:185 align:#left offset:[-11,3] text:"Set the spreadsheet path"
		button setCSVFilePathBtn "..." width:25 height:17 align:#left offset:[180,-22] tooltip:"Set the spreadsheet path" 
		button loadCSVFileBtn "L" width:25 height:17 align:#left offset:[208,-22] tooltip:"Load the spreadsheet" enabled:false
		
		label sceneComponentsLbl "Scene Components :" pos:[256,5]
		listbox sceneComponentsLbx  width:240 height:28 align:#center offset:[0,0]
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
			_cl.requiredComponents = _csv.GetColumn (_csv.GetColumnIndex _cl.namesCol) unique:false
			
			if _cl.requiredComponents.count != 0 then 
			(
				-- Clear the listview and add each component
				requiredComponentsLbx.items.Clear()
				for component in _cl.requiredComponents do
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" component		
					
-- 					print ("count: " + (getNodeByName component all:true).count as string)
					if (getNodeByName component all:true).count != 0 then listViewItem.BackColor = green
-- 					else 
-- 					(
-- 						if (GetComponent component layer:"cao").count != 0 
-- 							then (dnColor.FromArgb 255 158 92 12) 
-- 							else (dnColor.FromArgb 255 150 40 40)
-- 					)
					
					requiredComponentsLbx.items.add listViewItem
				)
				
				requiredComponentsLbl.text = "Required Components : (" + _cl.requiredComponents.count as string + ")"
			)
			
			
			
-- 			UpdateSceneComponentLabel()
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
				
				-- Load the required components
				FillRequiredComponentsList()
			)
			else CSVFileTxt.text = "Set the spreadsheet path"
			
		)
		
		
		/* Get all scene components and set the scene component listbox ***************************************************************************************************************************************************************/
		fn FillSceneComponentsList = 
		(
			_cl.sceneComponents = _sgz._extMxs.SortObjects (_ca.GetObjsWithCA #compLoc)
			sceneComponentsLbx.items = for obj in _cl.sceneComponents collect obj.name
			
-- 			UpdateSceneComponentLabel()
		)
		
	
		
		
		
		/* Events ############################################################################################*/
		on CLView open do 
		(
			InitListViews()
			FillSceneComponentsList()
			hotspotDdl.items = for cam in cameras where not isKindOf cam Targetobject and cam.layer.name == "Hotspots" collect cam.name
		)
		
		/* Set the csv path and load the file ***************************************************************************************************************************************************************/
		on setCSVFilePathBtn pressed do LoadCSV()
		
		
		/* Get the assigned hotspot and FOV from required component ***************************************************************************************************************************************************************/
		on requiredComponentsLbx MouseDown s e do
		(
			hit = requiredComponentsLbx.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
			requiredHotspotNameLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.hotspotCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
			requiredFovValueLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.fovCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
		)
		
		
		/* Add scene component ***************************************************************************************************************************************************************/
		/* Remove scene component ***************************************************************************************************************************************************************/
		/* Reload the list ***************************************************************************************************************************************************************/
		on reloadComponentsBtn pressed do FillSceneComponentsList()
		
		/* Set relative ***************************************************************************************************************************************************************/
		on sceneComponentsLbx selected item do 
		(
			component = _cl.sceneComponents[item]
			if component.hotspot != undefined then hotspotDdl.selection = findItem hotspotDdl.items component.hotspot.name
			if component.fov != 0 then fovSpn.value = component.fov
				
			
		)
		
		/* Select the component when double clicked ***************************************************************************************************************************************************************/
		on sceneComponentsLbx doubleClicked item do select _cl.sceneComponents[item]
		
		/* Set the hotspot for selected component ***************************************************************************************************************************************************************/
		on hotspotDdl selected item do 
		(
			-- Reset other cameras 
			if oldCam != undefined then 
			(
				oldCam.target.pos = oldCam.pos
				oldCam.fov = 40
			)
			
			oldCam = getNodeByName (hotspotDdl.selected)
			if selection.count != 1 then oldCam.target.pos = oldCam.pos
			else if (_ca.CheckForCustAttr $ #compLoc)[1] then 
			(
				oldCam.target.pos = $.pos 
				$.hotspot = oldCam
			)
			
			viewport.setCamera oldCam
		)
		
		/* Set the hotspot FOV for selected component ***************************************************************************************************************************************************************/
		on fovSpn changed val do 
		(
			if selection.count == 1 and (_ca.CheckForCustAttr $ #compLoc)[1] then
			(
				 $.fov = val
				if oldCam != undefined then oldCam.fov = val
			)
			
		)
		
		
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
		SetCompLocCA()
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