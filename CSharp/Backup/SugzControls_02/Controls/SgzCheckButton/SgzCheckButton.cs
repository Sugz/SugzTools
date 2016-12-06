using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;

namespace SgzControls.Controls
{
    public class SgzCheckButton : SgzButton
    {

        #region Properties


        /// <summary>
        /// Get / set the Checkstate property
        /// </summary>
        [Description("Get / set the Checkstate"), Category("Common")]
        public bool IsChecked
        {
            get { return (bool)GetValue(IsCheckedProperty); }
            set { SetValue(IsCheckedProperty, value); }
        }


        #endregion


        #region // Dependency Properties


        // DependencyProperty as the backing store for IsChecked
        public static readonly DependencyProperty IsCheckedProperty = DependencyProperty.Register(
            "IsChecked", 
            typeof(bool), 
            typeof(SgzCheckButton), 
            new PropertyMetadata(false)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzCheckButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzCheckButton), new FrameworkPropertyMetadata(typeof(SgzCheckButton)));
        }
        public SgzCheckButton()
        {
            Click += (s, e) => IsChecked = !IsChecked;
        }


        #endregion Constructors


    }


}
