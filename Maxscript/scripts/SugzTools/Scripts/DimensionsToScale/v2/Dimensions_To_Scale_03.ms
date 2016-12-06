global dim, _wpf
struct dimStc
(
	-- Store object size to calculate the delta size
	_xSize = 0,
	_ySize = 0,
	_zSize = 0,
	
	-- WPF Controls ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_objectNameTxt, _xSpn, _ySpn, _zSpn, _resetScaleBtn, _applyBtn, _expander, _form,
	
	
	fn SetSelectionScale s e = 
	(
		$.scale.x *= dim._xSpn.value / dim._xSize
		$.scale.y *= dim._ySpn.value / dim._ySize
		$.scale.z *= dim._zSpn.value / dim._zSize
		
		dim.GetSelectionDimensions()
	),
	
	
	fn ResetSelectionScale s e =
	(
		ResetScale $
		dim.GetSelectionDimensions()
	),
	
	
	fn RemoveCB = 
	(
		callbacks.removeScripts #selectionSetChanged id:#GetDimensionsCB
	),
	
	
	fn GetUI = 
	(
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(_objectNameTxt = _wpf.TextBlock text:"No object selected" align:#left)
		panel.Add(_xSpn = _wpf.Spinner text:"X :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits)
		panel.Add(_ySpn = _wpf.Spinner text:"Y :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits)
		panel.Add(_zSpn = _wpf.Spinner text:"Z :" height:18 margin:#(2,0,0,0) fieldWidth:100 type:#worldunits)
		panel.Add(grid = _wpf.Grid())
		grid.Add(_resetScaleBtn = _wpf.Button text:"Reset Scale" margin:#(0,0,1,0) click:ResetSelectionScale) 0 0
		grid.Add(_applyBtn = _wpf.Button text:"Apply" margin:#(1,0,0,0) click:SetSelectionScale) 1 0
		_expander =_wpf.Expander header:"Dimensions" content:panel
			
		_expander
	),

	
	fn GetSelectionDimensions = 
	(
		print "working...."
		
		-- active UI only if user selected one object
		if selection.count == 1 then 
		(
			bb = nodeGetBoundingBox $ $.transform
			_dim = bb[2] - bb[1]
			
			_objectNameTxt.text = $.name + " :"
			_xSize = _xSpn.value = _dim[1] * $.scale.x
			_xSpn.Content = "X (" + ($.scale.x * 100) as string + " %) : "
			_ySize = _ySpn.value = _dim[2] * $.scale.y
			_ySpn.Content = "Y (" + ($.scale.y * 100) as string + " %) : "
			_zSize = _zSpn.value = _dim[3] * $.scale.z
			_zSpn.Content = "Z (" + ($.scale.z * 100) as string + " %) : "
			_resetScaleBtn.IsEnabled = _applyBtn.IsEnabled = true
		)
		
		-- deactivate UI if user selected 0 or more than 1 object
		else
		(
			_objectNameTxt.text = "No object selected"
			_xSpn.Content = "X : "
			_ySpn.Content = "Y : "
			_zSpn.Content = "Z : "
			_xSpn.Indeterminate = _ySpn.Indeterminate = _zSpn.Indeterminate = true
			_resetScaleBtn.IsEnabled = _applyBtn.IsEnabled = false
		)
		
	),
	
	
	fn Run = 
	(
		GetSelectionDimensions()
		callbacks.addScript #selectionSetChanged "dim.GetSelectionDimensions()" id:#GetDimensionsCB
	),
	
	
	fn CreateForm = 
	(
		if doesFileExist (file = "$userscripts\SugzTools\Libs\Wpf_Lib.ms") then fileIn file 
		panel = _wpf.StackPanel margin:#(5,5,5,0)
		panel.Add(GetUI())
			
		if _form != undefined then _form.Close()
		_form = _wpf.Window content:panel title:"Dimensions" width:217 height:500 location:#centerParent closed:RemoveCB()
		_form.ShowInFrame()
			
		Run()
	)
	
)
dim = dimStc()
-- dim.CreateForm()




