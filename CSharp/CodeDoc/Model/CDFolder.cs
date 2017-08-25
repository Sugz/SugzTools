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

        protected override ObservableCollection<CDDataItem> GetChildren()
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
