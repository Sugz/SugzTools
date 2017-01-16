using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SvgToXaml
{
    public class Folder
    {
        public string Name { get; set; }
        public string Count { get; set; }

        public Folder(string name)
        {
            Name = name;
        }
    }
}
