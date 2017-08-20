using GalaSoft.MvvmLight;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace CodeDoc.ViewModel
{
    public class CDStatusVM : ViewModelBase
    {


        #region Fields


        private Visibility _DataPathFieldVisibility = Visibility.Collapsed;                                 // The visibility of the data path panel
        private Visibility _MissingDescriptionVisibility = Visibility.Collapsed;                            // The visibility of the missing description panel
        private Visibility _ProgressVisibility = Visibility.Collapsed;                                      // The visibility of the progress panel 


        #endregion Fields


        #region Properties


        /// <summary>
        /// Get or set the visibility of the data path panel
        /// </summary>
        public Visibility DataPathFieldVisibility
        {
            get { return _DataPathFieldVisibility; }
            set { Set(ref _DataPathFieldVisibility, value); }
        }


        /// <summary>
        /// Get or set the visibility of the missing description panel
        /// </summary>
        public Visibility MissingDescriptionVisibility
        {
            get { return _MissingDescriptionVisibility; }
            set { Set(ref _MissingDescriptionVisibility, value); }
        }


        /// <summary>
        /// Get or set the visibility of the missing description panel
        /// </summary>
        public Visibility ProgressVisibility
        {
            get { return _ProgressVisibility; }
            set { Set(ref _ProgressVisibility, value); }
        } 


        #endregion Properties


    }
}