using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Controls
{
    public class SgzTreeViewItem : INotifyPropertyChanged
    {
        // INotifyPropertyChanged
        #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        #endregion // End INotifyPropertyChanged


        private ObservableCollection<object> _Children;
        public ObservableCollection<object> Children
        {
            get { return _Children ?? (_Children = new ObservableCollection<object>()); }
            set
            {
                _Children = value;
                OnPropertyChanged();
            }
        }

        private bool _SgzIsItemExpanded;
        public bool SgzIsItemExpanded
        {
            get { return _SgzIsItemExpanded; }
            set
            {
                _SgzIsItemExpanded = value;
                OnPropertyChanged();
            }
        }


        private bool _SgzIsItemSelected;
        public bool SgzIsItemSelected
        {
            get { return _SgzIsItemSelected; }
            set
            {
                _SgzIsItemSelected = value;
                OnPropertyChanged();
            }
        }

    }
}
