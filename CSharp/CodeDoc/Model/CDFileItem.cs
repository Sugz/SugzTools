using CodeDoc.Src;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public abstract class CDFileItem : CDDataItem
    {
        #region Fields

        protected bool _IsValidPath;
        protected string _Path;
        protected ObservableCollection<CDDataItem> _Children = new ObservableCollection<CDDataItem>();

        #endregion Fields


        #region Properties

        //TODO update selecteditem when isvalidpath changed
        public bool IsValidPath
        {
            get { return _IsValidPath; }
            set { Set(ref _IsValidPath, value); }
        }
        public string RelativePath
        {
            get { return CDMaxPath.GetRelativePath(Path); }
        }
        public string Path
        {
            get { return _Path; }
            set
            {
                Set(ref _Path, value);
                IsValidPath = GetIsValidPath();
            }
        }
        public ObservableCollection<CDDataItem> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            set { _Children = value; }
        }

        #endregion MyRegion


        #region Constructors

        public CDFileItem(object parent, string path) : this(parent, path, null, null) { }
        public CDFileItem(object parent, string path, string text) : this(parent, path, text, null) { }
        public CDFileItem(object parent, string path, string text, ObservableCollection<CDDataItem> children) : base(parent)
        {
            Path = path;
            Text = text;
            Children = children;
        }

        #endregion Constructors


        #region Methods

        protected abstract bool GetIsValidPath();
        protected abstract ObservableCollection<CDDataItem> GetChildren(); 

        #endregion Methods

    }
}
