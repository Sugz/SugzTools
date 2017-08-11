using CodeDoc.Model;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Messaging;
using SugzTools.Src;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading;
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
        ObservableCollection<CDFileItem> _Datas;

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
            MessengerInstance.Send(new CDStatusMessage(status, false, true));
        }



        #region Load Datas


        /// <summary>
        /// 
        /// </summary>
        public void LoadDatas()
        {
            SetUpDataIO(CDConstants.LoadingData);
            _Worker.DoWork += LoadDatasWorker;
            _Worker.RunWorkerCompleted += LoadDatasCompleted;
            _Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="worker"></param>
        /// <returns></returns>
        public void LoadDatasWorker(object sender, DoWorkEventArgs e)
        {
            ObservableCollection<CDFileItem> items = new ObservableCollection<CDFileItem>();
            XDocument doc = XDocument.Load(_DataFile);
            _ItemCount = doc.Root.Descendants().Count();

            doc.Root.Elements().ForEach(x => items.Add((CDFileItem)LoadItem((XElement)x)));
            e.Result = items;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="node"></param>
        /// <returns></returns>
        private CDDataItem LoadItem(XElement node)
        {
            Thread.Sleep(100);

            _Worker.ReportProgress(++_Progress * 100 / _ItemCount);

            string path = CDMaxPath.GetPath(node.Attribute("Path").Value);
            string text = node.Attribute("Text").Value;
            CDDataItem item = null;
            if (node.Name == "Folder")
            {
                ObservableCollection<CDDataItem> scripts = new ObservableCollection<CDDataItem>();
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
        private void LoadDatasCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            MessengerInstance.Send(new GenericMessage<ObservableCollection<CDFileItem>>(e.Result as ObservableCollection<CDFileItem>));
            MessengerInstance.Send(new CDStatusPanelMessage(true));
            MessengerInstance.Send(new CDStatusMessage(CDConstants.DataLoaded, true, true));
            Cursor = Cursors.Arrow;
            _Worker.DoWork -= LoadDatasWorker;
            _Worker.RunWorkerCompleted -= LoadDatasCompleted;
        }


        #endregion Load Datas



        #region Save Datas


        /// <summary>
        /// 
        /// </summary>
        public void SaveDatas(ObservableCollection<CDFileItem> datas)
        {
            _Datas = datas;
            SetUpDataIO(CDConstants.SavingData);
            _Worker.DoWork += SaveDatasWork;
            _Worker.RunWorkerCompleted += SaveDatasCompleted;
            _Worker.RunWorkerAsync();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SaveDatasWork(object sender, DoWorkEventArgs e)
        {
            _ItemCount = 0;
            _Datas.ForEach(x => _ItemCount += ((CDFileItem)x).Children.Count + 1);

            _Writer = new XmlTextWriter(_DataFile, Encoding.UTF8);
            _Writer.Formatting = Formatting.Indented;
            _Writer.Indentation = 4;

            _Writer.WriteStartDocument();
            _Writer.WriteStartElement("CodeDocConfig");

            _Datas.ForEach(x => SaveItem((CDDataItem)x));

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
        private void SaveItem(CDDataItem _item)
        {
            //Thread.Sleep(100);

            _Worker.ReportProgress(++_Progress * 100 / _ItemCount);

            if (_item is CDFileItem item)
            {
                _Writer.WriteStartElement(item.Type.ToString());
                _Writer.WriteAttributeString("Path", item.RelativePath);
                _Writer.WriteAttributeString("Text", item.Text);

                item.Children.ForEach(x => SaveItem((CDDataItem)x));

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
        private void SaveDatasCompleted(object sender, RunWorkerCompletedEventArgs e)
        {
            MessengerInstance.Send(new CDStatusMessage(CDConstants.DataSaved, true, true));
            Cursor = Cursors.Arrow;
            _Worker.DoWork -= SaveDatasWork;
            _Worker.RunWorkerCompleted -= SaveDatasCompleted;
        } 


        #endregion Save Datas


        #endregion Methods
    }
}
