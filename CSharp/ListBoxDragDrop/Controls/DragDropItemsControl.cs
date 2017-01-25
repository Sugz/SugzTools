using SugzTools.Controls;
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
using System.Windows.Interactivity;

namespace ListBoxDragDrop
{
    public class ItemsControlDragDropBehavior : Behavior<ItemsControl>
    {

        #region Fields


        private FrameworkElement _SourceItem;
        private Point _DragStartPoint;


        #endregion Fields



        #region Properties


        public bool HasThumb { get; set; } = false; 


        #endregion Properties



        #region Constructor


        protected override void OnAttached()
        {
            base.OnAttached();

            AssociatedObject.PreviewMouseDown += ItemsControl_PreviewMouseDown;
            AssociatedObject.PreviewMouseMove += ItemsControl_PreviewMouseMove;
        }


        #endregion Constructor



        #region Event Handlers


        private void ItemsControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            FrameworkElement item = Helpers.FindAnchestor<FrameworkElement>((DependencyObject)e.OriginalSource);
            if (item != null)
            {
                if (HasThumb)
                {
                    item = Helpers.FindAnchestor<Thumb>((DependencyObject)e.OriginalSource);
                    if (item is Thumb && item.Name == "PART_Drag")
                        _SourceItem = Helpers.FindAnchestor<SgzExpanderItem>(item);
                }
                    
                else
                    _SourceItem = item;

                _DragStartPoint = e.GetPosition(AssociatedObject);
            }

        }


        private void ItemsControl_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            if (_SourceItem != null)
            {
                Vector delta = _DragStartPoint - e.GetPosition(AssociatedObject);

                if (e.LeftButton == MouseButtonState.Pressed &&
                    (Math.Abs(delta.X) > SystemParameters.MinimumHorizontalDragDistance || Math.Abs(delta.Y) > SystemParameters.MinimumVerticalDragDistance))
                {
                    DragDrop.DoDragDrop(_SourceItem, _SourceItem.DataContext, DragDropEffects.Copy);
                }
            }
        } 


        #endregion Event Handlers


    }


}
