using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public abstract class CDFile
    {
        protected string _Text;
        protected ObservableCollection<CDFile> _Children;

        public string Path { get; protected set; }
        public string Text
        {
            get { return _Text ?? (_Text = GetText()); }
            set { _Text = value; }
        }
        public ObservableCollection<CDFile> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            protected set { _Children = value; }
        }


        public CDFile(string path)
        {
            Path = path;
        }


        protected abstract string GetText();
        protected abstract ObservableCollection<CDFile> GetChildren();

    }
}
