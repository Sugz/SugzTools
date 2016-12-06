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
    public class SgzExpander : Expander
    {


        // Dependency Properties
        #region Dependency Properties


        /// <summary>
        /// Get / set the HeaderBrush property
        /// </summary>
        [Description("Get / set the color of the header"), Category("Brush")]
        public Brush HeaderBrush
        {
            get { return (Brush)GetValue(HeaderBrushProperty); }
            set { SetValue(HeaderBrushProperty, value); }
        }

        // Using a DependencyProperty as the backing store for HeaderBrush.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty HeaderBrushProperty = 
            DependencyProperty.Register("HeaderBrush", typeof(Brush), typeof(SgzExpander), new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxRollout")));



        /// <summary>
        /// Get / set the height of the header
        /// </summary>
        [Description("Get / set the height of the header"), Category("Appearance")]
        public int HeaderHeight
        {       
            get { return (int)GetValue(HeaderHeightProperty); }
            set { SetValue(HeaderHeightProperty, value); }
        }

        // Using a DependencyProperty as the backing store for HeaderHeight.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty HeaderHeightProperty = 
            DependencyProperty.Register("HeaderHeight", typeof(int), typeof(SgzExpander), new PropertyMetadata(20));



        /// <summary>
        /// Get / set the CornerRadius property
        /// </summary>
        [Description("Get / set the CornerRadius"), Category("Appearance")]
        public int CornerRadius
        {
            get { return (int)GetValue(CornerRadiusProperty); }
            set { SetValue(CornerRadiusProperty, value); }
        }

        // Using a DependencyProperty as the backing store for CornerRadius.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty CornerRadiusProperty =
            DependencyProperty.Register("CornerRadius", typeof(int), typeof(SgzExpander), new PropertyMetadata(0));



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
            DependencyProperty.Register("ButtonType", typeof(ButtonType), typeof(SgzExpander), new PropertyMetadata(ButtonType.IconAndText));



        /// <summary>
        /// Define wheter the expander is a toolbar, thus showing the toolbar style button
        /// </summary>
        [Description("Get / set if the expander is a toolbar, thus showing the toolbar style button"), Category("Common")]
        public bool IsToolbar
        {
            get { return (bool)GetValue(IsToolbarProperty); }
            set { SetValue(IsToolbarProperty, value); }
        }

        // Using a DependencyProperty as the backing store for IsToolbar.  This enables animation, styling, binding, etc...
        public static readonly DependencyProperty IsToolbarProperty =
            DependencyProperty.Register("IsToolbar", typeof(bool), typeof(SgzExpander), new PropertyMetadata(false));





        #endregion // End Dependency Properties



        // Properties
        #region Properties





        #endregion // End Properties


        // Constructor
        #region Constructor


        public SgzExpander()
        {
            Style = Resource<Style>.GetStyle("SgzExpanderStyle");
        }


        #endregion // End Constructor

    }
}
