using System.ComponentModel;
using SugzControls.Controls;
using SugzTools.Max.Helpers;

namespace ExemplesApp
{
    public class Loader : Custom_CuiActionCommandAdapter
    {

        // Fields
        #region Fields


        private SugzWindow _Dialog = null;
        //private SugzWindow _Dialog = new SugzWindow();


        #endregion // End Fields


        // Properties
        #region Properties


        private bool _IsChecked = false;
        public override bool IsChecked { get { return _IsChecked; } }
        public override string ActionText { get { return "TestWindow"; } }

        

        #endregion // End Properties


        // Methods
        #region Methods


        public override void Execute(object parameter)
        {
            //if (_Dialog == null)
            //{
            //    _Dialog = new SugzWindow();
            //    _IsChecked = true;
            //    _Dialog.Closing += _Dialog_Closing;
            //}
            //else
            //{
            //    _Dialog.Close();
            //}


            // First Execution
            if (_Dialog == null)
            {
                _Dialog = new SugzWindow();
                _Dialog.Closing += _Dialog_Closing;
            }

            // Hide or show the Dialog
            if (_IsChecked)
                _Dialog.Hide();
            else
                _Dialog.Show();


            _IsChecked = !_IsChecked;

        }


        void _Dialog_Closing(object sender, CancelEventArgs e)
        {
            //_Dialog = null;
            //_IsChecked = false;

            e.Cancel = true;
            _Dialog.Hide();
            _IsChecked = false;

            // Redraw MacroButtons
            MaxUtils.CUIFrameMgr.SetMacroButtonStates(false);
        }

        


        #endregion // End Methods

    }
}
