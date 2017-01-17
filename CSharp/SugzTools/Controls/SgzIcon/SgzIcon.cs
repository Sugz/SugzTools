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


        private Geo _Icon; 


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
        public Geo Icon
        {
            get { return _Icon; }
            set
            {
                _Icon = value;
                Data = Resource<PathGeometry>.GetIcon(value.ToString());
            }
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
        /// Define the MouseOver brush color
        /// </summary>
        [Description("Define the MouseOver brush color"), Category("Brush")]
        public Brush MouseOverBrush
        {
            get { return (Brush)GetValue(MouseOverBrushProperty); }
            set { SetValue(MouseOverBrushProperty, value); }
        }


        /// <summary>
        /// Define the MouseDown brush color
        /// </summary>
        [Description("Define the MouseDown brush color"), Category("Brush")]
        public Brush MouseDownBrush
        {
            get { return (Brush)GetValue(MouseDownBrushProperty); }
            set { SetValue(MouseDownBrushProperty, value); }
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


        // DependencyProperty as the backing store for MouseOverBrush
        public static readonly DependencyProperty MouseOverBrushProperty = DependencyProperty.Register(
            "MouseOverBrush",
            typeof(Brush),
            typeof(SgzIcon),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxButtonMouseOver"))
        );


        // DependencyProperty as the backing store for MouseDownBrush
        public static readonly DependencyProperty MouseDownBrushProperty = DependencyProperty.Register(
            "MouseDownBrush",
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
