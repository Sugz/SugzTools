using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;

namespace SugzTools.Controls
{
    public class SgzCanvas : Canvas
    {
        public void Add(UIElement obj)
        {
            Children.Add(obj);
        }


        public void Add(UIElement[] objs)
        {
            foreach (UIElement obj in objs)
                Children.Add(obj);
        }

    }


    public class SgzDockPanel : DockPanel
    {
        public void Add(UIElement obj)
        {
            Children.Add(obj);
        }


        public void Add(UIElement[] objs)
        {
            foreach (UIElement obj in objs)
                Children.Add(obj);
        }

    }


    public class SgzUniformGrid : UniformGrid
    {
        public void Add(UIElement obj)
        {
            Children.Add(obj);
        }


        public void Add(UIElement[] objs)
        {
            foreach (UIElement obj in objs)
                Children.Add(obj);
        }

    }


    public class SgzStackPanel : StackPanel
    {
        public void Add(UIElement obj)
        {
            Children.Add(obj);
        }


        public void Add(UIElement[] objs)
        {
            foreach (UIElement obj in objs)
                Children.Add(obj);
        }

    }


    public class SgzWrapPanel : WrapPanel
    {
        public void Add(UIElement obj)
        {
            Children.Add(obj);
        }


        public void Add(UIElement[] objs)
        {
            foreach (UIElement obj in objs)
                Children.Add(obj);
        }

    }
}
