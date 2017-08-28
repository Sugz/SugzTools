using SugzTools.Src;
using SugzTools.Themes;
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
    public class SgzFlatCheckButton : ToggleButton
    {

        #region Properties


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
        /// Define the CheckMark brush
        /// </summary>
        [Description("Define the Checked brush"), Category("Brush")]
        public Brush CheckMarkBrush
        {
            get { return (Brush)GetValue(CheckMarkBrushProperty); }
            set { SetValue(CheckMarkBrushProperty, value); }
        }


        /// <summary>
        /// Get or set the docking side of the check part
        /// </summary>
        [Description("Define the docking side of the check part."), Category("Appearance")]
        public Dock PartCheckDock
        {
            get { return (Dock)GetValue(PartCheckDockProperty); }
            set { SetValue(PartCheckDockProperty, value); }
        }


        #endregion



        #region Dependency Properties


        // DependencyProperty as the backing store for CheckedBrush
        public static readonly DependencyProperty CheckedBrushProperty = DependencyProperty.Register(
            "CheckedBrush",
            typeof(Brush),
            typeof(SgzFlatCheckButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for CheckedBrush
        public static readonly DependencyProperty CheckMarkBrushProperty = DependencyProperty.Register(
            "CheckMarkBrush",
            typeof(Brush),
            typeof(SgzFlatCheckButton),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for PartCheckDock
        public static readonly DependencyProperty PartCheckDockProperty = DependencyProperty.Register(
            "PartCheckDock",
            typeof(Dock),
            typeof(SgzFlatCheckButton),
            new PropertyMetadata(Dock.Left)
        );


        #endregion Dependency Properties



        #region Constructors


        static SgzFlatCheckButton()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzFlatCheckButton), new FrameworkPropertyMetadata(typeof(SgzFlatCheckButton)));
        }
        public SgzFlatCheckButton()
        {
            Loaded += (s, e) => FocusVisualStyle = FocusVisualStyles.GetControlStyle(3);
        }


        #endregion Constructors
    }
}
