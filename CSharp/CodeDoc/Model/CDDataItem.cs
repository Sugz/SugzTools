﻿using CodeDoc.Messaging;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
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
        Function
    }


    /// <summary>
    /// Common interface for script and function
    /// </summary>
    public interface IDescriptiveItem
    {
        bool IsMissingDescription { get; set; }
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
        public string Text
        {
            get { return _Text ?? (_Text = GetText()); }
            set { Set(ref _Text, value); }
        }
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


        protected abstract string GetText();


        #endregion Methods


    }
}