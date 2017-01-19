using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Collections.Generic;

namespace SugzTools.Controls
{

    public class DragAndDropListBoxBase : ListBox
    {
        //static DragAndDropListBoxBase()
        //{
        //    DefaultStyleKeyProperty.OverrideMetadata(typeof(DragAndDropListBoxBase), new FrameworkPropertyMetadata(typeof(DragAndDropListBoxBase)));
        //}
    }



    public class DragAndDropListBox<T> : ListBox
        where T : class
    {

        #region Fields


        private Point _dragStartPoint;
        protected T _SourceItem;
        protected T _TargetItem;


        #endregion Fields



        #region Constructor


        public DragAndDropListBox()
        {
            PreviewMouseMove += List_PreviewMouseMove;
            PreviewMouseLeftButtonDown += List_PreviewMouseLeftButtonDown;
            Drop += List_Drop;
        }


        #endregion Constructor



        #region Methods


        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            // Add the DragEnter event handler to the ListBoxItem to catch _TargetItem 
            Style itemContainerStyle = ItemContainerStyle;
            if (itemContainerStyle != null)
                itemContainerStyle.Setters.Add(new EventSetter(DragEnterEvent, new DragEventHandler(ListBoxItem_DragEnter)));

        }


        #endregion Overrides


        #region Privates


        private P FindVisualParent<P>(DependencyObject child)
            where P : DependencyObject
        {
            do
            {
                if (child is P)
                    return (P)child;

                child = VisualTreeHelper.GetParent(child);
            }
            while (child != null);
            return null;
        }


        #endregion Privates


        #region Event Handlers


        private void ListBoxItem_DragEnter(object sender, DragEventArgs e)
        {
            ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
            if (lbi != null && lbi != _SourceItem)
                _TargetItem = lbi.DataContext as T;

        }


        private void List_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Point point = e.GetPosition(null);
                Vector diff = _dragStartPoint - point;

                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(diff.X) > SystemParameters.MinimumHorizontalDragDistance ||
                        Math.Abs(diff.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
                    if (lbi != null)
                        DragDrop.DoDragDrop(lbi, lbi.DataContext, DragDropEffects.Move);

                }
            }
        }


        private void List_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            _dragStartPoint = e.GetPosition(null);

            SgzIcon dragIcon = FindVisualParent<SgzIcon>(((DependencyObject)e.OriginalSource));
            if (dragIcon != null && dragIcon.Name == "PART_Drag")
            {
                ListBoxItem lbi = FindVisualParent<ListBoxItem>(((DependencyObject)e.OriginalSource));
                if (lbi != null)
                    _SourceItem = lbi.DataContext as T;

            }
        }


        private void List_Drop(object sender, DragEventArgs e)
        {
            IList<T> items = DataContext as IList<T>;
            if (items != null && _SourceItem != null)
            {
                int sourceIndex = Items.IndexOf(_SourceItem);
                int targetIndex = Items.IndexOf(_TargetItem);

                if (sourceIndex < targetIndex)
                {
                    items.Insert(targetIndex + 1, _SourceItem);
                    items.RemoveAt(sourceIndex);
                }
                else
                {
                    int removeIndex = sourceIndex + 1;
                    if (items.Count + 1 > removeIndex)
                    {
                        items.Insert(targetIndex, _SourceItem);
                        items.RemoveAt(removeIndex);
                    }
                }

                _SourceItem = null;
            }
        }


        #endregion Event Handlers


        #endregion Methods

    }



    public class ExpanderListBox : DragAndDropListBox<ExpanderItem>
    {
        static ExpanderListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(ExpanderListBox), new FrameworkPropertyMetadata(typeof(ExpanderListBox)));
        }
    }



    public class ExpanderItem
    {

        #region Properties


        public object Header { get; set; }
        public bool IsExpanded { get; set; }
        public object Content { get; set; } 


        #endregion Properties



        #region Constructors



        public ExpanderItem()
        {

        }
        public ExpanderItem(string header, bool isExpanded)
        {
            Header = header;
            Content = header;
            IsExpanded = isExpanded;
        }


        #endregion Constructors


    }

}
