using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Input;

namespace HeadersControl
{
    public class SgzExpandersListBox : ListBox
    {

        #region Fields

        private ScrollViewer _ScrollViewer;
        private SgzDropIndicator _DropIndicator;
        private SgzExpanderItem _SourceItem;
        private Point _DragStartPoint;
        bool _WentOutside = false;


        #endregion Fields



        #region Constructors


        static SgzExpandersListBox()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpandersListBox), new FrameworkPropertyMetadata(typeof(SgzExpandersListBox)));
        }
        public SgzExpandersListBox()
        {
            MouseEnter += SgzExpandersListBox_MouseEnter;
            PreviewMouseDown += SgzExpandersListBox_PreviewMouseDown;
            PreviewMouseMove += SgzExpandersListBox_PreviewMouseMove;
            PreviewDragEnter += SgzExpandersListBox_PreviewDragEnter;
            PreviewDragOver += SgzExpandersListBox_PreviewDragOver;
            PreviewDragLeave += SgzExpandersListBox_PreviewDragLeave;
            PreviewDrop += SgzExpandersListBox_PreviewDrop;
        }


        #endregion Constructors



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();
            _ScrollViewer = GetTemplateChild("PART_ScrollViewer") as ScrollViewer;
        }


        #endregion Overrides



        #region Event Handlers


        /// <summary>
        /// Check if the drop has been canceled by droping outside and enabled HitTestVisible for all Expanders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_MouseEnter(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null && e.LeftButton == MouseButtonState.Released)
            {
                _SourceItem = null;
                Items.ForEach(x => ((SgzExpanderItem)x).IsHitTestVisible = true);
            }
        }


        /// <summary>
        /// Initiate the dragging process if the mouse if over the drag Thumb
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb thumb = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
            if (thumb != null && thumb.Name == "PART_DragDrop")
            {
                _SourceItem = Helpers.FindAnchestor<SgzExpanderItem>(thumb);
                _DragStartPoint = e.GetPosition(this);
            }
        }


        /// <summary>
        /// Start to drag and disabled HitTestVisible for all Expanders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Vector delta = _DragStartPoint - e.GetPosition(this);
                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(delta.X) > SystemParameters.MinimumHorizontalDragDistance || Math.Abs(delta.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    Items.ForEach(x => ((SgzExpanderItem)x).IsHitTestVisible = false);
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem, DragDropEffects.Copy);
                }
            }
        }


        /// <summary>
        /// When draging went outside, get the closest Expander from the cursor and set the drop indicator 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (_WentOutside)
            {
                _WentOutside = false;

                SgzExpanderItem item = Helpers.GetClosestContainerFromPoint<SgzExpanderItem>(this, e.GetPosition(this));
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


        /// <summary>
        /// Set the drop indicator depending on the mouse position over an expander
        /// Scroll if the cursor is near the vertical extremities
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Set the drop indicator relative to the item under the mouse when dragging
            SgzExpanderItem item = Helpers.GetContainerAtPoint<SgzExpanderItem>(this, e.GetPosition(this));
            if (item != null)
            {
                Items.Remove(_DropIndicator ?? (_DropIndicator = new SgzDropIndicator()));

                int index = (e.GetPosition(item).Y >= item.ActualHeight / 2) ? Items.IndexOf(item) + 1 : Items.IndexOf(item);
                Items.Insert(index, _DropIndicator);
            }
            e.Handled = true;


            // Handle scrolling
            if (_ScrollViewer != null)
            {
                double mouseYPos = e.GetPosition(this).Y;
                double tolerance = 20;

                if (mouseYPos < tolerance)
                {
                    _ScrollViewer.LineUp();
                }
                if (mouseYPos > ActualHeight - tolerance)
                {
                    _ScrollViewer.LineDown();
                }
            }

        }


        /// <summary>
        /// Remove the drop indicator when dragging outside
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewDragLeave(object sender, DragEventArgs e)
        {
            Items.Remove(_DropIndicator);
            _DropIndicator = null;
            _WentOutside = true;
            e.Handled = true;
        }


        /// <summary>
        /// Replace the drop indicator by the dragged Expander and enabled HitTestVisible for all Expanders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersListBox_PreviewDrop(object sender, DragEventArgs e)
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



        #endregion Event Handlers


    }

}
