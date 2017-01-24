using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Controls;
using System.Windows;

namespace DragAndDropLib
{
    public abstract class BaseDecorator : Decorator
    {
        protected UIElement DecoratedUIElement
        {
            get
            {
                if (this.Child is BaseDecorator)
                {
                    return ((BaseDecorator)this.Child).DecoratedUIElement;
                }
                return this.Child;
            }
        } 
    }
}
