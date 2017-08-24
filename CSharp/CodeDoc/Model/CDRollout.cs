using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDRollout : CDDataItem
    {
        public CDRollout(object parent) : base(parent)
        {
            Type = CDDataItemType.Rollout;
        }
    }
}
