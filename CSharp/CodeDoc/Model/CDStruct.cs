using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDStruct : CDCodeItem
    {
        public CDStruct(object parent, int lineIndex) : base(parent, lineIndex)
        {
            Type = CDDataItemType.Struct;
        }

        protected override ObservableCollection<CDDataItem> GetChildren()
        {
            throw new NotImplementedException();
        }

        protected override StringCollection GetDescription()
        {
            throw new NotImplementedException();
        }
    }
}
