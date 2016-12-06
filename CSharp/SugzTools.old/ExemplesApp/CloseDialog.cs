using System.ComponentModel;
using SugzControls.Controls;
using SugzTools.Max.Helpers;

namespace ExemplesApp
{
    public class CloseDialog : Custom_CuiActionCommandAdapter
    {

        // Fields
        #region Fields


        private SugzWindow _Dialog = null;


        #endregion // End Fields


        // Properties
        #region Properties


        private bool _IsChecked = false;
        public override bool IsChecked { get { return _IsChecked; } }

        public override string ActionText { get { return "Close Dialog"; } }

        

        #endregion // End Properties


        // Methods
        #region Methods


        public override void Execute(object parameter)
        {
            if (_Dialog == null)
            {
                _Dialog = new SugzWindow();
                _Dialog.SetForMax();
                _Dialog.Show();
                _IsChecked = true;
                _Dialog.Closing += _Dialog_Closing;
            }
            else
            {
                _Dialog.Close();
            }
        }


        /// <summary>
        /// Set the dialog to be null and uncheck the macro button
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void _Dialog_Closing(object sender, CancelEventArgs e)
        {
            _Dialog = null;
            _IsChecked = false;

            // Redraw MacroButtons
            MaxUtils.CUIFrameMgr.SetMacroButtonStates(false);
        }


        #endregion // End Methods

    }
}

