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
            TestRenamer();
            Console.ReadLine();
        }


        private static void TestRenamer()
        {
            Rename rename = new Rename() { Name = "Test001" };
            rename.Remove(4, 4);
            Console.WriteLine(rename.Name);
        }


        private static void TestClassGen()
        {
            ClassGenerator gen = new ClassGenerator("Model");
            gen.AddProperties(typeof(double), "Value", true);
            gen.AddProperties(typeof(string), "Name", false);
            var MyClass = gen.GenerateCSharpCode();

            if (MyClass != null)
            {
                Console.WriteLine($"Class: {MyClass.GetType().Namespace}.{MyClass.GetType().Name}");
                var props = MyClass.GetType().GetProperties();
                props.ForEach(x => Console.WriteLine(x));
            }
        }
    }
}
