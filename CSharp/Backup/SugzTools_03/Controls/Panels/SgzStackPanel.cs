using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Controls
{
    public class SgzStackPanel : StackPanel
    {


        #region Constructors


        public SgzStackPanel()
        {

        }


        #endregion Constructors


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


        #endregion Public


        #endregion Methods

    }

}
