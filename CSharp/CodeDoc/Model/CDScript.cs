using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDScript : CDFile
    {
        public CDScript(string path) : this(path, null, null) { }
        public CDScript(string path, string text) : this(path, text, null) { }
        public CDScript(string path, string text, ObservableCollection<ICDItem> children) : base(path, text, children)
        {
            Type = CDItemType.Script;
        }


        protected override bool GetIsValidPath()
        {
            return File.Exists(Path);
        }
        protected override string GetText()
        {
            return System.IO.Path.GetFileNameWithoutExtension(Path);
        }

        protected override ObservableCollection<ICDItem> GetChildren()
        {
            //TODO: correct implementation
            return new ObservableCollection<ICDItem>();
        }

        
    }
}
