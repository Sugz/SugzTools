using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Model
{
    public class CDFunction : ICDItem
    {
        public CDItemType Type { get; set; }

        public CDFunction()
        {
            Type = CDItemType.Function;
        }
    }
}
