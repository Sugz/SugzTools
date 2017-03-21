using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            ClassGenerator gen = new ClassGenerator("Model");
            gen.AddProperties(typeof(double), "Value");
            gen.AddProperties(typeof(string), "Name");
            gen.GenerateCSharpCode();
        }
    }
}
