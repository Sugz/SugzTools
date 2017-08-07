using SugzTools.Src;
using SugzTools.Icons;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Media;

namespace SugzTools.Controls
{

    public class SgzIcon : Button
    {

        #region Fields


        //private Geo _Icon; 


        #endregion Fields



        #region Properties


        /// <summary>
        /// Get or set a thickness that describes the border thickness of an element
        /// </summary>
        [Description("Get or set a thickness that describes the border thickness of an element."), Category("Appearance")]
        public new double BorderThickness
        {
            get { return (double)GetValue(BorderThicknessProperty); }
            set { SetValue(BorderThicknessProperty, value); }
        }


        /// <summary>
        /// Get an icon from https://materialdesignicons.com/
        /// </summary>
        [Description("Get or set an icon from https://materialdesignicons.com/"), Category("Common")]
        //public Geo Icon
        //{
        //    get { return _Icon; }
        //    set
        //    {
        //        _Icon = value;
        //        Data = Resource<PathGeometry>.GetIcon(value.ToString());
        //    }
        //}

        public Geo? Icon
        {
            get { return (Geo?)GetValue(IconProperty); }
            set { SetValue(IconProperty, value); }
        }

        // DependencyProperty as the backing store for Icon
        public static readonly DependencyProperty IconProperty = DependencyProperty.Register(
            "Icon",
            typeof(Geo?),
            typeof(SgzIcon),
            new PropertyMetadata(null, OnIconChanged)
        );

        private static void OnIconChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzIcon _this = d as SgzIcon;
            if (_this.Icon != null)
                _this.Data = Resource<PathGeometry>.GetIcon(_this.Icon.ToString());
        }





        /// <summary>
        /// Get or set the data used to draw the button
        /// </summary>
        [Description("Get or set the data used to draw the button"), Category("Common")]
        public PathGeometry Data
        {
            get { return (PathGeometry)GetValue(DataProperty); }
            set { SetValue(DataProperty, value); }
        }


        /// <summary>
        /// Get or set the stretch of the icon
        /// </summary>
        [Description("Get or set the stretch of the icon"), Category("Appearance")]
        public Stretch Stretch
        {
            get { return (Stretch)GetValue(StretchProperty); }
            set { SetValue(StretchProperty, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Layout")]
        // [Browsable(false)]
        public double IconWidth
        {
            get { return (double)GetValue(IconWidthProperty); }
            set { SetValue(IconWidthProperty, value); }
        }

        // DependencyProperty as the backing store for IconWidth
        public static readonly DependencyProperty IconWidthProperty = DependencyProperty.Register(
            "IconWidth",
            typeof(double),
            typeof(SgzIcon),
            new PropertyMetadata(double.NaN)
        );


        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Layout")]
        // [Browsable(false)]
        public double IconHeight
        {
            get { return (double)GetValue(IconHeightProperty); }
            set { SetValue(IconHeightProperty, value); }
        }

        // DependencyProperty as the backing store for IconHeight
        public static readonly DependencyProperty IconHeightProperty = DependencyProperty.Register(
            "IconHeight",
            typeof(double),
            typeof(SgzIcon),
            new PropertyMetadata(double.NaN)
        );





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
        /// Define the MouseDown brush color
        /// </summary>
        [Description("Define the MouseDown brush color"), Category("Brush")]
        public Brush PressedBrush
        {
            get { return (Brush)GetValue(PressedBrushProperty); }
            set { SetValue(PressedBrushProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for BorderThickness
        public new static readonly DependencyProperty BorderThicknessProperty = DependencyProperty.Register(
            "BorderThickness",
            typeof(double),
            typeof(SgzIcon),
            new PropertyMetadata(0d)
        );


        // DependencyProperty as the backing store for Data
        public static readonly DependencyProperty DataProperty = DependencyProperty.Register(
            "Data",
            typeof(PathGeometry),
            typeof(SgzIcon),
            new PropertyMetadata(new PathGeometry())
        );



        // DependencyProperty as the backing store for Stretch
        public static readonly DependencyProperty StretchProperty = DependencyProperty.Register(
            "Stretch",
            typeof(Stretch),
            typeof(SgzIcon),
            new PropertyMetadata(Stretch.Uniform)
        );


        // DependencyProperty as the backing store for HoverBrush
        public static readonly DependencyProperty HoverBrushProperty = DependencyProperty.Register(
            "HoverBrush",
            typeof(Brush),
            typeof(SgzIcon),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for PressedBrush
        public static readonly DependencyProperty PressedBrushProperty = DependencyProperty.Register(
            "PressedBrush",
            typeof(Brush),
            typeof(SgzIcon),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        ); 


        #endregion Dependency Properties



        #region Constructors


        static SgzIcon()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzIcon), new FrameworkPropertyMetadata(typeof(SgzIcon)));
        }
        public SgzIcon()
        {

        }


        #endregion Constructors

    }
}
