using SugzTools.Src;
using UiViewModels.Actions;

namespace SugzTools.Max.Cui
{
    public abstract class Custom_CuiDockableContentAdapter : CuiDockableContentAdapter
    {

        public override string Category { get { return Const.Assembly; } }
        public override string WindowTitle { get { return ActionText; } }
        public abstract override DockStates.Dock DockingModes { get; }

    }
}
