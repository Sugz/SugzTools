using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDFolder : CDFileItem
    {
        public CDFolder(string path) : this(path, null, null) { }
        public CDFolder(string path, string text) : this(path, text, null) { }
        public CDFolder(string path, string text, ObservableCollection<CDDataItem> children) : base(path, text, children)
        {
            Type = CDDataItemType.Folder;
        }

        protected override bool GetIsValidPath()
        {
            return Directory.Exists(Path);
        }

        protected override string GetText()
        {
            return System.IO.Path.GetFileName(Path);
        }

        protected override ObservableCollection<CDDataItem> GetChildren()
        {
            if (!IsValidPath)
                return null;

            ObservableCollection<CDDataItem> children = new ObservableCollection<CDDataItem>();
            Directory.GetFiles(Path).ToList().ForEach(x => children.Add(new CDScript(x)));
            return children;
        }
    }
}
