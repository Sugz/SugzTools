using SgzControls.Sources;
using SgzControls.Src;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace SgzControls.Controls
{
    public class SgzTextBox : TextBox
    {


        // Contructors
        #region Contructors


        public SgzTextBox()
        {
            Style = Resource<Style>.GetStyle("SgzTextBoxStyle");
            KeyDown += SgzTextBox_KeyDown;
        }


        #endregion // End Contructors



        // Methods
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


        #endregion // End Methods


    }
}



