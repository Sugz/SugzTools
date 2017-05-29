using Autodesk.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public class Animatable
    {
        protected IAnimatable _Anim;
        public SClass_ID SuperClassID { get { return _Anim.SuperClassID; } }

        public object Icon
        {
            get
            {
                switch (SuperClassID)
                {
                    case SClass_ID.Geomobject:
                        return null;
                    case SClass_ID.Shape:
                        return null;
                    case SClass_ID.Light:
                        return null;
                    case SClass_ID.Camera:
                        return null;
                    case SClass_ID.Helper:
                        return null;
                    case SClass_ID.WsmObject:
                        return null;
                    case SClass_ID.System:
                        return null;
                    case SClass_ID.Layer:
                        return null;
                    default:
                        return null;
                }
            }
        }

        public Animatable() { }
        public Animatable(IAnimatable anim) { _Anim = anim; }

    }
}
