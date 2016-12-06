using ManagedServices;
using SugzTools.Max;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Interop;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzWindow : Window
    {


        #region Constructors


        public SgzWindow()
        {
            //Width = 216;
            //Height = 300;
            
            
        }


        #endregion Constructors



        #region Methods



        #region Public


        /// <summary>
        /// Set the window for 3ds Max
        /// </summary>
        public void SetForMax()
        {
            ShowInTaskbar = false;
            Background = Resource<SolidColorBrush>.GetColor("MaxBackground");
            WindowInteropHelper windowHandle = new WindowInteropHelper(this);
            windowHandle.Owner = AppSDK.GetMaxHWND();
            AppSDK.ConfigureWindowForMax(this);
            WindowStartupLocation = WindowStartupLocation.CenterOwner;

        }


        /// <summary>
        /// Set the window location on the center of the screen
        /// </summary>
        public void CenterOnScreen()
        {
            Rectangle screen = Helpers.CurrentScreenBounds(this);
            Top = (Math.Abs(screen.Top) + screen.Bottom / 2) - (Height / 2);
            Left = (Math.Abs(screen.Left) + screen.Right / 2) - (Width / 2);

            //Kernel.Print(string.Format("Left: {0}, Right: {1}\n", screen.Left, screen.Right));
        }


        public void CenterOnMax()
        {
            Rectangle maxWnd = new Rectangle();
            NativeMethods.GetWindowRect(AppSDK.GetMaxHWND(), out maxWnd);
            Top = ((maxWnd.Top + maxWnd.Bottom) / 2) - (Height / 2);
            Left = ((maxWnd.Left + maxWnd.Right) / 2) - (Width / 2);

            //Kernel.Print(string.Format("Top: {0}, Bottom: {1}, Left: {2}, Right: {3}\n", maxWnd.Top, maxWnd.Bottom, maxWnd.Left, maxWnd.Right));
        }




        #endregion Public


        #endregion Methods


    }

}
