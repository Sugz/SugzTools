using CodeDoc.Messaging;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
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
    public interface IReadableItem
    {
        //bool IsMissingDescription { get; }
        StringCollection Description { get; }
    }


    public abstract class CDDataItem : ViewModelBase
    {

        #region Fields

        private bool _IsSelected = false;
        private bool _IsExpanded;
        protected string _Text;

        #endregion Fields


        #region Properties


        public CDDataItemType Type { get; set; }
        public object Parent { get; set; }
        public virtual string Text { get; set; }
        public bool IsSelected
        {
            get { return _IsSelected; }
            set
            {
                Set(ref _IsSelected, value);
                MessengerInstance.Send(new CDSelectedItemMessage(this));
            }
        }
        public bool IsExpanded
        {
            get { return _IsExpanded; }
            set { Set(ref _IsExpanded, value); }
        }


        #endregion Properties


        public CDDataItem(object parent) { Parent = parent; }


        #region Methods


        


        #endregion Methods


    }
}
