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
    public abstract class CDFile : ObservableObject, ICDItem
    {
        #region Fields

        protected bool _IsValidPath;
        protected string _Path;
        protected string _Text;
        protected ObservableCollection<ICDItem> _Children;

        #endregion Fields


        #region Properties

        public CDItemType Type { get; set; }
        public bool IsValidPath
        {
            get { return _IsValidPath; }
            set { Set(ref _IsValidPath, value); }
        }
        public string Path
        {
            get { return _Path; }
            set
            {
                _Path = value;
                IsValidPath = GetIsValidPath();
            }
        }
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

        #endregion MyRegion


        #region Constructors

        public CDFile(string path)
        {
            Path = path;
        }
        public CDFile(string path, string text)
        {
            Path = path;
            Text = text;
        }
        public CDFile(string path, string text, ObservableCollection<ICDItem> children)
        {
            Path = path;
            Text = text;
            Children = children;
        }

        #endregion Constructors


        #region Methods

        protected abstract bool GetIsValidPath();
        protected abstract string GetText();
        protected abstract ObservableCollection<ICDItem> GetChildren(); 

        #endregion Methods

    }
}
