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


        private ElementHost elementHost;
        private ContentPresenter presenter;


        #endregion Fields


        #region Properties


        public object Content
        {
            get { return presenter.Content; }
            set { presenter.Content = value; }
        }


        #endregion Properties


        #region Constructor


        public SgzMaxForm()
        {
            elementHost = new ElementHost();
            presenter = new ContentPresenter();
            SuspendLayout();

            // ContentPresenter
            presenter.HorizontalAlignment = System.Windows.HorizontalAlignment.Stretch;
            presenter.VerticalAlignment = System.Windows.VerticalAlignment.Stretch;

            // ElementHost
            elementHost.Dock = DockStyle.Fill;
            elementHost.Location = new Point(0, 0);
            elementHost.Child = presenter;

            // Form
            Text = "SgzMaxForm";
            Controls.Add(elementHost);
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
