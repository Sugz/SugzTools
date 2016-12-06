using CodeDoc.Src;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.IO;

namespace CodeDoc.Model
{
    public class CDFunction : CDTreeViewItem
    {

        // Properties
        #region Properties


        public StreamReader File { get; private set; }



        #endregion // End Properties


        // Constructors
        #region Constructors 


        public CDFunction(string text, StreamReader file)
        {
            Type = ItemType.Function;
            Text = text;
            File = file;
        }


        #endregion // End Constructors



        // Methods
        #region Methods

        /// <summary>
        /// Folder have an ampty description
        /// </summary>
        protected override StringCollection GetDescription()
        {
            StringCollection description = new StringCollection();

            // Go to the begining
            File.DiscardBufferedData();
            File.BaseStream.Seek(0, SeekOrigin.Begin);

            // Read all file until the function is reached (and avoid the the History part)
            string str = File.ReadLine();
            while (!str.Contains("fn " + Text))
                str = File.ReadLine();

            // Get the function name and arguments
            //str = str.TrimStart("\t fn=".ToCharArray());
            str = str.Trim("\t fn=".ToCharArray());
            description.Add(str);

            // Go the to begining of the description
            while (!str.Contains("Description"))
                str = File.ReadLine();

            // Read all the description
            while (!str.Contains("</Function>*/"))
            {
                str = str.Trim("\t ".ToCharArray());
                description.Add(str);
                str = File.ReadLine();
            }


            //return description.ToString();
            return description;
        }

        /// <summary>
        /// Get all the script in the folder
        /// </summary>
        protected override ObservableCollection<ICDTreeViewItem> GetChildren()
        {
            return null;
        }


        #endregion // End Methods

    }
}