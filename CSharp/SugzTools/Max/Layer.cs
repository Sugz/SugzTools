using Autodesk.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public class Layer : Animatable
    {
        private IILayerManager _LayerManager = Kernel.Interface.LayerManager;

        public IILayer _Layer { get { return _Anim as IILayer; } }

        public Layer() : base() { }
        public Layer(IILayer layer) : base(layer) { }
        public Layer(int index) { _Anim = _LayerManager.GetLayer(index); }
    }
}
