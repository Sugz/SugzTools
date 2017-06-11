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
using System.Windows.Media.Media3D;

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
        private static TreeViewItem _selectTreeViewItemOnMouseUp;

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

            GotFocus += OnTreeViewItemGotFocus;
            PreviewMouseLeftButtonDown += OnTreeViewItemPreviewMouseDown;
            PreviewMouseLeftButtonUp += OnTreeViewItemPreviewMouseUp;

            //Loaded += SetDragDropEventHandlers;
        }


        #endregion Constructors


        #region Methods


        #region Private


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

        /*
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
        */



        


        public static readonly DependencyProperty IsItemSelectedProperty = DependencyProperty.RegisterAttached(
            "IsItemSelected", 
            typeof(Boolean), 
            typeof(SgzTreeView), 
            new PropertyMetadata(false, OnIsItemSelectedPropertyChanged)
        );

        public static bool GetIsItemSelected(TreeViewItem element)
        {
            return (bool)element.GetValue(IsItemSelectedProperty);
        }

        public static void SetIsItemSelected(TreeViewItem element, Boolean value)
        {
            if (element == null) return;

            element.SetValue(IsItemSelectedProperty, value);
        }

        private static void OnIsItemSelectedPropertyChanged(DependencyObject d, DependencyPropertyChangedEventArgs e)
        {
            DependencyObject treeView = VisualTreeHelper.GetParent(d);
            while (!(treeView is TreeView))
                treeView = VisualTreeHelper.GetParent(treeView);

            if (d is TreeViewItem treeViewItem&& treeView != null)
            {
                var selectedItems = GetSelectedItems((TreeView)treeView);
                if (selectedItems != null)
                {
                    if (GetIsItemSelected(treeViewItem))
                        selectedItems.Add(treeViewItem.Header);
                    else
                        selectedItems.Remove(treeViewItem.Header);
                }
            }
        }




        public static readonly DependencyProperty SelectedItemsProperty = DependencyProperty.RegisterAttached(
            "SelectedItems", 
            typeof(IList), 
            typeof(SgzTreeView)
        );

        public static IList GetSelectedItems(TreeView element)
        {
            return (IList)element.GetValue(SelectedItemsProperty);
        }

        public static void SetSelectedItems(TreeView element, IList value)
        {
            element.SetValue(SelectedItemsProperty, value);
        }




        private static readonly DependencyProperty StartItemProperty = DependencyProperty.RegisterAttached(
            "StartItem", 
            typeof(TreeViewItem), 
            typeof(SgzTreeView)
        );

        private static TreeViewItem GetStartItem(TreeView element)
        {
            return (TreeViewItem)element.GetValue(StartItemProperty);
        }

        private static void SetStartItem(TreeView element, TreeViewItem value)
        {
            element.SetValue(StartItemProperty, value);
        }



        private void OnTreeViewItemGotFocus(object sender, RoutedEventArgs e)
        {
            _selectTreeViewItemOnMouseUp = null;

            if (e.OriginalSource is TreeView)
                return;

            var treeViewItem = FindTreeViewItem(e.OriginalSource as DependencyObject);
            if (Mouse.LeftButton == MouseButtonState.Pressed && GetIsItemSelected(treeViewItem) && Keyboard.Modifiers != ModifierKeys.Control)
            {
                _selectTreeViewItemOnMouseUp = treeViewItem;
                return;
            }

            SelectItems(treeViewItem);
        }

        private void OnTreeViewItemPreviewMouseDown(object sender, MouseEventArgs e)
        {
            var treeViewItem = FindTreeViewItem(e.OriginalSource as DependencyObject);

            if (treeViewItem != null && treeViewItem.IsFocused)
                OnTreeViewItemGotFocus(sender, e);
        }

        private void OnTreeViewItemPreviewMouseUp(object sender, MouseButtonEventArgs e)
        {
            var treeViewItem = FindTreeViewItem(e.OriginalSource as DependencyObject);

            if (treeViewItem == _selectTreeViewItemOnMouseUp)
                SelectItems(treeViewItem);
        }


        private TreeViewItem FindTreeViewItem(DependencyObject dependencyObject)
        {
            if (!(dependencyObject is Visual || dependencyObject is Visual3D))
                return null;

            if (dependencyObject is TreeViewItem treeViewItem)
                return treeViewItem;

            return FindTreeViewItem(VisualTreeHelper.GetParent(dependencyObject));
        }



        private void SelectItems(TreeViewItem treeViewItem)
        {
            if (treeViewItem != null)
            {
                if ((Keyboard.Modifiers & (ModifierKeys.Control | ModifierKeys.Shift)) == (ModifierKeys.Control | ModifierKeys.Shift))
                {
                    SelectMultipleItemsContinuously(treeViewItem, true);
                }
                else if (Keyboard.Modifiers == ModifierKeys.Control)
                {
                    SelectMultipleItemsRandomly(treeViewItem);
                }
                else if (Keyboard.Modifiers == ModifierKeys.Shift)
                {
                    SelectMultipleItemsContinuously(treeViewItem);
                }
                else
                {
                    SelectSingleItem(treeViewItem);
                }
            }
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

        private void SelectSingleItem(TreeViewItem treeViewItem)
        {
            // first deselect all items
            DeSelectAllItems(null);
            SetIsItemSelected(treeViewItem, true);
            SetStartItem(this, treeViewItem);
        }

        private void SelectMultipleItemsRandomly(TreeViewItem treeViewItem)
        {
            SetIsItemSelected(treeViewItem, !GetIsItemSelected(treeViewItem));
            if (GetStartItem(this) == null || Keyboard.Modifiers == ModifierKeys.Control)
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

        private void SelectMultipleItemsContinuously(TreeViewItem treeViewItem, bool shiftControl = false)
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
                //DeSelectAllItems(treeView, null);
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
                        continue;
                    }

                    if (!shiftControl)
                        SetIsItemSelected(item, false);
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
                    if (ItemContainerGenerator.ContainerFromIndex(i) is TreeViewItem item)
                    {
                        allItems.Add(item);
                        GetAllItems(item, allItems);
                    }
                }
            }
        }

    }
}