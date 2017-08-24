using CodeDoc.Messaging;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Documents;

namespace CodeDoc.Model
{
    public enum CDDataItemType
    {
        Folder,
        Script,
        Function,
        Struct,
        Rollout,
    }


    /// <summary>
    /// Common interface for script and function
    /// </summary>
    public interface IDescriptionItem
    {
        StringCollection Description { get; }
    }

    public interface IPathItem
    {
        bool IsValidPath { get; }
        string RelativePath { get; }
        string Path { get; }

        //bool GetIsValidPath();
    }


    public abstract class CDDataItem : ViewModelBase
    {

        #region Fields

        private bool _IsSelected = false;
        private bool _IsExpanded;
        protected string _Text;
        protected ObservableCollection<CDDataItem> _Children = new ObservableCollection<CDDataItem>(); //TODO: remove initialization here

        #endregion Fields


        #region Properties

        //TODO: check if Type is usefull
        /// <summary>
        /// Enum for all the final implementation of CDDataItem
        /// </summary>
        public CDDataItemType Type { get; set; }

        //TODO: need to check if folder need parent 
        /// <summary>
        /// The treeviewitem parent
        /// </summary>
        public object Parent { get; set; } 

        /// <summary>
        /// Binding for the treeviewitem text
        /// </summary>
        public virtual string Text { get; set; }

        /// <summary>
        /// Get or set the collection of children in the treeview
        /// </summary>
        public virtual ObservableCollection<CDDataItem> Children
        {
            //get { return _Children ?? (_Children = GetChildren()); }
            get => _Children;
            set => Set(ref _Children, value);
        }

        /// <summary>
        /// Binding for the treeview SelectedItem
        /// Messages viewmodels
        /// </summary>
        public bool IsSelected
        {
            get => _IsSelected;
            set
            {
                Set(ref _IsSelected, value);
                MessengerInstance.Send(new CDSelectedItemMessage(this));
            }
        }

        /// <summary>
        /// Binding for the expand state of a treeviewitem
        /// </summary>
        public bool IsExpanded
        {
            get => _IsExpanded;
            set => Set(ref _IsExpanded, value);
        }


        #endregion Properties


        public CDDataItem(object parent) : this(parent, null) { }
        public CDDataItem(string text) : this(null, text) { }
        public CDDataItem(object parent, string text)
        {
            Parent = parent;
            Text = text;
        }


        #region Methods


        //protected abstract ObservableCollection<CDDataItem> GetChildren();


        #endregion Methods


    }
}
