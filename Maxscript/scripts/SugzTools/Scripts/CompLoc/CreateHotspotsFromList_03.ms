try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	local _csv
	local oldCam = undefined
	
	edittext excelFileTxt width:155 offset:[-7,0] align:#left
	button excelFileBtn "..." width:25 height:18 offset:[5,-22] align:#right
	button setHotspotBtn "Create Hotspots" width:183 offset:[1,0] align:#center
	button exportHotspotBtn "Export Hotspots" width:183 offset:[1,0] align:#center
	button getSnapshotBtn "Create Snapshot" width:183 offset:[1,0] align:#center
	
	dropdownlist hotspotListDdl width:183 offset:[1,0] align:#center
	
	
	
	fn GetCamPos cam = 
	(
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
			
		ss
	)
	
	
	
	on Roll open do 
	(
		if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
		_csv = SpreadsheetParserLibraryStc()	
		
		hotspotListDdl.items = for cam in cameras where not isKindOf cam Targetobject collect cam.name

	)
	
	
	on excelFileBtn pressed do
	(
		excelFileTxt.text = if (filename =_csv.GetFile "Open the hotspot list") != undefined then filename
	)
	
	
	on setHotspotBtn pressed do
	(
		_csv.GetExcelOLE()
		(_csv.excel.Worksheets "Hotspots").Activate 
		RowCount = _csv.excel.ActiveSheet.UsedRange.Rows.Count
		
		-- try catch si le layer existe déjà
		try 
		(
			l = LayerManager.newLayerFromName "Hotspots"
			l.current = true
		) catch()
		
		for i = 2 to rowCount do 
		(
			try 
			(
				stringPos = filterString ((_csv.excel.ActiveSheet.Cells i 2).value) ", "
				p = [0,0,0]
				p[1] = stringPos[1] as float * -10
				p[2] = stringPos[3] as float * -10
				p[3] = stringPos[2] as float * 10
				
				cam = Physical_Camera pos:p name: ((_csv.excel.ActiveSheet.Cells i 1).value)
				cam.fov = 40
				cam.targeted = true
				cam.wireColor = color 88 199 225
				
			) catch()
		)
		
		_csv.DestroyExcelOLE()
	)
	
	
	on exportHotspotBtn pressed do
	(
		_csv.GetExcelOLE()
		(_csv.excel.Worksheets "Hotspots").Activate 
		
		i = 2
		for cam in cameras where not isKindOf cam Targetobject do 
		(
			(_csv.excel.application.Range("A" + i as string)).value = cam.name
			(_csv.excel.application.Range("B" + i as string)).value = (GetCamPos cam as string)
			i += 1
		)
		
		_csv.excel.application.ActiveWorkbook.SaveAs(_csv.file)
		
		_csv.DestroyExcelOLE()
	)
	
	
	on getSnapshotBtn pressed do
	(
		path = _sgz._extMxs.GetWinFolders #MyPictures + "\\Hotspots\\"
		if not (doesFileExist path) then makeDir path

		for cam in cameras where not isKindOf cam Targetobject do 
		(
			viewport.setCamera cam
			redrawViews()
			ssBitmap3 = viewport.getViewportDib()
			ssBitmap3.filename = path + cam.name + ".jpg"
			save ssBitmap3 quiet:true
		)
	)
	
	
	on hotspotListDdl selected item do 
	(
		if oldCam != undefined then oldCam.target.pos = [37, 0, 18]
		oldCam = getNodeByName (hotspotListDdl.selected)
		if selection.count == 1 
			then oldCam.target.pos = $.pos 
			else oldCam.target.pos = [37, 0, 18]
		
		viewport.setCamera oldCam
	)
	
	
)
createDialog Roll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)