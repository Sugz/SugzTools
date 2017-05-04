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
    public class SgzContextMenu : ContextMenu
    {

        #region Properties


        /// <summary>
        /// Define the CornerRadius property
        /// </summary>
        [Description("Define the CornerRadius property"), Category("Appearance")]
        // [Browsable(false)]
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
            typeof(SgzContextMenu),
            new PropertyMetadata(3)
        );


        #endregion Dependency Properties


        #region Constructors


        static SgzContextMenu()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzContextMenu), new FrameworkPropertyMetadata(typeof(SgzContextMenu)));
        }
        

        #endregion Constructors
    }
}
