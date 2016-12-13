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
    [TemplatePart(Name = "PART_Border", Type = typeof(Border))]
    [TemplatePart(Name = "PART_Animation", Type = typeof(Border))]
    public class SgzProgressBar : ProgressBar
    {

        #region Fields


        Border PART_Border;                             // The main border where is define the VisualStateGroup
        Border PART_Animation;                          // The border used for the indeterminate animation or tracking the value


        #endregion Fields



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


        /// <summary>
        /// Get or set if the animation should be autoreversed when the control is in Indeterminate state 
        /// </summary>
        [Description("Get or set if the animation should be autoreversed when the control is in Indeterminate state "), Category("Appearance")]
        public bool IndeterminateAutoReverse
        {
            get { return (bool)GetValue(IndeterminateAutoReverseProperty); }
            set { SetValue(IndeterminateAutoReverseProperty, value); }
        }


        /// <summary>
        /// The brush use for the Cylon Mode
        /// </summary>
        [Description("The brush use for the Cylon Mode"), Category("Brush")]
        public Brush CylonBrush
        {
            get { return (Brush)GetValue(CylonBrushProperty); }
            set { SetValue(CylonBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the Cylon Mode. If true, switch to Indeterminate, IndeterminateBrush become red and IndeterminateAutoReverse is true, false switch everything back to normal
        /// </summary>
        [Description("Get or set the Cylon Mode. If true, switch to Indeterminate, IndeterminateBrush become red and IndeterminateAutoReverse is true, false switch everything back to normal"), Category("Appearance")]
        public bool IsCylon
        {
            get { return (bool)GetValue(IsCylonProperty); }
            set { SetValue(IsCylonProperty, value); }
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


        // DependencyProperty as the backing store for IndeterminateBrush
        public static readonly DependencyProperty IndeterminateBrushProperty = DependencyProperty.Register(
            "IndeterminateBrush",
            typeof(Brush),
            typeof(SgzProgressBar),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for CylonBrush
        public static readonly DependencyProperty CylonBrushProperty = DependencyProperty.Register(
            "CylonBrush",
            typeof(Brush),
            typeof(SgzProgressBar),
            new PropertyMetadata(new SolidColorBrush(Colors.Red))
        );


        // DependencyProperty as the backing store for IsCylon
        public static readonly DependencyProperty IsCylonProperty = DependencyProperty.Register(
            "IsCylon",
            typeof(bool),
            typeof(SgzProgressBar),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for IndeterminateAutoReverse
        public static readonly DependencyProperty IndeterminateAutoReverseProperty = DependencyProperty.Register(
            "IndeterminateAutoReverse",
            typeof(bool),
            typeof(SgzProgressBar),
            new PropertyMetadata(false, (d, e) => (d as SgzProgressBar)?.SetIndeterminateAutoReverse())
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzProgressBar()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzProgressBar), new FrameworkPropertyMetadata(typeof(SgzProgressBar)));
        }
        public SgzProgressBar()
        {
            Loaded += (s, e) => SetIndeterminateAutoReverse();
        }


        #endregion Constructors



        #region Methods


        #region Override


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            Border border = GetTemplateChild("PART_Border") as Border;
            if (border != null)
                PART_Border = border;

            border = GetTemplateChild("PART_Animation") as Border;
            if (border != null)
                PART_Animation = border;
        }


        #endregion Override


        #region Private


        private void SetIndeterminateAutoReverse()
        {
            // Make sure that the template has been apply
            if (PART_Border != null && PART_Animation != null)
            {
                // If IsIndeterminate is false, then CurrentState is null
                VisualStateGroup visualStateGroup = (VisualStateGroup)VisualStateManager.GetVisualStateGroups(PART_Border)[0];
                if (visualStateGroup.CurrentState != null)
                {
                    Storyboard storyBoard = visualStateGroup.CurrentState.Storyboard;
                    storyBoard.Stop();
                    storyBoard.AutoReverse = IndeterminateAutoReverse;
                    storyBoard.Begin(PART_Animation);
                }
            }
        }


        #endregion Private


        #endregion Methods
    }

}




