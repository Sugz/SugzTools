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
        CodeCompileUnit targetUnit;

        /// <summary>
        /// The only class in the compile unit. This class contains 2 fields,
        /// 3 properties, a constructor, an entry point, and 1 simple method. 
        /// </summary>
        CodeTypeDeclaration targetClass;

        private const string outputFileName = @"d:\SampleCode.cs";


        public ClassGenerator(string ClassName)
        {
            targetClass = new CodeTypeDeclaration(ClassName)
            {
                IsClass = true,
                TypeAttributes = TypeAttributes.Public
            };

            CodeNamespace nameSpace = new CodeNamespace("SugzTools");
            nameSpace.Imports.Add(new CodeNamespaceImport("System"));
            nameSpace.Types.Add(targetClass);

            targetUnit = new CodeCompileUnit();
            targetUnit.Namespaces.Add(nameSpace);
        }



        public void AddProperties(Type type, string name)
        {
            StringBuilder text = new StringBuilder($"public event EventHandler<EventArgs> {name}Changed;\n");
            text.AppendLine($"private {type} _{name};");
            text.AppendLine($"public {type} {name} \n{{");
            text.AppendLine($"\tget {{ return _{name}; }}");
            text.AppendLine($"\tset\n\t{{");
            text.AppendLine($"\t\t_{name} = value;");
            text.AppendLine($"\t\t{name}Changed?.Invoke(this, new EventArgs());\n\t}}\n}}\n");

            targetClass.Members.Add
            (
                new CodeSnippetTypeMember() { Text = text.ToString() }
            );

        }



        /// <summary>
        /// Generate CSharp source code from the compile unit.
        /// </summary>
        /// <param name="filename">Output file name</param>
        public void GenerateCSharpCode(string fileName = outputFileName)
        {
            CodeDomProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters()
            {
                GenerateExecutable = false,
                GenerateInMemory = true,
                IncludeDebugInformation = false
            };


            using (StreamWriter sourceWriter = new StreamWriter(fileName))
            {
                provider.GenerateCodeFromCompileUnit(targetUnit, sourceWriter, new CodeGeneratorOptions());
            }


        }




        /*
        /// <summary>
        /// run time compiler variables
        /// </summary>
        CompilerResults CompilationResult;
        CodeDomProvider RuntimeCompiler = new Microsoft.CSharp.CSharpCodeProvider();
        CompilerParameters Parameters = new CompilerParameters();

        public ClassGenerator()
        {
            Parameters.GenerateExecutable = false;
            Parameters.GenerateInMemory = true;
            Parameters.IncludeDebugInformation = false;
        }

        public object GetClass()
        {
            //object that represents our class
            object myClass;
            //Create instance from our collection
            object myClasslist = CompilationResult.CompiledAssembly.CreateInstance("DynamicCollection.EntityList");

            return CompilationResult.CompiledAssembly.CreateInstance("DynamicCollection.Entity");
        }
        */
    }
}
