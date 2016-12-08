using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzProgressBar : ProgressBar
    {


        #region Properties


        /// <summary>
        /// Get or set the radius of the control's corner
        /// </summary>
        [Description("Get or set the radius of the control's corner"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzProgressBar),
            new PropertyMetadata(0)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzProgressBar()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzProgressBar), new FrameworkPropertyMetadata(typeof(SgzProgressBar)));
        }


        #endregion Constructors


    }
}
