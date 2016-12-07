/*##############################################################################
SugzTools Spreadsheet Parser Library
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Create a dotnet HashTable from a csv file

# Required Components:
SugzTools Extend Maxscript Library

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !*
###############################################################################*/

DotNet.loadAssembly "Microsoft.VisualBasic.dll"

struct SpreadsheetParserLibraryStc
(
	file = undefined,																				-- the file to parse
	tempFile = undefined,																		-- a temp file to avoid messing with the original one
	excel = undefined,																			-- the excel OLE object
	
	
	/* Open File Dialogs for spreadsheet ############################################################################################*/
	fn GetFile title excel:false=
	(
		/*<Function>
		Description:
			Open File Dialogs for spreadsheet
		Arguments:
		Return:
			<String> filename: the filename 
		Further Infos:
		</Function>*/
		
		
		local types
		case excel of
		(
			true: types = "Excel(*.xlsx, *.xlsm)|*.xlsx;*.xlsm|Spreadsheet(*.csv)|*.csv|All|*.*|"
			false: types = "Spreadsheet(*.csv)|*.csv|Excel(*.xlsx, *.xlsm)|*.xlsx;*.xlsm|All|*.*|"
		)
		
		filename = getOpenFileName caption:title types:types filename:MaxFilePath
		if filename != undefined then file = filename
		
		filename
	),
	
	
	/* Create a temporary excel file and open it as OLE Object ############################################################################################*/
	fn GetExcelOLE =
	(
		/*<Function>
		Description:
			Create a temporary excel file and open it as OLE Object
		</Function>*/

		if excel == undefined then
		(
			tempFile = getFilenamePath file + "\\temp" + getFilenameType file
			copyFile file tempFile
			excel = CreateOLEObject "Excel.Application"
			excel.application.Workbooks.Open(tempFile)
		)
	),
	
	
	
	/* Delete the temporary excel file and release the OLE Object ############################################################################################*/
	fn DestroyExcelOLE =
	(
		/*<Function>
		Description:
			Delete the temporary excel file and release the OLE Object
		</Function>*/
		
		-- exit excel, release ole object and delete the temp excel file
		excel.application.ActiveWorkbook.Close false
		excel.quit()
		releaseAllOLEObjects()
		excel = undefined
		deleteFile tempFile
		
	),
	
	
	
	/* Convert Excel FileType to CSV ############################################################################################*/
	fn ConvertXLSXToCSV excelAS =
	(
		/*<Function>
		Description:
			Convert Excel FileType to CSV
		Arguments:
			<String> excelAS: the active sheet
		Return:
		</Function>*/
		
		GetExcelOLE()
		(excel.Worksheets excelAS).Activate 
		file = (getFilenamePath file + getFilenameFile file)
		excel.DisplayAlerts = false
		file = file + "_" + excelAS + ".csv"
		excel.ActiveSheet.SaveAs file 24
		DestroyExcelOLE()
		
	),
	
	
	
	/* Get the row count ############################################################################################*/
	fn GetRowCount =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		count = 0
		parser = dotnetObject "Microsoft.VisualBasic.FileIO.TextFieldParser" file
		parser.SetDelimiters(#(";"))
			
		while not parser.EndOfData do 
		(
			count += 1
			parser.ReadLine()
		)
	
		parser.close()
		count
	),
	
	
	
	/* Get data from a row number ############################################################################################*/
	fn GetRow rowNb unique:true =
	(
		/*<Function>
		Description:
			Get data from a row number
		Arguments:
			<Integer> rowNb: the row number
			<Optional> <Bool> unique: set wheter the function only return unique values or all of them. <Default: false>
		Return:
			<Var> rowData : datas from selected column
		</Function>*/
		
		
		rowData = #()
		parser = dotnetObject "Microsoft.VisualBasic.FileIO.TextFieldParser" file
		parser.SetDelimiters(#(";"))
		
		-- read each line until the desired line, then get data	
		for i = 1 to rowNb do 
		(
			rowCells = parser.ReadFields()
			if i == rowNb then for cellValue in rowCells do
			(
				if unique 
					then appendIfUnique rowData cellValue
					else append rowData cellValue
			)
		)
		
		parser.close()
		rowData
	),
	
	
	
	/* Get the column index from its header ############################################################################################*/
	fn GetColumnIndex header =
	(
		/*<Function>
		Description:
			Get the column index from its header
		Arguments:
			<String> header: the header of the column
		Return:
			<Integer> the index of the column
		</Function>*/
		
		return findItem (GetRow 1) header
	),
	
	
	
	/* Get data from a column ############################################################################################*/
	fn GetColumn columnNb columnFilter:undefined filter:undefined header:false unique:true debug:undefined =
	(
		/*<Function>
		Description:
			Get data from a column
		Arguments:
			<Integer> columnNb: the column number
			<Optional> <Integer> columnFilter: the number of the column use to filter
			<Optional> <Var> filter: the filter
			<Optional> <Bool> header: set wheter the function return the value from the first row. <Default: false>
			<Optional> <Bool> unique: set wheter the function only return unique values or all of them. <Default: false>
		Return:
			<Var> columnData : datas from selected column
		</Function>*/
		
		
		columnData = #()
		parser = dotnetObject "Microsoft.VisualBasic.FileIO.TextFieldParser" file
		parser.SetDelimiters(#(";"))
			
		while not parser.EndOfData do
		(
			-- read line and get the value from selected column
			columnCells = parser.ReadFields()
			if not header then header = true
			else
			(
				-- check if data need filtering
				if columnFilter != undefined and filter != undefined then 
				(
					if columnCells[columnFilter] == filter then
					(
						if debug != undefined then print (debug + " " + columnFilter as string + " " + filter as string)
						if unique 
							then appendIfUnique columnData columnCells[columnNb]
							else append columnData columnCells[columnNb]
					)
				)
				else 
				(
					if unique 
						then appendIfUnique columnData columnCells[columnNb]
						else append columnData columnCells[columnNb]
				)
				
			)
		)
		
		parser.close()
		columnData
	),
	
	
	
	/* Get a cell from its data ############################################################################################*/
	fn GetCellFromData data =
	(
		/*<Function>
		Description:
			Get a cell from its data
		Arguments:
			<String> data: the data to get the cell
		Return:
			<Array <<Integer>> cell:
		</Function>*/
		
		
	
	)
	
	
	
)
