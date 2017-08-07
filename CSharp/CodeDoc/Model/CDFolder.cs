using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDFolder : CDFile
    {
        public CDFolder(string path) : base(path)
        {
            Type = CDItemType.Folder;
        }
        public CDFolder(string path, string text) : base(path, text)
        {
            Type = CDItemType.Folder;
        }
        public CDFolder(string path, string text, ObservableCollection<ICDItem> children) : base(path, text, children)
        {
            Type = CDItemType.Folder;
        }

        protected override bool GetIsValidPath()
        {
            return Directory.Exists(Path);
        }

        protected override string GetText()
        {
            return System.IO.Path.GetFileName(Path);
        }

        protected override ObservableCollection<ICDItem> GetChildren()
        {
            if (!IsValidPath)
                return null;

            ObservableCollection<ICDItem> children = new ObservableCollection<ICDItem>();
            Directory.GetFiles(Path).ToList().ForEach(x => children.Add(new CDScript(x)));
            return children;
        }
    }
}
