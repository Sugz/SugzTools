using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using SugzTools.Src;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Input;
using System.Xml;
using System.Xml.Linq;

namespace CodeDoc.ViewModel
{
    public class DataViewModel : ViewModelBase, IDataErrorInfo
    {

        #region Fields

        private string _DataFile;
        private bool _CanValidateDataPath = false;
        private int _ItemCount = 0;
        private CDBrowser _Browser = new CDBrowser();
        private BackgroundWorker _Worker = new BackgroundWorker() { WorkerReportsProgress = true };
        private XmlTextWriter _Writer;
        
        private string _DataFolder;
        private ObservableCollection<CDFolder> _Datas = new ObservableCollection<CDFolder>();
        private bool _ShowSelectedItemPath;
        private ICDItem _TVSelectedItem;
        private string _DataPathField;
        private Visibility _DataPathFieldVisibility = Visibility.Collapsed;
        private Cursor _Cursor = Cursors.Arrow;
        private int _Progress = 0;

        private RelayCommand _SetDataFolderCommand;
        private RelayCommand _AddFolderCommand;
        private RelayCommand _LoadConfigCommand;
        private RelayCommand _SaveConfigCommand;
        private RelayCommand _ValidateDataPathCommand;

        #endregion Fields


        #region Properties


        string IDataErrorInfo.Error => string.Empty;

        string IDataErrorInfo.this[string name]
        {
            get
            {
                if (name == "DataPathField" && !_CanValidateDataPath)
                    return CDConstants.InvalidPath;

                return null;
            }
        }



        /// <summary>
        /// The folder use to store Data.xml
        /// </summary>
        public string DataFolder
        {
            get { return _DataFolder; }
            set
            {
                Set(ref _DataFolder, value);
                _DataFile = value + CDConstants.DataFile;
                Properties.Settings.Default.DataFolder = value;
                Properties.Settings.Default.Save();
            }
        }

        /// <summary>
        /// The collection of CDFolders that will be displayed in the treeview
        /// </summary>
        public ObservableCollection<CDFolder> Datas
        {
            get { return _Datas; }
            set { Set(ref _Datas, value); }
        }


        
        /// <summary>
        /// 
        /// </summary>
        public bool ShowSelectedItemPath
        {
            get { return _ShowSelectedItemPath; }
            set
            {
                Set(ref _ShowSelectedItemPath, value);
                Properties.Settings.Default.ShowSelectedItemPath = value;
                Properties.Settings.Default.Save();
                SetStatusPanel();
            }
        }


        //TODO: merge with SetStatusPanel method
        /// <summary>
        /// 
        /// </summary>
        public ICDItem TVSelectedItem
        {
            get { return _TVSelectedItem; }
            set
            {
                _TVSelectedItem = value;
                SetStatusPanel();
                //if (_TVSelectedItem is CDFile selectedItem)
                //{
                //    if (selectedItem.IsValidPath)
                //    {
                //        DataPathFieldVisibility = Visibility.Collapsed;
                //        if (ShowSelectedItemPath)
                //            MessengerInstance.Send(new CDStatusMessage(selectedItem.Path, false, false));
                //    }
                //    else
                //    {
                //        DataPathFieldVisibility = Visibility.Visible;
                //        DataPathField = selectedItem.Path;
                //        MessengerInstance.Send(new CDStatusMessage(string.Empty, false, false));
                //    }
                //}
            }
        }


        /// <summary>
        /// 
        /// </summary>
        public string DataPathField
        {
            get { return _DataPathField; }
            set
            {
                _CanValidateDataPath = false;
                if (TVSelectedItem is CDFile selectedItem)
                {
                    Set(ref _DataPathField, value);
                    selectedItem.Path = value;
                    if (selectedItem.IsValidPath)
                        _CanValidateDataPath = true;

                    ValidateDataPathCommand.RaiseCanExecuteChanged();
                }
            }
        }


        /// <summary>
        /// Set the visibility of the ProgressBar
        /// </summary>
        public Visibility ProgressBarVisibility
        {
            set => MessengerInstance.Send(new GenericMessage<Visibility>(value));
        }

        
        /// <summary>
        /// 
        /// </summary>
        public Visibility DataPathFieldVisibility
        {
            get { return _DataPathFieldVisibility; }
            set { Set(ref _DataPathFieldVisibility, value); }
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
        public RelayCommand SetDataFolderCommand
        {
            get { return _SetDataFolderCommand ?? (_SetDataFolderCommand = new RelayCommand(SetDataFolder)); }
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
        public RelayCommand ValidateDataPathCommand
        {
            get { return _ValidateDataPathCommand ?? (_ValidateDataPathCommand = new RelayCommand(SetStatusPanel, () => _CanValidateDataPath)); }
        }




        #endregion Properties


        #region Constructor


        public DataViewModel()
        {
            _Worker.ProgressChanged += (object sender, ProgressChangedEventArgs e) => Progress = e.ProgressPercentage;
            MessengerInstance.Register<NotificationMessage>(this, x => DataFolder = x.Notification);

            InitializeData();
        }


        #endregion Constructor


        #region Methods


        /// <summary>
        /// Create the CodeDoc appdata folder and set data.xml
        /// </summary>
        private void InitializeData()
        {
            ShowSelectedItemPath = Properties.Settings.Default.ShowSelectedItemPath;
            DataFolder = Properties.Settings.Default.DataFolder;
            if (DataFolder == string.Empty)
                DataFolder = CDConstants.AppDataFolder;

            if (File.Exists(_DataFile))
                LoadConfig();
            else
                MessengerInstance.Send(new CDStatusMessage(CDConstants.DataNotFind, true, false));
        }


        /// <summary>
        /// Select a folder to store data.xml
        /// </summary>
        private void SetDataFolder()
        {
            if (_Browser.GetFolder(CDConstants.AppDataFolder) is string selectedFolder)
                DataFolder = selectedFolder;
        }



        /// <summary>
        /// Let the user choose a folder to add to the folders list if it doesn't exist already
        /// </summary>
        private void AddFolder()
        {
            if (_Browser.GetFolder() is string selectedFolder && !Datas.Any(x => x.Path.Equals(selectedFolder)))
                Datas.Add(new CDFolder(selectedFolder));
        }





        /// <summary>
        /// Reset and show the progressbar
        /// Display the loading data status
        /// </summary>
        private void SetUpConfig(string status)
        {
            Progress = 0;
            MessengerInstance.Send(new CDStatusMessage(status, false, false));
            Cursor = Cursors.Wait;
            ProgressBarVisibility = Visibility.Visible;
        }




        /// <summary>
        /// 
        /// </summary>
        private void LoadConfig()
        {
            SetUpConfig(CDConstants.LoadingData);
            _Worker.DoWork += LoadConfigWorker;
            _Worker.RunWorkerCompleted += LoadConfigCompleted;
            _Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="worker"></param>
        /// <returns></returns>
        public void LoadConfigWorker(object sender, DoWorkEventArgs e)
        {
            ObservableCollection<CDFolder> folders = new ObservableCollection<CDFolder>();
            XDocument doc = XDocument.Load(_DataFile);
            _ItemCount = doc.Root.Descendants().Count();

            doc.Root.Elements().ForEach(x => folders.Add((CDFolder)LoadItem((XElement)x)));
            e.Result = folders;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        private ICDItem LoadItem(XElement node)
        {
            _Worker.ReportProgress(++_Progress * 100 / _ItemCount);

            string path = CDMaxPath.GetPath(node.Attribute("Path").Value);
            string text = node.Attribute("Text").Value;
            ICDItem item = null;
            if (node.Name == "Folder")
            {
                ObservableCollection<ICDItem> scripts = new ObservableCollection<ICDItem>();
                node.Elements().ForEach(x => scripts.Add((CDScript)LoadItem((XElement)x)));
                item = new CDFolder(path, text, scripts);
            }
            if (node.Name == "Script")
            {
                item = new CDScript(path, text);
            }
            return item;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void LoadConfigCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            Datas = e.Result as ObservableCollection<CDFolder>;
            MessengerInstance.Send(new CDStatusMessage(CDConstants.DataLoaded, true, true));
            Cursor = Cursors.Arrow;
            _Worker.DoWork -= LoadConfigWorker;
            _Worker.RunWorkerCompleted -= LoadConfigCompleted;
        }





        /// <summary>
        /// 
        /// </summary>
        private void SaveConfig()
        {
            SetUpConfig(CDConstants.SavingData);
            _Worker.DoWork += SaveConfigWork;
            _Worker.RunWorkerCompleted += SaveConfigCompleted;
            _Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveConfigWork(object sender, DoWorkEventArgs e)
        {
            _ItemCount = 0;
            Datas.ForEach(x => _ItemCount += ((CDFolder)x).Children.Count + 1);

            _Writer = new XmlTextWriter(_DataFile, Encoding.UTF8);
            //writer = new XmlTextWriter(Console.Out);
            _Writer.Formatting = Formatting.Indented;
            _Writer.Indentation = 4;

            _Writer.WriteStartDocument();
            _Writer.WriteStartElement("CodeDocConfig");

            Datas.ForEach(x => SaveItem((ICDItem)x));

            _Writer.WriteEndElement();
            _Writer.WriteEndDocument();
            _Writer.Flush();
            _Writer.Close();
        }


        /// <summary>
        /// Save a Data item as xml node and report progress
        /// </summary>
        /// <param name="_item"></param>
        /// <param name="worker"></param>
        private void SaveItem(ICDItem _item)
        {
            _Worker.ReportProgress(++_Progress * 100 / _ItemCount);

            if (_item is CDFile item)
            {
                _Writer.WriteStartElement(item.Type.ToString());
                _Writer.WriteAttributeString("Path", item.RelativePath);
                _Writer.WriteAttributeString("Text", item.Text);

                item.Children.ForEach(x => SaveItem((ICDItem)x));

                _Writer.WriteEndElement();
            }
            else
            {
                _Writer.WriteString(_item.Type.ToString());
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveConfigCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            MessengerInstance.Send(new CDStatusMessage(CDConstants.DataSaved, true, true));
            Cursor = Cursors.Arrow;
            _Worker.DoWork -= SaveConfigWork;
            _Worker.RunWorkerCompleted -= SaveConfigCompleted;
        }



        /// <summary>
        /// 
        /// </summary>
        private void SetStatusPanel()
        {
            //DataPathFieldVisibility = Visibility.Collapsed;
            //if (ShowSelectedItemPath && _TVSelectedItem is CDFile selectedItem)
            //    MessengerInstance.Send(new CDStatusMessage(selectedItem.Path, false, false));
            //else
            //    MessengerInstance.Send(new CDStatusMessage(false));

            if (_TVSelectedItem is CDFile selectedItem)
            {
                if (selectedItem.IsValidPath)
                {
                    DataPathFieldVisibility = Visibility.Collapsed;
                    if (ShowSelectedItemPath)
                        MessengerInstance.Send(new CDStatusMessage(selectedItem.Path, false, false));
                    else
                        MessengerInstance.Send(new CDStatusMessage(false));
                }
                else
                {
                    DataPathFieldVisibility = Visibility.Visible;
                    DataPathField = selectedItem.Path;
                    MessengerInstance.Send(new CDStatusMessage(string.Empty, false, false));
                }
            }
        } 


        #endregion Methods

    }
}
