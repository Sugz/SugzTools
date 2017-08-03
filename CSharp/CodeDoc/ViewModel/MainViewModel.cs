using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.WindowsAPICodePack.Dialogs;
using System;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Timers;

namespace CodeDoc.ViewModel
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


        private CDConfig _Config = new CDConfig();
        private string _Status = string.Empty;
        private int _Progress = 0;
        private RelayCommand _AddFolderCommand;
        private RelayCommand _SaveConfigCommand;
        Timer timer = new Timer() { Interval = 5000 };

        #endregion Fields


        #region Properties


        /// <summary>
        /// 
        /// </summary>
        public string Status
        {
            get { return _Status; }
            set { Set(ref _Status, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public int Progress
        {
            get { return _Progress; }
            set { Set(ref _Progress, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<CDFolder> Folders { get; private set; } = new ObservableCollection<CDFolder>();

        /// <summary>
        /// 
        /// </summary>
        public RelayCommand AddFolderCommand
        {
            get { return _AddFolderCommand ?? (_AddFolderCommand = new RelayCommand(AddFolder)); ; }
        }

        /// <summary>
        /// 
        /// </summary>
        public RelayCommand SaveConfigCommand
        {
            get { return _SaveConfigCommand ?? (_SaveConfigCommand = new RelayCommand(SaveConfig)); ; }
        }


        #endregion Properties


        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            string libs = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Libs";
            string scripts = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Scripts";
            Folders.Add(new CDFolder(libs));
            Folders.Add(new CDFolder(scripts));
        }


        #endregion Constructor


        #region Methods


        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}


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
                CDFolder folder = new CDFolder(selectedFolder);

                // Only add a folder if it doesn't already exist in Folders
                if (!Folders.Any(x => x.Equals(folder)))
                    Folders.Add(folder);
            }

        }


        /// <summary>
        /// 
        /// </summary>
        private void SaveConfig()
        {
            BackgroundWorker worker = new BackgroundWorker();
            worker.WorkerReportsProgress = true;
            worker.DoWork += (object sender, DoWorkEventArgs e) => _Config.ExportConfig(Folders, worker);
            worker.ProgressChanged += (object sender, ProgressChangedEventArgs e) => Progress = e.ProgressPercentage;
            worker.RunWorkerCompleted += (object sender, RunWorkerCompletedEventArgs e) => DisplaySatus("The config has been exported");
            worker.RunWorkerAsync();
        }


        /// <summary>
        /// Set the UI status message for 5 seconds
        /// </summary>
        /// <param name="status"></param>
        private void DisplaySatus(string status)
        {
            Status = status;
            timer.Elapsed += (s, ev) =>
            {
                Status = string.Empty;
                timer.Enabled = false;
            };
            timer.Enabled = true;
        }


        #endregion Methods

    }
}