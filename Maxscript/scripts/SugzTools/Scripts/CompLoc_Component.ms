/*##############################################################################
CompLoc Component
Version 3.05
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library
SugzTools Custom Attributes Library
SugzTools Spreadsheet Parser Library

# Sources:

# To do list:
 - Put the function to load the CSV,  add component and its relatives in the strcut instead of the Rollout to use them in the excel import
 - Always break instance when setting object as component
 - Create general function to add scene component, hidden, transparent and animated relative (fo the copy paste)
 - Transparent: radiobutton to decide to use xray or to hide (or simple checkbox with hide)

# History:
3.0:
	- Add ExcludedObjects to store objects that need to stay hidden when changing relatives objects 
	- Add CreateHotspotList and ExportHotspotList macros
	- Remove the Update scene function as it became irrelevant
	- Delete the relativeName parameter in the custom attribute as it doesn't work to when mergin scene together...
	- Add Function to make the component from the excel file
2.0:
	- Rewrite everything from the ground up and make a huge simplification

*Use / Modify this script at your own risk !


(
	component = $
	format "Component: %\nHotspot: %\nFOV: %\nTransparent: %\nHidden: %\nAnimated: %"component.name (_cl.GetHotspot component.hotspot) (component.fov as string) (_cl.GetRelatives component.transparent) (_cl.GetRelatives component.hidden) (_cl.GetRelatives component.animated)
	
)
###############################################################################*/



global _cl, _ca, _csv
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
_ca = CustomAttributesLibraryStc()
_csv = SpreadsheetParserLibraryStc()	

try(destroyDialog _cl.CLView) catch()
-- try (destroyDialog _hotspot.HotspotListView) catch()

struct TempRelativesStc
(
	hotspot,
	fov,
	hidden,
	transparent,
	animated
)


struct CompLocComponentStc
(
	-- the excel columns number
	ataCol = "ATA",
	namesCol = "Element name in 3D",
	hotspotCol = "Final Hotspot",
	fovCol = "FOV",
	transparentCol = "Transparent Container",
	hiddenCol = "Panel to hide",
	animatedCol = "Animation",
	hotspotLayer = "zzz_Hotspots",
	
	compLocCA = undefined,				-- The comploc custom attribute
	CLView = undefined,					-- The rollout
	requiredComponents = #(),			-- The required compononts for a given ata
	sceneComponents = #(),				-- The scene objects whose have the comploc custom attribute
	hotspotHT = #(),					-- The hotspot hashtable (name, position) 
	excludedObjects = #(),				-- The objects to keep hidden
	brokenComponents = #(),				-- The scene components with undefined relative
	


	/* Set the hotspot hashtable ############################################################################################*/
	fn SetHotspotHT =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		hotspotHT = #()
		if _csv.GetFile "Open the Hotspots.csv file" != undefined then
		(
			-- Read each row and parse them (name and position)
			for i = 2 to _csv.GetRowCount() do 
			(
				row = _csv.GetRow i unique:false
				
				stringPos = filterString row[2] ", "
				pos = [0,0,0]
				pos[1] = stringPos[1] as float * -10
				pos[2] = stringPos[3] as float * -10
				pos[3] = stringPos[2] as float * 10
				
				append hotspotHT #(row[1], pos)
			)
		)
	),
	
	
	
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
			/* Get the node this custom attribute is attached to ***************************************************************************************************************************************************************/
			function GetNode = (refs.dependentnodes (custattributes.getowner this) firstonly:on)
			
			
			parameters params rollout:view
			(
				hotspot type:#node
				fov type:#integer default:40
				hidden type:#maxObjectTab tabSizeVariable:true
				transparent type:#maxObjectTab tabSizeVariable:true
				animated type:#maxObjectTab tabSizeVariable:true
					
				on hotspot set val do if val != undefined then this.view.hotspotLbl.text = substring (val.name) ((GetNode()).name.count + 2) -1
				on fov set val do this.view.fovLbl.text = this.fov as string
				on hidden tabChanged arg1 arg2 arg3 do this.view.hiddenLbx.items = for obj in hidden where obj.node != undefined collect obj.node.name
				on transparent tabChanged arg1 arg2 arg3 do this.view.transparentLbx.items = for obj in transparent where obj.node != undefined collect obj.node.name
				on animated tabChanged arg1 arg2 arg3 do this.view.animatedLbx.items = for obj in animated where obj.node != undefined collect obj.node.name
			)
			 
			rollout view "CompLoc Component"
			(
				groupbox hotspotGrp "Hotspot" height:40 width:150 align:#center
				label hotspotLbl width:140 align:#left across:2 offset:[0,-25]
				label fovLbl align:#right offset:[0,-25]
				listbox hiddenLbx "Hidden Objects" height:10 width:150 align:#center offset:[0,10]
				listbox transparentLbx "Transparent Objects" height:3 width:150 align:#center offset:[0,5]
				listbox animatedLbx "Animated Objects" height:3 width:150 align:#center offset:[0,5]
				
			
				
				on view open do 
				(
					if this.hotspot != undefined then hotspotLbl.text = substring (this.hotspot.name) ((GetNode()).name.count + 2) -1
					fovLbl.text = this.fov as string
					hiddenLbx.items = for obj in this.hidden where obj.node != undefined collect obj.node.name
					transparentLbx.items = for obj in this.transparent where obj.node != undefined collect obj.node.name
					animatedLbx.items = for obj in this.animated where obj.node != undefined collect obj.node.name
				)
				
				
			) -- End rollout
			
		) -- End ComplocCA
		
	),
	
	
	
	/* Clean the scene from the complocCA ############################################################################################*/
	fn CleanScene =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/

		if selection.count > 0 then 
		(
			if (queryBox "Are you sure you want to remove the comploc custom attribute on every object of the selection ?" title:"Comploc Scene Cleaner" beep:false) then
			(
				for obj in selection where (_ca.CheckForCustAttr obj #compLoc)[1] do (if obj.hotspot != undefined then delete obj.hotspot)
				_ca.RemoveCA #compLoc nodeList:selection
			)
		)
		else if (queryBox "Are you sure you want to remove the comploc custom attribute on every object of the scene ?" title:"Comploc Scene Cleaner" beep:false) then
		(
			_ca.RemoveCA #compLoc nodeList:sceneComponents
			delete (for cam in cameras where cam.layer.name == _cl.hotspotLayer collect cam)
		)
			
	),
	
	
	
	/* Loop from every component and take a Screenshot from its hotspot ############################################################################################*/
	fn MakeScreenshot =
	(
		/*<Function>
		Description:
			Loop from every component and take a ScreenShot from its hotspot
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		path = _sgz._extMxs.GetWinFolders #MyPictures + "\\Hotspots\\"
		if not (doesFileExist path) then makeDir path
		
		toolmode.commandmode = #select
		for obj in sceneComponents while NOT keyboard.escPressed do
		(
			try 
			(
				-- Unhide and unxray everything 
				objects.isHidden = objects.xray = false
				
				-- Hide hotspots and covers if needed
				if findItem excludedObjects obj != 0 then 
					(for obj in objects where matchPattern obj.layer.name pattern:"zzz_*" collect obj).isHidden = true
				else 
				(
					excluded = join #() _cl.excludedObjects
					join excluded (for obj in objects where matchPattern obj.layer.name pattern:"zzz_*" collect obj)
					(for obj in objects where findItem excluded obj != 0 collect obj).isHidden = true
				)
				
				-- Select the object to get its wiewport selection outline and switch to its hotspot view
				select obj
				if obj != undefined then (if isKindOf obj helper then select (_sgz._sel.GetHierarchy children:true))

				viewport.setCamera obj.hotspot
				sliderTime = 0f
				
				-- Set hidden and xray objects and go the the last animationo frame if needed
				(for relative in obj.hidden collect relative.node).isHidden = true
				(for relative in obj.transparent collect relative.node).xray = true
				if obj.animated.count != 0 then sliderTime = 50f
				
				-- Save the screenshot as bitmap 
				redrawViews()
				ssBitmap3 = viewport.getViewportDib()
				ssBitmap3.filename = path + obj.name + ".jpg"
				save ssBitmap3 quiet:true
			) 
			catch(print obj.name)
		)
		
		objects.isHidden = objects.xray = false
		(for o in objects where o.layer.name == _cl.hotspotLayer or o.layer.name == "H135_covers" collect o).isHidden = true
		sliderTime = 0f
		
	),
	
	
	
	/* Get a formated position of an hotspot ############################################################################################*/
	fn GetHotspot hotspot = 
	(
		str = ""
		
		if hotspot != undefined then 
		(
			hasTarget = false
			if hotspot.targeted then 
			(
				hasTarget = true 
				hotspot.targeted = false
			)
			
			for item in hotspotHT while str == "" do 
				if _sgz._extMxs.ArePtsEquivalent item[2] (hotspot.pos) then str = item[1]
				
			if hasTarget then hotspot.targeted = true
		)
			
		str
	),
	
	
	
	/* Get a formated position of the hotspot to export it ############################################################################################*/
	fn GetHotspotPos cam = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		hasTarget = false
		if cam.targeted then 
		(
			hasTarget = true 
			cam.targeted = false
		)
		
		ss = StringStream ""
		p = cam.pos
		
		format "%, %, %" (-p[1]/10) (p[3]/10) (-p[2]/10) to:ss
		
		if hasTarget then cam.targeted = true
			
		ss as string
	),



	/* Get a formated rotation of the hotspot to export it ############################################################################################*/
	fn GetHotspotQuat cam = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		hasTarget = false
		if cam.targeted then 
		(
			hasTarget = true 
			cam.targeted = false
		)
		
		ss = StringStream ""

		oldEuler = cam.rotation as eulerAngles
		quat = eulerToQuat (eulerAngles (oldEuler.x + 90.0) oldEuler.y oldEuler.z)
		
		format "%, %, %, %" quat.x -quat.y quat.z -quat.w to:ss
		
		if hasTarget then cam.targeted = true
			
		ss as string
	),
	
	
	
	/* Get a formated list of relatives objects of a component ############################################################################################*/
	fn GetRelatives relatives =
	(
		ss = StringStream ""
		for i = 1 to relatives.count do 
		(
			if relatives[i].node != undefined then 
			(
				append ss (relatives[i].node.name)
				if i != relatives.count then append ss ", "
			)
			--else format "relatives: %\n" relatives
		)
		
		ss as string
	),
	
	
	
	/* Export to a excel file the component and related objects list ############################################################################################*/
	fn ExcelExport =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		-- Set the hotspot hashtable
		if _cl.hotspotHT.count == 0 then _cl.SetHotspotHT()
		
		-- Open the excel file
		if _csv.GetFile "Open the synthesis file" excel:true != undefined then
		(
			_csv.GetExcelOLE()
			
			-- Open the correct activesheet
			try ((_csv.excel.Worksheets "FromMax").Activate) 
			catch 
			(
				_csv.excel.ActiveWorkbook.Sheets.Add
				_csv.excel.ActiveSheet.Name = "FromMax"
			)
			
			-- Define Columns name
			col = #("A", "B", "C", "D", "E", "F")
			colName = #("Element name in 3D", "Final Hotspot", "FOV", "Transparent Container", "Panel to hide", "Animation")
			for i = 1 to col.count do (_csv.excel.application.Range(col[i] + 1 as string)).value = colName[i]
				
			-- Write values
			i = 2
			for component in _cl.sceneComponents do 
			(
				format "%: %\n" (i-1) component.name
				
				(_csv.excel.application.Range("A" + i as string)).value = component.name
				(_csv.excel.application.Range("B" + i as string)).value = _cl.GetHotspot component.hotspot
				(_csv.excel.application.Range("C" + i as string)).value = component.fov as string
				(_csv.excel.application.Range("D" + i as string)).value = _cl.GetRelatives component.transparent
				(_csv.excel.application.Range("E" + i as string)).value = _cl.GetRelatives component.hidden
				(_csv.excel.application.Range("F" + i as string)).value = _cl.GetRelatives component.animated
				
				i += 1
			)
			
			-- Save and close excel
			_csv.excel.DisplayAlerts = false
			_csv.excel.application.ActiveWorkbook.SaveAs(_csv.file)
			_csv.DestroyExcelOLE()
			
			messageBox "The writing on the excel file has gone well ;)"
		)
		
	),
	
	/* Use a backgroundworker to avoid blocking the UI when exporting the excel list ############################################################################################*/
	fn ExcelExportBackgroundWorker = 
	(
		clearListener()
		Worker = DotNetObject "CSharpUtilities.SynchronizingBackgroundWorker"
		dotNet.addEventHandler Worker "DoWork" ExcelExport
		if not Worker.IsBusy do Worker.RunWorkerAsync()
	),
	
	
	
	/* Import from an excel file the components and related objects list ############################################################################################*/
	fn ExcelImport =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		
		-- Set the hotspot hashtable
		if _cl.hotspotHT.count == 0 then _cl.SetHotspotHT()
		
		
		if _csv.GetFile "Open the synthesis file" != undefined then
		(
			-- Convert the file to CSV if it's a XLSX and fill the edittext with the csv path
			if getFilenameType _csv.file != ".csv" then _csv.ConvertXLSXToCSV "FromMax"
			
			excelComponents = _sgz._extMxs.SortStrings (_csv.GetColumn (_csv.GetColumnIndex namesCol) unique:false)
			
			for str in excelComponents do 
			(
				-- Get the Object and add it the complocCA
				obj = getNodeByName str
				if obj != undefined then 
				(
					-- make the object unique to avoid instance
					InstanceMgr.MakeObjectsUnique obj #individual
					
					custAttributes.add obj compLocCA BaseObject:true
				
					-- create its hotspot
					hotspotName = (_csv.GetColumn (_csv.GetColumnIndex hotspotCol) columnFilter:(_csv.GetColumnIndex namesCol) filter:str unique:false)[1]
					hotspotPos = _sgz._extMxs.GetHashTableValue hotspotHT hotspotName
					hotspotFov = (_csv.GetColumn (_csv.GetColumnIndex fovCol) columnFilter:(_csv.GetColumnIndex namesCol) filter:str unique:false)[1] as integer
					
					cam = Physical_Camera name:(obj.name + "_" + hotspotName) pos:hotspotPos specify_fov:on
					cam.fov = hotspotFov 
					cam.targeted = true
					cam.target.pos = obj.center
					
					LayerManager.newLayerFromName _cl.hotspotLayer
					(LayerManager.getLayerFromName _cl.hotspotLayer).addNode cam
					(LayerManager.getLayerFromName _cl.hotspotLayer).addNode (cam.target)
					
					obj.hotspot = cam
					obj.fov = hotspotFov
					
					setTransformLockFlags cam #{1..9}
					setTransformLockFlags (cam.target) #{1..9}
					
					-- add relatives
					hiddenNames = filterString (_csv.GetColumn (_csv.GetColumnIndex hiddenCol) columnFilter:(_csv.GetColumnIndex namesCol) filter:str unique:false)[1] ", "
					for hiddenName in hiddenNames do 
					(
						hiddenObj = getNodeByName hiddenName
						if hiddenObj != undefined then append obj.hidden (nodeTransformMonitor node:hiddenObj forwardTransformChangeMsgs:false)
					)
					
					
					transparentNames = filterString (_csv.GetColumn (_csv.GetColumnIndex transparentCol) columnFilter:(_csv.GetColumnIndex namesCol) filter:str unique:false)[1] ", "
					for transparentName in transparentNames do 
					(
						transparentObj = getNodeByName transparentName
						if transparentObj != undefined then append obj.transparent (nodeTransformMonitor node:transparentObj forwardTransformChangeMsgs:false)
					)
					
					animatedNames = filterString (_csv.GetColumn (_csv.GetColumnIndex animatedCol) columnFilter:(_csv.GetColumnIndex namesCol) filter:str unique:false)[1] ", "
					for animatedName in animatedNames do 
					(
						animatedObj = getNodeByName animatedName
						if animatedObj != undefined then append obj.animated (nodeTransformMonitor node:animatedObj forwardTransformChangeMsgs:false)
					)
				)

			)
		)
		
	),
	
	
	
	/* Import and create a camera for each hotspot position ############################################################################################*/
	fn CreateHotspotList =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		-- Set the hotspot hashtable and layer
		if _cl.hotspotHT.count == 0 then _cl.SetHotspotHT()
		LayerManager.newLayerFromName _cl.hotspotLayer
		
		for item in hotspotHT do 
		(
			cam = Physical_Camera name: item[1] pos:item[2]
 			cam.wireColor = color 28 149 177
 			(LayerManager.getLayerFromName _cl.hotspotLayer).addNode cam
 			-- pt = Point name: item[1] pos:item[2] Box:on cross:off size:5
 			-- pt.wireColor = color 28 149 177
			-- (LayerManager.getLayerFromName _cl.hotspotLayer).addNode pt
		)
	
	),
	
	
	
	/* Export the hotspots list (name and position) ############################################################################################*/
	fn ExportHotspotList =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		folder = getSavePath caption:"Choose a folder to save the Hotspots.csv" initialDir:maxFilePath
		if folder != udnefined then 
		(
			file = (folder + "\\" + (getFilenameFile maxFileName) + ".csv")
			excel = CreateOLEObject "Excel.Application"
			excel.application.Workbooks.Add
			excel.ActiveSheet.Name = "Hotspots"
			
			(excel.application.Range("A1")).value = "Hotspot name"
			(excel.application.Range("B1")).value = "Hotspot position"
			(excel.application.Range("C1")).value = "Hotspot default rotation"
			(excel.application.Range("D1")).value = "Hotspot rotation"
			

			i = 2
			cams = _sgz._extMxs.SortObjects(for cam in cameras where not isKindOf cam Targetobject and cam.layer.name == _cl.hotspotLayer collect cam)
			for cam in cams do 
			(
				(excel.application.Range("A" + i as string)).value = cam.name
				(excel.application.Range("B" + i as string)).value = GetHotspotPos cam
				(excel.application.Range("D" + i as string)).value = GetHotspotQuat cam
				i += 1
			)
			
			excel.DisplayAlerts = false
			excel.ActiveSheet.SaveAs file 24
			excel.application.ActiveWorkbook.Close false
			excel.quit()
			releaseAllOLEObjects()
			excel = undefined

		)
	),
	
	
	
	/* Check if scene components has undefined relatives ############################################################################################*/
	fn ComponentChecker = 
	(
		/*<Function>
		Description:
			Check if scene components has no undefined relatives
		</Function>*/
		
		clearListener()
		brokenComponents = #()
		somethingIsWrong = false
		for component in sceneComponents do 
		(
			str = ""
			hiddenCount = (for obj in component.hidden where obj.node == undefined collect obj).count
			transparentCount = (for obj in component.transparent where obj.node == undefined collect obj).count
			animatedCount = (for obj in component.transparent where obj.node == undefined collect obj).count

			if component.hotspot == undefined do str += "\thotspot: undefined\n"
			if hiddenCount != 0 then str += "\thidden: " + hiddenCount as string + " undefined\n" 
			if transparentCount != 0 then str += "\ttransparent: " + transparentCount as string + " undefined\n" 
			if animatedCount != 0 then str += "\tanimated: " + animatedCount as string + " undefined\n" 
			
			if str != "" then 
			(
				format "% :\n%\n" component.name str
				somethingIsWrong = true
				append brokenComponents component
			)
		)
		
		if not somethingIsWrong then format "Everything's fine dude :D\n"
	),
	
	
	
	/* Check if scene components has undefined relatives ############################################################################################*/
	fn ComponentFixer = 
	(
		/*<Function>
		Description:
			Fix scene components with undefined relatives
		</Function>*/
		
		ComponentChecker()
		for component in brokenComponents do 
		(
			format "Fixing: %\n" component

			oldNodes = for h in component.hidden where h.node == undefined collect h
			for oldNode in oldNodes do deleteItem (component.hidden) (findItem (component.hidden) oldNode)

			oldNodes = for h in component.transparent where h.node == undefined collect h
			for oldNode in oldNodes do deleteItem (component.transparent) (findItem (component.transparent) oldNode)

			oldNodes = for h in component.animated where h.node == undefined collect h
			for oldNode in oldNodes do deleteItem (component.animated) (findItem (component.animated) oldNode)
		)
	),



	fn OpenExcludedObjects = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		global ExcludedObjectsRol
		
		try(destroyDialog ExcludedObjectsRol) catch()
		Rollout ExcludedObjectsRol "Excluded Objects"
		(
			listbox excludedLbx width:240 height:32 align:#center offset:[0,0]
			button addBtn "Add" width:76 align:#left offset:[-9,-3] 
			button removeBtn "Remove" width:76 align:#center offset:[0,-26] 
			button clearBtn "Clear" width:77 align:#right offset:[8,-26] 


			fn SetList = 
			(
			   /*<Function>
				Description:
				Arguments:
				Return:
				Infos:
				</Function>*/
				
				items = #()
				for obj in _cl.excludedObjects do append items obj.name
				excludedLbx.items = items
				
			)


			on ExcludedObjectsRol open do SetList()


			on addBtn pressed do
			(
				if not _sgz._sel.IsSelectionEmpty() then 
				(
					for obj in selection do appendIfUnique _cl.excludedObjects obj
					SetList()
				)
			)


			on removeBtn pressed do
			(
				index = excludedLbx.selection
				if relativeIndex != 0 then deleteItem _cl.excludedObjects index
				SetList()
			)


			on clearBtn pressed do
			(
				_cl.excludedObjects = #()
				SetList()
			)

		)
		createDialog ExcludedObjectsRol 250 455 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout CLView "CompLoc Components"
	(
		local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
		local red = dnColor.FromArgb 255 150 40 40
		local green = dnColor.FromArgb 255 30 100 30
		local orange = dnColor.FromArgb 255 158 92 12
		local tempRelatives = TempRelativesStc()
		
		label requiredComponentsLbl "Required Components :" width:200 pos:[9,7]
		dropdownlist requiredComponentsFilterDdl items:#("All") width:60 align:#left offset:[174,-20]
		dotNetControl requiredComponentsLbx "listView" width:240 height:363 align:#left offset:[-7,0]
		label requiredHotspotLbl "Hotspot: " align:#left offset:[-7,2]
		label requiredHotspotNameLbl width:110 height:16 style_sunkenedge:true align:#left offset:[40,-19]
		label requiredFovLbl "FOV: " align:#left offset:[180,-20] 
		label requiredFovValueLbl  width:25 height:16 style_sunkenedge:true align:#left offset:[208,-19] 
		
		groupbox separatorGrp width:230 height:7 align:#left offset:[-2,-3]
		
		edittext csvFileTxt width:185 align:#left offset:[-11,3] text:"Set the spreadsheet path"
		button getCsvFileBtn "..." width:25 height:17 align:#left offset:[180,-22] tooltip:"Set the spreadsheet path" 
		button loadCsvFileBtn "L" width:25 height:17 align:#left offset:[208,-22] tooltip:"Load the spreadsheet" enabled:false
		
		dropdownlist sceneComponentsDdl items:#("Scene Components :", "Broken Components :") width:150 pos:[256,5]
		dropdownlist sceneComponentsFilterDdl items:#("All") width:60 align:#center offset:[91,-27]
		listbox sceneComponentsLbx  width:240 height:30 align:#center offset:[0,-1]
		button addComponentBtn "Add" width:56  align:#center offset:[-92,-3] 
		button removeComponentBtn "Remove" width:56  align:#center offset:[-31,-26] 
		button reloadComponentsBtn "Reload" width:56  align:#center offset:[31,-26] 
		button selectComponentBtn "Select" width:56  align:#center offset:[92,-26] 

		button excludeObjectsbtn "Excluded Objects" width:115 pos:[505,7]
		button copyBtn "Copy" width:60 align:#right offset:[-55,-26]
		button pasteBtn "Paste" width:60 align:#right offset:[7,-26] 
		
		label hotspotLbl "Hotspot :" align:#right offset:[-185,7] --pos:[506,7]
		button getHotspotCsvFileBtn "..." width:25 height:17 align:#right offset:[7,-19] tooltip:"Set the hotspot file" 
		dropdownlist hotspotDdl width:170 align:#right offset:[-63,0]
		spinner fovSpn width:60 range:[10,110,40] type:#integer align:#right offset:[7,-25] 

		--button excludeObjectsbtn "Excluded Objects" width:240 align:#right offset:[7,7]
		
		label hiddenLbl "Hidden Objects :" align:#right offset:[-151,7] 
		checkbox hiddenChk checked:true width:15 align:#right offset:[7,-19] 
		listbox hiddenLbx width:240 height:8 align:#right offset:[7,-1]
		button addHiddenBtn "Add" width:76 align:#right offset:[-156,-3] 
		button removeHiddenBtn "Remove" width:76 align:#right offset:[-75,-26] 
		button clearHiddenBtn "Clear" width:77 align:#right offset:[7,-26] 
		
		label transparentLbl "Transparent Objects :" align:#right offset:[-125,12]
		checkbox transparentChk checked:true width:15 align:#right offset:[7,-19] 
		listbox transparentLbx width:240 height:3 align:#right offset:[7,-1]
		button addTransparentBtn "Add" width:76 align:#right offset:[-156,-3] 
		button removeTransparentBtn "Remove" width:76 align:#right offset:[-75,-26] 
		button clearTransparentBtn "Clear" width:77 align:#right offset:[7,-26] 
		
		label animatedLbl "Animated Objects :" align:#right offset:[-139,12]
		listbox animatedLbx width:240 height:3 align:#right offset:[7,0]
		button addAnimatedBtn "Add" width:76 align:#right offset:[-156,-3] 
		button removeAnimatedBtn "Remove" width:76 align:#right offset:[-75,-26] 
		button clearAnimatedBtn "Clear" width:77 align:#right offset:[7,-26] 
		

		/* Functions #####################################################################################################################################################################################*/
			
		/* Initialize the look and feeel fo the listviews *************************************************************************************************************************************************/
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
		
		
		
		/* Set the required components listbox ********************************************************************************************************************************************************/
		fn FillRequiredComponentsList filter = 
		(
			-- Get the required components for a given ata
			_csv.file = csvFileTxt.text
			
			case filter of 
			(
				true: _cl.requiredComponents = _sgz._extMxs.SortStrings (_csv.GetColumn (_csv.GetColumnIndex _cl.namesCol) columnFilter:(_csv.GetColumnIndex _cl.ataCol) filter:requiredComponentsFilterDdl.selected unique:false)
				false: _cl.requiredComponents = _sgz._extMxs.SortStrings (_csv.GetColumn (_csv.GetColumnIndex _cl.namesCol) unique:false)
			)
			
			if _cl.requiredComponents.count != 0 then 
			(
				-- Clear the listview and add each component
				requiredComponentsLbx.items.Clear()
				for component in _cl.requiredComponents do
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" component		
					
					-- Set the item backcolor depending if it can be found in the scene and if it's already a component
					obj = getNodeByName component
					if obj != undefined then 
					(
						if (_ca.CheckForCustAttr obj #compLoc)[1] 
							then listViewItem.BackColor = green
							else listViewItem.BackColor = orange
					)
					else listViewItem.BackColor = red
					
					requiredComponentsLbx.items.add listViewItem
				)
			)
		)
		
		
		
		/* Load the spreadsheet  ***************************************************************************************************************************************************************/
		fn LoadCSV =
		(
			/*<Function>
			Arguments:
			Return:
			Further Infos:
			</Function>*/
			
			
			if _csv.GetFile "Open the synthesis file" != undefined then
			(
				-- Convert the file to CSV if it's a XLSX and fill the edittext with the csv path
				if getFilenameType _csv.file != ".csv" then _csv.ConvertXLSXToCSV "Complete-Unity"
				csvFileTxt.text = _csv.file
				loadCsvFileBtn.enabled = true
				
				-- define the filter
				requiredComponentsFilterDdl.items = #("All") + _sgz._extMxs.SortIntegers(_csv.GetColumn (_csv.GetColumnIndex _cl.ataCol))
				
				-- Load the required components
				FillRequiredComponentsList false
			)
			else csvFileTxt.text = "Set the spreadsheet path"
			
		)
		
		
		
		/* Get all scene components and set the scene component listbox **************************************************************************************************************************************/
		fn FillSceneComponentsList filter:false broken:false = 
		(
			_cl.sceneComponents = _sgz._extMxs.SortObjects (_ca.GetObjsWithCA #compLoc)
			
			try
			(
				atas = #()
				items = #()
				components = if broken then _cl.brokenComponents else _cl.sceneComponents
				for obj in components do
				(
					-- Get the ATA number by firltering the object name
					str = ""
					ss = filterString obj.name "_"
					if ss[1] == "ATA" then
					(
						nb = filterString ss[2] "-"
						if (nb[1] as integer) != undefined then str = nb[1]
					)
					
					-- Set the ATAs filter list
					appendIfUnique atas str
					
					if filter then 
					(
						if sceneComponentsFilterDdl.selected == str then append items obj.name
					)
					else append items obj.name
				)
				
				sceneComponentsFilterDdl.items = join #("All") atas
				sceneComponentsLbx.items = items
				sceneComponentsLbx.selection = sceneComponentsLbx.items.count
				
			) catch()
		)
		
		
		
		/* Set relatives infos for a component ***************************************************************************************************************************************************************/
		fn SetRelatives =
		(
			/*<Function>
			Description
			Arguments:
			Return:
			Further Infos:
			</Function>*/


			-- Collect excluded objects 
			excluded = join #() _cl.excludedObjects
			join excluded (for obj in objects where matchPattern obj.layer.name pattern:"zzz_*" collect obj)
			
			
			if _cl.sceneComponents.count != 0 and sceneComponentsLbx.selection != 0 then 
			(
				component = getNodeByName sceneComponentsLbx.selected
				index = -1
				for i = 1 to _cl.hotspotHT.count while index == -1 do
					if _sgz._extMxs.ArePtsEquivalent _cl.hotspotHT[i][2] (component.hotspot.pos) then index = i
			
				hotspotDdl.selection = index
				fovSpn.value = component.fov
				
				-- Set hidden
				hiddens = for obj in component.hidden where obj.node != undefined collect obj
				hiddenLbx.items = for obj in hiddens collect obj.node.name
				(for obj in objects where findItem excluded obj == 0 collect obj).isHidden = false
				for obj in hiddens do obj.node.isHidden = (hiddenChk.state)
						
				-- Set transparent 
				transparents = for obj in component.transparent where obj.node != undefined collect obj
				transparentLbx.items = for obj in transparents collect obj.node.name
				(for obj in objects where findItem excluded obj == 0 collect obj).xray = false
				for obj in transparents do obj.node.xray = (transparentChk.state)
				
				-- Set animated
				animatedLbx.items = for obj in component.animated where obj.node != undefined collect obj.node.name

				-- Check if the component is fine
				if component.hotspot == undefined OR 
					(for obj in component.hidden where obj.node == undefined collect obj).count != 0 OR
					(for obj in component.transparent where obj.node == undefined collect obj).count != 0 OR
					(for obj in component.transparent where obj.node == undefined collect obj).count != 0
					then _sgz._extMxs.Prompt "This component include undefined relative node..."
			)
			
			else
			(
				hiddenLbx.items = transparentLbx.items = animatedLbx.items = #()

				arr = for obj in objects where findItem excluded obj == 0 collect obj
				arr.isHidden = arr.xray = false
				
			)
		)
		
		

		/* Select a component from one of the list ***************************************************************************************************************************************************************/
		fn SelectComponent objName =
		(
			/*<Function>
			Description:
				Select a component from one of the list
			Arguments:
			Return:
			Further Infos:
			</Function>*/

			select (component = getNodeByName objName)
			if component != undefined then 
				if isKindOf component helper then select (_sgz._sel.GetHierarchy children:true)
		)


		-- Add an object to the scene component -----------------------------------------------------------------------------------------------------------------------------------------------------------------
		fn AddComponent =
		(
		   /*<Function>
			Description:
			Arguments:
			Return:
			Infos:
			</Function>*/
			
			for obj in selection do 
			(
				wrongName = "\"" + obj.name + "\" name doesn't start with \"ATA_XX\"... "
				ss = filterString obj.name "_"
				if ss[1] == "ATA" then
				(
					nb = filterString ss[2] "-"
					if (nb[1] as integer) == undefined 
						then MessageBox wrongName

					-- Check if the object doesn't already have the complocCA
					else if not (_ca.CheckForCustAttr obj #comploc)[1] then 
					(
						-- make the object unique to avoid instance
						InstanceMgr.MakeObjectsUnique obj #individual
						
						custAttributes.add obj _cl.compLocCA BaseObject:true
						cam = Physical_Camera name:(obj.name + "_" + _cl.hotspotHT[1][1]) pos:_cl.hotspotHT[1][2] specify_fov:on
						cam.fov = 40
						cam.targeted = true
						cam.target.pos = obj.center
						
						LayerManager.newLayerFromName _cl.hotspotLayer
						(LayerManager.getLayerFromName _cl.hotspotLayer).addNode cam
						(LayerManager.getLayerFromName _cl.hotspotLayer).addNode (cam.target)
						
						obj.hotspot = cam
						
						setTransformLockFlags cam #{1..9}
						setTransformLockFlags (cam.target) #{1..9}

					)
				)

				else MessageBox wrongName
			)
			
			FillSceneComponentsList filter:(sceneComponentsFilterDdl.selection != 1)
			SetRelatives()
			
			if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList (requiredComponentsFilterDdl.selection != 1)
			
		)



		-- Set the hotspot ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------





		-- Add Relative object to a scene component -----------------------------------------------------------------------------------------------------------------------------------------------------------
		fn AddRelative component relatives relativeType = 
		(
		   /*<Function>
			Description:
			Arguments:
			Return:
			Infos:
			</Function>*/

			arr = case relativeType of 
			(
				#hidden: component.hidden
				#transparent: component.transparent
				#animated: component.animated
			)
			
			for obj in relatives where obj != component do 
			(
				canAdd = true
				for relative in arr while canAdd do if relative.node == obj then canAdd = false

				if canAdd then 
				(
					append arr (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)

					if relativeType == #hidden then obj.isHidden = hiddenChk.checked
					if relativeType == #transparent then obj.xray = transparentChk.checked
				)
			)
			
			SetRelatives()
			
		)



		
		/* Events ###########################################################################################################################################################################################*/
		on CLView open do 
		(
			InitListViews()
			if _cl.hotspotHT.count == 0 then _cl.SetHotspotHT()
			hotspotDdl.items = for item in _cl.hotspotHT collect item[1]
			FillSceneComponentsList()
			SetRelatives()
		)
		
		
		/* Filter the required component by ATA number ***************************************************************************************************************************************************************/
		on requiredComponentsFilterDdl selected item do FillRequiredComponentsList (item != 1)
		
		
		
		/* Set the csv path and load the file ***************************************************************************************************************************************************************/
		on getCsvFileBtn pressed do LoadCSV()
		
		
		
		/* Reload the required component list ***************************************************************************************************************************************************************/
		on loadCsvFileBtn pressed do FillRequiredComponentsList (requiredComponentsFilterDdl.selection != 1)
		
		
		
		/* Get the assigned hotspot and FOV from required component ***********************************************************************************************************************************************/
		on requiredComponentsLbx MouseDown s e do
		(
			if (requiredComponentsLbx.Items.Count != 0) then
			(
				hit = requiredComponentsLbx.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
				try
				(
					requiredHotspotNameLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.hotspotCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
					requiredFovValueLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.fovCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
				) catch()
			)
		)
		
		
		
		/* Select the required component from the listbox *********************************************************************************************************************************************************/
		on requiredComponentsLbx MouseDoubleClick s e do
		(
			if (requiredComponentsLbx.Items.Count != 0) then
			(
				hit = requiredComponentsLbx.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
				try (SelectComponent (hit.item.text)) catch()
			)
		)



		/* Filter the scene component by ATA number ***************************************************************************************************************************************************************/
		on sceneComponentsDdl selected item do 
		(
			if item == 2
				then FillSceneComponentsList filter:(sceneComponentsFilterDdl.selection != 1) broken:true
				else FillSceneComponentsList filter:(sceneComponentsFilterDdl.selection != 1)

			SetRelatives()
		)
		
		
		
		/* Filter the scene component by ATA number ***************************************************************************************************************************************************************/
		on sceneComponentsFilterDdl selected item do 
		(
			if sceneComponentsDdl.selection == 2 
				then FillSceneComponentsList filter:(item != 1) broken:true
				else FillSceneComponentsList filter:(item != 1)
			
			SetRelatives()
		)
			
		
			
		/* Add scene component ********************************************************************************************************************************************************************************/
		on addComponentBtn pressed do AddComponent()
		
		
		
		/* Remove scene component ******************************************************************************************************************************************************************************/
		on removeComponentBtn pressed do
		(
			-- Check that there is a component to remove
			if _cl.sceneComponents.count != 0 then 
			(
				-- Get the selected component
				component = getNodeByName sceneComponentsLbx.selected
				index = sceneComponentsLbx.selection
				if component != undefined then
				(
					delete component.hotspot
					_ca.RemoveCA #compLoc nodeList:(_sgz._extMxs.AsArray component)
					FillSceneComponentsList filter:(sceneComponentsFilterDdl.selection != 1)
					
					-- select previous item if its the last from the list whose been removed
					if index > _cl.sceneComponents.count then 
						sceneComponentsLbx.selection = _cl.sceneComponents.count
					
					SetRelatives()
					
					if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList (requiredComponentsFilterDdl.selection != 1)
				)
				
			)
		)
		
		
		
		/* Reload the list ***********************************************************************************************************************************************************************************/
		on reloadComponentsBtn pressed do
		(
			FillSceneComponentsList filter:(sceneComponentsFilterDdl.selection != 1)
			SetRelatives()
			
			if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList (requiredComponentsFilterDdl.selection != 1)
		)
		
		
		
		/* Select the object shown in the list ***************************************************************************************************************************************************************/
		on selectComponentBtn pressed do select (for item in sceneComponentsLbx.items collect (getNodeByName item))
		
		
		
		/* Set relative ***************************************************************************************************************************************************************/
		on sceneComponentsLbx selected item do SetRelatives()
		
		
		
		/* Select the component when double clicked ***************************************************************************************************************************************************************/
		on sceneComponentsLbx doubleClicked item do SelectComponent (sceneComponentsLbx.selected)



		on hiddenLbx doubleClicked item do select (getNodeByName hiddenLbx.selected)
		on transparentLbx doubleClicked item do select (getNodeByName transparentLbx.selected)
		on animatedLbx doubleClicked item do select (getNodeByName animatedLbx.selected)
		
		

		/* Switch to the camera view for the component ***************************************************************************************************************************************************************/
		on sceneComponentsLbx rightClick item do viewport.setCamera (getNodeByName sceneComponentsLbx.selected).hotspot
		
		
		
		/* Set the hotspot file ***************************************************************************************************************************************************************/
		on getHotspotCsvFileBtn pressed do 
		(
			_cl.SetHotspotHT()
			hotspotDdl.items = for item in _cl.hotspotHT collect item[1]
		)
		
		
		
		/* Set the hotspot for selected component ***************************************************************************************************************************************************************/
		on hotspotDdl selected item do 
		(
			if _cl.sceneComponents.count != 0 then 
			(
				component = getNodeByName sceneComponentsLbx.selected
				component.hotspot.pos = _sgz._extMxs.GetHashTableValue (_cl.hotspotHT) (hotspotDdl.selected)
				component.hotspot.name = component.name + "_" + hotspotDdl.selected
				
				viewport.setCamera component.hotspot
			)
		)
		
		
		
		/* Set the hotspot FOV for selected component ***************************************************************************************************************************************************************/
		on fovSpn changed val do 
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				component.fov = component.hotspot.fov = val
			)
		)



		/* Open the Excluded objects list  ***************************************************************************************************************************************************************/
		on excludeObjectsbtn pressed do _cl.OpenExcludedObjects()



		/* Copy relatives from selected object  ***************************************************************************************************************************************************************/
		on copyBtn pressed do 
		(
			if _sgz._sel.IsSelectionOne() AND (_ca.CheckForCustAttr $ #comploc)[1] then 
			(
				--tempRelatives.hotspot = $.hotspot
				tempRelatives.fov = $.fov
				tempRelatives.hidden = for obj in $.hidden where obj.node != undefined collect obj.node
				tempRelatives.transparent = for obj in $.transparent where obj.node != undefined collect obj.node
				tempRelatives.animated = for obj in $.animated where obj.node != undefined collect obj.node
			)
		)



		/* Paste relatives to selected object  ***************************************************************************************************************************************************************/
		on pasteBtn pressed do 
		(
			if _sgz._sel.IsSelectionOne() AND (_ca.CheckForCustAttr $ #comploc)[1] then 
			(
				--$.hotspot = tempRelatives.hotspot
				$.fov = tempRelatives.fov
				for obj in tempRelatives.hidden do append $.hidden (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
				for obj in tempRelatives.transparent do append $.transparent (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
				for obj in tempRelatives.animated do append $.animated (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
			)
		)
		
		
		/* Set the visibility of hidden objects ***************************************************************************************************************************************************************/
		on hiddenChk changed state do 
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				(for obj in component.hidden collect obj.node).isHidden = state
				
			)
		)
		
		
		
		/* Add hidden object  ***************************************************************************************************************************************************************/
		on addHiddenBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				for obj in selection where obj != component do 
				(
					canAdd = true
					for relative in component.hidden while canAdd do if relative.node == obj then canAdd = false
					if canAdd then 
					(
						append component.hidden (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						obj.isHidden = hiddenChk.checked
					)
				)
				
				SetRelatives()
			)
		)
		
		
		
		/* Remove hidden object  ***************************************************************************************************************************************************************/
		on removeHiddenBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = hiddenLbx.selection
				if relativeIndex != 0 then deleteItem component.hidden relativeIndex
				SetRelatives()
				
				-- Set the listbox selected item
				if hiddenLbx.selection == 0 and hiddenLbx.items.count >= 1 then hiddenLbx.selection = hiddenLbx.items.count
			)
		)



		/* Clear hidden object  ***************************************************************************************************************************************************************/
		on clearHiddenBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				component.hidden = #()
				SetRelatives()
			)
		)
		

		
		/* Set the xray of transparent objects ***************************************************************************************************************************************************************/
		on transparentChk changed state do 
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				(for obj in component.transparent collect obj.node).xray = state
				
			)
		)
		
		
		/* Add transparent object ***************************************************************************************************************************************************************/
		on addTransparentBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				for obj in selection where obj != component do 
				(
					canAdd = true
					for relative in component.transparent while canAdd do if relative.node == obj then canAdd = false
					
					if canAdd then 
					(
						append component.transparent (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						obj.xray = transparentChk.checked
					)
				)
				
				SetRelatives()
			)
		)
		
		
		
		/* Remove transparent object ***************************************************************************************************************************************************************/
		on removeTransparentBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = transparentLbx.selection
				if relativeIndex != 0 then deleteItem component.transparent relativeIndex
				SetRelatives()
				
				-- Set the listbox selected item
				if transparentLbx.selection == 0 and transparentLbx.items.count >= 1 then transparentLbx.selection = transparentLbx.items.count
			)
		)



		/* Clear transparent objects  ***************************************************************************************************************************************************************/
		on clearTransparentBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				component.transparent = #()
				SetRelatives()
			)
		)
		
		
		
		/* Add Animated objects ***************************************************************************************************************************************************************/
		on addAnimatedBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				for obj in selection where obj != component do 
				(
					canAdd = true
					for relative in component.animated while canAdd do if relative.node == obj then canAdd = false
						
					if canAdd then append component.animated (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
				)
				
				SetRelatives()
			)
		)
		
		
		
		/* Remove Animated objects ***************************************************************************************************************************************************************/
		on removeAnimatedBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = animatedLbx.selection
				if relativeIndex != 0 then deleteItem component.animated relativeIndex
				SetRelatives()
				
				-- Set the listbox selected item
				if animatedLbx.selection == 0 and animatedLbx.items.count >= 1 then animatedLbx.selection = animatedLbx.items.count
			)
		)



		/* Clear animated objects  ***************************************************************************************************************************************************************/
		on clearAnimatedBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				component.animated = #()
				SetRelatives()
			)
		)
		
	), -- End GetView()
	
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		try(destroyDialog _cl.CLView) catch()
		GetView()
		createDialog _cl.CLView 750 455 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
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
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
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
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.ComponentChecker()
				)
			)
		)
	),



	/* Check if scene components has no undefined relatives ############################################################################################*/
	macroFix =
	(
		macroScript CompLocFixer
			category:"SugzTools"
			toolTip:"CompLoc Fixer"
			Icon:#("Comploc",9)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.ComponentFixer()
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
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
-- 					_cl.ExcelExportBackgroundWorker()
					_cl.ExcelExport()
				)
			)
		)
	),
	
	
	
	/* Import components informations from excel ############################################################################################*/
	macroImport =
	(
		macroScript CompLocExcelImporter
			category:"SugzTools"
			toolTip:"CompLoc Excel Importer"
			Icon:#("Comploc",4)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.ExcelImport()
				)
			)
		)
	),
	
	
	
	/* Import and create a camera for each hotspot position ############################################################################################*/
	macroCreateHotspotList =
	(
		macroScript CompLocCreateHotspotList
			category:"SugzTools"
			toolTip:"CompLoc Create Hotspot List"
			Icon:#("Comploc",7)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.CreateHotspotList()
				)
			)
		)
	),
	
	
	
	/* Import and create a camera for each hotspot position ############################################################################################*/
	macroExportHotspotList=
	(
		macroScript CompLocExportHotspotList
			category:"SugzTools"
			toolTip:"CompLoc Export Hotspot List"
			Icon:#("Comploc",8)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.ExportHotspotList()
				)
			)
		)
	),
	
	
	/* Clean the scene from the complocCA ############################################################################################*/
	macroClean = 
	(
		macroScript CompLocCleanScene
			category:"SugzTools"
			toolTip:"CompLoc Clean Scene"
			Icon:#("Comploc",5)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.CleanScene()
				)
			)
		)
	),
	
	
	
	/* Clean the scene from the complocCA ############################################################################################*/
	macroScreenshot = 
	(
		macroScript CompLocScreenshot
			category:"SugzTools"
			toolTip:"CompLoc ScreenShot"
			Icon:#("Comploc",6)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist (file = "$userscripts\SugzTools\Scripts\CompLoc_Component.ms") then 
				(
					fileIn file
					_cl.MakeScreenshot()
				)
			)
		)
	)
	
)


(
	_sgz._extMxs.SetHeapSize 100000000
	hotspotHT = #()
	excludedObjects = #()

	if _cl != undefined then
	(
		hotspotHT = _cl.hotspotHT
		excludedObjects = _cl.excludedObjects
		brokenComponents = _cl.brokenComponents
	)
	
	_cl = CompLocComponentStc()
	_cl.hotspotHT = hotspotHT
	_cl.excludedObjects = excludedObjects
	_cl.brokenComponents = brokenComponents
	_cl.Run()
)