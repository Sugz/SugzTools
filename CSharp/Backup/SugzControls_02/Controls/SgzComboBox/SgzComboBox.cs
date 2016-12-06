using SgzControls.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SgzControls.Controls
{
    public class SgzComboBox : ComboBox
    {

        #region Constructors


        static SgzComboBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzComboBox), new FrameworkPropertyMetadata(typeof(SgzComboBox)));
        }
        public SgzComboBox()
        {

        }


        #endregion Constructors



        #region Methods


        /// <summary>
        /// Let the user set the number of item to be shown in the popup instead of the popup height
        /// </summary>
        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            MaxDropDownHeight *= 18;
            MaxDropDownHeight += 2;
        }


        #endregion Methods


    }
}

