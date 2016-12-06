using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzDockPanel : DockPanel
    {

        #region Properties


        public Thickness InnerMargin { get; set; }


        #endregion Properties



        #region Constructor


        public SgzDockPanel()
        {
            InnerMargin = new Thickness(0, 0, 0, 7);
        }


        #endregion Constructor



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
        /// <summary>
        /// Add a child with specified dock
        /// </summary>
        /// <param name="child"></param>
        /// <param name="dock"></param>
        public void Add(UIElement child, Dock dock)
        {
            Children.Add(child);
            SetDock(child, dock);
        }


        #endregion Public


        #endregion Methods



    }
}
