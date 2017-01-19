using SugzTools.Controls;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace ListBoxDragDrop
{

    //public class DragAndDropListBox<T> : ListBox 
    //    where T : class
    //{

    //    #region Fields


    //    private Point _dragStartPoint;
    //    protected T _SourceItem;
    //    protected T _TargetItem; 


    //    #endregion Fields



    //    #region Constructor


    //    public DragAndDropListBox()
    //    {
    //        PreviewMouseMove += List_PreviewMouseMove;
    //        PreviewMouseLeftButtonDown += List_PreviewMouseLeftButtonDown;
    //        Drop += List_Drop;
    //    } 


    //    #endregion Constructor



    //    #region Overrides


    //    public override void OnApplyTemplate()
    //    {
    //        base.OnApplyTemplate();

    //        // Add the DragEnter event handler to the ListBoxItem to catch _TargetItem 
    //        Style itemContainerStyle = ItemContainerStyle;
    //        if (itemContainerStyle != null)
    //            itemContainerStyle.Setters.Add(new EventSetter(DragEnterEvent, new DragEventHandler(ListBoxItem_DragEnter)));

    //    }


    //    #endregion Overrides



    //    #region Methods


    //    private P FindVisualParent<P>(DependencyObject child)
    //        where P : DependencyObject
    //    {
    //        do
    //        {
    //            if (child is P)
    //                return (P)child;

    //            child = VisualTreeHelper.GetParent(child);
    //        }
    //        while (child != null);
    //        return null;
    //    }


    //    #endregion Methods



    //    #region Event Handlers


    //    private void ListBoxItem_DragEnter(object sender, DragEventArgs e)
    //    {
    //        ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
    //        if (lbi != null && lbi != _SourceItem)
    //        {
    //            _TargetItem = lbi.DataContext as T;
    //        }
                
    //    }


    //    private void List_PreviewMouseMove(object sender, MouseEventArgs e)
    //    {
    //        if (_SourceItem != null)
    //        {
    //            Point point = e.GetPosition(null);
    //            Vector diff = _dragStartPoint - point;
    //            if (e.LeftButton == MouseButtonState.Pressed &&
    //                (Math.Abs(diff.X) > SystemParameters.MinimumHorizontalDragDistance ||
    //                    Math.Abs(diff.Y) > SystemParameters.MinimumVerticalDragDistance))
    //            {
    //                ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
    //                if (lbi != null)
    //                {
    //                    DragDrop.DoDragDrop(lbi, lbi.DataContext, DragDropEffects.Move);
    //                }
    //            }
    //        }
    //    }


    //    private void List_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
    //    {
    //        _dragStartPoint = e.GetPosition(null);

    //        SgzIcon dragIcon = FindVisualParent<SgzIcon>(((DependencyObject)e.OriginalSource));
    //        if (dragIcon != null && dragIcon.Name == "PART_Drag")
    //        {
    //            ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
    //            if (lbi != null)
    //                _SourceItem = lbi.DataContext as T;
    //        }
    //    }


    //    private void List_Drop(object sender, DragEventArgs e)
    //    {
    //        IList<T> items = DataContext as IList<T>;
    //        if (items != null && _SourceItem != null)
    //        {
    //            int sourceIndex = Items.IndexOf(_SourceItem);
    //            int targetIndex = Items.IndexOf(_TargetItem);

    //            if (sourceIndex < targetIndex)
    //            {
    //                items.Insert(targetIndex + 1, _SourceItem);
    //                items.RemoveAt(sourceIndex);
    //            }
    //            else
    //            {
    //                int removeIndex = sourceIndex + 1;
    //                if (items.Count + 1 > removeIndex)
    //                {
    //                    items.Insert(targetIndex, _SourceItem);
    //                    items.RemoveAt(removeIndex);
    //                }
    //            }

    //            _SourceItem = null;
    //        }
    //    } 


        
    //    protected virtual void Print() { }


    //    #endregion Event Handlers

    //}




    //public class ItemDragAndDropListBox : DragAndDropListBox<ExpanderItem>
    //{


    //    protected override void Print()
    //    {
    //        object sourceName = _SourceItem != null ? _SourceItem.Header : "Null";
    //        //Console.WriteLine($"SourceItem: {sourceName}\nTargetItem: {_TargetItem.Name}");
    //        Console.WriteLine($"TargetItem: {_TargetItem.Header}");
    //    }
    //}


    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window
    {
        IList<ExpanderItem> _items;

        public MainWindow()
        {
            InitializeComponent();

            _items = new ObservableCollection<ExpanderItem>()
            {
                new ExpanderItem("1", true),
                new ExpanderItem("2", false),
                new ExpanderItem("3", false),
                new ExpanderItem("4", true),
                new ExpanderItem("5", false),
                new ExpanderItem("6", false),
            };

            listBox.DataContext = _items;

        }

    }
}
