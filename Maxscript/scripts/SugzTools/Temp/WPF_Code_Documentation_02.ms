if doesFileExist "$userscripts\SugzTools\Libs\Wpf_Lib\Wpf_Lib_09.ms" do include "$userscripts\SugzTools\Libs\Wpf_Lib\Wpf_Lib_09.ms"

global CodeDocView

(
	
	fn GetHelp s e = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
-- 		format "tag: %\n" s.tag
		uri = case s.tag of
		(
			"array": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_A5B54C67_BFDD_45C0_9D6B_E6869817282A_htm"
			"string": "http://help.autodesk.com/view/3DSMAX/2016/ENU//?guid=__files_GUID_A6A60FC7_6206_4FFC_80E2_0EF8544BE2C4_htm"
			"number": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_B57EA575_DCDE_42F5_9D30_88E3EB41F350_htm"
			"name": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_19058A42_F710_48A4_8F8B_A52597748EAA_htm"
			"bool": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BCAFBD54_CE0D_40D0_8424_99E1FE1518CC_htm"
			"stringstream": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_DB8A8E34_179F_4264_86E3_D0CD9AB836A6_htm"
			"filestream": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BB041082_3EEF_4576_9D69_5B258A59065E_htm"
			"node": "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_AB920CA1_5DC2_44F5_9B3C_2B6D5047AC8A_htm"
			
		)
		
		(dotNetObject "System.Diagnostics.Process").Start uri
	)
	
	
	/* Get a hyperlink ############################################################################################*/
	fn GetHyperlink str = 
	(
		/*<Function>
		Description:
			Get a hyperlink
		Arguments:
			<String> str: the type of variable to redirect to the correct help
		Return:
			<dotNetObject> hyperl: the hyperlink
		Further Infos:
		</Function>*/
		
		hyperLinks = #("array", "string", "name", "bool", "stringstream", "filestream", "node")
		numbers = #("integer", "float", "double", "integer64", "integerptr")
		hyperl = undefined
		
		format "the arr: %\nthe str: %\n" (join hyperLinks numbers) str
		for hl in (join hyperLinks numbers) do if toLower str == hl then 
		(
			run = dotNetObject "System.Windows.Documents.Run" str
			run.foreground = _wpf.GetSolidColorBrush (_wpf._color.FromArgb 255 84 181 111)
			
			hyperl  = dotNetObject "System.Windows.Documents.Hyperlink" run
			hyperl.Cursor = (dotnetclass "System.Windows.Input.Cursors").Hand
			
			isNumber = false
			for n in numbers while not isNumber do if toLower str == n then 
			(
				hyperl.tag = "number" 
				isNumber = true
			)
			else hyperl.tag = toLower str
			
			dotnet.addeventhandler hyperl "MouseDown" GetHelp
		)
		
		hyperl
	)
	
	
	
	fn ParseDescription str = 
	(
		paragraph = dotNetObject "System.Windows.Documents.Paragraph"
		
		for s in (filterString str "<> ") do 
		(
			-- Check for optional argument name
			if matchPattern s pattern:"*:*" then
			(
				-- Get what precede the ":"
				s = filterString s ":"
				run = dotNetObject "System.Windows.Documents.Run" (s[1] + ":")
				run.foreground = _wpf.GetSolidColorBrush #grey
				run.FontStyle = (dotnetclass "System.Windows.FontStyles").Italic
				paragraph.inlines.Add run
				
				-- Get what is after the ":"
				if s.count > 1 then paragraph.inlines.Add(run = dotNetObject "System.Windows.Documents.Run" s[2])
			)

			-- Check for hyperLink
			else if GetHyperlink s != undefined then paragraph.inlines.Add (GetHyperlink s)
			
			-- Normal text
			else paragraph.inlines.Add(run = dotNetObject "System.Windows.Documents.Run" s)
			
			paragraph.inlines.Add(run = dotNetObject "System.Windows.Documents.Run" " ")
		)			
		
		-- Set the flow document
		flowDoc = dotNetObject "System.Windows.Documents.FlowDocument" paragraph
		flowDoc.FontFamily = dotNetObject "System.Windows.Media.FontFamily" "Arial"
		
		flowDoc
	)
	
	
	
	/* Initialise the look of the window ***************************************************************************************************************************************************************/
	fn SetWindow wnd = 
	(
		CodeDocView = _wpf.GetWindow width:640 height:380 title:"SugzTools Code Documentation" windowStyle:#singleBorderWindow
		tv = _wpf.GetTreeView width:190 borderThickness:#(0,0,0,0) margin:#(5,5,5,5)
		txt = _wpf.GetRichTextBox background:#maxBackground borderThickness:#(0,0,0,0) margin:#(5,5,5,5) readOnly: true
		
		pnl = _wpf.GetDockPanel width:620 height:340 children:#(tv, txt)
		pnl.SetDock tv _wpf._dock.Left
		
		CodeDocView.content = pnl
		
		str = "<Array <Name><Integer>> this:is a test"
		txt.Document = ParseDescription str


	)
	
	
	fn Run =
	(
		try(CodeDocView.Close()) catch()
		clearListener()
		SetWindow CodeDocView
	)
	
	Run()
	
)