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

namespace SugzTools.Controls
{
    public class SgzUniformGrid : UniformGrid
    {

        #region Properties


        public Thickness InnerMargin { get; set; } = new Thickness(0);


        #endregion Properties



        #region Constructors


        public SgzUniformGrid()
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
            Helpers.SetChildrenMargin(this, InnerMargin);
            Loaded -= SetChildrenMargin;
        }


        #endregion Private



        #endregion Methods

    }
}
