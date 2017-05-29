using SugzTools.Src;
using SugzTools.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;

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
            ModelGenerator gen = new ModelGenerator("Model");
            gen.AddUsing("System.Collections.Generic");
            gen.AddUsing("Autodesk.Max", @"C:\Program Files\Autodesk\3ds Max 2016\Autodesk.Max.dll");
            gen.AddProperty(typeof(float), "Number", true);
            gen.AddProperty(typeof(string), "Word", false);
            gen.AddProperty(typeof(bool), "OK", false);
            gen.AddProperty(Helper.GetNodeClass(), "Node", false);

            Type model = gen.GetClassType(@"D:\SampleCode.cs");
            if (model != null)
            {
                var MyClass = Activator.CreateInstance(model, new object[] { 1, "Test", true, new object() });
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
