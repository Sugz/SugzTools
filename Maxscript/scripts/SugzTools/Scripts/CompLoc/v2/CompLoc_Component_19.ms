/*##############################################################################
CompLoc Component
Version 2.19
Script By Cl�ment "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library
SugzTools Custom Attributes Library
SugzTools Spreadsheet Parser Library

# Sources:

# To do list:
- component checker 
- modifier la gestion pour le SetHotspotHT pour que ca marche via le boutton alors que sa valeur est d�j� fix�.
- possibilit� de selectionner tous les objets d'une liste
- eviter de pouvoir ajouter le component dans les relatives objects et eviter de pouvoir mettre un objet en double dans n'importe quel liste


# History:
2.0:
	- Rewrite everything from the ground up and make a huge simplification

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
	ataCol = "ATA",
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
	hotspotHT = #(),								-- The hotspot hashtable (name, position) 
	
	
	/* Set the hotspot hashtable ############################################################################################*/
	fn SetHotspotHT =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		if hotspotHT.count == 0 then 
		(
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
		)
		
		
		
		/*
		hotspotHT = #(
			#("HCabinDoorILH", [35,-6,18]),
			#("HCabinDoorIRH", [35,6,18]),
			#("HCabinDoorLOLH", [35,-18,2]),
			#("HCabinDoorLORH", [35,18,2]),
			#("HCabinDoorOLH", [35,-18,18]),
			#("HCabinDoorORH", [35,18,18]),
			#("HCockpitDoorILH", [26,-6.5,18]),
			#("HCockpitDoorIRH", [26,6.5,18]),
			#("HCockpitDoorLOLH", [30,-20,2]),
			#("HCockpitDoorLORH", [30,20,2]),
			#("HCockpitDoorOLH", [30,-20,18]),
			#("HCockpitDoorORH", [30,20,18]),
			#("HFenestronLH", [100,-25,18]),
			#("HFenestronRH", [100,25,18]),
			#("HFreeE", [47,110,18]),
			#("HFreeN", [-60,0,18]),
			#("HFreeNE", [-26,80,18]),
			#("HFreeNW", [-26,-80,18]),
			#("HFreeS", [160,3,18]),
			#("HFreeSE", [125,80,18]),
			#("HFreeSW", [125,-80,18]),
			#("HFreeW", [47,-110,18]),
			#("HInBackwardCabin", [46,0,18]),
			#("HInCopilot", [27,-4,18]),
			#("HInForwardCabin", [33,0,18]),
			#("HInPilot", [27,4,18]),
			#("HLadderFrontLH", [40,-11,30]),
			#("HLadderFrontLLH", [40,-11,18]),
			#("HLadderFrontLRH", [40,11,18]),
			#("HLadderFrontRH", [40,11,30]),
			#("HLadderMiddleLH", [47.5,-11,23]),
			#("HLadderMiddleLLH", [47.5,-11,18]),
			#("HLadderMiddleLRH", [47.5,11,18]),
			#("HLadderMiddleRH", [47.5,11,23]),
			#("HLadderRearLH", [55,-11,20]),
			#("HLadderRearLLH", [55,-11,18]),
			#("HLadderRearLRH", [55,11,18]),
			#("HLadderRearRH", [55,11,20]),
			#("HNose", [0,0,18]),
			#("HNoseLying", [0,0,2]),
			#("HPilonLH", [80,-15,18]),
			#("HPilonRH", [80,15,18]),
			#("HRearDoorBack", [72,0,10]),
			#("HRearDoorLH", [67,-18,18]),
			#("HRearDoorLLH", [67,-18,2]),
			#("HRearDoorLRH ", [67,18,2]),
			#("HRearDoorRH", [67,18,18]))
		*/
		
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
				hidden type:#maxObjectTab tabSizeVariable:true
				hiddenName type:#stringTab tabSizeVariable:true
				transparent type:#maxObjectTab tabSizeVariable:true
				transparentName type:#stringTab tabSizeVariable:true
				animated type:#maxObjectTab tabSizeVariable:true
				animatedName type:#stringTab tabSizeVariable:true
					
				on hotspot set val do if val != undefined then this.view.hotspotLbl.text = substring (val.name) ((GetNode()).name.count + 2) -1
				on fov set val do this.view.fovLbl.text = this.fov as string
				on hidden tabChanged arg1 arg2 arg3 do this.view.hiddenLbx.items = for obj in hidden collect obj.node.name
				on transparent tabChanged arg1 arg2 arg3 do this.view.transparentLbx.items = for obj in transparent collect obj.node.name
				on animated tabChanged arg1 arg2 arg3 do this.view.animatedLbx.items = for obj in animated collect obj.node.name
			)
			 
			rollout view "CompLoc Component"
			(
				groupbox hotspotGrp "Hotspot" height:40 width:150 align:#center
				label hotspotLbl width:140 align:#left across:2 offset:[0,-25]
				label fovLbl align:#right offset:[0,-25]
				listbox hiddenLbx "Hidden Objects" height:10 width:150 align:#center offset:[0,10]
				listbox transparentLbx "Transparent Objects" height:3 width:150 align:#center offset:[0,5]
				listbox animatedLbx "Animated Objects" height:3 width:150 align:#center offset:[0,5]
				
				
				fn GetRelated type = 
				(
					objs = #()
					objsNames = #()
					arr = #()
					arrName = #()
					case type of 
					(
						#hidden: (arr = this.hidden; arrName = this.hiddenName)
						#transparent: (arr = this.transparent; arrName = this.transparentName)
						#animated: (arr = this.animated; arrName = this.animatedName)
					)
					
					for i = 1 to arr.count do 
					(
						if arr[i].node != undefined then 
						(
							append objs arr[i]
							append objsNames arr[i].node.name
						)
						else
						(
							obj = getNodeByName arrName[i]
							if obj != undefined then append objs (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						)
					)

					case type of 
					(
						#hidden: (this.hidden = objs; this.hiddenName = objsNames)
						#transparent: (this.transparent = objs; this.transparentName = objsNames)
						#animated: (this.animated = objs; this.animatedName = objsNames)
					)
					
				)
				
				on view open do 
				(
					GetRelated #hidden; GetRelated #transparent; GetRelated #animated;
					
					if this.hotspot != undefined then hotspotLbl.text = substring (this.hotspot.name) ((GetNode()).name.count + 2) -1
					fovLbl.text = this.fov as string
					hiddenLbx.items = for obj in this.hidden collect obj.node.name
					transparentLbx.items = for obj in this.transparent collect obj.node.name
					animatedLbx.items = for obj in this.animated collect obj.node.name
				)
				
				
			) -- End rollout
			
		) -- End ComplocCA
		
	),
	
	
	
	/* Go through each scene component to actualise their relatives ############################################################################################*/
	fn UpdateComponent =
	(
		/*<Function>
		Description:
			Go through each scene component to actualise them
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		for obj in sceneComponents do select obj
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
		
		if (queryBox "Are you sure you want to remove the comploc custom attribute on every object of the scene ?" title:"Comploc Scene Cleaner" beep:false) then
		(
			_ca.RemoveCA #compLoc nodeList:sceneComponents
			delete (for cam in cameras where cam.layer.name == "Hotspots" collect cam)
		)
			
	),
	
	
	
	/* Loop from every component and take a snapshot from its hotspot ############################################################################################*/
	fn MakeSnapShot =
	(
		/*<Function>
		Description:
			Loop from every component and take a snapshot from its hotspot
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		path = _sgz._extMxs.GetWinFolders #MyPictures + "\\Hotspots\\"
		if not (doesFileExist path) then makeDir path
		
		for obj in sceneComponents do 
		(
			arr = for obj in objects where not obj.layer.name == "H135_covers" collect obj
			arr.isHidden = arr.xray = false
			sliderTime = 0f
			
			select obj
			viewport.setCamera obj.hotspot
			
			(for relative in obj.hidden collect relative.node).isHidden = true
			(for relative in obj.transparent collect relative.node).xray = true
			if obj.animated.count != 0 then sliderTime = 50f
			
			redrawViews()
			ssBitmap3 = viewport.getViewportDib()
			ssBitmap3.filename = path + obj.name + ".jpg"
			save ssBitmap3 quiet:true
		)
	
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
-- 			else format "relatives: %\n" relatives
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
		_cl.SetHotspotHT()
		
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
			for component in sceneComponents do 
			(
				format "%: %\n" (i-1) component.name
				
				(_csv.excel.application.Range("A" + i as string)).value = component.name
				(_csv.excel.application.Range("B" + i as string)).value = GetHotspot component.hotspot
				(_csv.excel.application.Range("C" + i as string)).value = component.fov as string
				(_csv.excel.application.Range("D" + i as string)).value = GetRelatives component.transparent
				(_csv.excel.application.Range("E" + i as string)).value = GetRelatives component.hidden
				(_csv.excel.application.Range("F" + i as string)).value = GetRelatives component.animated
				
				i += 1
			)
			
			-- Save and close excel
			_csv.excel.DisplayAlerts = false
			_csv.excel.application.ActiveWorkbook.SaveAs(_csv.file)
			_csv.DestroyExcelOLE()
			
			messageBox "The writing on the excel file has gone well ;)"
		)
		
	),
	
	
	
	/* View ############################################################################################*/
	fn GetView = Rollout CLView "CompLoc Components"
	(
		local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
		local red = dnColor.FromArgb 255 150 40 40
		local green = dnColor.FromArgb 255 30 100 30
		local orange = dnColor.FromArgb 255 158 92 12
		
		label requiredComponentsLbl "Required Components :" width:200 pos:[9,5]
		dropdownlist requiredComponentsFilterDdl items:#("All") width:60 align:#left offset:[174,-22]
		dotNetControl requiredComponentsLbx "listView" width:240 height:338 align:#left offset:[-7,-5]
		label requiredHotspotLbl "Hotspot: " align:#left offset:[-7,2]
		label requiredHotspotNameLbl width:110 height:16 style_sunkenedge:true align:#left offset:[40,-19]
		label requiredFovLbl "FOV: " align:#left offset:[180,-20] 
		label requiredFovValueLbl  width:25 height:16 style_sunkenedge:true align:#left offset:[208,-19] 
		
		groupbox separatorGrp width:230 height:7 align:#left offset:[-2,-3]
		
		edittext csvFileTxt width:185 align:#left offset:[-11,3] text:"Set the spreadsheet path"
		button getCsvFileBtn "..." width:25 height:17 align:#left offset:[180,-22] tooltip:"Set the spreadsheet path" 
		button loadCsvFileBtn "L" width:25 height:17 align:#left offset:[208,-22] tooltip:"Load the spreadsheet" enabled:false
		
		label sceneComponentsLbl "Scene Components :" pos:[256,5]
		dropdownlist sceneComponentsFilterDdl items:#("All") width:60 align:#center offset:[91,-22]
		listbox sceneComponentsLbx  width:240 height:28 align:#center offset:[0,-5]
		button addComponentBtn "Add" width:56  align:#center offset:[-92,-3] 
		button removeComponentBtn "Remove" width:56  align:#center offset:[-31,-26] 
		button reloadComponentsBtn "Reload" width:56  align:#center offset:[31,-26] 
		button selectComponentBtn "Select" width:56  align:#center offset:[92,-26] 
		
		label hotspotLbl "Hotspot :" pos:[506,5]
		button getHotspotCsvFileBtn "..." width:25 height:15 align:#right offset:[7,-18] tooltip:"Set the hotspot file" 
		dropdownlist hotspotDdl width:170 align:#right offset:[-63,-1]
		spinner fovSpn width:60 range:[10,80,40] type:#integer align:#right offset:[7,-25] 
		
		label hiddenLbl "Hidden Objects :" align:#right offset:[-151,10] 
		checkbox hiddenChk checked:true width:15 align:#right offset:[7,-19] 
		listbox hiddenLbx width:240 height:8 align:#right offset:[7,-1]
		button addHiddenBtn "Add Hidden" width:115 align:#right offset:[-118,-3] 
		button removeHiddenBtn "Remove Hidden" width:115 align:#right offset:[7,-26] 
		
		label transparentLbl "Transparent Objects :" align:#right offset:[-125,12]
		checkbox transparentChk checked:true width:15 align:#right offset:[7,-19] 
		listbox transparentLbx width:240 height:3 align:#right offset:[7,-1]
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
		
		
		
		/* Get all scene components and set the scene component listbox ***************************************************************************************************************************************************************/
		fn FillSceneComponentsList filter:false = 
		(
			_cl.sceneComponents = _sgz._extMxs.SortObjects (_ca.GetObjsWithCA #compLoc)
			
			atas = #()
			items = #()
			for obj in _cl.sceneComponents do
			(
				-- Skip the ATA_ part
				str = ""
				ss = StringStream obj.name
				skipToString ss "_"
				
				-- Read the number
				c = readChar ss
				while c != "-" do 
				(
					str += c 
					c = readChar ss
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
			
-- 			sceneComponentsLbx.items = for obj in _cl.sceneComponents collect obj.name
			sceneComponentsLbx.items = items
			sceneComponentsLbx.selection = sceneComponentsLbx.items.count
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
			
			
			
			if _cl.sceneComponents.count != 0 then 
			(
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				index = -1
				for i = 1 to _cl.hotspotHT.count while index == -1 do
					if _sgz._extMxs.ArePtsEquivalent _cl.hotspotHT[i][2] (component.hotspot.pos) then index = i
			
				hotspotDdl.selection = index
				fovSpn.value = component.fov
				
				-- Set hidden
				hiddenLbx.items = for obj in component.hidden collect obj.node.name
				(for obj in objects where not obj.layer.name == "H135_covers" collect obj).isHidden = false
				for obj in component.hidden do obj.node.isHidden = (hiddenChk.state)
						
				-- Set transparent 
				transparentLbx.items = for obj in component.transparent collect obj.node.name
				(for obj in objects where not obj.layer.name == "H135_covers" collect obj).xray = false
				for obj in component.transparent do obj.node.xray = (transparentChk.state)
				
				-- Set animated
				animatedLbx.items = for obj in component.animated collect obj.node.name
			)
			
			else
			(
				hiddenLbx.items = transparentLbx.items = animatedLbx.items = #()
				arr = for obj in objects where not obj.layer.name == "H135_covers" collect obj
				arr.isHidden = arr.xray = false
				
			)
		)
		
		
		
		/* Events ############################################################################################*/
		on CLView open do 
		(
			InitListViews()
			_cl.SetHotspotHT()
			hotspotDdl.items = for item in _cl.hotspotHT collect item[1]
			FillSceneComponentsList()
			SetRelatives()
		)
		
		
		/* Filter the required component by ATA number ############################################################################################*/
		on requiredComponentsFilterDdl selected item do 
		(
			FillRequiredComponentsList (item != 1)
		)
		
		
		
		/* Set the csv path and load the file ***************************************************************************************************************************************************************/
		on getCsvFileBtn pressed do LoadCSV()
		
		
		
		/* Reload the required component list ***************************************************************************************************************************************************************/
		on loadCsvFileBtn pressed do FillRequiredComponentsList()
		
		
		
		/* Get the assigned hotspot and FOV from required component ***************************************************************************************************************************************************************/
		on requiredComponentsLbx MouseDown s e do
		(
			hit = requiredComponentsLbx.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
			requiredHotspotNameLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.hotspotCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
			requiredFovValueLbl.text = " " + (_csv.GetColumn (_csv.GetColumnIndex _cl.fovCol) columnFilter:(_csv.GetColumnIndex _cl.namesCol) filter:(hit.item.text))[1]
		)
		
		
		
		/* Select the required component from the listbox ***************************************************************************************************************************************************************/
		on requiredComponentsLbx MouseDoubleClick s e do
		(
			hit = requiredComponentsLbx.HitTest (dotNetObject "System.Drawing.Point" e.x e.y)
			obj = getNodeByName (hit.item.text)
			if obj != undefined then select obj
		)
		
		
		
		/* Filter the scene component by ATA number ############################################################################################*/
		on sceneComponentsFilterDdl selected item do 
		(
			FillSceneComponentsList filter:(item != 1)
			SetRelatives()
		)
			
		
			
		/* Add scene component ***************************************************************************************************************************************************************/
		on addComponentBtn pressed do
		(
			for obj in selection do 
			(
				-- Check if the object doesn't already have the complocCA
				if not (_ca.CheckForCustAttr obj #comploc)[1] then 
				(
					custAttributes.add obj _cl.compLocCA BaseObject:true
					cam = Physical_Camera name:(obj.name + "_" + _cl.hotspotHT[1][1]) pos:_cl.hotspotHT[1][2] specify_fov:on
					cam.fov = 40
					cam.targeted = true
					cam.target.pos = obj.center
					
					LayerManager.newLayerFromName "Hotspots"
					(LayerManager.getLayerFromName "Hotspots").addNode cam
					(LayerManager.getLayerFromName "Hotspots").addNode (cam.target)
					
					obj.hotspot = cam
					
					setTransformLockFlags cam #{1..9}
					setTransformLockFlags (cam.target) #{1..9}
				)
			)
			
			FillSceneComponentsList()
			SetRelatives()
			
			if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList()
		)
		
		
		
		/* Remove scene component ***************************************************************************************************************************************************************/
		on removeComponentBtn pressed do
		(
			-- Check that there is a component to remove
			if _cl.sceneComponents.count != 0 then 
			(
				-- Get the selected component
				index = sceneComponentsLbx.selection
				if index != 0 then 
				(
					
					component = _cl.sceneComponents[index]
					if component != undefined then
					(
						delete component.hotspot
						_ca.RemoveCA #compLoc nodeList:(_sgz._extMxs.AsArray component)
						FillSceneComponentsList()
						
						-- select previous item if its the last from the list whose been removed
						if index > _cl.sceneComponents.count then 
							sceneComponentsLbx.selection = _cl.sceneComponents.count
						
						SetRelatives()
						
						if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList()
					)
				)
				
			)
		)
		
		
		
		/* Reload the list ***************************************************************************************************************************************************************/
		on reloadComponentsBtn pressed do
		(
			FillSceneComponentsList()
			SetRelatives()
			
			if csvFileTxt.text != "Set the spreadsheet path" then FillRequiredComponentsList()
		)
		
		
		
		/* Select the object shown in the list ############################################################################################*/
		on selectComponentBtn pressed do
		(
			select (for item in sceneComponentsLbx.items collect (getNodeByName item))
		)
		
		
		
		/* Set relative ***************************************************************************************************************************************************************/
		on sceneComponentsLbx selected item do SetRelatives()
		
		
		
		/* Select the component when double clicked ***************************************************************************************************************************************************************/
		on sceneComponentsLbx doubleClicked item do select _cl.sceneComponents[item]
			
		
		
		/* Switch to the camera view for the component ***************************************************************************************************************************************************************/
		on sceneComponentsLbx rightClick item do viewport.setCamera (_cl.sceneComponents[item]).hotspot
		
		
		
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
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
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
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				component.fov = component.hotspot.fov = val
			)
		)
		
		
		
		/* Set the visibility of hidden objects ***************************************************************************************************************************************************************/
		on hiddenChk changed state do 
		(
			if _cl.sceneComponents.count != 0 then
			(
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				(for obj in component.hidden collect obj.node).isHidden = state
				
			)
		)
		
		
		
		/* Add hidden object  ***************************************************************************************************************************************************************/
		on addHiddenBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				for obj in selection where obj != component do 
				(
					canAdd = true
					for relative in component.hidden while canAdd do 
					(
						if relative.node == obj then canAdd = false
					)
					
					if canAdd then 
					(
						appendIfUnique component.hidden (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						appendIfUnique component.hiddenName obj.name
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
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = hiddenLbx.selection
				if relativeIndex != 0 then
				(
					deleteItem component.hidden relativeIndex
					deleteItem component.hiddenName relativeIndex
				)
				
				SetRelatives()
				if hiddenLbx.selection == 0 and hiddenLbx.items.count >= 1 then hiddenLbx.selection = hiddenLbx.items.count
			)
		)
		
		
		
		/* Set the xray of transparent objects ***************************************************************************************************************************************************************/
		on transparentChk changed state do 
		(
			if _cl.sceneComponents.count != 0 then
			(
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				(for obj in component.transparent collect obj.node).xray = state
				
			)
		)
		
		
		
		on addTransparentBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
				component = getNodeByName sceneComponentsLbx.selected
				for obj in selection where obj != component do 
				(
					canAdd = true
					for relative in component.transparent while canAdd do 
					(
						if relative.node == obj then canAdd = false
					)
					
					if canAdd then 
					(
						append component.transparent (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						append component.transparentName obj.name
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
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = transparentLbx.selection
				if relativeIndex != 0 then
				(
					deleteItem component.transparent relativeIndex
					deleteItem component.transparentName relativeIndex
				)
				
				SetRelatives()
				if transparentLbx.selection == 0 and transparentLbx.items.count >= 1 then transparentLbx.selection = transparentLbx.items.count
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
					for relative in component.animated while canAdd do 
					(
						if relative.node == obj then canAdd = false
					)
					
					if canAdd then 
					(
						append component.animated (nodeTransformMonitor node:obj forwardTransformChangeMsgs:false)
						append component.animatedName obj.name
					)
				)
				
				SetRelatives()
			)
		)
		
		
		
		/* Remove Animated objects ***************************************************************************************************************************************************************/
		on removeAnimatedBtn pressed do
		(
			if _cl.sceneComponents.count != 0 then
			(
-- 				component = _cl.sceneComponents[sceneComponentsLbx.selection]
				component = getNodeByName sceneComponentsLbx.selected
				relativeIndex = animatedLbx.selection
				if relativeIndex != 0 then
				(
					deleteItem component.animated relativeIndex
					deleteItem component.animatedName relativeIndex
				)
				
				SetRelatives()
				if animatedLbx.selection == 0 and animatedLbx.items.count >= 1 then animatedLbx.selection = animatedLbx.items.count
			)
		)
		
	), -- End GetView()
	
	
	
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
	),
	
	
	
	/* Go through each component to update their relatives ############################################################################################*/
	macroMerge = 
	(
		macroScript CompLocPostMerge
			category:"SugzTools"
			toolTip:"CompLoc Post Merge"
			Icon:#("Comploc",4)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.UpdateComponent()
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
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.CleanScene()
				)
			)
		)
	),
	
	
	
	/* Clean the scene from the complocCA ############################################################################################*/
	macroSnapShot = 
	(
		macroScript CompLocSnapShot
			category:"SugzTools"
			toolTip:"CompLoc SnapShot"
			Icon:#("Comploc",6)
		
		(
			global _cl
			on execute do 
			(
				if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms" then 
				(
					fileIn "$userscripts\SugzTools\Scripts\CompLoc\CompLoc_Component.ms"
					_cl.MakeSnapShot()
				)
			)
		)
	)
	
)


(
	if heapSize < 100000000 then heapSize += 85000000
	hotspotHT = if _cl != undefined then _cl.hotspotHT else #()
	_cl = CompLocComponentStc()
	_cl.hotspotHT = hotspotHT
	_cl.Run()
)
