using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace TestApp
{
    public class People
    {
        public string Name { get; set; }
        public int Age { get; set; }
        public bool IsMinor
        {
            get { return (Age < 18); }
        }

    }
}
