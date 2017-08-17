using CodeDoc.Model;
using CodeDoc.Src;
using GalaSoft.MvvmLight;
using GalaSoft.MvvmLight.Command;
using Microsoft.WindowsAPICodePack.Shell;
using Microsoft.WindowsAPICodePack.Dialogs;
using System;
using System.Collections;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.IO;
using System.Linq;
using System.Timers;
using System.Windows.Input;
using System.Windows.Controls;
using System.Windows;
using GalaSoft.MvvmLight.Messaging;
using CodeDoc.Messaging;

namespace CodeDoc.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// See http://www.mvvmlight.net
    /// </para>
    /// </summary>
    public class CDMainVM : ViewModelBase
    {

        #region Fields

        private Cursor _Cursor = Cursors.Arrow;
        private int _Progress = 0;

        private bool _ShowOptionPanel = false;
        private bool _StatusPanelIsOpen;
        private Visibility _ProgressBarVisibility = Visibility.Collapsed;
        private Timer _Timer = new Timer() { Interval = 3000, AutoReset = false };
        private string _Status = string.Empty;

        private RelayCommand _ApplyDefaultsCommand;
        private RelayCommand _ShowOptionPanelCommand;


        #endregion Fields


        #region Properties

        /// <summary>
        /// 
        /// </summary>
        public Cursor Cursor
        {
            get { return _Cursor; }
            set { Set(ref _Cursor, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public int Progress
        {
            get { return _Progress; }
            set { Set(ref _Progress, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public bool StatusPanelIsOpen
        {
            get { return _StatusPanelIsOpen; }
            set { Set(ref _StatusPanelIsOpen, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public Visibility ProgressBarVisibility
        {
            get { return _ProgressBarVisibility; }
            set { Set(ref _ProgressBarVisibility, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public bool ShowOptionPanel
        {
            get { return _ShowOptionPanel; }
            set { Set(ref _ShowOptionPanel, value); }
        }

        /// <summary>
        /// 
        /// </summary>
        public string Status
        {
            get { return _Status; }
            set { Set(ref _Status, value); }
        }


        /// <summary>
        /// 
        /// </summary>
        public RelayCommand ApplyDefaultsCommand
        {
            get { return _ApplyDefaultsCommand ?? (_ApplyDefaultsCommand = new RelayCommand(ApplyDefaults)); }
        }

        /// <summary>
        /// 
        /// </summary>
        public RelayCommand ShowOptionPanelCommand
        {
            get { return _ShowOptionPanelCommand ?? (_ShowOptionPanelCommand = new RelayCommand(() => ShowOptionPanel = !ShowOptionPanel)); }
        }



        #endregion Properties


        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public CDMainVM()
        {
            MessengerInstance.Register<CDStatusMessage>(this, x => DisplaySatus(x.ShowPanel, x.Status, x.UseTimer, x.ShowProgressBar));
            MessengerInstance.Register<CDDataIOMessage>(this, x => Progress = x.Progress);
        }


        #endregion Constructor


        #region Methods


        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}


        /// <summary>
        /// Set the UI status message for 5 seconds
        /// </summary>
        /// <param name="status"></param>
        private void DisplaySatus(bool showPanel, string status, bool useTimer, bool showProgressBar)
        {
            // check wheter an item was selected 

            _Timer.Stop();

            if (!showPanel)
            {
                StatusPanelIsOpen = false;
                return;
            }

            Status = status;
            StatusPanelIsOpen = true;
            ProgressBarVisibility = showProgressBar ? Visibility.Visible : Visibility.Collapsed;

            if (useTimer)
            {
                _Timer.Elapsed += (s, ev) =>
                {
                    ProgressBarVisibility = Visibility.Collapsed;
                    StatusPanelIsOpen = false;
                    Status = string.Empty;
                    MessengerInstance.Send(new CDStatusPanelMessage(false));
                };
                _Timer.Start();
            }
        }


        /// <summary>
        /// Revert settings to their default value
        /// </summary>
        private void ApplyDefaults()
        {
            MessengerInstance.Send(new NotificationMessage(CDConstants.AppDataFolder));
        }


        #endregion Methods

    }
}