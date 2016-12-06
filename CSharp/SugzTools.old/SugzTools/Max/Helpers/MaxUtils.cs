using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Autodesk.Max;

namespace SugzTools.Max.Helpers
{
    public static class MaxUtils
    {

        public static IGlobal Global { get { return GlobalInterface.Instance; } }
        public static IInterface14 Interface { get { return Global.COREInterface14; } }


        /// <summary>
        /// The undo / redo system of 3ds Max uses a global instance of this class called theHold. Developers call methods of theHold object to participate in the undo / redo system.
        /// </summary>
        public static IHold TheHold { get { return Global.TheHold; } }

        /// <summary>
        /// Returns a pointer to the Autodesk.Max.ICUIFrameMgr which controls the overall operation of CUI Frames (the windows which contain toolbars, menus, the command panel, etc).
        /// </summary>
        public static ICUIFrameMgr CUIFrameMgr { get { return Global.CUIFrameMgr; } } 
        
    }
}



