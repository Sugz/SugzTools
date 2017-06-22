(
	
	LightsMasterCA =  attributes LightsMaster
	(
		-- Get the node this custom attribute is attached to ------------------------------------------------------------------------------------------------------------------------------------------------------
		fn GetNode = (refs.dependentnodes (custattributes.getowner this) firstonly:on)
		
		parameters params rollout:view
		(
			intensity type:#float default:1500 ui:intensitySpn
			temp type:#float default:6500 ui:tempSpn
			
		)
		 
		rollout view "CompLoc Component"
		(
			spinner intensitySpn "Intensity" type:#float range:[0,9999999999,1500]
			spinner tempSpn "Temperature" type:#float range:[1000,20000,6500]
			
			fn SetLightsProps prop arg = 
			(
				obj = GetNode()
				for c in obj.children do 
				(
					case prop of 
					(
						#intensity: c.intensity = arg
						#temperature: c.kelvin = arg
					)
				)
			)
			
			on intensitySpn changed val do SetLightsProps #intensity val
			on tempSpn changed val do SetLightsProps #temperature val
			
			
		) -- End rollout
	)
	
	
	fn CreateScene = 
	(
		myDummy = dummy()
		for i = 1 to 3 do 
		(
			l = Free_Light useKelvin: true kelvin:6500
			l.parent = myDummy
			l.pos.x = 10 * i
		)
		
		custAttributes.add myDummy LightsMasterCA
	)
	
	
	CreateScene()
	
)