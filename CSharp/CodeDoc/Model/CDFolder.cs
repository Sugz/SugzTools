using CodeDoc.Messaging;
using CodeDoc.Src;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;

namespace CodeDoc.Model
{
    public class CDFolder : CDDataItem, IPathItem //CDFileItem
    {

        #region Fields

        private bool _IsValidPath;
        private string _RelativePath;
        private string _Path;


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
                if (value && _Children is null)
                    Children = GetChildren();
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
                IsValidPath = Directory.Exists(Path);
            }
        }

        public override ObservableCollection<CDDataItem> Children
        {
            get => _Children ?? (_Children = GetChildren());
            set => Set(ref _Children, value);
        }


        #endregion Properties

        #region Constructors


        //public CDFolder(object parent, string path) : this(parent, path, null, null) { }
        public CDFolder(object parent, string text, string path) : base(parent, text) //this(parent, path, text, null)
        {
            Type = CDDataItemType.Folder;
            Path = path;
        }
        //public CDFolder(object parent, string path, string text, ObservableCollection<CDDataItem> children) : base(parent, path, text, children)
        //{
        //    Type = CDDataItemType.Folder;
        //    Path = path;

        //} 


        #endregion Constructors


        #region Methods


        //private void GetIsValidPath() => IsValidPath = Directory.Exists(Path);

        private string GetText() => System.IO.Path.GetFileName(Path);

        private ObservableCollection<CDDataItem> GetChildren()
        {
            if (!IsValidPath)
                return null;

            ObservableCollection<CDDataItem> children = new ObservableCollection<CDDataItem>();
            Directory.GetFiles(Path).ToList().ForEach(x => children.Add(new CDScript(this, x)));
            return children;
        }


        #endregion Methods

    }
}
