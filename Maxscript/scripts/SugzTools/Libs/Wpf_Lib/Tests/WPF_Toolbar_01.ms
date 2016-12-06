fn CreateAssembly src=
(
    /*
        code compilation based on an example from Kim David Hauser
        http://www.codeproject.com/KB/cs/evalcscode.aspx
    */
    csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
    compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
	compilerParams.ReferencedAssemblies.Add "System.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationFramework.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\System.Xaml.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files\Autodesk\3ds Max 2016\bin\assemblies\SugzTools.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files\Autodesk\3ds Max 2016\UiViewModels.dll"
	
	compilerParams.OutputAssembly = @"C:\Program Files\Autodesk\3ds Max 2016\bin\assemblies\test.dll"
--     compilerParams.GenerateInMemory = true
    compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(src)
    
    if (compilerResults.Errors.Count > 0 ) then
    (
        errs = stringstream ""
        for i = 0 to (compilerResults.Errors.Count-1) do
        (
            err = compilerResults.Errors.Item[i]
            format "Error:% Line:% Column:% %\n" err.ErrorNumber err.Line err.Column err.ErrorText to:errs 
        )
        MessageBox (errs as string) title: "Errors encountered while compiling C# code"
        return undefined
    )
    
    a = compilerResults.CompiledAssembly
)

fn getToolbar = 
(
	source = "using SugzTools.Controls; \n"
	source += "using System; \n"
	source += "using UiViewModels.Actions; \n"
	source += "public class MaxToolBar : CuiDockableContentAdapter \n"
	source += "{ \n"
	source += "	private SgzToolBar _View = new SgzToolBar(); \n"
	source += "	private string _ActionText = \"Test\"; \n"
	source += "	public override string Category { get { return \"SugzTools\"; } } \n"
	source += "	public override string WindowTitle { get { return _ActionText; } } \n"
	source += "	public override string ActionText { get { return _ActionText; } } \n"
	source += "	public override Type ContentType { get { return typeof(SgzToolBar); } } \n"
	source += "	public override DockStates.Dock DockingModes { get { return DockStates.Dock.Left | DockStates.Dock.Right | DockStates.Dock.Floating; } } \n"
	source += "	public override bool IsMainContent { get { return true; } } \n"
	source += "	public override object CreateDockableContent() { return _View; } \n"
	source += "	public override void SetContentDockMode(object dockableContent, DockStates.Dock dockMode) \n"
	source += "	{ \n"
	source += "		base.SetContentDockMode(dockableContent, dockMode); \n"
	source += "		_View.SetResizers(dockMode); \n"
	source += "	} \n"
	source += "} \n"

	a = CreateAssembly source
	a.CreateInstance "MaxToolBar" 
)


toolbar = getToolbar()
toolbar.CreateDockableContent()