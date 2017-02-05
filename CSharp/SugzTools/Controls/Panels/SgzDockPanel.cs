using SugzTools.Src;
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


        public Thickness InnerMargin { get; set; } = new Thickness(0);


        #endregion Properties



        #region Constructor


        public SgzDockPanel()
        {
            Loaded += SetChildrenMargin;
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
            Helpers.SetChildrenMargin(this, InnerMargin);
            Loaded -= SetChildrenMargin;
        }


        #endregion Private



        #endregion Methods



    }
}
