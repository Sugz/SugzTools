using PhotoGuideLines.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;

namespace PhotoGuideLines.ViewModel
{
    public class PGLViewModel : INotifyPropertyChanged
    {

        // INotifyPropertyChanged
         #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        #endregion // End INotifyPropertyChanged


        // Fields
        #region Fields


        private Grid _Grid;


        #endregion // End Fields



        // Properties
        #region Properties


        public Grid Grid
        {
            get { return _Grid; }
            set
            {
                if (_Grid != value)
                {
                    _Grid = value;
                    OnPropertyChanged();
                }
            }
        }




        #endregion // End Properties



        // Constructors
        #region Constructors


        public PGLViewModel()
        {
            RuleOfThird third = new RuleOfThird();
            Grid = third.Grid;
        }


        #endregion // End Constructors
        



    }
}
