using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Messaging;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;
using System.Xml;
using System.Xml.Linq;

namespace CodeDoc.Src
{
    public class CDDataIO : ViewModelBase
    {

        #region Fields


        private string _DataFile;
        private int _Progress = 0;
        private int _ItemCount = 0;
        private BackgroundWorker _Worker = new BackgroundWorker() { WorkerReportsProgress = true };
        private XmlTextWriter _Writer;
        ObservableCollection<CDFolder> _Datas;

        #endregion Fields


        #region Properties


        public int Progress { set => MessengerInstance.Send(new GenericMessage<int>(value)); }
        public Cursor Cursor { set => MessengerInstance.Send(new GenericMessage<Cursor>(value)); }
        public Visibility ProgressBarVisibility { set => MessengerInstance.Send(new GenericMessage<Visibility>(value)); }


        /// <summary>
        /// The path for CodeDoc_Datas.xml
        /// </summary>
        public string DataFile
        {
            get { return _DataFile; }
            set { _DataFile = value; }
        }



        #endregion Properties



        #region Constructor


        public CDDataIO()
        {
            _Worker.ProgressChanged += (s, e) => Progress = e.ProgressPercentage;
            //MessengerInstance.Register<NotificationMessage>(this, x => _DataFile = x.Notification);
        }


        #endregion Constructor



        #region Methods



        /// <summary>
        /// Reset and show the progressbar
        /// Display the loading data status
        /// </summary>
        private void SetUpDataIO(string status)
        {
            _Progress = 0;
            Progress = 0;
            Cursor = Cursors.Wait;
            ProgressBarVisibility = Visibility.Visible;
            MessengerInstance.Send(new CDStatusMessage(status, false, false));
        }



        #region Load Datas


        /// <summary>
        /// 
        /// </summary>
        public void LoadConfig()
        {
            SetUpDataIO(CDConstants.LoadingData);
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
            Thread.Sleep(500);

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
            //Datas = e.Result as ObservableCollection<CDFolder>;
            MessengerInstance.Send(new GenericMessage<ObservableCollection<CDFolder>>(e.Result as ObservableCollection<CDFolder>));
            MessengerInstance.Send(new CDStatusMessage(CDConstants.DataLoaded, true, true));
            Cursor = Cursors.Arrow;
            _Worker.DoWork -= LoadConfigWorker;
            _Worker.RunWorkerCompleted -= LoadConfigCompleted;
        }


        #endregion Load Datas



        #region Save Datas


        /// <summary>
        /// 
        /// </summary>
        public void SaveConfig(ObservableCollection<CDFolder> datas)
        {
            _Datas = datas;
            SetUpDataIO(CDConstants.SavingData);
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
            _Datas.ForEach(x => _ItemCount += ((CDFolder)x).Children.Count + 1);

            _Writer = new XmlTextWriter(_DataFile, Encoding.UTF8);
            //writer = new XmlTextWriter(Console.Out);
            _Writer.Formatting = Formatting.Indented;
            _Writer.Indentation = 4;

            _Writer.WriteStartDocument();
            _Writer.WriteStartElement("CodeDocConfig");

            _Datas.ForEach(x => SaveItem((ICDItem)x));

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


        #endregion Save Datas


        #endregion Methods
    }
}
