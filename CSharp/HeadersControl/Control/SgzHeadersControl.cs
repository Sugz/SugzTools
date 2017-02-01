using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;
using System.Windows.Media;

namespace HeadersControl
{
    public class SgzHeadersControl : ItemsControl
    {
        private SgzDropIndicator _DropIndicator;
        private SgzExpanderItem _SourceItem;
        private Point _DragStartPoint;
        bool _WentOutside = false;


        static SgzHeadersControl()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzHeadersControl), new FrameworkPropertyMetadata(typeof(SgzHeadersControl)));
        }
        public SgzHeadersControl()
        {
            MouseEnter += SgzHeadersControl_MouseEnter;
            PreviewMouseDown += SgzHeadersControl_PreviewMouseDown;
            PreviewMouseMove += SgzExpandersControl_PreviewMouseMove;
            PreviewDragEnter += SgzHeadersControl_PreviewDragEnter;
            PreviewDragOver += SgzExpandersControl_PreviewDragOver;
            PreviewDragLeave += SgzHeadersControl_PreviewDragLeave;
            PreviewDrop += SgzExpandersControl_PreviewDrop;
        }





        public T GetContainerAtPoint<T>(Point p)  
            where T : DependencyObject
        {
            DependencyObject obj = VisualTreeHelper.HitTest(this, p).VisualHit;

            while (VisualTreeHelper.GetParent(obj) != null && !(obj is T))
                obj = VisualTreeHelper.GetParent(obj);

            // Will return null if not found
            return obj as T;
        }


        public T GetClosestContainerAtPoint<T>(Point p)
            where T : UIElement
        {
            T nearest = null;
            double lastDistance = short.MaxValue;
            foreach (T item in Items)
            {
                Point itemPos = item.TranslatePoint(new Point(0, 0), this);
                double distance = Math.Abs(p.Y - itemPos.Y);
                if (distance > lastDistance && lastDistance != short.MaxValue)
                    return nearest;
                else
                {
                    lastDistance = distance;
                    nearest = item;
                }
            }

            return nearest;
        }




        private void SgzHeadersControl_MouseEnter(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null && e.LeftButton == MouseButtonState.Released)
            {
                _SourceItem = null;
                Items.ForEach(x => ((SgzExpanderItem)x).IsHitTestVisible = true);
            }
        }


        private void SgzHeadersControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb thumb = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
            if (thumb != null)
            {
                _SourceItem = Helpers.FindAnchestor<SgzExpanderItem>(thumb);
                _DragStartPoint = e.GetPosition(this);

                Items.ForEach(x => ((SgzExpanderItem)x).IsHitTestVisible = false);
            }
        }


        private void SgzExpandersControl_PreviewMouseMove(object sender, MouseEventArgs e)
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


        private void SgzHeadersControl_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (_WentOutside)
            {
                _WentOutside = false;

                SgzExpanderItem item = GetClosestContainerAtPoint<SgzExpanderItem>(e.GetPosition(this));
                if (item != null)
                {
                    int index = Items.IndexOf(item);
                    if (index == Items.Count - 1)
                        index = (e.GetPosition(item).Y >= item.ActualHeight / 2) ? Items.IndexOf(item) + 1 : Items.IndexOf(item);

                    Items.Insert(index, _DropIndicator = new SgzDropIndicator());
                }

                e.Handled = true;
            }
        }


        private void SgzExpandersControl_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Set the drop indicator relative to the item under the mouse when dragging
            SgzExpanderItem item = GetContainerAtPoint<SgzExpanderItem>(e.GetPosition(this));
            if (item != null)
            {
                Items.Remove(_DropIndicator ?? (_DropIndicator = new SgzDropIndicator()));

                int index = (e.GetPosition(item).Y >= item.ActualHeight / 2) ? Items.IndexOf(item) + 1 : Items.IndexOf(item);
                Items.Insert(index, _DropIndicator);
            }
            e.Handled = true;
        }


        private void SgzHeadersControl_PreviewDragLeave(object sender, DragEventArgs e)
        {
            Items.Remove(_DropIndicator);
            _DropIndicator = null;
            _WentOutside = true;
            e.Handled = true;
        }


        private void SgzExpandersControl_PreviewDrop(object sender, DragEventArgs e)
        {
            if (_SourceItem != null && _DropIndicator != null)
            {
                Items.Remove(_SourceItem);
                Items.Insert(Items.IndexOf(_DropIndicator), _SourceItem);
                Items.Remove(_DropIndicator);

                _SourceItem = null;
                _DropIndicator = null;
                Items.ForEach(x => ((SgzExpanderItem)x).IsHitTestVisible = true);
            }
            e.Handled = true;
        }

    }
}
