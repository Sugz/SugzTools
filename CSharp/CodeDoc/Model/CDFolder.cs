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

        protected override string GetText()
        {
            return System.IO.Path.GetFileName(Path);
        }

        protected override ObservableCollection<ICDItem> GetChildren()
        {
            if (!Directory.Exists(Path))
                return null;

            ObservableCollection<ICDItem> children = new ObservableCollection<ICDItem>();
            Directory.GetFiles(Path).ToList().ForEach(x => children.Add(new CDScript(x)));
            return children;
        }
    }
}
