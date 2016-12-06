using CodeDoc.Src;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
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
        protected override FlowDocument GetDescription()
        {
            // Open the file as tream and skip the first line
            StreamReader stream = new StreamReader(File, Encoding.GetEncoding("iso-8859-1"));
            FlowDocument document = new FlowDocument();
            stream.ReadLine();

            // Collect all description until the "use / modify" warning
            string str = stream.ReadLine();
            StringCollection description = new StringCollection();
            while (!str.Contains("*"))
            {
                str = str.Trim("\t# ".ToCharArray());
                if (str != "") description.Add(str);
                str = stream.ReadLine();
            }

            // Parse the description
            for (int i = 0; i < description.Count; i++)
            {
                // Get titles
                if (CDParser.IsTitle(description, i, document))
                    continue;

                // Get list
                if (CDParser.IsList(description, i, document))
                    continue;


                // Get hyperlink, types and normal text
                else document.Blocks.Add(CDParser.GetHyperlinkTypesAndNormalText(description[i]));

            }


            // Close the stream and return the paragraph
            stream.Close();
            return document;
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
