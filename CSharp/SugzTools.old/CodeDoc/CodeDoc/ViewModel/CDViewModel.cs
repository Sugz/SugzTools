using CodeDoc.Model;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Documents;
using System.Windows.Media;

namespace CodeDoc.ViewModel
{
    public class CDViewModel : INotifyPropertyChanged
    {

        // INotifyPropertyChanged
        #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }


        #endregion // End INotifyPropertyChanged



        // Fields
        #region Fields


        private ICDTreeViewItem _SelectedItem = null;
        private FlowDocument _Document;
        


        #endregion // End Fields



        // Properties
        #region Properties


        public ObservableCollection<ICDTreeViewItem> Folders { get; private set; }
        public FlowDocument Document
        {
            get { return _Document; }
            set
            {
                _Document = value;
                OnPropertyChanged();
            }
        }
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
            // Define a style to apply to all document paragraphs
            Style style = new Style(typeof(Paragraph));
            style.Setters.Add(new Setter(Block.MarginProperty, new Thickness(0)));

            // Get and format the document
            Document = SelectedItem.Description;
            Document.PagePadding = new Thickness(5);
            Document.FontFamily = new FontFamily("Segoe UI");
            Document.FontSize = 12;
            Document.Resources.Add(typeof(Paragraph), style);
        }


        #endregion // End Methods


    }
}
