using CodeDoc.Messaging;
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
    public class CDFolder : CDFileItem
    {

        #region Properties


        public override bool IsValidPath
        {
            get { return _IsValidPath; }
            set
            {
                Set(ref _IsValidPath, value);

                // Reload children when path become valid
                if (value && _Children is null)
                    Children = GetChildren();
            }
        }

        public override ObservableCollection<CDDataItem> Children
        {
            get => _Children ?? (_Children = GetChildren());
            protected set => _Children = value;
        } 


        #endregion Properties


        #region Constructors


        public CDFolder(object parent, string path) : this(parent, path, null, null) { }
        public CDFolder(object parent, string path, string text) : this(parent, path, text, null) { }
        public CDFolder(object parent, string path, string text, ObservableCollection<CDDataItem> children) : base(parent, path, text, children)
        {
            Type = CDDataItemType.Folder;
        } 


        #endregion Constructors


        #region Methods


        protected override bool GetIsValidPath() => Directory.Exists(Path);

        protected override string GetText() => System.IO.Path.GetFileName(Path);

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
