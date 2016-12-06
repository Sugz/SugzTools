using SugzTools.Src;
using UiViewModels.Actions;

namespace SugzTools.Max.Cui
{
    public abstract class Custom_CuiActionCommandAdapter : CuiActionCommandAdapter
    {
        public override string Category { get { return Const.Assembly; } }
        public override string InternalActionText { get { return ActionText; } }
        public override string InternalCategory { get { return Category; } }

    }
}
