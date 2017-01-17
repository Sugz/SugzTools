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
        public string Path { get; set; }
        public string Prefix { get; set; }
        public int SvgCount { get; private set; }
        

        public Folder(string path)
        {
            Path = path;
            SvgCount = Directory.GetFiles(Path, "*.svg").Length;
        }

        public bool Equals(Folder other)
        {
            if (Path == other.Path && Prefix == other.Prefix && SvgCount == other.SvgCount)
                return true;
            return false;
        }
    }
}
