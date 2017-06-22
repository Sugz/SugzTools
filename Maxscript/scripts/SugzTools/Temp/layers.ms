(
	layer = layermanager.newLayerFromName (getFilenameFile MaxFileName)
	comp = layermanager.newLayerFromName "Composants"
	comp.SetParent layer
	stc = layermanager.newLayerFromName "Structure"
	stc.SetParent layer
)