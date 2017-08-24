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
        protected string _RelativePath;
        protected string _Path;
        

        #endregion Fields


        #region Properties

        /// <summary>
        /// Get if the path is valid. 
        /// Load Children if it is
        /// </summary>
        public bool IsValidPath
        {
            get { return _IsValidPath; }
            protected set
            {
                Set(ref _IsValidPath, value);

                // Reload children when path become valid
                //if (value && _Children is null)
                    //Children = GetChildren();
            }
        }

        /// <summary>
        /// Get a formated path to get 3ds max appdata and install folder
        /// </summary>
        public string RelativePath => _RelativePath ?? (_RelativePath = CDMaxPath.GetRelativePath(Path));

        /// <summary>
        /// Get or set the full path
        /// </summary>
        public string Path
        {
            get { return _Path; }
            set
            {
                Set(ref _Path, value);
                IsValidPath = GetIsValidPath();
            }
        }

        /// <summary>
        /// The text display in the treeview
        /// </summary>
        public override string Text
        {
            get { return _Text ?? (_Text = GetText()); }
            set { Set(ref _Text, value); }
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
        protected abstract string GetText();
        

        #endregion Methods

    }
}
