using System;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.CommandWpf;
using SvgToXaml.Model;
using System.Collections.ObjectModel;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.IO;
using System.Linq;

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
        private string _Status;
        // private int _SvgCount;
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
        /// Process all the svg files contain in the folders
        /// </summary>
        public RelayCommand ProcessCommand
        {
            get { return  _ProcessCommand ?? (_ProcessCommand = new RelayCommand(ConvertSvgsToXaml, CanConvert)); }
        }


        /// <summary>
        /// Remove a folder from Folders
        /// </summary>
        public RelayCommand<string> RemoveFolderCommand
        {
            get { return _RemoveFolderCommand ?? (_RemoveFolderCommand = new RelayCommand<string>(
                name => Folders.Remove(Folders.Single(x => x.Name == name)))
            ); }
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

                // Only add a folder if it doesn't already exist in Folders
                if (!Folders.Any(x => x.Equals(folder)))
                    Folders.Add(folder);
            }
        }


        /// <summary>
        /// Create an enum and a resource dictionay from a list of svg files
        /// </summary>
        private void ConvertSvgsToXaml()
        {
            throw new NotImplementedException();
        }


        /// <summary>
        /// Check if there is some svg files in Folders
        /// </summary>
        /// <returns></returns>
        private bool CanConvert()
        {
            int _SvgCount = 0;
            Status = "Add a folder";

            if (Folders.Count > 0)
            {
                foreach (Folder folder in Folders)
                    _SvgCount += folder.SvgCount;
                Status = $"{_SvgCount} SVG found";
            }

            return _SvgCount > 0;
        }


        #endregion Methods





        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}
    }
}