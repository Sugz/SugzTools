using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;

namespace SugzTools.Behaviors
{
    public class Spacing
    {

        /// <summary>
        /// Attached DependencyProperty for Vertical
        /// </summary>
        public static readonly DependencyProperty VerticalProperty = DependencyProperty.RegisterAttached(
            "Vertical",
            typeof(int),
            typeof(Spacing),
            new PropertyMetadata(0, (d, e) => ((Panel)d).Loaded += SetSpacingVertical)
        );
        public static int GetVertical(DependencyObject obj)
        {
            return (int)obj.GetValue(VerticalProperty);
        }
        public static void SetVertical(DependencyObject obj, int value)
        {
            obj.SetValue(VerticalProperty, value);
        }
        private static void SetSpacingVertical(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            SetChildrenMargin(panel, new Thickness(0, 0, 0, GetVertical(panel)), true);
            panel.Loaded -= SetSpacingVertical;
        }



        /// <summary>
        /// Attached DependencyProperty for Horizontal
        /// </summary>
        public static readonly DependencyProperty HorizontalProperty = DependencyProperty.RegisterAttached(
            "Horizontal",
            typeof(int),
            typeof(Spacing),
            new PropertyMetadata(0, (d, e) => ((Panel)d).Loaded += SetSpacingHorizontal)
        );
        public static int GetHorizontal(DependencyObject obj)
        {
            return (int)obj.GetValue(HorizontalProperty);
        }
        public static void SetHorizontal(DependencyObject obj, int value)
        {
            obj.SetValue(HorizontalProperty, value);
        }
        private static void SetSpacingHorizontal(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            SetChildrenMargin(panel, new Thickness(0, 0, GetHorizontal(panel), 0), true);
            panel.Loaded -= SetSpacingHorizontal;
        }



        /// <summary>
        /// Attached DependencyProperty for All
        /// </summary>
        public static readonly DependencyProperty AllProperty = DependencyProperty.RegisterAttached(
            "All",
            typeof(Thickness),
            typeof(Spacing),
            new PropertyMetadata(new Thickness(0), (d, e) => ((Panel)d).Loaded += SetSpacingAll)
        );
        public static Thickness GetAll(DependencyObject obj)
        {
            return (Thickness)obj.GetValue(AllProperty);
        }
        public static void SetAll(DependencyObject obj, Thickness value)
        {
            obj.SetValue(AllProperty, value);
        }
        private static void SetSpacingAll(object sender, RoutedEventArgs e)
        {
            Panel panel = sender as Panel;
            SetChildrenMargin(panel, GetAll(panel), GetLeaveLastItem(panel));
            panel.Loaded -= SetSpacingAll;
        }


        /// <summary>
        /// Attached DependencyProperty for LeaveLastItem
        /// </summary>
        public static readonly DependencyProperty LeaveLastItemProperty = DependencyProperty.RegisterAttached(
            "LeaveLastItem",
            typeof(bool),
            typeof(Spacing),
            new PropertyMetadata(false)
        );
        public static bool GetLeaveLastItem(DependencyObject obj)
        {
            return (bool)obj.GetValue(LeaveLastItemProperty);
        }
        public static void SetLeaveLastItem(DependencyObject obj, bool value)
        {
            obj.SetValue(LeaveLastItemProperty, value);
        }





        private static void SetChildrenMargin(Panel panel, Thickness thickness, bool leaveLastChildren)
        {
            // Go over the children and set margin for them:
            int count = leaveLastChildren ? panel.Children.Count - 1 : panel.Children.Count;
            for (int i = 0; i < count; i++)
            {
                FrameworkElement child = panel.Children[i] as FrameworkElement;
                if (child == null)
                    continue;

                child.Margin = new Thickness
                (
                    child.Margin.Left + thickness.Left,
                    child.Margin.Top + thickness.Top,
                    child.Margin.Right + thickness.Right,
                    child.Margin.Bottom + thickness.Bottom
                );
            }
        }




        /// <summary>
        /// Add the spacing to children existing margin
        /// </summary>
        /// <param name="panel"></param>
        /// <param name="spacingType"></param>
        //private static void SetChildrenMargin(Panel panel, SpacingType spacingType)
        //{
        //    Thickness thickness = spacingType == SpacingType.Vertical ? new Thickness(0, 0, 0, GetVertical(panel)) : new Thickness(0, 0, GetHorizontal(panel), 0);

        //    // Go over the children and set margin for them:
        //    for (int i = 0; i < panel.Children.Count - 1; i++)
        //    {
        //        FrameworkElement child = panel.Children[i] as FrameworkElement;
        //        if (child == null)
        //            continue;

        //        child.Margin = new Thickness
        //        (
        //            child.Margin.Left + thickness.Left,
        //            child.Margin.Top + thickness.Top,
        //            child.Margin.Right + thickness.Right,
        //            child.Margin.Bottom + thickness.Bottom
        //        );
        //    }
        //}

    }
}
