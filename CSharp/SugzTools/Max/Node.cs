using Autodesk.Max;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public class Node : Animatable
    {
        public IINode _Node { get { return _Anim as IINode; } }

        public string Name
        {
            get { return _Node.Name; }
            set { _Node.Name = value; }
        }

        public IEnumerable<Node> Children
        {
            get
            {
                for (int i = 0; i < _Node.NumberOfChildren; ++i)
                    if (_Node.GetChildNode(i) != null)
                        yield return new Node(_Node.GetChildNode(i));
            }
        }
        public IEnumerable<Node> NodeTree
        {
            get
            {
                foreach (Node x in Children)
                {
                    foreach (Node y in x.NodeTree)
                        yield return y;
                    yield return x;
                }
            }
        }


        public bool Selected
        {
            get { return _Node.Selected; }
            set { if (value) Kernel.Interface.SelectNode(_Node, false); else Kernel.Interface.DeSelectNode(_Node); }
        }



        public Node() : base() { }
        public Node(IINode node) : base(node) { }
        public Node(uint handle) { _Anim = Kernel.Interface.GetINodeByHandle(handle); }


    }
}
