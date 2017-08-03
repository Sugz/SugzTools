using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public abstract class CDFile : ICDItem
    {
        protected string _Text;
        protected ObservableCollection<ICDItem> _Children;

        public CDItemType Type { get; set; }
        public string Path { get; protected set; }
        public string Text
        {
            get { return _Text ?? (_Text = GetText()); }
            set { _Text = value; }
        }
        public ObservableCollection<ICDItem> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            protected set { _Children = value; }
        }

        

        public CDFile(string path)
        {
            Path = path;
        }


        protected abstract string GetText();
        protected abstract ObservableCollection<ICDItem> GetChildren();

    }
}
