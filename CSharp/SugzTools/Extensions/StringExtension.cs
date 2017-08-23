using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
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
