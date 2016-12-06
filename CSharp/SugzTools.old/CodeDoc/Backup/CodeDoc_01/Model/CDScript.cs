using System;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Text;

namespace CodeDoc.Model
{
    public class CDScript : CDTreeViewItem
    {

        // Properties
        #region Properties


        public StreamReader File { get; private set; }
        


        #endregion // End Properties



        // Constructors
        #region Constructors 


        public CDScript(string text, string file)
        {
            Type = ItemType.Script;
            Text = text;
            File = new StreamReader(file, Encoding.GetEncoding("iso-8859-1"));
        }


        #endregion // End Constructors



        // Methods
        #region Methods


        /// <summary>
        /// Get the script description
        /// </summary>
        protected override StringCollection GetDescription()
        {
            StringCollection description = new StringCollection();

            // Go to the begining and skip the first line
            File.DiscardBufferedData();
            File.BaseStream.Seek(0, SeekOrigin.Begin);
            File.ReadLine();

            // Real all description until the "use / modify" warning
            string str = File.ReadLine();
            while (!str.Contains("*"))
            {
                description.Add(str);
                str = File.ReadLine();
            }

            //return description.ToString();
            return description;
        }



        /// <summary>
        /// Get all the function in a script
        /// </summary>
        protected override ObservableCollection<ICDTreeViewItem> GetChildren()
        {
            ObservableCollection<ICDTreeViewItem> children = new ObservableCollection<ICDTreeViewItem>();
            while (!File.EndOfStream)
            {
                string line = File.ReadLine();
                if (line.Contains("fn "))
                {
                    string[] function = line.Split(' ');
                    children.Add(new CDFunction(function[1], File));
                }
            }

            return children;
        }

        

        #endregion // End Methods

    }
}
