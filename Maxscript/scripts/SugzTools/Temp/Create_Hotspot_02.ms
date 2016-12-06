global _hotspot
struct HotspotManagerStc
(
	heights = #(1.0, 10.0, 18.0, 40.0),
	insidePos = #([28.5, 3.89101, 19.5], [28.5, -3.92987, 19.5], [32.5, 0, 19], [46.5, 0, 18.25]),
	HotspotCA = undefined,				-- The hotspot custom attribute
	
	HotspotMakerView = undefined,					-- The hotspot maker rollout
	HotspotListView = undefined,						-- The hotspot list rollout
	
	dnColor = dotNetClass "System.Drawing.Color", 
	
	
	/*  ############################################################################################*/
	fn CreateHotspotCA =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		HotspotCA = attributes HotspotAttr attribID: #(0x5887f429, 0x3990ace3)
		(
			parameters params rollout:view
			(
				locationType type:#integer ui:locationsRdb
				location type:#integer ui:locationsDdl
				
				on locationType changed val do 
				(
					case val of
					(
						1: this.view.locationsDdl.items = #("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (4 m)")
						2: this.view.locationsDdl.items = #("Pilot", "Copilot", "Cabin FWD", "Cabin AFT")
					)
				)
			)
			 
			rollout view "CompLoc Component"
			(
				radiobuttons locationsRdb labels:#("Outside", "Inside") default:1 columns:2 
				dropdownlist locationsDdl items:#("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (4 m)")
				
				on view open do 
				(
					case this.locationType of
					(
						1: locationsDdl.items = #("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (4 m)")
						2: locationsDdl.items = #("Pilot", "Copilot", "Cabin FWD", "Cabin AFT")
					)
				)
				
			)
		)
	
	),
	
	
	
	/* Add or Update the comploc custom attribute on selection  ############################################################################################*/
	fn AddCA objs =
	(
		if objs.count != 0 then 
		(
			CreateHotspotCA()
			(custAttributes.add objs HotspotCA BaseObject:true)
		)
	),
	
	
	
	/* Set a hotspot location ############################################################################################*/
	fn SetHotspotPos objs index location = 
	(
		/*<Function>
		Description:
			Set a hotspot position
		Arguments:
			<Integer> index: the index of the dropdownlist selection
			<Name> location: the location of the hotspot: #oustide / #inside
		</Function>*/
		
		
		if objs.count != 0 then for obj in objs do 
		(
			if superClassOf obj == camera and not isKindOf obj Targetobject do 
			(
				case location of 
				(
					#oustide: obj.locationType = 1
					#inside: obj.locationType = 2
					/*
					#oustide: obj.pos.z = heights[index]
					#inside: obj.pos = insidePos[index]
					*/
				)
				obj.location = index
			)
		)
		
		
	),
	
	
	
	/* Create a hotspot ############################################################################################*/
	fn CreateHotspot index location = 
	(
		if selection.count == 1 then 
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
			SetHotspotPos #(cam) index location

			viewport.setCamera cam
			select cam
		)
	),
	
	
	
	

	
	
	fn GetHotspotMakerView = 
	(
		Rollout HotspotMakerView "Hotspot"
		(
			radiobuttons locationsRdb labels:#("Outside", "Inside") default:1 columns:2 align:#left offsets:#([-5,0], [15,0])
			dropdownlist locationsDdl items:#("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (4 m)") width:148 align:#center

			button createHotspotBtn "Create Hotspot" width:148 align:#center
			button checkCamHeightbtn "Check Cameras Height" width:148 align:#center
			
			groupbox separatorGrp width:150 height:7 align:#center
			button exportBtn "Export" width:150 align:#center offset:[0,5] enabled:false
			
			
			
			
			on locationsRdb changed val do 
			(
				case locationsRdb.state of
				(
					1: locationsDdl.items = #("Lying (0,1 m)", "Crouched (1 m)", "Standing (1,8 m)", "Ladder (4 m)")
					2: locationsDdl.items = #("Pilot", "Copilot", "Cabin FWD", "Cabin AFT")
				)
			)
			
			on locationsDdl selected val do 
			(
				case locationsRdb.state of
				(
					1: _hotspot.SetHotspotPos val #oustide
					2: _hotspot.SetHotspotPos val #inside
				)
				
			)
			
			
			on createHotspotBtn pressed do 
			(
				case locationsRdb.state of
				(
					1: _hotspot.CreateHotspot locationsDdl.selection #oustide
					2: _hotspot.CreateHotspot locationsDdl.selection #inside
				)
				
			)
			
		)
		createDialog _hotspot.HotspotMakerView 160 150 style:#(#style_titlebar, #style_sysmenu, #style_toolwindow)
	)
		
	
	
)


_hotspot = HotspotManagerStc()
_hotspot.GetHotspotMakerView()
