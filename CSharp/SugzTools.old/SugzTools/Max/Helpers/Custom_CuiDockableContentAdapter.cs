using UiViewModels.Actions;


namespace SugzTools.Max.Helpers
{
    public abstract class Custom_CuiDockableContentAdapter : CuiDockableContentAdapter
    {

        public override string Category { get { return "SugzTools"; } }
        public override string WindowTitle { get { return ActionText; } }
        public abstract override DockStates.Dock DockingModes { get; }

    }
}
