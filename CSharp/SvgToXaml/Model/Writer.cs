using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SvgToXaml.Model
{
    public class Writer
    {
        public enum File
        {
            Enum,
            ResourceDictionary,
        }

        private StreamWriter writer;

        public string GetEnum()
        {
            string str = "//////////////////////////////////////////";
            str += "\n/// Auto-generated file, do not modify ///";
            str += "\n//////////////////////////////////////////";
            str += "\n";
            str += "\nnamespace SugzTools.Icons";
            str += "\n{";
            str += "\n\tpublic enum Geo";
            str += "\n\t{";
            return str;
        }
        public string GetResourceDictionary()
        {
            string str = "<!--////////////////////////////////////-->";
            str += "\n<!-- Auto-generated file, do not modify -->";
            str += "\n<!--////////////////////////////////////-->";
            str += "\n";
            str += "\n<ResourceDictionary xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\"";
            str += "\n\t\t\t\t\txmlns:x=\"http://schemas.microsoft.com/winfx/2006/xaml\">";
            str += "\n";
            return str;
        }

        public void Write(string _folder, string _enum, string _resourceDictionary)
        {
            if (!Directory.Exists(_folder))
                Directory.CreateDirectory(_folder);

            writer = new StreamWriter($"{_folder}\\ExternalIconsEnum.cs", false);
            writer.Write($"{GetEnum()}{_enum}\n\t}}\n}}\n");
            writer.Close();

            writer = new StreamWriter($"{_folder}\\ExternalIcons.xaml", false);
            writer.Write($"{ GetResourceDictionary()}{_resourceDictionary}\n\n</ResourceDictionary>\n");
            writer.Close();

        }
    }
}
