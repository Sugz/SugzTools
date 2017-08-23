using CodeDoc.Controls;
using CodeDoc.Model;
using SugzTools.Extensions;
using SugzTools.Src;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Media;

namespace CodeDoc.Src
{
    public static class CDParser
    {

        #region Formating


        /// <summary>
        /// Return a hyperlink
        /// </summary>
        /// <param name="str">The text and link</param>
        /// <param name="color">The text foreground</param>
        /// <param name="overColor">The text foreground when the mouse is over</param>
        /// <returns>A formated hyperlink</returns>
        public static Hyperlink GetHyperLink(string text, Color? color, Color? overColor)
        {
            return (GetHyperLink(text, text, color, overColor));
        }


        /// <summary>
        /// Return a hyperlink
        /// </summary>
        /// <param name="str">The text</param>
        /// <param name="uri">The link</param>
        /// <param name="color">The text foreground</param>
        /// <param name="overColor">The text foreground when the mouse is over</param>
        /// <returns>A formated hyperlink</returns>
        public static Hyperlink GetHyperLink(string text, string uri, Color? color, Color? hoverColor)
        {
            Run run = new Run(text);
            run.FontStyle = FontStyles.Italic;
            run.TextDecorations = TextDecorations.Underline;

            if (color != null)
                run.Foreground = new SolidColorBrush((Color)color);

            if (hoverColor != null)
            {
                run.MouseEnter += (s, e) => run.Foreground = new SolidColorBrush((Color)hoverColor);
                run.MouseLeave += (s, e) => run.Foreground = new SolidColorBrush((Color)color);
            }

            Hyperlink hyperlink = new Hyperlink(run);
            hyperlink.NavigateUri = new Uri(uri);
            hyperlink.RequestNavigate += (s, e) => Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri));

            return hyperlink;
        }


        /// <summary>
        /// Check if a string is a hyperlink and return it
        /// </summary>
        /// <param name="s">The string to check and format as hyperlink</param>
        /// <returns>A hyperlink or null</returns>
        public static Hyperlink FormatHyperlink(string text)
        {
            if (CDConstants.LinkParser.IsMatch(text))
                return GetHyperLink(text, Colors.CornflowerBlue, Colors.DeepSkyBlue);
            return null;
        }


        /// <summary>
        /// Check if a string is an email and return a mail generator if so
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static Run FormatEmail(string adress)
        {
            if (adress.Contains("@"))
            {
                Run run = new Run(adress) { Style = (Style)Application.Current.Resources["EmailRunStyle"] };
                string mailto = Uri.EscapeUriString($"mailto:{adress}?&Body=\n\n\nSend from SugzTools CodeDoc");
                run.MouseDown += (s, e) => Process.Start(mailto);
                return run;
            }
            return null;
        }


        /// <summary>
        /// Get Hyperlinks, email, and type from a string
        /// </summary>
        /// <param name="text"></param>
        /// <returns></returns>
        public static Paragraph FormatText(string text)
        {
            Paragraph paragraph = new Paragraph();
            foreach (string str in text.SplitAndKeep(CDConstants.Delimiters))
            {
                if (FormatHyperlink(str) is Hyperlink hyperlink)
                    paragraph.Inlines.Add(hyperlink);
                else if (FormatEmail(str) is Run email)
                    paragraph.Inlines.Add(email);
                else
                    paragraph.Inlines.Add(new Run(str));
            }
            return paragraph;
        }


        /// <summary>
        /// Format a collection of string as list
        /// </summary>
        /// <param name="values"></param>
        /// <returns></returns>
        public static List FormatList(StringCollection values, Thickness margin)
        {
            List list = new List() { Margin = margin };
            foreach (string str in values)
            {
                Paragraph paragraph = FormatText(str.TrimStart(CDConstants.VersionTrimChars));
                list.ListItems.Add(new ListItem(paragraph));
            }
            return list;
        }


        /// <summary>
        /// Format description titles
        /// </summary>
        /// <param name="title"></param>
        /// <returns></returns>
        public static Paragraph FormatTitle(string title)
        {
            Run run = new Run($"\n{title}");
            run.Foreground = Resource<SolidColorBrush>.GetColor("MaxBlue");
            run.FontStyle = FontStyles.Italic;
            run.FontWeight = FontWeights.DemiBold;
            return new Paragraph(run);
        }


        public static Paragraph FormatFunctionName(string name)
        {
            Paragraph paragraph = new Paragraph();
            foreach (string str in Regex.Split(name, @"(?<=[ :])"))
            {
                Run run = new Run(str);
                if (str.EndsWith(":"))
                {
                    run.Foreground = new SolidColorBrush(Color.FromArgb(255, 185, 185, 185));
                    run.FontStyle = FontStyles.Italic;
                }
                paragraph.Inlines.Add(run);
            }
            return paragraph;
        }



        /// <summary>
        /// Format history as table with lists in front of the version
        /// </summary>
        /// <param name="history"></param>
        /// <returns></returns>
        public static Table FormatHistory(Dictionary<string, StringCollection> history)
        {
            Table table = new Table() { CellSpacing = 0, Margin = new Thickness(0, 2, 0, 0) };
            table.Columns.Add(new TableColumn() { Width = new GridLength(30) });
            table.Columns.Add(new TableColumn());
            table.RowGroups.Add(new TableRowGroup());

            foreach (KeyValuePair<string, StringCollection> version in history)
            {
                table.RowGroups[0].Rows.Add(new TableRow());
                table.RowGroups[0].Rows.Last().Cells.Add(new TableCell(new Paragraph(new Run(version.Key))));

                List list = FormatList(version.Value, new Thickness(0, 0, 0, 10));
                table.RowGroups[0].Rows.Last().Cells.Add(new TableCell(list));
            }

            return table;
        }


        #endregion Formating



        #region Script


        /// <summary>
        /// Parse a script description
        /// </summary>
        /// <param name="description"></param>
        /// <returns></returns>
        public static Dictionary<string, object> ParseScriptDescription(StringCollection description)
        {
            Dictionary<string, object> dictonary = new Dictionary<string, object>();

            // Store the intro
            // TODO: include in a complete for loop to avoid intro that do not contain 4 lines
            for (int i = 0; i < 4; i++)
                dictonary.Add(CDConstants.ScriptIntro[i], description[i]);

            // Store the rest of the description
            for (int i = 4; i < description.Count; i++)
            {
                // Get the next title
                int titleIndex = Array.FindIndex(CDConstants.ScriptDescription, x => description[i] == x);
                if (titleIndex != -1)
                {
                    int j = i + 1;

                    //History case
                    if (titleIndex == 4)
                    {
                        // Get the version number as key and store the rest to the last key until next version number or another title
                        Dictionary<string, StringCollection> versions = new Dictionary<string, StringCollection>();
                        while (j < description.Count && Array.FindIndex(CDConstants.ScriptDescription, x => description[j] == x) == -1)
                        {
                            string curStr = description[j].TrimEnd(":".ToCharArray());
                            if (float.TryParse(curStr, out float f))
                                versions.Add(curStr, new StringCollection());
                            else
                                versions.Values.Last().Add(description[j]);
                            j++;
                        }
                        dictonary.Add(CDConstants.ScriptDescription[titleIndex], versions.Count != 0 ? versions : null);
                    }
                    else
                    {
                        // Store the description until finding a title
                        StringCollection strs = new StringCollection();
                        while (j < description.Count && Array.FindIndex(CDConstants.ScriptDescription, x => description[j] == x) == -1)
                        {
                            strs.Add(description[j]);
                            j++;
                        }
                        dictonary.Add(CDConstants.ScriptDescription[titleIndex], strs.Count != 0 ? strs : null);
                    }
                }
            }

            return dictonary;
        }


        /// <summary>
        /// Get a formated script description
        /// </summary>
        /// <param name="script"></param>
        /// <returns></returns>
        public static void FormatScriptDescription(CDScript script, ref FlowDocument document)
        {
            // Get each part of the description associated with their titles
            if (script.Description is StringCollection scriptDescription)
            {
                foreach (KeyValuePair<string, object> pair in ParseScriptDescription(scriptDescription))
                {
                    // Format the intro
                    if (CDConstants.ScriptIntro.Contains(pair.Key))
                    {
                        // Format the email
                        if (FormatEmail((string)pair.Value) is Run email)
                            document.Blocks.Add(new Paragraph(email));
                        else
                            document.Blocks.Add(new Paragraph(new Run((string)pair.Value)));
                    }

                    // Format only titles that have a value (ICollection is as common interface between StringCollection and Dictionary)
                    else if (pair.Value is ICollection values)
                    {
                        // Format titles
                        document.Blocks.Add(FormatTitle(pair.Key.TrimLast()));

                        // Format History
                        if (values is Dictionary<string, StringCollection> history)
                            document.Blocks.Add(FormatHistory(history));
                        else
                        {
                            // Format as a list if the StringCollection count is greater than one
                            if (values.Count > 1)
                                document.Blocks.Add(FormatList((StringCollection)values, new Thickness(0, 2, 0, 0)));
                            else if (values.Count == 1)
                                document.Blocks.Add(FormatText(((StringCollection)values)[0]));
                        }
                    }
                }
            }
        }


        /// <summary>
        /// Format and add to a script a full description
        /// </summary>
        /// <param name="script"></param>
        /// <param name="description"></param>
        public static void SaveScriptDescription(CDScript script, Dictionary<string, string> description)
        {
            StringBuilder stringBuilder = new StringBuilder();
            stringBuilder.AppendLine(CDConstants.ScriptDescriptionStart);
            foreach (KeyValuePair<string, string> pair in description)
            {
                // Format the intro
                if (CDConstants.ScriptIntro.Contains(pair.Key))
                    stringBuilder.Append(pair.Value);

                // Format only titles that have a value
                else if (pair.Value != string.Empty)
                {
                    stringBuilder.Append($"\n# {pair.Key}\n");
                    stringBuilder.Append(pair.Value);
                }
            }

            stringBuilder.AppendLine($"\n{CDConstants.UseModifyScript}");
            stringBuilder.AppendLine($"{CDConstants.ScriptDescriptionEnd}\n\n");

            Console.WriteLine(stringBuilder.ToString());
        }


        #endregion Script



        #region Function


        /// <summary>
        /// Parse a function description
        /// </summary>
        /// <param name="description"></param>
        /// <returns></returns>
        public static Dictionary<string, object> ParseFunctionDescription(StringCollection description)
        {
            Dictionary<string, object> dictonary = new Dictionary<string, object>();
            dictonary.Add(CDConstants.FnDescription[0], new StringCollection() { description[0] });

            for (int i = 1; i < description.Count; i++)
            {
                // Get the next title
                int titleIndex = Array.FindIndex(CDConstants.FnDescription, x => description[i] == x);
                if (titleIndex != -1)
                {
                    int j = i + 1;

                    // Description case
                    if (titleIndex == 0)
                    {
                        StringCollection strs = dictonary.Values.First() as StringCollection;
                        while (j < description.Count && Array.FindIndex(CDConstants.FnDescription, x => description[j] == x) == -1)
                        {
                            // legacy description
                            if (description[j] != strs[0])
                                strs.Add(description[j]);
                            j++;
                        }
                    }
                    else
                    {
                        // Store the description until finding a title
                        StringCollection strs = new StringCollection();
                        while (j < description.Count && Array.FindIndex(CDConstants.FnDescription, x => description[j] == x) == -1)
                        {
                            strs.Add(description[j]);
                            j++;
                        }
                        dictonary.Add(CDConstants.FnDescription[titleIndex], strs.Count != 0 ? strs : null);
                    }
                }
            }

            return dictonary;
        }

        /// <summary>
        /// Get a formated function description
        /// </summary>
        /// <param name="function"></param>
        /// <param name="document"></param>
        public static void FormatFunctionDescription(CDFunction function, ref FlowDocument document)
        {
            // Add the function text in the begining of the description
            document.Blocks.Add(FormatFunctionName(function.Name));

            // Get each part of the description associated with their titles
            foreach (KeyValuePair<string, object> pair in ParseFunctionDescription(function.Description))
            {
                // Format only titles that have a value
                if (pair.Value is StringCollection values)
                {
                    // Format titles
                    document.Blocks.Add(FormatTitle(pair.Key.TrimLast()));

                    // Description case
                    if (pair.Key == CDConstants.FnDescription[0])
                    {
                        foreach(string s in values)
                            document.Blocks.Add(FormatText(s));
                    }
                    else
                    {
                        // Format as a list if the StringCollection count is greater than one
                        if (values.Count > 1)
                            document.Blocks.Add(FormatList(values, new Thickness(0, 2, 0, 0)));
                        else if (values.Count == 1)
                            document.Blocks.Add(FormatText(values[0]));
                    }
                }
            }
        }


        #endregion Function



        #region Folder


        /// <summary>
        /// Get a formated description of a folder
        /// </summary>
        /// <param name="script"></param>
        /// <returns></returns>
        public static void FormatFolderDescription(CDFolder folder, ref FlowDocument document)
        {
            // Format the list of children
            List scripts = new List() { Margin = new Thickness(0, 7, 0, 0) };
            foreach (CDScript child in folder.Children)
            {
                Run run = new Run(child.Text);
                run.Style = (Style)Application.Current.Resources["FolderChildrenRunStyle"];
                run.MouseDown += (s, e) =>
                {
                    folder.IsExpanded = true;
                    folder.IsSelected = false;
                    child.IsSelected = true;
                };
                scripts.ListItems.Add(new ListItem(new Paragraph(run)) { Margin = new Thickness(0, 5, 0, 5) });
            }

            document.Blocks.Add(new Paragraph(new Run(folder.Text)));
            document.Blocks.Add(scripts);
        }


        #endregion Folder



        #region Dispatch


        /// <summary>
        /// Get the formated description of all DataItem types
        /// </summary>
        /// <param name="item"></param>
        /// <param name="document"></param>
        public static void FormatDataItemDescription(CDDataItem item, ref FlowDocument document)
        {
            if (item is CDFolder folder)
                FormatFolderDescription(folder, ref document);
            else if (item is CDScript script)
                FormatScriptDescription(script, ref document);
            else if (item is CDFunction function)
                FormatFunctionDescription(function, ref document);
        }


        /// <summary>
        /// Format and add to a dataitem a full description
        /// </summary>
        /// <param name="item"></param>
        /// <param name="description"></param>
        public static void SaveDataItemDescription(IReadableItem item, Dictionary<string, string> description)
        {
            if (item is CDScript script)
                SaveScriptDescription(script, description);
        } 


        #endregion Dispatch
    }
}
