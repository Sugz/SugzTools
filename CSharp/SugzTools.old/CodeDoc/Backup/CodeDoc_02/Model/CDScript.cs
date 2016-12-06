using System;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows.Documents;

namespace CodeDoc.Model
{
    public class CDScript : CDTreeViewItem
    {

        // Properties
        #region Properties


        //public StreamReader File { get; private set; }
        public string File { get; private set; }


        #endregion // End Properties



        // Constructors
        #region Constructors 


        public CDScript(string text, string file)
        {
            Text = text;
            //File = new StreamReader(file, Encoding.GetEncoding("iso-8859-1"));
            File = file;
        }


        #endregion // End Constructors



        // Methods
        #region Methods


        /// <summary>
        /// Get the script description
        /// </summary>
        protected override Paragraph GetDescription()
        {
            // Open the file as tream and skip the first line
            StreamReader stream = new StreamReader(File, Encoding.GetEncoding("iso-8859-1"));
            Paragraph paragraph = new Paragraph();
            stream.ReadLine();

            // Real all description until the "use / modify" warning
            string str = stream.ReadLine();
            while (!str.Contains("*"))
            {
                paragraph.Inlines.Add(new Run(str + "\n"));
                str = stream.ReadLine();
            }

            /*
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
            */

            // Close the stream and return the paragraph
            stream.Close();
            return paragraph;
            
        }



        /// <summary>
        /// Get all the function in a script
        /// </summary>
        protected override ObservableCollection<ICDTreeViewItem> GetChildren()
        {
            ObservableCollection<ICDTreeViewItem> children = new ObservableCollection<ICDTreeViewItem>();
            StreamReader stream = new StreamReader(File, Encoding.GetEncoding("iso-8859-1"));
            int counter = 0;

            while (!stream.EndOfStream)
            {
                counter += 1;
                string line = stream.ReadLine();
                if (line.Contains("fn "))
                {
                    string[] function = line.Split(' ');
                    children.Add(new CDFunction(function[1], File, counter));
                }
            }

            stream.Close();
            return children;
        }

        

        #endregion // End Methods

    }
}
