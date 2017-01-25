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

namespace ListBoxDragDrop
{
    public class SgzExpandersControl : ItemsControl
    {

        #region Fields


        private SgzExpanderItem _SourceItem;
        private Point _DragStartPoint;


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
            PreviewDragLeave += SgzExpandersControl_PreviewDragLeave;
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
                    Console.WriteLine(_SourceItem.Header);
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





        private void SgzExpandersControl_PreviewDragLeave(object sender, DragEventArgs e)
        {
            Console.WriteLine("Right now");
            e.Handled = true;
        }


        #endregion Event Handlers

    }
}
