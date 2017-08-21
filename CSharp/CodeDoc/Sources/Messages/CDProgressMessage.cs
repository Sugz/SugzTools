using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    public class CDProgressMessage
    {
        public int Progress { get; protected set; }
        public CDProgressMessage(int progress)
        {
            Progress = progress;
        }
    }
}
