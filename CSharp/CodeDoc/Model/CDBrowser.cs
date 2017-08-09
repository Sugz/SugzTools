using Microsoft.WindowsAPICodePack.Dialogs;
using Microsoft.WindowsAPICodePack.Shell;
using System;
using System.Collections;
using System.IO;

namespace CodeDoc.Model
{
    public class CDBrowser
    {

        private CommonOpenFileDialog _OpenFileDialog;


        /// <summary>
        /// Use CommonOpenFileDialog to select a folder
        /// </summary>
        /// <returns></returns>
        public string GetFolder(string initialPath = null)
        {
            DefineOpenFileDialog(initialPath);

            CommonFileDialogResult result = _OpenFileDialog.ShowDialog();
            if (result == CommonFileDialogResult.Ok && Directory.Exists(_OpenFileDialog.FileName))
                return _OpenFileDialog.FileName;
            return null;
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

    }
}
