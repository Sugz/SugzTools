// Based on the exemple provided by Yury Vetyukov (Yury.Vetyukov@tuwien.ac.at)
// https://www.codeproject.com/Articles/893068/WPF-TreeView-with-in-place-editing

using System;
using System.ComponentModel;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;

namespace CodeDoc.Controls
{
    /// <summary>
    /// Interaction logic for EditableTreeView.xaml
    /// </summary>
    public partial class EditableTreeView : TreeView, INotifyPropertyChanged
    {

        #region INotifyPropertyChanged

        public event PropertyChangedEventHandler PropertyChanged;
        protected void OnPropertyChanged([CallerMemberName] string propertyName = null) =>
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));

        #endregion INotifyPropertyChanged


        #region Fields


        private bool _IsInEditMode;
        private string _OldText;

        #endregion Fields


        #region Properties


        public bool IsInEditMode
        {
            get { return _IsInEditMode; }
            set
            {
                _IsInEditMode = value;
                OnPropertyChanged();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        [Description("")]
        public new object SelectedItem
        {
            get { return GetValue(SelectedItemProperty); }
            set { SetValue(SelectedItemProperty, value); }
        }

        // DependencyProperty as the backing store for SelectedItem
        public static readonly new DependencyProperty SelectedItemProperty = DependencyProperty.Register(
            "SelectedItem",
            typeof(object),
            typeof(EditableTreeView),
            new PropertyMetadata(null, OnSelectedItemChanged)
        );


        #endregion Properties


        #region Constructor


        public EditableTreeView()
        {
            InitializeComponent();
            SelectedItemChanged += EditableTreeView_SelectedItemChanged; ;
        }

        private void EditableTreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            SelectedItem = e.NewValue;
        }


        #endregion Constructor


        #region Methods


        // searches for the corresponding TreeViewItem,
        // based on http://stackoverflow.com/questions/592373/select-treeview-node-on-right-click-before-displaying-contextmenu
        private TreeViewItem FindTreeItem(DependencyObject source)
        {
            while (source != null && !(source is TreeViewItem))
                source = VisualTreeHelper.GetParent(source);
            return source as TreeViewItem;
        }


        #endregion Methods


        #region Event Handlers

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private static void OnSelectedItemChanged(DependencyObject sender, DependencyPropertyChangedEventArgs e)
        {
            if (e.NewValue is TreeViewItem item)
                item.SetValue(TreeViewItem.IsSelectedProperty, true);
        }


        /// <summary>
        /// Switch to edit mode when the user presses F2 and a item is selected
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TreeView_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.F2)
                IsInEditMode = true;
        }


        /// <summary>
        /// Turn off edit mode when selected item changed
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TreeView_SelectedItemChanged(object sender, RoutedPropertyChangedEventArgs<object> e)
        {
            IsInEditMode = false;
        }


        /// <summary>
        /// Edit an item when its already selected and double cliked
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextBlock_MouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            if (FindTreeItem(e.OriginalSource as DependencyObject).IsSelected && e.ClickCount == 2)
            {
                IsInEditMode = true;
                e.Handled = true;       // otherwise the newly activated control will immediately loose focus
            }
        }


        /// <summary>
        /// Stop editing on Enter or Escape (then with cancel)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextBox_LostFocus(object sender, RoutedEventArgs e)
        {
            IsInEditMode = false;
        }


        /// <summary>
        /// If a text box has just become visible, we give it the keyboard input focus and select contents
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextBox_IsVisibleChanged(object sender, DependencyPropertyChangedEventArgs e)
        {
            var tb = sender as TextBox;
            if (tb.IsVisible)
            {
                tb.Focus();
                tb.SelectAll();
                _OldText = tb.Text;      // back up - for possible cancelling
            }
        }


        /// <summary>
        /// Stop editing on Enter or Escape (then with cancel)
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void TextBox_KeyDown(object sender, KeyEventArgs e)
        {
            if (e.Key == Key.Enter)
                IsInEditMode = false;
            if (e.Key == Key.Escape)
            {
                var tb = sender as TextBox;
                tb.Text = _OldText;
                IsInEditMode = false;
            }
        }


        #endregion Events Handlers

    }


    //public class SetPathEventArgs : EventArgs
    //{
    //    public int Threshold { get; set; }
    //    public DateTime TimeReached { get; set; }
    //}
}


// TODO: ContextMenu