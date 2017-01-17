using System;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using SvgToXaml.Model;
using System.Collections.ObjectModel;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.IO;
using System.Linq;
using System.ComponentModel;

namespace SvgToXaml.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// See http://www.mvvmlight.net
    /// </para>
    /// </summary>
    public class MainViewModel : ViewModelBase
    {

        #region Fields

        
        private readonly IDataService _dataService;
        private readonly BackgroundWorker worker = new BackgroundWorker();
        private int _SvgCount;
        private string _Status;
        private int _Progress;
        private string _SaveFolder;
        private RelayCommand _AddFolderCommand;
        private RelayCommand _ProcessCommand;
        private RelayCommand<string> _RemoveFolderCommand;


        #endregion Fields



        #region Properties


        /// <summary>
        /// Gets the Status property.
        /// </summary>
        public string Status
        {
            get { return _Status; }
            private set { Set(ref _Status, value); }
        }

        
        /// <summary>
        /// 
        /// </summary>
        public int Progress
        {
            get { return _Progress; }
            private set { Set(ref _Progress, value); }
        }


        /// <summary>
        /// The folders to process
        /// </summary>
        public ObservableCollection<Folder> Folders { get; private set; } = new ObservableCollection<Folder>();
        

        /// <summary>
        /// Let the user choose a folder to add to the processing list
        /// </summary>
        public RelayCommand AddFolderCommand
        {
            get { return  _AddFolderCommand ?? (_AddFolderCommand = new RelayCommand(AddFolder)); ; }
        }


        /// <summary>
        /// Remove a folder from Folders
        /// </summary>
        public RelayCommand<string> RemoveFolderCommand
        {
            get
            {
                return _RemoveFolderCommand ?? (_RemoveFolderCommand = new RelayCommand<string>(
                    path => Folders.Remove(Folders.Single(x => x.Path == path)))
                );
            }
        }


        /// <summary>
        /// Process all the svg files contain in the folders
        /// </summary>
        public RelayCommand ProcessCommand
        {
            get { return  _ProcessCommand ?? (_ProcessCommand = new RelayCommand(Convert, CanConvert)); }
        }




        #endregion Properties



        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel(IDataService dataService)
        {
            _dataService = dataService;
            _dataService.GetData(
                (item, error) =>
                {
                    if (error != null)
                    {
                        // Report error here
                        return;
                    }
                });

            SetWorker();
        }




        #endregion Constructor



        #region Methods


        /// <summary>
        /// Set the BackgroundWorker properties and events
        /// </summary>
        private void SetWorker()
        {
            worker.WorkerReportsProgress = true;
            worker.DoWork += Worker_DoWork;
            worker.ProgressChanged += (s, e) =>
            {
                Progress = e.ProgressPercentage;
                Status = $"{Progress} %";
            };
            worker.RunWorkerCompleted += (s, e) =>
            {
                Progress = 0;
                Status = "Done !";
            };
        }



        /// <summary>
        /// Use CommonOpenFileDialog to select a folder
        /// </summary>
        /// <returns></returns>
        private string SelectFolder()
        {
            CommonOpenFileDialog commonOpenFileDialog = new CommonOpenFileDialog();
            commonOpenFileDialog.IsFolderPicker = true;
            CommonFileDialogResult result = commonOpenFileDialog.ShowDialog();

            if (result == CommonFileDialogResult.Ok && Directory.Exists(commonOpenFileDialog.FileName))
                return commonOpenFileDialog.FileName;
            return string.Empty;
        }



        /// <summary>
        /// Let the user choose a folder to add to the processing list
        /// </summary>
        private void AddFolder()
        {
            string selectedFolder = SelectFolder();
            if (selectedFolder != string.Empty)
            {
                Folder folder = new Folder(selectedFolder);

                // Only add a folder if it doesn't already exist in Folders
                if (!Folders.Any(x => x.Equals(folder)))
                    Folders.Add(folder);
            }
            
        }



        /// <summary>
        /// Check if there is some svg files in Folders
        /// </summary>
        /// <returns></returns>
        private bool CanConvert()
        {
            if (worker.IsBusy)
                return false;

            _SvgCount = 0;
            Status = "Add a folder";

            if (Folders.Count > 0)
            {
                foreach (Folder folder in Folders)
                    _SvgCount += folder.SvgCount;
                Status = $"{_SvgCount} SVG found";
            }

            return _SvgCount > 0;
        }



        /// <summary>
        /// Get _SaveFolder and execute the BackgroundWorker 
        /// </summary>
        private void Convert()
        {
            _SaveFolder = SelectFolder();
            worker.RunWorkerAsync();
        }



        /// <summary>
        /// Create an enum and a resource dictionay from a list of svg files
        /// </summary>
        private void Worker_DoWork(object sender, DoWorkEventArgs e)
        {
            if (_SaveFolder != string.Empty)
            {
                string enumStr = string.Empty;
                string resourceDictionaryStr = string.Empty;
                Writer writer = new Writer();
                int count = 1;

                foreach (Folder folder in Folders)
                {
                    DirectoryInfo folderInfo = new DirectoryInfo(folder.Path);
                    foreach (FileInfo file in folderInfo.GetFiles())
                    {
                        // Write the svg name and data
                        string data = GetSvgData(file.FullName);
                        if (data != string.Empty)
                        {
                            string svgName = $"{folder.Prefix}{GetSvgName(file.FullName)}";
                            enumStr += $"\n\t\t{svgName},";
                            resourceDictionaryStr += $"\n\t<PathGeometry x:Key=\"{svgName}\" Figures={data} />";
                        }

                        // Update the ProgressBar
                        worker.ReportProgress(count * 100 / _SvgCount);
                        count++;
                    }
                }

                writer.Write(_SaveFolder, enumStr, resourceDictionaryStr);
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
            string[] names = Path.GetFileNameWithoutExtension(svg).Split("- .".ToCharArray());
            foreach (string s in names)
                name += char.ToUpper(s[0]) + s.Substring(1);

            return name;
        }



        /// <summary>
        /// Get the first path data contain in a svg file
        /// </summary>
        /// <param name="svg"></param>
        /// <returns></returns>
        private string GetSvgData(string svg)
        {
            StreamReader reader = new StreamReader(svg);
            string line;
            while ((line = reader.ReadLine()) != null)
            {
                if (line.TrimStart('\t').StartsWith("<path"))
                {
                    int startIndex = line.IndexOf("d=");
                    int endIndex = line.Substring(startIndex + 3).IndexOf('"');
                    return line.Substring(startIndex + 2, endIndex + 2);
                }
            }

            reader.Close();
            return string.Empty;
        }


        #endregion Methods

    }
}