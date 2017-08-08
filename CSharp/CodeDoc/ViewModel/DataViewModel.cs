using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using GalaSoft.MvvmLight.Messaging;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using System.Xml;
using System.Xml.Linq;

namespace CodeDoc.ViewModel
{
    public class DataViewModel : ViewModelBase
    {

        private XmlTextWriter _Writer;
        private int _ItemCount = 0;
        private int _Progress = 0;
        private string _DataPath;
        private CDBrowser _Browser;
        private BackgroundWorker _Worker;
        private ObservableCollection<CDFolder> _Datas = new ObservableCollection<CDFolder>();
        private RelayCommand _AddFolderCommand;
        private RelayCommand _LoadConfigCommand;
        private RelayCommand _SaveConfigCommand;



        /// <summary>
        /// 
        /// </summary>
        public ObservableCollection<CDFolder> Datas
        {
            get { return _Datas; }
            set { Set(ref _Datas, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand AddFolderCommand
        {
            get { return _AddFolderCommand ?? (_AddFolderCommand = new RelayCommand(LoadConfig)); }
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
        //public RelayCommand SaveConfigCommand
        //{
        //    get { return _SaveConfigCommand ?? (_SaveConfigCommand = new RelayCommand(SaveConfig)); }
        //}



        #region Constructor


        public DataViewModel()
        {
            _Browser = new CDBrowser();
            _Worker = new BackgroundWorker();
            _Worker.WorkerReportsProgress = true;
            //_DataPath = path + CDConstants.DataFile;
        } 


        #endregion Constructor





        private void ResetProgress()
        {
            _Progress = 0;
            _ItemCount = 0;
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
        /// 
        /// </summary>
        private void SetUpConfig(string status)
        {
            ResetProgress();
            MessengerInstance.Send(new CDDataMessage(status, _Progress, Cursors.Wait, Visibility.Visible));

            //TODO: send message for the progress report (or bind directly to a property here if the progressbar isn't needed somewhere else)
            _Worker.ProgressChanged += (object sender, ProgressChangedEventArgs e) => _Progress = e.ProgressPercentage;
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
            XDocument doc = XDocument.Load(_DataPath);

            
            _ItemCount = doc.Descendants().Count() - 1;

            XElement root = doc.Root;
            var test = doc.Root.Elements();
            doc.Root.Elements().ForEach(x => Datas.Add((CDFolder)LoadItem((XElement)x)));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        private ICDItem LoadItem(XElement node)
        {
            _Progress += 1;
            _Worker.ReportProgress(_Progress * 100 / _ItemCount);

            string path = node.Attribute("Path").Value;
            string text = node.Attribute("Text").Value;
            ICDItem item = null;
            if (node.Name == "Folder")
            {
                ObservableCollection<ICDItem> scripts = new ObservableCollection<ICDItem>();
                node.Descendants().ForEach(x => scripts.Add((CDScript)LoadItem((XElement)x)));
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
            //DisplaySatus(CDConstants.DataLoaded, true, true);
            //Cursor = Cursors.Arrow;
            _Worker.DoWork -= LoadConfigWorker;
            _Worker.RunWorkerCompleted -= LoadConfigCompleted;
        }
    }
}
