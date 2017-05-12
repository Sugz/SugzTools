using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;

namespace StyleApp
{
    public class User : INotifyPropertyChanged
    {
        public string Name { get; set; }

        public int Age { get; set; }

        public string Mail { get; set; }


        // INotifyPropertyChanged
        #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        #endregion // End INotifyPropertyChanged


        private int _MyProperty;
        public int MyProperty
        {
            get { return _MyProperty; }
            set
            {
                _MyProperty = value;
                OnPropertyChanged();
            }
        }


    }
}
