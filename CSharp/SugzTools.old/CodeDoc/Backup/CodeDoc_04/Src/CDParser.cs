using SugzExtensions;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;

namespace CodeDoc.Src
{
    public static class CDParser
    {

        // Hyperlink
        #region Hyperlink


        /// <summary>
        /// Return a hyperlink
        /// </summary>
        /// <param name="str">The text and link</param>
        /// <param name="color">The text foreground</param>
        /// <param name="overColor">The text foreground when the mouse is over</param>
        /// <returns>A formated hyperlink</returns>
        public static Hyperlink GetHyperLink(string str, Color? color, Color? overColor)
        {
            return (GetHyperLink(str, str, color, overColor));
        }



        /// <summary>
        /// Return a hyperlink
        /// </summary>
        /// <param name="str">The text</param>
        /// <param name="uri">The link</param>
        /// <param name="color">The text foreground</param>
        /// <param name="overColor">The text foreground when the mouse is over</param>
        /// <returns>A formated hyperlink</returns>
        public static Hyperlink GetHyperLink(string str, string uri, Color? color, Color? overColor)
        {
            Run run = new Run(str);
            run.FontStyle = FontStyles.Italic;

            if (color != null)
            {
                run.Foreground = new SolidColorBrush((Color)color);
                run.TextDecorations = TextDecorations.Underline;
                run.MouseEnter += (s, e) => run.Foreground = new SolidColorBrush((Color)overColor);
                run.MouseLeave += (s, e) => run.Foreground = new SolidColorBrush((Color)color);
            }
                

            Hyperlink hyperlink = new Hyperlink(run);
            hyperlink.NavigateUri = new Uri(uri);
            hyperlink.RequestNavigate += (s, e) => Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri));

            return hyperlink;
        }



        /// <summary>
        /// Format a hyperlink and add it to a paragraph
        /// </summary>
        /// <param name="s">The string to check and format as hyperlink</param>
        /// <param name="paragraph">The paragraph to add the hyperlink</param>
        /// <returns>True if the string is a hyperlink, false otherwise</returns>
        public static bool IsHyperlink(string s, Paragraph paragraph)
        {
            bool iIsHyperlink = false;
            if (CDConstant.LinkParser.IsMatch(s))
            {
                iIsHyperlink = true;
                paragraph.Inlines.Add(GetHyperLink(s, Colors.CornflowerBlue, Colors.DeepSkyBlue));
            }

            return iIsHyperlink;
        }


        #endregion // End Hyperlink



        // Title
        #region Title

        /// <summary>
        /// Add a formated run to a document
        /// </summary>
        /// <param name="strs">The StringCollection containing the lines of the description</param>
        /// <param name="index">The index of the current line in the StringCollection</param>
        /// <param name="paragraph">The paragraph to add the run inside</param>
        /// <returns>True is the string is a title, false otherwise</returns>
        public static bool IsTitle(StringCollection strs, int index, FlowDocument document)
        {
            bool isTitle = false;
            if (CDConstant.Titles.Contains(strs[index]))
            {
                isTitle = true;

                // Skip empty titles
                if (!(index + 1 == strs.Count) && !(CDConstant.Titles.Contains(strs[index + 1])))
                {
                    Run run = new Run(strs[index]);
                    run.Foreground = new SolidColorBrush(Color.FromArgb(255, 150, 150, 150));
                    run.FontStyle = FontStyles.Italic;

                    Paragraph paragraph = new Paragraph(new Run("\n"));
                    paragraph.Inlines.Add(run);
                    document.Blocks.Add(paragraph);
                }
            }

            return isTitle;
        }


        #endregion // End Title



        // List
        #region List

        /// <summary>
        /// Add a list to a document
        /// </summary>
        /// <param name="strs"></param>
        /// <param name="index"></param>
        /// <param name="document"></param>
        /// <returns>True is the string is a list, false otherwise</returns>
        public static bool IsList(StringCollection strs, int index, FlowDocument document)
        {
            bool isList = false;
            if (strs[index].StartsWith("-"))
            {
                isList = true;
                string str = strs[index].Trim("- ".ToCharArray());
                List list = new List(new ListItem(new Paragraph(new Run(str))));
                list.Margin = new Thickness(0);
                document.Blocks.Add(list);
            }

            return isList;
        }


        #endregion // End List



        // Type
        #region Type


        /// <summary>
        /// Add a formated string (or hyperlink) to a paragraph
        /// </summary>
        /// <param name="s">The string to test if it's a type</param>
        /// <param name="paragraph">The Paragraph to add the type</param>
        /// <returns>True if the string is a type, false otherwise</returns>
        public static bool IsType(string s, Paragraph paragraph)
        {
            bool isType = false;
            IEnumerable<string> types = CDConstant.Collections.Keys.Concat(CDConstant.Types.Keys.Concat(CDConstant.Numbers.Concat(CDConstant.OtherTypes.Concat(CDConstant.Delimiters))));
            if (types.Any(s.Contains))
            {
                isType = true;

                // Get collections
                if (CDConstant.Collections.Keys.Contains(s))
                    paragraph.Inlines.Add(GetHyperLink(s, CDConstant.Collections[s], Colors.YellowGreen, Colors.Yellow));

                // Get numbers
                else if (CDConstant.Numbers.Contains(s))
                    paragraph.Inlines.Add(GetHyperLink(s, "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_B57EA575_DCDE_42F5_9D30_88E3EB41F350_htm", Colors.YellowGreen, Colors.Yellow));

                // Get normal types
                else if (CDConstant.Types.Keys.Contains(s))
                    paragraph.Inlines.Add(GetHyperLink(s, CDConstant.Types[s], Colors.YellowGreen, Colors.Yellow));

                // Get other types
                else
                {
                    Run run = new Run(s);
                    run.FontStyle = FontStyles.Italic;
                    run.Foreground = new SolidColorBrush(Colors.YellowGreen);
                    paragraph.Inlines.Add(run);
                }
            }

            return isType;
        }


        #endregion // End Type


        // Hyperlink, type and normal text
        #region Hyperlink, type and normal text


        public static void GetHlTypesAndNormal(StringCollection description, int index, FlowDocument document)
        {
            Paragraph paragraph = new Paragraph();
            int count = 0;
            foreach (string s in description[index].SplitAndKeep(CDConstant.Delimiters.StringArrayToCharArray()))
            {
                // Get hyperlink
                if (IsHyperlink(s, paragraph))
                    continue;

                // Get types 
                if (IsType(s, paragraph))
                    continue;

                // Get normal text
                paragraph.Inlines.Add(new Run(s));
                count += 1;
            }

            document.Blocks.Add(paragraph);
        }


        #endregion // End Hyperlink, type and normal text


    }
}
