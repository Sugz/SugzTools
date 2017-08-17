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

namespace CodeDoc.Controls
{
    public class SgzMultiLineTextBox : TextBox
    {

        #region Fields





        #endregion Fields


        #region Properties


        /// <summary>
        /// Get or set the focus color
        /// </summary>
        [Description("Get or set the focus color"), Category("Brush")]
        public Brush FocusBrush
        {
            get { return (Brush)GetValue(FocusBrushProperty); }
            set { SetValue(FocusBrushProperty, value); }
        }


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
        /// Get or set the control's watermark
        /// </summary>
        [Description("Get or set the control's watermark"), Category("Common")]
        public string Watermark
        {
            get { return (string)GetValue(WatermarkProperty); }
            set { SetValue(WatermarkProperty, value); }
        }


        /// <summary>
        /// Get or set the control's watermark foreground
        /// </summary>
        [Description("Get or set the control's watermark foreground"), Category("Brush")]
        public Brush WaterMarkForeground
        {
            get { return (Brush)GetValue(WaterMarkForegroundProperty); }
            set { SetValue(WaterMarkForegroundProperty, value); }
        }


        /// <summary>
        /// Get opr set the control's watermark font style
        /// </summary>
        [Description("Get opr set the control's watermark font style"), Category("Common")]
        public FontStyle WatermarkFontStyle
        {
            get { return (FontStyle)GetValue(WatermarkFontStyleProperty); }
            set { SetValue(WatermarkFontStyleProperty, value); }
        }


        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for FocusBrush
        public static readonly DependencyProperty FocusBrushProperty = DependencyProperty.Register(
            "FocusBrush",
            typeof(Brush),
            typeof(SgzMultiLineTextBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxFocusBorder"))
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzMultiLineTextBox),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for Watermark
        public static readonly DependencyProperty WatermarkProperty = DependencyProperty.Register(
            "Watermark",
            typeof(string),
            typeof(SgzMultiLineTextBox),
            new PropertyMetadata(string.Empty)
        );


        // DependencyProperty as the backing store for WaterMarkForeground
        public static readonly DependencyProperty WaterMarkForegroundProperty = DependencyProperty.Register(
            "WaterMarkForeground",
            typeof(Brush),
            typeof(SgzMultiLineTextBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxRolloutIcon"))
        );


        // DependencyProperty as the backing store for WatermarkFontStyle
        public static readonly DependencyProperty WatermarkFontStyleProperty = DependencyProperty.Register(
            "WatermarkFontStyle",
            typeof(FontStyle),
            typeof(SgzMultiLineTextBox),
            new PropertyMetadata(FontStyles.Italic)
        );


        #endregion Dependency Properties


        #region Constructors


        static SgzMultiLineTextBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzMultiLineTextBox), new FrameworkPropertyMetadata(typeof(SgzMultiLineTextBox)));
        }
        public SgzMultiLineTextBox()
        {

        }


        #endregion Constructors


        #region Methods





        #endregion Methods

    }
}

