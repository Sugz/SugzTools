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
    public class CDDataMessage : MessageBase
    {
        public string Status { get; protected set; }
        public int Progress { get; protected set; }
        public Cursor Cursor { get; protected set; }
        public Visibility ProgressBarVisibility { get; protected set; }


        public CDDataMessage(string status, int progress, Cursor cursor, Visibility visibility)
        {
            Status = status;
            Progress = progress;
            Cursor = cursor;
            ProgressBarVisibility = visibility;
        }
    }
}
