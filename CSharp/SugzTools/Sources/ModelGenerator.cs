using Microsoft.CSharp;
using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace SugzTools.Src
{

    public class ModelGenerator
    {

        class Using
        {
            public string Name { get; set; }
            public string Url { get; set; }

            public Using(string name)
            {
                Name = name;
            }
            public Using(string name, string url)
            {
                Name = name;
                Url = url;
            }
        }

        class Property
        {
            public Type Type { get; set; }
            public string Name { get; set; }
            public bool ReadOnly { get; set; }
            public bool IsCollection { get; set; }
            public object Value { get; set; }

            public Property(Type type, string name, bool readOnly, bool isCollection)
            {
                Type = type;
                Name = name;
                ReadOnly = readOnly;
                IsCollection = isCollection;
            }
        }


        #region Fields

        private CodeDomProvider _Provider = new CSharpCodeProvider();
        private StringBuilder _Code = new StringBuilder();
        private const string _NamespaceName = "SugzTools";
        private List<Using> _Usings = new List<Using>();
        private List<Property> _Properties = new List<Property>();



        #endregion Fields


        public string ClassName { get; set; } = "Model";



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
            _Code.AppendLine("using System;");
            _Code.AppendLine("using System.ComponentModel;");

            foreach (Using _using in _Usings.Where(x => x.Name != ""))
                _Code.AppendLine($"using {_using.Name};");


            // Namespace and Class
            _Code.AppendLine("\nnamespace SugzTools");
            _Code.AppendLine("{");
            _Code.AppendLine($"\tpublic class {ClassName} : INotifyPropertyChanged\n\t{{\n");

            // INotifyPropertyChanged
            _Code.AppendLine("\t\t#region INotifyPropertyChanged\n");
            _Code.AppendLine("\t\tpublic event PropertyChangedEventHandler PropertyChanged;");
            _Code.AppendLine("\t\tprivate void OnPropertyChanged(string name)\n\t\t{");
            _Code.AppendLine("\t\t\tif (PropertyChanged != null)\n\t\t\t\tPropertyChanged(this, new PropertyChangedEventArgs(name));\n\t\t}\n");
            _Code.AppendLine("\t\t#endregion INotifyPropertyChanged\n\n");

            // Properties
            _Code.AppendLine("\t\t#region Properties\n");
            foreach (Property prop in _Properties)
            {
                if (prop.ReadOnly)
                    _Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name} {{ get; private set; }}\n");
                else
                {
                    _Code.AppendLine($"\t\tprivate {prop.Type} _{prop.Name};");
                    _Code.AppendLine($"\t\tpublic {prop.Type} {prop.Name}\n\t\t{{");
                    _Code.AppendLine($"\t\t\tget {{ return _{prop.Name}; }}");
                    _Code.AppendLine("\t\t\tset\n\t\t\t{");
                    _Code.AppendLine($"\t\t\t\t_{prop.Name} = value;");
                    _Code.AppendLine($"\t\t\t\tOnPropertyChanged(\"{prop.Name}\");");
                    _Code.AppendLine("\t\t\t}\n\t\t}\n");
                }
                    
            }
            _Code.AppendLine("\t\t#endregion Properties\n\n");

            // Constructor
            _Code.AppendLine("\t\t#region Constructor\n");
            _Code.Append($"\t\tpublic {ClassName}(");
            for (int i = 0; i < _Properties.Count; i++)
            {
                _Code.Append($"{_Properties[i].Type} _{(_Properties[i].Name).ToLower()}");
                if (i != _Properties.Count - 1)
                    _Code.Append(", ");
            }
            _Code.AppendLine(")\n\t\t{");
            foreach (Property prop in _Properties)
                _Code.AppendLine($"\t\t\t{prop.Name} = _{(prop.Name).ToLower()};");

            _Code.AppendLine("\t\t}\n\n\t\t#endregion Constructor\n\t}\n}");

        }


        /// <summary>
        /// Add a using to the generated class
        /// </summary>
        /// <param name="_using">The Namespace to add</param>
        public void AddUsing(string name)
        {
            _Usings.Add(new Using(name));
        }
        public void AddUsing(string name, string url)
        {
            _Usings.Add(new Using(name, url));
        }


        /// <summary>
        /// Add a property to the generated class
        /// </summary>
        /// <param name="type">The property Type</param>
        /// <param name="name">The property Name</param>
        /// <param name="readOnly">Set the property setter to be private</param>
        /// <param name="value">The property Value</param>
        public bool AddProperty(Type type, string name, bool readOnly, bool isCollection = false)
        {
            // Make sure the property name isn't a c# reserved keyword
            if (!_Provider.IsValidIdentifier(name))
                return false;

            _Properties.Add(new Property(type, name, readOnly, isCollection));
            return true;
        }

        /// <summary>
        /// Set the value of a property to the generated class
        /// </summary>
        /// <param name="propertyName"></param>
        /// <param name="value"></param>
        public void SetProperty(string propertyName, object value)
        {
            _Properties.Where(x => x.Name == propertyName).ToArray()[0].Value = value;
        }


        /// <summary>
        /// Generate CSharp source code from the compile unit.
        /// </summary>
        /// <param name="filename">Output file name</param>
        public Type GetClassType(string fileName = null)
        {
            CreateClass();

            CompilerParameters parameters = new CompilerParameters()
            {
                GenerateExecutable = false,
                GenerateInMemory = true,
                IncludeDebugInformation = true,
            };
            parameters.ReferencedAssemblies.Add("System.dll");

            foreach (Using _using in _Usings.Where(x => x.Url != null))
                parameters.ReferencedAssemblies.Add(_using.Url);


            // Write the class to a file
            if (fileName != null)
                File.WriteAllText(fileName, _Code.ToString());


            CompilerResults compiler = _Provider.CompileAssemblyFromSource(parameters, _Code.ToString());
            if (compiler.Errors.HasErrors)
            {
                compiler.Errors.ForEach(x => Console.WriteLine(x));
                return null;
            }

            //return compiler.CompiledAssembly.CreateInstance($"{namespaceName}.{ClassName}");
            return compiler.CompiledAssembly.GetType($"{_NamespaceName}.{ClassName}");
        } 


        #endregion Methods

    }
}
