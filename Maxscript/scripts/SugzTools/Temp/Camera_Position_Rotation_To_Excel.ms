(
	
	
	

	fn GetCamTm cam = 
	(
		hasTarget = false
		if cam.targeted then 
		(
			hasTarget = true 
			cam.targeted = false
		)
		
		ss = StringStream ""
		format "cam: %; pos: %; rot: %\n" cam.name cam.pos cam.rotation to:ss
		
		if hasTarget then cam.targeted = true
			
		ss
	)
	
	
	 -- Generate a filename
	excelFile = @"D:\Hotspots.xlsx"

	-- Start an Excel OLE Object
	x = CreateOLEObject "Excel.Application"

	-- Create a new workbook in the new excel document
	x.application.Workbooks.Add

	-- Give the active sheet a name ("Test
	x.ActiveSheet.Name = "Hotspots"

	-- Put some content into Collumn A
	i = 1
	for cam in cameras where not isKindOf cam Targetobject do 
	(
		(x.application.Range("A" + i as string)).value = (GetCamTm cam as string)
		i += 1
	)

	-- Save the spreadsheet
	x.application.ActiveWorkbook.SaveAs(excelFile)

	-- Close the spreadsheet
	x.application.ActiveWorkbook.Close

	-- quit excel
	x.quit()

	-- Release the OLE Object
	releaseOLEObject x

	-- Release ALL OLE Objects, just incase
	releaseAllOLEObjects()

)