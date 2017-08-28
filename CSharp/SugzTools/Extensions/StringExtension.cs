using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SugzTools.Extensions
{
    public static class StringExtension
    {

        public static IEnumerable<string> SplitAndKeep(this string s, char delim)
        {
            return (s.SplitAndKeep(delim.ToString().ToCharArray()));
        }

        /// <summary>
        /// Split a string while keeping the delimiters
        /// </summary>
        /// <param name="s">The string to split</param>
        /// <param name="delims">The delimiters</param>
        /// <returns>Return an IEnumerable of string composed of the split string and the delimiters</returns>
        public static IEnumerable<string> SplitAndKeep(this string s, char[] delims)
        {
            int start = 0, index;

            while ((index = s.IndexOfAny(delims, start)) != -1)
            {
                if (index - start > 0)
                    yield return s.Substring(start, index - start);
                yield return s.Substring(index, 1);
                start = index + 1;
            }

            if (start < s.Length)
            {
                yield return s.Substring(start);
            }
        }

        /// <summary>
        /// Split a string given a string delimiter and keep the delimiter
        /// </summary>
        /// <param name="s"></param>
        /// <param name="delim"></param>
        /// <returns></returns>
        public static IEnumerable<string> SplitAndKeep(this string s, string delim)
        {
            string[] parts = Regex.Split(s, delim);
            yield return parts[0];
            for (int i = 1; i < parts.Length; i++)
            {
                yield return delim;
                yield return parts[i];
            }
        }

        /// <summary>
        /// Split a string given string delimiters and keep the delimiters
        /// Code by Guffa: https://stackoverflow.com/a/2485179/3971575
        /// </summary>
        /// <param name="input"></param>
        /// <param name="delimiters"></param>
        /// <returns></returns>
        public static IEnumerable<string> SplitAndKeep(this string input, string[] delimiters)
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
                    if (input.Substring(pos) is string sub && sub != string.Empty)
                        yield return sub;
                    break;
                }
            }
        }


        /// <summary>
        /// Convert a string array to a char array
        /// </summary>
        /// <param name="strings">The String Array to convert as Char Array</param>
        /// <returns>The String Array as Char Array</returns>
        public static char[] StringArrayToCharArray(this string[] strings)
        {
            // Convert the char array to a string
            StringBuilder str = new StringBuilder();
            foreach (string s in strings)
                str.Append(s[0]);

            // Return the string as char array
            return str.ToString().ToCharArray();
        }


        /// <summary>
        /// Return a string without last char
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static string TrimLast(this string s)
        {
            return s.Remove(s.Length - 1);
        }

    }
}
