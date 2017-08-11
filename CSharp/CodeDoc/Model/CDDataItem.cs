using CodeDoc.Src;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public enum CDDataItemType
    {
        Folder,
        Script,
        Function
    }


    public abstract class CDDataItem : ViewModelBase
    {
        private bool _IsSelected = false;
        private bool _IsExpanded;

        public CDDataItemType Type { get; set; }
        public string Text { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public bool IsSelected
        {
            get { return _IsSelected; }
            set
            {
                Set(ref _IsSelected, value);
                MessengerInstance.Send(new CDSelectedItemMessage(this));
            }
        }

        
        /// <summary>
        /// 
        /// </summary>
        public bool IsExpanded
        {
            get { return _IsExpanded; }
            set { Set(ref _IsExpanded, value); }
        }


    }
}
