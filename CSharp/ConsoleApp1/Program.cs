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

namespace ConsoleApp1
{
    class Program
    {
        static void Main(string[] args)
        {
            string s = "/*this is a test /* comm */ ahaha -- test";

            string[] delims = { "/*", "*/", "--" };
            SplitAndKeep(s, delims).ForEach(x => Console.WriteLine(x));

            Console.ReadLine();
        }

        /// <summary>
        /// 
        /// Code by Guffa: https://stackoverflow.com/a/2485179/3971575
        /// </summary>
        /// <param name="input"></param>
        /// <param name="delimiters"></param>
        /// <returns></returns>
        public static IEnumerable<string> SplitAndKeep(string input, string[] delimiters)
        {
            int[] nextPosition = delimiters.Select(d => input.IndexOf(d)).ToArray();
            int pos = 0;
            while (true)
            {
                int firstPos = int.MaxValue;
                string delimiter = null;
                for (int i = 0; i < nextPosition.Length; i++)
                {
                    if (nextPosition[i] != -1 && nextPosition[i] < firstPos)
                    {
                        firstPos = nextPosition[i];
                        delimiter = delimiters[i];
                    }
                }
                if (firstPos != int.MaxValue)
                {
                    if (input.Substring(pos, firstPos - pos) is string sub && sub != string.Empty)
                        yield return sub;
                    yield return delimiter;
                    pos = firstPos + delimiter.Length;
                    for (int i = 0; i < nextPosition.Length; i++)
                    {
                        if (nextPosition[i] != -1 && nextPosition[i] < pos)
                        {
                            nextPosition[i] = input.IndexOf(delimiters[i], pos);
                        }
                    }
                }
                else
                {
                    yield return input.Substring(pos);
                    break;
                }
            }
        }


    }
}
