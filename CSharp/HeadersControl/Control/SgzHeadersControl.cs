using SugzTools.Src;
using System;
using System.Collections.Generic;
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
        private SgzHeaderItem _SourceItem;
        private Point _DragStartPoint;
        bool _WentOutside = false;

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


        private T GetContainerAtPoint<T>(Point p)  
            where T : DependencyObject
        {
            HitTestResult result = VisualTreeHelper.HitTest(this, p);
            DependencyObject obj = result.VisualHit;

            while (VisualTreeHelper.GetParent(obj) != null && !(obj is T))
            {
                obj = VisualTreeHelper.GetParent(obj);
            }

            // Will return null if not found
            return obj as T;
        }


        private SgzHeaderItem GetClosestItem(int mouseYPos)
        {
            SgzHeaderItem nearest = null;
            int lastNearest = int.MaxValue;
            foreach (SgzHeaderItem item in Items)
            {
                int itemYPos = (int)item.TranslatePoint(new Point(0, 0), this).Y;
                int distance = Math.Abs(mouseYPos - itemYPos);
                if (distance < lastNearest)
                {
                    lastNearest = distance;
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
                Items.ForEach(x => ((SgzHeaderItem)x).IsHitTestVisible = true);
            }
        }


        private void SgzHeadersControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb thumb = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
            //Thumb thumb = GetContainerAtPoint<Thumb>(e.GetPosition(this));
            if (thumb != null)
            {
                _SourceItem = Helpers.FindAnchestor<SgzHeaderItem>(thumb);
                _DragStartPoint = e.GetPosition(this);

                Items.ForEach(x => ((SgzHeaderItem)x).IsHitTestVisible = false);
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
                int mouseYPos = (int)e.GetPosition(this).Y;
                SgzHeaderItem item = GetClosestItem(mouseYPos);
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
            SgzHeaderItem item = GetContainerAtPoint<SgzHeaderItem>(e.GetPosition(this));
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
                Items.ForEach(x => ((SgzHeaderItem)x).IsHitTestVisible = true);
            }
            e.Handled = true;
        }

    }
}
