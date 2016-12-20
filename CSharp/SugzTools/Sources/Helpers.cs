using System;
using System.Collections;
using System.Drawing;
using System.Linq;
using System.Runtime.InteropServices;
using System.Windows;
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
        public static object[] ToArray(IEnumerable _items)
        {
            object[] items = _items.Cast<object>().ToArray();
            return items;
        }

    }
}
