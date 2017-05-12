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
            TestClassGen();

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
            gen.AddUsing("System.Collections.Generic");
            gen.AddProperty(PropertyType.Float, "Number", true);
            //gen.SetProperty("Number", 1);
            gen.AddProperty(PropertyType.String, "Word", false);
            //gen.SetProperty("Word", "Test");
            gen.AddProperty(PropertyType.Bool, "OK", false);
            //gen.SetProperty("OK", true);


            var model = gen.GetClass();
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
