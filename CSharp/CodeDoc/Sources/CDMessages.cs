using CodeDoc.Model;
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
