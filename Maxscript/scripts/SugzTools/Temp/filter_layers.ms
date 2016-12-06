(
	keepLayers = #()
	unKeepLayers = #()
	filters = #("*components*", "*structure*", "*hotspots*")
	for i = 0 to layerManager.count-1 do
	(
		layer = layerManager.getLayer i
		
		find = false
		for str in filters while not find do 
		(
			if MatchPattern (toLower(layer.name)) pattern:str then 
			(
				append keepLayers layer
				find = true
			)
		)
		
		if findItem keepLayers layer == 0 then append unKeepLayers layer
	)
	

	for layer in unKeepLayers do 
	(
		layer.nodes &theNodes
		delete theNodes
	)
	for layer in unKeepLayers do LayerManager.deleteLayerByName layer.name
)