using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.CodeDom.Compiler;
using System.CodeDom;
using System.Reflection;
using System.IO;
using Microsoft.CSharp;

namespace SugzTools.Src
{
    public class ClassGenerator
    {

        /// <summary>
        /// Define the compile unit to use for code generation. 
        /// </summary>
        private CodeCompileUnit targetUnit;

        /// <summary>
        /// The only class in the compile unit. This class contains 2 fields,
        /// 3 properties, a constructor, an entry point, and 1 simple method. 
        /// </summary>
        private CodeTypeDeclaration targetClass;

        private string ClassName;
        private const string outputFileName = @"d:\SampleCode.cs";
        private const string namespaceName = "SugzTools";

        public ClassGenerator(string className)
        {
            ClassName = className;
            targetClass = new CodeTypeDeclaration(ClassName)
            {
                IsClass = true,
                TypeAttributes = TypeAttributes.Public
            };

            CodeNamespace nameSpace = new CodeNamespace(namespaceName);
            nameSpace.Imports.Add(new CodeNamespaceImport("System"));
            nameSpace.Types.Add(targetClass);

            targetUnit = new CodeCompileUnit();
            targetUnit.Namespaces.Add(nameSpace);
        }



        public void AddProperties(Type type, string name, bool readOnly)
        {
            StringBuilder text = new StringBuilder();
            if (readOnly)
                text.AppendLine($"public event EventHandler {name}Changed;");

            text.AppendLine($"private {type} _{name};");
            text.AppendLine($"public {type} {name} \n{{");
            text.AppendLine($"\tget {{ return _{name}; }}");
            
            if (readOnly)
            {
                text.AppendLine($"\tset\n\t{{");
                text.AppendLine($"\t\t_{name} = value;");
                text.AppendLine($"\t\tif ({name}Changed != null)");
                text.AppendLine($"\t\t\t{name}Changed(this, new EventArgs());\n\t}}\n}}");
            }
            else
                text.AppendLine($"\tset {{ _{name} = value; }}\n}}");

            targetClass.Members.Add(new CodeSnippetTypeMember() { Text = text.ToString() });
        }



        /// <summary>
        /// Generate CSharp source code from the compile unit.
        /// </summary>
        /// <param name="filename">Output file name</param>
        public object GenerateCSharpCode(string fileName = outputFileName)
        {
            CodeDomProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters()
            {
                GenerateExecutable = false,
                GenerateInMemory = true,
                IncludeDebugInformation = true,
            };

            using (StreamWriter streamWriter = new StreamWriter(outputFileName))
                provider.GenerateCodeFromCompileUnit(targetUnit, streamWriter, new CodeGeneratorOptions());


            CompilerResults compiler = provider.CompileAssemblyFromDom(parameters, targetUnit);
            if (compiler.Errors.HasErrors)
            {
                compiler.Errors.ForEach(x => Console.WriteLine(x));
                return null;
            }

            object myClass = compiler.CompiledAssembly.CreateInstance($"{namespaceName}.{ClassName}");
            return myClass;
        }

    }
}
