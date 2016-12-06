global dim
struct dimStc
(
	_txt,
	_xSpn,
	_ySpn,
	_zSpn,
	_scaleBtn,
	_applyBtn,
				
	
	fn CreateUI = 
	(
		_panel = _wpf.StackPanel margin:#(5,5,5,0) tag:"panel"
		_panel.Add(_txt = _wpf.TextBlock text:"No object selected" align:#left)
		_panel.Add(_xSpn = _wpf.Spinner text:"X :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"x")
		_panel.Add(_ySpn = _wpf.Spinner text:"Y :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"y")
		_panel.Add(_zSpn = _wpf.Spinner text:"Z :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"z")
		_panel.Add(_grid = _wpf.Grid())
		_grid.Add(_scaleBtn = _wpf.Button text:"Reset Scale" margin:#(0,0,1,0) tag:"reset") 0 0
		_grid.Add(_applyBtn = _wpf.Button text:"Apply" margin:#(1,0,0,0) tag:"apply") 1 0
		
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(_expander =_wpf.Expander header:"Dimensions" content:_panel)
			
		_view = _wpf.Window content:panel title:"SugzTools" width:217 height:500 location:#centerParent
		_view.ShowInFrame()
	),
			
	
	fn GetSelectionDimensions = 
	(
		-- active UI only if user selected one object
		if selection.count == 1 then 
		(
			bb = nodeGetBoundingBox $ $.transform
			_dim = bb[2] - bb[1]
			
			_txt.text = $.name + " :"
			_xSpn.value = _dim[1] * $.scale.x
			_xSpn.Content = "X (" + ($.scale.x * 100) as string + " %) : "
			_ySpn.value = _dim[2] * $.scale.y
			_ySpn.Content = "Y (" + ($.scale.y * 100) as string + " %) : "
			_zSpn.value = _dim[3] * $.scale.z
			_zSpn.Content = "Z (" + ($.scale.z * 100) as string + " %) : "
			_scaleBtn.IsEnabled = _applyBtn.IsEnabled = true
		)
		
		-- deactivate UI if user selected 0 or more than 1 object
		else
		(
			_txt.text = "No object selected"
			_xSpn.Content = "X : "
			_ySpn.Content = "Y : "
			_zSpn.Content = "Z : "
			_xSpn.Indeterminate = _ySpn.Indeterminate = _zSpn.Indeterminate = true
			_scaleBtn.IsEnabled = _applyBtn.IsEnabled = false
		)
		
	),
	
	
	fn Run = 
	(
		CreateUI()
		GetSelectionDimensions()
		callbacks.addScript #selectionSetChanged "dim.GetSelectionDimensions()" id:#GetDimensionsCB
	),
	

	fn Stop = 
	(
		callbacks.removeScripts #selectionSetChanged id:#GetDimensionsCB
	)
	
)

dim = dimStc()
dim.Run()
-- dim.Stop()

-- fn CreateUI = 
-- (
-- 	_panel = _wpf.StackPanel margin:#(5,5,5,0) tag:"panel"
-- 	_panel.Add(dim._txt = _wpf.TextBlock text:"No object selected" align:#left)
-- 	_panel.Add(dim._xSpn = _wpf.Spinner text:"X :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"x")
-- 	_panel.Add(dim._ySpn = _wpf.Spinner text:"Y :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"y")
-- 	_panel.Add(dim._zSpn = _wpf.Spinner text:"Z :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits name:"z")
-- 	_panel.Add(_grid = _wpf.Grid())
-- 	_grid.Add(dim._scaleBtn = _wpf.Button text:"Reset Scale" margin:#(0,0,1,0) tag:"reset") 0 0
-- 	_grid.Add(dim._applyBtn = _wpf.Button text:"Apply" margin:#(1,0,0,0) tag:"apply") 1 0
-- 	
-- 	panel = _wpf.StackPanel margin:#(5,5,5,0)
-- 	panel.Add(_expander =_wpf.Expander header:"Dimensions" content:_panel)
-- 		
-- 	_view = _wpf.Window content:panel title:"SugzTools" width:217 height:500 location:#centerParent
-- 	_view.ShowInFrame()
-- )


-- CreateUI()
-- dim.GetSelectionDimensions()

