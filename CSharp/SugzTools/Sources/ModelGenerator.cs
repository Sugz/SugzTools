using Microsoft.CSharp;
using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace SugzTools.Src
{

    public class ModelGenerator
    {

        class Property
        {
            public Type Type;
            public string Name;
            public bool ReadOnly;
            public object Value;

            public Property(Type type, string name, bool readOnly)
            {
                Type = type;
                Name = name;
                ReadOnly = readOnly;
            }

            public Property(PropertyType type, string name, bool readOnly)
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


        public ModelGenerator() { }
        public ModelGenerator(string className)
        {
            ClassName = className;
        }


        #endregion Constructor



        #region Methods


        private void CreateClass()
        {
            // Using
            Code.AppendLine("using System;");
            Code.AppendLine("using System.ComponentModel;");

            foreach (string str in Usings)
                Code.AppendLine($"using {str};");

            // Namespace and Class
            Code.AppendLine("\nnamespace SugzTools");
            Code.AppendLine("{");
            Code.AppendLine($"\tpublic class {ClassName} : INotifyPropertyChanged\n\t{{\n");

            // INotifyPropertyChanged
            Code.AppendLine("\t\t#region INotifyPropertyChanged\n");
            Code.AppendLine("\t\tpublic event PropertyChangedEventHandler PropertyChanged;");
            Code.AppendLine("\t\tprivate void OnPropertyChanged(string name)\n\t\t{");
            Code.AppendLine("\t\t\tif (PropertyChanged != null)\n\t\t\t\tPropertyChanged(this, new PropertyChangedEventArgs(name));\n\t\t}\n");
            Code.AppendLine("\t\t#endregion // INotifyPropertyChanged\n\n");

            // Properties
            Code.AppendLine("\t\t#region Properties\n");
            foreach (Property prop in Properties)
            {
                if (prop.ReadOnly)
                    Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name} {{ get; private set; }}\n");
                else
                {
                    Code.AppendLine($"\t\tprivate {prop.Type} _{prop.Name};");
                    //Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name} \n\t\t{{ get; set; }}");
                    Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name}\n\t\t{{");
                    Code.AppendLine($"\t\t\tget {{ return _{prop.Name}; }}");
                    Code.AppendLine("\t\t\tset\n\t\t\t{");
                    Code.AppendLine($"\t\t\t\t_{prop.Name} = value;");
                    Code.AppendLine($"\t\t\t\tOnPropertyChanged(\"{prop.Name}\");");
                    Code.AppendLine("\t\t\t}\n\t\t}\n");
                }
                    
            }
            Code.AppendLine("\t\t#endregion // Properties\n\n");

            // Constructors
            Code.AppendLine("\t\t#region Constructors\n");
            Code.AppendLine($"\t\tpublic {ClassName}() {{ }}");
            Code.Append($"\t\tpublic {ClassName}(");
            for (int i = 0; i < Properties.Count; i++)
            {
                Code.Append($"{Properties[i].Type} {(Properties[i].Name).ToLower()}");
                if (i != Properties.Count - 1)
                    Code.Append(", ");
            }
            Code.AppendLine(")\n\t\t{");
            foreach (Property prop in Properties)
                Code.AppendLine($"\t\t\t{prop.Name} = {(prop.Name).ToLower()};");

            Code.AppendLine("\t\t}\n\n\t\t#endregion // Constructors\n\t}\n}");

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
        public void AddProperty(PropertyType type, string name, bool readOnly)
        {
            Properties.Add(new Property(type, name, readOnly));
        }
        public void AddProperty(Type type, string name, bool readOnly)
        {
            Properties.Add(new Property(type, name, readOnly));
        }

        /// <summary>
        /// Set the value of a property to the generated class
        /// </summary>
        /// <param name="propertyName"></param>
        /// <param name="value"></param>
        public void SetProperty(string propertyName, object value)
        {
            Properties.Where(x => x.Name == propertyName).ToArray()[0].Value = value;
        }


        /// <summary>
        /// Generate CSharp source code from the compile unit.
        /// </summary>
        /// <param name="filename">Output file name</param>
        //public object GetClass(object[] args = null, string fileName = outputFileName)
        public object GetClass(string fileName = outputFileName)
        {
            CreateClass();

            //CodeDomProvider provider = new Microsoft.CodeDom.Providers.DotNetCompilerPlatform.CSharpCodeProvider();
            CodeDomProvider provider = new CSharpCodeProvider();
            CompilerParameters parameters = new CompilerParameters()
            {
                GenerateExecutable = false,
                GenerateInMemory = true,
                IncludeDebugInformation = true,
            };
            parameters.ReferencedAssemblies.Add("System.dll");

            File.WriteAllText(outputFileName, Code.ToString());


            CompilerResults compiler = provider.CompileAssemblyFromSource(parameters, Code.ToString());
            if (compiler.Errors.HasErrors)
            {
                compiler.Errors.ForEach(x => Console.WriteLine(x));
                return null;
            }

            return compiler.CompiledAssembly.CreateInstance($"{namespaceName}.{ClassName}");
        } 


        #endregion Methods

    }
}
