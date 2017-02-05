
using SugzTools.Src;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace StyleApp
{
    public static class PanelInnerMarginAttachedBehavior
    {
        public static Thickness GetInnerMargin(DependencyObject obj)
        {
            return (Thickness)obj.GetValue(InnerMargin);
        }
        public static void SetInnerMargin(DependencyObject obj, Thickness value)
        {
            obj.SetValue(InnerMargin, value);
        }
        public static readonly DependencyProperty InnerMargin = DependencyProperty.RegisterAttached(
            "InnerMargin", 
            typeof(Thickness), 
            typeof(PanelInnerMarginAttachedBehavior), 
            new PropertyMetadata(new Thickness(0), (d, e) => ((Panel)d).Loaded += SetChildrenMargin)
        );


        private static void SetChildrenMargin(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            foreach (FrameworkElement child in panel.Children)
            {
                if (child == null)
                    continue;

                child.Margin = new Thickness(child.Margin.Left + GetInnerMargin(panel).Left,
                    child.Margin.Top + GetInnerMargin(panel).Top,
                    child.Margin.Right + GetInnerMargin(panel).Right,
                    child.Margin.Bottom + GetInnerMargin(panel).Bottom
                );
            }

            panel.Loaded -= SetChildrenMargin;
        }
    }
}
