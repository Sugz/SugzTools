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
            //TestRenamer();
            //TestClassGen();

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
            ModelGenerator gen = new ModelGenerator("Model");
            gen.AddUsing("System.Collections.Generic");
            gen.AddProperty(typeof(float), "Number", true);
            gen.AddProperty(typeof(string), "Word", false);
            gen.AddProperty(typeof(bool), "OK", false);

            Type model = gen.GetClassType();
            if (model != null)
            {
                var MyClass = Activator.CreateInstance(model.GetType(), new object[] { 1, "Test", true });
                if (MyClass != null)
                {
                    Console.WriteLine($"Class: {MyClass.GetType().Namespace}.{MyClass.GetType().Name}");
                    var props = MyClass.GetType().GetProperties();
                    props.ForEach(x => Console.WriteLine(x));
                }
            }
                
            
        }
    }
}
