using System.ComponentModel;
using System.Runtime.CompilerServices;

namespace SugzMVVM
{
    public class NotifyPropertyChanged : INotifyPropertyChanged
    {
        // INotifyPropertyChanged
        #region INotifyPropertyChanged


        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }


        #endregion // End INotifyPropertyChanged
    }
}
