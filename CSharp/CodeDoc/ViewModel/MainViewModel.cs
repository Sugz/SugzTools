using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.WindowsAPICodePack.Shell;
using Microsoft.WindowsAPICodePack.Dialogs;
using System;
using System.Collections;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Timers;
using System.Windows.Input;
using System.Windows.Controls;
using System.Windows;

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

        private string _DataFolder = Properties.Settings.Default.DataFolder;

        private Visibility _ProgressBarVisibility = Visibility.Collapsed;
        private Visibility _PathFieldVisibility = Visibility.Collapsed;
        private bool _ShowOptionPanel = false;
        
        private Timer _Timer = new Timer() { Interval = 5000, AutoReset = false };
        private Cursor _Cursor = Cursors.Arrow;
        private CommonOpenFileDialog _OpenFileDialog;

        private CDConfig _Config;
        private ObservableCollection<CDFolder> _Folders = new ObservableCollection<CDFolder>();
        private ICDItem _TVSelectedItem;

        private string _Status = string.Empty;
        private int _Progress = 0;
        private string _PathField;
        private bool _CanValidatePath = false;

        private RelayCommand _AddFolderCommand;
        private RelayCommand _LoadConfigCommand;
        private RelayCommand _SaveConfigCommand;
        private RelayCommand _ValidatePathCommand;
        private RelayCommand _SetDataFolderCommand;
        private RelayCommand _ApplyDefaultsCommand;
        private RelayCommand _ShowOptionPanelCommand;

        #endregion Fields


        #region Properties


        /// <summary>
        /// 
        /// </summary>
        public string DataFolder
        {
            get { return _DataFolder; }
            set
            {
                Set(ref _DataFolder, value);
                Properties.Settings.Default.DataFolder = value;
                Properties.Settings.Default.Save();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public Visibility ProgressBarVisibility
        {
            get { return _ProgressBarVisibility; }
            set { Set(ref _ProgressBarVisibility, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public Visibility PathFieldVisibility
        {
            get { return _PathFieldVisibility; }
            set { Set(ref _PathFieldVisibility, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public bool ShowOptionPanel
        {
            get { return _ShowOptionPanel; }
            set { Set(ref _ShowOptionPanel, value); }
        }


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
        public Cursor Cursor
        {
            get { return _Cursor; }
            set { Set(ref _Cursor, value); }
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
        public ObservableCollection<CDFolder> Folders
        {
            get { return _Folders; }
            set { Set(ref _Folders, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public ICDItem TVSelectedItem
        {
            get { return _TVSelectedItem; }
            set
            {
                _TVSelectedItem = value;
                if (_TVSelectedItem is CDFile selectedItem)
                {
                    if (selectedItem.IsValidPath)
                    {
                        PathFieldVisibility = Visibility.Collapsed;
                        Status = selectedItem.Path;
                    }
                    else
                    {
                        Status = string.Empty;
                        PathField = selectedItem.Path;
                        PathFieldVisibility = Visibility.Visible;
                    }
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public string PathField
        {
            get { return _PathField; }
            set
            {
                _CanValidatePath = false;
                if (_TVSelectedItem is CDFile selectedItem)
                {
                    selectedItem.Path = value;
                    Set(ref _PathField, value);

                    if (selectedItem.IsValidPath)
                        _CanValidatePath = true;

                    ValidatePathCommand.RaiseCanExecuteChanged();
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand AddFolderCommand
        {
            get { return _AddFolderCommand ?? (_AddFolderCommand = new RelayCommand(AddFolder)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand LoadConfigCommand
        {
            get { return _LoadConfigCommand ?? (_LoadConfigCommand = new RelayCommand(LoadConfig)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand SaveConfigCommand
        {
            get { return _SaveConfigCommand ?? (_SaveConfigCommand = new RelayCommand(SaveConfig)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand ValidatePathCommand
        {
            get { return _ValidatePathCommand ?? (_ValidatePathCommand = new RelayCommand(ValidatePath, () => _CanValidatePath)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand SetDataFolderCommand
        {
            get { return _SetDataFolderCommand ?? (_SetDataFolderCommand = new RelayCommand(SetDataFolder)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand ApplyDefaultsCommand
        {
            get { return _ApplyDefaultsCommand ?? (_ApplyDefaultsCommand = new RelayCommand(ApplyDefaults)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand ShowOptionPanelCommand
        {
            get { return _ShowOptionPanelCommand ?? (_ShowOptionPanelCommand = new RelayCommand(() => ShowOptionPanel = !ShowOptionPanel)); }
        }


        #endregion Properties


        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            SetUp();

            //string libs = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Libs";
            //string scripts = Environment.GetEnvironmentVariable("LocalAppData") + @"\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Scripts";
            //Folders.Add(new CDFolder(libs));
            //Folders.Add(new CDFolder(scripts));
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
        private string SelectFolder(string initialPath = null)
        {
            DefineOpenFileDialog(initialPath);
            
            CommonFileDialogResult result = _OpenFileDialog.ShowDialog();
            if (result == CommonFileDialogResult.Ok && Directory.Exists(_OpenFileDialog.FileName))
                return _OpenFileDialog.FileName;
            return string.Empty;
        }


        /// <summary>
        /// 
        /// </summary>
        private void DefineOpenFileDialog(string initialPath)
        {
            if (_OpenFileDialog is null)
            {
                _OpenFileDialog = new CommonOpenFileDialog();
                _OpenFileDialog.IsFolderPicker = true;
                _OpenFileDialog.InitialDirectory = initialPath;
                foreach (DictionaryEntry environmentVariable in Environment.GetEnvironmentVariables())
                {
                    string key = environmentVariable.Key as string;
                    if (key.StartsWith("ADSK_3DSMAX_x64_"))
                    {
                        _OpenFileDialog.AddPlace(Environment.GetEnvironmentVariable("LocalAppData") + $@"\Autodesk\3dsMax\{key.Substring(key.Length - 4)} - 64bit\ENU\", FileDialogAddPlaceLocation.Top);
                        _OpenFileDialog.AddPlace((string)environmentVariable.Value, FileDialogAddPlaceLocation.Top);
                    }
                }
            }
        }


        /// <summary>
        /// Let the user choose a folder to add to the folders list if it doesn't exist already
        /// </summary>
        private void AddFolder()
        {
            if (SelectFolder() is string selectedFolder && !Folders.Any(x => x.Path.Equals(selectedFolder)))
                Folders.Add(new CDFolder(selectedFolder));
        }


        /// <summary>
        /// 
        /// </summary>
        private void SetUpConfig()
        {
            Progress = 0;
            Cursor = Cursors.Wait;
            ProgressBarVisibility = Visibility.Visible;
            _Config.Worker.ProgressChanged += (object sender, ProgressChangedEventArgs e) => Progress = e.ProgressPercentage;
        }


        /// <summary>
        /// 
        /// </summary>
        private void LoadConfig()
        {
            SetUpConfig();
            Status = CDConstants.LoadingData;
            _Config.Worker.DoWork += _Config.LoadConfig;
            _Config.Worker.RunWorkerCompleted += LoadConfigCompleted;
            _Config.Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LoadConfigCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            Folders = e.Result as ObservableCollection<CDFolder>;
            DisplaySatus(CDConstants.DataLoaded, true, true);
            Cursor = Cursors.Arrow;
            _Config.Worker.DoWork -= _Config.LoadConfig;
            _Config.Worker.RunWorkerCompleted -= LoadConfigCompleted;
        }


        /// <summary>
        /// 
        /// </summary>
        private void SaveConfig()
        {
            SetUpConfig();
            Status = CDConstants.SavingData;
            _Config.Worker.DoWork += SaveConfigWork;
            _Config.Worker.RunWorkerCompleted += SaveConfigCompleted;
            _Config.Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveConfigWork(object sender, DoWorkEventArgs e)
        {
            _Config.SaveConfig(Folders);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveConfigCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            DisplaySatus(CDConstants.DataSaved, true, true);
            Cursor = Cursors.Arrow;
            _Config.Worker.DoWork -= SaveConfigWork;
            _Config.Worker.RunWorkerCompleted -= SaveConfigCompleted;
        }


        /// <summary>
        /// Set the UI status message for 5 seconds
        /// </summary>
        /// <param name="status"></param>
        private void DisplaySatus(string status, bool useTimer = false, bool showProgressBar = false)
        {
            _Timer.Stop();

            Status = status;
            if (!showProgressBar)
                ProgressBarVisibility = Visibility.Collapsed;

            if (useTimer)
            {
                _Timer.Elapsed += (s, ev) =>
                {
                    ProgressBarVisibility = Visibility.Collapsed;
                    Status = string.Empty;
                };
                _Timer.Start();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        private void ValidatePath()
        {
            PathFieldVisibility = Visibility.Collapsed;
            if (_TVSelectedItem is CDFile selectedItem)
                Status = selectedItem.Path;
        }


        /// <summary>
        /// Create the CodeDoc appdata folder and set data.xml
        /// </summary>
        private void SetUp()
        {
            if (_DataFolder == string.Empty)
                DataFolder = CDConstants.AppDataFolder;
            _Config = new CDConfig(DataFolder);

            if (File.Exists(DataFolder + CDConstants.DataFile))
                LoadConfig();
            else
                DisplaySatus(CDConstants.DataNotFind, true);
        }


        /// <summary>
        /// Select a folder to store data.xml
        /// </summary>
        private void SetDataFolder()
        {
            if (SelectFolder(CDConstants.AppDataFolder) is string selectedFolder)
                DataFolder = selectedFolder;
        }


        /// <summary>
        /// Revert settings to their default value
        /// </summary>
        private void ApplyDefaults()
        {
            DataFolder = CDConstants.AppDataFolder;
        }


        #endregion Methods

    }
}