using GalaSoft.MvvmLight.Messaging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CodeDoc.Messaging
{
    public enum StatusPanels
    {
        Default,
        None,
        MissingDescription,
        DataPathField,
        Progress
    }

    public class CDStatusMessage : MessageBase
    {
        public StatusPanels Panel { get; protected set; }

        //public bool ShowPanel { get; protected set; } = true;
        public string Status { get; protected set; }
        public bool AutoClose { get; protected set; }
        public bool CanClose { get; protected set; }
        //public bool ShowProgressBar { get; protected set; }


        //public CDStatusMessage(bool showPanel)
        //{
        //    ShowPanel = showPanel;
        //}

        //public CDStatusMessage(string status, bool autoClose, bool showProgressBar)
        //{
        //    Status = status;
        //    AutoClose = autoClose;
        //    ShowProgressBar = showProgressBar;
        //}



        public CDStatusMessage(StatusPanels panel, bool canClose = false)
        {
            Panel = panel;
            CanClose = canClose;
        }

        public CDStatusMessage(string status, bool autoClose = false, bool canClose = false) : this(StatusPanels.Default, status, autoClose, canClose) { }

        public CDStatusMessage(StatusPanels panel, string status, bool autoClose, bool canClose = false)
        {
            Panel = panel;
            AutoClose = autoClose;
            Status = status;
            CanClose = canClose;
        }
    }
}
