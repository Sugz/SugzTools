using SugzTools.Src;
using SugzTools.Extensions;
using System;
using System.Collections.Generic;
using System.ComponentModel;
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



        #region Properties


        /// <summary>
        /// Get or set the spacing between the expanders
        /// </summary>
        [Description("Get or set the spacing between the expanders"), Category("Layout")]
        public int Spacing { get; set; } = 2; 


        #endregion Properties



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
            PreviewDragOver += SgzExpandersControl_PreviewDragOver;
            PreviewDragLeave += SgzExpandersControl_PreviewDragLeave;
            PreviewDrop += SgzExpandersControl_PreviewDrop;
        }


        


        #endregion Constructors



        #region Overrides


        public override void OnApplyTemplate()
        {
            base.OnApplyTemplate();

            if (GetTemplateChild("PART_ScrollViewer") is ScrollViewer scrollViewer)
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
        /// Set the Expanders bottom margin
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


            foreach (SgzExpander item in Items)
                item.Margin = new Thickness(0, 0, 0, Spacing);
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
        /// Set the drop indicator depending on the mouse position over an expander.
        /// When draging went outside, get the closest Expander from the cursor.
        /// Scroll if the cursor is near the vertical extremities.
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SgzExpandersControl_PreviewDragOver(object sender, DragEventArgs e)
        {
            // Set the drop indicator relative to the item under the mouse when dragging
            SgzExpander item = Helpers.GetContainerAtPoint<SgzExpander>(this, e.GetPosition(this));
            if (item == null)
                item = Helpers.GetClosestContainerFromPoint<SgzExpander>(this, e.GetPosition(this));

            if (item != null)
            {
                // Avoid nested expanders
                while (item.Parent != this)
                    item = Helpers.FindAnchestor<SgzExpander>(item.Parent);

                Items.Remove(_DropIndicator ?? (_DropIndicator = new SgzDropIndicator(Spacing)));

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
                int index = Items.IndexOf(_DropIndicator);
                SgzExpandersControl dropControl = (SgzExpandersControl)dropItem.Parent;
                dropControl.Items.Remove(dropItem);
                Items.Insert(index, dropItem);
                Items.Remove(_DropIndicator);

                Reset(this);
                if (dropControl != this)
                    Reset(dropControl);
            }
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
        public SgzDropIndicator(int spacing)
        {
            Margin = new Thickness(0, 0, 0, spacing);
        }
    }
}
