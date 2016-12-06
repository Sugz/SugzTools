using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzStackPanel : StackPanel
    {

        #region Properties


        /// <summary>
        /// Modify the Margin for the panel's children
        /// </summary>
        [Description("Modify the Margin for the panel's children"), Category("Common")]
        public Thickness InnerMargin
        {
            get { return (Thickness)GetValue(InnerMarginProperty); }
            set { SetValue(InnerMarginProperty, value); }
        }


        #endregion Properties



        #region Dependency Properties


        // DependencyProperty as the backing store for InnerMargin
        public static readonly DependencyProperty InnerMarginProperty = DependencyProperty.Register(
            "InnerMargin",
            typeof(Thickness),
            typeof(SgzStackPanel),
            new UIPropertyMetadata(new Thickness(0,0,0,7))
        );


        #endregion Dependency Properties



        #region Constructors


        public SgzStackPanel()
        {
            Loaded += SetChildrenMargin;
        }


        #endregion Constructors



        #region Methods


        #region Private


        /// <summary>
        /// Modify the Margin for the panel's children
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SetChildrenMargin(object sender, RoutedEventArgs e)
        {
            foreach (FrameworkElement child in Children)
            {
                if (child == null)
                    continue;

                child.Margin = new Thickness(child.Margin.Left + InnerMargin.Left,
                    child.Margin.Top + InnerMargin.Top,
                    child.Margin.Right + InnerMargin.Right,
                    child.Margin.Bottom + InnerMargin.Bottom
                );
            }

            Loaded -= SetChildrenMargin;
        }


        #endregion Private


        #region Public


        /// <summary>
        /// Add a child
        /// </summary>
        /// <param name="child"></param>
        public void Add(UIElement child)
        {
            Children.Add(child);
        }


        #endregion Public


        #endregion Methods

    }

}
