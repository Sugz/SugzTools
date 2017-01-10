using ManagedServices;
using MaxCustomControls;
using System.Drawing;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System;

namespace SugzTools.Controls
{
    public class SgzMaxForm : MaxForm
    {

        #region Fields


        private ElementHost eh;
        private ContentPresenter pnl;


        #endregion Fields


        #region Properties


        public object Content
        {
            get { return pnl.Content; }
            set { pnl.Content = value; }
        }


        #endregion Properties


        #region Constructor


        public SgzMaxForm()
        {
            eh = new ElementHost();
            pnl = new ContentPresenter();
            SuspendLayout();

            // ContentPresenter
            pnl.Width = 200;
            pnl.Height = 400;

            // ElementHost
            eh.Dock = DockStyle.Fill;
            eh.Location = new Point(0, 0);
            eh.Child = pnl;

            // Form
            Text = "SgzMaxForm";
            ClientSize = new Size(210, 350);
            Controls.Add(eh);
            ResumeLayout(false);

        }


        #endregion Constructor


        #region Overrides


        public override void ShowModeless()
        {
            //NativeWindow nativeWindow = new NativeWindow();
            //nativeWindow.AssignHandle(AppSDK.GetMaxHWND());
            //Show(nativeWindow);
            //nativeWindow.ReleaseHandle();

            Win32HandleWrapper maxHWND = new Win32HandleWrapper(AppSDK.GetMaxHWND());
            Show(maxHWND);
        } 


        #endregion Overrides


    }


    /// <summary>
    /// Class replacement for missing class in MaxCustomControls, thanks to lo http://forums.cgsociety.org/archive/index.php?t-1166327.html
    /// </summary>
    public class Win32HandleWrapper : IWin32Window
    {
        public IntPtr Handle { get; set; }
        public Win32HandleWrapper(IntPtr handle)
        {
            Handle = handle;
        }
    }
}
