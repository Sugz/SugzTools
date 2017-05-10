using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestApp
{
    public class TempModel
    {
        public int Value { get; set; }
        public string Name { get; private set; }
        public bool Valid { get; private set; }

        public TempModel(int value, string name, bool valid)
        {
            Value = value;
            Name = name;
            Valid = valid;
        }

    }
}
