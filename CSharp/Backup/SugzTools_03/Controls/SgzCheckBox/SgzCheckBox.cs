using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace SugzTools.Controls
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
            get { return (LabelPlacement)GetValue(LabelPlacementProperty); }
            set { SetValue(LabelPlacementProperty, value); }
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
        /// Define the Checked brush
        /// </summary>
        [Description("Define the Checked brush"), Category("Brush")]
        public Brush CheckedBrush
        {
            get { return (Brush)GetValue(CheckedBrushProperty); }
            set { SetValue(CheckedBrushProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty LabelPlacementProperty = DependencyProperty.Register(
            "LabelPlacement",
            typeof(LabelPlacement),
            typeof(SgzCheckBox),
            new PropertyMetadata(LabelPlacement.Left)
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzCheckBox),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for MouseOverBrush
        public static readonly DependencyProperty MouseOverBrushProperty = DependencyProperty.Register(
            "MouseOverBrush",
            typeof(Brush),
            typeof(SgzCheckBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for CheckedBrush
        public static readonly DependencyProperty CheckedBrushProperty = DependencyProperty.Register(
            "CheckedBrush",
            typeof(Brush),
            typeof(SgzCheckBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxText"))
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

