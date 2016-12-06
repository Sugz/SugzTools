using SugzControls.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace SugzControls.Controls
{
    public enum ButtonType
    {
        Icon,
        Text,
        IconAndText
    }

    public class SugzButton : Button
    {

        // Fields
        #region Fields





        #endregion // End Fields



        // Properties
        #region Properties









        #endregion // End Properties



        // Dependency Properties
        #region Dependency Properties



        /// <summary>
        /// Get / set the appearance of the button (Icon, Text or Icon and Text)
        /// </summary>
        [Description("Get / set the appearance of the button (Icon, Text or Icon and Text)"), Category("Appearance")]
        public ButtonType ButtonType
        {
            get { return (ButtonType)GetValue(ButtonTypeProperty); }
            set { SetValue(ButtonTypeProperty, value); }
        }

        // Using a DependencyProperty as the backing store for ButtonType.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty ButtonTypeProperty =
            DependencyProperty.Register("ButtonType", 
                typeof(ButtonType), 
                typeof(SugzButton), 
                new PropertyMetadata(ButtonType.IconAndText));



        /// <summary>
        /// Get / set the text of the button
        /// </summary>
        [Description("Get / set the text of the button"), Category("Common")]
        public string Text
        {
            get { return (string)GetValue(TextProperty); }
            set { SetValue(TextProperty, value); }
        }

        public static readonly DependencyProperty TextProperty =
            DependencyProperty.Register("Text", 
                typeof(string), 
                typeof(SugzButton), 
                new PropertyMetadata("SugzButton"));



        /// <summary>
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }

        public static readonly DependencyProperty CornerRadiusProperty =
            DependencyProperty.Register("CornerRadius", 
                typeof(int), 
                typeof(SugzButton), 
                new PropertyMetadata(0));



        /// <summary>
        /// Get / set the OverBrush property
        /// </summary>
        [Description("Get / set the overlay color when the mouse is over"), Category("Brush")]
        public Brush OverBrush
        {
            get { return (Brush)GetValue(OverBrushProperty); }
            set { SetValue(OverBrushProperty, value); }
        }

        public static DependencyProperty OverBrushProperty =
            DependencyProperty.RegisterAttached("OverBrush", 
                typeof(Brush), 
                typeof(SugzButton),
                new PropertyMetadata(Resource<SolidColorBrush>.GetColor("SugzWhite20")));



        /// <summary>
        /// Get / set the PressedBrush property
        /// </summary>
        [Description("Get / set the overlay color when the mouse is pressed"), Category("Brush")]
        public Brush PressedBrush
        {
            get { return (Brush)GetValue(PressedBrushProperty); }
            set { SetValue(PressedBrushProperty, value); }
        }

        public static DependencyProperty PressedBrushProperty =
            DependencyProperty.RegisterAttached("PressedBrush", 
                typeof(Brush), 
                typeof(SugzButton),
                new PropertyMetadata(Resource<SolidColorBrush>.GetColor("SugzBlack30")));



        /// <summary>
        /// Get / set the CheckedBrush property
        /// </summary>
        [Description("Get / set the color when the button is checked"), Category("Brush")]
        public Brush CheckedBrush
        {
            get { return (Brush)GetValue(CheckedBrushProperty); }
            set { SetValue(CheckedBrushProperty, value); }
        }

        public static DependencyProperty CheckedBrushProperty =
            DependencyProperty.RegisterAttached("CheckedBrush",
                typeof(Brush),
                typeof(SugzButton),
                new PropertyMetadata(Resource<SolidColorBrush>.GetColor("SugzBlue")));



        /// <summary>
        /// Get / set if the button act like a checkbutton
        /// </summary>
        [Description("Get / set if the button act like a checkbutton"), Category("Appearance")]
        public bool IsCheckButton
        {
            get { return (bool)GetValue(IsCheckButtonProperty); }
            set { SetValue(IsCheckButtonProperty, value); }
        }

        public static readonly DependencyProperty IsCheckButtonProperty =
            DependencyProperty.Register("IsCheckButton", 
                typeof(bool), 
                typeof(SugzButton), 
                new PropertyMetadata(false));

        

        /// <summary>
        /// Get / set the checked property
        /// </summary>
        [Description("Get / set the checked property"), Category("Appearance")]
        public bool IsChecked
        {
            get { return (bool)GetValue(IsCheckedProperty); }
            set { SetValue(IsCheckedProperty, value); }
        }

        public static readonly DependencyProperty IsCheckedProperty =
            DependencyProperty.Register("IsChecked", 
                typeof(bool), 
                typeof(SugzButton), 
                new PropertyMetadata(false));



        #endregion // End Dependency Properties



        // Constructor
        #region Constructor


        public SugzButton()
        {
            // Apply the style
            Style = Resource<Style>.GetStyle("SugzButtonStyle");

            // Allow the button to be checkable
            Loaded += (s, e) => { if (!IsCheckButton) IsChecked = false; };
            Click += (s, e) => IsChecked = (IsCheckButton) ? !IsChecked : false;

        }

    
        #endregion // End Constructor
    }
}
