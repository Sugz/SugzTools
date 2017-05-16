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
    public class SgzDataGrid : DataGrid
    {

        #region Fields


        HorizontalAlignment OldHorizontalAlignment;


        #endregion Fields


        #region Properties


        /// <summary>
        /// Get or set if a row or a cell can be selected.
        /// </summary>
        [Description("Get or set if a row or a cell can be selected."), Category("Common")]
        public bool IsSelectable
        {
            get { return (bool)GetValue(IsSelectableProperty); }
            set { SetValue(IsSelectableProperty, value); }
        }


        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for IsSelectable
        public static readonly DependencyProperty IsSelectableProperty = DependencyProperty.Register(
            "IsSelectable",
            typeof(bool),
            typeof(SgzDataGrid),
            new PropertyMetadata(false)//, OnIsSelectableChanged)
        );


        #endregion Dependency Properties


        #region Constructors


        static SgzDataGrid()
        {
            //DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDataGrid), new FrameworkPropertyMetadata(typeof(SgzDataGrid)));
        }
        public SgzDataGrid()
        {
            OldHorizontalAlignment = HorizontalAlignment;
            Loaded += SgzDataGrid_Loaded;
        }


        #endregion Constructors


        #region Methods


        private void SgzDataGrid_Loaded(object sender, RoutedEventArgs e)
        {
            // Fix the issue with HorizontalAlignment.Stretch
            SetWidth();
            ((FrameworkElement)VisualTreeHelper.GetParent(this)).SizeChanged += (s, ev) => SetWidth();
        }


        /// <summary>
        /// Fix the issue with HorizontalAlignment.Stretch
        /// </summary>
        private void SetWidth()
        {
            if (OldHorizontalAlignment == HorizontalAlignment.Stretch)
                HorizontalAlignment = HorizontalAlignment.Center;

            Width = ((FrameworkElement)VisualTreeHelper.GetParent(this)).ActualWidth - (Margin.Left + Margin.Right);
        }



        /*private static void OnIsSelectableChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            SgzDataGrid control = (SgzDataGrid)d;
            control.SelectionChanged += (s, ev) =>
            {
                if ((bool)e.NewValue)
                    control.UnselectAllCells();
            };
        }*/


        #endregion Methods

    }
}