global _cplc
if doesFileExist "$userscripts\SugzTools\Scripts\CompLoc_Component.ms" then 
(
	include "$userscripts\SugzTools\Scripts\CompLoc_Component_17.ms"
	_cplc.CreateView()
	clearListener()
)

