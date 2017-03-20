using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.CodeDom.Compiler;

namespace SugzTools.Sources
{
    public class ClassGenerator
    {
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
}
