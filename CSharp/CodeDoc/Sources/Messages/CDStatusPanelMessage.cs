using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    /// <summary>
    /// Message to inform that a status is currently displaying
    /// </summary>
    public class CDStatusPanelMessage
    {
        public bool IsDisplayingStatus { get; protected set; }
        public CDStatusPanelMessage(bool isDisplayingStatus)
        {
            IsDisplayingStatus = isDisplayingStatus;
        }
    }
}
 