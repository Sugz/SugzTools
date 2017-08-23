using Microsoft.WindowsAPICodePack.Dialogs;
using Microsoft.WindowsAPICodePack.Shell;
using System;
using System.Collections;
using System.IO;

namespace CodeDoc.Src
{
    public class CDBrowser
    {
        private CommonOpenFileDialog _OpenFileDialog;


        public string GetFile(string initialPath = null)
        {
            if (GetResult(false, initialPath) is string file && File.Exists(file))
                return file;
            return null;
        }


        /// <summary>
        /// Use CommonOpenFileDialog to select a folder
        /// </summary>
        /// <returns></returns>
        public string GetFolder(string initialPath = null)
        {
            if (GetResult(true, initialPath) is string folder && Directory.Exists(folder))
                return folder;
            return null;
        }

        private string GetResult(bool isFolderPicker, string initialPath)
        {
            if (_OpenFileDialog is null)
                DefineOpenFileDialog();

            _OpenFileDialog.IsFolderPicker = isFolderPicker;
            _OpenFileDialog.InitialDirectory = initialPath;

            CommonFileDialogResult result = _OpenFileDialog.ShowDialog();
            if (result == CommonFileDialogResult.Ok)
                return _OpenFileDialog.FileName;
            return null;
        }


        /// <summary>
        /// 
        /// </summary>
        private void DefineOpenFileDialog()
        {
            _OpenFileDialog = new CommonOpenFileDialog();
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
}
