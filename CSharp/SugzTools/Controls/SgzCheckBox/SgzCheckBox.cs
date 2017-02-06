using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System;
using SugzTools.Themes;

namespace SugzTools.Controls
{
    public class SgzCheckBox : CheckBox
    {


        #region Properties


        /// <summary>
        /// Define the checkstate that can be set either with a bool? or a int (0, 1, 2)
        /// </summary>
        [Description("Define the checkstate property with int:\n0: false\n1: true\n2: null"), Category("Common")]
        public int TriState
        {
            get { return (int)GetValue(TriStateProperty); }
            set { SetValue(TriStateProperty, value); }
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
        /// Define the Checked brush
        /// </summary>
        [Description("Define the Checked brush"), Category("Brush")]
        public Brush CheckedBrush
        {
            get { return (Brush)GetValue(CheckedBrushProperty); }
            set { SetValue(CheckedBrushProperty, value); }
        }


        /// <summary>
        /// Define the Intermediate brush
        /// </summary>
        [Description("Define the Intermediate brush"), Category("Brush")]
        public Brush IntermediateBrush
        {
            get { return (Brush)GetValue(IntermediateBrushProperty); }
            set { SetValue(IntermediateBrushProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for TriState
        public static readonly DependencyProperty TriStateProperty = DependencyProperty.Register(
            "TriState",
            typeof(int),
            typeof(SgzCheckBox),
            new PropertyMetadata(0, TriState_PropertyChanged)
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzCheckBox),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty HoverBrushProperty = DependencyProperty.Register(
            "HoverBrush",
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


        // DependencyProperty as the backing store for IntermediateBrush
        public static readonly DependencyProperty IntermediateBrushProperty = DependencyProperty.Register(
            "IntermediateBrush",
            typeof(Brush),
            typeof(SgzCheckBox),
            new PropertyMetadata(new SolidColorBrush(Colors.Black))
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzCheckBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzCheckBox), new FrameworkPropertyMetadata(typeof(SgzCheckBox)));
        }
        public SgzCheckBox()
        {
            Loaded += (s, e) => FocusVisualStyle = FocusVisualStyles.GetControlStyle(3, -2);
        }


        #endregion Constructors



        #region Methods


        /// <summary>
        /// Set the IsChecked property from the TriState property
        /// </summary>
        /// <param name="d"></param>
        /// <param name="e"></param>
        private static void TriState_PropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzCheckBox _this = (SgzCheckBox)d;
            switch ((int)e.NewValue)
            {
                case 1:
                    _this.IsChecked = true;
                    break;
                case 2:
                    _this.IsChecked = null;
                    break;
                default:
                    _this.IsChecked = false;
                    break;
            }
        } 


        #endregion Methods


    }
}
