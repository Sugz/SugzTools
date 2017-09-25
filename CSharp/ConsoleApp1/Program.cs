using SugzTools.Src;
using SugzTools.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;
using CodeDoc.Src;
using System.Diagnostics;
using System.IO;
using System.Text.RegularExpressions;
using SugzTools.Extensions;
using System.Xml.Linq;
using MaxscriptManager.Src;

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            TestMethod(HasChildrenDavidDax, "HasChildrenDavidDax");
            TestMethod(HasChildrenAlternate, "HasChildrenAlternate");
            TestMethod(HasChildrenClem, "HasChildrenClem");
            Console.ReadKey(false);
        }

        static void TestMethod(Func<string, bool> method, string MethodName)
        {
            string[] TestFolders = new string[] { @"D:\Test\EmptyFolder", @"D:\Test\FolderWithFile", @"D:\Test\FolderWithSubfolder" };
            int tests = 10000;
            Random r = new Random();
            Stopwatch sw = new Stopwatch();
            sw.Start();
            for (int i = 0; i < tests; ++i)
            {
                bool b = method(TestFolders[r.Next(0, TestFolders.Length)]);
            }
            Console.WriteLine($"{MethodName}: Elapsed Time: {sw.ElapsedMilliseconds} ms");
        }


        static bool HasChildrenDavidDax(string path)
        {
            DirectoryInfo directory = new DirectoryInfo(path);
            if (directory.GetDirectories().Length != 0 || directory.GetFiles().Length != 0)
                return true;
            return false;
        }
        static bool HasChildrenAlternate(string path)
        {
            IEnumerable<string> subfolders = Directory.EnumerateDirectories(path);
            IEnumerable<string> subitem = Directory.EnumerateFiles(path);
            return (subfolders != null && subfolders.Any()) ||
                (subitem != null && subitem.Any());
        }
        static bool HasChildrenClem(string path)
        {
            return (Directory.EnumerateDirectories(path) != null ||
                Directory.EnumerateFiles(path) != null);
        }

    }
}
