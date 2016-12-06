fn getToolbar = 
(
	source = "using System; \n"
	source += "using System.Windows.Controls; \n"
	source += "using UiViewModels.Actions; \n"
	source += "public class MaxToolBar : CuiDockableContentAdapter \n"
	source += "{ \n"
	source += "	private UserControl _View = new UserControl(); \n"
	source += "	private string _ActionText = \"Test !!!!\"; \n"
	source += "	public override string Category { get { return \"SugzTools\"; } } \n"
	source += "	public override string WindowTitle { get { return _ActionText; } } \n"
	source += "	public override string ActionText { get { return _ActionText; } } \n"
	source += "	public override Type ContentType { get { return typeof(UserControl); } } \n"
	source += "	public override DockStates.Dock DockingModes { get { return DockStates.Dock.Left | DockStates.Dock.Right | DockStates.Dock.Floating; } } \n"
	source += "	public override bool IsMainContent { get { return true; } } \n"
	source += "	public override object CreateDockableContent() { return _View; } \n"
	source += "} \n"

	csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
	compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
	
	compilerParams.ReferencedAssemblies.Add "System.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationFramework.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\PresentationCore.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\WindowsBase.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.6.2\System.Xaml.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files\Autodesk\3ds Max 2016\bin\assemblies\SugzTools.dll"
	compilerParams.ReferencedAssemblies.Add @"C:\Program Files\Autodesk\3ds Max 2016\UiViewModels.dll"

	compilerParams.GenerateInMemory = on
	compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)

	compilerResults.CompiledAssembly.CreateInstance "MaxToolBar"
)


toolbar = getToolbar()
toolbar.CreateDockableContent()