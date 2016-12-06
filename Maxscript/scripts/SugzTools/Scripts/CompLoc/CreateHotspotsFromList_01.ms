try(destroyDialog ::Roll) catch()
Rollout Roll "Sugz"
(
	local _csv
	
	edittext excelFileTxt width:155 offset:[-7,0] align:#left
	button excelFileBtn "..." width:25 height:18 offset:[5,-22] align:#right
	button setHotspotBtn "Create Hotspots" width:183 offset:[1,0] align:#center
	
	
	on Roll open do 
	(
		if doesFileExist "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms" do include "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
		_csv = SpreadsheetParserLibraryStc()	
	)
	
	
	on excelFileBtn pressed do
	(
		filename = getOpenFileName caption:"Open the synthesis file" types:"Excel(*.csv)|*.csv|Excel(*.xlsx, *.xlsm)|*.xlsx;*.xlsm|All|*.*|"
		if filename != undefined then 
		(
			_csv.file = excelFileTxt.text = filename
			_csv.GetExcelOLE()
		)
	)
	
	
	on setHotspotBtn pressed do
	(
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
				stringPos = filterString htEnum.Value ", "
				p = [0,0,0]
				p[1] = stringPos[1] as float * -10
				p[2] = stringPos[3] as float * 10
				p[3] = stringPos[2] as float * 10
				
				column1 = (_csv.excel.ActiveSheet.Cells i 1).value
				column2 = (_csv.excel.ActiveSheet.Cells i 2).value
				ht.Add column1 column2
				
			) catch()
		)
		
		
		htEnum = ht.GetEnumerator()
		while htEnum.MoveNext() do 
		(
			stringPos = filterString htEnum.Value ", "
			p = [0,0,0]
			p[1] = stringPos[1] as float * -10
			p[2] = stringPos[3] as float * 10
			p[3] = stringPos[2] as float * 10

			c = Physical_Camera name: htEnum.Key
			c.pos = p
			c.targeted = false
		)
		
		_csv.DestroyExcelOLE()
	)
	
	
	
)
createDialog Roll 200 300 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)