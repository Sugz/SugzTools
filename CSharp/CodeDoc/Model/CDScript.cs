using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDScript : CDFile
    {
        public CDScript(string path) : base(path)
        {
            Type = CDItemType.Script;
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
