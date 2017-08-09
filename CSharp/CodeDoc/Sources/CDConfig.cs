using CodeDoc.Model;
using GalaSoft.MvvmLight;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Xml;
using System.Xml.Linq;

namespace CodeDoc.Src
{
    public class CDConfig : ViewModelBase
    {
        #region Fields

        //private BackgroundWorker _Worker;
        private XmlTextWriter _Writer;
        private int _ItemCount = 0;
        private int _Progress = 0;
        private string _Path;

        #endregion Fields


        #region Properties

        public BackgroundWorker Worker { get; set; }


        #endregion Properties


        public CDConfig(string path)
        {
            Worker = new BackgroundWorker();
            Worker.WorkerReportsProgress = true;
            _Path = path + CDConstants.DataFile;
        }


        private void ResetProgress()
        {
            _Progress = 0;
            _ItemCount = 0;
        }



        /// <summary>
        /// 
        /// </summary>
        /// <param name="folders"></param>
        /// <param name="worker"></param>
        public void SaveConfig(ObservableCollection<CDFolder> folders)
        {
            ResetProgress();
            folders.ForEach(x => _ItemCount += ((CDFolder)x).Children.Count + 1);

            _Writer = new XmlTextWriter(_Path, Encoding.UTF8);
            //writer = new XmlTextWriter(Console.Out);
            _Writer.Formatting = Formatting.Indented;
            _Writer.Indentation = 4;

            _Writer.WriteStartDocument();
            _Writer.WriteStartElement("CodeDocConfig");

            folders.ForEach(x => SaveItem((ICDItem)x));

            _Writer.WriteEndElement();
            _Writer.WriteEndDocument();
            _Writer.Flush();
            _Writer.Close();
            
        }


        /// <summary>
        /// Save a treeview node a xml node and update 
        /// </summary>
        /// <param name="_item"></param>
        /// <param name="worker"></param>
        private void SaveItem(ICDItem _item)
        {
            _Progress += 1;
            Worker.ReportProgress(_Progress * 100 / _ItemCount);

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
        /// <param name="worker"></param>
        /// <returns></returns>
        public void LoadConfig(object sender, DoWorkEventArgs e)
        {
            ObservableCollection<CDFolder> folders = new ObservableCollection<CDFolder>();
            XDocument doc = XDocument.Load(_Path);

            ResetProgress();
            _ItemCount = doc.Descendants().Count() - 1;

            XElement root = doc.Root;
            var test = doc.Root.Elements();
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
            _Progress += 1;
            Worker.ReportProgress(_Progress * 100 / _ItemCount);

            string path = CDMaxPath.GetPath(node.Attribute("Path").Value);
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

    }
}
;