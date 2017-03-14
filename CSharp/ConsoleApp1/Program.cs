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
            Rename renamer = new Rename();
            renamer.Name = "Test";

            Console.WriteLine(renamer.Name);

            renamer.AddPrefix("The-");
            renamer.AddSuffix("-LH-");
            Console.WriteLine(renamer.Name);

            //renamer.RemoveLast(3);
            //renamer.RemoveFirst(2);
            //renamer.Remove(2, 2);

            //renamer.Replace("-", "_", true);
            //renamer.Replace("-", "_", false);
            renamer.ReplaceAt(2, 2, "Add");

            Console.WriteLine(renamer.Name);

            Console.ReadLine();
        }
    }
}
