using System;
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
    public static class CDDescriptionParser
    {

        public static Hyperlink GetHyperLink(string str)
        {
            return (GetHyperLink(str, str));
        }


        public static Hyperlink GetHyperLink(string str, string uri)
        {
            return (GetHyperLink(str, str, null));
        }


        public static Hyperlink GetHyperLink(string str, string uri, Color? color)
        {
            Run run = new Run(str);
            
            if (color != null)
                run.Foreground = new SolidColorBrush((Color)color);

            Hyperlink hyperlink = new Hyperlink(run);
            hyperlink.MouseEnter += (s, e) => Mouse.OverrideCursor = Cursors.Hand;
            hyperlink.MouseLeave += (s, e) => Mouse.OverrideCursor = Cursors.Arrow;
            hyperlink.MouseDown += (s, e) => Process.Start(uri);

            return hyperlink;
        }



        public static Hyperlink GetTypes(string str)
        {
            Hyperlink hyperlink = null;
            if (CDConstant.Numbers.Concat(CDConstant.Types.Keys.ToList()).Contains(str))
            {
                // Get Numbers
                if (CDConstant.Numbers.Contains(str))
                {
                    hyperlink = GetHyperLink(str, "http://help.autodesk.com/view/3DSMAX/2016/ENU/?guid=__files_GUID_B57EA575_DCDE_42F5_9D30_88E3EB41F350_htm", Color.FromArgb(255, 0, 150, 0));
                }

                // Get other values
                else
                {
                    hyperlink = GetHyperLink(str, CDConstant.Types[str], Color.FromArgb(255, 0, 150, 0));
                }
            }

            return hyperlink;
        }



        public static Paragraph ParseScript(StringCollection strs)
        {
            Paragraph paragraph = new Paragraph();

            for (int i = 0; i < strs.Count; i++)
            {
                // Skip empty strings
                if (strs[i] == "")
                {
                    continue;
                }


                // Get hyperlink
                if (CDConstant.LinkParser.Matches(strs[i]).Count != 0)
                {
                    string[] line = strs[i].Split(" ".ToCharArray());
                    foreach (string l in line)
                    {
                        if (CDConstant.LinkParser.IsMatch(l))
                        {
                            paragraph.Inlines.Add(GetHyperLink(l));
                            paragraph.Inlines.Add(new Run(" "));
                        }  
                        else
                        {
                            paragraph.Inlines.Add(new Run(l + " "));
                        }   
                    }

                    paragraph.Inlines.Add(new Run("\n"));
                    continue;
                }



                // Check for titles
                if (strs[i].StartsWith("#"))
                {
                    // Check if there is infos after the title, otherwise skip it
                    if (!(strs[i + 1] == ""))
                    {
                        Run run = new Run("\n" + strs[i].TrimStart("# ".ToCharArray()) + "\n");
                        run.Foreground = new SolidColorBrush(Color.FromArgb(255, 150, 150, 150));
                        run.FontStyle = FontStyles.Italic;
                        paragraph.Inlines.Add(run);
                    }
                }


                // Just use standard text and avoid empty categories
                else
                {
                    paragraph.Inlines.Add(new Run(strs[i] + "\n"));
                }
            }

            return paragraph;

        }


        public static Paragraph ParseFunction(StringCollection strs)
        {
            Paragraph paragraph = new Paragraph();

            // Parse the function declaration
            foreach (string s in strs[0].Split(' '))
            {
                if (s.Contains(":"))
                {
                    string[] argName = s.Split(':');
                    Run run = new Run(argName[0] + ":");
                    run.Foreground = new SolidColorBrush(Color.FromArgb(255, 150, 150, 150));
                    run.FontStyle = FontStyles.Italic;
                    paragraph.Inlines.Add(run);

                    if (argName.Count() > 1)
                        paragraph.Inlines.Add(new Run(argName[1] + " "));
                }
                else
                {
                    paragraph.Inlines.Add(new Run(s + " "));
                }

            }
            paragraph.Inlines.Add(new Run("\n"));

            // Parse the function description
            for (int i = 1; i < strs.Count; i++)
            {
                // Skip empty strinsg
                if (strs[i] == "")
                    continue;


                // Get titles
                if (strs[i].EndsWith(":"))
                {
                    // Check if there is infos after the title, otherwise skip it
                    if (!(strs[i+1] == ""))
                    {
                        Run run = new Run("\n" + strs[i]);
                        run.Foreground = new SolidColorBrush(Color.FromArgb(255, 150, 150, 150));
                        run.FontStyle = FontStyles.Italic;
                        paragraph.Inlines.Add(run);
                    }
                }


                // Get hyperlink
                else if (CDConstant.LinkParser.Matches(strs[i]).Count != 0)
                {
                    string[] line = strs[i].Split(" ".ToCharArray());
                    foreach (string l in line)
                    {
                        if (CDConstant.LinkParser.IsMatch(l))
                        {
                            paragraph.Inlines.Add(GetHyperLink(l));
                            paragraph.Inlines.Add(new Run(" "));
                        }
                        else
                        {
                            paragraph.Inlines.Add(new Run(l + " "));
                        }
                    }

                    paragraph.Inlines.Add(new Run("\n"));
                    continue;
                }


                // Get lines that contains types that need to be transform as hyperlink
                else if (CDConstant.Numbers.Concat(CDConstant.Types.Keys.ToList()).Any(strs[i].Contains))
                {
                    foreach (string s in strs[i].Split("<> ".ToCharArray()))
                    {
                        Hyperlink hl = GetTypes(s);

                        // Skip empty strings
                        if (s == "")
                            continue;

                        if (hl != null)
                        {
                            paragraph.Inlines.Add(hl);
                            paragraph.Inlines.Add(new Run(" "));
                        }
                        else
                        {
                            paragraph.Inlines.Add(new Run(s + " "));
                        }
                    }
                }
                    


                // Just use standard text and avoid empty categories
                else
                {
                    paragraph.Inlines.Add(new Run(strs[i]));
                }
                
                paragraph.Inlines.Add(new Run("\n"));
            }

            return paragraph;
        }
    }
}
