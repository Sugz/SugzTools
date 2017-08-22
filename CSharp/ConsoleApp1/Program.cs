using SugzTools.Src;
using SugzTools.Extensions;
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

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            ReadFile();
            Console.ReadLine();
        }


        public static void ReadFile()
        {
            string path = @"C:\Users\Clem\AppData\Local\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Libs\Custom_Attributes_Lib.ms";
            StreamReader reader = new StreamReader(path, Encoding.GetEncoding("iso-8859-1"));
            PeekableStreamReaderAdapter peekStreamReader = new PeekableStreamReaderAdapter(reader);

            while(!reader.EndOfStream)
            {
                Console.WriteLine(peekStreamReader.PeekLine());
                Console.WriteLine(peekStreamReader.ReadLine());
            }
        }
    }
}
