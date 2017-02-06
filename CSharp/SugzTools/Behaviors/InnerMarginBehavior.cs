using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Behaviors
{
    public static class InnerMargin
    {

        public static readonly DependencyProperty InnerMarginProperty = DependencyProperty.RegisterAttached(
            "Value", 
            typeof(Thickness), 
            typeof(InnerMargin), 
            new PropertyMetadata(new Thickness(0), (d, e) => ((Panel)d).Loaded += SetChildrenMargin)
        );
        public static void SetValue(UIElement element, Thickness value)
        {
            element.SetValue(InnerMarginProperty, value);
        }
        public static Thickness GetValue(UIElement element)
        {
            return (Thickness)element.GetValue(InnerMarginProperty);
        }


        private static void SetChildrenMargin(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            foreach (FrameworkElement child in panel.Children)
            {
                if (child == null)
                    continue;

                child.Margin = new Thickness
                (
                    child.Margin.Left + GetValue(panel).Left,
                    child.Margin.Top + GetValue(panel).Top,
                    child.Margin.Right + GetValue(panel).Right,
                    child.Margin.Bottom + GetValue(panel).Bottom
                );
            }

            panel.Loaded -= SetChildrenMargin;
        }

    }

}
