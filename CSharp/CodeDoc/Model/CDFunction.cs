using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDFunction : CDDataItem
    {
        public CDDataItemType Type { get; set; }
        public string Text { get; set; }

        public CDFunction()
        {
            Type = CDDataItemType.Function;
        }
    }
}
