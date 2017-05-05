using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace SugzTools.Src
{
    public class Rename
    {

        public string Name { get; set; } = "";
        public int Index { get; set; } = 1;
        public int Padding { get; set; } = 2;


        public void AddPrefix(string prefix) { Name = prefix + Name; }

        public void AddSuffix(string suffix) { Name += suffix; }

        public void Remove(int index, int count)
        {
            if (index + count > Name.Length)
                count = Name.Length - index;

            Name = Name.Remove(index, count);
        }

        public void RemoveFirst(int count) { Name = Name.Substring(count); }

        public void RemoveLast(int count) { Name = Name.Remove(Name.Length - count); }

        public void Replace(string oldSubString, string newSubString, bool allOccurrences, bool matchCase)
        {
            if (allOccurrences)
            {
                Name = Name.Replace(oldSubString, newSubString);
            }
            else
            {
                Regex regex = new Regex(Regex.Escape(oldSubString));
                Name = regex.Replace(Name, newSubString, 1);
            }
        }

        public void ReplaceAt(int index, int count, string newSubString)
        {
            Remove(index, count);
            Insert(index, newSubString);
        }

        public void Insert(int index, string newSubString)
        {
            Name = Name.Insert(index, newSubString);
        }

        public void AddIndex(int increment)
        {
            string index = (Index + increment).ToString();
            while (index.Length < Padding)
                index = "0" + index;

            Name += index;
        }


    }
}