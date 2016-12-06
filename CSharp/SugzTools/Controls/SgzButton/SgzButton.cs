using Autodesk.Max;
using SugzTools.Max;
using SugzTools.Src;
using SugzTools.Themes;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Markup;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzButton : Button
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
        public Brush MouseOverBrush
        {
            get { return (Brush)GetValue(MouseOverBrushProperty); }
            set { SetValue(MouseOverBrushProperty, value); }
        }


        /// <summary>
        /// Define the MouseDown brush color
        /// </summary>
        [Description("Define the MouseDown brush color"), Category("Brush")]
        public Brush MouseDownBrush
        {
            get { return (Brush)GetValue(MouseDownBrushProperty); }
            set { SetValue(MouseDownBrushProperty, value); }
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
            typeof(SgzButton),
            new PropertyMetadata(false)
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius", 
            typeof(int), 
            typeof(SgzButton), 
            new PropertyMetadata(3)
        );


        // DependencyProperty as the backing store for MouseOverBrush
        public static readonly DependencyProperty MouseOverBrushProperty = DependencyProperty.Register(
            "MouseOverBrush",
            typeof(Brush),
            typeof(SgzButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for MouseDownBrush
        public static readonly DependencyProperty MouseDownBrushProperty = DependencyProperty.Register(
            "MouseDownBrush",
            typeof(Brush),
            typeof(SgzButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlueMouseOver"))
        );


        // Using a DependencyProperty as the backing store for BaseBorderThickness.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty BaseBorderThicknessProperty = DependencyProperty.Register(
            "BaseBorderThickness",
            typeof(Thickness),
            typeof(SgzButton),
            new PropertyMetadata(new Thickness(0))
        );



        #endregion Dependency Properties



        #region Constructors


        static SgzButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzButton), new FrameworkPropertyMetadata(typeof(SgzButton)));
            
        }
        public SgzButton()
        {
            Loaded += (s, e) => FocusVisualStyle = FocusVisualStyles.GetControlStyle(CornerRadius);

            Click += (sender, e) =>
            {

            };
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
