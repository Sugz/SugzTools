using GalaSoft.MvvmLight.Messaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    public class CDStatusMessage : MessageBase
    {
        public bool ShowPanel { get; protected set; } = true;
        public string Status { get; protected set; }
        public bool UseTimer { get; protected set; }
        public bool ShowProgressBar { get; protected set; }


        public CDStatusMessage(bool showPanel)
        {
            ShowPanel = showPanel;
        }

        public CDStatusMessage(string status, bool useTimer, bool showProgressBar)
        {
            Status = status;
            UseTimer = useTimer;
            ShowProgressBar = showProgressBar;
        }
    }
}
