using GalaSoft.MvvmLight.Messaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Input;

namespace CodeDoc.Src
{
    public class CDStatusMessage : MessageBase
    {
        public string Status { get; protected set; }
        public bool UseTimer { get; protected set; }
        public bool ShowProgressBar { get; protected set; }

        public CDStatusMessage(string status, bool useTimer, bool showProgressBar)
        {
            Status = status;
            UseTimer = useTimer;
            ShowProgressBar = showProgressBar;
        }
    }
}
