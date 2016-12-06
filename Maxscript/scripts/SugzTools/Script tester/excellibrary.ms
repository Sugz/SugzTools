(
	fileIn "$userscripts\SugzTools\Libs\Spreadsheet_Parser_Lib.ms"
	global _csv = SpreadsheetParserLibraryStc()

	_csv.file = @"D:\Travail\SVN3D\H135CompLoc\synthesis\CPC_AHVMT CS H135 CompLoc 001 A-synthesis v0006_temp"

	if doesFileExist (_csv.file + ".csv") then _csv.file += ".csv"
	else
	(
		_csv.file += ".xlsx"
		_csv.ConvertXLSXToCSV "Complete-Unity"
	)

	
	columns = dotNetObject "System.Collections.Hashtable"
	columns.Add "ATAs" "3D ATA"
	columns.Add "Graphist" "Graphist"
	columns.Add "Names" "Element name in 3D"
	columns.Add "StartupVis" "Visible at start-up"
	columns.Add "Openable" "Openable"
	columns.Add "Hotspot" "Hotspot location"
	columns.Add "Transparent" "Transparent Container"
	columns.Add "Hidden" "Panel to hide"
	columns.Add "Animated" "Animation"

	print columns.Item["Transparent"]
	columns[1]
	
-- 	_csv.GetRow 1
	
-- 	clemObjects = _csv.GetColumn (_csv.GetColumnIndex namesColumn) columnFilter:(_csv.GetColumnIndex graphistColumn) filter:"CPC" --unique:false
-- 	clemObjects.count
)
