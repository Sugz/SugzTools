/*##############################################################################
SugzTools WPF Library
Version 0.01
Script By Clément "Sugz" Plantec
plantec.clement@gmail.com

# Script infos:
Functions to easily create wpf user interface 

# Required Components:

# Sources:

# To do list:
- create a richtextbox class to add the text property

# History:

*Use / Modify this script at your own risk !
###############################################################################*/



-- Assemblies
dotnet.loadAssembly "$userscripts\SugzTools\Assemblies\SugzControls.dll"

struct WpfStruct
(
	/* Classes ############################################################################################*/
	_dock = dotNetClass "System.Windows.Controls.Dock",
	_color = dotNetClass "System.Windows.Media.Color",
	
	
	
	/* Return a color ############################################################################################*/
	fn GetColorPresets clr = 
	(
		/*<Function>
		Description:
			Return a color
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		case clr of 
		(
			#red: return _color.FromArgb 255 255 0 0
			#green: return  _color.FromArgb 255 0 255 0
			#blue: return  _color.FromArgb 255 0 0 255
			#black: return _color.FromArgb 255 0 0 0
			#text: return _color.FromArgb 255 225 225 225
			#grey: return _color.FromArgb 255 128 128 128
			#maxBackground: return  _color.FromArgb 255 68 68 68
			#editBackground: return  _color.FromArgb 255 86 86 86
		)
	),
	
	
	
	/* Return a SolidColorBrush with a color ############################################################################################*/
	fn GetSolidColorBrush clr = 
	(
		/*<Function>
		Description:
			Return a SolidColorBrush with a color
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		if (classOf clr != dotNetObject) then clr = GetColorPresets clr
		return (dotNetObject "System.Windows.Media.SolidColorBrush" clr)
	),
	
	
	
	/* Enum to return the window style ############################################################################################*/
	fn GetWindowStyle style = 
	(
		/*<Function>
		Description:
			Enum to return the window style
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_style = dotNetClass "System.Windows.WindowStyle"
		case style of 
		(
			#none: return _style.none
			#toolWindow: return _style.toolWindow
			#singleBorderWindow: return _style.SingleBorderWindow
			#threeDBorderWindow: return _style.ThreeDBorderWindow
		)
	),
	
	
	
	/* Enum to return the window location ############################################################################################*/
	fn GetWindowLocation location = 
	(
		/*<Function>
		Description:
			Enum to return the window location
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		_location = dotNetClass "System.Windows.WindowStartupLocation"
		case location of
		(
			#centerOwner: return _location.CenterOwner
			#centerScreen: return _location.CenterScreen
			#manual: return _location.Manual
		)
	),
	
	
	
	/* Return a wpf thickness from an integer array ############################################################################################*/
	fn GetThickness thickness = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		return (dotnetObject "System.Windows.Thickness" thickness[1] thickness[2] thickness[3] thickness[4])
	),
	
	
	
	/* Return a Window ############################################################################################*/
	fn GetWindow 
		width: 300 
		height: 300 
		title: undefined 
		background: undefined 
		windowStyle: undefined 
		location: #centerScreen =
	(
		/*<Function>
		Description:
			Return a Window
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		-- Define the window
		wnd = dotNetObject "SugzControls.SugzWindow"
		wnd.width = width
		wnd.height = height
		wnd.WindowStartupLocation =  GetWindowLocation location
		if background != undefined then wnd.background = GetSolidColorBrush background
		if title != undefined then wnd.title = title
		if windowStyle != undefined then wnd.windowStyle = GetWindowStyle windowStyle
		
-- 		wnd.Show()
		
		wnd
	),
	
	
	
	/* Return a DockPanel ############################################################################################*/
	fn GetDockPanel 
		width: undefined 
		height: undefined 
		background: undefined 
		children: undefined 
		lastChildFill: true = 
	(
		/*<Function>
		Description:
			Return a DockPanel 
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		dockPnl = dotNetObject "System.Windows.Controls.DockPanel"
		if width != undefined then dockPnl.width = width
		if height  != undefined then dockPnl.height = height
		if background != undefined then dockPnl.background = GetSolidColorBrush background
		dockPnl.LastChildFill = LastChildFill
		if children != undefined then for child in children do 
		(
			dockPnl.Children.Add(child)
		)
		
		dockPnl
	),
	
	
	
	/* Return a StackPanel ############################################################################################*/
	fn GetStackPanel 
		width: undefined 
		height: undefined 
		background: undefined 
		children: undefined = 
	(
		/*<Function>
		Description:
			Return a StackPanel
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		stackPnl = dotNetObject "System.Windows.Controls.StackPanel"
		if width != undefined then stackPnl.width = width
		if height  != undefined then stackPnl.height = height
		if background != undefined then stackPnl.background = GetSolidColorBrush background
		if children != undefined then for child in children do 
		(
			stackPnl.Children.Add(child)
		)
		
		stackPnl
	),
	
	
	
	/* Return a Button ############################################################################################*/
	fn GetButton
		text:"SugzButton" 
		width:undefined 
		height:undefined 
		background:undefined 
		overbrush:undefined 
		pressedbrush:undefined 
		cornerRadius:0 
		borderbrush:undefined 
		borderThickness:undefined 
		margin:undefined = 
		(
			
			/*<Function>
			Description:
				Return a Button
			Arguments:
			Return:
			Further Infos:
			</Function>*/
			
			btn = dotNetObject "SugzControls.SugzButton"
			if width != undefined then btn.width = width
			if height  != undefined then btn.height = height
			if background != undefined then btn.background = GetSolidColorBrush background
			if overbrush != undefined then btn.overbrush = GetSolidColorBrush overbrush
			if pressedbrush != undefined then btn.pressedbrush = GetSolidColorBrush pressedbrush
			btn.cornerRadius = cornerRadius	
			if borderbrush != undefined then btn.borderBrush = GetSolidColorBrush borderbrush
			if borderThickness != undefined then btn.borderThickness = GetThickness borderThickness
			if margin != undefined then btn.margin = GetThickness margin
			btn.Content = text
			
			btn
		),
		
		
		
	/* Return a Treeview ############################################################################################*/
	fn GetTreeView 
		width:undefined 
		height:undefined 
		background:#editBackground 
		borderbrush:#black 
		borderThickness:#(1,1,1,1)
		margin:#(0,0,0,0) = 
	(
		/*<Function>
		Description:
			Return a Treeview
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		tv = dotNetObject "System.Windows.Controls.TreeView"
		if width != undefined then tv.width = width
		if height  != undefined then tv.height = height
		tv.background = GetSolidColorBrush background
		tv.borderBrush = GetSolidColorBrush borderbrush
		tv.borderThickness = GetThickness borderThickness
		tv.margin = GetThickness margin
			
		tv
	),
	
	
	
	/* Set the text for a RichTextBox ############################################################################################*/
	fn SetText txt str = 
	(
		/*<Function>
		Description:
			Set the text for a RichTextBox
		Arguments:
			<Control>txt: the RichTextBox to add text to
			<String> str: the text to put in the textbox
		Return:
		Further Infos:
		</Function>*/
		
		run = dotNetObject "System.Windows.Documents.Run" str
		paragraph = dotNetObject "System.Windows.Documents.Paragraph" run
		doc = dotNetObject "System.Windows.Documents.FlowDocument" paragraph
		
        txt.Document = doc
	),
	
	
	
	/* Return a RichTextBox ############################################################################################*/
	fn GetRichTextBox 
		width: undefined 
		height: undefined 
		background: #editBackground 
		foreground: #text
		borderbrush: #black 
		borderThickness: #(1,1,1,1)
		margin: #(0,0,0,0) 
		readOnly: false = 
	(
		/*<Function>
		Description:
			Return a RichTextBox
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		txt = dotNetObject "System.Windows.Controls.RichTextBox"
		if width != undefined then txt.width = width
		if height  != undefined then txt.height = height
		txt.background = GetSolidColorBrush background
		txt.foreground = GetSolidColorBrush foreground
		txt.borderBrush = GetSolidColorBrush borderbrush
		txt.borderThickness = GetThickness borderThickness
		txt.margin = GetThickness margin
		txt.IsReadOnly = readOnly
		
		txt
	)
	
	
	
)

global _wpf = WpfStruct()