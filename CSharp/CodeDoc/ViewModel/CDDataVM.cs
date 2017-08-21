using CodeDoc.Messaging;
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
using System.Windows.Threading;
using System.Xml;
using System.Xml.Linq;

namespace CodeDoc.ViewModel
{
    public sealed class CDDataVM : ViewModelBase, IDataErrorInfo
    {
        

        #region Fields

        private CDDataIO _DataIO = new CDDataIO();
        private enum IOType
        {
            Load,
            Save
        }
        private CDBrowser _Browser = new CDBrowser();

        private string _DataFolder;
        private ObservableCollection<CDFileItem> _Datas = new ObservableCollection<CDFileItem>();
        private bool _ShowSelectedItemPath;
        private CDDataItem _SelectedItem;
        private bool _CanValidateDataPath = false;
        private string _DataPathField;
        private bool _CanShowDataPathField = true;
        private Visibility _DataPathFieldVisibility = Visibility.Collapsed;

        private RelayCommand _SetDataFolderCommand;
        private RelayCommand _AddFolderCommand;
        private RelayCommand _AddFileCommand;
        private RelayCommand _RemoveItemCommand;
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
                _DataIO.DataFile = value + CDConstants.DataFile;
                Properties.Settings.Default.DataFolder = value;
                Properties.Settings.Default.Save();
            }
        }

        /// <summary>
        /// The collection of CDFolders that will be displayed in the treeview
        /// </summary>
        public ObservableCollection<CDFileItem> Datas
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

        /// <summary>
        /// 
        /// </summary>
        public CDDataItem SelectedItem
        {
            get { return _SelectedItem; }
            set
            {
                _SelectedItem = value;
                SetStatusPanel();
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
                if (SelectedItem is CDFileItem selectedItem)
                {
                    Set(ref _DataPathField, value);
                    selectedItem.Path = value;
                    if (selectedItem.IsValidPath)
                        _CanValidateDataPath = true;

                    Application.Current.Dispatcher.Invoke(ValidateDataPathCommand.RaiseCanExecuteChanged);
                }
            }
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
        public RelayCommand AddFileCommand
        {
            get { return _AddFileCommand ?? (_AddFileCommand = new RelayCommand(AddFile)); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand RemoveItemCommand
        {
            get { return _RemoveItemCommand ?? (_RemoveItemCommand = new RelayCommand(RemoveItem)); }
        }

        /// <summary>
        /// 
        /// </summary>
        public RelayCommand LoadConfigCommand
        {
            get { return _LoadConfigCommand ?? (_LoadConfigCommand = new RelayCommand(() => UseDataIO(IOType.Load))); }
        }

        /// <summary>
        /// 
        /// </summary>
        public RelayCommand SaveConfigCommand
        {
            get { return _SaveConfigCommand ?? (_SaveConfigCommand = new RelayCommand(() => UseDataIO(IOType.Save))); }
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


        public CDDataVM()
        {
            // Get selected treeview item
            MessengerInstance.Register<CDSelectedItemMessage>(this, x => SelectedItem = x.Sender);

            //Get the data from _DataIO
            MessengerInstance.Register<GenericMessage<ObservableCollection<CDFileItem>>>(this, x => Datas = x.Content);

            //Set the status panel when it's closing
            MessengerInstance.Register<CDStatusPanelMessage>(this, x =>
            {
                _CanShowDataPathField = !x.IsDisplayingStatus;
                SetStatusPanel();
            });
            

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

            if (File.Exists(_DataIO.DataFile))
                _DataIO.LoadDatas();
            else
                MessengerInstance.Send(new CDStatusMessage(CDConstants.DataNotFind, true, false));
        }


        /// <summary>
        /// Select a folder to store CodeDoc_Datas.xml
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
                Datas.Add(new CDFolder(null, selectedFolder));
        }


        /// <summary>
        /// Let the user choose a file to add to the folders list if it doesn't exist already
        /// </summary>
        private void AddFile()
        {
            if (_Browser.GetFile() is string selectedFile && !Datas.Any(x => x.Path.Equals(selectedFile)))
                Datas.Add(new CDScript(null, selectedFile));
        }


        /// <summary>
        /// Remove a item from the list
        /// </summary>
        private void RemoveItem()
        {
            if (SelectedItem != null)
            {
                if (SelectedItem.Parent is null)
                    Datas.Remove((CDFileItem)SelectedItem);
                else
                    ((CDFileItem)SelectedItem.Parent).Children.Remove(SelectedItem);
            }
                
        }


        /// <summary>
        /// Set status panel depending of selected item
        /// </summary>
        private void SetStatusPanel()
        {
            //TODO: order of priority: DataPathFieldVisibility before missing description
            if (SelectedItem is IReadableItem item && item.Description is null)
            {
                DataPathFieldVisibility = Visibility.Collapsed;
                MessengerInstance.Send(new CDStatusMessage(CDConstants.ScriptNoDescription, false, false));
            }
            else if (_SelectedItem is CDFileItem selectedItem)
            {
                if (selectedItem.IsValidPath)
                {
                    DataPathFieldVisibility = Visibility.Collapsed;
                    if (ShowSelectedItemPath)
                        MessengerInstance.Send(new CDStatusMessage(selectedItem.Path, false, false));
                    else
                        MessengerInstance.Send(new CDStatusMessage(false));
                }
                else if (_CanShowDataPathField)
                {
                    DataPathFieldVisibility = Visibility.Visible;
                    DataPathField = selectedItem.Path;
                    MessengerInstance.Send(new CDStatusMessage(string.Empty, false, false));
                }
            }
        } 


        /// <summary>
        /// Load or save datas
        /// </summary>
        /// <param name="type"></param>
        private void UseDataIO(IOType type)
        {
            _CanShowDataPathField = false;
            DataPathFieldVisibility = Visibility.Collapsed;
            switch (type)
            {
                case IOType.Load:
                    _DataIO.LoadDatas();
                    SelectedItem = null;
                    break;
                case IOType.Save:
                    _DataIO.SaveDatas(Datas);
                    break;
            }
        }


        #endregion Methods

    }
}
