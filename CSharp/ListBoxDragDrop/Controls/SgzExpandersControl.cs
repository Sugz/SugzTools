using SugzTools.Controls;
using SugzTools.Src;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;

namespace ListBoxDragDrop
{
    public class SgzExpandersControl : ItemsControl
    {

        #region Fields


        private SgzExpanderItem _SourceItem;
        private SgzExpanderItem _TargetItem;
        private Point _DragStartPoint;
        private bool _OnTop;


        #endregion Fields



        #region Constructor


        public SgzExpandersControl()
        {
            SetEventHandlers();
        }


        #endregion Constructor



        #region Private


        private void SetEventHandlers()
        {
            PreviewMouseDown += SgzExpandersControl_PreviewMouseDown;
            PreviewMouseMove += SgzExpandersControl_PreviewMouseMove;
            PreviewDragEnter += SgzExpandersControl_PreviewDragEnter;
            PreviewDragOver += SgzExpandersControl_PreviewDragOver;
            PreviewDragLeave += SgzExpandersControl_PreviewDragLeave;
            PreviewDrop += SgzExpandersControl_PreviewDrop;
        }



        private void Reset()
        {
            _SourceItem = null;
            _TargetItem = null;
        }



        #endregion Private



        #region Event Handlers


        private void SgzExpandersControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb item = Helpers.FindAnchestor<Thumb>(((DependencyObject)e.OriginalSource));
            if (item != null && item.Name == "PART_Drag")
            {
                SgzExpanderItem sgzExpanderItem = Helpers.FindAnchestor<SgzExpanderItem>(item);
                if (sgzExpanderItem != null)
                {
                    _SourceItem = sgzExpanderItem;
                    _DragStartPoint = e.GetPosition(this);
                }
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



        private void SgzExpandersControl_PreviewDragEnter(object sender, DragEventArgs e)
        {
            UIElement item = Helpers.FindAnchestor<SgzExpanderItem>((DependencyObject)e.OriginalSource);
            if (item != null)
            {
                if (_TargetItem != null)
                {
                    _TargetItem.TopIndicator = false;
                    _TargetItem.BottomIndicator = false;
                }

                _TargetItem = item as SgzExpanderItem;
            }
            else if (_TargetItem != null)
            {
                // show adorner when mouse enter back on the list
            }
            e.Handled = true;
        }



        private void SgzExpandersControl_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Define if you drop before or after targetItem
            if (_TargetItem != null)
            {
                _OnTop = e.GetPosition(_TargetItem).Y < (_TargetItem.ActualHeight / 2) ? true : false;
                _TargetItem.TopIndicator = _OnTop;
                _TargetItem.BottomIndicator = !_OnTop;
            }
                

            e.Handled = true;
        }




        private void SgzExpandersControl_PreviewDragLeave(object sender, DragEventArgs e)
        {
            if (_TargetItem != null)
            {
                _TargetItem.TopIndicator = false;
                _TargetItem.BottomIndicator = false;
            }
            e.Handled = true;
        }



        private void SgzExpandersControl_PreviewDrop(object sender, DragEventArgs e)
        {
            if (_SourceItem != null && _TargetItem != null)
            {
                IList items = (ItemsSource != null) ? (IList)ItemsSource : Items;
                if (items != null)
                {
                    items.Remove(_SourceItem);

                    int targetIndex = _OnTop ? items.IndexOf(_TargetItem) : items.IndexOf(_TargetItem) + 1;
                    items.Insert(targetIndex >= 0 ? targetIndex : 0, _SourceItem);
                }

                Reset();
            }
        }


        #endregion Event Handlers






    }
}
