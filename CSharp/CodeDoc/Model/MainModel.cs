using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public abstract class MainModel
    {
        // Fields
        #region Fields


        protected ObservableCollection<MainModel> _Children;


        #endregion // End Fields


        // Properties
        #region Properties


        public string Text { get; private set; }
        public ObservableCollection<MainModel> Children
        {
            get { return _Children ?? (_Children = GetChildren()); }
            set { _Children = value; }
        }


        #endregion // End Properties



        // Methods
        #region Methods


        protected abstract ObservableCollection<MainModel> GetChildren();


        #endregion // End Methods
    }
}
