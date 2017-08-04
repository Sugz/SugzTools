using CodeDoc.Model;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Xml;

namespace CodeDoc.Src
{
    public class CDConfig
    {
        private string path = @"d:\test.xml";
        private XmlTextWriter writer;
        int itemCount = 0;
        int progress = 0;


        public void SaveConfig(ObservableCollection<CDFolder> folders, BackgroundWorker worker)
        {
            folders.ForEach(x => itemCount += ((CDFolder)x).Children.Count + 1);

            writer = new XmlTextWriter(path, Encoding.UTF8);
            //writer = new XmlTextWriter(Console.Out);
            writer.Formatting = Formatting.Indented;
            writer.Indentation = 4;

            writer.WriteStartDocument();
            writer.WriteStartElement("CodeDocConfig");

            folders.ForEach(x => SaveItem((ICDItem)x, worker));

            writer.WriteEndElement();
            writer.WriteEndDocument();
            writer.Flush();
            writer.Close();
            
        }


        private void SaveItem(ICDItem _item, BackgroundWorker worker)
        {
            progress += 1;
            worker.ReportProgress(progress * 100 / itemCount);

            if (_item is CDFile item)
            {
                writer.WriteStartElement(item.Type.ToString());
                writer.WriteAttributeString("Path", item.Path);
                writer.WriteAttributeString("Text", item.Text);

                item.Children.ForEach(x => SaveItem((ICDItem)x, worker));

                writer.WriteEndElement();
            }
            else
            {
                writer.WriteString(_item.Type.ToString());
            }
        }


        public ObservableCollection<CDFolder> LoadConfig(BackgroundWorker worker)
        {
            ObservableCollection<CDFolder> folders = new ObservableCollection<CDFolder>();
            XmlDocument xDoc = new XmlDocument();
            xDoc.Load(path);

            XmlElement rootNode = xDoc.DocumentElement;
            rootNode.ChildNodes.ForEach(x => folders.Add((CDFolder)LoadItem((XmlElement)x, worker)));

            return folders;
        }

        private ICDItem LoadItem(XmlElement node, BackgroundWorker worker)
        {
            string text = node.GetAttribute("Text");
            string path = node.GetAttribute("Path");
            string name = node.Name;
            ICDItem item = null;
            switch (node.Name)
            {
                case "Folder":
                    ObservableCollection<ICDItem> scripts = new ObservableCollection<ICDItem>();
                    node.ChildNodes.ForEach(x => scripts.Add((CDScript)LoadItem((XmlElement)x, worker)));
                    item = new CDFolder(path, text, scripts);
                    break;

                case "Script":
                    item = new CDScript(path, text);
                    break;
            }
            return item;
        }
    }
}
