(
	excelFile = @"D:\Travail\SVN3D\H135CompLoc\synthesis\test.xlsx"

	x = CreateOLEObject "Excel.Application"

	x.application.Workbooks.Open(excelFile)


	(x.Worksheets "Complete-Unity-CPC").Activate 
	
	RowCount = x.ActiveSheet.UsedRange.Rows.Count
-- 	count = 0
	for i = 1 to rowCount do 
	(
		try 
		(
			if  (x.ActiveSheet.Cells i 10).value == "CPC" then 
			(
				objName = (x.ActiveSheet.Cells i 16).value
				if objName != undefined then count += 1
			)
			
		) catch()
		
	)
	
-- 	count
	
)