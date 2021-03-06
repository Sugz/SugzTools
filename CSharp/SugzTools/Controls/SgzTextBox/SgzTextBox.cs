﻿using SugzTools.Src;
using System;
using System.ComponentModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Linq;

namespace SugzTools.Controls
{

    [TemplatePart(Name = "PART_Grid", Type = typeof(Grid))]
    [TemplatePart(Name = "PART_Focus", Type = typeof(Border))]
    public class SgzTextBox : TextBox
    {

        #region Fields


        Grid PART_Grid;
        Border PART_Focus;


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


        public UIElement UIElement0 { get; set; }
        public UIElement UIElement1 { get; set; }
        public UIElement UIElement2 { get; set; }


        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for FocusBrush
        public static readonly DependencyProperty FocusBrushProperty = DependencyProperty.Register(
            "FocusBrush",
            typeof(Brush),
            typeof(SgzTextBox),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxFocusBorder"))
        );


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
            Loaded += (s, e) =>
            {
                if (UIElement0 != null) SetUIElement(UIElement0, 0);
                if (UIElement1 != null) SetUIElement(UIElement1, 1);
                if (UIElement2 != null) SetUIElement(UIElement2, 2);
            };
        }


        #endregion Contructors



        #region Methods


        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            PART_Grid = GetTemplateChild("PART_Grid") as Grid;
            PART_Focus = GetTemplateChild("PART_Focus") as Border;
        }


        #endregion Overrides



        #region Event Handlers


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


        #endregion Event Handlers



        #region Public

        public void SetUIElement(UIElement control, int index)
        {
            if (PART_Grid != null && PART_Focus != null &&
                (index == 0 || index == 1 || index == 2))
            {
                int column = (index == 0) ? index : index + 1;

                // Remove existing control
                PART_Grid.Children.Remove(PART_Grid.Children.Cast<UIElement>().SingleOrDefault(x => Grid.GetColumn(x) == column && x != PART_Focus));

                PART_Grid.Children.Add(control);
                Grid.SetColumn(control, column);
            }
        }



        #endregion Public


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