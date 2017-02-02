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

namespace SugzTools.Controls
{
    public class SgzExpandersControl : ItemsControl
    {

        #region Fields

        private ScrollViewer _ScrollViewer;
        private SgzDropIndicator _DropIndicator;
        private SgzExpander _SourceItem;
        private Point _DragStartPoint;
        bool _WentOutside = false;


        #endregion Fields



        #region Constructors


        static SgzExpandersControl()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpandersControl), new FrameworkPropertyMetadata(typeof(SgzExpandersControl)));
        }
        public SgzExpandersControl()
        {
            MouseEnter += SgzExpandersControl_MouseEnter;
            PreviewMouseDown += SgzExpandersControl_PreviewMouseDown;
            PreviewMouseMove += SgzExpandersControl_PreviewMouseMove;
            PreviewDragEnter += SgzExpandersControl_PreviewDragEnter;
            PreviewDragOver += SgzExpandersControl_PreviewDragOver;
            PreviewDragLeave += SgzExpandersControl_PreviewDragLeave;
            PreviewDrop += SgzExpandersControl_PreviewDrop;
        }


        #endregion Constructors



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            ScrollViewer scrollViewer = GetTemplateChild("PART_ScrollViewer") as ScrollViewer;
            if (scrollViewer != null)
                _ScrollViewer = scrollViewer;
        }


        #endregion Overrides



        #region Event Handlers


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_MouseEnter(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null && e.LeftButton == MouseButtonState.Released)
            {
                _SourceItem = null;
                //Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = true);
                Items.ForEach(x => ((UIElement)x).IsHitTestVisible = true);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb thumb = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
            if (thumb != null && thumb.Name == "PART_DragDrop")
            {
                _SourceItem = Helpers.FindAnchestor<SgzExpander>(thumb);
                _DragStartPoint = e.GetPosition(this);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Vector delta = _DragStartPoint - e.GetPosition(this);
                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(delta.X) > SystemParameters.MinimumHorizontalDragDistance || Math.Abs(delta.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    //Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = false);
                    Items.ForEach(x => ((UIElement)x).IsHitTestVisible = false);
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem, DragDropEffects.Copy);
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragEnter(object sender, DragEventArgs e)
        {
            if (_WentOutside)
            {
                _WentOutside = false;

                SgzExpander item = Helpers.GetClosestContainerFromPoint<SgzExpander>(this, e.GetPosition(this));
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
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Set the drop indicator relative to the item under the mouse when dragging
            SgzExpander item = Helpers.GetContainerAtPoint<SgzExpander>(this, e.GetPosition(this));
            if (item != null)
            {
                Items.Remove(_DropIndicator ?? (_DropIndicator = new SgzDropIndicator()));

                int index = (e.GetPosition(item).Y >= item.ActualHeight / 2) ? Items.IndexOf(item) + 1 : Items.IndexOf(item);
                Items.Insert(index, _DropIndicator);
            }

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

            e.Handled = true;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragLeave(object sender, DragEventArgs e)
        {
            Items.Remove(_DropIndicator);
            _DropIndicator = null;
            _WentOutside = true;
            e.Handled = true;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDrop(object sender, DragEventArgs e)
        {
            if (_SourceItem != null && _DropIndicator != null)
            {
                Items.Remove(_SourceItem);
                Items.Insert(Items.IndexOf(_DropIndicator), _SourceItem);
                Items.Remove(_DropIndicator);

                _SourceItem = null;
                _DropIndicator = null;
                //Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = true);
                Items.ForEach(x => ((UIElement)x).IsHitTestVisible = true);
            }
            e.Handled = true;
        } 


        #endregion Event Handlers


    }



    public class SgzDropIndicator : Control
    {
        static SgzDropIndicator()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDropIndicator), new FrameworkPropertyMetadata(typeof(SgzDropIndicator)));
        }
    }
}
