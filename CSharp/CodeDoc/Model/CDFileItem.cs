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
        protected string _Text;
        protected ObservableCollection<CDDataItem> _Children;

        #endregion Fields


        #region Properties

        public CDDataItemType Type { get; set; }
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
        public string Text
        {
            get { return _Text ?? (_Text = GetText()); }
            set { Set(ref _Text, value); }
        }
        public ObservableCollection<CDDataItem> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            protected set { _Children = value; }
        }

        #endregion MyRegion


        #region Constructors

        public CDFileItem(string path) : this(path, null, null) { }
        public CDFileItem(string path, string text) : this(path, text, null) { }
        public CDFileItem(string path, string text, ObservableCollection<CDDataItem> children)
        {
            Path = path;
            Text = text;
            Children = children;
        }

        #endregion Constructors


        #region Methods

        protected abstract bool GetIsValidPath();
        protected abstract string GetText();
        protected abstract ObservableCollection<CDDataItem> GetChildren(); 

        #endregion Methods

    }
}
