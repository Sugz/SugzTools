using ManagedServices;
using SugzControls.Src;
using System;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;

namespace SugzControls.Controls
{
    public class SugzWindow : Window
    {
        // Fields
        #region Fields

        #endregion // End Fields



        // Properties
        #region Properties




        #endregion // End Properties



        // Constructor
        #region Constructor


        public SugzWindow()
        {
            Style = Resource<Style>.GetStyle("SugzWindowStyle");
        }


        #endregion // End Constructor



        // Methods
        #region Methods


        // Private
        #region Private




        #endregion // End Private


        // Public
        #region Public

        /// <summary>
        /// Set the window for 3ds Max
        /// </summary>
        public void SetForMax()
        {
            WindowStartupLocation = WindowStartupLocation.CenterOwner;
            ShowInTaskbar = false;
            Width = 200;
            Height = 300;
            WindowInteropHelper windowHandle = new WindowInteropHelper(this);
            windowHandle.Owner = AppSDK.GetMaxHWND();
            AppSDK.ConfigureWindowForMax(this);
        }


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            // Get captiosn button and assign them their functions
            ((Button)GetTemplateChild("PART_CLOSE")).Click += (s, ec) => Close();
            ((Button)GetTemplateChild("PART_MAXIMIZE")).Click += (s, ec) => WindowState = (WindowState == WindowState.Maximized) ? WindowState.Normal : WindowState.Maximized;
            ((Button)GetTemplateChild("PART_MINIMIZE")).Click += (s, ec) => WindowState = WindowState.Minimized;
        }


        #endregion // End Public


        #endregion // End Methods



        // Events
        #region Events


        #endregion // End Events



    }
}
