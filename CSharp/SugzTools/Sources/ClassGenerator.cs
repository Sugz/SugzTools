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

        class Property
        {
            public Type Type;
            public string Name;
            public bool ReadOnly;
            public object Value;

            public Property(PropertyType type, string name, bool readOnly, object value)
            {
                switch (type)
                {
                    case PropertyType.Bool:
                        Type = typeof(bool);
                        break;
                    case PropertyType.Int:
                        Type = typeof(int);
                        break;
                    case PropertyType.Float:
                        Type = typeof(float);
                        break;
                    case PropertyType.String:
                        Type = typeof(string);
                        break;
                    case PropertyType.List:
                    default:
                        break;
                }

                Name = name;
                ReadOnly = readOnly;
                Value = value;
            }
        }


        #region Fields


        private StringBuilder Code = new StringBuilder();
        private string ClassName = "Model";
        private const string outputFileName = @"d:\SampleCode.cs";
        private const string namespaceName = "SugzTools";

        private List<String> Usings = new List<string>();
        private List<Property> Properties = new List<Property>();
        


        #endregion Fields



        #region Constructor


        public ClassGenerator() { }
        public ClassGenerator(string className)
        {
            ClassName = className;
        }


        #endregion Constructor



        #region Methods


        private void CreateClass()
        {
            Code.AppendLine("using System;");
            foreach (string str in Usings)
                Code.AppendLine($"using {str};");

            Code.AppendLine("\nnamespace SugzTools");
            Code.AppendLine("{");
            Code.AppendLine($"\tpublic class {ClassName}\n\t{{");

            // Properties
            foreach (Property prop in Properties)
            {
                if (prop.ReadOnly)
                    Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name} {{ get; private set; }}");
                else
                    Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name} {{ get; set; }}");
            }

            // Constructor
            Code.AppendLine($"\n\t\tpublic {ClassName}(){{}}");


            Code.Append($"\n\t\tpublic {ClassName}(");

            for (int i = 0; i < Properties.Count; i++)
            {
                Code.Append($"{Properties[i].Type} {(Properties[i].Name).ToLower()}");
                if (i != Properties.Count - 1)
                    Code.Append(", ");
            }

            Code.AppendLine(")\n\t\t{");
            foreach (Property prop in Properties)
                Code.AppendLine($"\t\t\t{prop.Name} = {(prop.Name).ToLower()};");

            Code.AppendLine("\t\t}\n\t}\n}");

        }


        /// <summary>
        /// Add a using to the generated class
        /// </summary>
        /// <param name="_using">The Namespace to add</param>
        public void AddUsing(string _using)
        {
            Usings.Add(_using);
        }


        /// <summary>
        /// Add a property to the generated class
        /// </summary>
        /// <param name="type">The property Type</param>
        /// <param name="name">The property Name</param>
        /// <param name="readOnly">Set the property setter to be private</param>
        /// <param name="value">The property Value</param>
        public void AddProperty(PropertyType type, string name, bool readOnly, object value)
        {
            Properties.Add(new Property(type, name, readOnly, value));
        }


        /// <summary>
        /// Generate CSharp source code from the compile unit.
        /// </summary>
        /// <param name="filename">Output file name</param>
        public object GetClass(string fileName = outputFileName)
        {
            CreateClass();


            CodeDomProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters()
            {
                GenerateExecutable = false,
                GenerateInMemory = true,
                IncludeDebugInformation = true,
            };

            File.WriteAllText(outputFileName, Code.ToString());


            CompilerResults compiler = provider.CompileAssemblyFromSource(parameters, Code.ToString());
            if (compiler.Errors.HasErrors)
            {
                compiler.Errors.ForEach(x => Console.WriteLine(x));
                return null;
            }

            object[] args = new object[Properties.Count()];
            for (int i = 0; i < Properties.Count; i++)
            {
                args[i] = Properties[i].Value;
            }


            object myClass = compiler.CompiledAssembly.CreateInstance($"{namespaceName}.{ClassName}");
            return Activator.CreateInstance(myClass.GetType(), args);
        } 


        #endregion Methods

    }
}
