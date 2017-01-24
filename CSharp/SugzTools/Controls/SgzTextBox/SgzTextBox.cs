using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Linq;

namespace SugzTools.Controls
{

    
    public class SgzTextBox : TextBox
    {

        Grid PART_Grid;
        Border PART_Focus;


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


        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzTextBox),
            new PropertyMetadata(0)
        );


        // DependencyProperty as the backing store for Watermark
        public static readonly DependencyProperty WatermarkProperty = DependencyProperty.Register(
            "Watermark",
            typeof(string),
            typeof(SgzTextBox),
            new PropertyMetadata(string.Empty)
        );


        // DependencyProperty as the backing store for WaterMarkForeground
        public static readonly DependencyProperty WaterMarkForegroundProperty = DependencyProperty.Register(
            "WaterMarkForeground",
            typeof(Brush),
            typeof(SgzTextBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxRolloutIcon"))
        );


        // DependencyProperty as the backing store for WatermarkFontStyle
        public static readonly DependencyProperty WatermarkFontStyleProperty = DependencyProperty.Register(
            "WatermarkFontStyle",
            typeof(FontStyle),
            typeof(SgzTextBox),
            new PropertyMetadata(FontStyles.Italic)
        );


        #endregion Dependency Properties



        #region Published Events


        public event EventHandler<SgzTextBoxEventArgs> Validate;


        #endregion Published Events



        #region Contructors


        static SgzTextBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzTextBox), new FrameworkPropertyMetadata(typeof(SgzTextBox)));
        }
        public SgzTextBox()
        {
            KeyDown += SgzTextBox_KeyDown;
        }


        #endregion Contructors



        #region Methods


        private void SgzTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);

                // Call the Validate event
                Validate?.Invoke(this, new SgzTextBoxEventArgs(Text));
            }
        }


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            PART_Grid = GetTemplateChild("PART_Grid") as Grid;
            PART_Focus = GetTemplateChild("PART_Focus") as Border;
        }



        public void AddControl(Control control, int column)
        {
            if (PART_Grid != null && PART_Focus != null && 
                (column == 0 || column == 2 || column == 3))
            {
                // Remove existing control
                PART_Grid.Children.Remove(PART_Grid.Children.Cast<UIElement>().SingleOrDefault(x => Grid.GetColumn(x) == column && x != PART_Focus));

                PART_Grid.Children.Add(control);
                Grid.SetColumn(control, column);
            }
        }


        #endregion Methods


    }



    //     EVENTARGS     /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class SgzTextBoxEventArgs : EventArgs
    {
        public string Text { get; set; }

        public SgzTextBoxEventArgs(string text)
        {
            Text = text;
        }
    }


    //     3DS MAX IMPLEMENTATION     ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    public class SgzMaxTextbox : SgzTextBox
    {
        public SgzMaxTextbox()
        {
            GotFocus += (s, e) => ManagedServices.AppSDK.DisableAccelerators();
            LostFocus += (s, e) => ManagedServices.AppSDK.EnableAccelerators();
        }
    }
}