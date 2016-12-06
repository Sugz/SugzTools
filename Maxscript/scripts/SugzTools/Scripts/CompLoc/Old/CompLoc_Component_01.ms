/*##############################################################################
CompLoc Component
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Required Components:
SugzTools Manager
SugzTools Extend Maxscript Library

# Script infos:

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/

try(destroyDialog _comp.View) catch()

global _comp
struct CompLocComponentStc
(
	
	compLocCA = undefined,			-- The comploc custom attribute
	components = #(),						-- Nodes having the comploc custom attribute
	View = undefined,						-- The rollout
	excelFile = undefined,					-- The location of the excel file	
	atas = #(),									-- The ATA for current user
	
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
				
				on hotspotBtn  rightclick do
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

	
	
	/* Add or Update the custom attribute comploc ############################################################################################*/
	fn AddCA =
	(
		custAttributes.add selection compLocCA BaseObject:true
	),
	
	
	
	/* Get scene objects that have the comploc custom attribute  ############################################################################################*/
	fn GetComponents =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		components = for obj in (_custAttr.GetObjsWithCA #compLoc) collect obj
	
	),
	
	
	
	/* Execute  ############################################################################################*/
	fn Run = 
	(
		CreateCA()
		AddCA()
	),
	
	
	/* Get Info from the Excel File ############################################################################################*/
	fn GetDataFromXlsx columnFilter valueFilter columnToGet arr =
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
		
		if excelFile != undefined then 
		(
			-- create a temporary copy of the excel file and open it 
			tempFile = (getFilenamePath (_comp.excelFile)) + "\\temp.xlsx"
			copyFile (_comp.excelFile) tempFile
			excel = CreateOLEObject "Excel.Application"
			excel.application.Workbooks.Open(tempFile)
				
			-- set the activesheet
			(excel.Worksheets "Complete-Unity-CPC").Activate 
			RowCount = excel.ActiveSheet.UsedRange.Rows.Count
				
			-- Get data
			for i = 1 to rowCount do 
			(
				try 
				(
					if  (excel.ActiveSheet.Cells i columnFilter).value == valueFilter then 
					(
						ata = (excel.ActiveSheet.Cells i columnToGet).value
						if ata != undefined then appendIfUnique arr ata
					)
					
				) catch()
			)
			
			-- exit excel, release ole object and delete the temp excel file
			excel.application.ActiveWorkbook.Close
			excel.quit()
			releaseAllOLEObjects()
			deleteFile tempFile
				
		)
		
		arr
	),
	
	
	/* View ############################################################################################*/
	fn GetView = 
	(
		Rollout View "Hotspot Maker"
		(
			label requiredComponentsLbl "Required Components :" align:#left offset:[-5,0]
			dropdownlist atasDdl width:75 align:#center offset:[-42,-21]
			listbox requiredComponentsList  width:240 height:40 align:#left offset:[-7,-5]
			edittext excelFileTxt width:185 align:#left offset:[-10,0] 
			button setExcelFilePathBtn "..." width:25 align:#center offset:[-45,-24] tooltip:"Get the Excel file path"
			button loadExcelFileBtn "L" width:25 align:#center offset:[-17,-26] tooltip:"Load the Excel file" enabled:false
			
			label sceneComponentsLbl "Scene Components :" align:#center offset:[55,-574]
			listbox sceneComponentsList  width:240 height:25 align:#right offset:[7,0]
			button addComponentBtn "Add Component" width:115  align:#center offset:[60,-3] 
			button removeComponentBtn "Remove Component" width:115  align:#right offset:[7,-26] 

			groupbox separatorGrp width:230 height:7 align:#right offset:[2,-3]
			
			button hotspotBtn "Set Hotspot" width:240 height:20 align:#right offset:[7,1]
			dropdownlist objectsTypeDdl items:#("Transparent", "Hidden", "Animated") width:240 align:#right offset:[7,0]
			listbox relatedObjectsList width:240 height:8 align:#right offset:[7,-5]
			button addObjectsBtn "Add Objects" width:115 align:#center offset:[60,-3] 
			button removeObjectsBtn "Remove Objects" width:115 align:#right offset:[7,-26] 
			

			on View open do 
			(
				excelFileTxt.text = _comp.excelFile as string
				if _comp.excelFile != undefined then loadExcelFileBtn.enabled = true
					
				sceneComponentsList.items = for obj in _comp.components collect obj.name
			)
			
			on setExcelFilePathBtn pressed do 
			(
				filename = getOpenFileName caption:"Open the Excel synthesis file" types:"Excel(*.xlsx)"
				if filename != undefined then 
				(
					_comp.excelFile = excelFileTxt.text = filename
					loadExcelFileBtn.enabled = true
				)
			)
			
			on loadExcelFileBtn pressed do
			(
				-- Fill the atas array and change their value to integer and fill the dropdownlist
				_comp.GetDataFromXlsx 10 "CPC" 7 _comp.atas
				_comp.atas = for ata in _comp.atas collect (ata as integer)
				atasDdl.items = for ata in _comp.atas collect ("ATA " + ata as string)
				
				/*
				if _comp.excelFile != undefined then 
				(
					tempFile = (getFilenamePath (_comp.excelFile)) + "\\temp.xlsx"
					copyFile (_comp.excelFile) tempFile
					excel = CreateOLEObject "Excel.Application"
					excel.application.Workbooks.Open(tempFile)
					(excel.Worksheets "Complete-Unity-CPC").Activate 
					RowCount = excel.ActiveSheet.UsedRange.Rows.Count
					
					for i = 1 to rowCount do 
					(
						try 
						(
							if  (excel.ActiveSheet.Cells i 10).value == "CPC" then 
							(
								ata = (excel.ActiveSheet.Cells i 7).value
								if ata != undefined then appendIfUnique _comp.atas (ata as integer)
							)
							
						) catch()
					)
					
					atasDdl.items = for i in _comp.atas collect ("ATA " + i as string)
					
					excel.application.ActiveWorkbook.Close
					excel.quit()
					releaseAllOLEObjects()
					deleteFile tempFile
				)
				*/
				
			)
			
			on atasDdl selected item do 
			(
				ataComponents = #()
				_comp.GetDataFromXlsx 7 _comp.atas[item] 16 ataComponents
				requiredComponentsList.items = ataComponents
				
				/*
				tempFile = (getFilenamePath (_comp.excelFile)) + "\\temp.xlsx"
				copyFile (_comp.excelFile) tempFile
				excel = CreateOLEObject "Excel.Application"
				excel.application.Workbooks.Open(tempFile)
				(excel.Worksheets "Complete-Unity-CPC").Activate 
				RowCount = excel.ActiveSheet.UsedRange.Rows.Count
				
				ataComponents = #()
				for i = 1 to rowCount do 
				(
					try 
					(
						if  (excel.ActiveSheet.Cells i 7).value == _comp.atas[item] then 
						(
							ataComponent = (excel.ActiveSheet.Cells i 16).value
							if ataComponent != undefined then appendIfUnique ataComponents (ataComponent as string)
						)
						
					) catch()
				)
				
				requiredComponentsList.items = ataComponents
				
				excel.application.ActiveWorkbook.Close
				excel.quit()
				releaseAllOLEObjects()
				*/
			)
			
		)
	),
	
	
	/* Create a dialog and add the view inside ############################################################################################*/
	fn CreateView = 
	(
		GetComponents()
		try(destroyDialog _comp.View) catch()
		GetView()
		createDialog _comp.view 500 580 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	)
	
	
)
_comp = CompLocComponentStc()
-- _comp.Run()
_comp.CreateView()
