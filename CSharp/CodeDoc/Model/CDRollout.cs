using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDRollout : CDDataItem, IReadableItem
    {
        public CDRollout(object parent, StringCollection code) : base(parent)
        {
            Type = CDDataItemType.Rollout;
            Code = code;
        }

        public StringCollection Description => null;

        public StringCollection Code { get; protected set; }
    }
}
