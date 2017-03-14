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


        public void Remove(int index, int length) { Name = Name.Remove(index, length); }
        public void RemoveFirst(int length) { Name = Name.Substring(length); }
        public void RemoveLast(int length) { Name = Name.Remove(Name.Length - length); }


        public void Replace(string oldSubString, string newSubString, bool allOccurrences)
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
        public void ReplaceAt(int index, int length, string newSubString)
        {
            Remove(index, length);
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