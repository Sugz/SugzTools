using SugzTools.Src;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;
using System;
using SugzTools.Themes;
using System.Windows.Media.Animation;

namespace SugzTools.Controls
{
    [TemplatePart(Name = "PART_Bullet", Type = typeof(Border))]
    public class SgzCheckBox : CheckBox
    {
        Border PART_Bullet;


        #region Properties


        /// <summary>
        /// Get or set if the checkbox looks like a toggle
        /// </summary>
        [Description("Get or set if the checkbox looks like a toggle."), Category("Appearance")]
        public bool IsSwitch
        {
            get { return (bool)GetValue(IsSwitchProperty); }
            set { SetValue(IsSwitchProperty, value); }
        }

        




        /// <summary>
        /// Get or set the checkstate that can be set either with a bool? or a int (0, 1, 2)
        /// </summary>
        [Description("Get or set the checkstate property with int:\n0: false\n1: true\n2: null"), Category("Common")]
        public int TriState
        {
            get { return (int)GetValue(TriStateProperty); }
            set { SetValue(TriStateProperty, value); }
        }


        /// <summary>
        /// Get or set the CornerRadius property
        /// </summary>
        [Description("Get or set the CornerRadius property"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }


        /// <summary>
        /// Get or set the Hover brush color
        /// </summary>
        [Description("Get or set the Hover brush color"), Category("Brush")]
        public Brush HoverBrush
        {
            get { return (Brush)GetValue(HoverBrushProperty); }
            set { SetValue(HoverBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the Checked brush
        /// </summary>
        [Description("Get or set the Checked brush"), Category("Brush")]
        public Brush CheckedBrush
        {
            get { return (Brush)GetValue(CheckedBrushProperty); }
            set { SetValue(CheckedBrushProperty, value); }
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
        /// Get or set the space bewteen the checkbox and the content
        /// </summary>
        [Description("Get or set the space bewteen the checkbox and the content"), Category("Layout")]
        public int Spacing
        {
            get { return (int)GetValue(SpacingProperty); }
            set { SetValue(SpacingProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for IsSwitch
        public static readonly DependencyProperty IsSwitchProperty = DependencyProperty.Register(
            "IsSwitch",
            typeof(bool),
            typeof(SgzCheckBox),
            new PropertyMetadata(false)
        );


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
        public static readonly DependencyProperty IndeterminateBrushProperty = DependencyProperty.Register(
            "IndeterminateBrus",
            typeof(Brush),
            typeof(SgzCheckBox),
            new PropertyMetadata(new SolidColorBrush(Colors.Black))
        );


        // DependencyProperty as the backing store for Spacing
        public static readonly DependencyProperty SpacingProperty = DependencyProperty.Register(
            "Spacing",
            typeof(int),
            typeof(SgzCheckBox),
            new PropertyMetadata(2)
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


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            if (IsSwitch && GetTemplateChild("PART_Bullet") is Border border)
            {
                PART_Bullet = border;
                PART_Bullet.RenderTransform = new TranslateTransform();
                PART_Bullet.RenderTransformOrigin = new Point(0, 0);

                Loaded += (s, e) => SwitchAnimation(TimeSpan.Zero);
                Click += (s, e) => SwitchAnimation(TimeSpan.FromMilliseconds(250));
            }
        }

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


        private void SwitchAnimation(TimeSpan time)
        {
            double from = IsChecked == true ? 0 : PART_Bullet.ActualWidth; 
            double to = IsChecked == true ? PART_Bullet.ActualWidth : 0;
            DoubleAnimation translateAnimation = new DoubleAnimation(from, to, time);
            PART_Bullet.RenderTransform.BeginAnimation(TranslateTransform.XProperty, translateAnimation);
        }


        #endregion Methods


    }
}
