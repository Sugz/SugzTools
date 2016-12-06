using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SgzControls.Controls
{
    public class SgzButton : Button
    {

        #region Properties


        /// <summary>
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }


        #endregion


        #region // Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius", 
            typeof(int), 
            typeof(SgzButton), 
            new PropertyMetadata(3)
        );



        #endregion Dependency Properties



        // Constructors
        #region Constructors


        static SgzButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzButton), new FrameworkPropertyMetadata(typeof(SgzButton)));
        }


        #endregion // End Constructors

    }


}
