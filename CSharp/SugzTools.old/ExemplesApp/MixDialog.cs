using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SugzTools.Max.Helpers;
using UiViewModels.Actions;
using SugzControls.Controls;

namespace ExemplesApp
{
    public class MixDialog : Custom_CuiDockableContentAdapter
    {

        // Create an instance of the view to be able to modify it in this class
        private SugzToolbar _View = new SugzToolbar();


        public override string ActionText { get { return "Dialog"; } }
        public override Type ContentType { get { return typeof(SugzToolbar); } }
        public override DockStates.Dock DockingModes { get { return DockStates.Dock.Left; } }
        public override bool IsMainContent { get { return true; } }


        public override object CreateDockableContent() { return _View; }


        // Modify the view based on the dockMode
        public override void SetContentDockMode(object dockableContent, DockStates.Dock dockMode)
        {
            base.SetContentDockMode(dockableContent, dockMode);
            _View.SetResizeBorders(dockMode);
        }
    }
}
