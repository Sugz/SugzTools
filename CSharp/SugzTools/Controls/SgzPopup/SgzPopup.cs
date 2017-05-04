using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzPopup : Popup
    {

        #region Properties


        /// <summary>
        /// Define the Background brush color
        /// </summary>
        [Description("Define the MouseOver brush color"), Category("Common")]
        public object Content
        {
            get { return GetValue(ContentProperty); }
            set { SetValue(ContentProperty, value); }
        }



        /// <summary>
        /// Define the Background brush color
        /// </summary>
        [Description("Define the MouseOver brush color"), Category("Brush")]
        public Brush Background
        {
            get { return (Brush)GetValue(BackgroundProperty); }
            set { SetValue(BackgroundProperty, value); }
        }


        /// <summary>
        /// Define the BorderBrush brush color
        /// </summary>
        [Description("Define the MouseOver brush color"), Category("Brush")]
        public Brush BorderBrush
        {
            get { return (Brush)GetValue(BorderBrushProperty); }
            set { SetValue(BorderBrushProperty, value); }
        }



        /// <summary>
        /// Define the CornerRadius property
        /// </summary>
        [Description("Define the CornerRadius property"), Category("Appearance")]
        public Thickness BorderThickness
        {
            get { return (Thickness)GetValue(BorderThicknessProperty); }
            set { SetValue(BorderThicknessProperty, value); }
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


        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty ContentProperty = DependencyProperty.Register(
            "Content",
            typeof(object),
            typeof(SgzPopup)
        );


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty BackgroundProperty = DependencyProperty.Register(
            "Background",
            typeof(Brush),
            typeof(SgzPopup),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxRollout"))
        );


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty BorderBrushProperty = DependencyProperty.Register(
            "BorderBrush",
            typeof(Brush),
            typeof(SgzPopup),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxRolloutBorder"))
        );





        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty BorderThicknessProperty = DependencyProperty.Register(
            "BorderThickness",
            typeof(Thickness),
            typeof(SgzPopup),
            new PropertyMetadata(new Thickness(1))
        );


        // DependencyProperty as the backing store for CornerRadius
        public static readonly DependencyProperty CornerRadiusProperty = DependencyProperty.Register(
            "CornerRadius",
            typeof(int),
            typeof(SgzPopup),
            new PropertyMetadata(3)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzPopup()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzPopup), new FrameworkPropertyMetadata(typeof(SgzPopup)));
        }
        public SgzPopup()
        {
            
        }


        #endregion Constructors


    }
}
