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
    public class SgzGroupBox : GroupBox
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
            typeof(SgzGroupBox),
            new PropertyMetadata(3)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzGroupBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzGroupBox), new FrameworkPropertyMetadata(typeof(SgzGroupBox)));
        }
        public SgzGroupBox()
        {

        }


        #endregion Constructors


    }
}
