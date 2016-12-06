using CodeDoc.Model;
using CodeDoc.Src;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Documents;

namespace CodeDoc.ViewModel
{
    public class CDViewModel
    {

        // Fields
        #region Fields


        private ICDTreeViewItem _SelectedItem = null;
 

        #endregion // End Fields



        // Properties
        #region Properties


        public ObservableCollection<ICDTreeViewItem> Folders { get; private set; }
        public FlowDocument Document { get; private set; }
        public ICDTreeViewItem SelectedItem
        {
            get { return _SelectedItem; }
            set
            {
                _SelectedItem = value;
                GetDocument();
            }
        }


        #endregion // End Properties



        // Constructors
        #region Constructor


        public CDViewModel()
        {
            Document = new FlowDocument();
            Folders = new ObservableCollection<ICDTreeViewItem>()
            {
                new CDFolder("Libraries", "Libs"),
                //new Folder("Managers"),
                //new Folder("Scripts"),
            };
        }


        #endregion // End Constructors



        // Methods
        #region Methods


        private void GetDocument()
        {
            Document.Blocks.Clear();

            switch(SelectedItem.Type)
            {
                case ItemType.Script:
                    Document.Blocks.Add(CDDescriptionParser.ParseScript(SelectedItem.Description));
                    break;
                case ItemType.Function:
                    Document.Blocks.Add(CDDescriptionParser.ParseFunction(SelectedItem.Description));
                    break;
                default:
                    break;
            }
        }


        #endregion // End Methods


    }
}
