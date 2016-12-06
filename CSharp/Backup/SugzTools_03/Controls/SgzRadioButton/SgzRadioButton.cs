using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzRadioButton : RadioButton
    {

        #region Fields


        //private SgzRadioButtonTypes _Type = SgzRadioButtonTypes.Standard;


        #endregion Fields



        #region Properties


        /// <summary>
        /// Get / Set the type of the radiobutton (radiobutton or checkbutton)
        /// </summary>
        [Description("Get / Set the type of the radiobutton (radiobutton or checkbutton)"), Category("Appearance")]
        public SgzRadioButtonTypes Type
        {
            get { return (SgzRadioButtonTypes)GetValue(TypeProperty); }
            set { SetValue(TypeProperty, value); }
        }

        //public SgzRadioButtonTypes Type
        //{
        //    get { return _Type; }
        //    set
        //    {
        //        _Type = value;
        //        SwitchType();
        //    }
        //}



        /// <summary>
        /// Get / Set the placement of the label
        /// </summary>
        [Description("Get / Set the placement of the label"), Category("Appearance")]
        public LabelPlacement LabelPlacement
        {
            get { return (LabelPlacement)GetValue(LabelPlacementProperty); }
            set { SetValue(LabelPlacementProperty, value); }
        }



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
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
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


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for Type
        public static readonly DependencyProperty TypeProperty = DependencyProperty.Register(
            "Type",
            typeof(SgzRadioButtonTypes),
            typeof(SgzRadioButton),
            new PropertyMetadata(SgzRadioButtonTypes.Standard)
        );


        // Using a DependencyProperty as the backing store for LabelPlacement.
        public static readonly DependencyProperty LabelPlacementProperty = DependencyProperty.Register(
            "LabelPlacement", 
            typeof(LabelPlacement), 
            typeof(SgzRadioButton), 
            new PropertyMetadata(LabelPlacement.Left)
        );


        // DependencyProperty as the backing store for IsTransparent
        public static readonly DependencyProperty IsTransparentProperty = DependencyProperty.Register(
            "IsTransparent",
            typeof(bool),
            typeof(SgzRadioButton),
            new PropertyMetadata(false)
        );


        // Using a DependencyProperty as the backing store for CornerRadius.
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius", 
            typeof(int), 
            typeof(SgzRadioButton), 
            new PropertyMetadata(3)
        );


        // DependencyProperty as the backing store for MouseOverBrush
        public static readonly DependencyProperty MouseOverBrushProperty = DependencyProperty.Register(
            "MouseOverBrush",
            typeof(Brush),
            typeof(SgzRadioButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for MouseDownBrush
        public static readonly DependencyProperty MouseDownBrushProperty = DependencyProperty.Register(
            "MouseDownBrush",
            typeof(Brush),
            typeof(SgzRadioButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlueMouseOver"))
        );


        // DependencyProperty as the backing store for CheckedBrush
        public static readonly DependencyProperty CheckedBrushProperty = DependencyProperty.Register(
            "CheckedBrush",
            typeof(Brush),
            typeof(SgzRadioButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // Using a DependencyProperty as the backing store for BaseBorderThickness.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty BaseBorderThicknessProperty = DependencyProperty.Register(
            "BaseBorderThickness",
            typeof(Thickness),
            typeof(SgzRadioButton),
            new PropertyMetadata(new Thickness(0))
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzRadioButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzRadioButton), new FrameworkPropertyMetadata(typeof(SgzRadioButton)));
        }
        public SgzRadioButton()
        {

        }
        //public SgzRadioButton() : this(SgzRadioButtonTypes.Standard) { }
        //public SgzRadioButton(SgzRadioButtonTypes type)
        //{
        //    _Type = type;
        //    SwitchType();
        //}


        #endregion Constructors



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (!IsTransparent)
                BaseBorderThickness = BorderThickness;
        }


        #endregion Overrides



        #region Methods


        //private void SwitchType()
        //{
        //    switch (Type)
        //    {
        //        case SgzRadioButtonTypes.CheckButton:
        //            Style = Resource<Style>.GetStyle("Generic", "SgzRadioCheckButtonStyle");
        //            break;
        //        case SgzRadioButtonTypes.Standard:
        //        default:
        //            Style = Resource<Style>.GetStyle("Generic", "SgzRadioButtonStyle");
        //            break;
        //    }
        //}


        #endregion Methods

    }

}
