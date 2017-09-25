using Microsoft.WindowsAPICodePack.Dialogs;
using Microsoft.WindowsAPICodePack.Shell;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Src
{
    public class Browser
    {
        private CommonOpenFileDialog _OpenFileDialog;

        /// <summary>
        /// Use CommonOpenFileDialog to select a file
        /// </summary>
        /// <returns></returns>
        public string GetFile(string initialPath = null, Dictionary<string, string> fileTypes = null)
        {
            if (GetResult(false, initialPath, fileTypes) is string file && File.Exists(file))
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


        /// <summary>
        /// Return either a file or a folder
        /// </summary>
        /// <param name="isFolderPicker"></param>
        /// <param name="initialPath"></param>
        /// <returns></returns>
        private string GetResult(bool isFolderPicker, string initialPath, Dictionary<string, string> fileTypes = null)
        {
            if (_OpenFileDialog is null)
                DefineOpenFileDialog();

            _OpenFileDialog.IsFolderPicker = isFolderPicker;
            _OpenFileDialog.InitialDirectory = initialPath;

            if (fileTypes != null)
            {
                CommonFileDialogFilter all = new CommonFileDialogFilter() { DisplayName = "All Compatibles" };
                _OpenFileDialog.Filters.Add(all);
                foreach (KeyValuePair<string, string> pair in fileTypes)
                {
                    _OpenFileDialog.Filters.Add(new CommonFileDialogFilter(pair.Key, $"*{pair.Value}"));
                    all.Extensions.Add(pair.Value.TrimStart('.'));
                }
                    
                
                
            }


            CommonFileDialogResult result = _OpenFileDialog.ShowDialog();
            if (result == CommonFileDialogResult.Ok)
                return _OpenFileDialog.FileName;
            return null;
        }


        /// <summary>
        /// Add the 3ds max install and ENU folders as places
        /// </summary>
        private void DefineOpenFileDialog()
        {
            //TODO use MaxFolder to get them
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
