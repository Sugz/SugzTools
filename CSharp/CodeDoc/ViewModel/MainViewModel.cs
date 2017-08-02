using GalaSoft.MvvmLight;
using CodeDoc.Model;
using GalaSoft.MvvmLight.Command;
using Microsoft.WindowsAPICodePack.Dialogs;
using System.IO;
using System.Collections.ObjectModel;
using System.Linq;

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


        private RelayCommand _AddFolderCommand;


        #endregion Fields



        #region Properties


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


        #endregion Properties



        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            string _path = @"C:\Users\cplantec\AppData\Local\Autodesk\3dsMax\2016 - 64bit\ENU\scripts\SugzTools\Libs";
            Folders.Add(new CDFolder(_path));
        }

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
    }
}