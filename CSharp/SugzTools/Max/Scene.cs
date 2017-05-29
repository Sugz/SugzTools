using Autodesk.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public class Scene
    {

        internal Node _RootNode;
        private IILayerManager _LayerManager;


        public Node RootNode { get { return _RootNode; } }
        public IEnumerable<Node> Objects { get { return RootNode.NodeTree; } }
        public IEnumerable<Node> Selection { get { return Objects.Where(x => x.Selected); } }

        public IEnumerable<Layer> Layers
        {
            get
            {
                for (int i = 0; i < _LayerManager.LayerCount; i++)
                    yield return new Layer(i);
            }
        }


        public Scene()
        {
            _RootNode = new Node(Kernel.Interface.RootNode);
            _LayerManager = Kernel.Interface.LayerManager;
        }



        public Node GetNodeByHandle(uint handle)
        {
            return new Node(handle);
        }

        public IEnumerable<Node> GetNodesByHandle(uint[] handles)
        {
            foreach (uint handle in handles)
                yield return new Node(handle);
        }


        public Layer GetLayer(int i)
        {
            return Layers.ToArray()[i];
        }

    }
}