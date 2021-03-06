﻿using SugzTools.Src;
using SugzTools.Themes;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzCheckButton : ToggleButton
    {

        #region Properties


        /// <summary>
        /// Define if the button will be transparent in it's normal state
        /// </summary>
        [Description("Define if the button will be transparent in it's normal state"), Category("Appearance")]
        public bool IsTransparent
        {
            get { return (bool)GetValue(IsTransparentProperty); }
            set { SetValue(IsTransparentProperty, value); }
        }



        /// <summary>
        /// Define the CornerRadius property
        /// </summary>
        [Description("Define the CornerRadius property"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }



        /// <summary>
        /// Define the MouseOver brush color
        /// </summary>
        [Description("Define the MouseOver brush color"), Category("Brush")]
        public Brush HoverBrush
        {
            get { return (Brush)GetValue(HoverBrushProperty); }
            set { SetValue(HoverBrushProperty, value); }
        }



        /// <summary>
        /// Define the MouseDown brush color
        /// </summary>
        [Description("Define the MouseDown brush color"), Category("Brush")]
        public Brush PressedBrush
        {
            get { return (Brush)GetValue(PressedBrushProperty); }
            set { SetValue(PressedBrushProperty, value); }
        }
        


        /// <summary>
        /// Define the Checked brush
        /// </summary>
        [Description("Define the Checked brush"), Category("Brush")]
        public Brush CheckedBrush
        {
            get { return (Brush)GetValue(CheckedBrushProperty); }
            set { SetValue(CheckedBrushProperty, value); }
        }



        /// <summary>
        /// Define a borderthickness to use when the control use IsTransparent
        /// </summary>
        [Browsable(false)]
        public Thickness BaseBorderThickness
        {
            get { return (Thickness)GetValue(BaseBorderThicknessProperty); }
            set { SetValue(BaseBorderThicknessProperty, value); }
        }



        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for IsTransparent
        public static readonly DependencyProperty IsTransparentProperty = DependencyProperty.Register(
            "IsTransparent",
            typeof(bool),
            typeof(SgzCheckButton),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzCheckButton),
            new PropertyMetadata(3)
        );


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty HoverBrushProperty = DependencyProperty.Register(
            "HoverBrush",
            typeof(Brush),
            typeof(SgzCheckButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for PressedBrush
        public static readonly DependencyProperty PressedBrushProperty = DependencyProperty.Register(
            "PressedBrush",
            typeof(Brush),
            typeof(SgzCheckButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlueMouseOver"))
        );



        // DependencyProperty as the backing store for CheckedBrush
        public static readonly DependencyProperty CheckedBrushProperty = DependencyProperty.Register(
            "CheckedBrush",
            typeof(Brush),
            typeof(SgzCheckButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );



        // Using a DependencyProperty as the backing store for BaseBorderThickness.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty BaseBorderThicknessProperty = DependencyProperty.Register(
            "BaseBorderThickness",
            typeof(Thickness),
            typeof(SgzCheckButton),
            new PropertyMetadata(new Thickness(0))
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzCheckButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzCheckButton), new FrameworkPropertyMetadata(typeof(SgzCheckButton)));
        }
        public SgzCheckButton()
        {
            Loaded += (s, e) => FocusVisualStyle = FocusVisualStyles.GetControlStyle(3);
        }


        #endregion Constructors



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (!IsTransparent)
                BaseBorderThickness = BorderThickness;
        }


        #endregion Overrides


    }


}
