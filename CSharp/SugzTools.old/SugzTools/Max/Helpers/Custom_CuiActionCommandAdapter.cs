using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UiViewModels.Actions;

namespace SugzTools.Max.Helpers
{
    public abstract class Custom_CuiActionCommandAdapter : CuiActionCommandAdapter
    {
        public override string Category { get { return "SugzTools"; } }
        public override string InternalActionText { get { return ActionText; } }
        public override string InternalCategory { get { return Category; } }

    }
}
