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

        #region Constructor


        public SgzDockPanel()
        {

        }


        #endregion Constructor



        #region Methods


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
