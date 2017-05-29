using Autodesk.Max;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SugzTools.Max
{
    public class Test
    {

        //private List<IINode> nodes = new List<IINode>();


        //public List<IINode> GetObjects(uint[] handles)
        //{
        //    foreach (uint handle in handles)
        //        nodes.Add(Kernel.Interface.GetINodeByHandle(handle));

        //    return nodes;
        //}

        public IINode[] GetObjects(uint[] handles)
        {
            IINode[] nodes = new IINode[handles.Length];
            for (int i = 0; i < handles.Length; i++)
            {
                nodes[i] = Kernel.Interface.GetINodeByHandle(handles[i]);
            }
                
            return nodes;
        }


    }
}


/*
(
	iNodes = (dotnetobject "SugzTools.Max.Test").GetObjects  (for obj in _sgz._extMxs.SortObjects (GetCurrentSelection()) collect obj.handle)
)
*/
