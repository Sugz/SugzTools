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

        private Cursor _Cursor = Cursors.Arrow;                                                             // The window cursor
        private int _Progress = 0;                                                                          // The progress value of the status progressbar bar

        private bool _CanCloseStatusPanel = true;                                                           // The authorization to close the status panel
        private bool _StatusPanelIsOpen;                                                                    // The opening state of the status panel
        private string _Status = string.Empty;                                                              // The current status to display
        private Visibility _DataPathFieldVisibility = Visibility.Collapsed;                                 // The visibility of the data path panel
        private Visibility _MissingDescriptionVisibility = Visibility.Collapsed;                            // The visibility of the missing description panel
        private Visibility _ProgressVisibility = Visibility.Collapsed;                                      // The visibility of the progress panel 
        private Timer _Timer = new Timer() { Interval = 3000, AutoReset = false };                          // The timer to close the status panel

        private bool _ShowOptionPanel = false;                                                              // The opening state of the option panel
        private RelayCommand _ShowOptionPanelCommand;                                                       // The command to show or hide the option panel
        private RelayCommand _ApplyDefaultsCommand;                                                         // The command to apply defaults settings

        #endregion Fields


        #region Properties

        /// <summary>
        /// Get or set the window cursor
        /// </summary>
        public Cursor Cursor
        {
            get { return _Cursor; }
            set { Set(ref _Cursor, value); }
        }

        /// <summary>
        /// Get or set the progress value of the status progressbar bar
        /// </summary>
        public int Progress
        {
            get { return _Progress; }
            set { Set(ref _Progress, value); }
        }



        /// <summary>
        /// Get or set the opening state of the status panel
        /// </summary>
        public bool StatusPanelIsOpen
        {
            get { return _StatusPanelIsOpen; }
            set { Set(ref _StatusPanelIsOpen, value); }
        }

        /// <summary>
        /// Get or set the current status to display
        /// </summary>
        public string Status
        {
            get { return _Status; }
            set { Set(ref _Status, value); }
        }

        /// <summary>
        /// Get or set the visibility of the data path panel
        /// </summary>
        public Visibility DataPathFieldVisibility
        {
            get { return _DataPathFieldVisibility; }
            set { Set(ref _DataPathFieldVisibility, value); }
        }

        /// <summary>
        /// Get or set the visibility of the missing description panel
        /// </summary>
        public Visibility MissingDescriptionVisibility
        {
            get { return _MissingDescriptionVisibility; }
            set { Set(ref _MissingDescriptionVisibility, value); }
        }

        /// <summary>
        /// Get or set the visibility of the missing description panel
        /// </summary>
        public Visibility ProgressVisibility
        {
            get { return _ProgressVisibility; }
            set { Set(ref _ProgressVisibility, value); }
        }



        /// <summary>
        /// Get or set the opening state of the option panel
        /// </summary>
        public bool ShowOptionPanel
        {
            get { return _ShowOptionPanel; }
            set { Set(ref _ShowOptionPanel, value); }
        }
        
        /// <summary>
        /// Get the command to show or hide the option panel
        /// </summary>
        public RelayCommand ShowOptionPanelCommand => _ShowOptionPanelCommand ?? 
            (_ShowOptionPanelCommand = new RelayCommand(() => ShowOptionPanel = !ShowOptionPanel));

        /// <summary>
        /// Get the command to apply defaults settings
        /// </summary>
        public RelayCommand ApplyDefaultsCommand => _ApplyDefaultsCommand ?? 
            (_ApplyDefaultsCommand = new RelayCommand(ApplyDefaults));





        #endregion Properties


        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public CDMainVM()
        {
            MessengerInstance.Register<CDStatusMessage>(this, x => SetStatusPanel(x.Panel, x.Status, x.AutoClose, x.CanClose));
            MessengerInstance.Register<CDProgressMessage>(this, x => Progress = x.Progress);
        }


        #endregion Constructor


        #region Methods


        ////public override void Cleanup()
        ////{
        ////    // Clean up if needed

        ////    base.Cleanup();
        ////}


        private void SetStatusPanel(StatusPanels panel, string status = null, bool autoClose = false, bool canClose = false)
        {
            if (_CanCloseStatusPanel && canClose)
                _CanCloseStatusPanel = true;

            Status = status;
            if (panel is StatusPanels.None && _CanCloseStatusPanel)
            {
                StatusPanelIsOpen = false;
                return;
            }

            else
            {
                StatusPanelIsOpen = true;
                ProgressVisibility = panel is StatusPanels.Progress ? Visibility.Visible : Visibility.Collapsed;
                DataPathFieldVisibility = panel is StatusPanels.DataPathField ? Visibility.Visible : Visibility.Collapsed;
                MissingDescriptionVisibility = panel is StatusPanels.MissingDescription ? Visibility.Visible : Visibility.Collapsed;

                if (autoClose)
                {
                    _Timer.Elapsed += (s, e) =>
                    {
                        if (_CanCloseStatusPanel)
                        {
                            StatusPanelIsOpen = false;
                            DataPathFieldVisibility = MissingDescriptionVisibility = ProgressVisibility = Visibility.Collapsed;
                            Status = null;
                        }
                    };
                    _Timer.Start();
                }
            }
        }


        /// <summary>
        /// Set the UI status message for 5 seconds
        /// </summary>
        /// <param name="status"></param>
        //private void DisplaySatus(bool showPanel, string status, bool useTimer, bool showProgressBar)
        //{
        //    // check wheter an item was selected 

        //    _Timer.Stop();

        //    if (!showPanel)
        //    {
        //        StatusPanelIsOpen = false;
        //        return;
        //    }

        //    Status = status;
        //    StatusPanelIsOpen = true;
        //    ProgressVisibility = showProgressBar ? Visibility.Visible : Visibility.Collapsed;

        //    if (useTimer)
        //    {
        //        _Timer.Elapsed += (s, ev) =>
        //        {
        //            ProgressVisibility = Visibility.Collapsed;
        //            StatusPanelIsOpen = false;
        //            Status = string.Empty;
        //            MessengerInstance.Send(new CDStatusPanelMessage(false));
        //        };
        //        _Timer.Start();
        //    }
        //}


        /// <summary>
        /// Revert settings to their default value
        /// </summary>
        private void ApplyDefaults()
        {
            //TODO: no generic message...
            MessengerInstance.Send(new NotificationMessage(CDConstants.AppDataFolder));
        }


        #endregion Methods

    }
}