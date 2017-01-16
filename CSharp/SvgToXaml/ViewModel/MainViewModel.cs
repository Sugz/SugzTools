using System;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using SvgToXaml.Model;
using System.Collections.ObjectModel;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.IO;

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
        private string _Status = "Not Ready";
        private RelayCommand _AddFolderCommand;
        private RelayCommand _ProcessCommand;


        #endregion Fields



        #region Properties


        /// <summary>
        /// Gets the Status property.
        /// </summary>
        public string Status
        {
            get { return _Status; }
            set { Set(ref _Status, value); }
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
            get { return _AddFolderCommand = _AddFolderCommand ?? new RelayCommand(AddFolder); ; }
        }

        
        /// <summary>
        /// Process all the svg files contain in the folders
        /// </summary>
        public RelayCommand ProcessCommand
        {
            get { return _ProcessCommand = _ProcessCommand ?? new RelayCommand(ConvertSvgsToXaml, () => Folders.Count > 0); }
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
        }


        #endregion Constructor



        #region Methods


        /// <summary>
        /// Let the user choose a folder to add to the processing list
        /// </summary>
        private void AddFolder()
        {
            CommonOpenFileDialog commonOpenFileDialog = new CommonOpenFileDialog();
            commonOpenFileDialog.IsFolderPicker = true;
            CommonFileDialogResult result = commonOpenFileDialog.ShowDialog();

            if (result == CommonFileDialogResult.Ok && Directory.Exists(commonOpenFileDialog.FileName))
            {
                Folder folder = new Folder(commonOpenFileDialog.FileName);

                if (IsUnique(folder))
                    Folders.Add(folder);
            }
        }


        private bool IsUnique(Folder _folder)
        {
            foreach(Folder folder in Folders)
            {
                if (folder.Equals(_folder))
                    return false;
            }
            return true;
        }


        /// <summary>
        /// Create an enum and a resource dictionay from a list of svg files
        /// </summary>
        private void ConvertSvgsToXaml()
        {
            throw new NotImplementedException();
        } 


        #endregion Methods





        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}
    }
}