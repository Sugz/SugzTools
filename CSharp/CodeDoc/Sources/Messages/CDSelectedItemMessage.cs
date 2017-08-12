using CodeDoc.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    /// <summary>
    /// Message to inform which treeview item is selected
    /// </summary>
    public class CDSelectedItemMessage
    {
        public CDDataItem Sender { get; protected set; }
        public CDSelectedItemMessage(CDDataItem item)
        {
            Sender = item;
        }
    }
}
