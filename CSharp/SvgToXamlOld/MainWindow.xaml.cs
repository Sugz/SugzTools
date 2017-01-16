using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.Windows.Threading;
using System.Collections.ObjectModel;

namespace SvgToXaml
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {

        private string _Status = "Not Ready";
        public string Status
        {
            get { return _Status; }
            set { _Status = value; }
        }

        public ObservableCollection<Folder> Folders { get; set; }
        

        



        public MainWindow()
        {
            InitializeComponent();
            Folders = new ObservableCollection<Folder>();
            folderListBox.ItemsSource = Folders;
        }

        private void AddFolder(object sender, RoutedEventArgs e)
        {
            CommonOpenFileDialog commonOpenFileDialog = new CommonOpenFileDialog();
            commonOpenFileDialog.IsFolderPicker = true;
            CommonFileDialogResult result = commonOpenFileDialog.ShowDialog();

            if (result == CommonFileDialogResult.Ok && Directory.Exists(commonOpenFileDialog.FileName))
            {
                Folders.Add(new Folder(commonOpenFileDialog.FileName));
            }

        }



        /*
        private void processBtn_Click(object sender, RoutedEventArgs e)
        {
            if (Directory.Exists(svgFolder) && Directory.Exists(xamlFolder))
            {
                // Create the enum base and resource dict base
                string enumStr = CreateSvgsEnum();
                string resourceDictionaryStr = CreateSvgsResourceDictionary();

                // Don't add svg that don't have a path value
                DirectoryInfo svgFolderInfo = new DirectoryInfo(svgFolder);
                int filesCount = svgFolderInfo.GetFiles().Length;
                int count = 0;

                foreach (FileInfo file in svgFolderInfo.GetFiles())
                {
                    // Write the svg name and data
                    string data = GetSvgData(file.FullName);
                    if (data != string.Empty)
                    {
                        string svgName = GetSvgName(file.FullName);
                        enumStr += $"\n\t\t{svgName},";
                        resourceDictionaryStr += $"\n\t<PathGeometry x:Key=\"{svgName}\" Figures={data} />";
                    }

                    // Update the ProgressBar
                    count++;
                    progressBar.Dispatcher.Invoke(() => progressBar.Value = (count * 100) / filesCount, DispatcherPriority.Background);
                    progressBarTxt.Text = $"{progressBar.Value.ToString()} %";
                }


                // End and write the files
                StreamWriter writer = new StreamWriter(xamlFolder + "\\MdiEnum.cs", false);
                writer.Write($"{enumStr}\n\t}}\n}}\n");
                writer.Close();

                writer = new StreamWriter(xamlFolder + "\\Mdi.xaml", false);
                writer.Write($"{resourceDictionaryStr}\n\n</ResourceDictionary>\n");
                writer.Close();

                progressBarTxt.Text = "Done";
            }
        }


        /// <summary>
        /// Get the svg and xaml folders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void GetFolders(object sender, RoutedEventArgs e)
        {
            CommonOpenFileDialog commonOpenFileDialog = new CommonOpenFileDialog();
            commonOpenFileDialog.IsFolderPicker = true;
            CommonFileDialogResult result = commonOpenFileDialog.ShowDialog();

            if (result == CommonFileDialogResult.Ok && Directory.Exists(commonOpenFileDialog.FileName))
            {
                if (sender == svgFolderBtn)
                    svgFolder = commonOpenFileDialog.FileName;
                else if (sender == xamlFolderBtn)
                    xamlFolder = commonOpenFileDialog.FileName;
                else
                {
                    svgFolder = commonOpenFileDialog.FileName + "\\svg";
                    xamlFolder = commonOpenFileDialog.FileName + "\\xaml";
                }

                svgFolderTxt.Text = svgFolder;
                xamlFolderTxt.Text = xamlFolder;

            }
                
        }


        /// <summary>
        /// Get the svg formated name
        /// </summary>
        /// <param name="svg"></param>
        /// <returns></returns>
        private string GetSvgName(string svg)
        {
            string name = string.Empty;
            string[] names = Path.GetFileNameWithoutExtension(svg).Split('-');
            foreach (string s in names)
            {
                char[] c = s.ToCharArray();
                c[0] = char.ToUpper(c[0]);
                name += new string(c);
            }

            return name;
        }


        /// <summary>
        /// Get the first path data contain in a svg file
        /// </summary>
        /// <param name="svg"></param>
        /// <returns></returns>
        private string GetSvgData(string svg)
        {
            string path = string.Empty;
            string line;
            int startIndex = 0;
            int endIndex = 0;


            StreamReader svgReader = new StreamReader(svg);
            while ((line = svgReader.ReadLine()) != null)
            {
                if (line.TrimStart('\t').StartsWith("<path"))
                {
                    path = line.TrimStart('\t');
                    break;
                }
            }

            svgReader.Close();

            for (int i = 0; i < path.Length; i++)
            {
                if (path[i] == '=' && path[i - 1] == 'd')
                    startIndex = i + 1;
                if (path[i] == '"' && startIndex != 0 && i > startIndex)
                {
                    endIndex = i + 1;
                    break;
                }
            }


            //string data = path.Substring(startIndex, endIndex - startIndex);
            //return (data = data ?? "");
            return path.Substring(startIndex, endIndex - startIndex);
        }


        private string CreateSvgsEnum()
        {
            string enumStr = "//////////////////////////////////////////";
            enumStr += "\n/// Auto-generated file, do not modify ///";
            enumStr += "\n//////////////////////////////////////////";
            enumStr += "\n";
            enumStr += "\nnamespace SugzTools.Icons";
            enumStr += "\n{";
            enumStr += "\n\tpublic enum MDI";
            enumStr += "\n\t{";
            return enumStr;
        }


        private string CreateSvgsResourceDictionary()
        {
            string resourceDictionary = "<!--////////////////////////////////////-->";
            resourceDictionary += "\n<!-- Auto-generated file, do not modify -->";
            resourceDictionary += "\n<!--////////////////////////////////////-->";
            resourceDictionary += "\n";
            resourceDictionary += "\n<ResourceDictionary xmlns=\"http://schemas.microsoft.com/winfx/2006/xaml/presentation\"";
            resourceDictionary += "\n\t\t\t\t\txmlns:x=\"http://schemas.microsoft.com/winfx/2006/xaml\">";
            resourceDictionary += "\n";
            return resourceDictionary;
        }
        */
    }
}
