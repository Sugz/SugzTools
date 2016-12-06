using MaxCustomControls;
using System.Drawing;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Forms.Integration;

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

    }
}
