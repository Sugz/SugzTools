using CodeDoc.Src;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Text;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Media;

namespace CodeDoc.Model
{
    public class CDFunction : CDTreeViewItem
    {

        // Properties
        #region Properties


        public string File { get; private set; }
        public int LineIndex { get; private set; }


        #endregion // End Properties


        // Constructors
        #region Constructors 


        public CDFunction(string text, string file, int lineIndex)
        {
            Text = text;
            File = file;
            LineIndex = lineIndex;
        }


        #endregion // End Constructors



        // Methods
        #region Methods

        /// <summary>
        /// Folder have an ampty description
        /// </summary>
        protected override Paragraph GetDescription()
        {
            StreamReader stream = new StreamReader(File);
            Paragraph paragraph = new Paragraph();
            string str = stream.ReadLine();

            // Skip until the function position
            int counter = 0;
            while (counter != LineIndex - 1)
            {
                counter += 1;
                str = stream.ReadLine();
            }

            // Get the function name and arguments (read until the opening bracket to get all arguments)
            int index = str.IndexOf("fn ");
            str = (index < 0) ? str : str.Remove(index, ("fn ").Length);


            // Go the to begining of the description
            counter = 0;
            while (!str.Contains("("))
            {
                str = str.Trim("\t= ".ToCharArray());

                // Increments arguments
                if (counter > 0)
                    str = "      " + str;

                paragraph.Inlines.Add(new Run(str + "\n"));
                str = stream.ReadLine();
                counter += 1;
            }

            // skip until the description
            while (!str.Contains("Description"))
                str = stream.ReadLine();

            // Read all the description. Read a string before the read one to get empty description
            string nextStr = stream.ReadLine();
            while (!nextStr.Contains("</Function>*/"))
            //while (!str.Contains("</Function>*/"))
            {
                str = str.Trim("\t ".ToCharArray());
                Run run = new Run();

                // Get titles
                if (str.EndsWith(":"))
                {
                    // Avoid empty titles
                    if (nextStr.EndsWith(":"))
                    {
                        str = nextStr;
                        nextStr = stream.ReadLine();
                        continue;
                    }

                    str = "\n" + str;
                    run.Foreground = new SolidColorBrush(Color.FromArgb(255, 150, 150, 150));
                    run.FontStyle = FontStyles.Italic;
                }

                run.Text = str + "\n";
                paragraph.Inlines.Add(run);
                //str = stream.ReadLine();
                str = nextStr;
                nextStr = stream.ReadLine();
            }

            paragraph.Inlines.Add(new Run(str.Trim("\t ".ToCharArray())));

            stream.Close();
            return paragraph;
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