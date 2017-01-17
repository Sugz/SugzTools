using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SvgToXaml.Model
{
    public class Folder : IEquatable<Folder>
    {
        public string Name { get; set; }
        public int SvgCount { get; private set; }
        

        public Folder(string name)
        {
            Name = name;
            SvgCount = Directory.GetFiles(Name, "*.svg").Length;
        }

        public bool Equals(Folder other)
        {
            if (Name == other.Name && SvgCount == other.SvgCount)
                return true;
            return false;
        }
    }
}
