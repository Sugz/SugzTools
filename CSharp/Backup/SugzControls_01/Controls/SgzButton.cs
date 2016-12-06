using SgzControls.Src;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;

namespace SgzControls.Controls
{
    public class SgzButton_ : Button
    {

        // Dependency Properties
        #region // Dependency Properties


        /// <summary>
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }
        public static readonly DependencyProperty CornerRadiusProperty =
            DependencyProperty.Register("CornerRadius", typeof(int), typeof(SgzButton), new PropertyMetadata(3));



        #endregion // End Dependency Properties



        // Constructors
        #region Constructors


        public SgzButton_()
        {
            Style = Resource<Style>.GetStyle("SgzButtonStyle");
        }


        #endregion // End Constructors

    }


    public class SgzCheckButton_ : SgzButton_
    {

        // Dependency Properties
        #region // Dependency Properties


        /// <summary>
        /// Get / set the Checkstate property
        /// </summary>
        [Description("Get / set the Checkstate"), Category("Common")]
        public bool IsChecked
        {
            get { return (bool)GetValue(IsCheckedProperty); }
            set { SetValue(IsCheckedProperty, value); }
        }
        public static readonly DependencyProperty IsCheckedProperty =
            DependencyProperty.Register("IsChecked", typeof(bool), typeof(SgzCheckButton_), new PropertyMetadata(false));




        #endregion // End Dependency Properties



        // Constructors
        #region Constructors


        public SgzCheckButton_()
        {
            Style = Resource<Style>.GetStyle("SgzButtonStyle", "SgzCheckButtonStyle");
            Click += (s, e) => IsChecked = !IsChecked;
        }



        #endregion // End Constructors


    }
}
