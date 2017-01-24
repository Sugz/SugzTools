using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Controls;
using System.Windows;
using System.Windows.Media;
using System.Windows.Documents;
using System.Windows.Shapes;
using System.Windows.Controls.Primitives;
using System.Collections;
using System.Diagnostics;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;

namespace DragAndDropLib
{
    public class ItemsControlDragDecorator : Decorator 
    {
        private bool _isMouseDown;
        private object _data;
        private Point _dragStartPosition;
        private bool _isDragging;

        static ItemsControlDragDecorator()
        {
            ItemTypeProperty = DependencyProperty.Register("ItemType", typeof(Type), typeof(ItemsControlDragDecorator));
            AllowDropProperty = DependencyProperty.Register("AllowDrop", typeof(bool), typeof(ItemsControlDragDecorator), new FrameworkPropertyMetadata(true));
        }

        public ItemsControlDragDecorator() : base()
        {
            _isMouseDown = false;
            _isDragging = false;
            this.Loaded += new RoutedEventHandler(DraggableItemsControl_Loaded);
        }

        void DraggableItemsControl_Loaded(object sender, RoutedEventArgs e)
        {
            if (!(Child is ItemsControl))
            {
                throw new InvalidCastException(string.Format("ItemsControlDragDecorator cannot have child of type {0}", Child.GetType()));
            }
            ItemsControl itemsControl = (ItemsControl)Child;
            itemsControl.AllowDrop = AllowDrop;
            itemsControl.PreviewMouseLeftButtonDown += new System.Windows.Input.MouseButtonEventHandler(_itemsControl_PreviewMouseLeftButtonDown);
            itemsControl.PreviewMouseMove += new System.Windows.Input.MouseEventHandler(_itemsControl_PreviewMouseMove);
            itemsControl.PreviewMouseLeftButtonUp += new System.Windows.Input.MouseButtonEventHandler(itemsControl_PreviewMouseLeftButtonUp);
            itemsControl.PreviewDrop += new DragEventHandler(itemsControl_PreviewDrop);
            itemsControl.PreviewQueryContinueDrag += new QueryContinueDragEventHandler(itemsControl_PreviewQueryContinueDrag);
        }

        #region Dependency Properties

        public static readonly DependencyProperty ItemTypeProperty;

        public Type ItemType
        {
            get { return (Type)base.GetValue(ItemTypeProperty); }
            set { base.SetValue(ItemTypeProperty, value); }
        }

        public static readonly DependencyProperty AllowDropProperty;

        public bool AllowDrop
        {
            get { return (bool)base.GetValue(AllowDropProperty); }
            set { base.SetValue(AllowDropProperty, value); }
        }

        #endregion

        #region Button Events

        void itemsControl_PreviewMouseLeftButtonUp(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            ResetState((ItemsControl)sender);
            e.Handled = true;
        }

        void _itemsControl_PreviewMouseMove(object sender, System.Windows.Input.MouseEventArgs e)
        {
            if (_isMouseDown)
            {
                ItemsControl itemsControl = (ItemsControl)sender;
                Point currentPosition = e.GetPosition(itemsControl);
                if ((_isDragging == false) && (Math.Abs(currentPosition.X - _dragStartPosition.X) > SystemParameters.MinimumHorizontalDragDistance) ||
                    (Math.Abs(currentPosition.Y - _dragStartPosition.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    DragStarted(itemsControl);
                }
            }
        }

        void _itemsControl_PreviewMouseLeftButtonDown(object sender, System.Windows.Input.MouseButtonEventArgs e)
        {
            ItemsControl itemsControl = sender as ItemsControl;
            if (sender != null)
            {
                Point p = e.GetPosition(itemsControl);
                _data = GetDataObjectFromItemsControl(itemsControl, p);
                if (_data != null)
                {
                    _isMouseDown = true;
                    _dragStartPosition = p;
                }
            }
        }
        #endregion 

        #region Drag Events

        void itemsControl_PreviewQueryContinueDrag(object sender, QueryContinueDragEventArgs e)
        {
            if (e.EscapePressed)
            {
                e.Action = DragAction.Cancel;
                ResetState((ItemsControl)sender);
                e.Handled = true;
            }
        }

        void itemsControl_PreviewDrop(object sender, DragEventArgs e)
        {
            ItemsControl itemsControl = (ItemsControl)sender;
            if (e.Data.GetDataPresent(ItemType))
            {
                e.Effects = ((e.KeyStates & DragDropKeyStates.ControlKey) == 0) ?
                    DragDropEffects.Copy : DragDropEffects.Move;
                object itemToAdd = e.Data.GetData(ItemType);
                if (!itemsControl.Items.Contains(itemToAdd))
                {
                    itemsControl.Items.Add(itemToAdd);
                }
                e.Handled = true;
            }
        }

        #endregion

        #region Private Methods

        private void DragStarted(ItemsControl itemsControl)
        {
            _isDragging = true;

            DataObject dObject = new DataObject(ItemType, _data);
            itemsControl.AllowDrop = false;
            DragDropEffects e = DragDrop.DoDragDrop(itemsControl, dObject, DragDropEffects.Copy | DragDropEffects.Move);
            if ((e & DragDropEffects.Move) != 0)
            {
                itemsControl.Items.Remove(_data);
            }
            ResetState(itemsControl);
        }

        private void ResetState(ItemsControl itemsControl)
        {
            _isMouseDown = false;
            _isDragging = false;
            _data = null;
            itemsControl.AllowDrop = AllowDrop;
        }

        private object GetDataObjectFromItemsControl(ItemsControl itemsControl, Point p)
        {
            UIElement element = itemsControl.InputHitTest(p) as UIElement;
            while (element != null)
            {
                if (element == itemsControl)
                    return null;

                object data = itemsControl.ItemContainerGenerator.ItemFromContainer(element);
                if (data != DependencyProperty.UnsetValue)
                {
                    return data;
                }
                else
                {
                    element = VisualTreeHelper.GetParent(element) as UIElement;
                }
            }
            return null;
        }

        #endregion
    }
}
