using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Documents;

namespace CodeDoc.Model
{

    /// <summary>
    ///Iinterface to define a basic TreeViewItem 
    /// </summary>
    public interface ICDTreeViewItem
    {
        string Text { get; set; }
        FlowDocument Description { get; }
    }



    /// <summary>
    /// Base class for TreeViewItem
    /// </summary>
    public abstract class CDTreeViewItem : ICDTreeViewItem
    {
        // Fields
        #region Fields

        protected FlowDocument _Description;
        protected ObservableCollection<ICDTreeViewItem> _Children;


        #endregion // End Fields



        // Properties
        #region Properties


        public string Text { get; set; }
        public FlowDocument Description
        {
            get { return GetDescription(); }
        }
        public ObservableCollection<ICDTreeViewItem> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            set { _Children = value; }
        }


        #endregion // End Properties



        // Methods
        #region Methods


        protected abstract FlowDocument GetDescription();
        protected abstract ObservableCollection<ICDTreeViewItem> GetChildren();


        #endregion // End Methods


    }

}
