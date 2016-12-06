using SgzControls.Sources;
using SgzControls.Src;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace SgzControls.Controls
{
    public class SgzTextBox : TextBox
    {


        #region Contructors


        static SgzTextBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzTextBox), new FrameworkPropertyMetadata(typeof(SgzTextBox)));
        }
        public SgzTextBox()
        {
            KeyDown += SgzTextBox_KeyDown;
        }


        #endregion Contructors



        #region Methods


        private void SgzTextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Return && e.Key == Key.Enter)
            {
                // Stop editing and set the focus to the parent
                Keyboard.ClearFocus();
                Helpers.RemoveFocus(this);
            }
        }


        #endregion Methods


    }
}