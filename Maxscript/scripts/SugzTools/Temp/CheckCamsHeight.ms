try(destroyDialog ::HotspotListView) catch()
Rollout HotspotListView "Hotspots"
(
	local heights = #(1.0, 10.0, 18.0, 40.0)
	
	local dnColor = dotNetClass "System.Drawing.Color" -- dotNetClass to define colors
	local wrongCams = #()
	local selCam
	
	dropdownlist choiceDdl items:#("Ouside all", "Ouside wrong","Inside all", "Inside wrong") width:384 align:#center 
	dotNetControl camList "listView" width:384 height:200 align:#center offset:[0,-5]
	button reloadListBtn "Reload" width:120 align:#left offset:[-5,0]
	button fixSelectedBtn "Quick fix selected" width:120 align:#center offset:[0,-26]
	button fixAllBtn "Quick fix all" width:120 align:#right offset:[5,-26]
	
	/* Function ############################################################################################*/
	fn SetListViewColumns lv = 
	(
		lv.columns.clear()
		case choiceDdl.selection of 
		(
			1: (lv.columns.add "Camera" 275; lv.columns.add "Height" 100)
			2: (lv.columns.add "Camera" 275; lv.columns.add "Height" 100)
			3: (lv.columns.add "Camera" 275; lv.columns.add "Position" 100)
			4: (lv.columns.add "Camera" 275; lv.columns.add "Position" 100)
		)
	)
	
	
	
	fn SetListView lv =
	(
		--Setup the forms view
		lv.view = (dotNetClass "system.windows.forms.view").details
		lv.FullRowSelect = true
		lv.MultiSelect = false		
		lv.AllowColumnReorder = false
		lv.BackColor = dnColor.FromArgb 255 86 86 86
		lv.ForeColor = dnColor.FromArgb 255 225 225 225
		
		lv.columns.add "Camera" 275
		lv.columns.add "Height" 100
	)
	
	
	
	fn FillListView lv = 
	(
		lv.items.clear()
		for cam in wrongCams do 
		(
			listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" cam.name		--Create a listViewItem object and name it. 
			listViewItem.subitems.add (cam.pos.z as string)		--Add data to the second column.
			
			lv.items.add listViewItem
		)
	)
	
	
	
	fn GetWrongCams = 
	(
		wrongCams = #()
		for cam in cameras where not isKindOf cam Targetobject do 
		(
			correctHeight = false
			for height in heights do 
			(
				val = height - cam.pos.z
				if val > -0.01 and val < 0.01 then correctHeight = true
			)
			
			if not correctHeight then append wrongCams cam
		)
		
		FillListView camList
	)
	
	
	
	fn getObjectFromList e = 
	(
		if camList.items.count != 0 then 
		(
			hit = (camList.HitTest (dotNetObject "System.Drawing.Point" e.x e.y))
			getNodeByName hit.item.text
		)
	)
	
	
	
	fn fixCamHeight cam = 
	(
		result = 1000000.0
		finalHeight = 0.0
		for height in heights do 
		(
			test = cam.pos.z - height
			if abs test < abs result then 
			(
				result = test
				finalHeight = height
			)
		)
		
		cam.pos.z = finalHeight
		GetWrongCams()
-- 		FillListView camList
	)
	
	
	
	/* Events ############################################################################################*/
	on HotspotListView open do 
	(
		SetListView camList
		GetWrongCams()
	)
	
	
	on choiceDdl selected val do SetListViewColumns camList
	
	
	on camList MouseDoubleClick s e do select (getObjectFromList e)
	
	on camList MouseUp s e do 
	(
		if (e.Button == (dotNetClass "MouseButtons").Right) 
			then viewport.setCamera (getObjectFromList e)
			else selCam = getObjectFromList e
		
	)
	
	on reloadListBtn pressed do GetWrongCams()
	on fixSelectedBtn pressed do fixCamHeight selCam
	on fixAllBtn pressed do for cam in wrongCams do fixCamHeight cam

	
	
)
createDialog HotspotListView 400 260 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)