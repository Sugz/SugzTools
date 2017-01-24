using SugzTools.Controls;
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;

namespace ListBoxDragDrop
{
    public class SgzExpanderList : ItemsControl
    {

        private SgzExpanderItem _SourceItem;
        private Point _DragStartPoint;

        #region Constructor


        public SgzExpanderList()
        {
            PreviewMouseDown += ItemsControl_PreviewMouseDown;
            PreviewMouseMove += ItemsControl_PreviewMouseMove;
        }

        private void ItemsControl_PreviewMouseMove(object sender, MouseEventArgs e)
        {
            throw new NotImplementedException();
        }

        private void ItemsControl_PreviewMouseDown(object sender, MouseButtonEventArgs e)
        {
            SgzIcon item = Helpers.FindAnchestor<SgzIcon>((DependencyObject)e.OriginalSource);
            if (item != null && item.Name == "PART_Drag")
            {
                _SourceItem = Helpers.FindAnchestor<SgzExpanderItem>(item);
                _DragStartPoint = e.GetPosition(this);
            }
                
        }


        #endregion Constructor

    }


}
