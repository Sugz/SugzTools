using System.ComponentModel;
using SugzControls.Controls;
using SugzTools.Max.Helpers;

namespace ExemplesApp
{
    public class HideDialog : Custom_CuiActionCommandAdapter
    {

        // Fields
        #region Fields


        private SugzWindow _Dialog = null;


        #endregion // End Fields


        // Properties
        #region Properties


        private bool _IsChecked = false;
        public override bool IsChecked { get { return _IsChecked; } }

        public override string ActionText { get { return "Hide Dialog"; } }


        #endregion // End Properties


        // Methods
        #region Methods


        public override void Execute(object parameter)
        {
            // On first execution, define the dialog and set the hide instead of close event
            if (_Dialog == null)
            {
                _Dialog = new SugzWindow();
                _Dialog.SetForMax();
                _Dialog.Closing += _Dialog_Closing;
            }


            // Hide or show the Dialog
            if (_IsChecked)
                _Dialog.Hide();
            else
                _Dialog.Show();


            _IsChecked = !_IsChecked;

        }


        /// <summary>
        /// Cancel the close and hide the window instead
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void _Dialog_Closing(object sender, CancelEventArgs e)
        {
            e.Cancel = true;
            _Dialog.Hide();
            _IsChecked = false;

            // Redraw MacroButtons
            MaxUtils.CUIFrameMgr.SetMacroButtonStates(false);
        }


        #endregion // End Methods

    }
}
