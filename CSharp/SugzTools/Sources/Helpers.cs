using System;
using System.Collections;
using System.Collections.Generic;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Forms;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Markup.Primitives;
using System.Windows.Media;
using BF = System.Reflection.BindingFlags;

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
        public static void GetLogicalChildren(DependencyObject parent, List<DependencyObject> logicalCollection)
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


        public static IEnumerable<T> GetVisualChildren<T>(DependencyObject depObj) where T : DependencyObject
        {
            if (depObj != null)
            {
                for (int i = 0; i < VisualTreeHelper.GetChildrenCount(depObj); i++)
                {
                    DependencyObject child = VisualTreeHelper.GetChild(depObj, i);
                    if (child != null && child is T)
                    {
                        yield return (T)child;
                    }

                    foreach (T childOfChild in GetVisualChildren<T>(child))
                    {
                        yield return childOfChild;
                    }
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


        /// <summary>
        /// Get a list of Dependency Properties of an object
        /// </summary>
        /// <param name="control"></param>
        /// <returns></returns>
        internal static IEnumerable<DependencyProperty> GetDependencyProperties(object control)
        {
            List<DependencyProperty> properties = new List<DependencyProperty>();
            MarkupObject markupObject = MarkupWriter.GetMarkupObjectFor(control);
            if (markupObject != null)
            {
                foreach (MarkupProperty mp in markupObject.Properties)
                {
                    if (mp.DependencyProperty != null)
                        properties.Add(mp.DependencyProperty);
                }
            }

            return properties;
        }

        /// <summary>
        /// Get a list of Attached Dependency Properties of an object
        /// </summary>
        /// <param name="control"></param>
        /// <returns></returns>
        internal static IEnumerable<DependencyProperty> GetAttachedProperties(object control)
        {
            List<DependencyProperty> attachedProperties = new List<DependencyProperty>();
            MarkupObject markupObject = MarkupWriter.GetMarkupObjectFor(control);
            if (markupObject != null)
            {
                foreach (MarkupProperty mp in markupObject.Properties)
                {
                    if (mp.IsAttached)
                        attachedProperties.Add(mp.DependencyProperty);
                }
            }

            return attachedProperties;
        }


        public static IEnumerable<BindingBase> GetBindingObjects(object control)
        {
            List<BindingBase> bindings = new List<BindingBase>();
            List<DependencyProperty> dpList = new List<DependencyProperty>();
            dpList.AddRange(GetDependencyProperties(control));
            dpList.AddRange(GetAttachedProperties(control));

            foreach (DependencyProperty dp in dpList)
            {
                BindingBase b = BindingOperations.GetBindingBase(control as DependencyObject, dp);
                if (b != null)
                    bindings.Add(b);
            }

            return bindings;
        }



        /// <summary>
        /// Get a list of RoutedEventHandlers
        /// Credit: Douglas : https://stackoverflow.com/a/12618521/3971575
        /// </summary>
        /// <param name="element"></param>
        /// <param name="routedEvent"></param>
        /// <returns></returns>
        internal static RoutedEventHandlerInfo[] GetRoutedEventHandlers(UIElement element, RoutedEvent routedEvent)
        {
            // Get the EventHandlersStore instance which holds event handlers for the specified element.
            // The EventHandlersStore class is declared as internal.
            PropertyInfo eventHandlersStoreProperty = typeof(UIElement).GetProperty("EventHandlersStore", BF.Instance | BF.NonPublic);
            object eventHandlersStore = eventHandlersStoreProperty.GetValue(element, null);

            // If no event handlers are subscribed, eventHandlersStore will be null.
            // Credit: https://stackoverflow.com/a/16392387/1149773
            if (eventHandlersStore == null)
                return null;

            // Invoke the GetRoutedEventHandlers method on the EventHandlersStore instance 
            // for getting an array of the subscribed event handlers.
            MethodInfo getRoutedEventHandlers = eventHandlersStore.GetType().GetMethod("GetRoutedEventHandlers", BF.Instance | BF.Public | BF.NonPublic);

            return (RoutedEventHandlerInfo[])getRoutedEventHandlers.Invoke(eventHandlersStore, new object[] { routedEvent });
        }


    }
}