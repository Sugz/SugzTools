using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace CodeDoc.Model
{
    public enum ItemType
    {
        Folder,
        Script,
        Function
    }


    



    /// <summary>
    ///Iinterface to define a basic TreeViewItem 
    /// </summary>
    public interface ICDTreeViewItem
    {
        ItemType Type { get; set; }
        string Text { get; set; }
        StringCollection Description { get; set; }
    }



    /// <summary>
    /// Base class for TreeViewItem
    /// </summary>
    public abstract class CDTreeViewItem : ICDTreeViewItem
    {
        // Fields
        #region Fields

        protected StringCollection _Description;
        protected ObservableCollection<ICDTreeViewItem> _Children;


        #endregion // End Fields



        // Properties
        #region Properties


        public ItemType Type { get; set; }
        public string Text { get; set; }
        public StringCollection Description
        {
            get { return _Description ?? (_Description = GetDescription()); }
            set { _Description = value; }
        }
        public ObservableCollection<ICDTreeViewItem> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            set { _Children = value; }
        }


        #endregion // End Properties



        // Methods
        #region Methods


        protected abstract StringCollection GetDescription();
        protected abstract ObservableCollection<ICDTreeViewItem> GetChildren();


        #endregion // End Methods


    }

}
