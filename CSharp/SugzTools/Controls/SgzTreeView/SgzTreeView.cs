using SugzTools.Src;
using SugzTools.Temp;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Input;
using System.Windows.Media;

namespace SugzTools.Controls
{
    public class SgzTreeView : TreeView
    {

        #region Fields


        private SgzDataTemplateSelector _TemplateSelector = new SgzDataTemplateSelector();
        private TreeViewItem _SourceItem;
        private ItemsControl _DropItem;
        private Point _DragStartPoint;
        private SolidColorBrush _Transparent = new SolidColorBrush(Colors.Transparent);
        private List<SgzTreeViewItem> _SelectedItems;

        #endregion Fields


        #region Properties


        /// <summary>
        /// Get or set if the drop target should be expanded after the drop.
        /// </summary>
        [Description("Get or set if the drop target should be expanded after the drop."), Category("Common")]
        public bool ExpandParentOnDrop { get; set; } = true;


        /// <summary>
        /// Get or set the visual style for the selected rows.
        /// </summary>
        [Description("Get or set the visual style for the selected row."), Category("Appearance")]
        public TreeViewSelectedRowVisual SelectedRowVisual
        {
            get { return (TreeViewSelectedRowVisual)GetValue(SelectedRowVisualProperty); }
            set { SetValue(SelectedRowVisualProperty, value); }
        }


        /// <summary>
        /// Get or set the rows height.
        /// </summary>
        [Description("Get or set the row height."), Category("Layout")]
        public double RowHeight
        {
            get { return (double)GetValue(RowHeightProperty); }
            set { SetValue(RowHeightProperty, value); }
        }


        /// <summary>
        /// Get or set the selected rows background.
        /// </summary>
        [Description("Get or set the selected rows background."), Category("Brush")]
        public Brush SelectionBackground
        {
            get { return (Brush)GetValue(SelectionBackgroundProperty); }
            set { SetValue(SelectionBackgroundProperty, value); }
        }


        /// <summary>
        /// Get or set the selected rows background when it's unfocus.
        /// </summary>
        [Description("Get or set the selected rows background when it's unfocus."), Category("Brush")]
        public Brush SelectionInactiveBackground
        {
            get { return (Brush)GetValue(SelectionInactiveBackgroundProperty); }
            set { SetValue(SelectionInactiveBackgroundProperty, value); }
        }


        /// <summary>
        /// Get or set the BorderBrush for the drop target item.
        /// </summary>
        [Description("Get or set the BorderBrush for the drop target item.."), Category("Brush")]
        public Brush DragOverBorderBrush { get; set; } = Resource<SolidColorBrush>.GetColor("MaxBlue");



        #endregion Properties


        #region Dependency Properties


        // DependencyProperty as the backing store for TreeViewSelectedRowVisual
        public static readonly DependencyProperty SelectedRowVisualProperty = DependencyProperty.Register(
            "SelectedRowVisual",
            typeof(TreeViewSelectedRowVisual),
            typeof(SgzTreeView),
            new PropertyMetadata(TreeViewSelectedRowVisual.Item)
        );


        // DependencyProperty as the backing store for RowHeight
        public static readonly DependencyProperty RowHeightProperty = DependencyProperty.Register(
            "RowHeight",
            typeof(double),
            typeof(SgzTreeView),
            new PropertyMetadata(double.NaN)
        );


        // DependencyProperty as the backing store for SelectionBackground
        public static readonly DependencyProperty SelectionBackgroundProperty = DependencyProperty.Register(
            "SelectionBackground",
            typeof(Brush),
            typeof(SgzTreeView),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlue"))
        );


        // DependencyProperty as the backing store for SelectionInactiveBackground
        public static readonly DependencyProperty SelectionInactiveBackgroundProperty = DependencyProperty.Register(
            "SelectionInactiveBackground",
            typeof(Brush),
            typeof(SgzTreeView),
            new PropertyMetadata(Resource<SolidColorBrush>.GetColor("MaxBlueMouseOver"))
        );


        #endregion Dependency Properties


        #region Constructors


        static SgzTreeView()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzTreeView), new FrameworkPropertyMetadata(typeof(SgzTreeView)));
        }
        public SgzTreeView()
        {
            ItemTemplateSelector = _TemplateSelector;
            //Loaded += SetDragDropEventHandlers;
        }


        #endregion Constructors


        #region Methods


        #region Private


        /// <summary>
        /// Get TreeViewItem parent node
        /// Code by Rohit: https://stackoverflow.com/a/29006266/3971575
        /// </summary>
        /// <param name="item"></param>
        /// <returns></returns>
        private ItemsControl GetTreeViewItemParent(TreeViewItem item)
        {
            DependencyObject parent = VisualTreeHelper.GetParent(item);
            while (!(parent is TreeViewItem || parent is TreeView))
                parent = VisualTreeHelper.GetParent(parent);

            return parent as ItemsControl;
        }

        
        #endregion Private


        public void AddTemplate(Type type, DataTemplate template)
        {
            _TemplateSelector.Templates.Add(type, template);
        }


        #endregion Methods


        #region DragDrop


        private void ResetDropItem()
        {
            if (_DropItem != null)
            {
                _DropItem.BorderBrush = _Transparent;
                _DropItem = null;
            }
        }

        private void Reset()
        {
            _SourceItem = null;
            ResetDropItem();
        }

        private void SetDragDropEventHandlers(object sender, RoutedEventArgs e)
        {
            if (AllowDrop)
            {
                PreviewMouseDown += SgzTreeView_PreviewMouseDown;
                PreviewMouseMove += SgzTreeView_PreviewMouseMove;
                PreviewDragOver += SgzTreeView_PreviewDragOver;
                PreviewDrop += SgzTreeView_PreviewDrop;
            }
        }

        private void SgzTreeView_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            if (e.ChangedButton == MouseButton.Left)
            {
                TreeViewItem item = Helpers.FindAnchestor<TreeViewItem>((DependencyObject)e.OriginalSource);
                if (item != null)
                {
                    _SourceItem = item;
                    _DragStartPoint = e.GetPosition(this);
                }
                else Reset();
            }
        }

        private void SgzTreeView_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Vector delta = _DragStartPoint - e.GetPosition(this);
                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(delta.X) > SystemParameters.MinimumHorizontalDragDistance || Math.Abs(delta.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem, DragDropEffects.Copy);
                }
            }
        }

        private void SgzTreeView_PreviewDragOver(object sender, DragEventArgs e)
        {
            ResetDropItem();

            // Get drop target
            ItemsControl item = Helpers.FindAnchestor<ItemsControl>((DependencyObject)e.OriginalSource);
            if (item != null && item != _SourceItem)
            {
                _DropItem = item;
                _DropItem.BorderBrush = DragOverBorderBrush;
            }
        }

        private void SgzTreeView_PreviewDrop(object sender, DragEventArgs e)
        {
            if (_SourceItem != null && _DropItem != null)
            {
                // Remove item from parent collection
                SgzTreeViewItem sourceItemModel = (SgzTreeViewItem)_SourceItem.DataContext;
                ((ObservableCollection<object>)GetTreeViewItemParent(_SourceItem).ItemsSource).Remove(sourceItemModel);

                // Initialise the children collection if it's null
                if (!(_DropItem.ItemsSource != null))
                    _DropItem.ItemsSource = new ObservableCollection<object>();

                // Add item to new parent
                ((ObservableCollection<object>)_DropItem.ItemsSource).Add(sourceItemModel);

                // Expanded new parent if needed and select sourceItemModel
                if (ExpandParentOnDrop)
                    ((SgzTreeViewItem)_DropItem.DataContext).SgzIsItemExpanded = true;

                Items.ForEach(x => ((SgzTreeViewItem)x).SgzIsItemSelected = false);
                sourceItemModel.SgzIsItemSelected = true;

                Reset();
            }
        }


        #endregion DragDrop




        /// <summary>
        /// 
        /// </summary>
        [Description(""), Category("Common")]
        public bool IsMultipleSelection
        {
            get { return (bool)GetValue(IsMultipleSelectionProperty); }
            set { SetValue(IsMultipleSelectionProperty, value); }
        }

        // DependencyProperty as the backing store for IsMultipleSelection
        public static readonly DependencyProperty IsMultipleSelectionProperty = DependencyProperty.Register(
            "IsMultipleSelection",
            typeof(bool),
            typeof(SgzTreeView),
            new PropertyMetadata(false, OnMultipleSelectionChanged)
        );

        private static void OnMultipleSelectionChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            if (d is SgzTreeView treeView && e.NewValue is bool)
            {
                if ((bool)e.NewValue)
                    treeView.AddHandler(MouseLeftButtonDownEvent, new MouseButtonEventHandler(treeView.OnTreeViewItemClicked), true);
                else
                    treeView.RemoveHandler(MouseLeftButtonDownEvent, new MouseButtonEventHandler(treeView.OnTreeViewItemClicked));
            }
        }

        private void OnTreeViewItemClicked(object sender, MouseButtonEventArgs e)
        {
            TreeViewItem item = Helpers.FindAnchestor<TreeViewItem>((DependencyObject)e.OriginalSource);
            if (item != null)
            {
                switch (Keyboard.Modifiers)
                {
                    case ModifierKeys.Control:
                        SelectMultipleItemsRandomly(item);
                        break;
                    case ModifierKeys.Shift:
                        SelectMultipleItemsContinuously(item);
                        break;
                    default:
                        SelectSingleItem(item);
                        break;
                }
            }
        }


        /// <summary>
        /// Attached DependencyProperty for IsItemSelected
        /// </summary>
        public static readonly DependencyProperty IsItemSelectedProperty = DependencyProperty.RegisterAttached(
            "IsItemSelected",
            typeof(bool),
            typeof(SgzTreeView),
            new PropertyMetadata(false, OnIsItemSelectedChanged)
        );
        public static bool GetIsItemSelected(DependencyObject obj)
        {
            return (bool)obj.GetValue(IsItemSelectedProperty);
        }
        public static void SetIsItemSelected(DependencyObject obj, bool value)
        {
            obj.SetValue(IsItemSelectedProperty, value);
        }

        private static void OnIsItemSelectedChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            if (d is TreeViewItem treeViewItem && VisualTreeHelper.GetParent(d) is TreeView treeView)
            {
                var selectedItems = GetSelectedItems(treeView);
                if (selectedItems != null)
                {
                    if (GetIsItemSelected(treeViewItem))
                    {
                        selectedItems.Add(treeViewItem.Header);
                    }
                    else
                    {
                        selectedItems.Remove(treeViewItem.Header);
                    }
                }
            }
        }



        /// <summary>
        /// Attached DependencyProperty for SelectedItems
        /// </summary>
        public static readonly DependencyProperty SelectedItemsProperty = DependencyProperty.RegisterAttached(
            "SelectedItems",
            typeof(IList),
            typeof(SgzTreeView)
        );
        public static IList GetSelectedItems(DependencyObject obj)
        {
            return (IList)obj.GetValue(SelectedItemsProperty);
        }
        public static void SetSelectedItems(DependencyObject obj, IList value)
        {
            obj.SetValue(SelectedItemsProperty, value);
        }


        /// <summary>
        /// Attached DependencyProperty for StartItem
        /// </summary>
        public static readonly DependencyProperty StartItemProperty = DependencyProperty.RegisterAttached(
            "StartItem",
            typeof(TreeViewItem),
            typeof(SgzTreeView)
        );
        public static TreeViewItem GetStartItem(DependencyObject obj)
        {
            return (TreeViewItem)obj.GetValue(StartItemProperty);
        }
        public static void SetStartItem(DependencyObject obj, TreeViewItem value)
        {
            obj.SetValue(StartItemProperty, value);
        }







        


        private void DeSelectAllItems(TreeViewItem treeViewItem)
        {
            if (treeViewItem != null)
            {
                for (int i = 0; i < treeViewItem.Items.Count; i++)
                {
                    if (treeViewItem.ItemContainerGenerator.ContainerFromIndex(i) is TreeViewItem item)
                    {
                        SetIsItemSelected(item, false);
                        DeSelectAllItems(item);
                    }
                }
            }
            else
            {
                for (int i = 0; i < Items.Count; i++)
                {
                    if (ItemContainerGenerator.ContainerFromIndex(i) is TreeViewItem item)
                    {
                        SetIsItemSelected(item, false);
                        DeSelectAllItems(item);
                    }
                }
            }
        }


        private void SelectSingleItem(TreeViewItem item)
        {
            // first deselect all items
            DeSelectAllItems(null);
            SetIsItemSelected(item, true);
            SetStartItem(this, item);
        }


        private void SelectMultipleItemsRandomly(TreeViewItem treeViewItem)
        {
            SetIsItemSelected(treeViewItem, !GetIsItemSelected(treeViewItem));
            if (GetStartItem(this) == null)
            {
                if (GetIsItemSelected(treeViewItem))
                    SetStartItem(this, treeViewItem);
            }
            else
            {
                if (GetSelectedItems(this).Count == 0)
                    SetStartItem(this, null);
            }
        }


        private void SelectMultipleItemsContinuously(TreeViewItem treeViewItem)
        {
            TreeViewItem startItem = GetStartItem(this);
            if (startItem != null)
            {
                if (startItem == treeViewItem)
                {
                    SelectSingleItem(treeViewItem);
                    return;
                }

                ICollection<TreeViewItem> allItems = new List<TreeViewItem>();
                GetAllItems(null, allItems);
                DeSelectAllItems(null);
                bool isBetween = false;
                foreach (var item in allItems)
                {
                    if (item == treeViewItem || item == startItem)
                    {
                        // toggle to true if first element is found and
                        // back to false if last element is found
                        isBetween = !isBetween;

                        // set boundary element
                        SetIsItemSelected(item, true);
                        continue;
                    }

                    if (isBetween)
                    {
                        SetIsItemSelected(item, true);
                    }
                }
            }
        }


        private void GetAllItems(TreeViewItem treeViewItem, ICollection<TreeViewItem> allItems)
        {
            if (treeViewItem != null)
            {
                for (int i = 0; i < treeViewItem.Items.Count; i++)
                {
                    if (treeViewItem.ItemContainerGenerator.ContainerFromIndex(i) is TreeViewItem item)
                    {
                        allItems.Add(item);
                        GetAllItems(item, allItems);
                    }
                }
            }
            else
            {
                for (int i = 0; i < Items.Count; i++)
                {
                    TreeViewItem item = ItemContainerGenerator.ContainerFromIndex(i) as TreeViewItem;
                    if (item != null)
                    {
                        allItems.Add(item);
                        GetAllItems(item, allItems);
                    }
                }
            }
        }



    }
}