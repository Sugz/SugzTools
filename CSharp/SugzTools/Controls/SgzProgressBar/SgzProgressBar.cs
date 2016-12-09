using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System.Windows.Media.Animation;

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



        /// <summary>
        /// Get or set the Indeterminate brush
        /// </summary>
        [Description("Get or set the Indeterminate brush"), Category("Brush")]
        public Brush IndeterminateBrush
        {
            get { return (Brush)GetValue(IndeterminateBrushProperty); }
            set { SetValue(IndeterminateBrushProperty, value); }
        }

        // DependencyProperty as the backing store for IndeterminateBrush
        public static readonly DependencyProperty IndeterminateBrushProperty = DependencyProperty.Register(
            "IndeterminateBrush",
            typeof(Brush),
            typeof(SgzProgressBar),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        /*TODO: FIND A WAY TO IMPLEMENT :(:(:(:(
        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Appearance")]
        public bool IndeterminateAutoReverse
        {
            get { return (bool)GetValue(IndeterminateAutoReverseProperty); }
            set { SetValue(IndeterminateAutoReverseProperty, value); }
        }

        // DependencyProperty as the backing store for IndeterminateAutoReverse
        public static readonly DependencyProperty IndeterminateAutoReverseProperty = DependencyProperty.Register(
            "IndeterminateAutoReverse",
            typeof(bool),
            typeof(SgzProgressBar),
            new PropertyMetadata(false)
        );
        */





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

        public SgzProgressBar()
        {


        }


        #endregion Constructors


    }

}




