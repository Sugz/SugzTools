/*##############################################################################
Hotspot Manager
Version 0.05
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:

# Required Components:
SugzTools Custom Attributes Library

# Sources:

# To do list:

# History:

*Use / Modify this script at your own risk !
###############################################################################*/



try (destroyDialog _hotspot.HotspotMakerView) catch()
try (destroyDialog _hotspot.HotspotListView) catch()

global _hotspot, _ca
if doesFileExist "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms" do include "$userscripts\SugzTools\Libs\Custom_Attributes_Lib.ms"
_ca = CustomAttributesLibraryStc()

struct HotspotManagerStc
(
	heights = #(1.0, 10.0, 18.0, 40.0),
	insidePos = #([28.5, 3.89101, 19.5], [28.5, -3.92987, 19.5], [32.5, 0, 19], [46.5, 0, 18.25]),
	
	hotspotCA = undefined,				-- The hotspot custom attribute
	
	HotspotMakerView = undefined,					-- The hotspot maker rollout
	HotspotListView = undefined,						-- The hotspot list rollout
	
	dnColor = dotNetClass "System.Drawing.Color", 
	
	
	/*  ############################################################################################*/
	fn CreateCA = 
	(
		hotspotCA = attributes hotspotAttr attribID:#(0x6a52912, 0x6fe9699)
		(
			local heights = #(1.0, 10.0, 18.0, 35.0)
			local insidePos = #([28.5, 3.89101, 19.5], [28.5, -3.92987, 19.5], [32.5, 0, 19], [46.5, 0, 18.25])
			
			fn getNode = (refs.dependentnodes (custattributes.getowner this) firstonly:on)
			
			fn Setlocation = 
			(
				this.view.locationDdl.items = case this.locationType of 
				(
					1: #("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (3,5 m)")
					2: #("Pilot", "Copilot", "Cabin FWD", "Cabin AFT")
				)
			)
			
			parameters main rollout:view
			(
				locationType type:#integer ui:locationTypeRdb
				location type:#integer ui:locationDdl
				
				on location set val do
				(
					case locationType of 
					(
						1: (getNode()).pos.z = heights[val]
						2: (getNode()).pos = insidePos[val]
					)
				)
			)
			
			rollout view "Hotspot"
			(
				radiobuttons locationTypeRdb labels:#("Outside", "Inside") align:#left offsets:#([0,0], [15,0])
				dropdownlist locationDdl --items:#("Lying", "Crouch", "Standing", "Ladder")
				
				on view open do Setlocation()
				on locationTypeRdb changed val do 
				(
					Setlocation()
					this.location = 1
				)
				
			)
		)
	),
	
	
	
	/* Add or Update the hotspot custom attribute on selection  ############################################################################################*/
	fn AddCA cams =
	(
		/*<Function>
		Description:
			Add or Update the hotspot custom attribute on selection
		Arguments:
			<Array <Node>> cams: the cameras to add the hotspot custom attribute
		</Function>*/
		
		CreateCA()
		if cams.count != 0 then custAttributes.add cams hotspotCA BaseObject:true
	),
	
	
	
	/* Set hotspots location type and location ############################################################################################*/
	fn SetHotspotPos cams locationType location = 
	(
		/*<Function>
		Description:
			Set hotspots location type and location
		Arguments:
			<Array <Node>> cams: the cameras to set their hotspot custom attribute
			<Integer> locationType: the index of the location type dropdownlist 
			<Integer> location: the index of the location dropdownlist
		</Function>*/
		
		
		for cam in cams where isKindOf cam camera do 
		(
			cam.locationType = locationType
			cam.location = location
		)
		
	),
	
	
	
	/* Create a hotspot ############################################################################################*/
	fn CreateHotspot locationType location = 
	(
		/*<Function>
		Description:
			Create a hotspot
		Arguments:
			<Integer> locationType: the index of the location type dropdownlist 
			<Integer> location: the index of the location dropdownlist
		</Function>*/
		
		
		if selection.count == 1 then 
		(
			-- if the selected object is already a hotspot, just update definition
			if isKindOf selection[1] camera then AddCA selection
			else 
			(
				refObj = selection[1]
			
				tm = Inverse(viewport.getTM())
				
				cam = Physical_Camera wirecolor:blue transform:tm name:(refObj.name + "_Hotspot")
				cam.targeted = true
				cam.target.pos = refObj.center
				cam.pos = tm.translationpart
				
				cam.parent = cam.target.parent = refObj
				
				setTransformLockFlags cam.target #{1..9}
				
				AddCA #(cam)
				SetHotspotPos #(cam) locationType location
				
				viewport.setCamera cam
				select cam
			)
			
		)
	),
	
	
	/* Create the Hotspot Maker Rollout ############################################################################################*/
	fn GetHotspotMakerView = 
	(
		Rollout HotspotMakerView "Create Hotspot"
		(
			radiobuttons locationTypeRdb labels:#("Outside", "Inside") default:1 columns:2 align:#left offsets:#([-5,0], [15,0])
			dropdownlist locationDdl width:148 align:#center
			
			button createHotspotBtn "Create Hotspot" width:148 align:#center
-- 			button hotspotsListViewBtn "Open the hotspots list" width:148 align:#center
			
-- 			groupbox separatorGrp width:150 height:7 align:#center
-- 			button exportBtn "Export" width:150 align:#center offset:[0,5] enabled:false
			
			
			fn Setlocation = 
			(
				locationDdl.items = case locationTypeRdb.state of 
				(
					1:#("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (3,5 m)")
					2:#("Pilot", "Copilot", "Cabin FWD", "Cabin AFT")
				)
			)
			
			
			on HotspotMakerView open do Setlocation()
			
			on locationTypeRdb changed val do Setlocation()
			
			on locationDdl selected val do _hotspot.SetHotspotPos selection (locationTypeRdb.state) val
			
			on createHotspotBtn pressed do _hotspot.CreateHotspot (locationTypeRdb.state) (locationDdl.selection)
			
			on hotspotsListViewBtn pressed do _hotspot.GetHotspotListView()
			
		)
		createDialog _hotspot.HotspotMakerView 160 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	),
	
	
	
	/* Create the Hotspot List Rollout ############################################################################################*/
	fn GetHotspotListView = 
	(
		Rollout HotspotListView "Hotspots"
		(
			local hotspotList = #()
			local selCam
			
			dropdownlist choiceDdl items:#("Ouside all", "Ouside wrong", "Inside all", "Inside wrong") width:384 align:#center 
			dotNetControl hotspotLv "listView" width:384 height:200 align:#center offset:[0,-2]
			button reloadListBtn "Reload" width:120 align:#left offset:[-5,0]
			button fixSelectedBtn "Quick fix selected" width:120 align:#center offset:[0,-26]
			button fixAllBtn "Quick fix all" width:120 align:#right offset:[5,-26]
			
			/* Function ############################################################################################*/
			/* Set the columns for the listview ***************************************************************************************************************************************************************/
			fn SetListViewColumns = 
			(
				hotspotLv.columns.clear()
				case choiceDdl.selection of 
				(
					1: (hotspotLv.columns.add "Camera" 300; hotspotLv.columns.add "Height" 80)
					2: (hotspotLv.columns.add "Camera" 300; hotspotLv.columns.add "Height" 80)
					3: (hotspotLv.columns.add "Camera" 255; hotspotLv.columns.add "Position" 125)
					4: (hotspotLv.columns.add "Camera" 255; hotspotLv.columns.add "Position" 125)
				)
			)
			
			
			/* Set the listview look ***************************************************************************************************************************************************************/
			fn SetListView =
			(
				--Setup the forms view
				hotspotLv.view = (dotNetClass "system.windows.forms.view").details
				hotspotLv.FullRowSelect = true
				hotspotLv.MultiSelect = false		
				hotspotLv.AllowColumnReorder = false
				hotspotLv.BackColor = dnColor.FromArgb 255 86 86 86
				hotspotLv.ForeColor = dnColor.FromArgb 255 225 225 225
				
				SetListViewColumns()
			)
			
			
			/* Fill the listview ***************************************************************************************************************************************************************/
			fn FillListView = 
			(
				hotspotLv.items.clear()
				for cam in hotspotList do 
				(
					listViewItem = dotNetObject "System.Windows.Forms.ListViewItem" cam.name		--Create a listViewItem object and name it. 
					pos = cam.pos
				
					case choiceDdl.selection of 
					(
						1: listViewItem.subitems.add (pos.z as string)		--Add data to the second column.
						2: listViewItem.subitems.add (pos.z as string)		--Add data to the second column.
						3: listViewItem.subitems.add (pos[1] as string + ", " + pos[2] as string + ", " + pos[3] as string)		--Add data to the second column.
						4:  listViewItem.subitems.add (pos[1] as string + ", " + pos[2] as string + ", " + pos[3] as string)		--Add data to the second column.
					)
					
					
					hotspotLv.items.add listViewItem
				)
			)
			
			
			
			/* Get the hotspot list ***************************************************************************************************************************************************************/
			fn GetHotspotList =
			(
				/*<Function>
				Description:
					Get the hotspot list
				</Function>*/
				
				hotspotList = _ca.GetObjsWithCA #hotspotAttr nodeList:cameras
				
				case choiceDdl.selection of 
				(
					1: hotspotList = for cam in hotspotList where cam.locationType == 1 collect cam
					2: hotspotList = for cam in hotspotList where cam.locationType == 1 collect cam
					3: hotspotList = for cam in hotspotList where cam.locationType == 2 collect cam
					4: hotspotList = for cam in hotspotList where cam.locationType == 2 collect cam
				)
				
				FillListView()
			)
			
			
			
			/* Events ############################################################################################*/
			on HotspotListView open do 
			(
				SetListView()
				GetHotspotList()
			)
			
			
			on choiceDdl selected val do 
			(
				SetListViewColumns()
				GetHotspotList()
			)
			
			
			
			
		)
		createDialog HotspotListView 400 260 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	)
	
	
)


_hotspot = HotspotManagerStc()
_hotspot.GetHotspotMakerView()

clearListener()
