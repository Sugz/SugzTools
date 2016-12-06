if doesFileExist "$userscripts\SugzTools\Libs\Wpf_Lib\Wpf_Lib_09.ms" do include "$userscripts\SugzTools\Libs\Wpf_Lib\Wpf_Lib_09.ms"

global CodeDocView

(
	
	fn GetArrayValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_A5B54C67_BFDD_45C0_9D6B_E6869817282A_htm"
	)
	
	fn GetStringValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU//?guid=__files_GUID_A6A60FC7_6206_4FFC_80E2_0EF8544BE2C4_htm"
	)
	
	fn GetNumberValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_B57EA575_DCDE_42F5_9D30_88E3EB41F350_htm"
	)
	
	fn GetNameValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_19058A42_F710_48A4_8F8B_A52597748EAA_htm"
	)
	
	fn GetBoolValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BCAFBD54_CE0D_40D0_8424_99E1FE1518CC_htm"
	)
	
	fn GetStringStreamValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_DB8A8E34_179F_4264_86E3_D0CD9AB836A6_htm"
	)
	
	fn GetFileStreamValues s e = 
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_BB041082_3EEF_4576_9D69_5B258A59065E_htm"
	)
	
	fn GetNode s e =
	(
		(dotNetObject "System.Diagnostics.Process").Start "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_AB920CA1_5DC2_44F5_9B3C_2B6D5047AC8A_htm"
	)
	
	
	
	
	
	/* Create a hyperlink to the maxscript help ############################################################################################*/
	fn CreateHyperlink type = 
	(
		/*<Function>
		Description:
		Arguments:
		Return:
		Further Infos:
		</Function>*/
		
		
		
	)
	
	
	
	fn ParseDescription str = 
	(
		clearListener()
		
		result = filterString str " "
		for str in result do 
		(
			str = trimLeft str "<"
			str = trimRight str ">"
		)
		
		result
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
		
		
		str = "<Array <Name>> this is a test"
		ParseDescription str
		
		-- Set a hyperlink
/* 		strings = #("Array", "String", "Number", "Name", "Boolean", "StringStream", "FileStream", "Node")
* 		run1 = dotNetObject "System.Windows.Documents.Run" strings[1]
* 		run1.foreground = _wpf.GetSolidColorBrush #red
* 		
* 		hyperl  = dotNetObject "System.Windows.Documents.Hyperlink" run1
* 		hyperl.Cursor = (dotnetclass "System.Windows.Input.Cursors").Hand
* 		dotnet.addeventhandler hyperl "MouseDown" GetArrayValues
* 		
* 		paragraph = dotNetObject "System.Windows.Documents.Paragraph" hyperl 
* 		doc = dotNetObject "System.Windows.Documents.FlowDocument" paragraph
* 		
* 		txt.Document = doc
*/

	)
	
	
	fn Run =
	(
		try(CodeDocView.Close()) catch()
		SetWindow CodeDocView
	)
	
	
	Run()
	
)