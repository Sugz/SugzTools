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
        public CDFolder(string path) : base(path) { }

        protected override string GetText()
        {
            return System.IO.Path.GetFileName(Path);
        }

        protected override ObservableCollection<CDFile> GetChildren()
        {
            if (!Directory.Exists(Path))
                return null;

            ObservableCollection<CDFile> children = new ObservableCollection<CDFile>();
            Directory.GetFiles(Path).ToList().ForEach(x => children.Add(new CDScript(x)));
            return children;
        }
    }
}
