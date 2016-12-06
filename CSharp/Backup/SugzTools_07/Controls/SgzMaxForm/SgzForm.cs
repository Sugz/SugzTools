using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Forms.Integration;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzForm : Form
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


        public SgzForm()
        {
            eh = new ElementHost();
            pnl = new ContentPresenter();
            SuspendLayout();

            // ContentPresenter
            pnl.Width = 200;
            pnl.Height = 400;

            // ElementHost
            eh.Dock = DockStyle.Fill;
            eh.Location = new System.Drawing.Point(0, 0);
            eh.Child = pnl;

            // Form
            Text = "SgzMaxForm";
            ClientSize = new System.Drawing.Size(210, 350);
            Controls.Add(eh);

            ResumeLayout(false);
        }


        #endregion Constructor


    }
}
