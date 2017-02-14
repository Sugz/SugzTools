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

        #endregion Fields



        #region Constructors


        static SgzExpandersControl()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzExpandersControl), new FrameworkPropertyMetadata(typeof(SgzExpandersControl)));
        }
        public SgzExpandersControl()
        {
            Loaded += SgzExpandersControl_Loaded;
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



        #region Privates


        private void Reset(SgzExpandersControl control)
        {
            control._SourceItem = null;
            control._DropIndicator = null;
            control.Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = true);
        }


        #endregion Privates



        #region Event Handlers


        /// <summary>
        /// Remove any children that isn't a SgzExpander
        /// If there is only one expander, hide the header
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_Loaded(object sender, RoutedEventArgs e)
        {
            List<object> itemToRemove = new List<object>();
            foreach (object item in Items)
            {
                if (!(item is SgzExpander))
                    itemToRemove.Add(item);
            }

            if (itemToRemove.Count != 0)
            {
                itemToRemove.ForEach(x => Items.Remove(x));
                throw new SystemException("SgzExpandersControl can only accept SgzExpander as children");
            }
        }


        /// <summary>
        /// Check if the drop has been canceled by droping outside and enabled HitTestVisible for all Expanders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_MouseEnter(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null && e.LeftButton == MouseButtonState.Released)
            {
                _SourceItem = null;
                Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = true);
            }
        }


        /// <summary>
        /// Initiate the dragging process if the mouse if over the drag Thumb
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            Thumb thumb = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
            if (thumb != null && thumb.Name == "PART_DragDrop")
            {
                SgzExpander item = Helpers.FindAnchestor<SgzExpander>(thumb);
                if (item != null)
                {
                    _SourceItem = item;
                    _DragStartPoint = e.GetPosition(this);
                }
            }
        }


        /// <summary>
        /// Start to drag and disabled HitTestVisible for all Expanders
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
                    Items.ForEach(x => ((SgzExpander)x).IsHitTestVisible = false);
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem, DragDropEffects.Copy);
                }
            }
        }


        /// <summary>
        /// When draging went outside, get the closest Expander from the cursor and set the drop indicator 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragEnter(object sender, DragEventArgs e)
        {
            int index = 0;
            SgzExpander item = Helpers.GetClosestContainerFromPoint<SgzExpander>(this, e.GetPosition(this));
            if (item != null)
            {
                index = Items.IndexOf(item);
                if (index == Items.Count - 1)
                    index = (e.GetPosition(item).Y >= item.ActualHeight / 2) ? Items.IndexOf(item) + 1 : Items.IndexOf(item);
            }

            Items.Insert(index, _DropIndicator = new SgzDropIndicator());
            e.Handled = true;
        }


        /// <summary>
        /// Set the drop indicator depending on the mouse position over an expander
        /// Scroll if the cursor is near the vertical extremities
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Set the drop indicator relative to the item under the mouse when dragging
            SgzExpander item = Helpers.GetContainerAtPoint<SgzExpander>(this, e.GetPosition(this));
            if (item != null)
            {
                // Avoid nested expanders
                while (item.Parent != this)
                    item = Helpers.FindAnchestor<SgzExpander>(item.Parent);

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
                    _ScrollViewer.LineUp();
                if (mouseYPos > ActualHeight - tolerance)
                    _ScrollViewer.LineDown();
            }

            e.Handled = true;
        }


        /// <summary>
        /// Remove the drop indicator when dragging outside
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragLeave(object sender, DragEventArgs e)
        {
            Items.Remove(_DropIndicator);
            _DropIndicator = null;
            e.Handled = true;
        }


        /// <summary>
        /// Replace the drop indicator by the dragged Expander and enabled HitTestVisible for all Expanders
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDrop(object sender, DragEventArgs e)
        {
            // faire des test pour savoir si on est tjs sur le même parent....
            SgzExpander dropItem = e.Data.GetData(typeof(SgzExpander)) as SgzExpander;
            if (dropItem != null && _DropIndicator != null)
            {
                SgzExpandersControl dropControl = (SgzExpandersControl)dropItem.Parent;
                dropControl.Items.Remove(dropItem);
                Items.Insert(Items.IndexOf(_DropIndicator), dropItem);
                Items.Remove(_DropIndicator);

                Reset(this);
                if (dropControl != this)
                    Reset(dropControl);
            }

            //e.Handled = true;
        }


        #endregion Event Handlers



        #region Public


        public void Add(SgzExpander expander)
        {
            Items.Add(expander);
        }

        public void Add(SgzExpander[] expanders)
        {
            foreach (SgzExpander expander in expanders)
                Items.Add(expander);
        } 


        #endregion Public

    }


    public class SgzDropIndicator : Control
    {
        static SgzDropIndicator()
        {
            DefaultStyleKeyProperty.OverrideMetadata(typeof(SgzDropIndicator), new FrameworkPropertyMetadata(typeof(SgzDropIndicator)));
        }
    }
}
