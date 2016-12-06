using SugzTools.Controls;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UiViewModels.Actions;

namespace SugzTools.Max.Cui
{
    public static class Cui
    {
        public class MaxToolBar : Custom_CuiDockableContentAdapter
        {

            #region Fields


            private SgzToolBar _View = new SgzToolBar();        // Create an instance of the view to be able to modify it in this class
            private string _ActionText = "SugzTools";


            #endregion Fields



            #region Properties


            public override string ActionText { get { return _ActionText; } }
            public override Type ContentType { get { return typeof(SgzToolBar); } }
            public override DockStates.Dock DockingModes { get { return DockStates.Dock.Left | DockStates.Dock.Right | DockStates.Dock.Floating; } }
            public override bool IsMainContent { get { return true; } }


            #endregion Properties



            public void SetActionText(string ActionText)
            {
                _ActionText = ActionText;
            }



            #region Overrides


            public override object CreateDockableContent() { return _View; }


            // Modify the view based on the dockMode
            public override void SetContentDockMode(object dockableContent, DockStates.Dock dockMode)
            {
                base.SetContentDockMode(dockableContent, dockMode);
                _View.SetResizers(dockMode);
            }


            #endregion Overrides


        }

        public static MaxToolBar GetToolBar()
        {
            MaxToolBar toolbar = new MaxToolBar();
            toolbar.SetActionText("WPF Toolbar from script !");

            return toolbar;
        }
    }


    
}
