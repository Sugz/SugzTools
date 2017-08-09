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

namespace CodeDoc.ViewModel
{
    /// <summary>
    /// This class contains properties that the main View can data bind to.
    /// <para>
    /// See http://www.mvvmlight.net
    /// </para>
    /// </summary>
    public class MainViewModel : ViewModelBase
    {

        #region Fields


        private Visibility _ProgressBarVisibility = Visibility.Collapsed;
        private bool _ShowOptionPanel = true;
        private Timer _Timer = new Timer() { Interval = 5000, AutoReset = false };
        private string _Status = string.Empty;

        private RelayCommand _ApplyDefaultsCommand;
        private RelayCommand _ShowOptionPanelCommand;


        #endregion Fields


        #region Properties


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
            get { return _ShowOptionPanelCommand ?? (_ShowOptionPanelCommand = new RelayCommand(test)); }
        }

        private void test()
        {
            ShowOptionPanel = !ShowOptionPanel;
        }





        #endregion Properties


        #region Constructor


        /// <summary>
        /// Initializes a new instance of the MainViewModel class.
        /// </summary>
        public MainViewModel()
        {
            MessengerInstance.Register<CDStatusMessage>(this, x => DisplaySatus(x.Status, x.UseTimer, x.ShowProgressBar));
            MessengerInstance.Register<GenericMessage<Visibility>>(this, x => ProgressBarVisibility = x.Content);
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
        private void DisplaySatus(string status, bool useTimer = false, bool showProgressBar = false)
        {
            _Timer.Stop();

            Status = status;
            if (!showProgressBar)
                ProgressBarVisibility = Visibility.Collapsed;

            if (useTimer)
            {
                _Timer.Elapsed += (s, ev) =>
                {
                    ProgressBarVisibility = Visibility.Collapsed;
                    Status = string.Empty;
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