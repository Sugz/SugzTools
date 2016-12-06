using SgzControls.Src;
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
    public class SgzCheckBox : CheckBox
    {


        #region Properties


        /// <summary>
        /// Get / Set the placement of the label
        /// </summary>
        [Description("Get / Set the placement of the label"), Category("Appearance")]
        public LabelPlacement LabelPlacement
        {
            get { return (LabelPlacement)GetValue(StringPlacemementProperty); }
            set { SetValue(StringPlacemementProperty, value); }
        }


        #endregion



        #region // Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty StringPlacemementProperty = DependencyProperty.Register(
            "LabelPlacement",
            typeof(LabelPlacement),
            typeof(SgzCheckBox),
            new PropertyMetadata(LabelPlacement.Left)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzCheckBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzCheckBox), new FrameworkPropertyMetadata(typeof(SgzCheckBox)));
        }
        public SgzCheckBox()
        {

        }



        #endregion Constructors


    }
}

