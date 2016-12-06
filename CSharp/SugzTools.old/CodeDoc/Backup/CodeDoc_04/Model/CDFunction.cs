using CodeDoc.Src;
using SugzExtensions;
using System;
using System.Collections.Generic;
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
        protected override FlowDocument GetDescription()
        {
            StreamReader stream = new StreamReader(File);
            FlowDocument document = new FlowDocument();
            string str = stream.ReadLine();

            // Skip until the function position
            for (int i = 0; i < LineIndex - 1; i++)
                str = stream.ReadLine();

            // Get the function name and arguments (read until the opening bracket to get all arguments)
            int index = str.IndexOf("fn ");
            str = (index < 0) ? str : str.Remove(index, ("fn ").Length);

            bool addLine = false;
            while (!str.Contains("("))
            {
                // Increments arguments and clean the string
                str = addLine ? "      " + str.Trim("\t= ".ToCharArray()) : str.Trim("\t= ".ToCharArray());

                document.Blocks.Add(new Paragraph(new Run(str)));
                str = stream.ReadLine();
                addLine = true;
            }

            // Skip until the description then store it
            while (!str.Contains("Description"))
                str = stream.ReadLine();

            StringCollection description = new StringCollection();
            while (!str.Contains("</Function>*/"))
            {
                description.Add(str.Trim("\t ".ToCharArray()));
                str = stream.ReadLine();
            }

            // Parse the description
            for (int i = 0; i < description.Count; i++)
            {
                // Get titles
                if (CDParser.IsTitle(description, i, document))
                    continue;

                //Get hyperlink, types and normal text
                else
                {
                    Paragraph paragraph = new Paragraph();
                    int count = 0;
                    foreach (string s in description[i].SplitAndKeep(CDConstant.Delimiters.StringArrayToCharArray()))
                    {
                        // Get hyperlink
                        if (CDParser.IsHyperlink(s, paragraph))
                            continue;

                        // Get types 
                        if (CDParser.IsType(s, paragraph))
                            continue;

                        // Get normal text
                        paragraph.Inlines.Add(new Run(s));
                        count += 1;
                    }

                    document.Blocks.Add(paragraph);
                }
                
            }

            stream.Close();
            return document;
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