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

        /// <summary>
        /// 
        /// </summary>
        public IINode RootNode
        {
            get { return Kernel.Interface.RootNode; }
        }


        public IEnumerable<IINode> Objects
        {
            get
            {
                foreach (IINode x in GetChildren(RootNode))
                {
                    foreach (IINode y in GetNodeTree(x))
                        yield return y;
                    yield return x;
                }
            }
        }


        public IEnumerable<IINode> Selection
        {
            get { return Objects.Where(x => x.Selected); }
        }




        public IEnumerable<IINode> GetChildren(IINode node)
        {
            for (int i = 0; i < node.NumberOfChildren; ++i)
                if (node.GetChildNode(i) != null)
                    yield return node.GetChildNode(i);
        }



        public IEnumerable<IINode> GetNodeTree(IINode node)
        {
            foreach (IINode x in GetChildren(node))
            {
                foreach (IINode y in GetNodeTree(x))
                    yield return y;
                yield return x;
            }
        }


    }
}