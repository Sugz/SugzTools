using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;

namespace SugzTools.Src
{
    public static class Helpers
    {
        /// <summary>
        /// Switch the focus to the top parent of send control
        /// </summary>
        /// <param name="ctrl">The control to remove the focus on</param>
        internal static void RemoveFocus(FrameworkElement ctrl)
        {
            // Move to a parent that can take focus
            FrameworkElement parent = (FrameworkElement)ctrl.Parent;
            while (parent != null && parent is IInputElement
                              && !((IInputElement)parent).Focusable)
            {
                parent = (FrameworkElement)parent.Parent;
            }

            DependencyObject scope = FocusManager.GetFocusScope(ctrl); //can pass in ctrl here because FrameworkElement inherits from DependencyObject
            FocusManager.SetFocusedElement(scope, parent as IInputElement);
        }


        /// <summary>
        /// Return the current screen bounds
        /// </summary>
        /// <param name="visual"></param>
        /// <returns>The current screen bounds</returns>
        internal static Rectangle CurrentScreenBounds(Visual visual)
        {
            HwndSource source = (HwndSource)PresentationSource.FromVisual(visual);
            Screen currentScreen = Screen.FromHandle(source.Handle);
            return currentScreen.Bounds;
        }


        /// <summary>
        /// Set the mouse position
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        internal static void SetMousePosition(int x, int y)
        {
            System.Windows.Forms.Cursor.Position = new System.Drawing.Point(x, y);
        }


        /// <summary>
        /// Return wheter the mouse is over a control
        /// </summary>
        /// <param name="s"></param>
        /// <param name="e"></param>
        /// <returns>True if the mouse is over a control, false otherwise</returns>
        internal static bool IsMouseOver(FrameworkElement s, System.Windows.Input.MouseEventArgs e)
        {
            Rect bounds = new Rect(0, 0, s.ActualWidth, s.ActualHeight);
            if (bounds.Contains(e.GetPosition(s)))
                return true;
            return false;
        }


        /// <summary>
        /// Cast any IEnumerable to Object[]
        /// </summary>
        /// <param name="_items"></param>
        /// <returns></returns>
        internal static object[] ToArray(IEnumerable _items)
        {
            return _items.Cast<object>().ToArray();
        }


        /// <summary>
        /// Get a list of all logical children of a DependencyObject
        /// </summary>
        /// <param name="parent"></param>
        /// <param name="logicalCollection"></param>
        internal static void GetLogicalChildren(DependencyObject parent, List<DependencyObject> logicalCollection)
        {
            IEnumerable children = LogicalTreeHelper.GetChildren(parent);
            foreach (object child in children)
            {
                if (child is DependencyObject)
                {
                    DependencyObject depChild = child as DependencyObject;

                    if (child is DependencyObject)
                        logicalCollection.Add(child as DependencyObject);

                    GetLogicalChildren(depChild, logicalCollection);
                }
            }
        }


        /// <summary>
        /// Get the first VisualParent of a given type
        /// </summary>
        /// <typeparam name="T">The type of the control to return</typeparam>
        /// <param name="child"></param>
        /// <returns></returns>
        internal static T FindAnchestor<T>(DependencyObject child) where T : DependencyObject
        {
            do
            {
                if (child is T)
                    return (T)child;

                child = VisualTreeHelper.GetParent(child);
            }
            while (child != null);

            return null;
        }


        /// <summary>
        /// Get the container of a given type under the cursor in a ItemsControl
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="p"></param>
        /// <returns></returns>
        internal static T GetContainerAtPoint<T>(ItemsControl itemsControl, System.Windows.Point p)
            where T : DependencyObject
        {
            DependencyObject obj = VisualTreeHelper.HitTest(itemsControl, p).VisualHit;

            while (VisualTreeHelper.GetParent(obj) != null && !(obj is T))
                obj = VisualTreeHelper.GetParent(obj);

            // Will return null if not found
            return obj as T;
        }


        /// <summary>
        /// Get the container of a given type closest from the cursor in a ItemsControl
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="p"></param>
        /// <returns></returns>
        internal static T GetClosestContainerFromPoint<T>(ItemsControl itemsControl, System.Windows.Point p)
            where T : UIElement
        {
            T nearest = null;
            double lastDistance = short.MaxValue;
            foreach (UIElement item in itemsControl.Items)
            {
                System.Windows.Point itemPos = item.TranslatePoint(new System.Windows.Point(0, 0), itemsControl);
                double distance = Math.Abs(p.Y - itemPos.Y);
                if (distance > lastDistance && lastDistance != short.MaxValue)
                    return nearest;
                else if (item is T)
                {
                    lastDistance = distance;
                    nearest = item as T;
                }
            }

            return nearest;
        }


        /// <summary>
        /// Create a random string of 16 chars as title case
        /// </summary>
        /// <returns></returns>
        internal static string NameGenerator()
        {
            Random random = new Random();
            string chars = "abcdefghijklmnopqrstuvwxyz";
            string str = new string(Enumerable.Repeat(chars, 16).Select(s => s[random.Next(s.Length)]).ToArray());
            return CultureInfo.CurrentCulture.TextInfo.ToTitleCase(str);
        }


    }
}