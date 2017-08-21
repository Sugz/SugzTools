using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    public class CDDataIOMessage
    {
        public int Progress { get; protected set; }
        public CDDataIOMessage(int progress)
        {
            Progress = progress;
        }
    }
}
