(
	for file in (getFiles @"D:\Travail\SVN3D\H145\MAX\CAO\2016-11-25-3D\*.max") where (filenameFromPath file) !=  "__H145_Full_Xref__.max" do 
	(
		loadMaxFile file useFileUnits:true quiet:true
-- 		
		(layerManager.getLayer 1).setName ("CAO_" + getFilenameFile MaxFileName )

		saveMaxFile file quiet:true
		
-- 		xrefs.addNewXRefFile file
	)
	
)