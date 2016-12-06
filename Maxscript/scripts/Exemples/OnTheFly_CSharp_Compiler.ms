(
-- 	val = dotNetClass "System.Nullable`1[System.Boolean]"
	fn getMaxValue = 
	(
		source = ""
		source += "using System;\n"
		source += "public class MaxValue\n"
		source += "{\n"
		source += "	public string GetValue(Object input) { return ((input == null) ? \"undefined\" : input.ToString()); }\n"
		source += "	public string GetType(Object input) { return ((input == null) ? \"null\" : (input.GetType()).Name); }\n"
		source += "}\n"

		-- Compile on fly
		csharpProvider = dotnetobject "Microsoft.CSharp.CSharpCodeProvider"
		compilerParams = dotnetobject "System.CodeDom.Compiler.CompilerParameters"
		compilerParams.ReferencedAssemblies.Add "System.dll"

		compilerParams.GenerateInMemory = on
		compilerResults = csharpProvider.CompileAssemblyFromSource compilerParams #(source)

		compilerResults.CompiledAssembly.CreateInstance "MaxValue"
	)
	maxValue = getMaxValue()

-- 	maxValue.GetValue undefined
-- 	maxValue.GetType undefined

-- 	maxValue.GetValue ""
-- 	maxValue.GetType ""

-- 	maxValue.GetValue (dotnetclass "System.Drawing.Color").Red
	maxValue.GetType (dotnetclass "System.Drawing.Color").Red
	
)