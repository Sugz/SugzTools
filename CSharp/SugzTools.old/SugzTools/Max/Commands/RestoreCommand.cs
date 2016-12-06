using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;
using Autodesk.Max.Plugins;
using SugzTools.Max.Helpers;

namespace SugzTools.Max.Commands
{
    /// <summary>
    /// Defines a baseclass for commands that can be registered in the 3dsmax undo system.
    /// </summary>
    public abstract class RestoreCommand : RestoreObj
    {

        public void Execute() { this.Execute(false); }


        public void Execute(Boolean redrawViews)
        {
            IHold theHold = MaxUtils.TheHold;
            theHold.Begin();

            theHold.Put(this);
            this.Redo();

            theHold.Accept(this.Description);

            //if (redrawViews)
            //    Viewprts.Redraw();
        }

    }
}
