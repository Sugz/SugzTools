using System;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Media;
using System.Collections.Generic;

namespace SugzTools.Controls
{
    /*
    public class SgzExpanderItem : ListBoxItem
    {

        #region Properties

        /// <summary>
        /// Get or set the content for the Header
        /// </summary>
        public object Header { get; set; }

        /// <summary>
        /// Get or set the expand state
        /// </summary>
        public bool IsExpanded
        {
            get { return (bool)GetValue(IsExpandedProperty); }
            set { SetValue(IsExpandedProperty, value); }
        }


        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for IsExpanded
        public static readonly DependencyProperty IsExpandedProperty = DependencyProperty.Register(
            "IsExpanded",
            typeof(bool),
            typeof(SgzExpanderItem),
            new PropertyMetadata(true)
        );


        #endregion Dependency Properties


        #region Constructors


        public SgzExpanderItem()
        {

        }
        public SgzExpanderItem(string header, bool isExpanded)
        {
            Header = header;
            Content = header;
            IsExpanded = isExpanded;
        }


        #endregion Constructors
    }


    public class SgzExpanderListBox : ListBox
    {

        #region Fields


        private Point _DragStartPoint;
        protected SgzExpanderItem _SourceItem;
        protected SgzExpanderItem _TargetItem;


        #endregion Fields


        #region Constructor

        static SgzExpanderListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderListBox), new FrameworkPropertyMetadata(typeof(SgzExpanderListBox)));
        }
        public SgzExpanderListBox()
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


        private T FindVisualParent<T>(DependencyObject child)
            where T : DependencyObject
        {
            do
            {
                if (child is T)
                    return (T)child;

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
                _TargetItem = lbi.DataContext as SgzExpanderItem;

        }


        private void List_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Point point = e.GetPosition(null);
                Vector diff = _DragStartPoint - point;

                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(diff.X) > SystemParameters.MinimumHorizontalDragDistance ||
                        Math.Abs(diff.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    SgzExpanderItem lbi = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
                    if (lbi != null)
                        DragDrop.DoDragDrop(lbi, lbi.DataContext, DragDropEffects.Move);

                }
            }
        }


        private void List_PreviewMouseLeftButtonDown(object sender, MouseButtonEventArgs e)
        {
            _DragStartPoint = e.GetPosition(null);

            SgzIcon dragIcon = FindVisualParent<SgzIcon>(((DependencyObject)e.OriginalSource));
            if (dragIcon != null && dragIcon.Name == "PART_Drag")
            {
                SgzExpanderItem lbi = FindVisualParent<SgzExpanderItem>(((DependencyObject)e.OriginalSource));
                if (lbi != null)
                    _SourceItem = lbi.DataContext as SgzExpanderItem;

            }
        }


        private void List_Drop(object sender, DragEventArgs e)
        {
            IList<SgzExpanderItem> items = DataContext as IList<SgzExpanderItem>;
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
    */

    
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
            AddEventHandlers();
            SetItemContainerStyle();
        }


        #endregion Constructor



        #region Methods


        #region Privates


        /// <summary>
        /// Helper method to get the first VisualParent of a given type
        /// </summary>
        /// <typeparam name="P"></typeparam>
        /// <param name="child"></param>
        /// <returns></returns>
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


        /// <summary>
        /// Add various Event Handlers to handle drag and drop
        /// </summary>
        private void AddEventHandlers()
        {
            PreviewMouseMove += List_PreviewMouseMove;
            PreviewMouseLeftButtonDown += List_PreviewMouseLeftButtonDown;
            Drop += List_Drop;
        }


        /// <summary>
        /// Set the ItemContainerStyle
        /// </summary>
        private void SetItemContainerStyle()
        {
            ControlTemplate template = new ControlTemplate(typeof(ListBoxItem));
            template.VisualTree = new FrameworkElementFactory(typeof(ContentPresenter));

            Style style = new Style(typeof(ListBoxItem));
            style.Setters.Add(new Setter(TemplateProperty, template));
            style.Setters.Add(new Setter(MarginProperty, new Thickness(0, 0, 0, 5)));
            style.Setters.Add(new EventSetter(DragEnterEvent, new DragEventHandler(ListBoxItem_DragEnter)));

            ItemContainerStyle = style;
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



    public class SgzExpanderListBox : DragAndDropListBox<ExpanderItem>
    {
        static SgzExpanderListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpanderListBox), new FrameworkPropertyMetadata(typeof(SgzExpanderListBox)));
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
