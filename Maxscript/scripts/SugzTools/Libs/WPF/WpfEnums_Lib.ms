struct WpfEnumStruct
(
	-- WinForm Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_formBorderStyle = dotNetClass "FormBorderStyle",
	_formStartPosition = dotNetClass "FormStartPosition",


	-- NET Classes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_enum = dotNetClass "System.Enum",
	_cursors = dotNetClass "System.Windows.Input.Cursors",
	_fontStretches = dotNetClass "System.Windows.FontStretches",
	_fontStyles = dotNetClass "System.Windows.FontStyles",
	_fontWeights = dotNetClass "System.Windows.FontWeights",


	-- WPF Enums ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_horizontalAlignment = dotNetClass "System.Windows.HorizontalAlignment",
	_gridUnitType = dotNetClass "System.Windows.GridUnitType",
	_orientation = dotNetClass "System.Windows.Controls.Orientation",
	_stretch = dotNetClass "System.Windows.Media.Stretch",
	_verticalAlignment = dotNetClass "System.Windows.VerticalAlignment",
	_visibility = dotNetClass "System.Windows.Visibility",


	-- SugzTools Enums ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	_numericFormatSpecifier = dotNetClass "SugzTools.Src.NumericFormatSpecifier",
	_numericUpDownLimits = dotNetClass "SugzTools.Src.NumericUpDownLimits",
	_numericUpDownType = dotNetClass "SugzTools.Src.NumericUpDownType",
	_radioButtonTypes = dotNetClass "SugzTools.Src.RadioButtonTypes",
	_side = dotNetClass "SugzTools.Src.Side",



	-- Return a System.Windows.Forms.FormBorderStyle ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FormBorderStyle arg = 
	(
		/*<Function>
		Description:
			Enum to return the FormBorderStyle
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#Fixed3D: return _formBorderStyle.Fixed3D
			#FixedDialog: return _formBorderStyle.FixedDialog
			#FixedSingle: return _formBorderStyle.FixedSingle
			#FixedToolWindow: return _formBorderStyle.FixedToolWindow
			#None: return _formBorderStyle.None
			#Sizable: return _formBorderStyle.Sizable
			#SizableToolWindow: return _formBorderStyle.SizableToolWindow
		)
	),
	
	
	-- Return a System.Windows.WindowStartupLocation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FormStartPosition arg = 
	(
		/*<Function>
		Description:
			Enum to return the window location
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of
		(
			#CenterParent: return _formStartPosition.CenterParent
			#CenterScreen: return _formStartPosition.CenterScreen
			#Manual: return _formStartPosition.Manual
			#WindowsDefaultBounds: return _formStartPosition.WindowsDefaultBounds
			#WindowsDefaultLocation: return _formStartPosition.WindowsDefaultLocation
		)
	),


	-- Return a System.Windows.Input.Cursors ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Cursors arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#AppStarting: return _cursors.AppStarting
			#Arrow: return _cursors.Arrow
			#ArrowCD: return _cursors.ArrowCD
			#Cross: return _cursors.Cross
			#Hand: return _cursors.Hand
			#Help: return _cursors.Help
			#IBeam: return _cursors.IBeam
			#No: return _cursors.No
			#None: return _cursors.None
			#Pen: return _cursors.Pen
			#ScrollAll: return _cursors.ScrollAll
			#ScrollE: return _cursors.ScrollE
			#ScrollN: return _cursors.ScrollN
			#ScrollNE: return _cursors.ScrollNE
			#ScrollNS: return _cursors.ScrollNS
			#ScrollNW: return _cursors.ScrollNW
			#ScrollS: return _cursors.ScrollS
			#ScrollSE: return _cursors.ScrollSE
			#ScrollSW: return _cursors.ScrollSW
			#ScrollW	: return _cursors.ScrollW
			#ScrollWE: return _cursors.ScrollWE
			#SizeAll: return _cursors.SizeAll
			#SizeNESW: return _cursors.SizeNESW
			#SizeNS: return _cursors.SizeNS
			#SizeNWSE: return _cursors.SizeNWSE
			#SizeWE: return _cursors.SizeWE
			#UpArrow: return _cursors.UpArrow
			#Wait: return _cursors.Wait
		)
	),


	-- Return a System.Windows.FontStretches ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FontStretches arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Condensed: return _fontStretches.Condensed
			#Expanded: return _fontStretches.Expanded
			#ExtraCondensed: return _fontStretches.ExtraCondensed
			#ExtraExpanded: return _fontStretches.ExtraExpanded
			#Medium: return _fontStretches.Medium
			#Normal: return _fontStretches.Normal
			#SemiCondensed: return _fontStretches.SemiCondensed
			#SemiExpanded: return _fontStretches.SemiExpanded
			#UltraCondensed: return _fontStretches.UltraCondensed
			#UltraExpanded: return _fontStretches.UltraExpanded
		)
	),


	-- Return a System.Windows.FontStyles ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FontStyles arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			
			#Italic: return _fontStyles.Italic
			#Normal: return _fontStyles.Normal
			#Oblique: return _fontStyles.Oblique
		)
	),


	-- Return a System.Windows.FontWeights ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn FontWeights arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Black: return _fontWeights.Black
			#Bold: return _fontWeights.Bold
			#DemiBold: return _fontWeights.DemiBold
			#ExtraBlack: return _fontWeights.ExtraBlack
			#ExtraBold: return _fontWeights.ExtraBold
			#ExtraLight: return _fontWeights.ExtraLight
			#Heavy: return _fontWeights.Heavy
			#Light: return _fontWeights.Light
			#Medium: return _fontWeights.Medium
			#Normal: return _fontWeights.Normal
			#Regular: return _fontWeights.Regular
			#SemiBold: return _fontWeights.SemiBold
			#Thin: return _fontWeights.Thin
			#UltraBlack: return _fontWeights.UltraBlack
			#UltraBold: return _fontWeights.UltraBold
			#UltraLight: return _fontWeights.UltraLight
		)
	),


	-- Return a System.Windows.Controls.Dock ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Dock arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Bottom: return _dock.Bottom
			#Left: return _dock.Left
			#Right: return _dock.Right
			#Top: return _dock.Top
		)
	),


	-- Return a System.Windows.HorizontalAlignment ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn HorizontalAlignment arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of
		(
			#Left: return _horizontalAlignment.Left
			#Center: return _horizontalAlignment.Center
			#Right: return _horizontalAlignment.Right
			#Stretch: return _horizontalAlignment.Stretch
		)
	),


	-- Return a System.Windows.GridUnitType  ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn GridUnitType arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Auto: return _gridUnitType.Auto
			#Pixel: return _gridUnitType.Pixel
			#Star: return _gridUnitType.Star
		)
	),
	

	-- Return a System.Windows.Controls.Orientation ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Orientation arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case orientation of
		(
			#Horizontal: return _orientation.Horizontal
			#Vertical: return _orientation.Vertical
		)
	),
	
	
	-- Return a System.Windows.Media.Stretch ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Stretch arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Fill: return _stretch.Fill
			#None: return _stretch.None
			#Uniform: return _stretch.Uniform
			#UniformToFill: return _stretch.UniformToFill
		)
	),


	-- Return a System.Windows.HorizontalAlignment ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn VerticalAlignment arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of
		(
			#Top: return _verticalAlignment.Top
			#Center: return _verticalAlignment.Center
			#Bottom: return _verticalAlignment.Bottom
			#Stretch: return _verticalAlignment.Stretch
		)
	),


	-- Return a System.Windows.Visibility ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Visibility arg = 
	(
	   /*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of
		(
			#Collapsed: return _visibility.Collapsed
			#Hidden: return _visibility.Hidden
			#Visible: return _visibility.Visible
		)
	),
	
	
	-- SugzTools.Src.NumericFormatSpecifier ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericFormatSpecifier arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#F: return _numericFormatSpecifier.F
			#N: return _numericFormatSpecifier.N
		)
	),
	
	
	-- SugzTools.Src.NumericUpDownLimits ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericUpDownLimits arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#Int: return _numericUpDownLimits.Int
			#Long: return _numericUpDownLimits.Long
			#Float: return _numericUpDownLimits.Float
			#Double: return _numericUpDownLimits.Double
		)
	),


	-- SugzTools.Src.NumericUpDownType ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn NumericUpDownType arg =
	(
		/*<Function>
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case arg of 
		(
			#Integer: return _numericUpDownType.Integer
			#Float: return _numericUpDownType.Float
			#WorldUnits: return _numericUpDownType.WorldUnits
		)
	),


	-- Return a SugzTools.Src.RadioButtonTypes ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn RadioButtonTypes arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Standard: return _radioButtonTypes.Standard
			#CheckButton: return _radioButtonTypes.CheckButton
		)
	),


	-- Return a SugzTools.Src.Side ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	fn Side arg =
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Infos:
		</Function>*/
		
		case arg of 
		(
			#Left: return _side.Left
			#Right: return _side.Right
		)
	)

)